SELECT *
FROM PortfolioProject..marketing;


--Remove null values
-- Finding null values in different columns

SELECT *
FROM PortfolioProject..marketing
WHERE Income IS NULL; 

--Income was the only column with a null value

-- Update null values in the Income column
UPDATE PortfolioProject..marketing
SET Income = '0'
WHERE Income IS NULL;

-- We are now finding outliers for each column, checking how they affect the averages and depending on the number of outliers present we either delete or treat them

-- We are using IQR to find out outliers for MntFruits
WITH IQRStats AS (
    SELECT
        MntFruits,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntFruits) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntFruits) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    MntFruits
FROM
    IQRStats
WHERE
    MntFruits < Q1 - 1.5 * (Q3 - Q1) OR MntFruits > Q3 + 1.5 * (Q3 - Q1);
-- Now we compare the averages with and  without outliers to see how they affect the means

WITH IQRStats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntFruits) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntFruits) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    COUNT(*) AS TotalCount,
    AVG(MntFruits) AS MeanWithOutliers,
    AVG(CASE WHEN MntFruits BETWEEN Q1 - 1.5 * (Q3 - Q1) AND Q3 + 1.5 * (Q3 - Q1) THEN MntFruits END) AS MeanWithoutOutliers
FROM
    PortfolioProject..marketing
CROSS JOIN
    IQRStats;
--Since the number of outliers for MntFruits is more than 5% of the dataset, we choose to not consider them as outliers
-- The same process is repeated for every required column
-- Finding and treating outliers for MntWines
-- We are using IQR to find out outliers for MntWines
WITH IQRStats AS (
    SELECT
        MntWines,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntWines) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntWines) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    MntWines
FROM
    IQRStats
WHERE
    MntWines < Q1 - 1.5 * (Q3 - Q1) OR MntWines > Q3 + 1.5 * (Q3 - Q1);
-- Now we compare the averages with and  without outliers to see how they affect the means

WITH IQRStats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntWines) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntWines) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    COUNT(*) AS TotalCount,
    AVG(MntWines) AS MeanWithOutliers,
    AVG(CASE WHEN MntWines BETWEEN Q1 - 1.5 * (Q3 - Q1) AND Q3 + 1.5 * (Q3 - Q1) THEN MntWines END) AS MeanWithoutOutliers
FROM
    PortfolioProject..marketing
CROSS JOIN
    IQRStats;

--There are about 30 outliers, which we will now treat by replacing them with the mean
WITH IQRStats AS (
    SELECT
        MntWines,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntWines) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntWines) OVER () AS Q3
    FROM PortfolioProject..marketing
)

UPDATE m
SET m.MntWines = 
    CASE
        WHEN m.MntWines < Q1 - 1.5 * (Q3 - Q1) THEN 303
        WHEN m.MntWines > Q3 + 1.5 * (Q3 - Q1) THEN 303
        ELSE m.MntWines
    END
FROM PortfolioProject..marketing m
JOIN IQRStats i ON m.MntWines = i.MntWines;
-- The 35 outliers have now been treated.

-- We now check the outliers for MntFishProducts
WITH IQRStats AS (
    SELECT
        MntFishProducts,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntFishProducts) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntFishProducts) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    MntFishProducts
FROM
    IQRStats
WHERE
    MntFishProducts < Q1 - 1.5 * (Q3 - Q1) OR MntFishProducts > Q3 + 1.5 * (Q3 - Q1);

-- We have about 223 outliers which is about 5% of the dataset. since it is a significant amount, we decide to keep them and not treat them as outliers
-- We now check for the column MntMeatProducts
WITH IQRStats AS (
    SELECT
        MntMeatProducts,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntMeatProducts) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntMeatProducts) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    MntMeatProducts
FROM
    IQRStats
WHERE
    MntMeatProducts < Q1 - 1.5 * (Q3 - Q1) OR MntMeatProducts > Q3 + 1.5 * (Q3 - Q1);

-- There are about 175 outliers which is less then 5% of the dataset

-- Now we compare their averges with and without outliers

WITH IQRStats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntMeatProducts) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntMeatProducts) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    COUNT(*) AS TotalCount,
    AVG(MntMeatProducts) AS MeanWithOutliers,
    AVG(CASE WHEN MntMeatProducts BETWEEN Q1 - 1.5 * (Q3 - Q1) AND Q3 + 1.5 * (Q3 - Q1) THEN MntMeatProducts END) AS MeanWithoutOutliers
FROM
    PortfolioProject..marketing
CROSS JOIN
    IQRStats;

-- We now treat the outliers by replacing them with the mean
WITH IQRStats AS (
    SELECT
        MntMeatProducts,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntMeatProducts) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntMeatProducts) OVER () AS Q3
    FROM PortfolioProject..marketing
)

UPDATE m
SET m.MntMeatProducts = 
    CASE
        WHEN m.MntMeatProducts< Q1 - 1.5 * (Q3 - Q1) THEN 166
        WHEN m.MntMeatProducts > Q3 + 1.5 * (Q3 - Q1) THEN 166
        ELSE m.MntMeatProducts
    END
FROM PortfolioProject..marketing m
JOIN IQRStats i ON m.MntMeatProducts = i.MntMeatProducts;

-- Finding outliers for MntSweetProducts
WITH IQRStats AS (
    SELECT
        MntSweetProducts,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntSweetProducts) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntSweetProducts) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    MntSweetProducts
FROM
    IQRStats
WHERE
    MntSweetProducts < Q1 - 1.5 * (Q3 - Q1) OR MntSweetProducts > Q3 + 1.5 * (Q3 - Q1);

-- The number of outliers is 5% of the dataset, so we leave it as it is

-- Finding outliers for MntGoldProducts
WITH IQRStats AS (
    SELECT
        MntGoldProds,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntGoldProds) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntGoldProds) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    MntGoldProds
FROM
    IQRStats
WHERE
    MntGoldProds < Q1 - 1.5 * (Q3 - Q1) OR MntGoldProds > Q3 + 1.5 * (Q3 - Q1);

--Lets just compare the averages
WITH IQRStats AS (
    SELECT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntGoldProds) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntGoldProds) OVER () AS Q3
    FROM
        PortfolioProject..marketing
)

SELECT
    COUNT(*) AS TotalCount,
    AVG(MntGoldProds) AS MeanWithOutliers,
    AVG(CASE WHEN MntGoldProds BETWEEN Q1 - 1.5 * (Q3 - Q1) AND Q3 + 1.5 * (Q3 - Q1) THEN MntGoldProds END) AS MeanWithoutOutliers
FROM
    PortfolioProject..marketing
CROSS JOIN
    IQRStats;
-- The difference in their averages is a lot, so we've decided to treat these outliers
WITH IQRStats AS (
    SELECT
        MntGoldProds,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY MntGoldProds) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY MntGoldProds) OVER () AS Q3
    FROM PortfolioProject..marketing
)

UPDATE m
SET m.MntGoldProds = 
    CASE
        WHEN m.MntGoldProds< Q1 - 1.5 * (Q3 - Q1) THEN 44
        WHEN m.MntGoldProds > Q3 + 1.5 * (Q3 - Q1) THEN 44
        ELSE m.MntGoldProds
    END
FROM PortfolioProject..marketing m
JOIN IQRStats i ON m.MntGoldProds = i.MntGoldProds;


--Campaign effectiveness analysis

--Total number of customers who accepted each campaign

SELECT 'AcceptedCmp1' AS Campaign, SUM(AcceptedCmp1) AS Total
FROM PortfolioProject..marketing
UNION
SELECT 'AcceptedCmp2' AS Campaign, SUM(AcceptedCmp2) AS Total
FROM PortfolioProject..marketing
UNION
SELECT 'AcceptedCmp3' AS Campaign, SUM(AcceptedCmp3) AS Total
FROM PortfolioProject..marketing
UNION
SELECT 'AcceptedCmp4' AS Campaign, SUM(AcceptedCmp4) AS Total
FROM PortfolioProject..marketing
UNION
SELECT 'AcceptedCmp5' AS Campaign, SUM(AcceptedCmp5) AS Total
FROM PortfolioProject..marketing
UNION
SELECT 'Response' AS Campaign, SUM(Response) AS Total
FROM PortfolioProject..marketing;

--Acceptance rate for each campaign

SELECT
    'Campaign 1' AS Campaign,
    AVG(AcceptedCmp1) * 100 AS AcceptanceRate
FROM PortfolioProject..marketing
UNION
SELECT
    'Campaign 2' AS Campaign,
    AVG(AcceptedCmp2) * 100 AS AcceptanceRate
FROM PortfolioProject..marketing
UNION
SELECT
    'Campaign 3' AS Campaign,
    AVG(AcceptedCmp3) * 100 AS AcceptanceRate
FROM PortfolioProject..marketing
UNION
SELECT
    'Campaign 4' AS Campaign,
    AVG(AcceptedCmp4) * 100 AS AcceptanceRate
FROM PortfolioProject..marketing
UNION
SELECT
    'Campaign 5' AS Campaign,
    AVG(AcceptedCmp5) * 100 AS AcceptanceRate
FROM PortfolioProject..marketing
UNION
SELECT
    'Last Campaign' AS Campaign,
    AVG(Response) * 100 AS AcceptanceRate
FROM PortfolioProject..marketing;


--Correlation between campaign acceptance and recency
SELECT
    AVG(AcceptedCmp1 * Recency) / (STDEV(AcceptedCmp1) * STDEV(Recency)) AS Correlation_AcceptedCmp1,
    AVG(AcceptedCmp2 * Recency) / (STDEV(AcceptedCmp2) * STDEV(Recency)) AS Correlation_AcceptedCmp2,
    AVG(AcceptedCmp3 * Recency) / (STDEV(AcceptedCmp3) * STDEV(Recency)) AS Correlation_AcceptedCmp3,
    AVG(AcceptedCmp4 * Recency) / (STDEV(AcceptedCmp4) * STDEV(Recency)) AS Correlation_AcceptedCmp4,
    AVG(AcceptedCmp5 * Recency) / (STDEV(AcceptedCmp5) * STDEV(Recency)) AS Correlation_AcceptedCmp5,
	AVG(Response * Recency) / (STDEV(Response) * STDEV(Recency)) AS Correlation_Response
FROM PortfolioProject..marketing;


--Campiagn acceptance rates by customer segement

-- Education Level
SELECT
    Education,
    AVG(AcceptedCmp1) AS AcceptanceRate_Cmp1,
    AVG(AcceptedCmp2) AS AcceptanceRate_Cmp2,
    AVG(AcceptedCmp3) AS AcceptanceRate_Cmp3,
    AVG(AcceptedCmp4) AS AcceptanceRate_Cmp4,
    AVG(AcceptedCmp5) AS AcceptanceRate_Cmp5,
	AVG(Response) AS AcceptanceRate_Response
FROM PortfolioProject..marketing
GROUP BY Education;

-- Marital Status
SELECT
    Marital_Status,
    AVG(AcceptedCmp1) AS AcceptanceRate_Cmp1,
    AVG(AcceptedCmp2) AS AcceptanceRate_Cmp2,
    AVG(AcceptedCmp3) AS AcceptanceRate_Cmp3,
    AVG(AcceptedCmp4) AS AcceptanceRate_Cmp4,
    AVG(AcceptedCmp5) AS AcceptanceRate_Cmp5,
	AVG(Response) AS AcceptanceRate_Response
FROM PortfolioProject..marketing
GROUP BY Marital_Status;

-- Income Bracket 
SELECT
    CASE
        WHEN Income >= 0 AND Income < 30000 THEN 'Low Income'
        WHEN Income >= 30000 AND Income < 60000 THEN 'Medium Income'
        WHEN Income >= 60000 AND Income < 100000 THEN 'High Income'
        WHEN Income >= 100000 THEN 'Very High Income'
    END AS IncomeBracket,
    AVG(AcceptedCmp1) AS AcceptanceRate_Cmp1,
    AVG(AcceptedCmp2) AS AcceptanceRate_Cmp2,
    AVG(AcceptedCmp3) AS AcceptanceRate_Cmp3,
    AVG(AcceptedCmp4) AS AcceptanceRate_Cmp4,
    AVG(AcceptedCmp5) AS AcceptanceRate_Cmp5,
	AVG(Response) AS AcceptanceRate_Response
FROM PortfolioProject..marketing
GROUP BY
    CASE
        WHEN Income >= 0 AND Income < 30000 THEN 'Low Income'
        WHEN Income >= 30000 AND Income < 60000 THEN 'Medium Income'
        WHEN Income >= 60000 AND Income < 100000 THEN 'High Income'
        WHEN Income >= 100000 THEN 'Very High Income'
    END;

-- Campaign acceptance rates by customer segment with kids at home

-- Small Children at Home
SELECT
    Kidhome,
    AVG(AcceptedCmp1) AS AcceptanceRate_Cmp1,
    AVG(AcceptedCmp2) AS AcceptanceRate_Cmp2,
    AVG(AcceptedCmp3) AS AcceptanceRate_Cmp3,
    AVG(AcceptedCmp4) AS AcceptanceRate_Cmp4,
    AVG(AcceptedCmp5) AS AcceptanceRate_Cmp5,
	AVG(Response) AS AcceptanceRate_Response
FROM PortfolioProject..marketing
GROUP BY Kidhome;

-- Teenagers at Home
SELECT
    Teenhome,
    AVG(AcceptedCmp1) AS AcceptanceRate_Cmp1,
    AVG(AcceptedCmp2) AS AcceptanceRate_Cmp2,
    AVG(AcceptedCmp3) AS AcceptanceRate_Cmp3,
    AVG(AcceptedCmp4) AS AcceptanceRate_Cmp4,
    AVG(AcceptedCmp5) AS AcceptanceRate_Cmp5,
	AVG(Response) AS AcceptanceRate_Response
FROM PortfolioProject..marketing
GROUP BY Teenhome;


--Understanding complaints and customer behaviour 

--Count of customers who complained in the last 2 years

SELECT COUNT(*) as complained_customers
FROM PortfolioProject..marketing
WHERE Complain = 1;

--Correlation between complaints and campaign acceptance

SELECT
    AVG(Complain * AcceptedCmp1) / (STDEV(Complain) * STDEV(AcceptedCmp1)) AS Correlation_Complain_AcceptedCmp1,
    AVG(Complain * AcceptedCmp2) / (STDEV(Complain) * STDEV(AcceptedCmp2)) AS Correlation_Complain_AcceptedCmp2,
    AVG(Complain * AcceptedCmp3) / (STDEV(Complain) * STDEV(AcceptedCmp3)) AS Correlation_Complain_AcceptedCmp3,
    AVG(Complain * AcceptedCmp4) / (STDEV(Complain) * STDEV(AcceptedCmp4)) AS Correlation_Complain_AcceptedCmp4,
    AVG(Complain * AcceptedCmp5) / (STDEV(Complain) * STDEV(AcceptedCmp5)) AS Correlation_Complain_AcceptedCmp5,
	AVG(Complain * Response) / (STDEV(Complain) * STDEV(Response)) AS Correlation_Complain_Response
FROM PortfolioProject..marketing;


--Spending patterns comparisons for customers with compaints
SELECT Complain,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wines_pending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY Complain;

--Customers who accepted a specific campaign show different spending patterns

SELECT AcceptedCmp1,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wine_spending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY AcceptedCmp1;

SELECT AcceptedCmp2,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wine_spending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY AcceptedCmp2;

SELECT AcceptedCmp3,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wine_spending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY AcceptedCmp3;

SELECT AcceptedCmp4,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wine_spending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY AcceptedCmp4;

SELECT AcceptedCmp5,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wine_spending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY AcceptedCmp5;

SELECT Response,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wine_spending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY Response;

--Average spening for different household sizes

SELECT Kidhome,
       Teenhome,
      AVG(MntFishProducts) AS avg_fishproduct_spending,
	  AVG(MntWines) AS avg_wine_spending,
	  AVG(MntMeatProducts) AS avg_meatproduct_spending,
	  AVG(MntSweetProducts) AS avg_sweet_spending,
	  AVG(MntGoldProds) AS avg_gold_spending
FROM PortfolioProject..marketing
GROUP BY Kidhome,Teenhome;

--Which channels (deals, catalog, store, web) do customers prefer for making purchases?

SELECT
    'Deals' AS Channel,
    SUM(NumDealsPurchases) AS TotalPurchases
FROM PortfolioProject..marketing
UNION
SELECT
    'Catalog' AS Channel,
    SUM(NumCatalogPurchases) AS TotalPurchases
FROM PortfolioProject..marketing
UNION
SELECT
    'Store' AS Channel,
    SUM(NumStorePurchases) AS TotalPurchases
FROM PortfolioProject..marketing
UNION
SELECT
    'Web' AS Channel,
    SUM(NumWebPurchases) AS TotalPurchases
FROM PortfolioProject..marketing
ORDER BY TotalPurchases DESC;

-- Correlation between web visits and web purcheses
WITH Averages AS (
    SELECT
        AVG(NumWebVisitsMonth) AS AvgNumWebVisits,
        AVG(NumWebPurchases) AS AvgNumWebPurchases
    FROM
        PortfolioProject..marketing
)

SELECT
    AVG((NumWebVisitsMonth - AvgNumWebVisits) * (NumWebPurchases - AvgNumWebPurchases))
    / (STDEV(NumWebVisitsMonth) * STDEV(NumWebPurchases)) AS Correlation_WebVisits_Purchases
FROM
    PortfolioProject..marketing, Averages;

--CLV per customer segement
WITH CustomerCLV AS (
    SELECT
        Marital_Status,
        AVG(Income) AS AvgIncome,
        COUNT(*) AS Num_Transactions,
        AVG(Recency) AS AvgRecency,
        AVG(NumWebPurchases) AS AvgNumWebPurchases,
        (AVG(Income) * COUNT(*) * AVG(Recency)) AS CLV
    FROM
        PortfolioProject..marketing
    GROUP BY
        Marital_Status
)

SELECT
    Marital_Status,
    AVG(AvgIncome) AS AvgIncome,
    AVG(Num_Transactions) AS AvgNumTransactions,
    AVG(AvgRecency) AS AvgRecency,
    AVG(CLV) AS AvgCLV
FROM
    CustomerCLV
GROUP BY
    Marital_Status;

-- CLV per education
WITH CustomerCLV AS (
    SELECT
        Education,
        AVG(Income) AS AvgIncome,
        COUNT(*) AS Num_Transactions,
        AVG(Recency) AS AvgRecency,
        AVG(NumWebPurchases) AS AvgNumWebPurchases,
        (AVG(Income) * COUNT(*) * AVG(Recency)) AS CLV
    FROM
        PortfolioProject..marketing
    GROUP BY
        Education
)

SELECT
    Education,
    AVG(AvgIncome) AS AvgIncome,
    AVG(Num_Transactions) AS AvgNumTransactions,
    AVG(AvgRecency) AS AvgRecency,
    AVG(CLV) AS AvgCLV
FROM
    CustomerCLV
GROUP BY
    Education;

-- CLV based on household size
WITH CustomerCLV AS (
    SELECT
        Kidhome,
		Teenhome,
        AVG(Income) AS AvgIncome,
        COUNT(*) AS NumTransactions,
        AVG(Recency) AS AvgRecency,
        AVG(NumWebPurchases) AS AvgNumWebPurchases,
        (AVG(Income) * COUNT(*) * AVG(Recency)) AS CLV
    FROM
        PortfolioProject..marketing
    GROUP BY
        Kidhome,Teenhome
)

SELECT
    Kidhome,
	Teenhome,
    AVG(AvgIncome) AS AvgIncome,
    AVG(NumTransactions) AS AvgNumTransactions,
    AVG(AvgRecency) AS AvgRecency,
    AVG(CLV) AS AvgCLV
FROM
    CustomerCLV
GROUP BY
       Kidhome,Teenhome;


-- Time series analysis
--Monthly spending analysis
SELECT
    YEAR(Dt_Customer) AS Year,
    MONTH(Dt_Customer) AS Month,
    SUM(MntFishProducts + MntMeatProducts + MntFruits + MntSweetProducts + MntWines + MntGoldProds) AS TotalSpending,
	SUM(MntFishProducts) AS TotalFishSpending,
    SUM(MntMeatProducts) AS TotalMeatSpending,
    SUM(MntFruits) AS TotalFruitsSpending,
    SUM(MntSweetProducts) AS TotalSweetSpending,
    SUM(MntWines) AS TotalWinesSpending,
    SUM(MntGoldProds) AS TotalGoldSpending
FROM PortfolioProject..marketing
    
GROUP BY
    YEAR(Dt_Customer), MONTH(Dt_Customer)
ORDER BY
    Year, Month;


--Number of purchases over time
SELECT
    YEAR(Dt_Customer) AS Year,
    MONTH(Dt_Customer) AS Month,
    COUNT(*) AS TotalPurchases
FROM
    PortfolioProject..marketing
GROUP BY
    YEAR(Dt_Customer), MONTH(Dt_Customer)
ORDER BY
    Year, Month;




         

