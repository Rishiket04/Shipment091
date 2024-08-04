CREATE DATABASE ShipMate;
USE ShipMate;
-- drop database ShipMate;
CREATE TABLE Customer (
    CustomerID VARCHAR(6) CHECK(CustomerID LIKE 'C%') PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    street VARCHAR(20) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    BillingMethod VARCHAR(255) NOT NULL
);

CREATE TABLE Account (
    AccountID INT PRIMARY KEY,
    AccountNumber VARCHAR(20) NOT NULL,
    CustomerID VARCHAR(6) CHECK(CustomerID  LIKE 'C%') NOT NULL ,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) on delete cascade
);

CREATE TABLE CreditCard (
    CardNumber BIGINT PRIMARY KEY,
    CustomerID VARCHAR(6) CHECK(CustomerID  LIKE 'C%') NOT NULL,
    ExpirationDate DATE NOT NULL,
    SecurityCode INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) on delete cascade
);

CREATE TABLE Employee (
    EmployeeID VARCHAR(6) CHECK(EmployeeID  LIKE 'E%') PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Role VARCHAR(255) NOT NULL
);

CREATE TABLE Warehouse (
    WarehouseID VARCHAR(6) CHECK(WarehouseID LIKE 'W%') PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(255) NOT NULL
);

CREATE TABLE Truck (
    TruckID VARCHAR(6) CHECK(TruckID LIKE 'T%') PRIMARY KEY,
    PlateNumber VARCHAR(20) NOT NULL,
    Capacity DECIMAL(10,2) NOT NULL,
    EmployeeID VARCHAR(6) ,
    WarehouseID VARCHAR(6) ,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) on delete set null , 
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID) on delete set null 
);

CREATE TABLE Plane (
    PlaneID VARCHAR(6) CHECK(PlaneID LIKE 'Pl%') PRIMARY KEY,
    TailNumber VARCHAR(20) NOT NULL,
    Capacity DECIMAL(10,2) NOT NULL,
    EmployeeID VARCHAR(6) ,
    WarehouseID VARCHAR(6) ,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) on delete set null,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID) on delete set null
);

CREATE TABLE Package (
    PackageID VARCHAR(6) CHECK(PackageID LIKE 'P%'),
    Type VARCHAR(255) NOT NULL,
    Weight DECIMAL(10,2) NOT NULL,
    DeliveryTime DATETIME NOT NULL,
    Status VARCHAR(255) NOT NULL,
    AccountID INT,
    CreditCardNumber BIGINT,
    EmployeeID VARCHAR(6) ,
    TruckID VARCHAR(6) ,
    PlaneID VARCHAR(6) ,
    WarehouseID VARCHAR(6) ,
    PRIMARY KEY(PackageID),
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID) on delete set null,
    FOREIGN KEY (CreditCardNumber) REFERENCES CreditCard(CardNumber) on delete set null,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) on delete set null,
    FOREIGN KEY (TruckID) REFERENCES Truck(TruckID) on delete set null,
    FOREIGN KEY (PlaneID) REFERENCES Plane(PlaneID) on delete set null,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID) on delete set null
);

CREATE TABLE Orders (
    PackageID VARCHAR(6) ,
    SenderID VARCHAR(6) ,
    ReceiverID VARCHAR(6),
    ShippingDate DATETIME,
    ShippingCost DECIMAL(10,2),
    PromisedTime DATETIME,
    FOREIGN KEY (SenderID) REFERENCES Customer(CustomerID) ,
    FOREIGN KEY (ReceiverID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID) ,
    PRIMARY KEY (PackageID, SenderID, ReceiverID)
);

CREATE TABLE loc_of_pkg (
		PackageID VARCHAR(6) CHECK(PackageID LIKE 'P%'),
		WarehouseID VARCHAR(6) CHECK(WarehouseID LIKE 'W%'),
        Start_timestamp DATETIME,
        End_timestamp DATETIME,
        FOREIGN KEY (PackageID) REFERENCES Package(PackageID) on delete cascade,
		FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID) on delete cascade,
        PRIMARY KEY (PackageID,WarehouseID)
);

CREATE TABLE Works (
	EmployeeID VARCHAR(6) ,
    TruckID VARCHAR(6) ,
    PlaneID VARCHAR(6) ,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) on delete cascade,
	FOREIGN KEY (TruckID) REFERENCES Truck(TruckID) on delete cascade,
    FOREIGN KEY (PlaneID) REFERENCES Plane(PlaneID) on delete cascade,
    PRIMARY KEY (EmployeeID)
);
        
        
        
INSERT INTO Customer (CustomerID, Name, street, Address, Phone, Email, BillingMethod)
VALUES
    ('C101', 'John Smith', 'Main St', '123 Main St, Springfield, IL, USA', '555-1234', 'johnsmith@example.com', 'Credit Card'),
    ('C102', 'Emily Johnson', 'Elm St', '456 Elm St, Chicago, IL, USA', '555-5678', 'emilyjohnson@example.com', 'Invoice'),
    ('C103', 'Michael Williams', 'Oak St', '789 Oak St, New York, NY, USA', '555-9876', 'michaelwilliams@example.com', 'Credit Card'),
    ('C104', 'Emma Jones', 'Maple St', '321 Maple St, Los Angeles, CA, USA', '555-4321', 'emmajones@example.com', 'Invoice'),
    ('C105', 'Daniel Brown', 'Cedar St', '555 Cedar St, Miami, FL, USA', '555-1111', 'danielbrown@example.com', 'Credit Card');

INSERT INTO Account (AccountID, AccountNumber, CustomerID)
VALUES
    (201, 'A12345', 'C101'),
    (202, 'B67890', 'C102'),
    (203, 'C24680', 'C103'),
    (204, 'D13579', 'C104'),
    (205, 'E97531', 'C105');

INSERT INTO CreditCard (CardNumber, CustomerID, ExpirationDate, SecurityCode)
VALUES
    ('1234567890123456', 'C101', '2025-12-31', '123'),
    ('2345678901234567', 'C102', '2024-10-31', '456'),
    ('3456789012345678', 'C103', '2023-05-31', '789'),
    ('4567890123456789', 'C104', '2024-03-31', '321'),
    ('5678901234567890', 'C105', '2025-08-31', '654');

INSERT INTO Employee (EmployeeID, Name, Address, Phone, Email, Role)
VALUES
    ('E301', 'James Miller', '10 Business Blvd, Springfield, IL, USA', '555-1111', 'jamesmiller@example.com', 'Manager'),
    ('E302', 'Sophia Davis', '20 Service St, Chicago, IL, USA', '555-2222', 'sophiadavis@example.com', 'Driver'),
    ('E303', 'William Wilson', '30 Logistics Ln, New York, NY, USA', '555-3333', 'williamwilson@example.com', 'Warehouse Manager'),
    ('E304', 'Olivia Taylor', '40 Distribution Dr, Los Angeles, CA, USA', '555-4444', 'oliviataylor@example.com', 'Clerk'),
    ('E305', 'Benjamin Anderson', '50 Delivery Rd, Miami, FL, USA', '555-5555', 'benjaminanderson@example.com', 'Driver');

INSERT INTO Warehouse (WarehouseID, Address, Phone, Email)
VALUES
    ('W401', '123 Main St, Springfield, IL, USA', '555-1234', 'warehouse1@example.com'),
    ('W402', '456 Elm St, Chicago, IL, USA', '555-5678', 'warehouse2@example.com'),
    ('W403', '789 Oak St, New York, NY, USA', '555-9876', 'warehouse3@example.com'),
    ('W404', '321 Maple St, Los Angeles, CA, USA', '555-4321', 'warehouse4@example.com'),
    ('W405', '555 Cedar St, Miami, FL, USA', '555-1111', 'warehouse5@example.com');

INSERT INTO Truck (TruckID, PlateNumber, Capacity, EmployeeID, WarehouseID)
VALUES
    ('T1721', 'ABC123', '5000.00', 'E301', 'W401'),
    ('T1722', 'XYZ789', '6000.00', 'E305', 'W405'),
    ('T1723', 'DEF456', '5500.00', 'E301', 'W402'),
    ('T1724', 'GHI789', '7000.00', 'E305', 'W404'),
    ('T1725', 'JKL012', '4500.00', 'E305', 'W403');

INSERT INTO Plane (PlaneID, TailNumber, Capacity, EmployeeID, WarehouseID)
VALUES
    ('Pl101', 'ABC123', '5000.00', 'E301', 'W401'),
    ('Pl102', 'XYZ789', '6000.00', 'E305', 'W405'),
    ('Pl103', 'DEF456', '5500.00', 'E301', 'W402'),
    ('Pl104', 'GHI789', '7000.00', 'E305', 'W404'),
    ('Pl105', 'JKL012', '4500.00', 'E305', 'W403');

INSERT INTO Package (PackageID, Type, Weight, DeliveryTime, Status, AccountID, CreditCardNumber, EmployeeID, TruckID, PlaneID, WarehouseID)
VALUES
    ('P1001', 'Box', '10.5', '2024-04-01 10:00:00', 'Delivered', '201', '1234567890123456', 'E301', 'T1721', 'Pl101', 'W401'),
    ('P1002', 'Envelope', '5.2', '2024-04-02 15:00:00', 'Delivered', '202', '2345678901234567', 'E305', 'T1722', 'Pl102', 'W405'),
    ('P1003', 'Box', '8.8', '2024-04-03 12:30:00', 'Delivered', '203', '3456789012345678', 'E301', 'T1723', 'Pl103', 'W402'),
    ('P1004', 'Package', '12.0', '2024-04-04 09:45:00', 'In Transit', '204', '4567890123456789', 'E305', 'T1724', 'Pl104', 'W404'),
    ('P1005', 'Crate', '3.5', '2024-04-05 14:00:00', 'In Transit', '205', '5678901234567890', 'E301', 'T1721', 'Pl105', 'W403');

INSERT INTO Orders (PackageID, SenderID, ReceiverID, ShippingDate, ShippingCost, PromisedTime)
VALUES
    ('P1001', 'C101', 'C103', '2024-04-01 10:00:00', 2525.00, '2024-04-04 12:00:00'),
    ('P1002', 'C102', 'C104', '2023-04-02 15:00:00', 250.00, '2023-04-03 18:00:00'),
    ('P1003', 'C103', 'C105', '2024-03-03 12:30:00', 2000.00, '2024-04-06 10:00:00'),
    ('P1004', 'C104', 'C105', '2024-04-04 09:45:00', 3030.00, '2024-04-07 14:00:00'),
    ('P1005', 'C105', 'C102', '2023-04-05 14:00:00', 4215.00, '2023-04-08 16:00:00');

INSERT INTO loc_of_pkg (PackageID, WarehouseID, Start_timestamp, End_timestamp)
VALUES 
    ('P1001', 'W401', '2024-04-20 10:00:00', '2024-04-20 12:00:00'),
    ('P1002', 'W402', '2024-04-19 15:30:00', '2024-04-19 18:00:00'),
    ('P1003', 'W401', '2024-04-18 09:00:00', '2024-04-18 11:30:00'),
    ('P1004', 'W403', '2024-04-17 14:00:00', '2024-04-17 16:30:00'),
    ('P1001', 'W402', '2024-04-30 10:00:00', '2024-05-05 12:00:00'),
    ('P1002', 'W401', '2024-04-21 15:30:00', '2024-04-25 16:00:00'),
    ('P1005', 'W402', '2024-04-16 11:45:00', '2024-04-16 13:30:00');

INSERT INTO Works (EmployeeID, TruckID, PlaneID)
VALUES 
    ('E301', 'T1721', 'Pl101'),
    ('E302', 'T1725', 'Pl102'),
    ('E303', 'T1724', 'Pl104'),
    ('E304', 'T1723', 'Pl103'),
    ('E305', 'T1722', 'Pl105');



select * from Package;
-- Queries

-- 1.a
SELECT DISTINCT Customer.Name, Customer.Address
FROM Package
JOIN Orders ON Package.PackageID = Orders.PackageID
JOIN customer ON customer.CustomerID = Orders.SenderID
WHERE Package.TruckID = 'T1721' and Package.Status <> 'Delivered';

-- 1.b
SELECT DISTINCT customer.Name, customer.Address
FROM Package
JOIN Orders ON Package.PackageID = Orders.PackageID
JOIN customer ON customer.CustomerID= Orders.ReceiverID
WHERE Package.TruckID = 'T1721';

-- 1.c
SELECT MAX(DeliveryTime),PackageID
FROM Package
where TruckID = 'T1721' AND Status = 'Delivered'
group by packageID;

-- 2
SELECT Customer.Name, COUNT(Package.PackageID)
FROM Package
JOIN orders ON Package.PackageID = orders.PackageID
JOIN customer ON customer.customerID= orders.senderID
WHERE year(orders.ShippingDate) = year(date_sub(curdate(),interval 1 year))
GROUP BY Customer.Name
ORDER BY COUNT(Package.PackageID) DESC
LIMIT 1;

-- 3
SELECT Customer.Name, SUM(orders.ShippingCost)
FROM Package
JOIN orders ON Package.packageID = orders.packageID
JOIN customer on customer.customerID= orders.senderID
WHERE year(orders.ShippingDate) = year(date_sub(curdate(),interval 1 year))
GROUP BY Customer.Name
ORDER BY SUM(orders.ShippingCost) DESC
LIMIT 1;

-- 4
SELECT street, COUNT(CustomerID)
FROM Customer
GROUP BY street
ORDER BY COUNT(CustomerID) DESC
LIMIT 1;

-- 5
SELECT package.PackageID, DeliveryTime, PromisedTime
FROM package
JOIN orders on orders.packageID= package.packageID
WHERE package.DeliveryTime > orders.PromisedTime;

-- 6.a
SELECT Customer.Name, Customer.Address, SUM(orders.ShippingCost)
FROM orders
JOIN Customer ON orders.senderID = Customer.CustomerID
WHERE month(orders.ShippingDate) = month(date_sub(curdate(),interval 1 month))
GROUP BY Customer.Name, Customer.Address;

-- 6.b
SELECT Customer.Name, Package.Type, SUM(orders.ShippingCost)
FROM Package
JOIN orders ON Package.packageID = orders.packageID
JOIN customer ON customer.customerID = orders.senderID
WHERE month(orders.ShippingDate) = month(date_sub(curdate(),interval 1 month))
GROUP BY Customer.Name, Package.Type;

-- 6.c
SELECT Customer.Name, Package.PackageID,Package.Type, orders.ShippingDate, orders.ShippingCost
FROM Package
JOIN orders ON Package.packageID = orders.packageID
JOIN customer on customer.customerID = orders.senderID
WHERE month(orders.ShippingDate) = month(date_sub(curdate(),interval 1 month));