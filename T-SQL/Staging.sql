USE EcommerceStage

---Staging bảng Customers----
Drop table [dbo].[EcommerceStageCustomer]

SELECT customer_id, customer_city, customer_state
INTO [dbo].[EcommerceStageCustomer]
FROM [Ecommerce].[dbo].[customers]

---Staging bảng Sellers---
Drop table [dbo].[EcommerceStageSeller]

select [seller_id],[seller_city],[seller_state]
into [dbo].[EcommerceStageSeller]
from [Ecommerce].[dbo].[sellers]

---Staging bảng Products---
Drop table [dbo].[EcommerceStageProduct]

select product_id,product_category_name_english
into [dbo].[EcommerceStageProduct]
from [Ecommerce].[dbo].[products] p 
join [Ecommerce].[dbo].[product_category_name_translation] c
on p.[product_category_name] = c.[product_category_name]

---Staging bảng Date---
Drop table [dbo].[EcommerceStageDate]

SELECT *
INTO [dbo].[EcommerceStageDate]
FROM [Temp].[dbo].[Date_Dimension]
WHERE year between 2016 and 2019

---Staging fact sale---
Drop table [dbo].[EcommerceStageSale]

select oi.order_id
, c.customer_id
, p.product_id
, s.seller_id
, oi.order_item_id
, oi.price
, oi.freight_value
, o.order_purchase_timestamp
, o.order_delivered_customer_date
, o.order_estimated_delivery_date
into [dbo].[EcommerceStageSale]
from [Ecommerce].[dbo].[order_items] oi
join [Ecommerce].[dbo].[orders] o
on oi.order_id = o.order_id
join [Ecommerce].[dbo].[sellers] s
on oi.seller_id = s.seller_id
join [Ecommerce].[dbo].[products] p
on oi.product_id = p.product_id
join [Ecommerce].[dbo].[customers] c
on o.customer_id = c.customer_id

---Staging fact order---
Drop table [dbo].[EcommerceStageOrder]

select order_purchase_timestamp
, order_delivered_customer_date
, order_estimated_delivery_date
, customer_id
, o.order_id 
, oi.price
, oi.freight_value
, order_approved_at
into [dbo].[EcommerceStageOrder] 
from [Ecommerce].[dbo].[orders] as o
join [Ecommerce].[dbo].[order_items] as oi
on o.order_id = oi.order_id