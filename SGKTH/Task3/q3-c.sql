select instructor_id ,extract(month from datum) as month, extract(year from datum) as year,count(*)
from lestot where extract(month from datum) = extract(month from current_date) 
and extract(year from datum) = extract(year from current_date) group by instructor_id, extract(month from datum), extract(year from datum) 
having count(*) >= 1 order by count(*);


 -- Räcker det med en average som inkluderar alla lektioner??