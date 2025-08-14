-- Top-Selling Tracks Per Genre
SELECT
	G.GenreId,
    G.Name,
	Genre_Revenues.Revenue
from chinook.genre G
join
	(
		select
			T.GenreId,
			sum(IL.UnitPrice) as Revenue
		FROM chinook.invoiceline IL
		join chinook.track T on IL.TrackId = T.TrackId
		group by T.GenreId
	) Genre_Revenues
on
	Genre_Revenues.GenreId = G.GenreId
order by
	Revenue desc;

-- 1) Top-Selling Products (Quantity of Tracks Selled)
select T.name Track, sum(Quantity) as Quantity
from invoiceline IL join track T on IL.trackId = T.trackId
group by T.name
order by Quantity desc;

-- 2) Revenue Per Region
SELECT
	BillingCountry Country,
    sum(total) as Revenue
FROM
	chinook.invoice
group by
	BillingCountry
order by
	Revenue desc;

-- 3) Monthly Performance
select
    monthname(InvoiceDate) as Month,
    sum(total) as Revenue
from
	chinook.invoice
group by
	monthname(InvoiceDate);


-- BONUS (Top 3 highest revenue generating customers per country)
select *
from (
	select
		FirstName, LastName, Country, State, City, Address, Company, Phone, Email, total,
		row_number() over(partition by Country order by total desc) as Priority
		from (
			select
				CustomerId,
				sum(total) as total
			from chinook.invoice
			group by CustomerId
		) aggregated_total
		join chinook.customer C on C.CustomerId = aggregated_total.CustomerId
	) ranked_customers_per_country
where
	ranked_customers_per_country.Priority <= 3;