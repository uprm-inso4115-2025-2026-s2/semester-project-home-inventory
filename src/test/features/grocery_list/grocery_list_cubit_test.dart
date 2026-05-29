import 'package:flutter_test/flutter_test.dart';
import 'package:src/features/grocery_list/presentation/cubits/grocery_list_cubit.dart';

void main() {
  group('GroceryListCubit', () {
    late GroceryListCubit cubit;

    setUp(() {
      cubit = GroceryListCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('adds item with trimmed name', () {
      expect(cubit.addItem('  Milk  '), isTrue);
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.name, 'Milk');
      expect(cubit.state.items.first.quantity, 1);
    });

    test('rejects empty item names', () {
      expect(cubit.addItem('   '), isFalse);
      expect(cubit.state.items, isEmpty);
    });

    test('increments quantity when same item is added again', () {
      expect(cubit.addItem('Eggs'), isTrue);
      expect(cubit.addItem('eggs'), isTrue);
      expect(cubit.state.items.length, 1);
      expect(cubit.state.items.first.quantity, 2);
    });

    test('supports multiple unique items', () {
      expect(cubit.addItem('Milk'), isTrue);
      expect(cubit.addItem('Eggs'), isTrue);
      expect(cubit.addItem('Bread'), isTrue);
      expect(cubit.state.items.length, 3);
    });

    test('incrementQuantity increases count', () {
      cubit.addItem('Milk');
      final id = cubit.state.items.first.id;
      cubit.incrementQuantity(id);
      expect(cubit.state.items.first.quantity, 2);
    });

    test('decrementQuantity removes item when quantity reaches zero', () {
      cubit.addItem('Milk');
      final id = cubit.state.items.first.id;
      cubit.decrementQuantity(id);
      expect(cubit.state.items, isEmpty);
    });

    test('removeItem removes by id', () {
      cubit.addItem('Milk');
      final id = cubit.state.items.first.id;
      cubit.removeItem(id);
      expect(cubit.state.items, isEmpty);
    });

    test('addCustomCollectionItem creates custom collection entry', () {
      expect(cubit.addCustomCollectionItem('Protein Powder'), isTrue);
      expect(cubit.state.hasCustomCollection, isTrue);
      expect(cubit.state.customCollectionItems.first.name, 'Protein Powder');
    });

    test('rejects duplicate custom collection items', () {
      cubit.addCustomCollectionItem('Honey');
      expect(cubit.addCustomCollectionItem('honey'), isFalse);
      expect(cubit.state.customCollectionItems.length, 1);
    });

    test('removeCustomCollectionItem clears custom collection', () {
      cubit.addCustomCollectionItem('Honey');
      final id = cubit.state.customCollectionItems.first.id;
      cubit.removeCustomCollectionItem(id);
      expect(cubit.state.hasCustomCollection, isFalse);
    });

    test('markAsCompleted moves item to history sorted by date', () {
      cubit.addItem('Milk');
      final id = cubit.state.items.first.id;

      expect(cubit.markAsCompleted(id), isTrue);
      expect(cubit.state.items, isEmpty);
      expect(cubit.state.completedItems.length, 1);
      expect(cubit.state.completedItems.first.name, 'Milk');
      expect(cubit.state.completedItems.first.quantity, 1);
    });

    test('markAsCompleted returns false for unknown id', () {
      expect(cubit.markAsCompleted('missing'), isFalse);
      expect(cubit.state.completedItems, isEmpty);
    });

    test('completed items are ordered most recent first', () {
      cubit.addItem('Milk');
      cubit.addItem('Eggs');
      final milkId = cubit.state.items.firstWhere((i) => i.name == 'Milk').id;
      final eggsId = cubit.state.items.firstWhere((i) => i.name == 'Eggs').id;

      cubit.markAsCompleted(milkId);
      cubit.markAsCompleted(eggsId);

      expect(cubit.state.completedItems.first.name, 'Eggs');
      expect(cubit.state.completedItems.last.name, 'Milk');
      expect(
        cubit.state.completedItems.first.completedAt.isAfter(
          cubit.state.completedItems.last.completedAt,
        ),
        isTrue,
      );
    });
  });
}
