class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String status;
  final DateTime createdAt;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.status,
    required this.createdAt,
  });

  /// Factory for creating from JSON (when real API is ready)
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  /// Convert to JSON (if needed)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'quantity': quantity,
    'status': status,
    'created_at': createdAt.toIso8601String(),
  };
}