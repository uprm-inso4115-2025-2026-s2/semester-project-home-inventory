# Code Style Guide

## 📋 Table of Contents
- [Overview](#overview)
- [General Principles](#general-principles)
- [Code Standards](#code-standards)
- [Documentation Standards](#documentation-standards)
- [Additional Resources](#additional-resources)

---

## 🎯 Overview
This style guide establishes coding standards and best practices for the Home Inventory project. We follow **Google's Style Guidelines** for code formatting and conventions. Specific language guides will be referenced once the tech stack is finalized.

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
*Note: These are general guidelines. Follow language-specific conventions from Google's style guides.*

- **Variables & Functions**: Use descriptive names that indicate purpose
  ```javascript
  // Good
  const userInventoryItems = [];
  function calculateExpirationDate() {}
  
  // Bad
  const arr = [];
  function calc() {}
  ```

- **Constants**: Use for values that don't change
  ```javascript
  const MAX_ITEMS_PER_ROOM = 100;
  const DEFAULT_NOTIFICATION_THRESHOLD = 3;
  ```

- **Classes/Components**: Use nouns that represent the entity
  ```javascript
  class InventoryItem {}
  class NotificationService {}
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
```javascript
// Good: Explains reasoning
// Using 3-day threshold to give users time to restock
const DEFAULT_LOW_STOCK_DAYS = 3;

// Bad: States the obvious
// Set the threshold to 3
const DEFAULT_LOW_STOCK_DAYS = 3;
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
```javascript
/**
 * Calculates days until an item expires
 * @param {Date} expirationDate - The expiration date of the item
 * @param {Date} currentDate - The current date (defaults to today)
 * @returns {number} Number of days until expiration (negative if expired)
 */
function daysUntilExpiration(expirationDate, currentDate = new Date()) {
  // Implementation
}
```

### Project Documentation
- All project documentation must use **AsciiDoc** format
- Store documentation in `/docs` folder
- See `CONTRIBUTING.md` for documentation workflow

---

## 📚 Additional Resources

### Google Style Guides
- [Google Style Guides](https://google.github.io/styleguide/) (Reference once tech stack is determined)

### Best Practices
- [Clean Code Principles](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)

### Tools
- Use linters and formatters for your chosen language
- Configure your IDE to follow the style guide
- Use pre-commit hooks to enforce standards

---

**Questions or Suggestions?**  
If you have suggestions for improving this style guide, please open an issue or submit a pull request.

---

**Last Updated:** February 6, 2026
