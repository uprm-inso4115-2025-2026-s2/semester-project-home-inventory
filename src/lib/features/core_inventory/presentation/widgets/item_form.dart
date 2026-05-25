import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/form_validators.dart';

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
  
  final _formKey = GlobalKey<FormState>();
  
  String? _nameError;
  String? _quantityError;
  String? _expirationError;

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
  
  void _validateAndSubmit() {
    setState(() {
      _nameError = InventoryFormValidators.validateName(_nameController.text);
      _quantityError = InventoryFormValidators.validateQuantity(_quantity.toString());
      _expirationError = InventoryFormValidators.validateExpirationDate(
        _expirationController.text,
      );
    });
    
    if (_nameError == null && _quantityError == null && _expirationError == null) {
      widget.onSubmit(
        _nameController.text,
        _detailsController.text,
        _quantity,
        _expirationController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name *',
                border: const OutlineInputBorder(),
                errorText: _nameError,
                helperText: 'Required - Name of the product',
              ),
              onChanged: (_) => setState(() => _nameError = null),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _detailsController,
              decoration: const InputDecoration(
                labelText: 'Brand/Details',
                border: OutlineInputBorder(),
                helperText: 'Optional - Brand name or additional details',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 2.h),
            Text('Quantity *', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 1.h),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_quantity > 1) {
                      setState(() {
                        _quantity--;
                        _quantityError = null;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _quantity++;
                      _quantityError = null;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (_quantityError != null)
              Padding(
                padding: EdgeInsets.only(top: 0.5.h),
                child: Text(
                  _quantityError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: _expirationController,
              decoration: InputDecoration(
                labelText: 'Expiration Date',
                hintText: 'YYYY-MM-DD',
                border: const OutlineInputBorder(),
                errorText: _expirationError,
                helperText: 'Optional - When does this item expire?',
              ),
              onChanged: (_) => setState(() => _expirationError = null),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndSubmit,
                child: Text(widget.submitLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
