CREATE TABLE bank_transaction (
  account_no INT,
  transaction_date DATE,
  transaction_details VARCHAR(255),
  cheqno INT,
  value_date DATE,
  withdrawal_amt DECIMAL(10, 2),
  deposit_amt DECIMAL(10, 2),
  balance_amt DECIMAL(10, 2)
);

-- Row 1
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (123456, DATE '2023-07-01', 'Salary Deposit', NULL, DATE '2023-07-01', NULL, 5000.00, 5000.00);

-- Row 2
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (123456, DATE '2023-07-02', 'Grocery Shopping', NULL, DATE '2023-07-02', 250.00, NULL, 4750.00);

-- Row 3
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (123456, DATE '2023-07-03', 'Dining Out', NULL, DATE '2023-07-03', 100.00, NULL, 4650.00);

-- Row 4
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (789012, DATE '2023-07-01', 'Rent Payment', NULL, DATE '2023-07-01', 1500.00, NULL, 1500.00);

-- Row 5
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (789012, DATE '2023-07-02', 'Utility Bill', NULL, DATE '2023-07-02', 200.00, NULL, 1300.00);

-- Row 6
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (789012, DATE '2023-07-03', 'Salary Deposit', NULL, DATE '2023-07-03', NULL, 3000.00, 4300.00);

-- Row 7
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (345678, DATE '2023-07-01', 'Online Purchase', NULL, DATE '2023-07-01', 75.00, NULL, 75.00);

-- Row 8
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (345678, DATE '2023-07-02', 'Withdrawal', 987654, DATE '2023-07-02', 200.00, NULL, -125.00);

-- Row 9
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (345678, DATE '2023-07-03', 'Deposit', NULL, DATE '2023-07-03', NULL, 300.00, 175.00);

-- Row 10
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (901234, DATE '2023-07-01', 'Salary Deposit', NULL, DATE '2023-07-01', NULL, 4000.00, 4000.00);

-- Row 11
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (901234, DATE '2023-07-02', 'Shopping', NULL, DATE '2023-07-02', 500.00, NULL, 3500.00);

-- Row 12
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (901234, DATE '2023-07-03', 'Dining Out', NULL, DATE '2023-07-03', 150.00, NULL, 3350.00);

-- Row 13
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (567890, DATE '2023-07-01', 'Rent Payment', NULL, DATE '2023-07-01', 1200.00, NULL, 1200.00);

-- Row 14
INSERT INTO bank_transaction (account_no, transaction_date, transaction_details, cheqno, value_date, withdrawal_amt, deposit_amt, balance_amt)
VALUES (567890, DATE '2023-07-02', 'Utility Bill', NULL, DATE '2023-07-02', 180.00, NULL, 1020.00);

select * from BANK_TRANSACTION;

select * from BANK_TRANSACTION 
where ACCOUNT_NO = 123456;