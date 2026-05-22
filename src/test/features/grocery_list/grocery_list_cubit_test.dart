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
  });
}
