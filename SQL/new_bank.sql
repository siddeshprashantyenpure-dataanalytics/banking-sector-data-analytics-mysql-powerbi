-- Database Creation
-- create database banking_sector;
use banking_sector;
show tables;
-- --------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------
-- Changing datatypes as per requirement
select * from accounts;

-- --------------------------------------------------------------------------------------------------------------------------------------
select opened_date,str_to_date(opened_date,'%Y-%m-%d') as converted_date from branches;
alter table branches add column demo date;
update branches set demo = str_to_date(opened_date,'%Y-%m-%d');
select * from branches;
alter table branches drop opened_date;
alter table branches change demo opened_dates date;
select * from branches;

-- --------------------------------------------------------------------------------------------------------------------------------------
alter table card_transactions add column demo datetime;
update card_transactions set demo = str_to_date(transaction_datetime,'%Y-%m-%d %H:%i:%s');
alter table card_transactions drop transaction_datetime;
alter table card_transactions change demo transaction_datetime datetime;
select * from card_transactions;

-- --------------------------------------------------------------------------------------------------------------------------------------
alter table cards add column new_issue_date date;
update cards set new_issue_date = str_to_date(issue_date,'%Y-%m-%d');
alter table cards drop issue_date;
alter table cards change new_issue_date issue_date date;

alter table cards add column new_expiry_date date;
update cards set new_expiry_date = str_to_date(expiry_date,'%Y-%m-%d');
alter table cards drop expiry_date;
alter table cards change new_expiry_date expiry_date date;
select * from cards;

-- --------------------------------------------------------------------------------------------------------------------------------------
alter table customers add column new_dob date;
update customers set new_dob = str_to_date(date_of_birth,'%Y-%m-%d');
alter table customers drop date_of_birth;
alter table customers change new_dob date_of_birth date;

alter table customers add column new_cust date;
update customers set new_cust = str_to_date(customer_since,'%Y-%m-%d');
alter table customers drop customer_since;
alter table customers change new_cust customer_since date;
select * from customers;

-- --------------------------------------------------------------------------------------------------------------------------------------
alter table employees add column new_cust date;
update employees set new_cust = str_to_date(hire_date,'%Y-%m-%d');
alter table employees drop hire_date;
alter table employees change new_cust hire_date date;

alter table employees modify column manager_id int;
update employees set manager_id = null where manager_id = 0;
select * from employees;

-- --------------------------------------------------------------------------------------------------------------------------------------
alter table loan_payments add column new_payment_date date;
update loan_payments set new_payment_date = str_to_date(payment_date,'%Y-%m-%d');
alter table loan_payments drop payment_date;
alter table loan_payments change new_payment_date payment_date date;
select * from loan_payments;

-- --------------------------------------------------------------------------------------------------------------------------------------
alter table loans add column new_application_date date;
update loans set new_application_date = str_to_date(application_date,'%Y-%m-%d');
alter table loans drop application_date;
alter table loans change new_application_date application_date date;
select * from loan_payments;

-- --------------------------------------------------------------------------------------------------------------------------------------
alter table transactions add column new_datetime datetime;
update transactions set new_datetime = str_to_date(transaction_datetime,'%Y-%m-%d %H:%i:%s');
alter table transactions drop transaction_datetime;
alter table transactions change new_datetime transaction_datetime datetime;
select * from transactions;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------------
-- A. Basic SELECT / WHERE

-- 1. Display all customers.
select * from customers;

-- 2. Display customer_id, first_name, last_name and annual_income.
select customer_id as ID,first_name as Name,last_name as Surname,annual_income as Income from customers;

-- 3.Find customers from Maharashtra.
select * from customers where state = 'Maharashtra';

-- 4. Find customers whose annual income is greater than 100000.
select * from customers where annual_income > 100000;

-- 5. Find customers aged between 25 and 40.
with age as(
	select *,timestampdiff(Year,date_of_birth,CURDATE()) as Age
    from customers
)
select * from age where age between 25 and 40;

-- 6. Find all active accounts.
select * from accounts where status = 'Active';

-- 7. Display only Savings accounts.
select * from accounts where account_type = 'Savings';

-- 8. Find loans with loan_amount greater than 1,000,000.
select * from loans where loan_amount > 1000000;

-- 9. Find successful transactions.
select * from transactions where transaction_status = 'Success';

-- 10. Find failed transactions.
select * from transactions where transaction_status = 'Failed';

-- 11. Display customers from Pune, Mumbai and Bengaluru.
select * from customers where city in ('Pune','Mumbai','Bengaluru');

-- 12. Find accounts whose balance is between 50,000 and 2,00,000.
select * from accounts where current_balance between 50000 and 200000;

-- 13. Find customers whose occupation is either Salaried or Business.
select * from customers where occupation in ('Salaried','Business');

-- 14. Find customers whose first name starts with 'A'.
select * from customers where first_name like 'A%';

-- 15. Find customers whose last name ends with 'a'.
select * from customers where last_name like '%a';

-- 16. Find transactions performed through Mobile App.
select * from transactions where channel = 'Mobile App';

-- 17. Find credit transactions above 50,000.
select * from transactions where transaction_direction = 'Credit' and amount > 50000;

-- 18. Find debit transactions below 1,000.
select * from transactions where transaction_direction = 'Debit' and amount < 1000;

-- 19. Find loans with interest rate above 12%.
select * from loans where interest_rate > 12;

-- 20. Find cards that are currently Active.
select * from cards where status = 'Active';

-- --------------------------------------------------------------------------------------------------------------------------------------
-- B. DISTINCT / ORDER BY / LIMIT

-- 21. List distinct customer cities.
select distinct city as 'City_Name'
from customers;

-- 22. List distinct transaction channels.
select distinct channel as 'Transaction_Channels' from transactions;

-- 23. List distinct loan types.
select distinct loan_type as Loan_Type from loans;

-- 24. Sort customers by annual income descending.
select * from customers
order by annual_income desc;

-- 25. Sort accounts by current balance descending.
select * from accounts
order by currency,current_balance desc;

-- 26. Display the 10 highest-value transactions.
select * from transactions
order by amount desc
limit 10;

-- 27. Display the 10 customers with highest annual income.
select * from customers 
order by annual_income desc
limit 10;

-- 28. Display the 5 largest loans.
select * from loans
order by loan_amount desc
limit 5;

-- 29. Display branches alphabetically.
select * from branches 
order by branch_name;

-- 30. Display the 10 highest outstanding loan amounts.
select * from loans
order by outstanding_amount desc
limit 10;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- C. Aggregations
-- 31. Count total customers.
select distinct count(customer_id) as Total_Customers 
from customers;

-- 32. Count customers by gender.
select distinct gender,count(customer_id) as Total
from customers
group by gender;

-- 33. Find average annual income.
select round(avg(annual_income),2) as Average_Annual_Income
from customers;

-- 34. Find minimum and maximum account balance.
select min(current_balance) as Minimum_Balance,max(current_balance) as Maximum_Balance
from accounts;

-- 35. Find total transaction amount.
select round(sum(amount),2) as Total_Transaction_Amount
from transactions;

-- 36. Find average transaction amount.
select round(avg(amount),2) as Average_Transaction_Amount
from transactions;

-- 37. Find total loan amount.
select round(sum(loan_amount),2) as Total_Loan_Amount
from loans;

-- 38. Find total outstanding loan amount.
select round(sum(outstanding_amount),2) as Total_Outstanding_Amount
from loans;

-- 39. Find average loan interest rate.
select round(avg(interest_rate),2) as Average_Interest_Rate
from loans;

-- 40. Find total salary paid to employees.
select sum(salary) as Total_Salary_Paid
from employees;

-- 41. Count accounts by account type.
select account_type as Type,count(account_type) as No_Of_Accounts
from accounts
group by account_type;

-- 42. Count transactions by transaction type.
select transaction_type as Type,count(transaction_type) as No_Of_Transactions
from transactions
group by transaction_type;

-- 43. Count loans by loan type.
select loan_type as Type_of_Loan,count(loan_type) as Total_Loans_Given
from loans
group by loan_type;

-- 44. Count customers by customer segment.
select customer_segment as Segment,count(customer_segment) as Customer_Count
from customers
group by customer_segment;

-- 45. Find total card spending.
select round(sum(amount),2) as Total_Card_Spendings 
from card_transactions;

-- 46. Find average card transaction amount.
select round(avg(amount),2) as Average_Card_Spendings 
from card_transactions;

-- 47. Find total principal paid through loan payments.
select round(sum(principal_paid),2) as Principal_Paid
from loan_payments;

-- 48. Find total interest collected through loan payments.
select round(sum(interest_paid),2) as Interest_Paid
from loan_payments;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- D. GROUP BY / HAVING

-- 49. Find total account balance by account type.
select account_type as Account_Type,round(sum(current_balance),2) as Account_Balance
from accounts
group by account_type;

-- 50. Find total transaction amount by channel.
select channel as Channel,round(sum(amount),2) as Transaction_Amount
from transactions
group by channel;

-- 51. Find transaction count by month.
select monthname(transaction_datetime),count(transaction_id) as Transactions
from transactions
group by month(transaction_datetime);

-- 52. Find total loan amount by loan type.
select loan_type as Loan_Type,round(sum(loan_amount),2) as Loan_Amount
from loans
group by loan_type;

-- 53. Find total outstanding amount by loan type.
select loan_type as Loan_Type,round(sum(outstanding_amount),2) as Outstanding_Loan_Amount
from loans
group by loan_type;

-- 54. Find average annual income by city.
select city as City,round(avg(annual_income),2) as Average_Annual_Income
from customers
group by city;

-- 55. Find customer count by state.
select state as State,count(customer_id) as Customer_Count
from customers
group by state;

-- 56. Find average salary by job title.
select occupation as Job_Title,round(avg(annual_income),2) as Average_Salary
from customers
group by occupation;

-- 57. Find employee count by branch.
select b.branch_name as Branch,count(e.employee_id) as Employees
from employees e
inner join branches b
on e.branch_id = b.branch_id
group by e.branch_id;

-- 58. Find branches having more than 4 employees.
select b.branch_name as Branch,count(e.employee_id) as Employees
from employees e
inner join branches b
on e.branch_id = b.branch_id
group by e.branch_id
having count(e.employee_id) > 4;

-- 59. Find cities having more than 50 customers.
select city as City,count(customer_id) as Total_Customers
from customers
group by City
having count(customer_id) > 50;

-- 60. Find loan types whose average loan amount exceeds 1,000,000.
select loan_type as Loan_Type,round(avg(loan_amount),2) as Average_Loan_Amount
from loans
group by loan_type
having avg(loan_amount) > 1000000;

-- 61. Find transaction channels with total transaction value above 3,500,000.
select channel as Transaction_Channel,round(sum(amount),2) as Transaction_Value
from transactions
group by Transaction_Channel
having sum(amount) > 3500000;

-- 62. Find account types having average balance above 50,000.
select account_type as Type,avg(current_balance) as Average_Balance
from accounts
group by account_type
having avg(current_balance) > 50000;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- E. String Functions

-- 63. Create a full_name using CONCAT.
select concat(first_name,' ',last_name) as Full_Name from customers;

-- 64. Convert customer names to uppercase.
select upper(concat(first_name,' ',last_name)) as Uppercase_Full_Name from customers;

-- 65. Convert customer names to lowercase.
select lower(concat(first_name,' ',last_name)) as Lowercase_Full_Name from customers;

-- 66. Find the length of each customer's first name.
select first_name as First_Name,length(first_name) as First_Name_Length from customers;

-- 67. Extract the first 3 characters of branch names.
select left(branch_name,3) as Branch from branches;

-- 68. Find customers whose names contain 'an'.
select * from customers where concat(first_name,' ',last_name) like '%an%';

-- 69. Concatenate city and state into one location field.
select concat(city,',',State) as Location from customers;

-- 70. Extract the first character of employee last names.
select left(last_name,1) as Last_Name from customers;

-- 71. Create an employee display name with employee_id.
select concat(employee_id,':-',first_name,' ',last_name) as Display_Name from employees;

-- 72. Replace spaces in branch names with hyphens.
select branch_name as Branch_Names,replace(branch_name,' ','-') as Updated_Branch_Names from branches;

-- 73. Find the position of 'a' in customer first names.
select first_name as Name,locate('a',first_name) as Position_of_a from customers;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- F. Date Functions
-- 74. Find customers who joined after 2022-01-01.
select * from customers where customer_since > '2022-01-01';

-- 75. Extract year from transaction_datetime.
select *,year(transaction_datetime) as Year from transactions;

-- 76. Extract month from transaction_datetime.
-- 75. Extract year from transaction_datetime.
select *,month(transaction_datetime) as Month from transactions;

-- 77. Find monthly transaction totals.
select year(transaction_datetime),monthname(transaction_datetime),round(sum(amount),2) as Monthly_Totals
from transactions
group by year(transaction_datetime),month(transaction_datetime);

-- 78. Find yearly transaction totals.
select year(transaction_datetime),round(sum(amount),2) as Monthly_Totals
from transactions
group by year(transaction_datetime);

-- 79. Find transactions performed on weekends.
select * from transactions
where dayofweek(transaction_datetime) in (1,7);

-- 80. Find customers whose customer_since is older than 5 years.
select * from customers 
where timestampdiff(Year,customer_since,curdate()) > 5;

-- 81. Find loans approved in 2025.
select * from loans where loan_status = 'Approved' and year(application_date) = '2025';

-- 82. Find the number of days between account opening and today.
select *,timestampdiff(day,opening_date,curdate()) as Number_Of_Days from accounts;

-- 83. Find loan payments made in the last 12 months.
select * from loan_payments where timestampdiff(month,payment_date,curdate()) <= 12;

-- 84. Find the month with the highest transaction amount.
select year(transaction_datetime),monthname(transaction_datetime) as Month,round(sum(amount),2) as Transaction_Amount
from transactions
group by year(transaction_datetime),month(transaction_datetime)
order by sum(amount) desc
limit 1;

-- 85. Find the quarter-wise transaction value.
select year(transaction_datetime),quarter(transaction_datetime) as Quarter,round(sum(amount),2) as Transaction_Value
from transactions
group by year(transaction_datetime),quarter(transaction_datetime);

-- 86. Find average monthly transaction amount.
select year(transaction_datetime),monthname(transaction_datetime) as Month,round(avg(amount),2) as Average_Transaction_Amount
from transactions
group by year(transaction_datetime),month(transaction_datetime);

-- 87. Find customers' age using date_of_birth.
select *,timestampdiff(year,date_of_birth,curdate()) as Age
from customers;

-- 88. Find employees who have worked for more than 5 years.
select * from employees
where date_sub(curdate(),interval 5 year) > hire_date;

-- 89. Find card transactions by day of week.
select dayofweek(transaction_datetime) as Day,round(sum(amount),2) as Transaction_Amount
from transactions
where transaction_type = 'ATM'
group by dayofweek(transaction_datetime)
order by dayofweek(transaction_datetime);

-- --------------------------------------------------------------------------------------------------------------------------------------
-- G. CASE Expressions
-- 90. Categorize customers as Low, Medium and High income.
select customer_id as ID,concat(first_name,' ',last_name) as Name,
case
	when annual_income < 25000 then 'Low'
    when annual_income between 25000 and 60000 then 'Medium'
    when annual_income > 60000 then 'High'
end as Category
from customers;

-- 91. Categorize account balances as Low, Medium and High.
select account_id as ID,current_balance as Balance,
case
	when current_balance < 10000 then 'Low'
    when current_balance between 10000 and 40000 then 'Medium'
    when current_balance > 40000 then 'High'
end as Category
from accounts;

-- 92. Categorize loans by size: Small, Medium, Large.
select loan_id,loan_type,loan_amount,
case 
	when loan_amount < 500000 then 'Small'
    when loan_amount between 500000 and 1000000 then 'Medium'
    when loan_amount > 1000000 then 'Large'
end as Loan_Category
from loans;

-- 93. Categorize transactions as Small/Medium/Large based on amount.
select transaction_id,transaction_type,amount,
case 
	when amount < 1000 then 'Small'
    when amount between 1000 and 10000 then 'Medium'
    when amount > 10000 then 'Large'
end as Transaction_Category
from transactions;

-- 94. Create a salary band for employees.
select *,
case 
	when salary < 40000 then 'Beginner'
    when salary between 40000 and 100000 then 'Intermediate'
    when salary > 100000 then 'Experienced'
end as Employee_Category
from employees;

-- 95. Create a risk label from loan risk_category.
select *,
case
	when risk_category in ('Good') then 'Low Risk'
    when risk_category in ('Watch') then 'Medium Risk'
    when risk_category in ('NPA','N/A') then 'High Risk'
end as Loan_Risk_Category
from loans;

-- 96. Identify customers as Young Adult, Adult or Senior based on age.
select *,
case 
	when (year(curdate()) - year(date_of_birth)) between 18 and 25 then 'Young Adult' 
    when (year(curdate()) - year(date_of_birth)) between 25 and 50 then 'Adult'
    when (year(curdate()) - year(date_of_birth)) > 50 then 'Senior' 
end as Customer_Category
from customers;

-- 97. Create a channel category: Digital vs Physical.
select *,
case 
	when channel in ('Internet Banking','Mobile App','UPI') then 'Digital'
    when channel in ('ATM','Branch','POS') then 'Physical'
end as Channel_Category
from transactions;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- H. Joins
-- 98. Display customers with their account details.
select concat(c.first_name,' ',c.last_name) as Name,c.annual_income as Annual_Income,a.account_type as Account_Type,
a.current_balance as Balance
from customers c
left join accounts a
on c.customer_id = a.customer_id;

-- 99. Display customers with their branch names.
select concat(c.first_name,' ',c.last_name) as Name,b.branch_name as Branch_Name
from customers c
left join branches b
on c.home_branch_id = b.branch_id;

-- 100. Display accounts with customer names.
select concat(first_name,' ',last_name) as Customer_name,a.*
from accounts a
left join customers c
on a.customer_id = c.customer_id;

-- 101. Display transactions with customer names.
select concat(first_name,' ',last_name) as Customer_name,t.*
from transactions t
left join customers c
on t.customer_id = c.customer_id;

-- 102. Display loans with customer names.
select concat(first_name,' ',last_name) as Customer_name,l.*
from loans l
left join customers c
on l.customer_id = c.customer_id;

-- 103. Display loans with branch names.
select b.branch_name as Branch_Name,l.*
from loans l
left join branches b
on l.branch_id = b.branch_id;

-- 104. Display employees with branch names.
select b.branch_name as Branch_Name,e.*
from employees e
left join branches b
on e.branch_id = b.branch_id;

-- 105. Display all customers even if they have no accounts.
select c.* ,a.*
from customers c
left join accounts a
on c.customer_id = a.customer_id;

-- 106. Display all branches and their employees.
select b.*,e.*
from branches b
left join employees e
on b.branch_id = e.branch_id;

-- 107. Find customers who have both an account and a loan.
select c.*
from customers c
inner join accounts a
on c.customer_id = a.customer_id
inner join loans l
on c.customer_id = l.customer_id;

-- 108. Find customers who have an account but no loan.
select c.*
from customers c
inner join accounts a
on c.customer_id = a.customer_id
left join loans l 
on c.customer_id = l.customer_id
where l.customer_id is null;

-- 109. Find customers who have a loan but no card.
select c.*
from customers c
inner join loans l
on c.customer_id = l.customer_id
left join cards cd
on c.customer_id = cd.customer_id
where cd.customer_id is null;

-- 110. Join loans with loan payments.
select l.*,lp.principal_paid,lp.interest_paid,lp.total_payment,lp.payment_method,lp.payment_status,lp.payment_date
from loans l
left join loan_payments lp
on l.loan_id = lp.loan_id;

-- 111. Join cards with card transactions.
select c.*,ct.channel,ct.amount,ct.merchant_category,ct.transaction_status,ct.transaction_datetime
from cards c
left join card_transactions ct
on c.card_id = ct.card_id;

-- 112. SELF JOIN: Display employees with their manager names.
select e.*,em.first_name as Manager
from employees e
left join employees em
on e.manager_id = em.employee_id;

-- 113. SELF JOIN: Find employees who report to a Branch Manager.
select e.employee_id as ID,e.first_name as Name,e.last_name as Surname,e.job_title as Title,em.first_name as Manager,em.job_title as Manager_Title
from employees e
left join employees em
on e.manager_id = em.employee_id
where em.job_title = 'Branch Manager';

-- 114. Find branches with no loans.
select b.*
from branches b
left join loans l
on b.branch_id = l.branch_id
where l.branch_id is null;

-- 115. Find branches with no customers.
select b.*
from branches b
left join customers c
on b.branch_id = c.home_branch_id
where c.home_branch_id is null;

-- 116. Find customers with multiple accounts.
select c.customer_id as ID,c.first_name as Name,c.last_name as Surname,count(a.account_type) as Number_Of_Accounts
from customers c
inner join accounts a
on c.customer_id = a.customer_id
group by c.customer_id,c.first_name,c.last_name
having count(a.account_type) > 1;

-- 117. Find customers with multiple cards.
select c.customer_id as ID,c.first_name as Name,c.last_name as Surname,count(cd.card_type) as Card_Count
from customers c
inner join cards cd
on c.customer_id = cd.customer_id
group by c.customer_id,c.first_name,c.last_name
having count(cd.card_type) > 1;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- I. Subqueries
-- 118. Find customers whose income is above average.
with average_income as(
	select round(avg(annual_income)) as Average from customers
)
select c.customer_id,concat(c.first_name,' ',c.last_name) as Name,c.annual_income as Income,a.Average
from customers c
cross join average_income a
where annual_income > Average;

-- 119. Find accounts with balance above average account balance.
with average_balance as(
	select round(avg(current_balance),2) as Average from accounts
)
select a.account_id,a.account_type,a.current_balance,ab.Average
from accounts a
cross join average_balance ab
where a.current_balance > ab.Average;

-- 120. Find transactions greater than average transaction amount.
with transaction_balance as(
	select round(avg(amount),2) as Average from transactions
)
select t.transaction_id,t.transaction_type,t.amount,tb.Average
from transactions t
cross join transaction_balance tb
where t.amount > tb.Average;

-- 121. Find loans above average loan amount.
with loan_amount as(
	select round(avg(loan_amount),2) as Average from loans
)
select l.loan_id,l.loan_type,l.loan_status,l.loan_amount,la.Average
from loans l
cross join loan_amount la
where l.loan_amount > la.Average;

-- 122. Find customers who have the highest annual income.
with highest_income as(
	select max(annual_income) as Highest_Income from customers
)
select c.* 
from customers c
cross join highest_income hi
where c.annual_income = hi.Highest_Income;

-- 123. Find the branch with the highest number of customers.
with Highest_Customers as(
	select home_branch_id as Branch,count(customer_id) as Total_Customers
    from customers
    group by home_branch_id
    order by count(customer_id) desc
    limit 1
)
select b.branch_name,hc.Total_Customers as Customers
from branches b
cross join Highest_Customers hc
where b.branch_id = hc.Branch;

-- 124. Find employees earning above average salary.
with average_salary as(
	select round(avg(salary),2) as average from employees
)
select e.* ,aa.*
from employees e
cross join average_salary aa
where e.salary > aa.average;

-- 125. Find customers whose account balance is above their city's average.
with city_average as(
	select city,round(avg(annual_income),2) as City_Average
    from customers c
    group by city
),
comparison as(
	select c.first_name as name,c.last_name as Surname,c.city as City,c.annual_income as Annual_Income,ca.City_Average as City_Average
	from customers c
	inner join city_average ca
    on c.city = ca.city
)
select * from comparison
where Annual_Income > City_Average;

-- 126. Find the second-highest transaction amount.
with highest_transaction as(
	select max(amount) as Maximum from transactions
)
select ht.Maximum as Highest,max(t.amount) as Second_Highest
from transactions t
cross join highest_transaction ht
where t.amount < ht.Maximum;

-- 127. Find the second-highest salary.
with highest_salary as(
	select max(salary) as Maximum from employees
)
select hs.Maximum as Highest,max(e.salary) as Second_Highest
from employees e
cross join highest_salary hs
where e.salary < hs.Maximum;

-- 128. Find loans with outstanding amount above average outstanding amount.
with avg_outstanding_amount as(
	select round(avg(outstanding_amount),2) as avg_outstanding_amount
    from loans
)
select l.*,aoa.*
from loans l
cross join avg_outstanding_amount aoa
where l.outstanding_amount >  aoa.avg_outstanding_amount;

-- 129. Find customers whose total transaction value is above average customer transaction value.
with customer_transaction as(
	select customer_id,round(sum(amount),2) as Total_Transaction
    from transactions
    group by customer_id
),
average_transaction as(
	select round(avg(amount),2) as Average_Transaction 
    from transactions
),
all_in_one as(
	select c.customer_id as ID,c.first_name as Name,c.last_name as Surname,at.Average_Transaction as Overall_Average_Transaction,
    ct.Total_transaction as Indivitual_Total_Transactions
    from customers c
    cross join average_transaction at
    inner join customer_transaction ct
    on c.customer_id = ct.customer_id
)	
select * from all_in_one
where Indivitual_Total_Transactions > Overall_Average_Transaction;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- J. EXISTS / NOT EXISTS
-- 130. Find customers who have at least one account.
select c.* 
from customers c
where exists(
	select 1
    from accounts a
    where c.customer_id = a.customer_id
);

-- 131. Find customers who have at least one loan.
select c.*
from customers c
where exists(
	select 1
    from loans l
    where l.customer_id = c.customer_id
);

-- 132. Find customers who have at least one successful transaction.
select c.*
from customers c
where exists(
	select 1
    from transactions t
    where t.customer_id = c.customer_id and transaction_status = 'Success'
);

-- 133. Find customers who have both an account and a loan using EXISTS.
select c.*
from customers c
where exists(
	select 1 
    from accounts a
    where c.customer_id = a.customer_id and exists(
		select 1 
        from loans l
        where c.customer_id = l.customer_id
    )
);

-- 134. Find customers who have an account but no loan using NOT EXISTS.
select c.*
from customers c
where exists(
	select 1
    from accounts a
    where c.customer_id = a.customer_id
)
and not exists(
	select 1
    from loans l
    where c.customer_id = l.customer_id
);

-- 135. Find branches having at least one loan.
select b.*
from branches b
where exists(
	select 1
    from loans l
    where b.branch_id = l.branch_id
);

-- 136. Find employees working in branches that have customers.
select e.*
from employees e
where exists(
	select 1
    from customers c
    where c.home_branch_id = e.branch_id
);

-- 137. Find customers who have a card transaction.
select c.*
from customers c
where exists(
	select 1
    from cards ca
    where ca.customer_id = c.customer_id
);

-- 138. Find loans that have at least one payment.
select *
from loans l
where exists(
	select 1 
    from loan_payments lp
    where lp.loan_id = l.loan_id
);

-- 139. Find accounts that have no transactions.
select a.*
from accounts a
where not exists(
	select 1 
    from transactions t
    where t.account_id = a.account_id
);

-- 140. Find customers who have no card.
select c.*
from customers c
where not exists(
	select 1 
    from cards ca
    where c.customer_id = ca.customer_id
);

-- 141. Find branches with no employees.
select b.*
from branches b
where not exists(
	select 1
    from employees e
    where e.branch_id = b.branch_id
);

-- --------------------------------------------------------------------------------------------------------------------------------------
-- K. CTEs
-- 142. Use a CTE to calculate total transaction amount per customer.
with transaction_per_customer as(
	select customer_id,round(sum(amount),2) as Total
    from transactions
    group by customer_id
)
select c.*,tpc.Total as Total_Transactions
from customers c
inner join transaction_per_customer tpc
on c.customer_id = tpc.customer_id;

-- 143. Use a CTE to find the top 10 customers by transaction value.
with transaction_per_customer as(
	select customer_id,round(sum(amount),2) as Total
    from transactions
    group by customer_id
)
select c.*,tpc.Total as Total_Transactions
from customers c
inner join transaction_per_customer tpc
on c.customer_id = tpc.customer_id
order by Total_Transactions desc
limit 10;

-- 144. Use multiple CTEs to compare deposits and withdrawals.
with deposit as(
	select customer_id as ID,round(sum(amount),2) as Deposit_Amount
    from transactions
    where transaction_direction = 'Credit'
    group by customer_id
),
withdrawal as(
	select customer_id as ID,round(sum(amount),2) as Withdrawal_Amount
    from transactions
    where transaction_direction = 'Debit'
    group by customer_id
)
select d.ID,d.Deposit_Amount,w.Withdrawal_Amount,(d.Deposit_Amount - w.Withdrawal_Amount) as Difference
from deposit d
left join withdrawal w
on d.ID = w.ID;

-- 145. Use a CTE to calculate monthly transaction totals.
with monthly_transaction as(
	select year(transaction_datetime) as Year,monthname(transaction_datetime) as Month,round(sum(amount),2) as Monthly_Transaction
    from transactions
    group by year(transaction_datetime),month(transaction_datetime)
)
select Year,Month,Monthly_Transaction
from monthly_transaction;

-- 146. Use a CTE to calculate average monthly transaction amount.
with monthly_transaction as(
	select year(transaction_datetime) as Year,monthname(transaction_datetime) as Month,round(avg(amount),2) as Average_Monthly_Transaction
    from transactions
    group by year(transaction_datetime),month(transaction_datetime)
)
select Year,Month,Average_Monthly_Transaction
from monthly_transaction;

-- 147. Use a CTE to find customers whose loan amount exceeds their annual income.
with customer_loan as(
	select customer_id,loan_amount
    from loans
)
select c.customer_id as ID,c.first_name as Name,c.last_name as Surname,c.annual_income as Annual_Income,cl.loan_amount as Loan_Amount
from customers c
inner join customer_loan cl
on c.customer_id = cl.customer_id 
where c.annual_income < cl.loan_amount;

-- 148. Use multiple CTEs to calculate customer income, account balance and loan exposure.
with customer_income as(
	select customer_id as Customer_ID,first_name as Name,last_name as Surname,annual_income as Income
    from customers
),
account_balance as(
	select customer_id as Customer_ID,account_id as Account_ID,current_balance as Balance
    from accounts
),
loan_exposure as(
	select customer_id as Customer_ID,loan_id as Loan_ID,loan_amount as Loan_Amount,interest_rate as ROI,tenure_months as Tenure_Months
    from loans
)
select ci.Customer_ID as Customer_ID,ci.Name as Name,ci.Surname as Surname,ci.Income as Income,ab.Account_ID as Account_ID,
ab.Balance as Current_Balance,le.Loan_ID as Loan_ID,le.Loan_Amount as Loan_Amount,le.ROI as ROI,le.Tenure_Months as Tenure_Months
from customer_income ci
inner join account_balance ab
on ci.Customer_ID = ab.Customer_ID
inner join loan_exposure le
on ab.Customer_ID = le.Customer_ID;

-- 149. Use a CTE to identify customers with both high deposits and high loans.
with high_deposits as(
	select customer_id,
    case
		when amount < 2000 then 'Low Deposits'
        when amount between 2000 and 10000 then 'Medium Deposit'
        when amount > 10000 then 'High Deposits'
	end as Deposits
    from transactions 
),
high_loans as(
	select customer_id,
    case 
		when loan_amount < 500000 then 'Low Loan'
        when loan_amount between 500000 and 1000000 then 'Medium Loan'
        when loan_amount > 1000000 then 'High Loan'
	end as Loans
    from loans
)
select c.* 
from customers c
inner join high_deposits hd
on c.customer_id = hd.customer_id
inner join high_loans hl
on hd.customer_id = hl.customer_id
where hd.Deposits = 'High Deposits' and hl.Loans = 'High Loan';

-- 150. Use a CTE to calculate branch-level KPIs.
with customer_section as(
	select home_branch_id,count(customer_id) as Count_Customers
    from customers
    group by home_branch_id
),
loan_section as(
	select branch_id,sum(loan_amount) as Loan
    from loans
    group by branch_id
),
employee_section as(
	select count(employee_id) as Emp,branch_id
    from employees
    group by branch_id
),
account_section as(
	select branch_id,count(account_id) as Acc,round(sum(current_balance),2) as Bal
    from accounts
    group by branch_id
)
select b.branch_name as Branch,b.city as Branch_Location,cs.Count_Customers,ls.Loan as Loan_Given,es.Emp as No_Of_Employees,
ae.Acc as No_Of_Accounts,ae.Bal as Current_Available_Balance
from branches b
left join customer_section cs
on b.branch_id = cs.home_branch_id
left join loan_section ls
on b.branch_id = ls.branch_id
left join employee_section es
on b.branch_id = es.branch_id
left join account_section ae
on b.branch_id = ae.branch_id;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- L. Window Functions
-- 151. Rank customers by annual income.
select customer_id as ID,concat(first_name,' ',last_name) as Name,annual_income as Income,
rank() over(order by annual_income desc) as Income_Rank
from customers;

-- 152. Rank customers within each city by income.
select customer_id as ID,concat(first_name,' ',last_name) as Name,annual_income as Income,city as City,
rank() over(partition by city order by annual_income desc) as Income_Rank
from customers;

-- 153. Rank loans within each loan type by loan amount.
select loan_id as ID,loan_type as Type,loan_amount as Amount,
rank() over(partition by loan_type order by loan_amount desc) as Top_Ranking
from loans;

-- 154. Use DENSE_RANK to find top customers by transaction value.
select t.customer_id as ID,c.first_name as Name,c.last_name as Surname,t.amount as Transaction_Value,
dense_rank() over(order by t.amount desc) as Ranking
from transactions t
left join customers c
on t.customer_id = c.customer_id;

-- 155. Use ROW_NUMBER to find each customer's largest transaction.
with largest_transaction as(
	select customer_id,amount,
    row_number() over(partition by customer_id order by amount desc) as Ranking
    from transactions
)
select c.customer_id as ID,c.first_name as Name,c.last_name as Surname,lt.amount as Amount
from customers c
inner join largest_transaction lt
on c.customer_id = lt.customer_id
where lt.Ranking = 1;

-- 156. Use LAG to compare each month's transaction value with the previous month.
with monthly_transactions as(
	select year(transaction_datetime) as Year,monthname(transaction_datetime) as Monthname,month(transaction_datetime) as Month,
    round(sum(amount),2) as Transaction
    from transactions
    group by year(transaction_datetime),month(transaction_datetime)
)
select Year,Monthname,Transaction as Current_Month_Transaction,
lag(Transaction) over(order by Year,Month) as Previous_Month_Transaction
from monthly_transactions;

-- 157. Use LEAD to compare a month with the next month.
with monthly_transactions as(
	select year(transaction_datetime) as Year,monthname(transaction_datetime) as Monthname,month(transaction_datetime) as Month,
    round(sum(amount),2) as Transaction
    from transactions
    group by year(transaction_datetime),month(transaction_datetime)
)
select Year,Monthname,Transaction as Current_Month_Transaction,
lead(Transaction) over(order by Year,Month) as Next_Month_Transaction
from monthly_transactions;

-- 158. Calculate month-over-month transaction growth.
with monthly_amount as(
	select year(transaction_datetime) as Year,monthname(transaction_datetime) as MonthName,
    month(transaction_datetime) as Month,round(sum(amount),2) as Current_Month_Amount,
    lag(round(sum(amount),2)) over(order by year(transaction_datetime),month(transaction_datetime)) as Previous_Month_Amount
    from transactions
    group by year(transaction_datetime),month(transaction_datetime)
)
select Year,MonthName,Current_Month_Amount,Previous_Month_Amount,
round((((Current_Month_Amount - Previous_Month_Amount)/Previous_Month_Amount)*100),2) as Growth_Percent
from monthly_amount;

-- 159. Calculate a running total of transactions by month.
with monthly_transactions as(
	select year(transaction_datetime) as Year,monthname(transaction_datetime) as Monthname,month(transaction_datetime) as Month,
    round(sum(amount),2) as Transaction
    from transactions
    group by year(transaction_datetime),month(transaction_datetime)
)
select Year,Monthname,Transaction as Current_Month_Transaction,
sum(Transaction) over(order by Year,Month) as Transaction_Total
from monthly_transactions;

-- 160. Calculate cumulative loan payments by customer.
select lp.customer_id as ID,c.first_name as Name,c.last_name as Surname,year(lp.payment_date) as Year,monthname(lp.payment_date) as Month,
lp.total_payment as Current_Installment,sum(lp.total_payment) over(partition by lp.customer_id order by year(lp.payment_date),month(lp.payment_date)) as Cummulative_Payment
from loan_payments lp
inner join customers c
on lp.customer_id = c.customer_id;

-- 161. Calculate each customer's percentage contribution to total transaction value.
with total_transaction as(
	select round(sum(amount),2) as Total_Transaction 
    from transactions
),
indivitual_transaction as(
	select customer_id,round(sum(amount),2) as indivitual_transaction
    from transactions
    group by customer_id
)
select it.customer_id as Customer_ID,round(((it.indivitual_transaction/tt.Total_Transaction)*100),2) as Contribution_Percentage
from indivitual_transaction it
cross join total_transaction tt;

-- 162. Calculate branch transaction ranking.
select a.branch_id,b.branch_name,count(t.transaction_id) as Transactions,
rank() over(order by count(t.transaction_id) desc) as Rankings
from transactions t
left join accounts a
on t.account_id = a.account_id
inner join branches b
on a.branch_id = b.branch_id
group by b.branch_name,b.branch_id
order by Transactions desc;

-- 163. Find the top 3 customers in every city.
with top3Customers as(
	select c.customer_id as ID,concat(c.first_name,' ',c.last_name) as Name,c.city as City,round(sum(t.amount),2) as Transaction_Amount,
    rank() over(partition by c.city order by round(sum(t.amount),2) desc) as Rankings
    from customers c
    left join transactions t
    on c.customer_id = t.customer_id
    group by c.customer_id
    order by c.city,Rankings
)
select ID,Name,City,Transaction_Amount,Rankings
from top3Customers 
where Rankings between 1 and 3;

-- 164. Find the top 3 loans in each loan type.
with Top3loans as(
	select customer_id,loan_amount,loan_type,
    row_number() over(partition by loan_type order by loan_amount desc) as Rankings
    from loans
)
select customer_id as Customer_ID,loan_amount as Loan_Amount,loan_type as Loan_Type,Rankings
from Top3loans
where Rankings between 1 and 3;

-- 165. Calculate a 3-month moving average of transaction value.
with monthly_average as(
	select year(transaction_datetime) as Year,monthname(transaction_datetime) as MonthName,month(transaction_datetime) as Month,round(sum(amount),2) as Monthly_Average
    from transactions
    group by year(transaction_datetime),month(transaction_datetime)
)
select Year,MonthName,Monthly_Average,
avg(Monthly_Average) over(order by Year,Month rows between 2 preceding and current row) as Moving_3_Month_Average
from monthly_average;

-- 166. Calculate a customer's previous transaction amount using LAG.
with customer_transaction as(
	select customer_id,amount,transaction_datetime
    from transactions
    order by customer_id
)
select customer_id as ID,transaction_datetime as Date_Time,amount as Current_Transaction,
lag(amount) over(partition by customer_id order by transaction_datetime) as Previous_Transaction
from customer_transaction;

-- 167. Find customers whose transaction amount increased compared with their previous transaction.
with customer_transaction as(
	select customer_id,amount,transaction_datetime
    from transactions
    order by customer_id
),
comparison as(
	select customer_id as ID,transaction_datetime as Date_Time,
	lag(amount) over(partition by customer_id order by transaction_datetime) as Previous_Transaction,amount as Current_Transaction
	from customer_transaction
)
select ID,Date_Time,Previous_Transaction,Current_Transaction
from comparison
where (Current_Transaction - Previous_Transaction) > 0;

-- 168. Use NTILE(4) to divide customers into four income groups.
select customer_id as ID,concat(first_name,last_name) as Name,annual_income as Income,
NTILE(4) over(order by annual_income desc)
from customers
order by customer_id;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- M. Advanced SQL / Business Logic
-- 169. Find duplicate customer records based on name + date of birth.
select first_name,last_name,date_of_birth,count(*)
from customers
group by first_name,last_name,date_of_birth
having count(*) > 1;

-- 170. Find accounts with no transactions.
select a.*
from accounts a
left join transactions t
on a.account_id = t.account_id
where t.account_id is null;

-- 171. Find customers with more than one account type.
select c.*,count(a.account_type) as Accounts
from customers c
left join accounts a
on c.customer_id = a.customer_id
group by a.customer_id
having count(distinct a.account_type) > 1;

-- 172. Find customers with both credit and debit transactions.
with credit as(
	select customer_id as credit_id,transaction_direction
    from transactions 
    where transaction_direction = 'Credit'
    group by customer_id
),
debit as(
	select customer_id as debit_id,transaction_direction
    from transactions 
    where transaction_direction = 'Debit'
    group by customer_id
),
both_transaction as(
	select c.credit_id as both_id
	from credit c
	inner join debit d
	on c.credit_id = d.debit_id
)
select c.*
from customers c
inner join both_transaction bt
on bt.both_id = c.customer_id;

-- 173. Find customers whose total deposits exceed total withdrawals.
with total_deposit as(
	select customer_id as deposit_id,round(sum(amount),2) as Deposit_Amount
    from transactions
    where transaction_direction = 'Credit'
    group by customer_id
),
total_withdrawal as(
	select customer_id as withdrawal_id,round(sum(amount),2) as Withdrawal_Amount
    from transactions
    where transaction_direction = 'Debit'
    group by customer_id
),
both_transaction as(
	select d.deposit_id,w.withdrawal_id,d.Deposit_Amount as Deposit,w.Withdrawal_Amount as Withdrawal
	from total_deposit d
	inner join total_withdrawal w
	on d.deposit_id = w.withdrawal_id
)
select c.customer_id as ID,concat(c.first_name,' ',c.last_name) as Name,t.Deposit as Deposit,t.Withdrawal as Withdrawal,
(Deposit - Withdrawal) as Difference
from customers c
inner join both_transaction t
on c.customer_id = t.deposit_id
where t.Deposit > t.Withdrawal;

-- 174. Find customers whose total loan outstanding is greater than their account balance.
with loan_paid as(
	select lp.customer_id as cust_id,a.current_balance as Account_Balance,l.loan_amount as Loan,round(sum(lp.total_payment),2) as loan_paid,
    (l.loan_amount - (round(sum(lp.total_payment),2))) as Loan_Outstanding
    from loans l
    inner join loan_payments lp
    on l.loan_id = lp.loan_id
    left join accounts a
    on lp.customer_id = a.customer_id
    group by lp.customer_id
)
select cust_id as ID,Loan,loan_paid,Account_Balance,Loan_Outstanding
from loan_paid
where Account_Balance < Loan_Outstanding;

-- 175. Find the most active customer by transaction count.
with most_transactions as(
	select customer_id,count(transaction_id) as Transaction_Count
    from transactions
    group by customer_id
    order by count(transaction_id) desc
)
select concat(c.first_name,' ',c.last_name) as Name,mt.customer_id,mt.Transaction_Count
from most_transactions mt
inner join customers c
on mt.customer_id = c.customer_id
where Transaction_Count = (select max(Transaction_Count) from most_transactions);

-- 176. Find the most active branch by transaction count.
with transaction_count as(
	select account_id,count(transaction_id) as Transaction_Count
	from transactions
	group by account_id
),
branch_number as(
	select a.branch_id as Branch_Id,sum(tc.Transaction_Count) as Transaction_Count
	from transaction_count tc
	inner join accounts a
	on tc.account_id = a.account_id 
    group by a.branch_id
)
select b.branch_name,bn.Transaction_Count
from branch_number bn
inner join branches b
on bn.Branch_Id = b.branch_id
having bn.Transaction_Count = (select max(Transaction_Count) from branch_number)
order by bn.Transaction_Count desc;

-- 177. Find the month with the highest card spending.
select year(transaction_datetime) as Year,monthname(transaction_datetime) as Month,round(sum(amount),2) as Spending
from transactions
where channel = 'ATM'
group by year(transaction_datetime),monthname(transaction_datetime)
order by sum(amount) desc
limit 1;

-- 178. Find customers with consecutive transaction months.
with transaction_month as(
	select customer_id as ID,month(transaction_datetime) as Current_Month,
	lead(month(transaction_datetime)) over(partition by customer_id order by transaction_datetime) as Next_Month
	from transactions
)
select tm.ID,concat(c.first_name,' ',c.last_name) as Name
from transaction_month tm
inner join customers c
on tm.ID = c.customer_id
where (Next_Month - Current_Month) = 1 or (Next_Month - Current_Month) = -11
group by tm.ID;

-- 179. Find the longest gap between two transactions for each customer.
with consecutive_transactions as(
	select customer_id as Customer_ID,transaction_datetime as Current_Transaction,
	lead(transaction_datetime) over(partition by customer_id order by transaction_datetime) as Next_Transaction
	from transactions
),
gap as(
	select Customer_ID,Current_Transaction,Next_Transaction,datediff(Next_Transaction,Current_Transaction) as Difference,
    row_number() over(partition by Customer_ID order by Difference desc) as Ranking
    from consecutive_transactions
    where (datediff(Next_Transaction,Current_Transaction)) is not null
    order by Customer_ID,Difference
)
select Customer_ID,Difference
from gap
where Ranking = 1;

-- 180. Find each customer's first transaction.
with first_transaction as(
	select customer_id,transaction_datetime,
	row_number() over(partition by customer_id order by transaction_datetime) as Ranking
	from transactions
)
select customer_id as ID,transaction_datetime as First_Transaction
from first_transaction
where Ranking = 1;

-- 181. Find each customer's latest transaction.
with last_transaction as(
	select customer_id,transaction_datetime,
	row_number() over(partition by customer_id order by transaction_datetime desc) as Ranking
	from transactions
)
select customer_id as ID,transaction_datetime as Last_Transaction
from last_transaction
where Ranking = 1;

-- 182. Find dormant accounts with no transaction activity.
select a.account_id,t.account_id
from accounts a
left join transactions t
on a.account_id = t.account_id
where t.account_id is null;

-- 183. Find customers who use multiple transaction channels.
select customer_id,count(distinct channel) as Channels_Used
from transactions
group by customer_id
having count(distinct channel) > 1;

-- 184. Find customers who use both branch and digital channels.
select distinct customer_id 
from transactions t
where exists(
	select 1
    from transactions t1
    where t1.customer_id = t.customer_id
    and channel in ('Internet Banking','Mobile App','UPI')
) 
and exists(
	select 1
    from transactions t2
    where t2.customer_id = t.customer_id
    and channel in ('ATM','Branch','POS')
);

-- 185. Find customers whose loan payments were late more than once.
with late_payments as(
	select customer_id,count(payment_status) as Late_Payment,payment_status
	from loan_payments
	where payment_status = 'Late'
	group by customer_id
)
select customer_id,Late_Payment
from late_payments
where Late_Payment > 1;

-- 186. Find branches where average customer income is above the overall average.
with overall_average as(
	select round(avg(annual_income),2) as Overall_Average 
    from customers
),
branch_average as(
	select home_branch_id,round(avg(annual_income),2) as Branch_Average 
    from customers
    group by home_branch_id
),
comparison as(
	select ba.home_branch_id as Branch_ID,ba.Branch_Average,oa.Overall_Average
	from branch_average ba
	cross join overall_average oa
)
select b.branch_name,c.Branch_ID,c.Branch_Average,c.Overall_Average 
from comparison c
left join branches b
on c.Branch_ID = b.branch_id
where c.Branch_Average > c.Overall_Average;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- N. Cross Join / Set Logic
-- 187. Create every combination of account type and customer segment using CROSS JOIN.
select c.customer_segment,a.account_type
from customers c
cross join accounts a;

-- 188. Generate a branch × loan type matrix using CROSS JOIN.
select b.branch_name,l.loan_type as Loan_Type
from branches b
cross join loans l;

-- 189. Use UNION to combine customers from two selected states.
select customer_id as ID,concat(first_name,' ',last_name) as Name,city as City
from customers
where city = 'Pune'

union

select customer_id as ID,concat(first_name,' ',last_name) as Name,city as City
from customers
where city = 'Mumbai';

-- 190. Use UNION ALL to combine two transaction subsets.
select account_id as ID,customer_id as ID,reference_number as Reference_Number,transaction_datetime as DateAndTime
from transactions
where transaction_status = 'Reversed'

UNION ALL

select account_id as ID,customer_id as ID,reference_number as Reference_Number,transaction_datetime as DateAndTime
from transactions
where transaction_status = 'Failed';

-- 191. Use INTERSECT-style logic where supported to find common customers between accounts and loans.
select distinct a.customer_id 
from accounts a
inner join loans l
on a.customer_id = l.customer_id;

-- 192. Use NOT EXISTS / EXCEPT-style logic to find customers with accounts but no loans.
select a.customer_id,a.account_id
from accounts a
where not exists(
	select 1
    from loans l
    where l.customer_id = a.customer_id
);

-- --------------------------------------------------------------------------------------------------------------------------------------
-- O. Views / Procedures / Indexes
-- 193. Create a view showing customer + account information.
create view Customer_Account as
select c.customer_id as Customer_ID,concat(first_name,' ',last_name) as Name,
account_id as Account_ID,account_type as Account_Type,current_balance as Available_Balance
from customers c
left join accounts a
on c.customer_id = a.customer_id;

select * from Customer_Account;

-- 194. Create a view showing customer transaction summary.
create view Customer_Transaction as
select c.customer_id as Customer_ID,concat(first_name,' ',last_name) as Name,count(t.transaction_id) as Transactions,
round(sum(amount),2) as Total_Transaction_Amount
from customers c
left join transactions t
on c.customer_id = t.customer_id
group by c.customer_id;

select * from Customer_Transaction
order by customer_id;
-- drop view Customer_Transaction;

-- 195. Create a view showing branch performance.
create view Branch_Performance as
with branch as(
	select branch_id,branch_name,city
    from branches
),
branch_accounts as(
	select branch_id,count(distinct account_id) as Accounts,round(sum(current_balance),2) as Branch_Balance
    from accounts
    group by branch_id
),
branch_customers as(
	select home_branch_id,count(distinct customer_id) as Customers
    from customers
    group by home_branch_id
),
branch_employees as(
	select branch_id,count(distinct employee_id) as Employees
    from employees
    group by branch_id
),
branch_loans as(
	select branch_id,count(distinct loan_id) as Loan_Count,sum(loan_amount) as Loan_Amount
    from loans 
    group by branch_id 
)
select b.branch_id,b.branch_name,b.city,ba.Accounts,ba.Branch_Balance,bc.Customers,be.Employees,Loan_Count,Loan_Amount
from branch b
left join branch_accounts ba
on b.branch_id = ba.branch_id
left join branch_customers bc
on b.branch_id = bc.home_branch_id
left join branch_employees be
on b.branch_id = be.branch_id
left join branch_loans bl
on b.branch_id = bl.branch_id;

select * from Branch_Performance;

-- 206. Insert a test transaction and rollback.
start transaction;
insert into branches(
	branch_id,branch_name,city,state,region,opened_dates
)
values(
	9999,'SWARGATE','CROYDON','LONDON','UK','2030-04-31'
);
rollback;
select * from branches where branch_id = 9999;

-- 196. Create a view showing loan portfolio summary.
create view Loan_Portfolio as
with loans_portfolio as(
	select loan_id,customer_id,branch_id,sum(loan_amount) as Loan_Amount
    from loans
    group by customer_id
),
payments_portfolio as(
	select loan_id,customer_id,round(sum(total_payment),2) as Total_Repayment
    from loan_payments
    group by customer_id
)
select lp.customer_id as Customer_ID,lp.loan_id as Loan_ID,lp.Loan_Amount,coalesce(pp.Total_Repayment,0) as Total_Repayment
from loans_portfolio lp
left join payments_portfolio pp
on lp.loan_id = pp.loan_id;

select * from Loan_Portfolio;

-- 197. Create a view showing customer financial profile.
create view Customer_Financial_Profile as
with customer as(
	select customer_id,concat(first_name,' ',last_name) as Name,annual_income as Income_Annually,
    concat(city,', ',state) as Address,date_of_birth as DOB
    from customers
),
customer_loans as(
	select customer_id,sum(case when loan_status = 'Approved' then loan_amount else 0 end) as Loan_Amount
    from loans
    group by customer_id
),
customer_payment as(
	select customer_id,round(sum(total_payment),2) as Loan_Repaid
    from loan_payments
    group by customer_id
),
customer_transactions as(
	select customer_id,count(transaction_id) as Transactions,
    round(sum(case when transaction_direction = 'Debit' then amount else 0 end),2) as Total_Debit_Amount,
    round(sum(case when transaction_direction = 'Credit' then amount else 0 end),2) as Total_Credit_Amount
    from transactions
    group by customer_id
)
select c.customer_id,c.Name,c.Income_Annually,c.Address,c.DOB,coalesce(cl.Loan_Amount,0) as Loan_Amount,
coalesce(cp.Loan_Repaid,0) as Loan_Repaid,ct.Transactions,ct.Total_Debit_Amount,ct.Total_Credit_Amount
from customer c
left join customer_loans as cl
on c.customer_id = cl.customer_id
left join customer_payment as cp
on c.customer_id = cp.customer_id
left join customer_transactions as ct
on c.customer_id = ct.customer_id;

select * from Customer_Financial_Profile where customer_id = 20222;
 
-- 198. Create a procedure to return transactions for a given customer.
DELIMITER //

CREATE PROCEDURE GET_CUSTOMER_TRANSACTION(IN pcustomer_id INT)
BEGIN
    SELECT 
        transaction_id,customer_id,transaction_type,transaction_direction,amount,channel,
        transaction_status,reference_number,transaction_datetime
    FROM transactions
    WHERE customer_id = pcustomer_id;
END //

DELIMITER //

call GET_CUSTOMER_TRANSACTION(20111);

-- 199. Create a procedure to return loans for a given customer.
DELIMITER //
	create procedure CUSTOMER_LOANS(in p_customer_id int)
    begin
		select loan_id,customer_id,branch_id,loan_type,loan_status,loan_amount,interest_rate,tenure_months,outstanding_amount,
        risk_category,application_date
        from loans 
        where customer_id = p_customer_id;
    end //
DELIMITER // 

call CUSTOMER_LOANS(20123);

-- 200. Create a procedure to return transactions for a selected date range.
delimiter //
	create procedure GET_CUSTOMER_TRANSACTION_RANGE(in p_customer_id int,in p_begin_date date,in p_end_date date)
	begin
		select transaction_id,account_id,customer_id,transaction_type,transaction_direction,amount,
        channel,transaction_status,reference_number,transaction_datetime
        from transactions 
        where customer_id = p_customer_id
        and p_begin_date <= transaction_datetime
        and p_end_date >= transaction_datetime ;
    end //
delimiter //

drop procedure if exists GET_CUSTOMER_TRANSACTION_RANGE;

call GET_CUSTOMER_TRANSACTION_RANGE(20001,'2024-10-01','2025-04-01');

-- 201. Create a procedure that accepts a branch_id and returns branch KPIs.
delimiter //
	create procedure GET_BRANCH_KPIS(in p_branch_id int)
    begin
	with branch_KPIS as(
		select branch_id as ID,branch_name as Branch,concat(city,',',state) as Address
		from branches
	),
	account_KPIS as(
		select branch_id,count(distinct account_id) as Accounts,count(distinct customer_id) as Customers,
		round(sum(current_balance),2) as Current_Bank_Balance
		from accounts
		group by branch_id
	),
	employee_KPIS as(
		select branch_id,count(distinct employee_id) as Employees
		from employees
		group by branch_id
	)
	select bk.ID,bk.Branch,bk.Address,ak.Accounts,ak.Customers,ak.Current_Bank_Balance,ek.Employees
	from branch_KPIS bk
	left join account_KPIS ak
	on bk.ID = ak.branch_id
	left join employee_KPIS ek
	on bk.ID = ek.branch_id
    where bk.ID = p_branch_id;
    end //
delimiter //

call GET_BRANCH_KPIS(111);

drop procedure if exists GET_BRANCH_KPIS;

-- 202. Create a stored function that calculates a customer's total account balance.
delimiter //
	create procedure STORE_BALANCE(in p_customer_id int)
	begin
		declare total_balance double;
        
		select round(sum(current_balance),2) into total_balance
		from accounts
        where customer_id = p_customer_id;
        
        select total_balance as Total_Balance;
	end //
delimiter //

call STORE_BALANCE(20034);

drop procedure if exists STORE_BALANCE;

-- 203. Create a stored function that returns a customer risk category based on loan exposure.
delimiter //
	create procedure RISK_CATEGORY(in p_customer_id int)
    begin 
		select loan_id,customer_id,loan_type,risk_category
        from loans
        where customer_id = p_customer_id;
	end //
delimiter //

call RISK_CATEGORY(20074);

drop procedure if exists RISK_CATEGORY;

-- 204. Demonstrate START TRANSACTION, COMMIT and ROLLBACK.
select * from card_transactions;

start transaction;
update card_transactions set card_transaction_id = 6000001 where card_transaction_id = 6000000;

rollback;

-- 205.Identify suitable indexes for customer_id, account_id, transaction_datetime and loan_id.
create index index_customer_id
on customers(customer_id);
create index index_account_id
on accounts(account_id);
create index index_transaction_id
on transactions(transaction_id);
create index index_loan_id
on loans(loan_id);

show index from customers;
show index from accounts;
show index from transactions;
show index from loans;

-- 206. Use EXPLAIN on a transaction query.
explain 
select transaction_id,account_id,customer_id,transaction_type,transaction_direction,amount,
channel,transaction_status,reference_number,transaction_datetime
from transactions
where customer_id = 20001;


-- --------------------------------------------------------------------------------------------------------------------------------------
-- Q. Banking Business Analysis
-- 207. Calculate total deposits.
select round(sum(amount),2) as Total_Deposit 
from transactions 
where transaction_direction = 'Credit';

-- 208. Calculate total withdrawals.
select round(sum(amount),2) as Total_Withdrawal
from transactions 
where transaction_direction = 'Debit';

-- 209. Calculate net cash flow = credits - debits.
with credits as(
	select round(sum(amount),2) as Total_Deposit 
	from transactions 
	where transaction_direction = 'Credit'
),
debits as(
	select round(sum(amount),2) as Total_Withdrawal
	from transactions 
	where transaction_direction = 'Debit'
)
select c.Total_Deposit,d.Total_Withdrawal,(c.Total_Deposit - d.Total_Withdrawal) as Cashflow
from credits c
cross join debits d;

-- 210. Calculate total loan portfolio.
select round(sum(loan_amount),2) as Loan_Portfolio
from loans;

-- 211. Calculate total outstanding loan portfolio.
select round(sum(outstanding_amount),2) as Outstanding_Loan_Portfolio
from loans;

-- 212. Calculate loan approval rate.
with accepted_rate as(
	select count(distinct loan_id) as Approved_Loans
    from loans 
    where loan_status = 'Approved'
),
total_loans as(
	select count(distinct loan_id) as Total_Loans
    from loans 
)
select round((a.Approved_Loans/t.Total_Loans)*100,2) as Loan_Approval_Rate
from accepted_rate a
cross join total_loans t;

-- 213. Calculate loan rejection rate.
with rejected_rate as(
	select count(distinct loan_id) as Rejected_Loans
    from loans 
    where loan_status = 'Rejected'
),
total_loans as(
	select count(distinct loan_id) as Total_Loans
    from loans 
)
select round((r.Rejected_Loans/t.Total_Loans)*100,2) as Loan_Rejection_Rate
from rejected_rate r
cross join total_loans t

-- 214. Calculate average loan interest rate.
select round(avg(interest_rate),2) as Average_Interest_Rate 
from loans;

-- 215. Calculate total interest paid by customers.
select round(sum(interest_paid),2) as Interest_Paid_By_Customers
from loan_payments;

-- 216. Calculate total card spending.
select round(sum(amount),2) as Card_Spending
from transactions
where transaction_type = 'Card Payment';

-- 217. Calculate digital transaction percentage.
with digital_transactions as(
	select count(transaction_id) as Digital_Transactions
    from transactions 
    where channel in ('Internet Banking','Mobile App','UPI')
),
total_transactions as(
	select count(transaction_id) as Total_Transactions
    from transactions 
)
select round((d.Digital_Transactions/t.Total_Transactions)*100.0,2) as Digital_Transaction_Percentage
from digital_transactions d
cross join total_transactions t;

-- 218. Calculate ATM transaction percentage.
with atm_transactions as(
	select count(transaction_id) as ATM_Transactions
    from transactions 
    where channel = 'ATM'
),
total_transactions as(
	select count(transaction_id) as Total_Transactions
    from transactions 
)
select round((a.atm_Transactions/t.Total_Transactions)*100.0,2) as ATM_Transaction_Percentage
from atm_transactions a
cross join total_transactions t

-- 219. Calculate average account balance.
select round(avg(current_balance),2) as Average_Account_Balance
from accounts;

-- 220. Calculate customers per branch.
select c.home_branch_id as Branch_ID,b.branch_name as Branch_Name,count(distinct c.customer_id) as Customers
from customers c
left join branches b
on c.home_branch_id = b.branch_id
group by c.home_branch_id

-- 221. Calculate loans per branch.
select l.branch_id as Branch_ID,b.branch_name as Branch_Name,count(distinct loan_id) as Loans
from loans l
left join branches b
on l.branch_id = b.branch_id
group by l.branch_id;

-- 222. Calculate average loan amount per customer.
with total_loan as(
	select sum(loan_amount) as Total_Loan
    from loans 
    where loan_status = 'Approved'
),
total_loan_customer as(
	select count(distinct customer_id) as Total_Customers
    from loans
    where loan_status = 'Approved'
)
select tl.Total_Loan,tc.Total_Customers,round((tl.Total_Loan/tc.Total_Customers),2) as Average_Loan_Per_Person
from total_loan tl
cross join total_loan_customer tc

-- 223. Find high-income customers with low account balances.
select concat(c.first_name,' ',c.last_name) as Name,a.account_id as Account_ID,
c.annual_income as Income,a.current_balance as Current_Balance
from customers c 
inner join accounts a
on c.customer_id = a.customer_id
where c.annual_income > 300000 and a.current_balance < 10000;

-- 224. Find customers with high loan exposure.
select concat(c.first_name,' ',c.last_name) as Name,sum(l.loan_amount) as Loan_Exposure
from customers c
inner join loans l
on c.customer_id = l.customer_id
group by c.customer_id,first_name,c.last_name
having sum(l.loan_amount) > 2500000; 

-- --------------------------------------------------------------------------------------------------------------------------------------

