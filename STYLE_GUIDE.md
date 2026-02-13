# Code Style Guide

## 📋 Table of Contents
- [Overview](#overview)
- [General Principles](#general-principles)
- [Code Standards](#code-standards)
- [Documentation Standards](#documentation-standards)
- [Additional Resources](#additional-resources)

---

## 🎯 Overview
This style guide establishes coding standards and best practices for the Home Inventory project. We follow **Google's Style Guidelines** for code formatting and conventions.

**Tech Stack:**
- 📱 **Frontend:** Flutter (Dart)
- 🗄️ **Backend/Database:** Supabase (PostgreSQL + Auth + Storage)
- 🎨 **UI/UX Design:** Figma
- 📄 **Documentation:** AsciiDoc

**Purpose:** Ensure consistency, maintainability, and quality across the codebase.

---

## 🔑 General Principles

### Core Values
- **Write clear, readable code** - Code is read more often than written
- **Keep it simple** - Avoid unnecessary complexity
- **Be consistent** - Follow Google's style guides and existing patterns
- **Comment wisely** - Explain why, not what
- **Write self-documenting code** - Use meaningful names and clear structure

### Universal Best Practices
- ✅ Use meaningful variable and function names
- ✅ Keep functions small and focused (single responsibility)
- ✅ Avoid deep nesting (max 3-4 levels)
- ✅ Handle errors appropriately
- ✅ Remove unused code and commented-out sections
- ✅ Use constants for magic numbers and repeated values
- ✅ Write self-documenting code
- ✅ Follow DRY principle (Don't Repeat Yourself)
- ✅ Write code that is easy to test

---

## 💻 Code Standards

### Naming Conventions
*Follow Dart (Flutter) and PostgreSQL naming conventions as specified in Google's style guides.*

- **Variables & Functions (Dart)**: Use camelCase for variables, functions, and parameters
  ```dart
  // Good
  final List<Item> userInventoryItems = [];
  int calculateExpirationDate() {}
  
  // Bad
  final List<Item> user_inventory_items = [];
  int calc() {}
  ```

- **Constants (Dart)**: Use lowerCamelCase for constants
  ```dart
  const int maxItemsPerRoom = 100;
  const int defaultNotificationThreshold = 3;
  const int defaultLowStockDays = 7;
  ```

- **Classes (Dart)**: Use UpperCamelCase
  ```dart
  class InventoryItem {}
  class UserProfile {}
  class NotificationService {}
  ```

- **Database Tables/Columns (PostgreSQL)**: Use snake_case
  ```sql
  -- Good
  items, user_profiles, expiration_dates
  
  -- Bad
  Items, userProfiles, expirationDates
  ```

### Code Formatting
- Follow the indentation and line length rules from Google's style guide for your language
- Use consistent spacing around operators and after commas
- Use blank lines to separate logical blocks
- Group related code together

### Comments
- Use comments to explain **why**, not **what**
- Document complex algorithms or business logic
- Keep comments up-to-date with code changes
- Avoid obvious comments

**Examples:**
```dart
// Good: Explains reasoning
// Using 3-day threshold to give users time to restock
const int defaultLowStockDays = 3;

// Bad: States the obvious
// Set the threshold to 3
const int defaultLowStockDays = 3;
```

### Error Handling
- Always handle potential errors gracefully
- Provide meaningful error messages to users
- Log errors appropriately for debugging
- Never silently fail

### Code Organization
- Group related functionality together
- Keep files focused on a single responsibility
- Use clear folder structure
- Import/require statements at the top of files

---

## 📚 Documentation Standards

### Code Documentation
- Document public APIs, functions, and classes
- Include parameter types and return values
- Provide usage examples for complex functionality
- Keep documentation in sync with code

### Inline Documentation
```dart
/// Calculates days until an item expires
/// 
/// [expirationDate] - The expiration date of the item
/// [currentDate] - The current date (defaults to today)
/// 
/// Returns the number of days until expiration (negative if expired)
int daysUntilExpiration(DateTime expirationDate, {DateTime? currentDate}) {
  currentDate ??= DateTime.now();
  return expirationDate.difference(currentDate).inDays;
}
```

### Project Documentation
- All project documentation must use **AsciiDoc** format
- Store documentation in `/docs` folder
- See `CONTRIBUTING.md` for documentation workflow

---

## 📚 Additional Resources

### Google Style Guides
- **Dart (Flutter):** [Effective Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- **Dart Documentation:** [Dart Language Documentation](https://dart.dev/guides)
- **Flutter Best Practices:** [Flutter Style Guide](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#style-guide)
- **SQL/PostgreSQL:** [PostgreSQL Coding Conventions](https://www.postgresql.org/docs/current/sql-syntax.html)

### Supabase Resources
- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Flutter Guide](https://supabase.com/docs/guides/with-flutter)
- [PostgreSQL Best Practices](https://www.postgresql.org/docs/current/tutorial.html)

### Best Practices
- [Clean Code Principles](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Flutter Architecture Patterns](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)

### Tools
- **Dart/Flutter:** Use `dart format` and `flutter analyze`
- **IDE:** Configure VS Code or Android Studio with Dart/Flutter extensions
- **Database:** Use Supabase Studio for database management
- Use pre-commit hooks to enforce standards

---

**Questions or Suggestions?**  
If you have suggestions for improving this style guide, please open an issue or submit a pull request.

---

**Last Updated:** February 10, 2026
