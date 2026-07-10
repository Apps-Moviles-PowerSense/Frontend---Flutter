import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import 'dashboard_view_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardViewModel>().loadKPIs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<DashboardViewModel, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) return const Center(child: CircularProgressIndicator(color: Colors.green));
          if (state is DashboardFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => context.read<DashboardViewModel>().loadKPIs(),
                    child: const Text('Reintentar', style: TextStyle(color: Colors.green)),
                  )
                ],
              ),
            );
          }
          if (state is DashboardSuccess) {
            final data = state.kpis;
            return RefreshIndicator(
              color: Colors.green,
              onRefresh: () => context.read<DashboardViewModel>().loadKPIs(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainCard(data),
                    const SizedBox(height: 24),
                    const Text('Métricas Principales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildGridCard('Consumo Total', '${data.totalConsumption} kWh', Icons.flash_on, Colors.orange, data.consumptionVariation, invertColor: true),
                        _buildGridCard('Costo Estimado', 'S/ ${data.totalCost.toStringAsFixed(2)}', Icons.attach_money, Colors.green, data.costVariation, invertColor: true),
                        _buildGridCard('Dispositivos', '${data.activeDevices}/${data.totalDevices}', Icons.devices, Colors.blue, 0),
                        _buildGridCard('Eficiencia', '${data.efficiency}%', Icons.eco, Colors.teal, data.efficiencyVariation),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildMainCard(dynamic data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ahorro Potencial Mensual', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text('S/ ${data.monthlySavings}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.trending_down, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('${data.costVariation}% vs mes anterior', style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildGridCard(String title, String value, IconData icon, Color iconColor, int variation, {bool invertColor = false}) {
    bool isPositive = variation >= 0;
    // Lógica visual: para costos/consumo, subir es malo (rojo). Para eficiencia, subir es bueno (verde).
    Color varColor = Colors.grey;
    if (variation != 0) {
      if (invertColor) {
        varColor = isPositive ? Colors.red : Colors.green;
      } else {
        varColor = isPositive ? Colors.green : Colors.red;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 24)),
              if (variation != 0)
                Row(
                  children: [
                    Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: varColor, size: 14),
                    Text('${variation.abs()}%', style: TextStyle(color: varColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }
}
