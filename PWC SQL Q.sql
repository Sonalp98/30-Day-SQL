create table source(id int, name varchar(5));

create table target(id int, name varchar(5));

insert into source values(1,'A'),(2,'B'),(3,'C'),(4,'D');

insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');
select * from target;
select * from source;
with cte as (select *  from source s
left join target t
on s.id=t.id
union all
select * from source s
right join target t
on s.id=t.id),
cte2 as(select *
from cte
where name <> name2 or name is null or name2 is null)
select distinct id, case when name is null then 'New in target'
               when name2 is null then 'New in source' else 'mismatch'
               end as comment from cte2;
with cte as (select  s.name,s.id,t.id as id2 ,t.name as name2 from source s
left join target t
on s.id=t.id
union all
select  s.name,s.id,t.id as id2 ,t.name as name2 from source s
right join target t
on s.id=t.id),
cte2 as
(select name,id,id2 ,name2
from cte
where name <> name2 or name is null or name2 is null)
select distinct coalesce( id,id2) as id, case when name is null then 'New in target'
               when name2 is null then 'New in source' else 'mismatch'
               end as comment from cte2;
               ----
               -- Full outer join not present in MYSQL
with cte as(select s.*,t.name as name2 ,t.id as id2 from source s
left join target t
on s.id=t.id
where s.name <> t.name or s.name is null or t.name is null
union all
select s.*,t.name as name2 ,t.id as id2 from source s
right join target t
on s.id=t.id
where s.name<>t.name or s.name is null or t.name is null)
select coalesce(id,id2) as id, name ,name2, -- coalesce is to merge them in one
case when name is null then 'New in Target'
     when name2 is null then 'New in Source'
     when name<> name2 then 'mismatch'
     end as comment
     from cte