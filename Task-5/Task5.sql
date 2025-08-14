-- 1) Top-Selling Tracks Per Genre

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

-- 2) Revenue Per Region

SELECT
	BillingCountry,
    sum(total) as Revenue_Per_Region
FROM chinook.invoice
group by BillingCountry
order by Revenue_Per_Region desc;

-- 3) Monthly Performance

select
    month(InvoiceDate) as Month,
    sum(total) as Revenue
from chinook.invoice
group by month(InvoiceDate);


-- BONUS (Top 3 highest revenue generating customers(can be more than 3 having same revenue) per country)

select *
from
	(
		select
			C.CustomerId, LastName, Phone, Email, country, total,
			rank() over(partition by Country order by total desc) as Priority
		from
			(
				select
					CustomerId,
					sum(total) as total
				from chinook.invoice
				group by CustomerId
			) aggregated_total
		join chinook.customer C
			on C.CustomerId = aggregated_total.CustomerId
	) ranked_customers_per_country
where
	ranked_customers_per_country.Priority <= 3;