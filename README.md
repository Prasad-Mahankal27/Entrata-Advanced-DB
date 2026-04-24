# Library Management System: Database Integration Project

This project covers the fundamental and advanced database concepts including SQL Basics, Joins, PostgreSQL specifics, Functions, Triggers, and PHP/ODBC Integration.

## Concepts Covered

### 1. SQL Basics
Located in `setup.sql`, this section includes:
- **Table Creation**: Defining `authors`, `books`, `borrowers`, and `loans`.
- **Primary Keys & Foreign Keys**: Ensuring data integrity via relationships.
- **CRUD Operations**: Examples of `INSERT` and `SELECT` to manage data.

### 2. SQL Joins
Demonstrated in `setup.sql` and used in `index.php`:
- **INNER JOIN**: Combining `books` and `authors` to show book details with author names.
- **LEFT JOIN**: Showing all authors, including those without books in the library.

### 3. PostgreSQL Specifics
Specific PostgreSQL features utilized:
- **Data Types**: `SERIAL` for auto-incrementing IDs and `TIMESTAMPTZ` for timezone-aware timestamps.
- **PL/pgSQL**: The procedual language used for functions and triggers.

### 4. SQL Functions
- **Function**: `calculate_late_fee(loan_day, return_day)`
- Logic: Calculates a fine of $0.50 per day for returns made after the 14-day loan period.
- Implementation: Defined in `setup.sql`, called via ODBC in `index.php`.

### 5. Triggers
- **Trigger**: `trg_inventory_update`
- **Logic**: 
  - On **INSERT** (new loan): Reduces `available_copies` of the book by 1.
  - On **UPDATE** (book returned): Increases `available_copies` by 1.
- Implementation: Ensures the inventory stays synchronized with loan activities automatically.

### 6. PHP and ODBC Integration
- **Connection**: Uses `odbc_connect()` with a connection string targeting the PostgreSQL ODBC driver.
- **Execution**: `odbc_exec()` is used to run JOIN queries and call stored PL/pgSQL functions.
- **Results**: `odbc_fetch_array()` displays data in a clean HTML table.

## How to Run

1. **Database Setup**:
   - Install PostgreSQL.
   - Run the commands in `setup.sql` using `psql` or an admin tool like pgAdmin.
   - Ensure you have the [PostgreSQL ODBC Driver](https://odbc.postgresql.org/) installed.

2. **PHP Setup**:
   - Ensure PHP has the `odbc` extension enabled (check `php.ini` for `extension=odbc`).
   - Place `index.php` in your web server's root (e.g., Apache `htdocs` or use `php -S localhost:8000`).
   - Open `index.php` in your browser.

3. **Note on Connectivity**:
   - Update the connection details in `index.php` (`$host`, `$db`, `$user`, `$pass`) to match your local PostgreSQL configuration.
"# Entrata-Advanced-DB" 
