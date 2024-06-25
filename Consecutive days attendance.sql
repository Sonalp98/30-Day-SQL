drop table if exists emp_attendance;
create table emp_attendance
(
	employee 	varchar(10),
	dates 		date,
	status 		varchar(20)
);
insert into emp_attendance values('A1', '2024-01-01', 'PRESENT');
insert into emp_attendance values('A1', '2024-01-02', 'PRESENT');
insert into emp_attendance values('A1', '2024-01-03', 'PRESENT');
insert into emp_attendance values('A1', '2024-01-04', 'ABSENT');
insert into emp_attendance values('A1', '2024-01-05', 'PRESENT');
insert into emp_attendance values('A1', '2024-01-06', 'PRESENT');
insert into emp_attendance values('A1', '2024-01-07', 'ABSENT');
insert into emp_attendance values('A1', '2024-01-08', 'ABSENT');
insert into emp_attendance values('A1', '2024-01-09', 'ABSENT');
insert into emp_attendance values('A1', '2024-01-010', 'PRESENT');
insert into emp_attendance values('A2', '2024-01-06', 'PRESENT');
insert into emp_attendance values('A2', '2024-01-07', 'PRESENT');
insert into emp_attendance values('A2', '2024-01-08', 'ABSENT');
insert into emp_attendance values('A2', '2024-01-09', 'PRESENT');
insert into emp_attendance values('A2', '2024-01-010', 'ABSENT');

SELECT * from emp_attendance;
With cte as(select *,row_number() over(partition by employee order by dates) as rn
from emp_attendance),
cte_present as(
select *,row_number() over(partition by employee order by dates) as rn1,
rn-row_number() over(partition by employee order by dates) as flag
from cte
where status='PRESENT'),
cte_absent as(
select *,row_number() over(partition by employee order by dates) as rn1,
rn-row_number() over(partition by employee order by dates) as flag
from cte
where status='ABSENT')
select employee,first_value(dates) over(partition by employee,flag order by employee,dates) as from_date,
last_value(dates) over(partition by employee,flag order by employee,dates range between unbounded preceding and unbounded following) 
as to_date,status
from cte_present
union 
select employee,first_value(dates) over(partition by employee,flag order by employee,dates) as from_date,
last_value(dates) over(partition by employee,flag order by employee,dates range between unbounded preceding and unbounded following) 
as to_date,status
from cte_absent
order by employee,from_date;
select * from emp_attendance;
-- 2nd Solution
With cte as(select *,row_number() over(partition by employee order by dates) as rn,
row_number() over(partition by employee,status order by dates) as rn1
from emp_attendance)
select employee,min(dates) as from_date,max(dates) as to_date,status
from cte
group by employee,rn-rn1,status
order by 1,2;
-- 3rd solution
With cte as(select *,row_number() over(partition by employee order by dates)-
row_number() over(partition by employee,status order by dates) as rn
from emp_attendance)
select employee,min(dates) as from_date,max(dates) as to_date,status
from cte
group by employee,rn,status
order by 1,2;
-- 4th solution
WITH CTE AS 
	(SELECT *
	, date_sub(dates, interval ROW_NUMBER() OVER(PARTITION BY employee, status ORDER BY dates) DAY) as date_grp
	FROM emp_attendance)
SELECT employee, MIN(dates) AS from_date 
, MAX(dates) AS end_date, status
FROM CTE
GROUP BY employee, date_grp, status
ORDER BY employee, from_date;
-- 5th Solution
WITH cte AS (
    SELECT *, 
           CASE WHEN status = LAG(status, 1, status) OVER (PARTITION BY employee ORDER BY dates) THEN 0 ELSE 1 END AS flag
    FROM emp_attendance
), 
cte2 AS (
    SELECT employee, dates, status, SUM(flag) OVER (PARTITION BY employee ORDER BY dates) AS flag_sum 
    FROM cte
) 
SELECT employee, MIN(dates) AS from_date, MAX(dates) AS to_date, MAX(status) AS status
FROM cte2
GROUP BY employee, flag_sum
ORDER BY employee, from_date;
