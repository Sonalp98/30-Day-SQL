CREATE TABLE emp_salary
(
    emp_id INTEGER  NOT NULL,
    name NVARCHAR(20)  NOT NULL,
    salary NVARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');
-- same salary in dept
select dept_id,count(*) as same_salary from(select *, dense_rank() over(partition by dept_id order by salary) as rn from emp_salary) s
group by dept_id,rn
having count(rn) >1;
-- if you want names too
select emp_id,name,salary,dept_id from(select *, lead(salary) over(partition by dept_id order by salary) as nxt ,
lag(salary) over(partition by dept_id order by salary) as pre 
from emp_salary
)s
where salary-nxt =0 or salary= pre;

-- best method 
with cte as(select dept_id,salary from emp_salary e1
group by dept_id,salary
having count(*) >1)
select es.*
from emp_salary es
inner join cte on
es.dept_id = cte.dept_id and es.salary=cte.salary
order by dept_id