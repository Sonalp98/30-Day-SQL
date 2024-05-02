drop table icc_world_cup
create table icc_world_cup
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup values(1,'ENG','NZ','NZ');
INSERT INTO icc_world_cup values(2,'PAK','NED','PAK');
INSERT INTO icc_world_cup values(3,'AFG','BAN','BAN');
INSERT INTO icc_world_cup values(4,'SA','SL','SA');
INSERT INTO icc_world_cup values(5,'AUS','IND','IND');
INSERT INTO icc_world_cup values(6,'NZ','NED','NZ');
INSERT INTO icc_world_cup values(7,'ENG','BAN','ENG');
INSERT INTO icc_world_cup values(8,'SL','PAK','PAK');
INSERT INTO icc_world_cup values(9,'AFG','IND','IND');
INSERT INTO icc_world_cup values(10,'SA','AUS','SA');
INSERT INTO icc_world_cup values(11,'BAN','NZ','NZ');
INSERT INTO icc_world_cup values(12,'PAK','IND','IND');
-- INSERT INTO icc_world_cup values(12,'SA','IND','DRAW');
select * from icc_world_cup;

select distinct team, sum(no_of_matches_palyed) as matches, sum(win) as wins,sum(loss) as loss from(select team_1 as team, count(*) as no_of_matches_palyed, 
sum( case when team_1= winner then 1 else 0 end) as win,
sum( case when team_2= winner then 1 else 0 end) as loss from icc_world_cup group by team_1
union all select team_2 as team, count(*) as no_of_matches_palyed,
sum( case when team_2= winner then 1 else 0 end) as win,
sum( case when team_1= winner then 1 else 0 end) as loss from icc_world_cup group by team_2) s
group by team;

with cte as(select distinct team, sum(no_of_matches_palyed) as matches_played from(
select team_1 as team, count(*) as no_of_matches_palyed
from icc_world_cup group by team_1
union all select team_2 as team, count(*) as no_of_matches_palyed
from icc_world_cup group by team_2 ) s
group by team),
winner as(
select winner, count(winner) as wins from icc_world_cup group by winner)
select c.*, coalesce(w.wins,0) as wins, matches_played- coalesce(w.wins,0) as loss ,coalesce(w.wins,0)*2 as points 
from cte c
left join winner w
on c.team = w.winner;

-- My solution 
with cte as(select team_1 as team, count(*) as no_of_matches_palyed, 
sum( case when team_1= winner then 1 else 0 end) as win,
sum( case when team_2= winner then 1 else 0 end) as loss from icc_world_cup group by team_1
union all select team_2 as team, count(*) as no_of_matches_palyed,
sum( case when team_2= winner then 1 else 0 end) as win,
sum( case when team_1= winner then 1 else 0 end) as loss from icc_world_cup group by team_2) 
select distinct team, sum(no_of_matches_palyed) as matches, sum(win) as wins,sum(loss) as loss from cte
group by team;
-- insert draw on for next question
delete from icc_world_cup
where winner ='draw';
set sql_safe_updates = 0;
