# Core Presentation Widgets

Reusable UI components used across the app (e.g. app bar, forms, search, buttons). They keep layout and styling consistent.

---

## `top.dart`
**Top** – App bar / header bar.

- **Left**: Back button (icon) or custom text (e.g. "History") via `leftButton` and optional `leftButtonText`.
- **Center**: Title (or `titleWidget`).
- **Right**: Optional trailing widget, or an add button when `addButton` is true and `addFunction` is set.

Optional: `showSearch` adds a search field below the row; `focusNode`, `onChanged`, `secondWidget`, `thirdWidget` customize it. Supports custom colors (`color`, `iconColor`, `buttonColor`, `backgroundColor`) and padding. Used on most screens as the main header.

---

## `button.dart`
**Button** – Full-width primary action button.

Shows `buttonText` on a styled `CupertinoButton` (primary green, rounded corners). On press it calls `context.pop()`. Used as a bottom bar action (e.g. "Add Item", "Edit Item"). Does not take a custom `onPressed`; behavior is fixed to pop.

---

## `text_field.dart`
**BuildTextField** – Styled text input with label.

- **Label**: Optional label with optional red `*` when `required` is true.
- **Field**: Single or multi-line (`paragraph`), optional max length, optional numeric-only (`isNumber`), optional password with show/hide toggle.
- **Styling**: Uses `fieldColor`, border radius 16, and grocery `secondary` for borders/hint. Optional `onChange`, `onTap`, `keyboardType`, `inputFormatters`, `enable`.

Width is `40.w` when `isSmall` is true, otherwise `90.w`. Used for name, descriptions, and other form inputs.

---

## `search_bar.dart`
**MySearchBar** – Search input for lists.

A single `CupertinoSearchTextField` with placeholder "Search an Item", search icon, white background, rounded shape, and border using grocery `primary`/`secondary`. `onChanged` is currently a no-op; intended to be wired to filter list data. Used on Categories, Custom Items, Collections, and My Grocery List.

---

## `upload_image.dart`
**UploadImage** – Image or document upload control.

- **No file**: Shows a button ("Galeria" or "Documentos" when `isPdf` is true) that calls `chooseImg` to pick a file.
- **File chosen**: Shows a label ("image.jpg" or "document.pdf") and a "Cambiar" button to replace. For images, tapping the label opens a swipeable gallery (SwipeImageGallery) to view the file.

Accepts `title`, `color`, `changeButtonColor`, optional `required` asterisk. Used on Add Item (and similar screens) for item image or document upload.
