drop table events;
CREATE TABLE events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

delete from events;

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');
select * from events;
-- no of gold medals per swimmer for swimmer who won only gold medal
-- can't use where medal_type not in ('Silver','Bronze') as it removes silver & bronze medals
-- but doesn't exclude player who has won gold plus these medals also 
-- A player who has won bronze and gold can still be there(Although only count for his gold will be taken)
-- we need to remove the player_name to work--in second query
with cte as(select gold as player_name, 'gold' as medal_type
from events
union all
select silver as player_name, 'silver' as medal_type
from events
union all
select bronze as player_name, 'bronze' as medal_type
from events)
select player_name, count(*) as no_of_gold_medals
from cte
group by player_name
having count(distinct medal_type) ='1' and max(medal_type)='gold';
-- if we use where medal_type ='gold' then it will take only gold ones & doesn't exclude player who have more than one medal 
--  having will be executed after where in sql
-- so count of medal type will be 1 i.e gold which is true
select gold as player_name, count(*) as no_of_medals
from events
where gold not in( select silver from events union all select bronze from events)
group by gold
