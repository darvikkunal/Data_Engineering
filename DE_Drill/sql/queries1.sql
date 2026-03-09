/*
Problem 1 — Easy
Get the full name of all employees (first name + last name as one column called full_name), 
their job title, and the country they work in. Sort the results by last name A→Z.
Tables needed: employees
*/

select 
    Concat(FirstName , ' ' , LastName) as full_name,
    title as job_title,
    Country
from employees
order by LastName asc;

/*
Problem 2 — Easy
Get a list of all unique countries that our customers are from. Sort them alphabetically.
Tables needed: customers
*/

select
    DISTINCT Country
from customers
order by Country;