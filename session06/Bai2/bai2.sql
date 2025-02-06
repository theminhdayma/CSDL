
use session06;

-- 2
select CustomerName, ProductName, sum(Quantity) as totalQuantity from Orders
group by ProductName, CustomerName
having totalQuantity > 1;

-- 3
select CustomerName, OrderDate, sum(Quantity) as totalQuantity from Orders
group by OrderDate, CustomerName
having totalQuantity > 2;

-- 4
select CustomerName, OrderDate, sum(Quantity*Price) as TotalSpent from Orders
group by OrderDate, CustomerName
having TotalSpent > 20000000;
