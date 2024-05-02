drop table purchases;
create table purchases(
	user_id int,
	product_id int,
	quantity int,
	purchase_date datetime
);

insert into purchases values(536, 3223, 6, '2022-01-11 12:33:44');
insert into purchases values(827, 3585, 35, '2022-02-20 14:05:26');
insert into purchases values(536, 3223, 5, '2022-03-02 09:33:28');
insert into purchases values(536, 1435, 10, '2022-03-02 08:40:00');
insert into purchases values(827, 2452, 45, '2022-03-02 00:00:00');
insert into purchases values(333, 1122, 9, '2022-02-06 01:00:00');
insert into purchases values(333, 1122, 10, '2022-02-06 02:00:00');
select * from purchases;
--
select user_id,product_id,count( distinct cast(purchase_date as date)) as d_purch
from  purchases 
group by user_id,product_id
having count( distinct cast(purchase_date as date)) >1;

select count(*) as count from(select *,
lag(purchase_date) over(partition by user_id order by purchase_date) as nxt_pur
from purchases) s
where cast(purchase_date as date)- cast(nxt_pur as date) >0 and user_id in ( select user_id from purchases 
group by user_id,product_id
having count(*) >1);
