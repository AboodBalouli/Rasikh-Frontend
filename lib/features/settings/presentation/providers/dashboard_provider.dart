import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/settings/data/models/dashboard_model.dart';

final dashboardProvider = Provider<DashboardStats>((ref) {
  //   بيانات محاكية
  return DashboardStats(
    totalProducts: 150,
    activeProducts: 132,
    weeklySales: 1850.5,
    monthlySales: 7200.0,
    yearlySales: 85000.0,
    averageRating: 4.9,
    pendingOrders: 8,
    newCustomers: 52,
  );
});
