--PART ONE
--Counts number of rows in table
SELECT COUNT(*) "COUNT" FROM INVOICE;


--Counts number of rows that are greater than 500
SELECT COUNT(*) AS "Balance > 500" FROM CUSTOMER
WHERE CUS_BALANCE > 500;


--Joins three tables together using foreign keys so we can output different columns
SELECT I.CUS_CODE, I.INV_NUMBER, I.INV_DATE, P.P_DESCRIPT, L.LINE_UNITS, L.LINE_PRICE 
FROM INVOICE I
JOIN CUSTOMER C ON I.CUS_CODE = C.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
JOIN PRODUCT P ON L.P_CODE = P.P_CODE
ORDER BY I.CUS_CODE, I.INV_NUMBER, P.P_DESCRIPT;


--Generate a list customer purchases, including the subtotals for each of the invoices
SELECT I.CUS_CODE, I.INV_NUMBER, I.INV_DATE, P.P_DESCRIPT, L.LINE_UNITS, L.LINE_PRICE, L.LINE_UNITS*L.LINE_PRICE AS "Sub Total"
FROM INVOICE I
JOIN CUSTOMER C ON I.CUS_CODE = C.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
JOIN PRODUCT P ON L.P_CODE = P.P_CODE
ORDER BY I.CUS_CODE, I.INV_NUMBER, P.P_DESCRIPT;


--Displays the customer code, balance and total purchases for each customer.
SELECT  C.CUS_CODE, C.CUS_BALANCE, SUM(L.LINE_UNITS*L.LINE_PRICE) AS TotalPurchases
FROM CUSTOMER C
JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE
ORDER BY C.CUS_CODE;


--Displays the number of individual product purchases made by each customer
SELECT  C.CUS_CODE, C.CUS_BALANCE, SUM(L.LINE_UNITS*L.LINE_PRICE) AS TotalPurchases, COUNT(I.INV_NUMBER)
FROM CUSTOMER C
JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE
ORDER BY C.CUS_CODE;


--Displays the total of all purchases, the number of purchases and the average purchase
--amount made by each customer.
SELECT  C.CUS_CODE, C.CUS_BALANCE, SUM(L.LINE_UNITS*L.LINE_PRICE) AS TotalPurchases, 
COUNT(I.INV_NUMBER) AS NumOfPurchases, ROUND(SUM(L.LINE_UNITS*L.LINE_PRICE) / COUNT(I.INV_NUMBER), 2) AS AveragePurchaseAmount
FROM CUSTOMER C
JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY C.CUS_CODE, C.CUS_BALANCE
ORDER BY C.CUS_CODE;


--Displays the total purchase per invoice.
SELECT I.INV_NUMBER, SUM(L.LINE_UNITS*L.LINE_PRICE) AS InvoiceTotal
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY I.INV_NUMBER
ORDER BY I.INV_NUMBER;


--Displays all invoices for each customer and the invoice total
SELECT I.CUS_CODE, I.INV_NUMBER, SUM(L.LINE_UNITS*L.LINE_PRICE) AS InvoiceTotal
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY I.CUS_CODE, I.INV_NUMBER
ORDER BY I.CUS_CODE;


--Displays the total number of invoices and total sum of invocies for each customer 
SELECT I.CUS_CODE, COUNT(I.INV_NUMBER), SUM(L.LINE_UNITS*L.LINE_PRICE) AS InvoiceTotal
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY I.CUS_CODE
ORDER BY I.CUS_CODE;


--Displays the total number of invocies, the invoice total for all invoices, the smallest
--of the customer purchase amounts, the largest of the customer purchase amoutns
--and the average of all the customer purchase amounts.
SELECT SUM(count(DISTINCT I.INV_NUMBER)) AS "Total Income", SUM(SUM(L.LINE_PRICE*L.LINE_UNITS)) AS "Total Sales",
MIN(SUM(L.LINE_PRICE*L.LINE_UNITS)) AS "Minimum Customer Purchase", MAX(SUM(L.LINE_PRICE*L.LINE_UNITS)) AS "Largest Customer Purchases",
AVG(SUM(L.LINE_PRICE*L.LINE_UNITS))
FROM INVOICE I
JOIN LINE L ON I.INV_NUMBER = L.INV_NUMBER
GROUP BY I.CUS_CODE;


--Display the balances of customers who have make purchases during the current 
--invoice cycle-this is, for customers who appear in the INVOICE table.
SELECT DISTINCT C.CUS_CODE, C.CUS_BALANCE
FROM CUSTOMER C, INVOICE I
WHERE C.CUS_CODE = I.CUS_CODE
ORDER BY C.CUS_CODE;


--Displays a summary of customer balance characteristics for customers
--who makde purchases.
SELECT MIN(C.CUS_BALANCE), MAX(C.CUS_BALANCE), AVG(C.CUS_BALANCE)
FROM CUSTOMER C
JOIN INVOICE I ON C.CUS_CODE = I.CUS_CODE
WHERE C.CUS_CODE = I.CUS_CODE;


--Display the balance characteristics for all customers, including total of the
--outstandingn balances.
SELECT SUM(C.CUS_BALANCE), MIN(C.CUS_BALANCE), MAX(C.CUS_BALANCE), AVG(C.CUS_BALANCE)
FROM CUSTOMER C;


--Display customers who did not make purchases during the invoicing period.
SELECT C.CUS_CODE, C.CUS_BALANCE
FROM CUSTOMER C
WHERE C.CUS_CODE NOT IN (SELECT CUS_CODE FROM INVOICE)
ORDER BY C.CUS_CODE;


--Display customer balances summary for all customers who have not make purchases
-- during the current invoice period
SELECT SUM(C.CUS_BALANCE), MIN(C.CUS_BALANCE), MAX(C.CUS_BALANCE), AVG(C.CUS_BALANCE)
FROM CUSTOMER C
WHERE C.CUS_CODE NOT IN (SELECT CUS_CODE FROM INVOICE);


--Displays a summary of values of products currently in inventory.
SELECT P.P_DESCRIPT, P.P_QOH, P.P_PRICE, ROUND(P.P_QOH*P.P_PRICE, 2) AS "Sub total"
FROM PRODUCT P
ORDER BY "Sub total" DESC;


--Finds the total value of all products in the inventory.
SELECT SUM(P.P_QOH*P.P_PRICE)
FROM PRODUCT P;