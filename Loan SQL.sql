use project;
SELECT * FROM project.bank;

# 1. Total Loan Amount Funded: Measures the total value of loans disbursed.
select 
	sum(loan_amount) as "Total loan amount funded"
from bank; 

# 2. Total Loans: Tracks the number of loans issued.
select 
    count(loan_status) as 'Total loans'
from bank;

# 3. Total Collection: Reflects repayment performance, including principal and interest.
select 
	round(sum(total_payment),2) "Total collection"
from bank;

# 4. Total Interest: Captures revenue from loan interest.
select 
	round(sum(total_received_interest),2) as "Total Interest"
from bank;

# 5. Branch-Wise Performance: Revenue breakdown by branch, including interest income, fees, and combined revenue.
select 
	branch_name,
	round(sum(total_received_interest),2) "Total Interest" ,
    round(sum(total_fees),2) "Total Fees",
    round(sum(total_revenue),2) "Total Revenue"
from bank
group by branch_name;

# 6. State-Wise Loan: Shows geographic distribution of loans.
select 
	state_name, 
	sum(loan_amount) "Total Loan Amount",
    concat(round((sum(loan_amount)*100/(select sum(loan_amount) from bank)),2),"%") "% of Total Loan"
from bank
group by state_name;

# 7. Religion-Wise Loan: Monitors loan distribution across religious demographics.
select 
	religion, 
	sum(loan_amount) "Total Loan Amount",
    concat(round((sum(loan_amount)*100/(select sum(loan_amount) from bank)),2),"%") "% of Total Loan"
from bank
group by religion;

# 8. Product Group-Wise Loan: Categorizes loans by product types (e.g., personal, auto).
select 
	product_category_custom as "Product Group",
	sum(loan_amount) as "Total Loan Amount",
    concat(round((sum(loan_amount)*100/(select sum(loan_amount) from bank)),2),"%") as "% of Total Loan"
from bank
group by product_category_custom;


# 9. Disbursement Trend: Tracks changes in loan disbursements over time.
select date(disbursement_date) as Disbursement_Date, 
       SUM(loan_amount) as Total_Loan_Disbursed
from bank
group by date(disbursement_date)
order by Disbursement_Date;

-- Monthly Trend
select date_format(disbursement_date, '%Y-%m') as Month, 
       sum(loan_amount) as Total_Loan_Disbursed
from bank 
group by Month
order by Month;

-- Yearly Trend
select year(disbursement_date) as Year, 
       sum(loan_amount) as Total_Loan_Disbursed
from bank 
group by Year
order by Year;

# 10. Grade-Wise Loan: Assesses portfolio risk by borrower credit grades.
select 
	grade, 
	sum(loan_amount) as "Total Loan Amount",
    concat(round((sum(loan_amount)*100/(select sum(loan_amount) from bank)),2),"%") as "% of Total Loan"
from bank
group by grade
order by grade;

# 11. Default Loan Count: Counts loans in default.
select count(*) "Default Loan Count"
from bank
where is_default_loan ="Yes";

# 12. Delinquent Client Count: Tracks borrowers with missed payments.
select count(*) "Delinquent Client Count"
from bank
where is_delinquent_loan ="Yes";

# 13. Delinquent Loan Rate: Percentage of loans overdue in the portfolio.
select 
	concat(round((select count(*) from bank where is_delinquent_loan="Yes")*100/count(*),2),"%") as "Delinquent Loan Rate"
from bank;

# 14. Default Loan Rate: Proportion of defaulted loans to the total portfolio.
select 
	concat(round((select count(*) from bank where is_default_loan ="Yes")*100/count(*),2),"%") as "Default Loan Rate"
from bank;

# 15. Loan Status-Wise Loan: Breaks down loans by status (active, delinquent, closed).
 select 
	loan_status,
    sum(loan_amount) as "Total Loan Amount",
    concat(round(sum(loan_amount)*100/(select sum(loan_amount) from bank),2),"%") as "% of Total Loan"
from bank
group by loan_status
order by loan_status;

# 16. Age Group-Wise Loan: Categorizes loans by borrowers’ age groups.
 select 
	age as "Age Group",
    sum(loan_amount) as "Total Loan Amount",
    concat(round(sum(loan_amount)*100/(select sum(loan_amount) from bank),2),"%") as "% of Total Loan"
from bank
group by age
order by age;

# 17. Loan Maturity: Tracks the timeline until full repayment 
select 
	year(adddate(str_to_date(loan_maturity,"%d-%m-%y"),interval term month)) as "Maturity Year",
	count(*) as "Accounts"  
from bank
group by `Maturity Year` 
order by `Maturity Year`;

# 18. No Verified Loans: Identifies loans without proper verification.
select 
	count(*) as "No Verified Loan"
from bank
where verification_status= "not verified";
