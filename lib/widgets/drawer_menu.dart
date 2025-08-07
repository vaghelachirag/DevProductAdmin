import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopkeeper_admin/base/extensions/buildcontext_ext.dart';
import 'package:shopkeeper_admin/screens/product/addproduct.dart';
import 'package:shopkeeper_admin/screens/splash/splash_screen.dart';

import '../base/extensions/utils/app_constant.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

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
                  title: 'Dashboard',
                  route: AppConstant.dashboard
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.add_box_outlined,
                  title: 'Add Product',
                  route: '/addProductPage'
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.search,
                  title: 'Search Products',
                  route: '/searchProductPage'
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.receipt_long,
                  title: 'Generate Bill',
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
          image: AssetImage('assets/images/drawer_bg.jpg'), // Add your own image
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/images/profile.png'), // Add your profile image
      ),
      accountName: Text(
        'FarmEasy Admin',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(
        'admin@farmeasy.com',
        style: GoogleFonts.poppins(fontSize: 12),
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
