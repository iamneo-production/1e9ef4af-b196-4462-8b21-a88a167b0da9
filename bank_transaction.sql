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

/* Query to find the first five largest withdrawal transactions occured in the year 2018 */

    select to_number(regexp_replace(withdrawal_amt ,'[^0-9.]','' )) as first_five_highest_deposited_amount_in_2018
    from bank_transaction where withdrawal_amt is not null and 
    extract(year from "DATE")=2018
    and regexp_like(replace(withdrawal_amt,' ',''),'[0-9]+(\.[0-9]+)?$')
    order by to_number(replace(withdrawal_amt,'"','')) desc
    offset 0 rows fetch next 5 rows only;