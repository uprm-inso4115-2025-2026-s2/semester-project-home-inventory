import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemLabelsPage extends StatelessWidget {
  const ItemLabelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Item Labels')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _LabelRow(color: Colors.red, label: 'Out of Stock'),
              _LabelRow(color: Colors.yellow, label: 'Low Stock'),
              _LabelRow(color: Colors.brown, label: 'About to Expire'),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.circle, color: color),
      title: Text(label),
    );
  }
}
