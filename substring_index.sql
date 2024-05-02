
create table a
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
delete from airbnb_searches;
insert into a values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')
;
select * from a;
with cte as(select *,substring_index( filter_room_types,',',1)  as homes from a
union
select  *, substring_index( filter_room_types,',',-1)  as homes from a
order by user_id)
select homes, count(*) as count
from cte 
group by homes
order by count desc;
-- in sql 
select value as homes, count(*) as count from a
cross apply string_split(filter_room_types,',')
group by value
order by count desc

