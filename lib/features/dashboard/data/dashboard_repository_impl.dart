import '../domain/dashboard_kpis.dart';
import '../domain/dashboard_repository.dart';
import 'dashboard_service.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardService service;
  DashboardRepositoryImpl({required this.service});

  @override
  Future<DashboardKPIs> getKPIs() async {
    final dto = await service.getKPIs();
    return DashboardKPIs(
      totalDevices: dto.totalDevices,
      activeDevices: dto.activeDevices,
      totalConsumption: dto.totalConsumptionKWh,
      totalCost: dto.totalCostUSD,
      efficiency: dto.efficiencyPct,
      monthlySavings: dto.monthlySavings,
      estimatedCost: dto.estimatedMonthlyCost,
      consumptionVariation: dto.comparison['consumptionPct'] ?? 0,
      costVariation: dto.comparison['costPct'] ?? 0,
      efficiencyVariation: dto.comparison['efficiencyPct'] ?? 0,
    );
  }
}
