/* Retrieve All Records from Table */
select * from Bank_Transaction;

/* Describe Table */
DESC BANK_TRANSACTION;

/* Q1) Query to find highest amount debited each year */
   SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
         MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))
         as 
         HIGHEST_DEBITED_AMOUNT_OF_EVERY_YEAR 
         FROM BANK_TRANSACTION 
         WHERE WITHDRAWAL_AMT IS NOT NULL
         AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
         GROUP BY 
         EXTRACT(YEAR FROM "DATE") 
         ORDER BY 
         EXTRACT(YEAR FROM "DATE");

/* Q2) Query to find the lowest amount debited each year */
   SELECT EXTRACT(YEAR FROM "DATE")
         AS
         YEAR, 
         MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) 
         AS LOWEST_DEBITED_AMOUNT_OF_EVERY_YEAR 
         FROM BANK_TRANSACTION 
         WHERE WITHDRAWAL_AMT IS NOT NULL
         AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
         GROUP BY EXTRACT(YEAR FROM "DATE") 
         ORDER BY EXTRACT(YEAR FROM "DATE"); 


/* Q3) Query to find the 5th highest withdrawal each year */
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


/* Q4) Query to count the no of withdrawal transactions done between 5-may-2018 and 7-mar-2019 */
     SELECT COUNT(WITHDRAWAL_AMT) AS TOTAL_WITHDRAWAL_AMOUNT FROM BANK_TRANSACTION 
   WHERE "DATE" BETWEEN '05-MAY-18' AND '07-MAR-19'
   AND WITHDRAWAL_AMT IS NOT NULL; 

/* Q5) Query to find the first five largest withdrawal transactions occured in the year 2018 */

   SELECT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) 
   AS FIRST_FIVE_LARGEST_TRANSACTIONS_OCCURED_IN_2018 FROM BANK_TRANSACTION 
   WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
   AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
   ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
   OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY; 

-- Practice work

/* selecting particular columns from table */
   
select withdrawal_amt, "DATE" from bank_transaction ;
 
/* queries if date column is of date type and withdrawal_amt is of number type*/

/* Q1) Query to find highest amount debited each year */

select extract( year from "DATE") year,
       max(withdrawal_amt)  as highest_debited_amount 
   from bank_transaction 
   group by extract(year from "DATE") 
   order by extract(year from "DATE");

/* Q2) Query to find the lowest amount debited each year */


   select extract(year from "DATE") 
   as
      year,
   min(withdrawal_amt)  
   as 
      lowest_debited_amount 
   from bank_transaction 
   where 
      withdrawal_amt != '0' 
   group by extract(year from "DATE") 
   order by extract(year from "DATE");

/* Q3) Query to find the 5th highest withdrawal each year */

   select distinct year,
         withdrawal_amt 
         from 
               (select extract(year from "DATE") 
                        as 
                        year,
                        withdrawal_amt,dense_rank() over 
                              (partition by extract(year from "DATE") 
                              order by  (case when  withdrawal_amt is not null
                                             then  withdrawal_amt 
                                             else 0 end)  
                              desc ) 
                        as 
                        rank 
         from bank_transaction) 
         where rank=5;

/* Q4) Query to count the no of withdrawal transactions done between 5-may-2018 and 7-mar-2019 */


   select * 
   from bank_transaction 
   where "DATE">= TO_DATE('2018-05-05','YYYY-MM-DD') 
         and  
         "DATE"<= TO_DATE('2019-07-03','YYYY-MM-DD');

/* Q5) Query to find the first five largest withdrawal transactions occured in the year 2018 */
   select withdrawal_amt 
         as 
         withdrawal_amt_2018 
         from   
               (select withdrawal_amt,
                     row_number() over 
                     (partition by extract(year from "DATE") 
                     order by 
                     (case when withdrawal_amt is not null 
                           then withdrawal_amt else '0' end)  desc) 
                           as rank 
                     from bank_transaction 
                     where extract(year from "DATE")=2018) 
         where rank<=5;