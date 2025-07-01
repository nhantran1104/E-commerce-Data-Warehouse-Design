--Load bảng DimCustomer--
insert into [EcommerceDW].[dbo].[DimCustomer]
([CustomerID], [CustomerCity], [CustomerSate])
select
[customer_id],[customer_city],[customer_state]
from [EcommerceStage].dbo.EcommerceStageCustomer

--Load bảng DimProduct--
insert into [EcommerceDW].[dbo].[DimProduct]
([ProductID], [CategoryName])
select
[product_id], [product_category_name_english]
from [EcommerceStage].dbo.EcommerceStageProduct

--Load bảng DimSeller--
insert into [EcommerceDW].[dbo].[DimSeller]
([SellerID],[SellerCity],[SellerState])
select
[seller_id],[seller_city],[seller_state]
from [EcommerceStage].dbo.EcommerceStageSeller

--Load bảng DimTime--
insert into [EcommerceDW].[dbo].DimTime
(DateKey, Date, DayOfWeek, DayName, DayOfMonth, DayOfYear,
WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
select
date_key, full_date, day_of_week, day_name, day_num_in_month,
day_num_overall, week_num_in_year, month_name, month, quarter,
case
when month >= 1 and month <= 3 then 'First'
when month >= 4 and month <= 6 then 'Second'
when month >= 7 and month <= 9 then 'Third'
when month >= 10 and month <= 12 then 'Fourth'
end,
year, weekday_flag
from [EcommerceStage].dbo.EcommerceStageDate

---Load bảng FactSale---
insert into EcommerceDW.dbo.FactSale
([PurchaseDateKey],[DeliveredDateKey],[EstimateDeliveredDateKey],[CustomerKey],[ProductKey],[SellerKey],[order_item_id],[order_id],[product_id],[Price],[FreightValue],[TotalValue])
select Day(s.order_purchase_timestamp) + MONTH(s.order_purchase_timestamp) * 100 + YEAR(s.order_purchase_timestamp) * 10000 As
PurchaseDateKey,
case when s.order_delivered_customer_date is null then -1
else Day(s.order_delivered_customer_date) + MONTH(s.order_delivered_customer_date) * 100 + YEAR(s.order_delivered_customer_date) * 10000
end as DeliveredDateKey,
Day(s.order_estimated_delivery_date) + MONTH(s.order_estimated_delivery_date) * 100 + YEAR(s.order_estimated_delivery_date) * 10000 As
EstimateDeliveredDateKey,
c.CustomerKey,
p.ProductKey,
se.SellerKey,
s.order_item_id,
order_id,
product_id,
price,
freight_value,
price + freight_value as TotalValue
from [EcommerceStage].dbo.EcommerceStageSale s
join [EcommerceDW].[dbo].DimCustomer c
on s.customer_id = c.CustomerID
join [EcommerceDW].[dbo].DimSeller se
on se.SellerID = s.seller_id
join [EcommerceDW].[dbo].DimProduct p
on p.ProductID = s.product_id

---Load bảng FactOrder---
insert into EcommerceDW.dbo.FactOrder
([PurchaseDateKey],[DeliveredDateKey],[EstimateDeliveredDateKey],[CustomerKey],[order_id],[ShipAmount],[TotalProductValue],[TotalAmount],[DeliveryActualDays],[DeliveryEstimateDays],[ApproveDays])
select Day(o.[order_purchase_timestamp]) + MONTH(o.order_purchase_timestamp) * 100 + YEAR(o.order_purchase_timestamp) * 10000 As
PurchaseDateKey,
case when o.order_delivered_customer_date is null then -1
else Day(o.order_delivered_customer_date) + MONTH(o.order_delivered_customer_date) * 100 + YEAR(o.order_delivered_customer_date) * 10000
end as DeliveredDateKey,
Day(o.order_estimated_delivery_date) + MONTH(o.order_estimated_delivery_date) * 100 + YEAR(o.order_estimated_delivery_date) * 10000 As
EstimateDeliveredDateKey,
c.CustomerKey,
o.[order_id]
,sum(freight_value) as ShipAmount
, sum(price) as TotalProductValue
, sum(price) + sum(freight_value) as TotalAmount
, DATEDIFF(DAY, [order_approved_at], [order_delivered_customer_date]) as DeliveryActualDays
, DATEDIFF(DAY, [order_approved_at], [order_estimated_delivery_date]) as DeliveryEstimateDays
, DATEDIFF(DAY, [order_purchase_timestamp], [order_approved_at]) as ApproveDays
from [EcommerceStage].dbo.EcommerceStageOrder o
join [EcommerceDW].[dbo].DimCustomer c
on o.[customer_id] = c.CustomerID
GROUP BY 
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    c.CustomerKey,
    o.order_id,
    o.order_approved_at;