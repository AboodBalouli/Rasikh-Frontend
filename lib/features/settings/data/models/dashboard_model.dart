class DashboardStats {
  final int totalProducts;
  final int activeProducts;
  final double weeklySales;
  final double monthlySales;
  final double yearlySales;
  final double averageRating;
  final int pendingOrders;
  final int newCustomers;

  DashboardStats({
    required this.totalProducts,
    required this.activeProducts,
    required this.weeklySales,
    required this.monthlySales,
    required this.yearlySales,
    required this.averageRating,
    required this.pendingOrders,
    required this.newCustomers,
  });
}
