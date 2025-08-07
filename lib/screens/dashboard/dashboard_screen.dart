import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text('dashboard'.tr(), style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Dashboard Cards Section
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children:  [
                DashboardCard(
                  title: 'todays_bills'.tr(),
                  value: '0',
                  icon: Icons.receipt_long,
                  backgroundColor: Color(0xFFe1f5fe),
                  iconColor: Color(0xFF039be5),
                ),
                DashboardCard(
                  title: 'todays_revenue'.tr(),
                  value: '₹0',
                  icon: Icons.attach_money,
                  backgroundColor: Color(0xFFe8f5e9),
                  iconColor: Color(0xFF43a047),
                ),
                DashboardCard(
                  title: 'monthly_profit'.tr(),
                  value: '₹0',
                  icon: Icons.trending_up,
                  backgroundColor: Color(0xFFf3e5f5),
                  iconColor: Color(0xFF8e24aa),
                ),
                DashboardCard(
                  title: 'low_stock'.tr(),
                  value: '0',
                  icon: Icons.warning,
                  backgroundColor: Color(0xFFFFF3E0),
                  iconColor: Color(0xFFF57C00),
                ),
              ],
            ),
            const SizedBox(height: 32),
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
                    Text('low_stock_products'.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    const Divider(thickness: 1.2),
                    DataTable(
                      columnSpacing: 20,
                      headingTextStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      columns: const [
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('Price')),
                        DataColumn(label: Text('Qty')),
                        DataColumn(label: Text('Category')),
                      ],
                      rows: const [], // Fill with your data
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
