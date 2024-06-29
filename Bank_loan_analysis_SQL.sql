---Bank Loan Data Analysis----
--- Financial Data Analysis Integrated with SQL & Power BI ---

-------------------------------------------------------------------------------------------------

create database Bank_loan_data_analysis
USE Bank_loan_data_analysis

-------------------------------------------------------------------------------------------------

--Importing the data from Flat file(Table Name: bank_loan_customer_data)

Select * from bank_loan_customer_data

-- Data Imported succefully to our SQL Environment and now lets starts the firing our sql
-- queries based on business analysis and some of problem statements

-------------------------------------------------------------------------------------------------

-- Data Analysis:

-- Total Loan Applications: We need to calculate the total number of loan applications received during a 
--specified period. Additionally, it is essential to monitor the Month-to-Date (MTD) Loan Applications and track 
-- changes Month-over-Month (MoM).

Select count(id) as 'Total Loan Application' 
from bank_loan_customer_data

-- Total Funded Amount: Understanding the total amount of funds disbursed as loans is crucial. 
-- We also want to keep an eye on the MTD Total Funded Amount and analyse the Month-over-Month (MoM) 
-- changes in this metric.all the calculations are based on isuue date or disbursed daste

select count(id) as 'MTD Loan application' from bank_loan_customer_data
where month(issue_date)=12 and year (issue_date)= 2021

select count(id) as 'Prev MTD Loan application' from bank_loan_customer_data
where month(issue_date)=11 and year (issue_date)= 2021

-- As we alraedy we get to know the Current TD And Prev MTD So now lets understand the 
-- Month on Month Application Growth = which is  [MTD- Prev MTD/(Prev MTD)] by using CTE

with current_month_cte as 
(select count(id) as mtd_loan_application 
from bank_loan_customer_data 
where month(issue_date) = 12 and year(issue_date) = 2021),


previous_month_cte as 
(select count(id) as prev_mtd_loan_application 
from bank_loan_customer_data 
where month(issue_date) = 11 and year(issue_date) = 2021)


select current_month_cte.mtd_loan_application,
    previous_month_cte.prev_mtd_loan_application,
    case 
     when previous_month_cte.prev_mtd_loan_application = 0 then null
     else (current_month_cte.mtd_loan_application - previous_month_cte.prev_mtd_loan_application) / 
		                               cast(previous_month_cte.prev_mtd_loan_application as decimal)
									   end as MOM_Growth
from current_month_cte, previous_month_cte


-- Total Funded Amount: Lets understanding the total amount of funds disbursed by the bank.
-- We also want to keep an eye on the MTD Total Funded Amount and analyse the Month-over-Month 
-- (MoM) changes in this metric

select * from bank_loan_customer_data

select sum(loan_amount) as 'Total Funded Amount' from bank_loan_customer_data

-- Lets cheack the MTD Total Fund 

select sum(loan_amount) as 'MTD-Total Funded Amount' from bank_loan_customer_data
where month(issue_date)=12 and year(issue_date)=2021

-- Lets cheack the Prev-MTD Total Fund 

select sum(loan_amount) as 'Prev MTD-Total Funded Amount' from bank_loan_customer_data
where month(issue_date)=11 and year(issue_date)=2021

-- Lets Cheack the total fund amount between current MTD and Previous MTD and the difference,it will helps
-- to get the insights of perticular periods insights

select 
    sum(loan_amount) as 'total funded amount',
    sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) as 'mtd-total funded amount',
    sum(case when month(issue_date) = 11 and year(issue_date) = 2021 then loan_amount else 0 end) as 'prev mtd-total funded amount',
    sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then loan_amount else 0 end) -
    sum(case when month(issue_date) = 11 and year(issue_date) = 2021 then loan_amount else 0 end) as 'difference'
from bank_loan_customer_data
where 
    (month(issue_date) = 12 and year(issue_date) = 2021)
    or
    (month(issue_date) = 11 and year(issue_date) = 2021)



-- Total Amount Received: Tracking the total amount received from borrowers is essential for assessing the bank's
-- cash flow and loan repayment. We should analyse the Month-to-Date (MTD) Total Amount Received and observe the 
-- Month-over-Month (MoM) changes

select * from bank_loan_customer_data

-- Overall Payment received to bank by different types of EMI Tenure whether it may be Yearly or monthly or quarterly

select sum(total_payment) 'Total Amount Received' from bank_loan_customer_data

-- Lets cheack current month payment recived

select sum(total_payment) 'Total MTD Amount Received' from bank_loan_customer_data
where month(issue_date)=12 and year(issue_date)=2021

-- Previous MTD Amount Recived 

select sum(total_payment) 'Total Prev MTD Amount Received' from bank_loan_customer_data
where month(issue_date)=11 and year(issue_date)=2021

-- Lets Cheack the Difference of amount received by Bank with MTD ,Prev MTD and overall so that we can get a clear 
-- insights of current Amount recived based on criteria

select 
    sum(total_payment) as 'total amount received',
    sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end) as 'total mtd amount received',
    sum(case when month(issue_date) = 11 and year(issue_date) = 2021 then total_payment else 0 end) as 'total prev mtd amount received',
    (sum(case when month(issue_date) = 12 and year(issue_date) = 2021 then total_payment else 0 end)
	-
    sum(case when month(issue_date) = 11 and year(issue_date) = 2021 then total_payment else 0 end)) as 'difference amount'
from bank_loan_customer_data
where 
    (month(issue_date) = 12 and year(issue_date) = 2021)
    or
    (month(issue_date) = 11 and year(issue_date) = 2021)


-- Average Interest Rate: Calculating the average interest rate across all loans, MTD, and monitoring the Month-over-Month (MoM)
--variations in interest rates will provide insights into our lending portfolio's overall cost.

select round(avg(int_rate),5)*100 'Avg Interst Rate' from bank_loan_customer_data

-- Avg Interst Rate for MTD 

select round(avg(int_rate),5)*100 'MTD Avg-Interst Rate' from bank_loan_customer_data
where month(issue_date)=12 and year(issue_date)=2021

-- Avg Interst Rate for Prev-MTD 

select round(avg(int_rate),5)*100 'MTD Avg-Interst Rate' from bank_loan_customer_data
where month(issue_date)=11 and year(issue_date)=2021

-- Lets cheack the average Interst rate by Funded amount

select 
    (select sum(loan_amount) 
	from bank_loan_customer_data) as "Total funded amount",
    (select round(avg(int_rate), 5)*100 
	from bank_loan_customer_data) as "Avg interest rate",
    (select sum(loan_amount) 
	from bank_loan_customer_data 
	where month(issue_date) = 12 and 
	      year(issue_date) = 2021) as "MTD-total funded amount",
    (select round(avg(int_rate), 5)*100 
	from bank_loan_customer_data 
	where month(issue_date) = 12 and 
	      year(issue_date) = 2021) as "MTD avg interest rate",
    (select sum(loan_amount) 
	from bank_loan_customer_data 
	where month(issue_date) = 11 and 
	year(issue_date) = 2021) as "Prev-MTD total funded amount",
    (select round(avg(int_rate), 5)*100 
	from bank_loan_customer_data 
	where month(issue_date) = 11 and 
	      year(issue_date) = 2021) as "Prev MTD Avg interest rate"


-- Average Debt-to-Income Ratio (DTI): Evaluating the average DTI for our borrowers helps us gauge their financial health. 
-- We need to compute the average DTI for all loans, MTD, and track Month-over-Month (MoM) fluctuations. From this DTI Analysis
-- Financial Institute can decide Wheather they will give loan to perticular customer or not(cheack the financial health)
-- DTI Level varies from bank to bank, normally the DTI should not be higher or lower as dti indicates your income vs debt.

-- Current MTD DTI

select round(avg(dti),4)*100 'Avrg MTD DTI' from bank_loan_customer_data
where month(issue_date) = 12 and year(issue_date) = 2021


-- Current Previous MTD DTI
select round(avg(dti),4)*100 'Avrg Previous MTD DTI' from bank_loan_customer_data
where month(issue_date) = 11 and year(issue_date) = 2021

------------------------------------------------------------------------------------------------------------------------------
-- Data Analysis-In depth

-- Lets understand the banks profit from the disbursed amount

-- Based on Loan Status lets understand based on Good loan and Bad Loan
-- For the we need to figure out Bad Loan and Good Loan 
------------------------------------------------------------------------------------------------------------------------------
--Good Loan

-- Good Loan Application Percentage

select 
    (count
	   (case when loan_status='Fully Paid' or loan_status='Current' Then id end)*100.0)/
	count(id) as 'Good Loan Percentage'
from bank_loan_customer_data

-- Good Loan Application

select count(id) AS 'Good Loan Application' from bank_loan_customer_data
where  loan_status='Fully Paid' or loan_status='Current'

-- Good Loan Funded Amount

select sum(loan_amount) AS 'Good Loan Funded amount' from bank_loan_customer_data
where  loan_status='Fully Paid' or loan_status='Current'

-- Good Loan Total Received Amount

select sum(total_payment) AS 'Good Loan amount Recieved' from bank_loan_customer_data
where  loan_status='Fully Paid' or loan_status='Current'

-- Understand the Good Loan in terms of Profitable by considering above calculation by using CTE

with Good_loan_Appl_percentage as 
(select 
    (count
      (case when loan_status='fully paid' or loan_status='current' then id end)*100)/
     count(id) as 'Good_loan_Appl_percentage'
    from bank_loan_customer_data),

Good_Loan_application as 
(select count(id) as 'Good_Loan_application'
 from bank_loan_customer_data
 where  loan_status='fully paid' or loan_status='current'),

good_loan_funded_Amount as 
(select sum(loan_amount) as 'good_loan_funded_Amount' 
 from bank_loan_customer_data
 where  loan_status='fully paid' or loan_status='current'),

good_loan_amount_received as 
(select sum(total_payment) as 'good_loan_amount_received' 
 from bank_loan_customer_data
 where  loan_status='fully paid' or loan_status='current'),

Profit_loss AS 
(select good_loan_amount_received - good_loan_funded_amount AS Profit_loss
from good_loan_amount_received, good_loan_funded_amount)

select * from 
    Good_loan_Appl_percentage,
    Good_Loan_application,
    good_loan_funded_amount,
    good_loan_amount_received,
    Profit_loss
------------------------------------------------------------------------------------------------------------------------------
-- Bad Loan

-- Bad Loan Application Percentage

select 
    (count
	   (case when loan_status='Charged Off' Then id end)*100.0)/
	count(id) as 'Bad Loan Percentage'
from bank_loan_customer_data

-- Bad Loan Application

select count(id) AS 'Bad Loan Application' from bank_loan_customer_data
where  loan_status='Charged Off' 

-- Bad Loan Funded Amount

select sum(loan_amount) AS 'Bad Loan Funded amount' from bank_loan_customer_data
where  loan_status= 'Charged Off' 

-- Bad Loan Total Received Amount

select sum(total_payment) AS 'Bad Loan amount Recieved' from bank_loan_customer_data
where  loan_status='Charged Off'

-- Understand the Bad Loan loss amount by above calculation


with Bad_loan_Appl_percentage as 
(select 
    (count
      (case when loan_status='Charged Off' then id end)*100.0)/
     count(id) as 'Bad_loan_Appl_percentage'
    from bank_loan_customer_data),

Bad_Loan_application as 
(select count(id) as 'Bad_Loan_application'
 from bank_loan_customer_data
 where  loan_status='Charged Off'),

Bad_loan_funded_Amount as 
(select sum(loan_amount) as 'Bad_loan_funded_Amount' 
 from bank_loan_customer_data
 where  loan_status='Charged Off'),

Bad_loan_amount_received as 
(select sum(total_payment) as 'Bad_loan_amount_received' 
 from bank_loan_customer_data
 where  loan_status='Charged Off'),

loss_amount AS 
(select Bad_loan_amount_received - Bad_loan_funded_amount AS loss_amount
from Bad_loan_amount_received, Bad_loan_funded_amount)

select * from 
    Bad_loan_Appl_percentage,
    Bad_Loan_application,
    Bad_loan_funded_amount,
    Bad_loan_amount_received,
    loss_amount
------------------------------------------------------------------------------------------------------------------------
-- Lets analyse based on overall perfermance,MTD Performance and Prev MTD Performance of Bank instead of indivisual 
-- analysis of Good or Bad Loan to understand the 


-- Overall Performance
select loan_status,
       count(id) as Total_Loan_Application,
	   sum(Total_Payment) as Total_Amount_Received,
	   sum(loan_amount) as Total_Funded_Amount,
	   avg(int_rate*100) as Interest_Rate,
	   avg(dti*100) as DTI
	From bank_loan_customer_data
	group by loan_status

-- MTD Performance
select loan_status,
	   sum(loan_amount) as MTD_Total_Funded_Amount,
	   sum(Total_Payment) as MTD_Total_Amount_Received
	From bank_loan_customer_data
	where month(issue_date)=12
	group by loan_status

-- Previous MTD Performance
select loan_status,
	   sum(loan_amount) as Prev_MTD_Total_Funded_Amount,
	   sum(Total_Payment) as Prev_MTD_Total_Amount_Received
	From bank_loan_customer_data
	where month(issue_date)=11
	group by loan_status


---------------------------------------------------------------------------------------------------------------------
-- Lets Understand the Trend Overview analysis, To identify seasonality and long-term trends in lending activities

select * from bank_loan_customer_data

select MONTH(issue_date) as No_Of_Month,
       datename (month,issue_date) as 'Month-Name',
       count(id) Total_Loan_Application,
	   sum(Loan_Amount) Total_Funded_Amount,
	   sum(Total_Payment) Total_Received_Amount 
	from bank_loan_customer_data
	group by MONTH(issue_date),datename (month,issue_date)
	 order by MIN(MONTH(issue_date))


-- Regional Analysis By State
-- To identify regions with significant lending activity and assess regional disparities

select address_state,
       count(id) Total_Loan_Application,
	   sum(Loan_Amount) Total_Funded_Amount,
	   sum(Total_Payment) Total_Received_Amount 
	from bank_loan_customer_data
	group by address_state
	 order by sum(Loan_Amount) desc


-- Loan Term analysis: To allow the client to understand the distribution of loans across various term.

select term,
       count(id) Total_Loan_Application,
	   sum(Loan_Amount) Total_Funded_Amount,
	   sum(Total_Payment) Total_Received_Amount 
	from bank_loan_customer_data
	group by term
	 order by term desc

-- Customer work experience Analysis: How lending metrics are distributed among borrowers with different

select emp_length,
       count(id) Total_Loan_Application,
	   sum(Loan_Amount) Total_Funded_Amount,
	   sum(Total_Payment) Total_Received_Amount 
	from bank_loan_customer_data
	group by emp_length
	 order by count(id)  desc

-- Loan Purpose Breakdown: understand what purpose they are taken loan

select purpose,
       count(id) Total_Loan_Application,
	   sum(Loan_Amount) Total_Funded_Amount,
	   sum(Total_Payment) Total_Received_Amount 
	from bank_loan_customer_data
	group by purpose
	 order by count(id)  desc

-- Home Ownership Analysis :

select home_ownership,
       count(id) Total_Loan_Application,
	   sum(Loan_Amount) Total_Funded_Amount,
	   sum(Total_Payment) Total_Received_Amount 
	from bank_loan_customer_data
	group by home_ownership
	 order by count(id)  desc




