/* WORKSPACE QUERIES - BANK_TRANSACTION QUERIES */

-- SQL QUERY TO FIND HIGHEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR. 

   SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))
   AS HIGHEST_DEBITED_AMOUNT_OF_THE_YEAR FROM BANK_TRANSACTION 
   WHERE WITHDRAWAL_AMT IS NOT NULL
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
   GROUP BY EXTRACT(YEAR FROM "DATE") 
   ORDER BY EXTRACT(YEAR FROM "DATE");

-- SQL QUERY TO FIND LOWEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR. 

   SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) 
   AS LOWEST_DEBITED_AMOUNT_OF_THE_YEAR FROM BANK_TRANSACTION 
   WHERE WITHDRAWAL_AMT IS NOT NULL
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
   GROUP BY EXTRACT(YEAR FROM "DATE") 
   ORDER BY EXTRACT(YEAR FROM "DATE"); 

-- SQL QUERY TO FIND THE 5TH HIGHEST WITHDRAWAL AMOUNT OF EACH YEAR.

   WITH HIGHEST_TRANSACTIONS AS(
      SELECT TO_NUMBER(TRIM(' ' FROM REPLACE(WITHDRAWAL_AMT, '"',''))) AS WITHDRAWAL_AMT, 
      EXTRACT(YEAR FROM "DATE") AS YEAR FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL AND 
      REGEXP_LIKE(TRIM(' ' FROM REPLACE(WITHDRAWAL_AMT, '"','')), '^[0-9]+(\.[0-9]+)?$')
   ), 
   FIFTH_HIGHEST_TRANSACTION AS (
      SELECT YEAR, WITHDRAWAL_AMT, ROW_NUMBER() OVER (PARTITION BY YEAR ORDER BY WITHDRAWAL_AMT DESC) 
      AS FIFTH_H_T
      FROM HIGHEST_TRANSACTIONS
   ) 
   SELECT YEAR, WITHDRAWAL_AMT AS FIFTH_HIGHEST_WITHDRAWAL_AMOUNT_OF_THE_YEAR FROM FIFTH_HIGHEST_TRANSACTION 
   WHERE FIFTH_H_T=5 ORDER BY YEAR;

-- SQL QUERY TO FIND THE FIRST FIVE LARGEST WITHDRAWAL TRANSACTIONS OCCURED IN THE YEAR 2018.

   SELECT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) 
   AS FIRST_FIVE_LARGEST_WITHDRAWAL_TRANSACTIONS_OCCURED_IN_2018 FROM BANK_TRANSACTION 
   WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
   ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
   OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY; 

-- SQL QUERY TO COUNT THE WITHDRAWAL TRANSACTIONS BETWEEN MAY 5,2018 AND MAR 7,2019. 

   SELECT COUNT(WITHDRAWAL_AMT) AS TOTAL_WITHDRAWAL_AMT FROM BANK_TRANSACTION 
   WHERE "DATE" BETWEEN '05-MAY-18' AND '07-MAR-19'
   AND WITHDRAWAL_AMT IS NOT NULL; 



/* MY PRACTICE WORK TO GET THE ABOVE WORKSPACE QUERIES */ 

 -- WITHDRAWAL_AMT IS IN THE FORMAT OF VARCHAR WITH QUOTES, SPACES, DATES. 
 -- REMOVING QUOTES FROM THE WITHDRAWAL AMOUNTS 
    SELECT (REPLACE(WITHDRAWAL_AMT, '"', '')) FROM BANK_TRANSACTION

 -- REMOVING SPACES AND QUOTES FROM THE WITHDRAWAL AMOUNTS. 
    SELECT (TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) AS WITHDRAWAL_AMT FROM BANK_TRANSACTION; 

 -- SOME VALUES OF WITHDRAWAL_AMT ARE DATES. 
    SELECT WITHDRAWAL_AMT FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT LIKE '%-%'; 

 -- TO GET RID OF THOSE DATES IN WITHDRAWAL_AMT, IAM USING REGEXP_LIKE FUNCTION.
    SELECT (TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) AS WITHDRAWAL_AMT
    FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL
    AND REGEXP_LIKE(REPLACE(WITHDRAWAL_AMT,' ',''), '^[0-9]+(\.[0-9]+)?$'); 

 -- TO CONVERT THE WITHDRAWAL_AMT TO NUMBER. 
    SELECT (TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) AS WITHDRAWAL_AMT
    FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL
    AND REGEXP_LIKE(REPLACE(WITHDRAWAL_AMT,' ',''), '^[0-9]+(\.[0-9]+)?$'); 

 -- TO GET THE MAXIMUM ELEMNT FROM THE WITHDRAWAL_AMT.  
    SELECT (MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))) AS MAX_WITHDRAWAL_AMT
    FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL
    AND REGEXP_LIKE(REPLACE(WITHDRAWAL_AMT,' ',''), '^[0-9]+(\.[0-9]+)?$'); 

 -- TO GET THE MINIMUM ELEMENT FROM THE WITHDRAWAL_AMT 
    SELECT (MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))) AS MIN_WITHDRAWAL_AMT
    FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL
    AND REGEXP_LIKE(REPLACE(WITHDRAWAL_AMT,' ',''), '^[0-9]+(\.[0-9]+)?$'); 



 
