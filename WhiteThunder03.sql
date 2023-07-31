--retrive all data
/*select * 
from BANK_TRANSACTION;*/

--trying to get code in sonor
define lol=''^[0-9]+(\.[0-9]+)?$'';
define lol;
SELECT MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) AS HIGHEST_DEPOSITED_AMOUNT, 
 EXTRACT(YEAR FROM "DATE") AS YEAR FROM BANK_TRANSACTION 
 WHERE WITHDRAWAL_AMT IS NOT NULL
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &lol)
 GROUP BY EXTRACT(YEAR FROM "DATE") 
 ORDER BY EXTRACT(YEAR FROM "DATE") asc;

--Querry to find the lowest debited in each year
SELECT MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) AS LOWEST_DEPOSITED_AMOUNT_IN_YEAR, 
 EXTRACT(YEAR FROM "DATE") AS YEAR FROM BANK_TRANSACTION 
 WHERE WITHDRAWAL_AMT IS NOT NULL
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &lol)
 GROUP BY EXTRACT(YEAR FROM "DATE") 
 ORDER BY EXTRACT(YEAR FROM "DATE") asc;


--Query to find count of the withdrawal transaction between 5-May-2018 and 7-Mar-2019
select count(*) as total_withdrawal_count
from BANK_TRANSACTION
where "DATE" >= to_date('05-May-18', 'dd-Mon-yy')
    and "DATE" <= to_date('07-Mar-19', 'dd-Mon-yy')
    and withdrawal_amt is not null;


--Query to find 5th highest withdrawal each year
WITH processed_transactions AS (
  SELECT
    TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) AS withdrawal_amount,
    EXTRACT(YEAR FROM "DATE") AS year
  FROM
    BANK_TRANSACTION
  WHERE
    WITHDRAWAL_AMT IS NOT NULL
    AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &lol)
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

--TO check the output is individually correct and to evaluvate we use this year by year and identify accurate results */
SELECT
  TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) AS withdrawal_amount,
  EXTRACT(YEAR FROM "DATE") AS year
FROM
  BANK_TRANSACTION
WHERE
  EXTRACT(YEAR FROM "DATE") = 2018
  AND WITHDRAWAL_AMT IS NOT NULL
  AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &lol)
ORDER BY
  withdrawal_amount DESC;



--Query to find the first five Largest Transaction Occured in 2018 */

SELECT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) 
 AS FIRST_FIVE_HIGHEST_DEPOSITED_AMOUNT_IN_2018 FROM BANK_TRANSACTION 
 WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), &lol)
 ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
 OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
