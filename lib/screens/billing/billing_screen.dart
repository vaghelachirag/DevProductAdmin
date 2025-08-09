import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shopkeeper_admin/base/extensions/utils/app_constant.dart';

import '../../widgets/DateNavigator.dart';
import 'billing_provider.dart';


class BillingScreen extends ConsumerWidget {
  const BillingScreen({super.key});

  void _deleteCustomer(WidgetRef ref, String id) {
    final list = ref.read(customerListProvider);
    final updatedList = list.where((customer) => customer.id != id).toList();
    ref.read(customerListProvider.notifier).state = updatedList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customerListProvider);
    final query = ref.watch(searchQueryProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    final filtered = customers
        .where((c) =>
    DateUtils.isSameDay(c.date, selectedDate) &&
        (c.name.toLowerCase().contains(query.toLowerCase()) ||
            c.mobile.contains(query)))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 Customer List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(left: 20,right: 20),child: _buildSearchBar(ref),),
          const SizedBox(height: 8),
          DateNavigator(selectedDate: selectedDate),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? Center(child: Text('no_customers'.tr()))
                : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final customer = filtered[index];
                return GestureDetector(
                  onTap: (){
                    print("OnTap$index");
                    context.push(AppConstant.billingDetailPage);
                  },
                  child:Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    color: Colors.grey.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            child: Icon(Icons.person, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  customer.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 16, color: Colors.blueGrey),
                                    const SizedBox(width: 4),
                                    Text(
                                      customer.mobile,
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.date_range, size: 16, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat.yMMMd().format(customer.date),
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 16, color: Colors.orange),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${customer.totalAmount.toStringAsFixed(2)}",
                                      style: GoogleFonts.poppins(fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                            onPressed: () => _deleteCustomer(ref, customer.id),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'search_customer_hint'.tr(),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
    );
  }
}
