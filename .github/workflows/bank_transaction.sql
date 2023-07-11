select * 
from BANK_TRANSACTION;


SELECT distinct(year), withdrawal_amt
FROM (
  SELECT EXTRACT(YEAR FROM "DATE") AS year, 
         TO_NUMBER(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '')) AS withdrawal_amt,
         DENSE_RANK() OVER (PARTITION BY EXTRACT(YEAR FROM "DATE") 
                            ORDER BY TO_NUMBER(REGEXP_REPLACE(WITHDRAWAL_AMT, '[^0-9.]', '')) DESC) AS rn
  FROM bank_transaction
) subquery
WHERE rn = 4
order by year;
