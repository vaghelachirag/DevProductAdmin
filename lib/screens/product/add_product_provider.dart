import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Generate random Product ID
final productIdProvider = StateProvider<String>((ref) {
  final random = Random();
  return 'P${100000 + random.nextInt(899999)}';
});

final productNameProvider = StateProvider<String>((ref) => '');
final productCategoryProvider = StateProvider<String?>((ref) => null);
final purchasePriceProvider = StateProvider<String>((ref) => '');
final quantityProvider = StateProvider<String>((ref) => '');
