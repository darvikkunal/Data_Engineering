--  STROED PROCEDURE    --
-- STEP1 : write a query for US customers find the total number of customers and the average score

use SalesDB;

select 
    COUNT(*) TotalCustomers,
    AVG(score) avgscore
FROM sales.Customers
WHERE country = 'USA'

-- Step 2 : Turning the Query Into a stored Procedure

CREATE PROCEDURE GetCustomerSummary AS
BEGIN
select 
    COUNT(*) TotalCustomers,
    AVG(score) avgscore
FROM sales.customers
WHERE country = 'USA'
END

-- Alter Dynamic Stored Procedure

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) AS
BEGIN
select 
    COUNT(*) TotalCustomers,
    AVG(score) avgscore
FROM sales.customers
WHERE country = @Country
END

-- Execute the dynamic Stored Procedure

EXEC GetCustomerSummary @Country='Germany'

DROP GetCustomerSummary @Country='Germany'