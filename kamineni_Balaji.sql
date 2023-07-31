
DESC BANK_TRANSACTION;

SELECT * FROM BANK_TRANSACTION;

--Query to find Highest Amount debited each year 

SELECT
  MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) AS HIGHEST_DEPOSITED_AMOUNT_OF_THE_YEAR,
  EXTRACT(YEAR FROM "DATE") AS YEAR
FROM
  BANK_TRANSACTION
WHERE
  WITHDRAWAL_AMT IS NOT NULL
  AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
GROUP BY
  EXTRACT(YEAR FROM "DATE")
ORDER BY
  EXTRACT(YEAR FROM "DATE") ASC;


 -- Query to find Lowest Amount debited each year

SELECT MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) AS LOWEST_DEPOSITED_AMOUNT, 
 EXTRACT(YEAR FROM "DATE") AS YEAR FROM BANK_TRANSACTION 
 WHERE WITHDRAWAL_AMT IS NOT NULL
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
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
  year asc;


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
 AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
 ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
 OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


--TO check the output is individually correct and to evaluvate we use this year by year and identify accurate results 
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

/* MY PRACTICE WORK TO GET THE ABOVE WORKSPACE QUERIES */ 

/* Also the queries below are written by considering "DATE" column is if date data type
and withdrawal_amount if of number type*/

--Query to find Highest Amount debited each year
   /*
   select extract(year from transaction_date) year,
      max(withdrawal_amt)  as highest_debited_amount 
      from bank_transaction 
      group by extract(year from transaction_date) 
      order by extract(year from transaction_date) 
      */

 -- Query to find Lowest Amount debited each year
      /*select extract(year from transaction_date) year,
      min(withdrawal_amt)  as lowest_debited_amount 
      from bank_transaction where withdrawal_amt != 0 
      group by extract(year from transaction_date) 
      order by extract(year from transaction_date) ;
      */

--query to find 5th highest withdrawal each year
   /*
   select distinct year,
   withdrawal_amt from 
      (select extract(year from transaction_date) as year,
         withdrawal_amt,dense_rank() over 
         (partition by extract(year from transaction_date) 
         order by  (case when withdrawal_amt is not null 
                        then withdrawal_amt 
                        else 0 end)  desc ) as rank 
         from bank_transaction) 
         where rank=5; 
         --distinct because if 5th highest amount has
          more than 1 transaction, then multiple records
          will fetch because they have same rank.
         */
--Query to find Count the Withdrawal Transaction between 5-May-2018 and 7-Mar-2019 
   /*
   select * from bank_transaction 
   where transaction_date>= TO_DATE('2018-05-05','YYYY-MM-DD') 
   and 
         transaction_date<= TO_DATE('2019-07-03','YYYY-MM-DD');
   */

--Query to find the first five Largest Transaction Occured in 2018 

   /*
   select withdrawal_amt as withdrawal_amt_2018 
   from
    (select withdrawal_amt,row_number() over 
    (partition by extract(year from transaction_date) order by 
    (case when withdrawal_amt is not null 
         then withdrawal_amt else 0 end)  desc) as rank 
         from bank_transaction 
         where extract(year from transaction_date)=2018) 
      where rank<=5;
      */

