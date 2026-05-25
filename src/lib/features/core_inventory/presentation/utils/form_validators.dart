// lib/features/core_inventory/presentation/utils/form_validators.dart
import 'package:flutter/material.dart';

class InventoryFormValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an item name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 100) {
      return 'Name must be less than 100 characters';
    }
    return null;
  }
  
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a quantity';
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid number';
    }
    if (quantity <= 0) {
      return 'Quantity must be greater than zero';
    }
    if (quantity > 999999) {
      return 'Quantity is too large';
    }
    return null;
  }
  
  static String? validateExpirationDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    
    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Use format: YYYY-MM-DD';
    }
    
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Expiration date cannot be in the past';
    }
    
    return null;
  }
  
  static String? validateBrand(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a brand or product name';
    }
    if (value.length > 200) {
      return 'Brand name is too long';
    }
    return null;
  }
}
