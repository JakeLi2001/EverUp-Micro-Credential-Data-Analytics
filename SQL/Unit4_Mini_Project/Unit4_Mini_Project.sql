-- Create Insurance tables

CREATE TABLE Customer(
    Customer_ID_Number CHAR(9) PRIMARY KEY,
    Customer_First_Name VARCHAR(100) NOT NULL,
    Customer_Last_Name VARCHAR(100) NOT NULL,
    Customer_Type VARCHAR(100),
    Business_Name VARCHAR (50),
    Address_Street_Name_Line_One VARCHAR(100) NOT NULL,
    Address_Street_Name_Line_Two VARCHAR(100),
    Address_City VARCHAR(50) NOT NULL,
    Address_State VARCHAR(50) NOT NULL,
    Address_Postal_Code CHAR(5) NOT NULL,
    Address_Type VARCHAR(100),
    Customer_Birth_Date DATE,
    Risk_Score INT);

CREATE TABLE Policy_Detail(
    Policy_Number CHAR(10),
    Policy_Effective_Date DATE NOT NULL,
    Policy_Expiration_Date DATE NOT NULL,
    Policy_Limit NUMERIC(10, 2) NOT NULL,
    Policy_Type VARCHAR(50) NOT NULL,
    Currency_Type VARCHAR(10) NOT NULL,
    Premium_Cost NUMERIC(10, 2),
    Customer_ID_Number CHAR(9) REFERENCES Customer(Customer_ID_Number));

CREATE TABLE Claim(
    Claim_ID_Number CHAR(10) PRIMARY KEY,
    Claim_Receipt_Date DATE NOT NULL,
    Claim_Description VARCHAR(100) NOT NULL,
    Claimant_Birth_Date DATE,
    Law_Suit_Indicator BOOLEAN,
    Claimant_First_Name VARCHAR(100) NOT NULL,
    Claimant_Last_Name VARCHAR(100) NOT NULL,
    Policy_Number CHAR(10),
    Claimant_Occupation VARCHAR(50),
    Loss_Date DATE,
    Claim_Amount NUMERIC(10, 2),
    Claim_Paid_Amount NUMERIC(10, 2),
    Claim_Paid_Date DATE);

CREATE TABLE Reserves(
    Customer_ID_Number CHAR(9) REFERENCES Customer(Customer_ID_Number),
    Policy_Number CHAR(10),
    Reserved_Amount NUMERIC(10, 2) NOT NULL,
    Reserved_Date DATE NOT NULL);

-- Populate Insurance tables with sample data

INSERT INTO Customer(Customer_ID_Number, Customer_First_Name, Customer_Last_Name, Customer_Type, Business_Name, Address_Street_Name_Line_One, Address_Street_Name_Line_Two, Address_City, Address_State, Address_Postal_Code, Address_Type, Customer_Birth_Date, Risk_Score)
VALUES('777543325', 'Mary', 'Roberts', 'Individual', '', '123 Main Street', '', 'Chicago', 'Illinois', '60007', 'Residential', '1986-03-20', 75),
      ('777543800', 'Joe', 'Smith', 'Individual', '', '123 Park Avenue', '', 'New York', 'New York', '10017', 'Residential', '1963-02-27', 70),
      ('776983401', 'Aditya', 'Reddy', 'Business', 'ABC Systems', '222 Hyde Street', 'Floor 2', 'San Francisco', 'California', '94123', 'Business', NULL, 50);

INSERT INTO Policy_Detail(Policy_Number, Policy_Effective_Date, Policy_Expiration_Date, Policy_Limit, Policy_Type, Currency_Type, Premium_Cost, Customer_ID_Number)
VALUES('P987654321', '2020-02-11', '2021-02-11', 500000, 'Automobile', 'USD', 2600, '777543800'),
      ('P987654321', '2019-02-11', '2020-02-11', 500000, 'Automobile', 'USD', 2300, '777543800'),
      ('P987654321', '2018-02-11', '2019-02-11', 500000, 'Automobile', 'USD', 2150, '777543800'),
      ('P987654321', '2017-02-11', '2018-02-11', 500000, 'Automobile', 'USD', 2100, '777543800'),
      ('P987654111', '2020-03-15', '2021-03-15', 5000000, 'Excess/Umbrella', 'USD', 5500, '777543325'),
      ('P987654222', '2020-06-15', '2020-06-15', 3000000, 'Property', 'USD', 10000, '776983401');

INSERT INTO Claim(Claim_ID_Number, Claim_Receipt_Date, Claim_Description, Claimant_Birth_Date, Law_Suit_Indicator, Claimant_First_Name, Claimant_Last_Name, Policy_Number, Claimant_Occupation, Loss_Date, Claim_Amount, Claim_Paid_Amount, Claim_Paid_Date)
VALUES('C123450000', '2020-12-05', 'Automobile accident', '1975-08-01', 'N', 'Joe', 'Smith', 'P987654321', 'Physician', '2020-12-04', 5000, NULL, NULL),
      ('C123441000', '2019-08-05', 'Automobile accident', '1975-08-01', 'N', 'Joe', 'Smith', 'P987654321', 'Physician', '2019-08-02', 7600, 7100, '2019-09-05'),
      ('C123440000', '2020-10-15', 'Robbery', '1986-03-20', 'N', 'Mary', 'Roberts', 'P987654111', 'Not provided', '2020-10-01', 25000, 20000, '2020-11-05'),
      ('C345478900', '2020-07-13', 'Property', '1990-05-27', 'N', 'Aditya', 'Reddy', 'P987654222', 'Business Owner', '2020-07-12', 10000, 8000, '2020-08-12');

INSERT INTO Reserves(Customer_ID_Number, Policy_Number, Reserved_Amount, Reserved_Date)
VALUES('777543325', 'P987654111', 5000, '2020-03-15'),
      ('776983401', 'P987654222', 7000, '2020-06-15'),
      ('777543800', 'P987654321', 1500, '2017-02-11'),
      ('777543800', 'P987654321', 1500, '2018-02-11'),
      ('777543800', 'P987654321', 1500, '2019-02-11');

-- Form any 5 SQL to extract information from tables using: Join, Where, or other conditional operators

-- 1) Join the customer and policy detail table
SELECT C.Customer_ID_Number, C.Customer_First_Name, C.Customer_Last_Name, C.Customer_Type, P.Policy_Number, P.Policy_Effective_Date, P.Policy_Expiration_Date, P.Policy_Type, P.Premium_Cost
FROM Customer AS C
LEFT JOIN Policy_Detail AS P
ON C.Customer_ID_Number = P.Customer_ID_Number;
-- 2) Find policy details where premium cost is greater than 2500
SELECT *
FROM Policy_Detail
WHERE Premium_Cost > 2500;
-- 3) Find policy details where policy expired before 2020 and policy limit is less than 1,000,000
SELECT *
FROM Policy_Detail
WHERE Policy_Expiration_Date < '2020/01/01' AND Policy_Limit < 1000000;
-- 4) Get customer detail for each claim
SELECT Customer.Customer_ID_Number, Claim.Policy_Number ,Claim.Claim_ID_Number, Customer.Customer_First_Name, Customer.Customer_Last_Name, Customer.Customer_Type, Customer.Business_Name, Customer.Address_Street_Name_Line_One, Customer.Address_Street_Name_Line_Two, Customer.Address_City, Customer.Address_State, Customer.Address_Postal_Code, Customer.Address_Type, Claim.Claim_Receipt_Date, Claim.Claim_Description
FROM Claim
INNER JOIN Customer
ON Claim.Claimant_First_Name = Customer.Customer_First_Name AND Claim.Claimant_Last_Name = Customer.Customer_Last_Name;
-- 5) Get policy detail for each reserves
SELECT P.Customer_ID_Number, P.Policy_Number, P.Policy_Effective_Date, P.Policy_Expiration_Date, P.Policy_Limit, P.Policy_Type, P.Currency_Type, P.Premium_Cost, R.Reserved_Amount
FROM Reserves AS R
LEFT JOIN Policy_Detail AS P
ON R.Reserved_Date = P.Policy_Effective_Date;