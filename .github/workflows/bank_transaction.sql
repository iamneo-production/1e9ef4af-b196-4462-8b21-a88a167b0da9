
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