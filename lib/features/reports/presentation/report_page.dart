import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:power_sense/features/reports/domain/report.dart';
import 'package:power_sense/features/reports/presentation/report_state.dart';
import 'package:power_sense/features/reports/presentation/report_view_model.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedReportType = 'Diario';
  DateTime? startDate;
  DateTime? endDate;
  final List<String> reportTypes = ['Diario', 'Semanal', 'Mensual'];

  @override
  void initState() {
    super.initState();
    context.read<ReportViewModel>().loadAllReports();
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF81C784)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF81C784)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  void _showPreviewDialog(BuildContext context, ReportHistory report) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Previsualización de Reporte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Se generará un documento con la siguiente información:', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 16),
              _buildPreviewRow('Periodo:', report.period),
              _buildPreviewRow('Departamento:', report.department),
              _buildPreviewRow('Consumo Total:', '${report.consumption.toStringAsFixed(0)} kWh'),
              _buildPreviewRow('Costo Total:', 'S/${report.cost.toStringAsFixed(0)}'),
              _buildPreviewRow('Variación:', '${report.variation}%'),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.picture_as_pdf, color: Colors.grey, size: 48),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF81C784)),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          Text(value, style: const TextStyle(color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: BlocBuilder<ReportViewModel, ReportState>(
          builder: (context, state) {
            if (state is ReportLoading || state is ReportInitial) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF7CB342)));
            }

            if (state is ReportFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7CB342)),
                      onPressed: () => context.read<ReportViewModel>().loadAllReports(),
                      child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              );
            }

            if (state is ReportSuccess) {
              return RefreshIndicator(
                onRefresh: () async => context.read<ReportViewModel>().loadAllReports(),
                color: const Color(0xFF7CB342),
                child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    const Text('Reportes de Consumo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF454F5B))),
                    const Text('Analiza y compara el consumo energético con reportes detallados', style: TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
                    const SizedBox(height: 24),
                    
                    _buildFiltersCard(),
                    const SizedBox(height: 16),

                    _buildKPICard(
                      title: 'Consumo Total',
                      value: '${state.kpis.totalConsumption.toStringAsFixed(0)} kWh',
                      variation: state.kpis.consumptionVariation,
                      icon: Icons.bolt,
                      color: const Color(0xFF2196F3),
                    ),
                    const SizedBox(height: 16),
                    _buildKPICard(
                      title: 'Costo Total',
                      value: 'S/${state.kpis.totalCost.toStringAsFixed(0)}',
                      variation: state.kpis.costVariation,
                      icon: Icons.payments,
                      color: const Color(0xFFFFB300),
                    ),
                    const SizedBox(height: 16),
                    _buildKPICard(
                      title: 'Eficiencia',
                      value: '${state.kpis.efficiency}%',
                      variation: state.kpis.efficiencyVariation,
                      icon: Icons.trending_up,
                      color: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(height: 24),

                    _buildMonthlyComparisonChart(state.monthlyComparison),
                    const SizedBox(height: 16),
                    _buildDepartmentComparisonChart(state.departmentsMetrics),
                    const SizedBox(height: 24),

                    _buildHistorySection(context, state.history),
                    const SizedBox(height: 20),
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

  Widget _buildFiltersCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField('Tipo de Reporte', selectedReportType),
            const SizedBox(height: 12),
            _buildDateField('Fecha Inicio', formatDate(startDate), () => _selectStartDate(context)),
            const SizedBox(height: 12),
            _buildDateField('Fecha Fin', formatDate(endDate), () => _selectEndDate(context)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7CB342),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: const Text('Aplicar Filtros', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDFE3E8)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF919EAB)),
              items: reportTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => selectedReportType = newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDFE3E8)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value.isEmpty ? 'Seleccionar fecha' : value, style: TextStyle(color: value.isEmpty ? Colors.grey : Colors.black87)),
                const Icon(Icons.calendar_today, color: Color(0xFF919EAB), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard({required String title, required String value, required int variation, required IconData icon, required Color color}) {
    final variationColor = variation <= 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
    final prefix = variation > 0 ? '+' : '';

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(title, style: const TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF212B36))),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: variationColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        '$prefix$variation% vs. mes anterior',
                        style: TextStyle(color: variationColor, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyComparisonChart(List<MonthlyComparison> data) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    double maxVal = 1.0;
    for (var item in data) {
      if (item.value1 > maxVal) maxVal = item.value1;
      if (item.value2 > maxVal) maxVal = item.value2;
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Consumo Mensual', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212B36))),
                      Text('Comparativa anual', style: TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildLegendItem('2024', const Color(0xFF81C784)),
                    _buildLegendItem('2023', const Color(0xFF64B5F6)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  final h1 = (160 * (item.value1 / maxVal));
                  final h2 = (160 * (item.value2 / maxVal));
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(width: 14, height: h1, decoration: const BoxDecoration(color: Color(0xFF81C784), borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                            const SizedBox(width: 4),
                            Container(width: 14, height: h2, decoration: const BoxDecoration(color: Color(0xFF64B5F6), borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item.month, style: const TextStyle(fontSize: 12, color: Color(0xFF919EAB))),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentComparisonChart(List<DepartmentMetric> data) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    double maxVal = 1.0;
    for (var item in data) {
      if (item.current > maxVal) maxVal = item.current;
      if (item.previous > maxVal) maxVal = item.previous;
    }

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Comparativa por Departamentos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF212B36))),
                      Text('Consumo mensual', style: TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildLegendItem('Enero 2025', const Color(0xFF81C784)),
                    _buildLegendItem('Diciembre 2024', const Color(0xFFB39DDB)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  final h1 = (160 * (item.current / maxVal));
                  final h2 = (160 * (item.previous / maxVal));
                  return Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(width: 14, height: h1, decoration: const BoxDecoration(color: Color(0xFF81C784), borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                            const SizedBox(width: 4),
                            Container(width: 14, height: h2, decoration: const BoxDecoration(color: Color(0xFFB39DDB), borderRadius: BorderRadius.vertical(top: Radius.circular(4)))),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item.department, style: const TextStyle(fontSize: 11, color: Color(0xFF919EAB))),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF919EAB))),
        ],
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context, List<ReportHistory> history) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Historial de Reportes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF212B36))),
            const Text('Reportes generados previamente', style: TextStyle(fontSize: 14, color: Color(0xFF919EAB))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: const BorderSide(color: Color(0xFFDFE3E8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exportando todos a PDF...')));
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 16, color: Color(0xFF637381)),
                    label: const Text('Exportar PDF', style: TextStyle(fontSize: 11, color: Color(0xFF637381))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF81C784),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exportando todos a CSV...')));
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 16, color: Colors.white),
                    label: const Text('Exportar CSV', style: TextStyle(fontSize: 11, color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      SizedBox(width: 100, child: Text('Periodo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF919EAB)))),
                      SizedBox(width: 120, child: Text('Departamento', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF919EAB)))),
                      SizedBox(width: 80, child: Text('Consumo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF919EAB)))),
                      SizedBox(width: 70, child: Text('Costo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF919EAB)))),
                      SizedBox(width: 60, child: Text('Var.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF919EAB)))),
                      SizedBox(width: 70, child: Text('Acc.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF919EAB)))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(height: 1, width: 500, color: const Color(0xFFF4F6F8)),
                  ...history.map((item) {
                    final varColor = item.variation <= 0 ? const Color(0xFF4CAF50) : const Color(0xFFF44336);
                    final prefix = item.variation > 0 ? '+' : '';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              SizedBox(width: 100, child: Text(item.period, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF212B36)))),
                              SizedBox(width: 120, child: Text(item.department, style: const TextStyle(fontSize: 13, color: Color(0xFF637381)))),
                              SizedBox(width: 80, child: Text('${item.consumption.toStringAsFixed(0)} kWh', style: const TextStyle(fontSize: 13, color: Color(0xFF637381)))),
                              SizedBox(width: 70, child: Text('S/${item.cost.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, color: Color(0xFF637381)))),
                              SizedBox(
                                width: 60,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(color: varColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                  child: Text(
                                    '$prefix${item.variation}%',
                                    style: TextStyle(fontSize: 10, color: varColor, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () => _showPreviewDialog(context, item),
                                      child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF637381))),
                                    ),
                                    const SizedBox(width: 4),
                                    InkWell(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Descargando reporte de ${item.department} en PDF...')));
                                      },
                                      child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.file_download_outlined, size: 18, color: Color(0xFF637381))),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(height: 1, width: 500, color: const Color(0xFFF4F6F8)),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}