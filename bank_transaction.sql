/* Retrieve All Records from Table */
select * from Bank_Transaction;

/* Describe Table */
DESC BANK_TRANSACTION;
            (OR)
DESCRIBE BANK_TRANSACTION;

/* Query to find the 5th highest withdrawal each year */
select distinct year, WITHDRAWAL_AMT from (
     select extract(year from "DATE") year , 
     to_number(regexp_replace(withdrawal_amt ,'[^0-9.]', '' )) as WITHDRAWAL_AMT,
     dense_rank() over (partition by 
     extract(year from "DATE") order by to_number(regexp_replace(withdrawal_amt ,'[^0-9.]','' )) desc ) rank from 
     BANK_TRANSACTION) where rank=5 order by year;

/* doubt Query to find the first five largest withdrawal transactions occured in the year 2018 */

    select to_number(regexp_replace(withdrawal_amt ,'[^0-9.]','' )) as first_five_highest_deposited_amount_in_2018
    from bank_transaction where withdrawal_amt is not null and 
    extract(year from "DATE")=2018
    and regexp_like(replace(withdrawal_amt,' ',''),'[0-9]+(\.[0-9]+)?$')
    order by to_number(REPLACE(withdrawal_amt,'"',' ')) desc
    offset 0 rows fetch next 5 rows only;

/* Query to find highest amount debited each year */
select extract(year from "DATE") as year,
max(cast(withdrawal_amt as number(10,2) default null on conversion error )) as highest_debited_amount
from bank_transaction
group by extract(year from "DATE")
order by year;

/* Query to find the lowest amount debited each year */
select extract(year from "DATE") as year,
min(cast(withdrawal_amt as number(10,2) default null on conversion error )) as lowest_debited_amount
from bank_transaction
group by extract(year from "DATE")
order by year;

/*  Query to count the no of withdrawal transactions done between 5-may-2018 and 7-mar-2019 */
select count(*) as withdrawal_count
from bank_transaction 
where "DATE" >=to_date('05-MAY-18','dd-mon-yy')
and "DATE"<=to_date('07-mar-19','dd-mon-yy')
and WITHDRAWAL_AMT is not null;

