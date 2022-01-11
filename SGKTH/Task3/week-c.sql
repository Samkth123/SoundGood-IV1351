/*Äselect to_char(current_date, 'W');


 select 'This is ensamble lessons next week ';
 select  extract(year from datum) AS year, count(*), datum, genre, extract(day from datum) AS day
 from ensemble where DATE_PART('week', datum) = (CAST(to_char(current_date, 'W') as INTEGER)+1) 
 group by extract(year from datum), datum, genre, extract(day from datum) order by genre, extract(day from datum);

select id, genre, max_seats,
case 
    when (max_seats - boked) = 0
    then 'no seats left'
    when (max_seats - boked) = 1
    then '1 seat left'
    when(max_seats - boked) = 2
    then '2 seats left'
    else 'many seats left'
    end 
    from ensemble 
    inner join booked_students on ensemble.id = booked_students.ensemble_id
    where DATE_PART('week', datum) = (CAST(to_char(current_date, 'W') as INTEGER)+1)
    order by genre, datum;
*/
REFRESH MATERIALIZED VIEW booked_students;
select id as ensemble_id , datum ,genre,instructor_id,max_seats,extract(dow from datum) as "day of week",
CASE 
WHEN  (max_seats - boked) = 0 
THEN 'full boked'

WHEN  (max_seats - boked) = 1 or (max_seats - boked) = 2 
THEN '1-2 seats left!'

WHEN  (max_seats - boked) > 2
THEN 'Seats left'

END
from ensemble 
inner join booked_students on ensemble.id = booked_students.ensemble_id
where DATE_PART('week', datum) = (CAST(to_char(current_date, 'WW') as INTEGER)+1)
order by genre, extract(dow from datum);

/*

insert into ensemble (id, level, genre, instructor_id, datum, max_seats) values ('3363', 'Advanced', 'gospel band', '9367', '2021-03-07','1');
insert into ensemble (id, level, genre, instructor_id, datum, max_seats) values ('0126', 'Beginner', 'punk rock', '9367', '2022-01-13','2');
insert into ensemble (id, level, genre, instructor_id, datum, max_seats) values ('6590', 'Intermediate', 'punk rock', '9367', '2021-05-07','5');

insert into ensemble_students(student_id, ensemble_id) values ('7491','0126');
insert into ensemble_students(student_id, ensemble_id) values ('8631','3363');
insert into ensemble_students(student_id, ensemble_id) values ('8631','6590');


*/
/*CASE
    WHEN select count(*) from ensemble_students where = max_seats  THEN raise notice 'full'*/


 /*extract(year from datum) = extract(year from NOW()) and*/

 /*
 List all ensembles held during the next week, sorted by music genre and weekday. 
 For each ensemble tell whether it's full booked, has 1-2 seats left or has more seats left. 
 Hint: you might want to use a CASE statement in your query to produce the desired output.
 */