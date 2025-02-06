
use session06;

-- 2
select min(Price) as MinPrice, max(Price) as MaxPrice from Orders;

-- 3
select CustomerName, count(Quantity) as OrderCount from Orders
group by CustomerName;

-- 4
select min(OrderDate) as EarliestDate, max(OrderDate) as LatestDate from Orders;