import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/devices/domain/device.dart';
import 'package:power_sense/features/devices/presentation/device_state.dart';
import 'package:power_sense/features/devices/presentation/device_view_model.dart';
import 'dart:math';

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  static const Map<String, String> categoryTranslations = {
    "LIGHT": "Iluminación",
    "AC": "Aire Acondicionado",
    "TV": "Televisor",
    "REFRIGERATOR": "Refrigerador",
    "COMPUTER": "Computadora",
    "HEATING": "Calefacción",
    "GENERIC_POWER": "Genérico"
  };

  void showCreateDialog(BuildContext context) {
    String name = "";
    String category = "LIGHT";
    String roomName = "";
    String watts = "";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Nuevo Dispositivo', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Nombre del dispositivo'),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(labelText: 'Categoría'),
                      items: categoryTranslations.entries.map((entry) {
                        return DropdownMenuItem(value: entry.key, child: Text(entry.value));
                      }).toList(),
                      onChanged: (value) => setState(() => category = value!),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Habitación (ej: Sala)'),
                      onChanged: (value) => roomName = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Consumo (Watts)'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => watts = value,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784)),
                  onPressed: () {
                    if (name.isNotEmpty && roomName.isNotEmpty && watts.isNotEmpty) {
                      final newDevice = Device(
                        id: '', 
                        name: name,
                        category: category,
                        status: 'INACTIVE',
                        roomId: 'room-${roomName.toLowerCase().replaceAll(' ', '-')}',
                        roomName: roomName,
                        watts: int.tryParse(watts) ?? 0,
                      );
                      context.read<DeviceViewModel>().createDevice(newDevice);
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Agregar', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void showConfigureDialog(BuildContext context, Device device) {
    String roomName = device.roomName;
    String watts = device.watts.toString();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Configurar ${device.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: roomName),
                decoration: const InputDecoration(labelText: 'Habitación'),
                onChanged: (value) => roomName = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: watts),
                decoration: const InputDecoration(labelText: 'Consumo (Watts)'),
                keyboardType: TextInputType.number,
                onChanged: (value) => watts = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784)),
              onPressed: () {
                final updatedDevice = Device(
                  id: device.id,
                  name: device.name,
                  category: device.category,
                  status: device.status,
                  roomId: device.roomId,
                  roomName: roomName,
                  watts: int.tryParse(watts) ?? device.watts,
                );
                context.read<DeviceViewModel>().updateDevice(device.id, updatedDevice);
                Navigator.pop(dialogContext);
              },
              child: const Text('Guardar Cambios', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocConsumer<DeviceViewModel, DeviceState>(
          listener: (context, state) {
            if (state is DeviceFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is DeviceInitial || state is DeviceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DeviceSuccess) {
              final allDevices = state.allDevices;
              final displayedDevices = state.filteredDevices;
              
              final totalCount = allDevices.length;
              final activeCount = allDevices.where((d) => d.status.toUpperCase() == 'ACTIVE').length;
              final inactiveCount = totalCount - activeCount;
              final totalWatts = allDevices.where((d) => d.status.toUpperCase() == 'ACTIVE').fold(0, (sum, d) => sum + d.watts);
              final consumptionText = totalWatts >= 1000 ? '${(totalWatts / 1000.0).toStringAsFixed(1)} kW' : '${totalWatts}W';

              final allRooms = allDevices.map((d) => d.roomName).toSet().toList();
              final allCategories = allDevices.map((d) => d.category).toSet().toList();

              final Map<String, List<Device>> devicesByRoom = {};
              for (var device in allDevices) {
                devicesByRoom.putIfAbsent(device.roomName, () => []).add(device);
              }

              return RefreshIndicator(
                onRefresh: () => context.read<DeviceViewModel>().getDevices(),
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    const Text('Dispositivos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
                    const Text('Gestiona y controla todos los dispositivos conectados', style: TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () => showCreateDialog(context),
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Agregar Dispositivo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7CB342),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: buildSummaryItem('Total Dispositivos', totalCount.toString(), Icons.bolt, const Color(0xFF2196F3))),
                        const SizedBox(width: 12),
                        Expanded(child: buildSummaryItem('Activos', activeCount.toString(), Icons.check, const Color(0xFF4CAF50))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: buildSummaryItem('Inactivos', inactiveCount.toString(), Icons.circle, const Color(0xFFB39DDB))),
                        const SizedBox(width: 12),
                        Expanded(child: buildSummaryItem('Consumo Actual', consumptionText, Icons.bolt, const Color(0xFFFFB300))),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Buscador asilado para mantener estado de texto sin usar StatefulWidget en la página completa
                    DeviceSearchBar(
                      initialValue: state.searchQuery,
                      onChanged: (value) => context.read<DeviceViewModel>().onFiltersChanged(query: value),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
                      ),
                      value: state.selectedRoom,
                      hint: const Text('Todas las habitaciones'),
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('Todas las habitaciones')),
                        ...allRooms.map((room) => DropdownMenuItem(value: room, child: Text(room)))
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          context.read<DeviceViewModel>().onFiltersChanged(clearRoom: true);
                        } else {
                          context.read<DeviceViewModel>().onFiltersChanged(room: value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
                      ),
                      value: state.selectedCategory,
                      hint: const Text('Todos los tipos'),
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('Todos los tipos')),
                        ...allCategories.map((cat) => DropdownMenuItem(value: cat, child: Text(categoryTranslations[cat] ?? cat)))
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          context.read<DeviceViewModel>().onFiltersChanged(clearCategory: true);
                        } else {
                          context.read<DeviceViewModel>().onFiltersChanged(category: value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () => context.read<DeviceViewModel>().setAllDevicesStatus(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE57373),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Apagar Todo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<DeviceViewModel>().setAllDevicesStatus(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF81C784),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Encender Todo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 24),

                    ...displayedDevices.map((device) => buildDeviceItem(context, device)),

                    const SizedBox(height: 16),
                    const Text('Control por Habitación', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
                    const SizedBox(height: 16),

                    ...devicesByRoom.entries.map((entry) {
                      final roomName = entry.key;
                      final roomDevices = entry.value;
                      final roomId = roomDevices.first.roomId;
                      final activeInRoom = roomDevices.where((d) => d.status.toUpperCase() == 'ACTIVE').length;
                      final wattsInRoom = roomDevices.where((d) => d.status.toUpperCase() == 'ACTIVE').fold(0, (sum, d) => sum + d.watts);
                      
                      return buildRoomCard(context, roomName, roomId, activeInRoom, wattsInRoom, allDevices);
                    }),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF212B36))),
            Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF919EAB))),
          ],
        ),
      ),
    );
  }

  Widget buildDeviceItem(BuildContext context, Device device) {
    final isActive = device.status.toUpperCase() == 'ACTIVE';
    IconData icon;
    Color iconColor;

    switch (device.category.toUpperCase()) {
      case 'LIGHT': icon = Icons.lightbulb; iconColor = const Color(0xFFFFB300); break;
      case 'AC': icon = Icons.air; iconColor = const Color(0xFF42A5F5); break;
      case 'TV': icon = Icons.tv; iconColor = const Color(0xFFB39DDB); break;
      case 'REFRIGERATOR': icon = Icons.kitchen; iconColor = const Color(0xFF66BB6A); break;
      case 'COMPUTER': icon = Icons.computer; iconColor = const Color(0xFFEF5350); break;
      default: icon = Icons.bolt; iconColor = const Color(0xFFEF5350);
    }

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: iconColor, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212B36))),
                      Text(device.roomName, style: const TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
                    ],
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: (_) => context.read<DeviceViewModel>().toggleDeviceStatus(device),
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF81C784),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFDFE3E8),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Consumo', style: TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
                Text('${device.watts}W', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: isActive ? min(device.watts / 2000.0, 1.0) : 0,
              backgroundColor: const Color(0xFFE8F5E9),
              color: const Color(0xFF81C784),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF4F6F8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => showConfigureDialog(context, device),
                child: const Text('Configurar', style: TextStyle(color: Color(0xFF637381))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRoomCard(BuildContext context, String roomName, String roomId, int activeCount, int totalWatts, List<Device> allDevices) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFFF4F6F8), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.home, color: Color(0xFF637381)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(roomName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212B36))),
                    Text('$activeCount dispositivos activos', style: const TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEBEE),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => context.read<DeviceViewModel>().setRoomDevicesStatus(roomId, false, allDevices),
                    child: const Text('Apagar todo', style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE8F5E9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => context.read<DeviceViewModel>().setRoomDevicesStatus(roomId, true, allDevices),
                    child: const Text('Encender todo', style: TextStyle(color: Color(0xFF81C784), fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Consumo total', style: TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
                Text('${(totalWatts / 1000.0).toStringAsFixed(2)}kW', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: min(totalWatts / 5000.0, 1.0),
              backgroundColor: const Color(0xFFE8F5E9),
              color: const Color(0xFF81C784),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceSearchBar extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const DeviceSearchBar({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<DeviceSearchBar> createState() => _DeviceSearchBarState();
}

class _DeviceSearchBarState extends State<DeviceSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(DeviceSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: 'Buscar dispositivos...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFDFE3E8))),
      ),
    );
  }
}