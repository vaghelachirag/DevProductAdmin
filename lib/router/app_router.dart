// lib/router/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopkeeper_admin/base/extensions/utils/app_constant.dart';
import 'package:shopkeeper_admin/screens/product/addproduct.dart';
import 'package:shopkeeper_admin/screens/product/productListing/search_product_page.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path:  AppConstant.splashScreen,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppConstant.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppConstant.addProductPage,
      builder: (context, state) => const AddProductPage(),
    ),
    GoRoute(
      path: AppConstant.searchProductPage,
      builder: (context, state) => const SearchProductPage(),
    ),
  ],
    redirect: (context, state) {
      if (state.fullPath == '/') {
        return '/dashboard/home';
      }
      return null;
    }
);
