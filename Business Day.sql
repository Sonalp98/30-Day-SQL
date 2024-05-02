drop table tickets;
select * from tickets;
create table tickets( ticket_id int,create_date date,resolved_date date);
insert into tickets values(2,'2022-08-01','2022-08-16');
update tickets
set ticket_id= 3
where resolved_date= '2022-08-16';
select * from tickets;
select *,day(resolved_date)-day(create_date) as day_diff,
week(resolved_date)-week(create_date) as day_diff,
(day(resolved_date)-day(create_date))- 2*(week(resolved_date)-week(create_date)) as business_day
from tickets;
drop table holidays;
create table holidays( holiday_date date,reason varchar(20));
insert into holidays values('2022-08-11','Rakhi');
select * from holidays;
with cte as(select *,day(resolved_date)-day(create_date) as day_diff,
week(resolved_date)-week(create_date) as week_diff,
(day(resolved_date)-day(create_date))- 2*(week(resolved_date)-week(create_date)) as business_day
from tickets t
left join holidays h
on h.holiday_date between t.create_date and t.resolved_date)
select ticket_id,create_date,resolved_date,business_day, count(holiday_date) as h,
(business_day- count(holiday_date)) as new
from cte
group by ticket_id,create_date,resolved_date,business_day;
