
DROP DATABASE EcommerceDWSSIS
GO
CREATE DATABASE EcommerceDWSSIS
GO
ALTER DATABASE EcommerceDWSSIS
SET RECOVERY SIMPLE
GO

USE EcommerceDWSSIS
;
IF EXISTS (SELECT Name from sys.extended_properties where Name = 'Description')
    EXEC sys.sp_dropextendedproperty @name = 'Description'
EXEC sys.sp_addextendedproperty @name = 'Description', @value = 'Default description - you should change this.'
;





/* Drop table dbo.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimCustomer 
;

/* Create table dbo.DimCustomer */
CREATE TABLE dbo.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  nvarchar(50)   NOT NULL
,  [CustomerCity]  nvarchar(50)   NULL
,  [CustomerSate]  nvarchar(50)   NULL
, CONSTRAINT [PK_dbo.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT dbo.DimCustomer ON
;
INSERT INTO dbo.DimCustomer (CustomerKey, CustomerID, CustomerCity, CustomerSate)
VALUES (-1, '-1', 'Unk Attribute1', 'Unk Attribute2')
;
SET IDENTITY_INSERT dbo.DimCustomer OFF
;

/* Drop table dbo.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimProduct 
;

/* Create table dbo.DimProduct */
CREATE TABLE dbo.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  nvarchar(50)   NOT NULL
,  [CategoryName]  nvarchar(50)   NOT NULL
, CONSTRAINT [PK_dbo.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT dbo.DimProduct ON
;
INSERT INTO dbo.DimProduct (ProductKey, ProductID, CategoryName)
VALUES (-1, '-1', 'Unk Attribute1')
;
SET IDENTITY_INSERT dbo.DimProduct OFF
;

/* Drop table dbo.DimSeller */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimSeller') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimSeller 
;

/* Create table dbo.DimSeller */
CREATE TABLE dbo.DimSeller (
   [SellerKey]  int IDENTITY  NOT NULL
,  [SellerID]  nvarchar(50)   NOT NULL
,  [SellerCity]  nvarchar(50)   NULL
,  [SellerState]  nvarchar(50)   NULL
, CONSTRAINT [PK_dbo.DimSeller] PRIMARY KEY CLUSTERED 
( [SellerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT dbo.DimSeller ON
;
INSERT INTO dbo.DimSeller (SellerKey, SellerID, SellerCity, SellerState)
VALUES (-1, '-1', 'Unk Attribute1', 'Unk Attribute2')
;
SET IDENTITY_INSERT dbo.DimSeller OFF
;


/* Drop table dbo.DimTime */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.DimTime') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.DimTime 
;

/* Create table dbo.DimTime */
CREATE TABLE dbo.DimTime (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [DayOfWeek]  tinyint   NULL
,  [DayName]  varchar(9)   NULL
,  [DayOfMonth]  tinyint   NULL
,  [DayOfYear]  smallint   NULL
,  [WeekOfYear]  tinyint   NULL
,  [MonthName]  varchar(9)   NULL
,  [MonthOfYear]  tinyint   NULL
,  [Quarter]  tinyint   NULL
,  [QuarterName]  varchar(2)   NULL
,  [Year]  smallint   NULL
,  [IsWeekday]  char(1)   NULL
, CONSTRAINT [PK_dbo.DimTime] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;


INSERT INTO dbo.DimTime (DateKey, Date, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 0, '', 0, 0, 0, '', 0, 0, '', 0, '0')
;



/* Drop table dbo.FactOrder */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactOrder') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactOrder 
;

/* Create table dbo.FactOrder */
CREATE TABLE dbo.FactOrder (
   [PurchaseDateKey]  int   NOT NULL
,  [DeliveredDateKey]  int   NULL
,  [EstimateDeliveredDateKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [order_id]  nvarchar(50)   NOT NULL
,  [TotalAmount]  money   NULL
,  [ShipAmount]  money   NULL
,  [TotalProductValue]  money   NULL
,  [DeliveryActualDays]  int   NULL
,  [DeliveryEstimateDays]  int   NULL
,  [ApproveDays]  int   NULL
, CONSTRAINT [PK_dbo.FactOrder] PRIMARY KEY NONCLUSTERED 
( [order_id] )
) ON [PRIMARY]
;


/* Drop table dbo.FactSale */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.FactSale') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE dbo.FactSale 
;

/* Create table dbo.FactSale */
CREATE TABLE dbo.FactSale (
   [PurchaseDateKey]  int   NOT NULL
,  [DeliveredDateKey]  int   NULL
,  [EstimateDeliveredDateKey]  int   NOT NULL
,  [CustomerKey]  int   NOT NULL
,  [ProductKey]  int   NOT NULL
,  [SellerKey]  int   NOT NULL
,  [order_item_id]  tinyint   NOT NULL
,  [order_id]  nvarchar(50)   NOT NULL
,  [product_id]  nvarchar(50)   NOT NULL
,  [Price]  money   NULL
,  [FreightValue]  money   NULL
,  [TotalValue]  money   NULL
, CONSTRAINT [PK_dbo.FactSale] PRIMARY KEY NONCLUSTERED 
( [order_item_id], [order_id], [product_id] )
) ON [PRIMARY]
;


ALTER TABLE dbo.FactOrder ADD CONSTRAINT
   FK_dbo_FactOrder_PurchaseDateKey FOREIGN KEY
   (
   PurchaseDateKey
   ) REFERENCES DimTime
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactOrder ADD CONSTRAINT
   FK_dbo_FactOrder_DeliveredDateKey FOREIGN KEY
   (
   DeliveredDateKey
   ) REFERENCES DimTime
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactOrder ADD CONSTRAINT
   FK_dbo_FactOrder_EstimateDeliveredDateKey FOREIGN KEY
   (
   EstimateDeliveredDateKey
   ) REFERENCES DimTime
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactOrder ADD CONSTRAINT
   FK_dbo_FactOrder_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSale ADD CONSTRAINT
   FK_dbo_FactSale_PurchaseDateKey FOREIGN KEY
   (
   PurchaseDateKey
   ) REFERENCES DimTime
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSale ADD CONSTRAINT
   FK_dbo_FactSale_DeliveredDateKey FOREIGN KEY
   (
   DeliveredDateKey
   ) REFERENCES DimTime
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSale ADD CONSTRAINT
   FK_dbo_FactSale_EstimateDeliveredDateKey FOREIGN KEY
   (
   EstimateDeliveredDateKey
   ) REFERENCES DimTime
   ( DateKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSale ADD CONSTRAINT
   FK_dbo_FactSale_CustomerKey FOREIGN KEY
   (
   CustomerKey
   ) REFERENCES DimCustomer
   ( CustomerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSale ADD CONSTRAINT
   FK_dbo_FactSale_ProductKey FOREIGN KEY
   (
   ProductKey
   ) REFERENCES DimProduct
   ( ProductKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE dbo.FactSale ADD CONSTRAINT
   FK_dbo_FactSale_SellerKey FOREIGN KEY
   (
   SellerKey
   ) REFERENCES DimSeller
   ( SellerKey )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
