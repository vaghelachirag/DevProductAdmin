import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopkeeper_admin/base/extensions/utils/app_colors.dart';
import 'package:shopkeeper_admin/gen/assets.gen.dart';

import '../base/extensions/utils/app_constant.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
         _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'dashboard'.tr(),
                  route: AppConstant.dashboard
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.add_box_outlined,
                  title: 'add_product'.tr(),
                  route: AppConstant.addProductPage
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.search,
                  title: 'search_product'.tr(),
                  route: AppConstant.searchProductPage
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.receipt_long,
                  title: 'generate_bill'.tr(),
                  route: AppConstant.billingListPage
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.appLogo.path), // Add your own image
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text(
        'Dev',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: AppColors.blackColor),
      ),
      accountEmail: Text(
        'jackcomputer.com',
        style: GoogleFonts.poppins(fontSize: 12,color: AppColors.blackColor),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String title, required String route}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
      onTap: () {
        Navigator.pop(context);
        Future.delayed(Duration(milliseconds: 100), () {
          context.push(route);
        });
      },
    );
  }
}
