
create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);
delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000);
select * from employee;
-- max and min salary in each dept
with cte as(select dep_id,max(salary) as max,min(salary)  as min
from employee
group by dep_id)
select e.dep_id,
max(case when salary = max then emp_name else null end) as max_emp,
max(case when salary = min then emp_name else null end) as min_emp
from employee e
join cte on
e.dep_id= cte.dep_id
group by e.dep_id;
--
with cte as(select *,row_number() over(partition by dep_id order by salary desc) as desc_rn,
row_number() over(partition by dep_id order by salary ) as asc_rn
from employee
)
select dep_id,
max(case when desc_rn = 1 then emp_name else null end) as max_emp,
max(case when asc_rn = 1 then emp_name else null end) as min_emp
from cte 
group by dep_id