create table clocked_hours(

empd_id int,

swipe time,

flag char

);

insert into clocked_hours values

(11114,'08:30','I'),

(11114,'10:30','O'),

(11114,'11:30','I'),

(11114,'15:30','O'),

(11115,'09:30','I'),

(11115,'17:30','O');
select * from clocked_hours;
--
select empd_id,sum(hour(nxt_swipe-swipe)) as clocked_hours from (select *, lead(swipe) over(partition by empd_id order by swipe) as nxt_swipe
from clocked_hours) s
where flag='I'
group by empd_id;
with cte as(select *, row_number() over(partition by empd_id,flag order by swipe) as rn
from clocked_hours),
cte2 as(
select empd_id,rn,max(swipe)as max,min(swipe) as min, hour(max(swipe)-min(swipe)) as hr from cte
group by empd_id,rn)
select empd_id,sum(hr) as cloacked_hr
from cte2 
group by empd_id