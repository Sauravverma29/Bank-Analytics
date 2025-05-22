use project;
select * from credit_debit;

# 1. Total Credit Amount:
select 
	round(sum(amount),2) as "Total Credit Amount" 
from credit_debit
where transaction_type ="credit";

# 2. Total Debit Amount:
select 
	round(sum(amount),2) as "Total Debit Amount" 
from credit_debit
where transaction_type ="debit";

# 3. Credit to Debit Ratio:       
select 
	round(
	sum(case when transaction_type="credit" then amount end) /
    sum(case when transaction_type="debit" then amount end),4) as "Credit to Debit Ratio"
from credit_debit;

# 4. Net Transaction Amount:
select 
	round(
	sum(case when transaction_type="credit" then amount end) -
    sum(case when transaction_type="debit" then amount end),4) as "Net Transaction Amount"
from credit_debit;

# 5. Account Activity Ratio: Number of transactions ÷ Account balance.
select 
	round(
	count(*)/sum(amount),5) as "Account Activity Ratio"
from credit_debit;

# 6. Transactions per Day/Week/Month:
select 
	transaction_date as "Transaction day",
    count(*) over(partition by transaction_date ) as "Per Day",
    count(*) over(partition by week(transaction_date)) as "Per Week",
    count(*) over(partition by month(transaction_date)) as "Per Month"
from credit_debit
order by  transaction_date;


# 7. Total Transaction Amount by Branch:
select 
	branch,
    round(sum(amount),2) as "Total Transaction"
from credit_debit
group by branch;

# 8. Transaction Volume by Bank:
select 
	bank_name,
    round(sum(amount),2) as "Total Transaction"
from credit_debit
group by bank_name;

# 9. Transaction Method Distribution:
select 
	transaction_method,
    count(*) as "Transaction Count",
    concat(round((count(*)*100)/(select count(*) from credit_debit),2),"%") as "% of Total Transaction"
from credit_debit
group by transaction_method;

# 10. Branch Transaction Growth:
select
	date(transaction_date) as "Transaction Day",
    branch,
    round(sum(amount),2) as "Total Transaction",
    concat(
		round(
			(sum(amount)-lag(sum(amount)) over(partition by branch order by transaction_date))*100/
			lag(sum(amount)) over(partition by branch order by transaction_date),
		2),"%"
	) as "Growth_Percentage"
from credit_debit
group by transaction_date,branch
order by branch,transaction_date;

with cte as(
	select
		date(transaction_date) as Transaction_Day,
        branch,
        round(sum(amount),2) as Total_Transaction
	from credit_debit
group by transaction_date,branch
)
select transaction_day,branch,total_transaction,
	concat(
		round(
			(total_transaction-lag(total_transaction) over(partition by branch order by transaction_day))*100/
			lag(total_transaction) over(partition by branch order by transaction_day),
		2),"%"
	) as Growth_percentage
from cte
order by branch,transaction_day;

# 11. High-Risk Transaction Flag:
select 
	customer_name,
    amount,
    case
		when amount>4500 then "High Risk" else "Low Risk" 
	end as Risk_Flag
from credit_debit
order by 1;

# 12. Suspicious Transaction Frequency:
select 
	month(transaction_date) as Month, 
    count(if(amount>4500,customer_name,null)) "High Risk" 
from credit_debit 
group by 1 order by 1;

