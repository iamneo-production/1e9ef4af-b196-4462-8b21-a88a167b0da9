
/* Retrieve All Records */
select * 
from BANK_TRANSACTION; 
DESCRIBE BANK_TRANSACTION;

/* Describe Table */ 
DESC BANK_TRANSACTION;

/* query to find 5th highest withdrawal each year */
SELECT distinct(year), withdrawal_amt
FROM (
  SELECT EXTRACT(YEAR FROM "DATE") AS year, 
         TO_NUMBER(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '')) AS withdrawal_amt,
         DENSE_RANK() OVER (PARTITION BY EXTRACT(YEAR FROM "DATE") 
                            ORDER BY TO_NUMBER(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '')) DESC) AS rn
  FROM bank_transaction
) subquery
WHERE rn = 5
order by year;

/* Query to find Highest Amount debited each year */
SELECT EXTRACT(YEAR FROM "DATE") AS year, 
       MAX(CAST(WITHDRAWAL_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS highest_debited_amount
FROM bank_transaction
GROUP BY EXTRACT(YEAR FROM "DATE")
order by year;

/* Query to find Lowest Amount debited each year */ 
SELECT EXTRACT(YEAR FROM "DATE") AS year, 
       MIN(CAST(WITHDRAWAL_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS lowest_debited_amount
FROM bank_transaction
GROUP BY EXTRACT(YEAR FROM "DATE")
order by year;

/* Query to find Count the Withdrawal Transaction between 5-May-2018 and 7-Mar-2019 */
SELECT COUNT(*) AS withdrawal_count
FROM bank_transaction
WHERE "DATE" >= TO_DATE('05-May-18', 'dd-Mon-yy') 
  AND "DATE" <= TO_DATE('07-Mar-19', 'dd-Mon-yy')
  AND WITHDRAWAL_AMT IS NOT NULL;

/* Quert to find the first five Largest Transaction Occured in 2018 */
SELECT *
FROM (
  SELECT bank_transaction.*,
         ROW_NUMBER() OVER (ORDER BY TO_NUMBER(REGEXP_REPLACE(REPLACE(WITHDRAWAL_AMT, ' ', ''), '"', '')) DESC) AS rn
  FROM BANK_TRANSACTION
  WHERE "DATE" >= TO_DATE('01-Jan-18', 'dd-Mon-yy')
    AND "DATE" < TO_DATE('01-Jan-19', 'dd-Mon-yy')
    AND WITHDRAWAL_AMT IS NOT NULL
    AND REGEXP_LIKE(REPLACE(WITHDRAWAL_AMT, ' ', ''), '^[0-9]+(\.[0-9]+)?$')
)
WHERE rn <= 5;

-- Query to fetch distinct account numbers
SELECT DISTINCT ACCOUNT_NO FROM BANK_TRANSACTION; 

-- Query to count total number of transactions
SELECT COUNT(*) AS total_transactions FROM BANK_TRANSACTION; 

/* Query to find Highest Amount deposit each year */
SELECT EXTRACT(YEAR FROM "DATE") AS year, 
       MAX(CAST(DEPOSIT_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS highest_deposited_amount
FROM bank_transaction
GROUP BY EXTRACT(YEAR FROM "DATE")
order by year;


/* Query to find Lowest Amount deposit each year */
SELECT EXTRACT(YEAR FROM "DATE") AS year, 
       MIN(CAST(DEPOSIT_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS lowest_deposited_amount
FROM bank_transaction
GROUP BY EXTRACT(YEAR FROM "DATE")
order by year;

-- Query to count number of transactions for each account number
SELECT ACCOUNT_NO, COUNT(*) AS transaction_count
FROM BANK_TRANSACTION
GROUP BY ACCOUNT_NO; 

/* Proceeding as per SRS Document */
/* Creating a  branch_table */
CREATE TABLE branch_table(
  id NUMBER,
  name VARCHAR2(50),
  address VARCHAR2(50),
  PRIMARY KEY (id)
);

/*Select Statement */
select * from branch_table;

/* Inserting values in branch_table */
INSERT ALL
  INTO branch_table (id, name, address) VALUES (1, 'Central Branch', '123 Main Street, City A')
  INTO branch_table (id, name, address) VALUES (2, 'North Branch', '456 Park Avenue, City B')
  INTO branch_table (id, name, address) VALUES (3, 'West Branch', '789 Elm Street, City C')
  INTO branch_table (id, name, address) VALUES (4, 'East Branch', '987 Oak Avenue, City D')
  INTO branch_table (id, name, address) VALUES (5, 'South Branch', '654 Pine Road, City E')
  INTO branch_table (id, name, address) VALUES (6, 'Downtown Branch', '321 Market Street, City F')
  INTO branch_table (id, name, address) VALUES (7, 'Suburban Branch', '789 Maple Lane, City G')
  INTO branch_table (id, name, address) VALUES (8, 'Metro Branch', '987 Broadway, City H')
  INTO branch_table (id, name, address) VALUES (9, 'Coastal Branch', '543 Beach Boulevard, City I')
  INTO branch_table (id, name, address) VALUES (10, 'Hillside Branch', '210 Sunset Drive, City J')
  INTO branch_table (id, name, address) VALUES (11, 'Riverside Branch', '456 River Road, City K')
  INTO branch_table (id, name, address) VALUES (12, 'Mountain Branch', '789 Summit Street, City L')
  INTO branch_table (id, name, address) VALUES (13, 'Valley Branch', '123 Valley View, City M')
  INTO branch_table (id, name, address) VALUES (14, 'Lakefront Branch', '987 Lake Avenue, City N')
  INTO branch_table (id, name, address) VALUES (15, 'Parkside Branch', '543 Park Lane, City O')
SELECT 1 FROM DUAL;

/* Creating a  Customer table */
CREATE TABLE Customer (
  id NUMBER,
  branch_id NUMBER,
  first_name VARCHAR2(50),
  last_name VARCHAR2(50),
  date_of_birth DATE,
  gender VARCHAR2(10),
  PRIMARY KEY (id),
  FOREIGN KEY (branch_id) REFERENCES branch_table(id)
);


INSERT ALL
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (1, 1, 'John', 'Doe', TO_DATE('1980-01-01', 'YYYY-MM-DD'), 'Male')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (2, 1, 'Jane', 'Smith', TO_DATE('1992-05-15', 'YYYY-MM-DD'), 'Female')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (3, 2, 'Michael', 'Johnson', TO_DATE('1975-09-21', 'YYYY-MM-DD'), 'Male')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (4, 2, 'Emily', 'Davis', TO_DATE('1988-12-10', 'YYYY-MM-DD'), 'Female')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (5, 3, 'Daniel', 'Wilson', TO_DATE('1995-07-08', 'YYYY-MM-DD'), 'Male')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (6, 3, 'Olivia', 'Thomas', TO_DATE('1982-03-25', 'YYYY-MM-DD'), 'Female')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (7, 4, 'Matthew', 'Lee', TO_DATE('1990-09-18', 'YYYY-MM-DD'), 'Male')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (8, 4, 'Sophia', 'Harris', TO_DATE('1985-06-12', 'YYYY-MM-DD'), 'Female')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (9, 5, 'William', 'Martin', TO_DATE('1979-02-14', 'YYYY-MM-DD'), 'Male')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (10, 5, 'Ava', 'Clark', TO_DATE('1993-11-07', 'YYYY-MM-DD'), 'Female')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (11, 6, 'James', 'Walker', TO_DATE('1984-08-22', 'YYYY-MM-DD'), 'Male')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (12, 6, 'Mia', 'Anderson', TO_DATE('1997-04-29', 'YYYY-MM-DD'), 'Female')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (13, 7, 'Benjamin', 'Lopez', TO_DATE('1986-12-03', 'YYYY-MM-DD'), 'Male')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (14, 7, 'Charlotte', 'Gonzalez', TO_DATE('1991-03-16', 'YYYY-MM-DD'), 'Female')
  INTO Customer (id, branch_id, first_name, last_name, date_of_birth, gender)
  VALUES (15, 8, 'Henry', 'Martinez', TO_DATE('1978-10-27', 'YYYY-MM-DD'), 'Male')
SELECT 1 FROM DUAL;

select * from Customer;

/*Creating table for account */
CREATE TABLE Account (
  id NUMBER,
  customer_id NUMBER,
  card_id NUMBER,
  balance VARCHAR2(50),
  PRIMARY KEY (id),
  FOREIGN KEY (customer_id) REFERENCES Customer(id),
  FOREIGN KEY (card_id) REFERENCES Card(id)
);

/*Inserting values into account table */
INSERT ALL
  INTO account (id, customer_id, card_id, balance)
  VALUES (1, 1, 101, '1000.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (2, 2, 102, '500.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (3, 3, 103, '2500.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (4, 4, 104, '1500.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (5, 5, 105, '2000.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (6, 6, 106, '3000.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (7, 7, 107, '750.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (8, 8, 108, '1200.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (9, 9, 109, '2200.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (10, 10, 110, '1800.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (11, 11, 111, '3000.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (12, 12, 112, '2500.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (13, 13, 113, '1200.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (14, 14, 114, '2800.00')
  INTO account (id, customer_id, card_id, balance)
  VALUES (15, 15, 115, '3500.00')
SELECT 1 FROM DUAL;


/* Creating table for Card */
CREATE TABLE Card (
  id NUMBER,
  cardnumber VARCHAR2(16),
  expiration_date DATE,
  is_blocked NUMBER(1,0),
  PRIMARY KEY (id)
);

/*Inserting vakues into Card */
INSERT ALL
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (101, '1111222233334444', TO_DATE('2025-12-31', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (102, '2222333344445555', TO_DATE('2024-10-31', 'YYYY-MM-DD'), 1)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (103, '3333444455556666', TO_DATE('2023-09-30', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (104, '4444555566667777', TO_DATE('2025-05-31', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (105, '5555666677778888', TO_DATE('2024-12-31', 'YYYY-MM-DD'), 1)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (106, '6666777788889999', TO_DATE('2025-11-30', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (107, '7777888899990000', TO_DATE('2023-10-31', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (108, '8888999900001111', TO_DATE('2024-06-30', 'YYYY-MM-DD'), 1)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (109, '9999000011112222', TO_DATE('2025-08-31', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (110, '1234123412341234', TO_DATE('2024-09-30', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (111, '2345234523452345', TO_DATE('2025-11-30', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (112, '3456345634563456', TO_DATE('2023-12-31', 'YYYY-MM-DD'), 1)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (113, '4567456745674567', TO_DATE('2025-01-31', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (114, '5678567856785678', TO_DATE('2023-07-31', 'YYYY-MM-DD'), 0)
  INTO card (id, cardnumber, expiration_date, is_blocked)
  VALUES (115, '6789678967896789', TO_DATE('2024-02-28', 'YYYY-MM-DD'), 1)
SELECT 1 FROM DUAL;

/*Creating table for Transaction */
CREATE TABLE Transaction (
  id NUMBER,
  account_id NUMBER,
  description VARCHAR2(255),
  amount NUMBER,
  tdate DATE,
  PRIMARY KEY (id),
  FOREIGN KEY (account_id) REFERENCES Account(id)
);

-- Insert into transaction
INSERT ALL
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (1, 1, 'Deposit', '500.00', TO_DATE('2023-07-01', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (2, 1, 'Withdrawal', '200.00', TO_DATE('2023-07-05', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (3, 2, 'Deposit', '1000.00', TO_DATE('2023-07-02', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (4, 2, 'Transfer', '500.00', TO_DATE('2023-07-03', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (5, 3, 'Withdrawal', '300.00', TO_DATE('2023-07-04', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (6, 3, 'Deposit', '800.00', TO_DATE('2023-07-06', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (7, 4, 'Transfer', '100.00', TO_DATE('2023-07-01', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (8, 4, 'Withdrawal', '50.00', TO_DATE('2023-07-02', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (9, 5, 'Deposit', '700.00', TO_DATE('2023-07-03', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (10, 5, 'Withdrawal', '150.00', TO_DATE('2023-07-05', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (11, 6, 'Deposit', '400.00', TO_DATE('2023-07-06', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (12, 6, 'Transfer', '200.00', TO_DATE('2023-07-07', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (13, 7, 'Withdrawal', '80.00', TO_DATE('2023-07-01', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (14, 7, 'Deposit', '300.00', TO_DATE('2023-07-03', 'YYYY-MM-DD'))
  INTO transaction (id, account_id, description, amount, tdate)
  VALUES (15, 8, 'Transfer', '100.00', TO_DATE('2023-07-06', 'YYYY-MM-DD'))
SELECT 1 FROM DUAL;

/*Creating table for Loan_Type */
CREATE TABLE Loan_Type (
  id NUMBER,
  type VARCHAR2(50),
  description VARCHAR2(255),
  base_amount DECIMAL(10,0),
  base_interest_rate DECIMAL(10,0),
  PRIMARY KEY (id)
);

-- Insert into loan_type
INSERT ALL
  INTO loan_type (id, type, description, base_amount, base_interest_rate)
  VALUES (1, 'Personal Loan', 'Short-term loan for personal use', 5000, 5.5)
  INTO loan_type (id, type, description, base_amount, base_interest_rate)
  VALUES (2, 'Home Loan', 'Loan for purchasing a house', 200000, 3.75)
  INTO loan_type (id, type, description, base_amount, base_interest_rate)
  VALUES (3, 'Auto Loan', 'Loan for purchasing a car', 30000, 4.25)
  INTO loan_type (id, type, description, base_amount, base_interest_rate)
  VALUES (4, 'Education Loan', 'Loan for educational expenses', 10000, 6.0)
  INTO loan_type (id, type, description, base_amount, base_interest_rate)
  VALUES (5, 'Business Loan', 'Loan for financing a business', 50000, 7.5)
SELECT 1 FROM DUAL;

/*Creating table for Loan */
CREATE TABLE Loan (
  id NUMBER,
  account_id NUMBER,
  loan_type_id NUMBER,
  amount_paid DECIMAL(10,0),
  start_date DATE,
  due_date DATE,
  PRIMARY KEY (id),
  FOREIGN KEY (account_id) REFERENCES Account(id),
  FOREIGN KEY (loan_type_id) REFERENCES Loan_Type(id)
);


-- Insert into loan
INSERT ALL
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (1, 1, 1, 1000, TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (2, 2, 2, 20000, TO_DATE('2023-07-02', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (3, 3, 3, 15000, TO_DATE('2023-07-05', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (4, 4, 4, 5000, TO_DATE('2023-07-10', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (5, 5, 5, 10000, TO_DATE('2023-07-15', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (6, 6, 1, 500, TO_DATE('2023-07-20', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (7, 7, 2, 10000, TO_DATE('2023-07-25', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (8, 8, 3, 8000, TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (9, 9, 4, 3000, TO_DATE('2023-07-02', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (10, 10, 5, 5000, TO_DATE('2023-07-05', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (11, 11, 1, 100, TO_DATE('2023-07-10', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (12, 12, 2, 15000, TO_DATE('2023-07-15', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (13, 13, 3, 12000, TO_DATE('2023-07-20', 'YYYY-MM-DD'), TO_DATE('2024-03-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (14, 14, 4, 4000, TO_DATE('2023-07-25', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'))
  INTO loan (id, account_id, loan_type_id, amount_paid, start_date, due_date)
  VALUES (15, 15, 5, 7000, TO_DATE('2023-07-01', 'YYYY-MM-DD'), TO_DATE('2024-06-30', 'YYYY-MM-DD'))
SELECT 1 FROM DUAL;

--Inner join between customer and account tables to get account details of customers:

SELECT c.first_name, c.last_name, a.balance
FROM customer c
INNER JOIN account a ON c.id = a.customer_id;

--Left join between branch_table and customer tables to get all branches and customers (if any) associated with each branch:

SELECT b.name AS branch_name, c.first_name, c.last_name
FROM branch_table b
LEFT JOIN customer c ON b.id = c.branch_id;

--Right join between branch_table and customer tables to get all customers and their corresponding branch (if any):

SELECT b.name AS branch_name, c.first_name, c.last_name
FROM branch_table b
RIGHT JOIN customer c ON b.id = c.branch_id;

--Full outer join between customer and account tables to get all customers and their account details (if any) regardless of the relationship:

SELECT c.first_name, c.last_name, a.balance
FROM customer c
FULL OUTER JOIN account a ON c.id = a.customer_id;

--Inner join between customer and loan tables to get loans taken by customers:

SELECT c.first_name, c.last_name, l.amount_paid
FROM customer c
INNER JOIN loan l ON c.id = l.account_id;

--Left join between account and transaction tables to get all accounts and their transactions (if any):

SELECT a.id AS account_id, a.balance, t.description, t.amount
FROM account a
LEFT JOIN transaction t ON a.id = t.account_id;

--Right join between account and transaction tables to get all transactions and their corresponding account (if any):

SELECT a.id AS account_id, a.balance, t.description, t.amount
FROM account a
RIGHT JOIN transaction t ON a.id = t.account_id;

--Full outer join between account and transaction tables to get all accounts and their transactions, including unmatched records from both tables:

SELECT a.id AS account_id, a.balance, t.description, t.amount
FROM account a
FULL OUTER JOIN transaction t ON a.id = t.account_id;

--Inner join between customer, account, and card tables to get account details along with card information for each customer:

SELECT c.first_name, c.last_name, a.balance, ca.cardnumber
FROM customer c
INNER JOIN account a ON c.id = a.customer_id
INNER JOIN card ca ON a.card_id = ca.id;

--Left join between customer, account, and card tables to get all customers and their account details, with card information if available:

SELECT c.first_name, c.last_name, a.balance, ca.cardnumber
FROM customer c
LEFT JOIN account a ON c.id = a.customer_id
LEFT JOIN card ca ON a.card_id = ca.id;

--Inner join between branch_table, customer, and account tables to get all accounts and their corresponding branch and customer details:

SELECT b.name AS branch_name, c.first_name, c.last_name, a.balance
FROM branch_table b
INNER JOIN customer c ON b.id = c.branch_id
INNER JOIN account a ON c.id = a.customer_id;

--Inner join between customer, account, and loan tables to get customers who have both accounts and loans:

SELECT c.first_name, c.last_name
FROM customer c
INNER JOIN account a ON c.id = a.customer_id
INNER JOIN loan l ON a.id = l.account_id;

--Left join between loan and loan_type tables to get all loans along with their loan types (if available):

SELECT l.id AS loan_id, lt.type, lt.description, l.amount_paid
FROM loan l
LEFT JOIN loan_type lt ON l.loan_type_id = lt.id;

--Right join between loan and loan_type tables to get all loan types along with loans (if available):

SELECT l.id AS loan_id, lt.type, lt.description, l.amount_paid
FROM loan l
RIGHT JOIN loan_type lt ON l.loan_type_id = lt.id;

--Full outer join between loan and loan_type tables to get all loans and their loan types, including unmatched records from both tables:

SELECT l.id AS loan_id, lt.type, lt.description, l.amount_paid
FROM loan l
FULL OUTER JOIN loan_type lt ON l.loan_type_id = lt.id;

--Inner join between account, transaction, and card tables to get transactions associated with each account and their card information:

SELECT a.id AS account_id, a.balance, t.description, t.amount, ca.cardnumber
FROM account a
INNER JOIN transaction t ON a.id = t.account_id
INNER JOIN card ca ON a.card_id = ca.id;

-- Left join between account, transaction, and card tables to get all accounts and their transactions, with card information if available:

SELECT a.id AS account_id, a.balance, t.description, t.amount, ca.cardnumber
FROM account a
LEFT JOIN transaction t ON a.id = t.account_id
LEFT JOIN card ca ON a.card_id = ca.id;

--Inner join between customer, account, transaction, and loan tables to get customers who have both accounts and loans, along with their transactions:

SELECT c.first_name, c.last_name, a.id AS account_id, a.balance, t.description, t.amount
FROM customer c
INNER JOIN account a ON c.id = a.customer_id
INNER JOIN transaction t ON a.id = t.account_id
INNER JOIN loan l ON a.id = l.account_id;

--Left join between branch_table, customer, account, and transaction tables to get all customers and their transactions, along with their branch information:

SELECT b.name AS branch_name, c.first_name, c.last_name, t.description, t.amount
FROM branch_table b
LEFT JOIN customer c ON b.id = c.branch_id
LEFT JOIN account a ON c.id = a.customer_id
LEFT JOIN transaction t ON a.id = t.account_id;

--Full outer join between branch_table, customer, account, and transaction tables to get all branches, customers, accounts, and transactions, including unmatched records from all tables:

SELECT b.name AS branch_name, c.first_name, c.last_name, a.id AS account_id, a.balance, t.description, t.amount
FROM branch_table b
FULL OUTER JOIN customer c ON b.id = c.branch_id
FULL OUTER JOIN account a ON c.id = a.customer_id
FULL OUTER JOIN transaction t ON a.id = t.account_id;




