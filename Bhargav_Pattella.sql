--retrive all data
select * 
from BANK_TRANSACTION;

<<<<<<< HEAD:WhiteThunder03.sql
--Querry to find the highest debited each year
select extract(year from "DATE") as year,max(cast(withdrawal_amt as number(10,2) default null on conversion error)) as highest_debited_amount
from BANK_TRANSACTION
group by extract(year from "DATE")
order by year;

--Querry to find the lowest debited in each year
select extract(year from "DATE") as year,min(cast(withdrawal_amt as number(10,2) default null on conversion error)) as lowest_debited_amount
from BANK_TRANSACTION
group by extract(year from "DATE")
order by year;
=======
/* Describe Table */ 
DESC BANK_TRANSACTION;
>>>>>>> f748acc20be8310a78e6be6bf892a038f2755089:Bhargav_Pattella.sql

--Query to find count of the withdrawal transaction between 5-May-2018 and 7-Mar-2019
select count(*) as withdrawal_count
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
    AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
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
  year;

/* TO check the output is individually correct and to evaluvate we use this year by year and identify accurate results */
SELECT
  TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) AS withdrawal_amount,
  EXTRACT(YEAR FROM "DATE") AS year
FROM
  BANK_TRANSACTION
WHERE
  EXTRACT(YEAR FROM "DATE") = 2018
  AND WITHDRAWAL_AMT IS NOT NULL
  AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
ORDER BY
  withdrawal_amount DESC;



/* Query to find the first five Largest Transaction Occured in 2018 */

SELECT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) 
 AS FIRST_FIVE_HIGHEST_DEPOSITED_AMOUNT_IN_2018 FROM BANK_TRANSACTION 
 WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
 ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
 OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
<<<<<<< HEAD:WhiteThunder03.sql

=======
>>>>>>> f748acc20be8310a78e6be6bf892a038f2755089:Bhargav_Pattella.sql
