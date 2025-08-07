import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopkeeper_admin/model/billing_list_model.dart';


// Static list of customers
final customerListProvider = StateProvider<List<BillingListModel>>((ref) => [
  BillingListModel(
    id: '1',
    name: 'Chirag',
    mobile: '9876543210',
    date: DateTime(2025, 8, 7),
    totalAmount: 540.0,
  ),
  BillingListModel(
    id: '2',
    name: 'Deepa',
    mobile: '9123456780',
    date: DateTime(2025, 8, 6),
    totalAmount: 405.5,
  ),
  BillingListModel(
    id: '3',
    name: 'Amit',
    mobile: '9988776655',
    date: DateTime(2025, 8, 7),
    totalAmount: 230.0,
  ),
]);

// Search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected date for filtering
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
