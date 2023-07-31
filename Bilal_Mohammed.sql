DEFINE BIL = ''^[0-9]+(\.[0-9]+)?$'';
DEFINE BIL;
-- WORKSPACE QUERIES BANK_TRANSACTION QUERIES

--(1). Query to find Highest Amount debited from the bank in each year.

   SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))
   AS HIGHEST_DEBITED_AMOUNT_IN_THE_YEAR FROM BANK_TRANSACTION
   WHERE WITHDRAWAL_AMT IS NOT NULL
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &BIL)
   GROUP BY EXTRACT(YEAR FROM "DATE")
   ORDER BY EXTRACT(YEAR FROM "DATE") ASC;

--(2). Query to find Lowest amount debited from the bank in each year.

   SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))
   AS LOWEST_DEBITED_AMOUNT_IN_THE_YEAR FROM BANK_TRANSACTION
   WHERE WITHDRAWAL_AMT IS NOT NULL
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &BIL)
   GROUP BY EXTRACT(YEAR FROM "DATE")
   ORDER BY EXTRACT(YEAR FROM "DATE") ASC;

--(3). Query to find the 5th Highest Withdrawal amount at each year.

   WITH HIGH_TRANSACTIONS_IN_THE_YEAR AS(
      SELECT TO_NUMBER(TRIM(' ' FROM REPLACE(WITHDRAWAL_AMT, '"',''))) AS WITHDRAWAL_AMOUNT,
      EXTRACT(YEAR FROM "DATE") AS YEAR FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL AND
      REGEXP_LIKE(TRIM(' ' FROM REPLACE(WITHDRAWAL_AMT, '"','')), &BIL)
   ),
   FIFTH_HIGHEST_TRANSACTION_IN_THE_YEAR AS (
      SELECT YEAR, WITHDRAWAL_AMOUNT, ROW_NUMBER() OVER (PARTITION BY YEAR ORDER BY WITHDRAWAL_AMOUNT DESC) AS F_H_T
      FROM HIGH_TRANSACTIONS_IN_THE_YEAR
   )
   SELECT YEAR, WITHDRAWAL_AMOUNT AS FIFTH_HIGHEST_WITHDRAWAL_AMOUNT FROM FIFTH_HIGHEST_TRANSACTION_IN_THE_YEAR
   WHERE F_H_T=5 ORDER BY YEAR ASC;


--(4). Query to count the withdrawal transactions between May 5 2018, and March 7 2019.

   SELECT COUNT(WITHDRAWAL_AMT) AS COUNT_OF_WITHDRAWAL_AMT FROM BANK_TRANSACTION
   WHERE "DATE" BETWEEN '05-MAY-18' AND '07-MAR-19'
   AND WITHDRAWAL_AMT IS NOT NULL;


--(5). Query to Find the First five largest Withdrawal transactions are occured in year 18.

   SELECT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))
   AS FIRST_FIVE_LARGEST_TRANSACTIONS_IN_2018 FROM BANK_TRANSACTION
   WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &BIL)
   ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
   OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
