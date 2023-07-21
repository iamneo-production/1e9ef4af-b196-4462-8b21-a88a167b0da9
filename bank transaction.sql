/*query to find highest amount debited each year*/
select EXTRACT( year from "DATE") as year,
max(cast(WITHDRAWAL_AMT as NUMBER(10,2) default null on conversion error)) as highest_debited_amount
from BANK_TRANSACTION
group by EXTRACT(year from "DATE")
order by year;

/*query to find lowest amount debited each year*/
select EXTRACT( year from "DATE") as year,
min(cast(WITHDRAWAL_AMT as NUMBER(10,2) default null on conversion error)) as lowest_debited_amount
from BANK_TRANSACTION
group by EXTRACT(year from "DATE")
order by year;

/*query to find count the withdrwal transaction between 5-may-2018 and 2-mar-2019*/
select count(*) as withdrawal_count from bank_transaction
where "DATE">=TO_DATE('05-May-18','dd-Mon-yy')
and "DATE"<=TO_DATE('07-Mar-19','dd-Mon-yy') and WITHDRAWAL_AMT is not null;

/*query to find the first five largest withdrawal transaction*/
select to_number(replace(WITHDRAWAL_AMT,'''','')) as first_five_highest_deposited_amount_in_2018
from BANK_TRANSACTION where WITHDRAWAL_AMT is NOT NULL
and extract(year from "DATE")=2018
and regexp_like(replace(WITHDRAWAL_AMT,' ',''),'^[0-9]+(\.[0-9]+)?$')
order by to_number(replace(WITHDRAWAL_AMT,'''','')) desc
offset 0 rows fetch next 5 rows only;
/*query to find the 5 highest withdrawal each year*/
select distinct(year),WITHDRAWAL_AMT from
(
     select EXTRACT(year from "DATE") as year,
     TO_NUMBER(REGEXP_REPLACE(WITHDRAWAL_AMT,'[^0-9.]','')) as withdrawal_amt,
     dense_rank() over(partition by extract(year from "DATE")
     order by to_number(regexp_replace(WITHDRAWAL_AMT,'[^0-9.]',''))desc) as rn
     from BANK_TRANSACTION
)subquery
where rn=5
order by year;