-- WORKSPACE QUERIES - BANK_TRANSACTION QUERIES --

/* (1). Query to find Highest Amount debited from the bank
         in each year*/

   SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))
   AS HIGHEST_DEBITED_AMOUNT FROM BANK_TRANSACTION 
   WHERE WITHDRAWAL_AMT IS NOT NULL
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
   GROUP BY EXTRACT(YEAR FROM "DATE") 
   ORDER BY EXTRACT(YEAR FROM "DATE");

/*(2). Query to find Lowest amount debited from the bank 
        in each year*/

   SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) 
   AS LOWEST_DEBITED_AMOUNT FROM BANK_TRANSACTION 
   WHERE WITHDRAWAL_AMT IS NOT NULL
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
   GROUP BY EXTRACT(YEAR FROM "DATE") 
   ORDER BY EXTRACT(YEAR FROM "DATE"); 

/*(3). Query to find the 5th Highest Withdrawal amount 
        at each year*/

   WITH HIGH_TRANSACTIONS AS(
      SELECT TO_NUMBER(TRIM(' ' FROM REPLACE(WITHDRAWAL_AMT, '"',''))) AS WITHDRAWAL_AMT, 
      EXTRACT(YEAR FROM "DATE") AS YEAR FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL AND 
      REGEXP_LIKE(TRIM(' ' FROM REPLACE(WITHDRAWAL_AMT, '"','')), '^[0-9]+(\.[0-9]+)?$')
   ), 
   FIFTH_HIGH_TRANSACTION AS (
      SELECT YEAR, WITHDRAWAL_AMT, ROW_NUMBER() OVER (PARTITION BY YEAR ORDER BY WITHDRAWAL_AMT DESC) AS FHT 
      FROM HIGH_TRANSACTIONS
   ) 
   SELECT YEAR, WITHDRAWAL_AMT AS FIFTH_HIGHEST_WITHDRAWAL_AMT_OF_YEAR FROM FIFTH_HIGH_TRANSACTION 
   WHERE FHT=5 ORDER BY YEAR;


/*(4). Query to count the withdrawal transactions 
        between May 5 2018, and March 7 2019*/

   SELECT COUNT(WITHDRAWAL_AMT) FROM BANK_TRANSACTION 
   WHERE "DATE" BETWEEN '05-MAY-18' AND '07-MAR-19'
   AND WITHDRAWAL_AMT IS NOT NULL; 


/*(5). Query to Find the First five largest Withdrawal transactions are occured 
         in year 18*/

   SELECT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) 
   AS FIRST_FIVE_LARGEST_TRANSACTIONS_IN_2018 FROM BANK_TRANSACTION 
   WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
   ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
   OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY; 


-----PRACTISE WORK FOR ABOVE QUERIES-----

/*1. Query to find Highest Amount debited from the bank 
       in each year*/
SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
        MAX(CAST(WITHDRAWAL_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS highest_debited_amount 
FROM bank_transaction 
GROUP BY EXTRACT(YEAR FROM "DATE")
ORDER BY YEAR;

/*2. Query to find Lowest amount debited from the bank 
       in each year*/
SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
        MIN(CAST(WITHDRAWAL_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS lowest_debited_amount 
FROM bank_transaction 
GROUP BY EXTRACT(YEAR FROM "DATE")
ORDER BY YEAR;

/*3. Query to find the 5th Highest Withdrawal amount 
      at each year*/
SELECT distinct(year), withdrawal_amt
FROM(
  SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
         TO_NUMBER(REGEXP_REPLACE(WITHDRAWAL_AMT,'[^0-9.]','')) AS withdrawal_amt,
         DENSE_RANK() OVER (PARTITION BY EXTRACT(YEAR FROM "DATE")
                            ORDER BY TO_NUMBER(REGEXP_REPLACE(WITHDRAWAL_AMT,'[^0-9.]','')) DESC) AS rn
  FROM bank_transaction 
) subquery
WHERE rn = 5
order by year;


/*4. Query to count the withdrawal transactions 
      between May 5 2018, and March 7 2019*/
SELECT COUNT(*) AS withdrawal_count
FROM BANK_TRANSACTION
WHERE "DATE" >= TO_DATE('05-May-18', 'dd-Mon-yy')
  AND "DATE" <= TO_DATE ('07-Mar-19', 'dd-Mon-yy')
  AND WITHDRAWAL_AMT IS NOT NULL;

/*5. Query to Find the First five largest Withdrawal transactions are occured 
      in year 18*/
SELECT TO_NUMBER(REPLACE(WITHDRAWAL_AMT,'"','')) AS FIRST_FIVE_HIGHEST_DEPOSITED_AMOUNT_IN_2018
FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL
AND EXTRACT(YEAR FROM "DATE")=2018
AND REGEXP_LIKE(REPLACE(WITHDRAWAL_AMT,' ',''),'^[0-9]+(\.[0-9]+)?$')
ORDER BY TO_NUMBER(REPLACE(WITHDRAWAL_AMT,'"','')) DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

/*4 Query to count the withdrawal transactions  
    between May 5 2018, and March 7 2019 'by using index'*/
explain plan for
SELECT COUNT(*) AS withdrawal_count
FROM BANK_TRANSACTION
WHERE "DATE" >= TO_DATE('05-May-18', 'dd-Mon-yy')
  AND "DATE" <= TO_DATE ('07-Mar-19', 'dd-Mon-yy')
  AND WITHDRAWAL_AMT IS NOT NULL;
select * from 
table(dbms_XPLAN.display());

create bitmap index date_index on bank_transaction('DATE');
--