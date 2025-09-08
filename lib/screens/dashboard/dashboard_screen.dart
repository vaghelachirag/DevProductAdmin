import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopkeeper_admin/screens/dashboard/provider/dashboard_provider.dart';
import 'package:shopkeeper_admin/widgets/drawer_menu.dart';
import '../../widgets/dashboard_card.dart';

class DashboardScreen extends ConsumerWidget {
  static const route = "/DashboardScreen";

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: AppBar(
        title: Text(
          'dashboard'.tr(),
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) => context.setLocale(locale),
            itemBuilder: (_) => [
              const PopupMenuItem(value: Locale('en'), child: Text('English')),
              const PopupMenuItem(value: Locale('hi'), child: Text('हिंदी')),
              const PopupMenuItem(value: Locale('gu'), child: Text('ગુજરાતી')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Consumer(
          builder: (context, ref, _) {
            final dashboardAsync = ref.watch(dashboardStatsProvider);

            return dashboardAsync.when(
              data: (data) {
                final todayBills = data['billCount']?.toString() ?? "0";
                final todayRevenue = "₹${data['totalRevenue'] ?? 0}";
                final monthlyRevenue = "₹${data['monthlyRevenue'] ?? 0}";
                final lowStockCount = data['lowStockCount']?.toString() ?? "0";
                final lowStockList =
                List<Map<String, dynamic>>.from(data['lowStockProducts'] ?? []);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Dashboard Cards
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        DashboardCard(
                          title: 'todays_bills'.tr(),
                          value: todayBills,
                          icon: Icons.receipt_long,
                          backgroundColor: const Color(0xFFe1f5fe),
                          iconColor: const Color(0xFF039be5),
                        ),
                        DashboardCard(
                          title: 'todays_revenue'.tr(),
                          value: todayRevenue,
                          icon: Icons.attach_money,
                          backgroundColor: const Color(0xFFe8f5e9),
                          iconColor: const Color(0xFF43a047),
                        ),
                        DashboardCard(
                          title: 'monthly_profit'.tr(),
                          value: monthlyRevenue,
                          icon: Icons.trending_up,
                          backgroundColor: const Color(0xFFf3e5f5),
                          iconColor: const Color(0xFF8e24aa),
                        ),
                        DashboardCard(
                          title: 'low_stock'.tr(),
                          value: lowStockCount,
                          icon: Icons.warning,
                          backgroundColor: const Color(0xFFFFF3E0),
                          iconColor: const Color(0xFFF57C00),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    /// Low Stock Products Table
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'low_stock_products'.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(thickness: 1.2),
                            lowStockList.isEmpty
                                ? Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "✅ ${'no_low_stock'.tr()}",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                                : DataTable(
                              columnSpacing: 20,
                              headingTextStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              columns: [
                                DataColumn(label: Text('product'.tr())),
                                DataColumn(label: Text('price'.tr())),
                                DataColumn(label: Text('category'.tr())),
                                DataColumn(label: Text('qty'.tr())),
                              ],
                              rows: lowStockList.map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(item["name"].toString())),
                                    DataCell(Text("₹${item["price"] ?? 0}")),
                                    DataCell(Text(item["category"].toString())),
                                    DataCell(
                                      Text(
                                        item["qty"].toString(),
                                        style: TextStyle(
                                          color: (item["qty"] == 0)
                                              ? Colors.red
                                              : Colors.black,
                                          fontWeight: (item["qty"] == 0)
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text("Error: $e")),
            );
          },
        ),
      ),
    );
  }
}
