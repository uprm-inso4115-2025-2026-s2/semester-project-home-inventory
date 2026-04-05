import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.initialName = '',
    this.initialDetails = '',
    this.initialQuantity = 1,
    this.initialExpirationDate = '',
  });

  final String submitLabel;
  final void Function(
    String name,
    String details,
    int quantity,
    String expirationDate,
  )
  onSubmit;
  final String initialName;
  final String initialDetails;
  final int initialQuantity;
  final String initialExpirationDate;

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _detailsController;
  late final TextEditingController _expirationController;
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _detailsController = TextEditingController(text: widget.initialDetails);
    _expirationController = TextEditingController(
      text: widget.initialExpirationDate,
    );
    _quantity = widget.initialQuantity;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _expirationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: _detailsController,
            decoration: const InputDecoration(
              labelText: 'Item Details',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 2.h),
          Text('Edit Stock', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 1.h),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (_quantity > 0) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
                icon: const Icon(Icons.remove),
              ),
              Text('$_quantity'),
              IconButton(
                onPressed: () {
                  setState(() {
                    _quantity++;
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          TextField(
            controller: _expirationController,
            decoration: const InputDecoration(
              labelText: 'Edit Expiration Date',
              hintText: 'YYYY-MM-DD',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onSubmit(
                  _nameController.text,
                  _detailsController.text,
                  _quantity,
                  _expirationController.text,
                );
              },
              child: Text(widget.submitLabel),
            ),
          ),
        ],
      ),
    );
  }
}
