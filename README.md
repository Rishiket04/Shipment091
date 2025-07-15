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

```mermaid
erDiagram
    CUSTOMER {
        VARCHAR CustomerID PK "C…"
        VARCHAR Name
        VARCHAR street
        VARCHAR Address
        VARCHAR Phone
        VARCHAR Email
        VARCHAR BillingMethod
    }
    ACCOUNT {
        INT AccountID PK
        VARCHAR AccountNumber
        VARCHAR CustomerID FK
    }
    CREDITCARD {
        BIGINT CardNumber PK
        VARCHAR CustomerID FK
        DATE ExpirationDate
        INT SecurityCode
    }
    EMPLOYEE {
        VARCHAR EmployeeID PK "E…"
        VARCHAR Name
        VARCHAR Address
        VARCHAR Phone
        VARCHAR Email
        VARCHAR Role
    }
    WAREHOUSE {
        VARCHAR WarehouseID PK "W…"
        VARCHAR Address
        VARCHAR Phone
        VARCHAR Email
    }
    TRUCK {
        VARCHAR TruckID PK "T…"
        VARCHAR PlateNumber
        DECIMAL Capacity
        VARCHAR EmployeeID FK
        VARCHAR WarehouseID FK
    }
    PLANE {
        VARCHAR PlaneID PK "Pl…"
        VARCHAR TailNumber
        DECIMAL Capacity
        VARCHAR EmployeeID FK
        VARCHAR WarehouseID FK
    }
    PACKAGE {
        VARCHAR PackageID PK "P…"
        VARCHAR Type
        DECIMAL Weight
        DATETIME DeliveryTime
        VARCHAR Status
        INT AccountID FK
        BIGINT CreditCardNumber FK
        VARCHAR EmployeeID FK
        VARCHAR TruckID FK
        VARCHAR PlaneID FK
        VARCHAR WarehouseID FK
    }
    ORDERS {
        VARCHAR PackageID PK
        VARCHAR SenderID PK
        VARCHAR ReceiverID PK
        DATETIME ShippingDate
        DECIMAL ShippingCost
        DATETIME PromisedTime
    }
    LOC_OF_PKG {
        VARCHAR PackageID PK
        VARCHAR WarehouseID PK
        DATETIME Start_timestamp
        DATETIME End_timestamp
    }
    WORKS {
        VARCHAR EmployeeID PK
        VARCHAR TruckID
        VARCHAR PlaneID
    }

    CUSTOMER ||--o{ ACCOUNT         : has
    CUSTOMER ||--o{ CREDITCARD      : owns
    CUSTOMER ||--o{ ORDERS          : sends
    CUSTOMER ||--o{ ORDERS          : receives

    ACCOUNT   ||--o{ PACKAGE         : bills
    CREDITCARD||--o{ PACKAGE         : bills

    EMPLOYEE  ||--o{ TRUCK           : operates
    WAREHOUSE ||--o{ TRUCK           : houses

    EMPLOYEE  ||--o{ PLANE           : operates
    WAREHOUSE ||--o{ PLANE           : houses

    EMPLOYEE  ||--o{ PACKAGE         : handles
    TRUCK     ||--o{ PACKAGE         : transports
    PLANE     ||--o{ PACKAGE         : transports
    WAREHOUSE ||--o{ PACKAGE         : stores

    PACKAGE }o--o{ LOC_OF_PKG       : located_in
    WAREHOUSE }o--o{ LOC_OF_PKG     : holds

    PACKAGE  ||--o{ ORDERS          : is

    EMPLOYEE ||--o{ WORKS           : assigned
    TRUCK    ||--o{ WORKS           : includes
    PLANE    ||--o{ WORKS           : includes


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
