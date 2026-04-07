import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:src/config/theme.dart';

const kGreen = AppTheme.primaryColor;
const kGreenLight = AppTheme.accentColor;
const kGreenCard = AppTheme.primaryColor;
const kBg = AppTheme.backgroundColor;
const kWhite = AppTheme.surfaceColor;
const kTextDark = AppTheme.primaryText;
const kTextMuted = AppTheme.mutedText;


class Inventory {
  final String id;
  final String name;
  final int itemCount;
  final String role; // 'Owner' | 'Editor' | 'Viewer'
  final String? sharedBy;

  const Inventory({
    required this.id,
    required this.name,
    required this.itemCount,
    required this.role,
    this.sharedBy,
  });
}

class InventoryItem {
  final String id;
  final String name;
  final int qty;
  final String room;
  final String purchaseValue;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.room,
    this.purchaseValue = '',
  });
}

final mockInventories = [
  const Inventory(id: '1', name: 'Home', itemCount: 142, role: 'Owner'),
  const Inventory(id: '2', name: "Ana's Apartment", itemCount: 30, role: 'Editor', sharedBy: 'Ana Rivera'),
  const Inventory(id: '3', name: 'Family House', itemCount: 201, role: 'Viewer', sharedBy: 'Misael M.'),
];

final mockItems = {
  '1': [
    const InventoryItem(id: 'i1', name: 'Couch', qty: 1, room: 'Living Room', purchaseValue: '300.00'),
    const InventoryItem(id: 'i2', name: 'Coffee Table', qty: 1, room: 'Living Room', purchaseValue: '150.00'),
    const InventoryItem(id: 'i3', name: 'Chicken', qty: 1, room: 'Kitchen', purchaseValue: '12.00'),
    const InventoryItem(id: 'i4', name: 'Egg', qty: 12, room: 'Kitchen', purchaseValue: '4.00'),
  ],
  '2': [
    const InventoryItem(id: 'i5', name: 'Couch', qty: 1, room: 'Living Room', purchaseValue: '500.00'),
    const InventoryItem(id: 'i6', name: 'Coffee Table', qty: 1, room: 'Living Room', purchaseValue: '200.00'),
    const InventoryItem(id: 'i7', name: 'Chicken', qty: 1, room: 'Kitchen', purchaseValue: '12.00'),
    const InventoryItem(id: 'i8', name: 'Egg', qty: 12, room: 'Kitchen', purchaseValue: '4.00'),
  ],
  '3': [
    const InventoryItem(id: 'i9', name: 'TV', qty: 1, room: 'Living Room', purchaseValue: '800.00'),
    const InventoryItem(id: 'i10', name: 'Sofa', qty: 1, room: 'Living Room', purchaseValue: '600.00'),
    const InventoryItem(id: 'i11', name: 'Pan Set', qty: 3, room: 'Kitchen', purchaseValue: '80.00'),
    const InventoryItem(id: 'i12', name: 'Egg', qty: 12, room: 'Kitchen', purchaseValue: '4.00'),
  ],
};

// ─── SCREEN 1: MY INVENTORIES LIST ───────────────────────────────────────────
class MyInventoriesScreen extends StatefulWidget {
  const MyInventoriesScreen({super.key});

  @override
  State<MyInventoriesScreen> createState() => _MyInventoriesScreenState();
}

class _MyInventoriesScreenState extends State<MyInventoriesScreen> {
  String _search = '';

  List<Inventory> get _filtered => mockInventories
      .where((i) => i.name.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  List<Inventory> get _mine =>
      _filtered.where((i) => i.role == 'Owner').toList();

  List<Inventory> get _shared =>
      _filtered.where((i) => i.role != 'Owner').toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: const BackButton(color: kTextDark),
        title: Text(
          'My Inventories',
          style: GoogleFonts.poppins(
            color: kTextDark,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: open add inventory flow
            },
            child: Text(
              '+ Add',
              style: GoogleFonts.inter(
                color: kTextDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: GoogleFonts.inter(color: kTextDark, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.inter(color: kTextMuted, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: kTextMuted, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  if (_mine.isNotEmpty) ...[
                    Text(
                      'My home',
                      style: GoogleFonts.inter(
                        color: kTextDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._mine.map((inv) => _InventoryCard(
                          inventory: inv,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InventoryItemsScreen(inventory: inv),
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                  ],
                  if (_shared.isNotEmpty) ...[
                    Text(
                      'Shared with me',
                      style: GoogleFonts.inter(
                        color: kTextDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._shared.map((inv) => _InventoryCard(
                          inventory: inv,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InventoryItemsScreen(inventory: inv),
                            ),
                          ),
                        )),
                  ],
                  if (_filtered.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Text(
                          'No inventories found.',
                          style: GoogleFonts.inter(color: kTextMuted),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  final Inventory inventory;
  final VoidCallback onTap;

  const _InventoryCard({required this.inventory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: kGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.home_outlined, color: kWhite, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inventory.name,
                    style: GoogleFonts.inter(
                      color: kWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    inventory.sharedBy != null
                        ? '${inventory.itemCount} items · ${inventory.sharedBy}'
                        : '${inventory.itemCount} items',
                    style: GoogleFonts.inter(color: kGreenLight, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                inventory.role,
                style: GoogleFonts.inter(
                  color: kGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SCREEN 2 & 3: INVENTORY ITEMS (Editor / Viewer) ─────────────────────────
class InventoryItemsScreen extends StatefulWidget {
  final Inventory inventory;

  const InventoryItemsScreen({super.key, required this.inventory});

  @override
  State<InventoryItemsScreen> createState() => _InventoryItemsScreenState();
}

class _InventoryItemsScreenState extends State<InventoryItemsScreen> {
  String _search = '';

  bool get _isEditor => widget.inventory.role == 'Owner' || widget.inventory.role == 'Editor';

  List<InventoryItem> get _items =>
      (mockItems[widget.inventory.id] ?? [])
          .where((i) => i.name.toLowerCase().contains(_search.toLowerCase()))
          .toList();

  Map<String, List<InventoryItem>> get _grouped {
    final map = <String, List<InventoryItem>>{};
    for (final item in _items) {
      map.putIfAbsent(item.room, () => []).add(item);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: const BackButton(color: kTextDark),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.inventory.name,
              style: GoogleFonts.poppins(
                color: kTextDark,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              widget.inventory.role,
              style: GoogleFonts.inter(color: kTextMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kTextDark),
            onPressed: () {
              // TODO: show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                onChanged: (v) => setState(() => _search = v),
                style: GoogleFonts.inter(color: kTextDark, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  hintStyle: GoogleFonts.inter(color: kTextMuted, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: kTextMuted, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(
                    child: Text(
                      'No items found.',
                      style: GoogleFonts.inter(color: kTextMuted),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      ..._grouped.entries.map((entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Text(
                                entry.key.toUpperCase(),
                                style: GoogleFonts.inter(
                                  color: kTextMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...entry.value.map((item) => _ItemCard(
                                    item: item,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ItemDetailScreen(
                                          item: item,
                                          inventoryName: widget.inventory.name,
                                          isEditor: _isEditor,
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          )),
                      const SizedBox(height: 16),
                      // Read-only notice for Viewer or Add Item for Editor
                      if (_isEditor)
                        GestureDetector(
                          onTap: () {
                            // TODO: navigate to add item screen
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: kWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: kGreen,
                                style: BorderStyle.solid,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: kGreen, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Add Item',
                                  style: GoogleFonts.inter(
                                    color: kGreen,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: kGreenLight.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Read-only access',
                                style: GoogleFonts.inter(
                                  color: kGreen,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Contact the owner to make changes',
                                style: GoogleFonts.inter(
                                  color: kGreen,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onTap;

  const _ItemCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kGreenCard,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.inter(
                      color: kWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '${item.qty} qty',
                    style: GoogleFonts.inter(color: kGreenLight, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward, color: kWhite, size: 18),
          ],
        ),
      ),
    );
  }
}

// ─── SCREEN 4: ITEM DETAIL ────────────────────────────────────────────────────
class ItemDetailScreen extends StatelessWidget {
  final InventoryItem item;
  final String inventoryName;
  final bool isEditor;

  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.inventoryName,
    required this.isEditor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: const BackButton(color: kTextDark),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Item Details',
              style: GoogleFonts.poppins(
                color: kTextDark,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              inventoryName,
              style: GoogleFonts.inter(color: kTextMuted, fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          if (isEditor)
            Builder(
              builder: (ctx) => TextButton(
                onPressed: () {
                  Navigator.of(ctx).push(
                    MaterialPageRoute(
                      builder: (_) => EditItemScreen(item: item),
                    ),
                  );
                },
                child: Text(
                  'Edit',
                  style: GoogleFonts.inter(
                    color: kTextDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo area
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(Icons.camera_alt_outlined,
                  color: kTextMuted, size: 32),
            ),
            const SizedBox(height: 16),

            // Item name + badge
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: GoogleFonts.poppins(
                          color: kTextDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        item.room,
                        style: GoogleFonts.inter(
                          color: kTextMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kGreenLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Shared',
                    style: GoogleFonts.inter(
                      color: kGreen,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Detail rows
            Container(
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  _DetailRow(label: 'Owner', value: 'Jaime Rivera'),
                  _DetailRow(label: 'Location', value: item.room),
                  _DetailRow(label: 'Purchase date', value: 'Mar 14, 2023'),
                  _DetailRow(
                      label: 'Purchase Value',
                      value: '\$${item.purchaseValue}',
                      isLast: true),
                ],
              ),
            ),
            const Spacer(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: handle request action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: kWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Request',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: handle report issue action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: kWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Report Issue',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                    color: kGreenLight.withValues(alpha: 0.3), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: kGreenLight, fontSize: 13),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: kWhite,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SCREEN 5: EDIT ITEM ─────────────────────────────────────────────────────
class EditItemScreen extends StatefulWidget {
  final InventoryItem item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _qtyController;
  late TextEditingController _roomController;
  late TextEditingController _purchaseValueController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _qtyController = TextEditingController(text: widget.item.qty.toString());
    _roomController = TextEditingController(text: widget.item.room);
    _purchaseValueController = TextEditingController(text: widget.item.purchaseValue);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _roomController.dispose();
    _purchaseValueController.dispose();
    super.dispose();
  }

  void _save() {
    // TODO: persist changes to Supabase
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: const BackButton(color: kTextDark),
        title: Text(
          'Edit Item',
          style: GoogleFonts.poppins(
            color: kTextDark,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Save',
              style: GoogleFonts.inter(
                color: kGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TODO: add image upload
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: const Icon(Icons.camera_alt_outlined, color: kTextMuted, size: 32),
            ),
            const SizedBox(height: 16),
            _FormField(label: 'Item Name', controller: _nameController),
            const SizedBox(height: 12),
            _FormField(
              label: 'Quantity',
              controller: _qtyController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            _FormField(label: 'Room / Location', controller: _roomController),
            const SizedBox(height: 12),
            _FormField(
              label: 'Purchase Value (\$)',
              controller: _purchaseValueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _FormField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: kTextMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(color: kTextDark, fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── MAIN APP ENTRY ───────────────────────────────────────────────────────────
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Inventory',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MyInventoriesScreen(),
    );
  }
}
