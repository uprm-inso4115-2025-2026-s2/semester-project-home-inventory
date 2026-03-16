# Grocery List Feature

This feature provides the grocery list flow: a home screen with Collections and My Grocery List tabs, category browsing, custom items management, add/edit item, and history.

---

## Data

### `data/constants.dart`
Defines shared theme colors for the grocery list UI:
- **backgroundColor** – off-white background (`#FBF7EF`)
- **primary** – dark green (`#3A5A40`) for cards and accents
- **secondary** – light green (`#A3B18A`) for icons and highlights

---

## Presentation

### `presentation/routes.dart`
Go Router configuration for the grocery feature. Registers:
- **`/grocery_home`** – main grocery home (with `HomePage` and `TodoCubit`)
- **`categories`** – category list (e.g. Vegetables), with nested **`custom_items`** and **`edit_item`**
- **`add_item`** – add new item screen
- **`history`** – grocery history screen

### `presentation/pages/home_page.dart`
Main grocery screen. Shows:
- Top bar with “History” (left) and add button (right)
- Two tabs: **Collections** and **My Grocery List**, switched via a `PageView`
- Delegates content to `CollectionsPage` and `MyGroceryListPage`

### `presentation/pages/collections_page.dart`
Content for the **Collections** tab. Displays a search bar and a list of collection cards (e.g. “Vegetables”). Tapping a card navigates to the **Categories** screen for that collection.

### `presentation/pages/my_grocery_list_page.dart`
Content for the **My Grocery List** tab. Shows a search bar and a scrollable list of grocery items using `ItemTile`, with quantity increment/decrement (state is local for now).

### `presentation/pages/categories.dart`
Category view (e.g. “Vegetables”). Shows a search bar and a grid of items in that category. When `isCustom` is true, shows an “Edit” button in the top bar that navigates to **Custom Items**.

### `presentation/pages/custom_items.dart`
Screen to manage custom items in a category. Lists custom items as `ItemTile` with `isCustom: true` (tap opens edit, delete via dialog). Has a search bar and “Edit Custom Items” title.

### `presentation/pages/add_item.dart`
Screen to add a new grocery item (or edit when used as “Edit Item”). Includes:
- Name field
- Item image upload
- Optional “Item” preview tile  
Used for both **Add Item** and **Edit Item** (when `isCustom: true`).

### `presentation/pages/history.dart`
Grocery history screen. Shows past lists grouped by date (e.g. “Today”, “Yesterday”, “March 11, 2025”) with read-only item tiles (`ItemTile` with `isHistory: true`).

### `presentation/widgets/item_tile.dart`
Reusable row for a single grocery item. Shows image placeholder, title, and:
- **Default** – quantity with +/- and action sheet (Mark as completed, Remove from list)
- **`isCustom: true`** – edit (navigate to edit_item) and delete (dialog)
- **`isHistory: true`** – no quantity or actions (read-only)

Uses `primary` and `secondary` from `constants.dart` for styling.
