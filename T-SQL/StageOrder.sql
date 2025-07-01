SELECT customer_id, customer_city, customer_state
INTO [dbo].[EcommerceStageCustomer]
FROM [Ecommerce].[dbo].[customers]



SELECT min([order_purchase_timestamp]) As StartOrderDate 
, max([order_purchase_timestamp]) As EndOrderDate 
, min([order_delivered_customer_date]) As StartShippedDate 
, max([order_delivered_customer_date]) As EndShippedDate
, min([order_estimated_delivery_date]) As StartEstimatedShippedDate 
, max([order_estimated_delivery_date]) As EndEstimatedShippedDate
FROM [Ecommerce].[dbo].[orders]


SELECT *
INTO [dbo].[EcommerceStageDate]
FROM [ExternalSources].[dbo].[DateDimension]
WHERE year between 2016 and 2019


select order_purchase_timestamp
, order_delivered_customer_date
, order_estimated_delivery_date
, customer_id
, o.order_id 
, sum(price) + sum(freight_value) as TotalAmount
, sum(freight_value) as TotalShipAmount
, sum(price) as TotalProductValue
, DATEDIFF(DAY, [order_approved_at], [order_delivered_customer_date]) as DeliveryActualDays
, DATEDIFF(DAY, [order_approved_at], [order_estimated_delivery_date]) as DeliveryEstimateDays
, DATEDIFF(DAY, [order_purchase_timestamp], [order_approved_at]) as ApproveDays
into [dbo].[EcommerceStageOrder] 
from [Ecommerce].[dbo].[orders] as o
join [Ecommerce].[dbo].[order_items] as oi
on o.order_id = oi.order_id
GROUP BY 
    o.order_purchase_timestamp,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.customer_id,
    o.order_id,
    o.order_approved_at;

