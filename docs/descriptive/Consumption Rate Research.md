## Section 3: Consumption Rate Calculation and Inventory Valuation

This research defines the mathematical models and data requirements for predicting item depletion and calculating the total monetary value of household inventory. These analytics are foundational for generating automated restock alerts and providing financial summaries for budgeting or insurance.

---

### 1\. Consumption Algorithms: Predicting Depletion

To calculate "Estimated Days Remaining," the system must evaluate how quickly items are removed from inventory. Two primary models were considered:

* Simple Average Daily Use: Total quantity consumed divided by the number of days since the first recorded use.  
  * Pros: Easy to compute; works well for consistent items like milk or detergent.  
  * Cons: Fails to account for sudden lifestyle changes (e.g., guests staying over).  
* Moving Average (Recommended): Calculates the consumption rate based only on the last 30 days of activity.  
  * Pros: Highly adaptive to recent habits.  
  * Cons: Requires more data points to be accurate.

Defined Formula:

Estimated Days Remaining \= Current Quantity / (Quantity Consumed in Last 30 Days / 30\)

---

### 2\. Inventory Valuation: FIFO vs. LIFO

When tracking the value of items purchased at different prices (e.g., buying coffee for $8 one month and $10 the next), the system must decide which cost to "use" first.

* LIFO (Last-In, First-Out): Assumes the most recently purchased items are used first.  
* FIFO (First-In, First-Out): Assumes the oldest stock is used first.

Recommendation: FIFO is the most intuitive for home users. It aligns with how people naturally rotate perishables to prevent spoilage and ensures the "Total Value" reflected in the app matches the actual remaining shelf life of the products.

---

### 3\. Unit Conversion & Logic

To ensure accuracy when buying in bulk but consuming individually, the system will implement a "Base Unit" logic.

* Logic: All items are stored in the database as a "Base Unit" (e.g., "Ounce," "Gram," or "Single Item").  
* Application: If a user buys a "12-pack" of soda, the system immediately converts this to "12 units." Consumption is then subtracted from the unit total, preventing errors when calculating the daily use of mixed-size packages.

---

### 4\. Database Requirements

To support these calculations, the following fields must be present in the inventory schema:

| Field Name | Data Type | Purpose |
| :---- | :---- | :---- |
| initial\_quantity | Integer/Float | The amount at the time of purchase. |
| current\_quantity | Integer/Float | Remaining amount after use logs. |
| purchase\_price | Decimal | Cost per unit for FIFO valuation. |
| last\_replenished | Date | Resets the consumption window. |
| expiration\_date | Date | Triggers "forced consumption" (value drops to $0). |
| unit\_type | String | Defines the base unit (ml, oz, count). |

---

### 5\. Spanish-to-English Technical Glossary

To ensure consistency across development and documentation, the following terms are standardized:

* Tasa de Consumo \-\> Consumption Rate  
* Valoración de Inventario \-\> Inventory Valuation  
* Agotamiento de Existencias \-\> Stock Depletion  
* Primeras Entradas, Primeras Salidas \-\> First-In, First-Out (FIFO)  
* Unidad de Medida \-\> Unit of Measure (UOM)  
* Fecha de Caducidad \-\> Expiration Date

---

### 6\. Data Visualization Strategy

For the "Value per Category" overview, the following visualizations are recommended:

1. Donut Chart: Best for showing the distribution of total monetary value across categories (e.g., 60% Electronics, 30% Groceries).  
2. Heatmap: Useful for showing "High-Waste" areas where items are frequently expiring before being used.  
3. Bar Chart: To compare "Budgeted Value" vs. "Actual Inventory Value" month-over-month.

