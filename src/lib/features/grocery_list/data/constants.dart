import 'dart:ui';

Color backgroundColor = Color(0xFFFBF7EF);
Color primary = Color(0xFF3A5A40);
Color secondary = Color(0xFFA3B18A);

const String customCollectionName = 'Custom';

bool isCustomCollection(String name) => name == customCollectionName;

const List<String> collectionNames = [
  'Vegetables',
  'Fruits',
  'Dairy',
  'Meat',
  'Snacks',
  'Beverages',
  'Frozen',
  'Pantry',
];

const Map<String, List<String>> collectionItems = {
  'Vegetables': [
    'Tomatoes',
    'Carrots',
    'Lettuce',
    'Onions',
    'Potatoes',
    'Broccoli',
    'Spinach',
    'Peppers',
    'Cucumber',
    'Celery',
  ],
  'Fruits': [
    'Apples',
    'Bananas',
    'Oranges',
    'Grapes',
    'Strawberries',
    'Blueberries',
    'Mangoes',
    'Pineapple',
  ],
  'Dairy': [
    'Milk',
    'Cheese',
    'Yogurt',
    'Butter',
    'Eggs',
    'Cream',
    'Sour Cream',
  ],
  'Meat': [
    'Chicken',
    'Beef',
    'Pork',
    'Turkey',
    'Bacon',
    'Sausage',
    'Ground Beef',
  ],
  'Snacks': [
    'Chips',
    'Crackers',
    'Popcorn',
    'Granola Bars',
    'Nuts',
    'Pretzels',
    'Cookies',
  ],
  'Beverages': [
    'Water',
    'Juice',
    'Soda',
    'Coffee',
    'Tea',
    'Sports Drinks',
    'Sparkling Water',
  ],
  'Frozen': [
    'Frozen Pizza',
    'Ice Cream',
    'Frozen Vegetables',
    'Frozen Fruit',
    'Frozen Meals',
    'Frozen Fries',
  ],
  'Pantry': [
    'Rice',
    'Pasta',
    'Bread',
    'Flour',
    'Sugar',
    'Olive Oil',
    'Canned Beans',
    'Cereal',
  ],
};

List<String> itemsForCollection(String collectionName) {
  if (isCustomCollection(collectionName)) {
    return [];
  }
  return collectionItems[collectionName] ?? [];
}
