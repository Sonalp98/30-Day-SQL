create table sku 
(
sku_id int,
price_date date ,
price int
);
delete from sku;
insert into sku values 
(1,'2023-01-01',10)
,(1,'2023-02-15',15)
,(1,'2023-03-03',18)
,(1,'2023-03-27',15)
,(1,'2023-04-06',20);
select * from sku;
with cte as(select *,row_number() over(partition by year(price_date),month(price_date) order by price_date desc) as rn
from sku)
-- select sku_id,price_date as first_day,price from sku
-- where month(price_date)=1
-- union 
select sku_id, date_format(price_date,'%Y-%m-01')+ interval 1 month as first_day,price
from cte where rn=1;

