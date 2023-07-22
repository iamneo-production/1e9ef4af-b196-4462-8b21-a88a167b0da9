CREATE INDEX BANK_QUERY ON BANK_TRANSACTION("DATE", WITHDRAWAL_AMT);

/* SQL QUERY TO FIND HIGHEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR */ 
SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MAX(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))))
AS HIGHEST_DEPOSITED_AMOUNT FROM BANK_TRANSACTION 
WHERE WITHDRAWAL_AMT IS NOT NULL
AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
GROUP BY EXTRACT(YEAR FROM "DATE") 
ORDER BY EXTRACT(YEAR FROM "DATE");

/* SQL QUERY TO FIND LOWEST AMOUNT DEBITED FROM THE BANK IN EACH YEAR */
SELECT EXTRACT(YEAR FROM "DATE") AS YEAR, MIN(TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))))) 
AS LOWEST_DEPOSITED_AMOUNT FROM BANK_TRANSACTION 
WHERE WITHDRAWAL_AMT IS NOT NULL
AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
GROUP BY EXTRACT(YEAR FROM "DATE") 
ORDER BY EXTRACT(YEAR FROM "DATE");

/* SQL QUERY TO FIND THE FIRST FIVE LARGEST WITHDRAWAL TRANSACTIONS OCCURED IN THE YEAR 2018 */
SELECT DISTINCT TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) 
AS FIRST_FIVE_HIGHEST_DEPOSITED_AMOUNTs_IN_2018 FROM BANK_TRANSACTION 
WHERE WITHDRAWAL_AMT IS NOT NULL AND EXTRACT(YEAR FROM "DATE")=2018
AND REGEXP_LIKE(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', ''))), '^[0-9]+(\.[0-9]+)?$')
ORDER BY TO_NUMBER(TRIM(' ' FROM (REPLACE(WITHDRAWAL_AMT, '"', '')))) DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY; 

/* SQL QUERY TO COUNT THE WITHDRAWAL TRANSACTIONS BETWEEN MAY 5,2018 AND MAR 7,2019 */
SELECT COUNT(WITHDRAWAL_AMT) FROM BANK_TRANSACTION 
WHERE "DATE" BETWEEN '05-MAY-18' AND '07-MAR-19'
AND WITHDRAWAL_AMT IS NOT NULL; 



/* SAMPLE WORK ON OUR PROJECT - BANK MANAGEMENT SYSTEM */ 

/* CREATION OF TABLES - BRANCH, CUSTOMER, TRANSACTION, LOAN, ACCOUNT, CARD, LOAN_TYPE */ 

CREATE TABLE BRANCHES(ID NUMBER PRIMARY KEY NOT NULL, NAME VARCHAR2(50), ADDRESS VARCHAR2(50));

CREATE TABLE CARDS(ID NUMBER PRIMARY KEY NOT NULL, CARDNUMBER VARCHAR2(50), 
EXPIRATION_DATE DATE, IS_BLOCKED NUMBER(1)); 

CREATE TABLE LOAN_TYPES(ID NUMBER PRIMARY KEY NOT NULL, TYPE VARCHAR2(100), DESCRIPTION VARCHAR2(100),
BASE_AMOUNT NUMBER(10), BASE_INTEREST_RATE NUMBER(10)); 

CREATE TABLE CUSTOMERS(ID NUMBER PRIMARY KEY NOT NULL, BRANCH_ID NUMBER, FIRST_NAME VARCHAR2(50),
LAST_NAME VARCHAR2(50), DATE_OF_BIRTH DATE, GENDER VARCHAR2(6),
FOREIGN KEY(BRANCH_ID) REFERENCES BRANCHES(ID)); 

CREATE TABLE ACCOUNTS(ID NUMBER PRIMARY KEY NOT NULL, CUSTOMER_ID NUMBER(10), CARD_ID NUMBER(10),
BALANCE VARCHAR2(50),FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(ID), 
FOREIGN KEY (CARD_ID) REFERENCES CARDS(ID)) 

CREATE TABLE LOANS(ID NUMBER PRIMARY KEY NOT NULL, ACCOUNT_ID NUMBER, LOAN_TYPE_ID NUMBER, 
ACCOUNT_PAID DECIMAL(10,3), START_DATE DATE, DUE_DATE DATE,
FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS(ID), FOREIGN KEY(LOAN_TYPE_ID) REFERENCES LOAN_TYPES(ID)); 
ALTER TABLE LOANS RENAME COLUMN ACCOUNT_PAID TO AMOUNT_PAID;

CREATE TABLE TRANSACTIONS(ID NUMBER PRIMARY KEY NOT NULL, ACCOUNT_ID NUMBER, DESCRIPTION VARCHAR2(100),
AMOUNT DECIMAL(10,3), TDATE DATE, FOREIGN KEY (ACCOUNT_ID) REFERENCES ACCOUNTS(ID)); 

/* INSERTING RECORDS INTO THE TABLES */ 

INSERT INTO BRANCHES(ID, NAME, ADDRESS) VALUES (1, 'AXIS BANK', 'AXIS-BANK-HYD');
INSERT INTO BRANCHES(ID, NAME, ADDRESS) VALUES (2, 'AXIS BANK', 'AXIS-BANK-CHN');
INSERT INTO BRANCHES(ID, NAME, ADDRESS) VALUES (3, 'HDFC BANK', 'AXIS-BANK-BANG');
INSERT INTO BRANCHES(ID, NAME, ADDRESS) VALUES (4, 'ICICI', 'AXIS-BANK-AP');
INSERT INTO BRANCHES(ID, NAME, ADDRESS) VALUES (5, 'SBI BANK', 'AXIS-BANK-AP');
INSERT INTO BRANCHES(ID, NAME, ADDRESS) VALUES (6, 'SBI BANK', 'AXIS-BANK-HYD');
INSERT INTO BRANCHES(ID, NAME, ADDRESS) VALUES (7, 'SBI BANK', 'AXIS-BANK-CHN'); 

SELECT * FROM BRANCHES; 

INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(11,1,'LAKSHMI','SRI','07-JUN-2002','FEMALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(12,1,'MOUNI','SRI','09-SEP-1999','FEMALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(13,2,'HEMA','SRI','23-MAY-1996','FEMALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(14,3,'GOPI','BANDARU','16-JUL-1997','MALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(15,6,'SAI','SRI','24-APR-2002','MALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(16,4,'ASHISH','SAI','10-NOV-2003','MALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(17,7,'LALITHA','SRI','11-DEC-2002','FEMALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(18,5,'SRI','HARI','01-JUN-1973','MALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(19,5,'SUJATHA','BANDARU','31-JUL-1983','FEMALE'); 
INSERT INTO CUSTOMERS(ID,BRANCH_ID, FIRST_NAME,LAST_NAME,DATE_OF_BIRTH,GENDER) 
VALUES(20,1,'LAKSHMI','BANDARU','27-JUN-1976','FEMALE'); 

SELECT * FROM CUSTOMERS; 

INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(101,'1234','01-JAN-2030', 1); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(102,'1111','01-JUN-2025', 0); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(103,'2222','01-MAY-2040', 0); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(104,'3333','01-DEC-2032', 0); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(105,'4444','01-JUL-2028', 1); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(106,'5555','01-JUL-2030', 1); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(107,'6666','05-JAN-2034', 1); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(108,'7777','07-MAY-2037', 0); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(109,'8888','01-NOV-2030', 0); 
INSERT INTO CARDS(ID, CARDNUMBER, EXPIRATION_DATE, IS_BLOCKED) VALUES(110,'1234','06-APR-2027', 1);  

SELECT * FROM CARDS; 

INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1001, 12, 103,'5000.00'); 
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1002, 13, 101,'10000.00');
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1003, 15, 102,'500.00');
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1004, 11, 104,'1000.00');
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1005, 14, 105,'4500.00');
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1006, 16, 106,'473.43');
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1007, 17, 107,'200.80');  
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1008, 20, 108,'1000.00');
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1009, 19, 110,'5000.00');
INSERT INTO ACCOUNTS(ID, CUSTOMER_ID, CARD_ID, BALANCE) VALUES (1010, 18, 109,'4988.90');

SELECT * FROM ACCOUNTS; 

INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10001,1002,'WITHDRAWAL',500,'01-JUL-2023'); 
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10002,1005,'TRANSFER',1000,'08-JAN-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10003,1003,'DEPOSITED',5000,'06-MAY-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10004,1001,'DEPOSITED',590,'15-JUL-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10005,1008,'WITHDRAWAL',100,'17-MAR-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10006,1004,'DEPOSITED',390,'05-APR-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10007,1009,'TRANSFER',4000,'01-FEB-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10008,1010,'WITHDRAWAL',890,'08-JUL-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10009,1006,'TRANSFER',800,'10-JAN-2023');
INSERT INTO TRANSACTIONS(ID,ACCOUNT_ID,DESCRIPTION,AMOUNT,TDATE) VALUES(10010,1007,'DEPOSITED',920,'02-MAY-2023');

SELECT * FROM TRANSACTIONS; 

INSERT INTO LOAN_TYPES(ID,TYPE,DESCRIPTION,BASE_AMOUNT,BASE_INTEREST_RATE) VALUES(1,'PERSONAL LOAN','PL',6000,2);
INSERT INTO LOAN_TYPES(ID,TYPE,DESCRIPTION,BASE_AMOUNT,BASE_INTEREST_RATE) VALUES(2,'EDUCATIONAL LOAN','EL',50000,3);
INSERT INTO LOAN_TYPES(ID,TYPE,DESCRIPTION,BASE_AMOUNT,BASE_INTEREST_RATE) VALUES(3,'BUSINESS LOAN','BL',30000,4);
INSERT INTO LOAN_TYPES(ID,TYPE,DESCRIPTION,BASE_AMOUNT,BASE_INTEREST_RATE) VALUES(4,'VEHICLE LOAN','VL',10000,2);

SELECT * FROM LOAN_TYPES; 

INSERT INTO LOANS(ID, ACCOUNT_ID, LOAN_TYPE_ID, AMOUNT_PAID, START_DATE, DUE_DATE) 
VALUES (111,1001, 2, 1000, '05-JUL-2023', '05-JUL-2024');
INSERT INTO LOANS(ID, ACCOUNT_ID, LOAN_TYPE_ID, AMOUNT_PAID, START_DATE, DUE_DATE) 
VALUES (222,1008, 4, 4000, '05-JAN-2023', '05-JAN-2024');
INSERT INTO LOANS(ID, ACCOUNT_ID, LOAN_TYPE_ID, AMOUNT_PAID, START_DATE, DUE_DATE) 
VALUES (333,1003, 1, 1000, '25-APR-2023', '25-APR-2024');
INSERT INTO LOANS(ID, ACCOUNT_ID, LOAN_TYPE_ID, AMOUNT_PAID, START_DATE, DUE_DATE) 
VALUES (444,1007, 2, 5000, '15-JUN-2023', '15-JUN-2024');
INSERT INTO LOANS(ID, ACCOUNT_ID, LOAN_TYPE_ID, AMOUNT_PAID, START_DATE, DUE_DATE) 
VALUES (555,1005, 3, 5000, '08-MAR-2023', '08-MAR-2025');

SELECT * FROM LOANS; 

/* RETRIEVING THE RECORDS FROM THE SINGLE TABLES USING CLAUSES*/ 

SELECT * FROM BRANCHES WHERE NAME='SBI BANK'; 

SELECT * FROM BRANCHES WHERE NAME LIKE 'A%' AND ID=1;

SELECT FIRST_NAME || ' ' || LAST_NAME AS CUSTOMER_NAME FROM CUSTOMERS ORDER BY FIRST_NAME; 

SELECT * FROM CUSTOMERS WHERE GENDER='FEMALE' ORDER BY FIRST_NAME; 

SELECT SUM(AMOUNT) AS TOTAL_AMOUNT FROM TRANSACTIONS; 

SELECT MAX(AMOUNT) FROM TRANSACTIONS;

SELECT MIN(AMOUNT) FROM TRANSACTIONS; 

SELECT CARDNUMBER AS ACTIVE_CARDS FROM CARDS WHERE IS_BLOCKED=1; 

SELECT MAX(TO_NUMBER(BALANCE)) FROM ACCOUNTS; 

SELECT * FROM ACCOUNTS ORDER BY TO_NUMBER(BALANCE) DESC; 

SELECT * FROM LOANS WHERE START_DATE BETWEEN '01-JAN-2022' AND '01-JUL-2023';  

SELECT COUNT(ACCOUNT_ID) AS COUNT, LOAN_TYPE_ID FROM LOANS GROUP BY LOAN_TYPE_ID; 

