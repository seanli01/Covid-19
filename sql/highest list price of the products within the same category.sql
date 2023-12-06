/*
WITH cte_numbers(n, weekday) 
AS (
    SELECT --anchor member
        0, 
        DATENAME(DW, 0)
    UNION ALL
    SELECT   -- recursive 
        n + 1, 
        DATENAME(DW, n + 1)
    FROM    
        cte_numbers
    WHERE n < 6  --condition
)
SELECT
    weekday
FROM 
    cte_numbers

SELECT 
	*
From
	sales.staffs

SELECT * FROM   
(
    SELECT 
        category_name, 
        product_id
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
       -- [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;

SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name

*/
--  highest list price of the products within the same category
SELECT
	product_name,
	
	category_id,
	list_price

    FROM
        production.products one

WHERE list_price IN(
	SELECT
		MAX(two.list_price)

	FROM 
		production.products two

	WHERE two.category_id = one.category_id

	GROUP By
		two.category_id
	)

--  highest list price of the products within the same category
;
with CTE_Max_Cat as
(
select category_id, MAX(list_price) as Max_Price
from production.products 
group by category_id
)
select 
	--p.*
	p.product_name,
	p.category_id,
	p.list_price
from production.products  as P
	inner join CTE_Max_Cat as M on M.category_id=P.category_id and M.Max_Price=P.list_price

--  highest list price of the products within the same category

select 
	--p.*
	p.product_name,
	p.category_id,
	p.list_price
from production.products  as P
	inner join 
	(select category_id, MAX(list_price) as Max_Price
	from production.products 
	group by category_id) as M on M.category_id=P.category_id and M.Max_Price=P.list_price

	
--  highest list price of the products within the same category

--select 
--	--p.*
--	p.product_name,
--	p.category_id,
--	p.list_price
--	--p2.list_price

--from production.products  as P
--	inner join production.products  as P2 on P2.category_id=P.category_id and P2.list_price>P.list_price
--where p.category_id=2
--order by p.list_price 