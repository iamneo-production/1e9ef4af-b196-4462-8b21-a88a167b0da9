
--Retrieve All Records 
select * 
from BANK_TRANSACTION; 
DESCRIBE BANK_TRANSACTION;

--Describe Table 
DESC BANK_TRANSACTION;

CREATE OR REPLACE PACKAGE my_constants_pkg AS
  v_regex_pattern CONSTANT VARCHAR2(100) := '^[0-9]+(\.[0-9]+)?$';
END my_constants_pkg;
/

--Query to find Highest Amount debited each year 

-- Use the constant in the query
SELECT
  MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) AS HIGHEST_DEPOSITED_AMOUNT,
  EXTRACT(YEAR FROM "DATE") AS YEAR
FROM
  BANK_TRANSACTION
WHERE
  WITHDRAWAL_AMT IS NOT NULL
  AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), my_constants_pkg.v_regex_pattern)
GROUP BY
  EXTRACT(YEAR FROM "DATE")
ORDER BY
  EXTRACT(YEAR FROM "DATE") ASC;


 -- Query to find Lowest Amount debited each year 

SELECT MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) AS LOWEST_DEPOSITED_AMOUNT, 
 EXTRACT(YEAR FROM "DATE") AS YEAR FROM BANK_TRANSACTION 
 WHERE WITHDRAWAL_AMT IS NOT NULL
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), my_constants_pkg.v_regex_pattern)
 GROUP BY EXTRACT(YEAR FROM "DATE") 
 ORDER BY EXTRACT(YEAR FROM "DATE") asc;

--query to find 5th highest withdrawal each year 
WITH processed_transactions AS (
  SELECT
    TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) AS withdrawal_amount,
    EXTRACT(YEAR FROM "DATE") AS year
  FROM
    BANK_TRANSACTION
  WHERE
    WITHDRAWAL_AMT IS NOT NULL
    AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), my_constants_pkg.v_regex_pattern)
),
ranked_transactions AS (
  SELECT
    year,
    withdrawal_amount,
    ROW_NUMBER() OVER (PARTITION BY year ORDER BY withdrawal_amount DESC) AS rnk
  FROM
    processed_transactions
)
SELECT
  year,
  withdrawal_amount AS fifth_highest_withdrawal_amount
FROM
  ranked_transactions
WHERE
  rnk = 5
ORDER BY
  year asc;

--TO check the output is individually correct and to evaluvate we use this year by year and identify accurate results 
SELECT
  TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) AS withdrawal_amount,
  EXTRACT(YEAR FROM "DATE") AS year
FROM
  BANK_TRANSACTION
WHERE
  EXTRACT(YEAR FROM "DATE") = 2018
  AND WITHDRAWAL_AMT IS NOT NULL
  AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), my_constants_pkg.v_regex_pattern)
ORDER BY
  withdrawal_amount DESC;

--Query to find Count the Withdrawal Transaction between 5-May-2018 and 7-Mar-2019 
SELECT COUNT(*) AS withdrawal_count
FROM bank_transaction
WHERE "DATE" >= TO_DATE('05-May-18', 'dd-Mon-yy') 
  AND "DATE" <= TO_DATE('07-Mar-19', 'dd-Mon-yy')
  AND WITHDRAWAL_AMT IS NOT NULL;

--Query to find the first five Largest Transaction Occured in 2018 

SELECT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) 
 AS FIRST_FIVE_HIGHEST_DEPOSITED_AMOUNT_IN_2018 FROM BANK_TRANSACTION 
 WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), my_constants_pkg.v_regex_pattern)
 ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
 OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- Query to fetch distinct account numbers
SELECT DISTINCT ACCOUNT_NO FROM BANK_TRANSACTION; 


-- Query to count number of transactions for each account number
SELECT ACCOUNT_NO, COUNT(*) AS transaction_count
FROM BANK_TRANSACTION
GROUP BY ACCOUNT_NO; 

-- Proceeding as per SRS Document 
--Creating a  branch_table 
CREATE TABLE branch_table(
  id NUMBER,
  name VARCHAR2(50),
  address VARCHAR2(50),
  PRIMARY KEY (id)
);
--Select Statement
select * from branch_table;

-- Inserting values in branch_table 
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

--Creating a  Customer table 
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

--Creating table for account 
CREATE TABLE Account (
  id NUMBER,
  customer_id NUMBER,
  card_id NUMBER,
  balance VARCHAR2(50),
  PRIMARY KEY (id),
  FOREIGN KEY (customer_id) REFERENCES Customer(id),
  FOREIGN KEY (card_id) REFERENCES Card(id)
);

--Inserting values into account table 
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


--Creating table for Card 
CREATE TABLE Card (
  id NUMBER,
  cardnumber VARCHAR2(16),
  expiration_date DATE,
  is_blocked NUMBER(1,0),
  PRIMARY KEY (id)
);

--Inserting vakues into Card 
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

--Creating table for Transaction 
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

--Creating table for Loan_Type 
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

--Creating table for Loan 
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


-- Retrieve all customers along with their branch information.

-- Solution
SELECT c.first_name, c.last_name, c.date_of_birth, c.gender, b.name AS branch_name, b.address
FROM customer c
INNER JOIN branch b ON c.branch_id = b.id;


-- Get the total number of customers for each branch.

-- Solution
SELECT b.name AS branch_name, COUNT(c.id) AS customer_count
FROM branch b
LEFT JOIN customer c ON b.id = c.branch_id
GROUP BY b.name;


-- List all accounts along with their corresponding customer and branch details.

-- Solution
SELECT a.id AS account_id, a.balance, c.first_name, c.last_name, b.name AS branch_name
FROM account a
INNER JOIN customer c ON a.customer_id = c.id
INNER JOIN branch b ON c.branch_id = b.id;

-- Retrieve the total balance of all accounts for each customer.

-- Solution
SELECT c.id AS customer_id, c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM customer c
LEFT JOIN account a ON c.id = a.customer_id
GROUP BY c.id, c.first_name, c.last_name;


-- Get the card details for customers who have a balance greater than 1000.

-- Solution
SELECT c.first_name, c.last_name, a.balance, ca.cardnumber, ca.expiration_date
FROM customer c
INNER JOIN account a ON c.id = a.customer_id
INNER JOIN card ca ON a.card_id = ca.id
WHERE a.balance > 1000;


-- Retrieve the transactions with amounts greater than 100 for a specific account.

-- Solution
SELECT t.id AS transaction_id, t.description, t.amount, t.tdate
FROM transaction t
INNER JOIN account a ON t.account_id = a.id
WHERE a.id = 1 AND t.amount > 100;


-- List all customers who have taken a loan with the loan amount and corresponding loan type.

-- Solution
SELECT c.first_name, c.last_name, l.amount_paid, lt.type
FROM customer c
INNER JOIN account a ON c.id = a.customer_id
INNER JOIN loan l ON a.id = l.account_id
INNER JOIN loan_type lt ON l.loan_type_id = lt.id;


-- Retrieve the loan details and the corresponding loan type for a specific account.

-- Solution
SELECT l.id AS loan_id, lt.type, lt.description, l.amount_paid, l.start_date, l.due_date
FROM loan l
INNER JOIN loan_type lt ON l.loan_type_id = lt.id
WHERE l.account_id = 1;

-- Get the total amount of all transactions for a specific account.

-- Solution
SELECT a.id AS account_id, a.balance, SUM(t.amount) AS total_transactions
FROM account a
LEFT JOIN transaction t ON a.id = t.account_id
WHERE a.id = 1
GROUP BY a.id, a.balance;


-- Retrieve the average balance of accounts for each branch.

-- Solution
SELECT b.name AS branch_name, AVG(a.balance) AS average_balance
FROM branch b
LEFT JOIN customer c ON b.id = c.branch_id
LEFT JOIN account a ON c.id = a.customer_id
GROUP BY b.name;

-- List all branches along with the total number of customers and their average balance.

-- Solution
SELECT b.name AS branch_name, COUNT(c.id) AS customer_count, AVG(a.balance) AS average_balance
FROM branch b
LEFT JOIN customer c ON b.id = c.branch_id
LEFT JOIN account a ON c.id = a.customer_id
GROUP BY b.name;


-- Retrieve the accounts and their corresponding card details for a specific customer.

-- Solution
SELECT a.id AS account_id, a.balance, ca.cardnumber, ca.expiration_date
FROM account a
INNER JOIN customer c ON a.customer_id = c.id
INNER JOIN card ca ON a.card_id = ca.id
WHERE c.id = 1;

-- Retrieve the transactions and their corresponding account, customer, and branch details.

-- Solution
SELECT t.id AS transaction_id, t.description, t.amount, t.tdate, a.id AS account_id, a.balance, c.first_name, c.last_name, b.name AS branch_name
FROM transaction t
INNER JOIN account a ON t.account_id = a.id
INNER JOIN customer c ON a.customer_id = c.id
INNER JOIN branch b ON c.branch_id = b.id;

-- Get the loan details for accounts that have a balance less than 1000.

-- Solution
SELECT l.id AS loan_id, l.amount_paid, l.start_date, l.due_date
FROM loan l
INNER JOIN account a ON l.account_id = a.id
WHERE a.balance < 1000;


-- Retrieve the transactions with the highest amount for each account.

-- Solution
SELECT t.id AS transaction_id, t.description, t.amount, t.tdate, a.id AS account_id, a.balance
FROM transaction t
INNER JOIN account a ON t.account_id = a.id
WHERE (t.account_id, t.amount) IN (
    SELECT account_id, MAX(amount) FROM transaction GROUP BY account_id
);


-- List all customers and their loan types for customers who have taken a loan.

-- Solution
SELECT c.first_name, c.last_name, lt.type
FROM customer c
INNER JOIN account a ON c.id = a.customer_id
INNER JOIN loan l ON a.id = l.account_id
INNER JOIN loan_type lt ON l.loan_type_id = lt.id;



-- Retrieve the card details for customers whose cards are not blocked.

-- Solution
SELECT c.first_name, c.last_name, ca.cardnumber, ca.expiration_date
FROM customer c
INNER JOIN account a ON c.id = a.customer_id
INNER JOIN card ca ON a.card_id = ca.id
WHERE ca.is_blocked = 0;



-- Get the loan types along with the total amount paid for each loan type.

-- Solution
SELECT lt.type, SUM(l.amount_paid) AS total_amount_paid
FROM loan l
INNER JOIN loan_type lt ON l.loan_type_id = lt.id
GROUP BY lt.type;


-- List all customers who have no accounts.

-- Solution
SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN account a ON c.id = a.customer_id
WHERE a.id IS NULL;


-- Retrieve the transactions with the earliest date for each account.

-- Solution
SELECT t.id AS transaction_id, t.description, t.amount, t.tdate, a.id AS account_id, a.balance
FROM transaction t
INNER JOIN account a ON t.account_id = a.id
WHERE (t.account_id, t.tdate) IN (
    SELECT account_id, MIN(tdate) FROM transaction GROUP BY account_id
);


-- Get the loan details along with the corresponding customer names.

-- Solution
SELECT l.id AS loan_id, l.amount_paid, l.start_date, l.due_date, c.first_name, c.last_name
FROM loan l
INNER JOIN account a ON l.account_id = a.id
INNER JOIN customer c ON a.customer_id = c.id;

-- Retrieve the account details along with the corresponding branch and customer information.

-- Solution
SELECT a.id AS account_id, a.balance, b.name AS branch_name, c.first_name, c.last_name
FROM account a
INNER JOIN customer c ON a.customer_id = c.id
INNER JOIN branch b ON c.branch_id = b.id;



