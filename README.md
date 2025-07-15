# ShipMate

**ShipMate** is a sample database project modeling a shipment company. This repository contains the SQL definitions for the database schema, normalization analysis, an ER diagram (Mermaid), and a collection of SQL queries/features supporting common shipment operations.

---

## Table of Contents

* [Overview](#overview)
* [Database Setup](#database-setup)
* [Schema Definition](#schema-definition)

  * [Tables](#tables)
  * [ER Diagram](#er-diagram)
* [Normalization](#normalization)
* [SQL Queries & Features](#sql-queries--features)
* [Usage](#usage)
* [Contributing](#contributing)
* [License](#license)

---

## Overview

ShipMate provides a relational schema for managing customers, payments, employees, vehicles, packages, orders, and tracking locations. It is designed to:

* Store customer and account information
* Record credit card details securely
* Model employees, warehouses, trucks, and planes
* Track package assignments and transit history
* Support shipping cost calculations and delivery status reporting

---

## Database Setup

1. Ensure you have MySQL (or compatible) installed.
2. Run the following to create and use the ShipMate database:

   ```sql
   CREATE DATABASE ShipMate;
   USE ShipMate;
   ```
3. Load the schema definitions (all `.sql` files in `/schema/`).

---

## Schema Definition

### Tables

* **Customer** (`CustomerID`, Name, Street, Address, Phone, Email, BillingMethod)
* **Account** (`AccountID`, AccountNumber, CustomerID)
* **CreditCard** (`CardNumber`, CustomerID, ExpirationDate, SecurityCode)
* **Employee** (`EmployeeID`, Name, Address, Phone, Email, Role)
* **Warehouse** (`WarehouseID`, Address, Phone, Email)
* **Truck** (`TruckID`, PlateNumber, Capacity, EmployeeID, WarehouseID)
* **Plane** (`PlaneID`, TailNumber, Capacity, EmployeeID, WarehouseID)
* **Package** (`PackageID`, Type, Weight, DeliveryTime, Status, AccountID, CreditCardNumber, EmployeeID, TruckID, PlaneID, WarehouseID)
* **Orders** (`PackageID`, `SenderID`, `ReceiverID`, ShippingDate, ShippingCost, PromisedTime)
* **loc\_of\_pkg** (`PackageID`, WarehouseID, Start\_timestamp, End\_timestamp)
* **Works** (`EmployeeID`, TruckID, PlaneID)

#### ER Diagram


## Normalization

All tables are in Third Normal Form (3NF), ensuring no transitive dependencies. See `/analysis/normalization.pdf` for full details (Customer, Account, CreditCard, Employee, Warehouse, Truck, Plane, Package, Orders, loc\_of\_pkg, Works are all 3NF compliant). 

---

## SQL Queries & Features

This repo includes scripts to:

* **Customer & Account Management**: Add, update, delete, retrieve customers and accounts.
* **Payment Processing**: Insert and validate credit card records.
* **Shipment Creation**: Create packages, assign to accounts or credit cards.
* **Routing & Tracking**: Update package status, record movements between warehouses (`loc_of_pkg`).
* **Assignment**: Allocate employees, trucks, and planes (`Works` table).
* **Reporting**: Calculate shipping costs, generate delivery performance reports.

All queries are organized under `/queries/` with descriptive filenames.

---

## Usage

1. Import the schema: `mysql -u user -p ShipMate < schema/shipmate_schema.sql`
2. Load normalization analysis PDF in `/analysis/normalization.pdf`.
3. Run queries: `mysql -u user -p ShipMate < queries/<script>.sql`
4. View ER diagram by rendering the Mermaid code in a compatible markdown viewer.

---

## Contributing

Contributions are welcome! Please fork the repo, make changes, and submit a pull request. Ensure new features include:

* SQL scripts in `/queries/`
* Updated documentation in this `README.md`
* Tests for any new logic

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
