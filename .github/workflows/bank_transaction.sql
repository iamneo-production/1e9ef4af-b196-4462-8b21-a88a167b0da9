
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
