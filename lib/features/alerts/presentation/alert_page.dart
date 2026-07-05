import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/alerts/domain/alert.dart';
import 'package:power_sense/features/alerts/presentation/alert_state.dart';
import 'package:power_sense/features/alerts/presentation/alert_view_model.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  static const List<String> alertTypes = [
    "HIGH_CONSUMPTION",
    "LOW_EFFICIENCY",
    "DEVICE_OFFLINE",
    "SCHEDULE_CONFLICT",
    "THRESHOLD_EXCEEDED",
    "CUSTOM"
  ];

  String formatType(String type) {
    final clean = type.replaceAll('_', ' ').toLowerCase();
    return clean.replaceFirst(clean[0], clean[0].toUpperCase());
  }

  void showFilterDialog(BuildContext context, AlertSuccess state) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Filtrar por tipo de alerta'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: alertTypes.map((type) {
                final isSelected = state.selectedType == type;
                return Container(
                  color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
                  child: RadioListTile<String>(
                    title: Text(formatType(type)),
                    value: type,
                    groupValue: state.selectedType,
                    activeColor: const Color(0xFF81C784),
                    onChanged: (value) {
                      context.read<AlertViewModel>().onTypeFilterSelected(value);
                      Navigator.pop(dialogContext);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<AlertViewModel>().onTypeFilterSelected(null);
                Navigator.pop(dialogContext);
              },
              child: const Text('Limpiar filtros', style: TextStyle(color: Colors.grey)),
            )
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
        child: BlocConsumer<AlertViewModel, AlertState>(
          listener: (context, state) {
            if (state is AlertFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AlertInitial || state is AlertLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AlertSuccess) {
              final errorCount = state.allAlerts.where((a) => (a.severity.toUpperCase() == 'CRITICAL' || a.severity.toUpperCase() == 'ERROR') && !a.acknowledged).length;
              final warningCount = state.allAlerts.where((a) => a.severity.toUpperCase() == 'WARNING' && !a.acknowledged).length;
              final infoCount = state.allAlerts.where((a) => a.severity.toUpperCase() == 'INFO' && !a.acknowledged).length;
              final completedCount = state.allAlerts.where((a) => a.acknowledged).length;
              final unacknowledgedCount = state.unreadAlerts.length;

              return RefreshIndicator(
                onRefresh: () => context.read<AlertViewModel>().getAlerts(currentFilter: state.selectedType),
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    const Text('Alertas', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
                    const Text('Centro de notificaciones y alertas del sistema', style: TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => showFilterDialog(context, state),
                          icon: const Icon(Icons.filter_list, size: 16, color: Color(0xFF637381)),
                          label: Text(
                            state.selectedType != null ? formatType(state.selectedType!) : 'Filtrar',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF637381)),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 40),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        if (state.selectedType != null) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red, size: 18),
                            onPressed: () => context.read<AlertViewModel>().onTypeFilterSelected(null),
                          ),
                        ]
                      ],
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildSummaryItem('Errores', errorCount, Icons.error, const Color(0xFFF44336)),
                            buildSummaryItem('Advertencias', warningCount, Icons.warning, const Color(0xFFFF9800)),
                            buildSummaryItem('Información', infoCount, Icons.notifications, const Color(0xFF2196F3)),
                            buildSummaryItem('Leídas', completedCount, Icons.check_circle, const Color(0xFF4CAF50)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildAlertFilterChip('Nuevas ($unacknowledgedCount)', true, () {}),
                        TextButton(
                          onPressed: () => context.read<AlertViewModel>().acknowledgeAll(),
                          child: const Text(
                            'Marcar todas como leídas',
                            style: TextStyle(color: Color(0xFF81C784), fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (state.unreadAlerts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(child: Text('Sistema funcionando correctamente', style: TextStyle(color: Colors.grey))),
                      )
                    else
                      ...state.unreadAlerts.map((alert) => buildAlertItem(context, alert)),
                    const SizedBox(height: 20),
                    const Text('Historial (Ya vistas)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF919EAB))),
                    const SizedBox(height: 12),
                    if (state.readAlerts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(child: Text('No hay alertas leídas', style: TextStyle(color: Colors.grey))),
                      )
                    else
                      ...state.readAlerts.map((alert) => buildAlertItem(context, alert)),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 8),
                    const Text('Configuracion de Alertas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
                    const Text('Personaliza que notificaciones deseas recibir', style: TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
                    const SizedBox(height: 8),
                    const SettingsToggleItem(title: 'Consumo excesivo', subtitle: 'Notificar cuando el consumo supere los limites', initialValue: true),
                    const SettingsToggleItem(title: 'Dispositivos desconectados', subtitle: 'Alerta cuando un dispositivo pierda conexion', initialValue: true),
                    const SettingsToggleItem(title: 'Programaciones completadas', subtitle: 'Confirmar cuando se ejecuten programaciones', initialValue: false),
                    const SettingsToggleItem(title: 'Actualizaciones del sistema', subtitle: 'Notificar sobre nuevas versiones disponibles', initialValue: true),
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

  Widget buildSummaryItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF919EAB))),
      ],
    );
  }

  Widget buildAlertFilterChip(String label, bool selected, VoidCallback onClick) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDFE3E8) : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? const Color(0xFF212B36) : const Color(0xFF637381),
          ),
        ),
      ),
    );
  }

  Widget buildAlertItem(BuildContext context, Alert alert) {
    Color getSeverityColor(String severity) {
      switch (severity.toUpperCase()) {
        case 'CRITICAL':
        case 'ERROR': return const Color(0xFFF44336);
        case 'WARNING': return const Color(0xFFFF9800);
        default: return const Color(0xFF2196F3);
      }
    }

    final color = getSeverityColor(alert.severity);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.info, color: alert.acknowledged ? Colors.grey : color),
        title: Text(
          alert.message, 
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: alert.acknowledged ? Colors.grey : const Color(0xFF212B36)
          )
        ),
        subtitle: Text(alert.createdAt.contains('T') ? alert.createdAt.split('T').first : alert.createdAt),
        trailing: alert.acknowledged 
            ? null 
            : IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => context.read<AlertViewModel>().acknowledgeAlert(alert.id),
              ),
      ),
    );
  }
}

class SettingsToggleItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool initialValue;

  const SettingsToggleItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.initialValue,
  });

  @override
  State<SettingsToggleItem> createState() => SettingsToggleItemState();
}

class SettingsToggleItemState extends State<SettingsToggleItem> {
  late bool checked;

  @override
  void initState() {
    super.initState();
    checked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
                Text(widget.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
              ],
            ),
          ),
          Switch(
            value: checked,
            activeColor: const Color(0xFF81C784),
            onChanged: (value) {
              setState(() => checked = value);
            },
          ),
        ],
      ),
    );
  }
}