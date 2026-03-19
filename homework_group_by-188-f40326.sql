/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT
 DATENAME (year, i.[InvoiceDate]) as [Year]
,DATEPART (month, i.[InvoiceDate]) as [Month]
,AVG (il.[UnitPrice]) as UnitPrice
,SUM (il.[ExtendedPrice]) as ExtendedPriceSUM
FROM [WideWorldImporters].[Sales].[Invoices] as i
INNER JOIN [WideWorldImporters].[Sales].[InvoiceLines] as il
 ON i.[InvoiceID] = il.[InvoiceID]
GROUP BY DATENAME (year, i.[InvoiceDate]), DATEPART (month, i.[InvoiceDate])
ORDER BY [Year], [Month]

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT
 DATENAME (year, i.[InvoiceDate]) as [Year]
,DATEPART (month, i.[InvoiceDate]) as [Month]
,SUM (il.[ExtendedPrice]) as [ExtendedPriceSUM]
FROM [WideWorldImporters].[Sales].[Invoices] as i
INNER JOIN [WideWorldImporters].[Sales].[InvoiceLines] as il
 ON i.[InvoiceID] = il.[InvoiceID]
GROUP BY DATENAME (year, i.[InvoiceDate]), DATEPART (month, i.[InvoiceDate])
HAVING SUM (il.[ExtendedPrice]) > 4600000
ORDER BY [Year], [Month]

-- Не совсем понятно как проверить работу второго скрипта ибо нет ни одного месяца, где не было бы продаж вообще
SELECT
 DATENAME (year, i.[InvoiceDate]) as [Year]
,DATEPART (month, i.[InvoiceDate]) as [Month]
,SUM (il.[ExtendedPrice]) as [ExtendedPriceSUM]
FROM [WideWorldImporters].[Sales].[Invoices] as i
INNER JOIN [WideWorldImporters].[Sales].[InvoiceLines] as il
 ON i.[InvoiceID] = il.[InvoiceID]
GROUP BY DATENAME (year, i.[InvoiceDate]), DATEPART (month, i.[InvoiceDate])
HAVING SUM (il.[ExtendedPrice]) > 4600000 OR SUM (il.[ExtendedPrice]) = 0
ORDER BY [Year], [Month]

/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

SELECT
 DATENAME (year, i.[InvoiceDate]) as [Year]
,DATEPART (month, i.[InvoiceDate]) as [Month]
,il.[Description]
,SUM (il.[ExtendedPrice]) as [ExtendedPriceSUM]
,MIN (i.[InvoiceDate]) as [MinInvoiceDate]
,SUM (il.[Quantity]) as [Quantity]
FROM [WideWorldImporters].[Sales].[Invoices] as i
INNER JOIN [WideWorldImporters].[Sales].[InvoiceLines] as il
 ON i.[InvoiceID] = il.[InvoiceID]
GROUP BY DATENAME (year, i.[InvoiceDate]), DATEPART (month, i.[InvoiceDate]), il.[Description]
HAVING SUM (il.[Quantity]) < 50
ORDER BY [Year], [Month], il.[Description]


-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
