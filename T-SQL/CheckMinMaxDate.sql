select min(order_purchase_timestamp) As StartPurchaseDate
, max(order_purchase_timestamp) As EndPurchaseDate
, min(order_approved_at) As StartApprovedDate
, max(order_approved_at) As EndApprovedDate
, min(order_delivered_customer_date) As StartShippedDate
, min(order_delivered_customer_date) As EndShippedDate
, min(order_estimated_delivery_date) As StartEstimatedDate
, max(order_estimated_delivery_date) As EndEstimatedDate
from [Ecommerce].[dbo].orders