CREATE DATABASE fintech_banking_analytics;
USE fintech_banking_analytics;


SELECT COUNT(*) AS total_rows
FROM banking_data;
SELECT*FROM banking_data;
-- 1. Total customers
SELECT 
    COUNT(DISTINCT Customer_ID) AS total_customers
FROM banking_data;

-- 2 Total loans
SELECT 
    COUNT(DISTINCT Loan_ID) AS total_loans
FROM banking_data
WHERE Loan_ID IS NOT NULL;

-- 3. Total loan amount
SELECT 
    SUM(Loan_Amount) AS total_loan_amount
FROM banking_data
WHERE Loan_Amount IS NOT NULL;

-- 4. Total transaction value
SELECT 
    SUM(Transaction_Amount) AS total_transaction_value
FROM banking_data
WHERE Transaction_Amount IS NOT NULL;

-- 5. Total customer profit
SELECT 
    SUM(Customer_Profit) AS total_customer_profit
FROM banking_data;

-- 6. Total credit loss
SELECT 
    SUM(Credit_Loss) AS total_credit_loss
FROM banking_data;

-- 7. Average credit score
SELECT 
    ROUND(AVG(Credit_Score), 2) AS avg_credit_score
FROM banking_data;

-- 8. Average risk score
SELECT 
    ROUND(AVG(Risk_Score), 2) AS avg_risk_score
FROM banking_data;


-- 9. Customers by segment
SELECT
    Customer_Segment,
    COUNT(DISTINCT Customer_ID) AS customers
FROM banking_data
GROUP BY Customer_Segment
ORDER BY customers DESC;

-- 10. Profit by customer segment
SELECT
    Customer_Segment,
    ROUND(SUM(Customer_Profit), 2) AS total_profit,
    ROUND(AVG(Customer_Profit), 2) AS avg_profit
FROM banking_data
GROUP BY Customer_Segment
ORDER BY total_profit DESC;

-- 11. Loan amount by loan type
SELECT
    Loan_Type,
    COUNT(DISTINCT Loan_ID) AS loans,
    ROUND(SUM(Loan_Amount), 2) AS total_loan_amount,
    ROUND(AVG(Loan_Amount), 2) AS avg_loan_amount
FROM banking_data
WHERE Loan_ID IS NOT NULL
GROUP BY Loan_Type
ORDER BY total_loan_amount DESC;

-- 12. Default rate by customer segment

SELECT
    Customer_Segment,
    COUNT(*) AS payment_records,
    SUM(
        CASE 
            WHEN Default_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS defaults,

    ROUND(
        100.0 *
        SUM(
            CASE 
                WHEN Default_Flag = 1 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Default_Flag IS NOT NULL THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS default_rate_pct

FROM banking_data
WHERE Default_Flag IS NOT NULL
GROUP BY Customer_Segment
ORDER BY default_rate_pct DESC;


-- 13. Countries with more than 100 customers
SELECT
    Country,
    COUNT(DISTINCT Customer_ID) AS customers
FROM banking_data
GROUP BY Country
HAVING COUNT(DISTINCT Customer_ID) > 100
ORDER BY customers DESC;

-- 14. Loan types with more than 500 loans

SELECT
    Loan_Type,
    COUNT(DISTINCT Loan_ID) AS total_loans
FROM banking_data
WHERE Loan_ID IS NOT NULL
GROUP BY Loan_Type
HAVING COUNT(DISTINCT Loan_ID) > 500
ORDER BY total_loans DESC;

-- 15. Loans by year

SELECT
    YEAR(Loan_Start_Date) AS loan_year,
    COUNT(DISTINCT Loan_ID) AS total_loans,
    ROUND(SUM(Loan_Amount), 2) AS total_loan_amount
FROM banking_data
WHERE Loan_Start_Date IS NOT NULL
GROUP BY YEAR(Loan_Start_Date)
ORDER BY loan_year;

-- 16. Transactions by month
SELECT
   
    MONTH(Transaction_Date) AS transaction_month,
    COUNT(DISTINCT Transaction_ID) AS transactions,
    ROUND(SUM(Transaction_Amount), 2) AS transaction_value
FROM banking_data
WHERE Transaction_Date IS NOT NULL
GROUP BY
   
    MONTH(Transaction_Date)
ORDER BY
   
    transaction_month;

-- 17. Monthly profit
SELECT
    YEAR(Transaction_Date) AS year,
    MONTH(Transaction_Date) AS month,
    ROUND(SUM(Customer_Profit), 2) AS total_profit
FROM banking_data
WHERE Transaction_Date IS NOT NULL
GROUP BY
    YEAR(Transaction_Date),
    MONTH(Transaction_Date)
ORDER BY
    year,
    month;


-- 18. Customers above average profit
SELECT
    Customer_ID,
    Customer_Name,
    Customer_Profit
FROM banking_data
WHERE Customer_Profit >
(
    SELECT AVG(Customer_Profit)
    FROM banking_data
)
ORDER BY Customer_Profit DESC;

-- 19. Loans above average loan amount
SELECT DISTINCT
    Loan_ID,
    Loan_Type,
    Loan_Amount
FROM banking_data
WHERE Loan_Amount >
(
    SELECT AVG(Loan_Amount)
    FROM banking_data
    WHERE Loan_Amount IS NOT NULL
)
ORDER BY Loan_Amount DESC;

-- 20. Customers with above-average risk score
SELECT DISTINCT
    Customer_ID,
    Customer_Name,
    Risk_Score
FROM banking_data
WHERE Risk_Score >
(
    SELECT AVG(Risk_Score)
    FROM banking_data
)
ORDER BY Risk_Score DESC;



-- 21. Customer-level profitability
WITH customer_profit AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        MAX(Customer_Segment) AS Customer_Segment,
        SUM(Customer_Profit) AS total_profit
    FROM banking_data
    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    ROUND(total_profit, 2) AS total_profit
FROM customer_profit
ORDER BY total_profit DESC;


-- 22. Top 10 most profitable customers
WITH customer_profit AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        MAX(Customer_Segment) AS Customer_Segment,
        SUM(Customer_Profit) AS total_profit
    FROM banking_data
    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    ROUND(total_profit, 2) AS total_profit
FROM customer_profit
ORDER BY total_profit DESC
LIMIT 10;

-- 23. Rank customers by profitability
WITH customer_profit AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        SUM(Customer_Profit) AS total_profit
    FROM banking_data
    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(total_profit, 2) AS total_profit,

    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank

FROM customer_profit;

-- 24. Rank customers within each segment
WITH customer_profit AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        MAX(Customer_Segment) AS Customer_Segment,
        SUM(Customer_Profit) AS total_profit
    FROM banking_data
    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    ROUND(total_profit, 2) AS total_profit,

    RANK() OVER (
        PARTITION BY Customer_Segment
        ORDER BY total_profit DESC
    ) AS segment_rank

FROM customer_profit;


-- 25. Cumulative transaction value
WITH monthly_transactions AS
(
    SELECT
        YEAR(Transaction_Date) AS year,
        MONTH(Transaction_Date) AS month,
        SUM(Transaction_Amount) AS monthly_value
    FROM banking_data
    WHERE Transaction_Date IS NOT NULL
    GROUP BY
        YEAR(Transaction_Date),
        MONTH(Transaction_Date)
)

SELECT
    year,
    month,
    ROUND(monthly_value, 2) AS monthly_value,

    ROUND(
        SUM(monthly_value) OVER (
            ORDER BY year, month
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_transaction_value

FROM monthly_transactions
ORDER BY year, month;

-- 26. Monthly transaction growth
WITH monthly_transactions AS
(
    SELECT
        YEAR(Transaction_Date) AS year,
        MONTH(Transaction_Date) AS month,
        SUM(Transaction_Amount) AS monthly_value
    FROM banking_data
    WHERE Transaction_Date IS NOT NULL
    GROUP BY
        YEAR(Transaction_Date),
        MONTH(Transaction_Date)
),

previous_month AS
(
    SELECT
        year,
        month,
        monthly_value,

        LAG(monthly_value) OVER (
            ORDER BY year, month
        ) AS previous_month_value

    FROM monthly_transactions
)

SELECT
    year,
    month,
    ROUND(monthly_value, 2) AS monthly_value,
    ROUND(previous_month_value, 2) AS previous_month_value,

    ROUND(
        100.0 *
        (monthly_value - previous_month_value)
        /
        NULLIF(previous_month_value, 0),
        2
    ) AS mom_growth_pct

FROM previous_month
ORDER BY year, month;


-- 27. Each customer's percentage of total profit
WITH customer_profit AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        SUM(Customer_Profit) AS total_profit
    FROM banking_data
    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        100.0 *
        total_profit
        /
        NULLIF(
            SUM(total_profit) OVER (),
            0
        ),
        2
    ) AS profit_contribution_pct

FROM customer_profit

ORDER BY total_profit DESC;


-- 28. Top 10 customers' contribution to profit
WITH customer_profit AS
(
    SELECT
        Customer_ID,
        SUM(Customer_Profit) AS total_profit
    FROM banking_data
    GROUP BY Customer_ID
),

ranked_customers AS
(
    SELECT
        Customer_ID,
        total_profit,

        ROW_NUMBER() OVER (
            ORDER BY total_profit DESC
        ) AS customer_rank

    FROM customer_profit
)

SELECT
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN customer_rank <= 10
                THEN total_profit
                ELSE 0
            END
        )
        /
        NULLIF(SUM(total_profit), 0),
        2
    ) AS top_10_profit_contribution_pct

FROM ranked_customers;


-- 29. Default rate by credit score band
SELECT
    Credit_Score_Band,

    COUNT(*) AS records,

    SUM(
        CASE
            WHEN Default_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS defaults,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Default_Flag = 1 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN Default_Flag IS NOT NULL THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS default_rate_pct

FROM banking_data
WHERE Default_Flag IS NOT NULL
GROUP BY Credit_Score_Band
ORDER BY default_rate_pct DESC;

-- 30. Default rate by DTI band
SELECT
    DTI_Band,

    COUNT(*) AS records,

    SUM(
        CASE
            WHEN Default_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS defaults,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Default_Flag = 1 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(
            COUNT(*),
            0
        ),
        2
    ) AS default_rate_pct

FROM banking_data

WHERE DTI_Band IS NOT NULL

GROUP BY DTI_Band

ORDER BY default_rate_pct DESC;

-- 31 defaulted rate by utiliztion bond 
SELECT
    Utilization_Band,
    COUNT(*) AS records,
    SUM(
        CASE
            WHEN Default_Flag = 1 THEN 1
            ELSE 0
        END
    ) AS defaults,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN Default_Flag = 1 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(COUNT(*), 0),
        2
    ) AS default_rate_pct

FROM banking_data
WHERE Utilization_Band IS NOT NULL
GROUP BY Utilization_Band
ORDER BY default_rate_pct DESC;

-- 32. Customers with early-warning signals
SELECT
    Customer_ID,
    MAX(Customer_Name) AS Customer_Name,

    MAX(Risk_Score) AS Risk_Score,
    MAX(Credit_Score) AS Credit_Score,

    MAX(Debt_to_Income_Ratio) AS DTI,
    MAX(Utilization_Rate) AS Utilization_Rate,

    MAX(Days_Past_Due) AS Max_DPD,

    MAX(Early_Warning_Flag) AS Early_Warning_Flag,
    MAX(Default_Flag) AS Default_Flag

FROM banking_data
GROUP BY Customer_ID
HAVING
    MAX(Early_Warning_Flag) = 1
ORDER BY
    Risk_Score DESC,
    Max_DPD DESC;


-- 33. Create a risk-priority list
WITH customer_risk AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        MAX(Customer_Segment) AS Customer_Segment,

        MAX(Credit_Score) AS Credit_Score,
        MAX(Risk_Score) AS Risk_Score,
        MAX(Debt_to_Income_Ratio) AS DTI,
        MAX(Utilization_Rate) AS Utilization_Rate,
        MAX(Days_Past_Due) AS Max_DPD,

        MAX(Default_Flag) AS Default_Flag,
        MAX(Early_Warning_Flag) AS Early_Warning_Flag

    FROM banking_data
    GROUP BY Customer_ID
)

SELECT
    *,

    CASE
        WHEN Default_Flag = 1 THEN 'Default'
        WHEN Early_Warning_Flag = 1
             AND Max_DPD > 30
             THEN 'Critical Early Warning'
        WHEN Early_Warning_Flag = 1
             THEN 'Early Warning'
        WHEN Risk_Score >= 80
             THEN 'High Risk'
        ELSE 'Normal'
    END AS Risk_Priority
FROM customer_risk
ORDER BY
    CASE
        WHEN Default_Flag = 1 THEN 1
        WHEN Early_Warning_Flag = 1
             AND Max_DPD > 30 THEN 2
        WHEN Early_Warning_Flag = 1 THEN 3
        WHEN Risk_Score >= 80 THEN 4
        ELSE 5
    END,
    Risk_Score DESC;
    
    -- creating analytical views/tables later. For example, first create a customer summary:

CREATE OR REPLACE VIEW customer_summary AS
SELECT
    Customer_ID,
    MAX(Customer_Name) AS Customer_Name,
    MAX(Gender) AS Gender,
    MAX(Age) AS Age,
    MAX(Age_Group) AS Age_Group,
    MAX(Country) AS Country,
    MAX(Customer_Segment) AS Customer_Segment,
    MAX(Employment_Status) AS Employment_Status,
    MAX(Credit_Score) AS Credit_Score,
    MAX(Risk_Score) AS Risk_Score,
    MAX(Annual_Income) AS Annual_Income,
    SUM(Customer_Profit) AS Total_Profit,
    SUM(Credit_Loss) AS Total_Credit_Loss
FROM banking_data
GROUP BY Customer_ID;
SELECT *
FROM banking_data;


-- JOIN CUSTOMER SUMMARY WITH LOAN SUMMARY
CREATE OR REPLACE VIEW loan_summary AS

SELECT
    Customer_ID,

    COUNT(DISTINCT Loan_ID) AS Total_Loans,

    SUM(Loan_Amount) AS Total_Loan_Amount,
    AVG(Interest_Rate) AS Avg_Interest_Rate,
    AVG(Loan_Term_Months) AS Avg_Loan_Term
FROM banking_data
WHERE Loan_ID IS NOT NULL
GROUP BY Customer_ID;
SELECT
    c.Customer_ID,
    c.Customer_Name,
    c.Customer_Segment,
    c.Credit_Score,
    c.Risk_Score,
    c.Total_Profit,
    l.Total_Loans,
    l.Total_Loan_Amount,
    l.Avg_Interest_Rate,
    l.Avg_Loan_Term
FROM customer_summary c

LEFT JOIN loan_summary l
    ON c.Customer_ID = l.Customer_ID

ORDER BY c.Total_Profit DESC;

-- 34. Highest-profit customer in every segment
WITH customer_profit AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        MAX(Customer_Segment) AS Customer_Segment,
        SUM(Customer_Profit) AS total_profit

    FROM banking_data

    GROUP BY Customer_ID
),

ranked AS
(
    SELECT
        *,

        ROW_NUMBER() OVER (
            PARTITION BY Customer_Segment
            ORDER BY total_profit DESC
        ) AS rn

    FROM customer_profit
)

SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    ROUND(total_profit, 2) AS total_profit

FROM ranked

WHERE rn = 1;

-- 35. Profitable but high-risk customers
WITH customer_metrics AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        MAX(Customer_Segment) AS Customer_Segment,

        SUM(Customer_Profit) AS Total_Profit,

        MAX(Risk_Score) AS Risk_Score,

        MAX(Default_Flag) AS Default_Flag,

        MAX(Early_Warning_Flag) AS Early_Warning_Flag,

        MAX(Days_Past_Due) AS Max_DPD

    FROM banking_data

    GROUP BY Customer_ID
)

SELECT
    *

FROM customer_metrics

WHERE Total_Profit > 0

AND (
    Risk_Score >= 70
    OR Early_Warning_Flag = 1
    OR Max_DPD > 30
)

ORDER BY
    Risk_Score DESC,
    Total_Profit DESC;
    
    
-- 36. Create customer risk-profit segments
WITH customer_metrics AS
(
    SELECT
        Customer_ID,
        MAX(Customer_Name) AS Customer_Name,
        MAX(Customer_Segment) AS Customer_Segment,

        SUM(Customer_Profit) AS Total_Profit,

        MAX(Risk_Score) AS Risk_Score,

        MAX(Default_Flag) AS Default_Flag,

        MAX(Early_Warning_Flag) AS Early_Warning_Flag,

        MAX(Days_Past_Due) AS Max_DPD

    FROM banking_data

    GROUP BY Customer_ID
)

SELECT
    Customer_ID,
    Customer_Name,
    Customer_Segment,
    ROUND(Total_Profit, 2) AS Total_Profit,
    Risk_Score,
    Max_DPD,

    CASE

        WHEN Default_Flag = 1
            THEN 'Defaulted'

        WHEN Early_Warning_Flag = 1
             AND Total_Profit > 0
            THEN 'Profitable - Early Warning'

        WHEN Risk_Score >= 70
             AND Total_Profit > 0
            THEN 'Profitable - High Risk'

        WHEN Risk_Score < 70
             AND Total_Profit > 0
            THEN 'Profitable - Lower Risk'

        WHEN Total_Profit <= 0
            THEN 'Low / Negative Profit'

        ELSE 'Other'

    END AS Customer_Risk_Profit_Segment

FROM customer_metrics;

