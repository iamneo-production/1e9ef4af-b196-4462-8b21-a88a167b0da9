/*1 Query to find Highest Amount debited from the bank in each year*/
SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
        MAX(CAST(WITHDRAWAL_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS highest_debited_amount 
FROM bank_transaction 
GROUP BY EXTRACT(YEAR FROM "DATE")
ORDER BY YEAR;

/*2Query to find Lowest amount debited from the bank in each year*/
SELECT EXTRACT(YEAR FROM "DATE") AS YEAR,
        MIN(CAST(WITHDRAWAL_AMT AS NUMBER(10, 2) DEFAULT NULL ON CONVERSION ERROR)) AS lowest_debited_amount 
FROM bank_transaction 
GROUP BY EXTRACT(YEAR FROM "DATE")
ORDER BY YEAR;

/*3Query to find the 5th Highest Withdrawal amount at each year*/
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


/*4Query to count the withdrawal transactions between May 5 2018, and March 7 2019*/
SELECT COUNT(*) AS withdrawal_count
FROM BANK_TRANSACTION
WHERE "DATE" >= TO_DATE('05-May-18', 'dd-Mon-yy')
  AND "DATE" <= TO_DATE ('07-Mar-19', 'dd-Mon-yy')
  AND WITHDRAWAL_AMT IS NOT NULL;

/*5Query to Find the First five largest Withdrawal transactions are occured in year 18*/
SELECT TO_NUMBER(REPLACE(WITHDRAWAL_AMT,'"','')) AS FIRST_FIVE_HIGHEST_DEPOSITED_AMOUNT_IN_2018
FROM BANK_TRANSACTION WHERE WITHDRAWAL_AMT IS NOT NULL
AND EXTRACT(YEAR FROM "DATE")=2018
AND REGEXP_LIKE(REPLACE(WITHDRAWAL_AMT,' ',''),'^[0-9]+(\.[0-9]+)?$')
ORDER BY TO_NUMBER(REPLACE(WITHDRAWAL_AMT,'"','')) DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

/*4Query to count the withdrawal transactions between May 5 2018, and March 7 2019 'by using index'*/
explain plan for
SELECT COUNT(*) AS withdrawal_count
FROM BANK_TRANSACTION
WHERE "DATE" >= TO_DATE('05-May-18', 'dd-Mon-yy')
  AND "DATE" <= TO_DATE ('07-Mar-19', 'dd-Mon-yy')
  AND WITHDRAWAL_AMT IS NOT NULL;
select * from 
table(dbms_XPLAN.display());

create bitmap index date_index on bank_transaction('DATE');