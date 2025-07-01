INSERT INTO [EcommerceDW].[dbo].[DimCustomer]
	(CustomerID, CustomerCity, CustomerSate)
SELECT 
	[customer_id], [customer_city], [customer_state]
FROM [EcommerceStageDW].[dbo].[EcommerceStageCustomer]


insert into [EcommerceDW].[dbo].[DimTime]
(DateKey, Date, DayOfWeek, DayName, DayOfMonth, DayOfYear, 
WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday) 
select  
date_key, full_date, day_of_week, day_name, day_num_in_month,  
day_num_overall, week_num_in_year, month_name, month, quarter,  
case  
when quarter >= 1 and quarter <= 3 then 'First' 
when quarter >= 4 and quarter <= 6 then 'Second' 
when quarter >= 7 and quarter <= 9 then 'Third' 
when quarter >= 10 and quarter <= 12 then 'Fourth' 
end, 
year, weekday_flag 
from [EcommerceStageDW].[dbo].[EcommerceStageDate]


INSERT INTO [EcommerceDW].[dbo].[FactOrder]
	(PurchaseDateKey, DeliveredDateKey, EstimateDeliveredDateKey, CustomerKey, order_id,
	TotalAmount, ShipAmount, TotalProductValue, DeliveryActualDays, DeliveryEstimateDays, ApproveDays)

SELECT 
	Day(e.[order_purchase_timestamp]) + MONTH(e.[order_purchase_timestamp]) * 100 + YEAR(e.[order_purchase_timestamp]) * 10000 As PurchaseDateKey,
	Day(e.[order_delivered_customer_date]) + MONTH(e.[order_delivered_customer_date]) * 100 + YEAR(e.[order_delivered_customer_date]) * 10000 ,
	Day(e.[order_estimated_delivery_date]) + MONTH(e.[order_estimated_delivery_date]) * 100 + YEAR(e.[order_estimated_delivery_date]) * 10000 As EstimateDeliveredDateKey,
	c.CustomerKey,
	e.[order_id],
	e.[TotalAmount],
	e.[TotalShipAmount],
	e.[TotalProductValue],
	e.[DeliveryActualDays],
	e.[DeliveryEstimateDays],
	e.[ApproveDays]
FROM [EcommerceStageDW].[dbo].[EcommerceStageOrder] as e
join [EcommerceDW].[dbo].[DimCustomer] c
on e.[customer_id] = c.CustomerID
