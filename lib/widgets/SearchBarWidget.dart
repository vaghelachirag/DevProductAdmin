import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/billing/billing_provider.dart';

class _SearchBar extends ConsumerWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: "🔍 Search by name or mobile",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
      ),
    );
  }
}
