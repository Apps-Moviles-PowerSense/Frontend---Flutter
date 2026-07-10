import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/devices/domain/device.dart';
import 'package:power_sense/features/schedules/domain/schedule.dart';
import 'schedule_state.dart';
import 'schedule_view_model.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  void initState() {
    super.initState();
    context.read<ScheduleViewModel>().loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Programación', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<ScheduleViewModel, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) return const Center(child: CircularProgressIndicator(color: Colors.green));
          if (state is ScheduleFailure) return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          if (state is ScheduleSuccess) {
            return Stack(
              children: [
                RefreshIndicator(
                  color: Colors.green,
                  onRefresh: () async => context.read<ScheduleViewModel>().loadSchedules(),
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Text('Automatiza el encendido y apagado de tus dispositivos', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => context.read<ScheduleViewModel>().openCreateDialog(),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Nueva Programación', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784), minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ["Dispositivos", "Habitaciones", "Areas Comunes", "Reglas"].map((tab) => _buildFilterChip(tab, state.selectedTab == tab, context)).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        onChanged: (val) => context.read<ScheduleViewModel>().onSearchQueryChange(val),
                        decoration: InputDecoration(
                          hintText: "Buscar dispositivo...",
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Programaciones Activas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 12),
                      if (state.filteredSchedules.isEmpty)
                        const Center(child: Padding(padding: EdgeInsets.all(20), child: Text("No hay programaciones activas", style: TextStyle(color: Colors.grey)))),
                      ...state.filteredSchedules.map((schedule) => _buildScheduleCard(schedule, context)),
                      const SizedBox(height: 24),
                      const Text('Estadísticas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
                        child: Column(
                          children: [
                            _statRow("Dispositivos programados", state.stats.scheduledDevices, Colors.black87),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                            _statRow("Horarios activos", state.stats.activeSchedules.toString(), Colors.black87),
                            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1)),
                            _statRow("Ahorro estimado", "${state.stats.estimatedSavings}%", Colors.green),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (state.isCreateDialogOpen)
                  _CreateDialog(
                    devices: state.availableDevices,
                    onDismiss: () => context.read<ScheduleViewModel>().closeCreateDialog(),
                    onConfirm: (id, name, room, start, end, days) => context.read<ScheduleViewModel>().createSchedule(id, name, room, start, end, days),
                  )
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
        selected: isSelected,
        onSelected: (_) => context.read<ScheduleViewModel>().onTabSelected(label),
        selectedColor: const Color(0xFF81C784),
        backgroundColor: Colors.white,
        side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _statRow(String label, String value, Color color) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16))]);
  }

  Widget _buildScheduleCard(Schedule schedule, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.bolt, color: Colors.green)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(schedule.deviceName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(schedule.roomName, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ]),
                ),
                Switch(value: schedule.enabled, onChanged: (v) => context.read<ScheduleViewModel>().toggleSchedule(schedule), activeColor: Colors.green),
              ],
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _buildTimeInfo('Encendido', schedule.startTime, Colors.green),
              _buildTimeInfo('Apagado', schedule.endTime, Colors.red),
            ])
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, Color dotColor) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)), const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
      Padding(padding: const EdgeInsets.only(left: 16.0, top: 4), child: Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
    ]);
  }
}

class _CreateDialog extends StatefulWidget {
  final List<Device> devices;
  final VoidCallback onDismiss;
  final Function(String, String, String, String, String, List<String>) onConfirm;
  const _CreateDialog({required this.devices, required this.onDismiss, required this.onConfirm});
  @override
  State<_CreateDialog> createState() => _CreateDialogState();
}

class _CreateDialogState extends State<_CreateDialog> {
  Device? selectedDevice;
  TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);
  List<String> selectedDays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY"];
  final daysMap = {"MONDAY": "L", "TUESDAY": "M", "WEDNESDAY": "M", "THURSDAY": "J", "FRIDAY": "V", "SATURDAY": "S", "SUNDAY": "D"};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54, alignment: Alignment.center,
      child: Material(color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("Nueva Programación", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            DropdownButtonFormField<Device>(
              decoration: InputDecoration(labelText: "Dispositivo", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              value: selectedDevice, 
              items: widget.devices.map((d) {
                // extraemos el nombre de forma segura por si la entidad es distinta
                String name = "Dispositivo";
                try { name = (d as dynamic).name; } catch (_) {}
                return DropdownMenuItem(value: d, child: Text(name));
              }).toList(),
              onChanged: (val) => setState(() => selectedDevice = val),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: InkWell(onTap: () async { final time = await showTimePicker(context: context, initialTime: startTime); if (time != null) setState(() => startTime = time); },
                  child: InputDecorator(decoration: InputDecoration(labelText: "Encendido", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), child: Text("${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}")))),
              const SizedBox(width: 16),
              Expanded(child: InkWell(onTap: () async { final time = await showTimePicker(context: context, initialTime: endTime); if (time != null) setState(() => endTime = time); },
                  child: InputDecorator(decoration: InputDecoration(labelText: "Apagado", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), child: Text("${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}")))),
            ]),
            const SizedBox(height: 16),
            const Text("Días", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: daysMap.entries.map((e) {
              final isSel = selectedDays.contains(e.key);
              return InkWell(
                onTap: () => setState(() { if (isSel) selectedDays.remove(e.key); else selectedDays.add(e.key); }),
                child: Container(width: 32, height: 32, alignment: Alignment.center, decoration: BoxDecoration(color: isSel ? Colors.green : Colors.grey.withOpacity(0.1), shape: BoxShape.circle),
                  child: Text(e.value, style: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 12))),
              );
            }).toList()),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: widget.onDismiss, child: const Text("Cancelar", style: TextStyle(color: Colors.grey))),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: selectedDevice == null ? null : () {
                  final startStr = "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
                  final endStr = "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
                  
                  dynamic d = selectedDevice!;
                  String dId = "";
                  String dName = "";
                  String dRoom = "";
                  try { dId = d.id; } catch(_) {}
                  try { dName = d.name; } catch(_) {}
                  try { dRoom = d.roomName; } catch(_) {}
                  
                  widget.onConfirm(dId, dName, dRoom, startStr, endStr, selectedDays);
                },
                child: const Text("Crear", style: TextStyle(color: Colors.white)),
              )
            ])
          ]),
        ),
      ),
    );
  }
}
