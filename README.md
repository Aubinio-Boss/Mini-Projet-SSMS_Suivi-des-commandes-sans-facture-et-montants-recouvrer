🚀 **SSMS & SQL Playground Mini-Project: Tracking Uninvoiced Orders and Recoverable Amounts**

📌 Context and Objectives

This project aims to:

Identify orders that have been placed but *not invoiced*.
* Calculate the potentially *lost amounts* (UnitPrice × Quantity × (1 – Discount)).
* Produce an *automated report* using:

    SQL Server Management Studio (SSMS)
    SQL Playground (online T‑SQL testing environment)

 📂 Repository Contents

 **`scripts/`**: `.sql` files for SSMS
 **`playground/`**: T‑SQL snippets and examples for SQL Playground
 **`docs/README.md`**: project documentation (this file)

 ✨ Key Features

1. **Table Listing** (SSMS & Playground)
2. **Filtering** of orders without an invoice
3. **Advanced Joins** (LEFT, RIGHT, INNER, FULL, CROSS)
4. **Loss Calculation** by customer and category
5. **Parameterized Stored Procedure** (`ReportCustomerTurnover`)


 ⚙️ Usage

1. **SSMS**:

    Open and connect SSMS to **WideWorldImporters** (or your target database).
    Run the scripts located in the `scripts/` folder.
2. **SQL Playground**:

    Copy and paste snippets from `playground/` into the online editor.
    Test and refine your queries before deploying them in production.

 🆘 Help & Support

 **IntelliSense**: refresh the cache (**Ctrl + Shift + R**) if you see red underlines.
 **Restored Database**: ensure **WideWorldImporters** (or `SQLPlayground`) is available.
 **Documentation**: refer to the official SQL Server and T‑SQL guides.

