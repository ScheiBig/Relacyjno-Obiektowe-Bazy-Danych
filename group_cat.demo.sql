with data_table as (
	select 1 as id, '01' as segment from dual
	union all
	select 1 as id, '03' as segment from dual
	union all
	select 2 as id, '01' as segment from dual
	union all
	select 2 as id, '02' as segment from dual
	union all
	select 3 as id, '01' as segment from dual
	union all
	select 3 as id, '03' as segment from dual
	union all
	select 3 as id, '08' as segment from dual
	union all
	select 4 as id, '04' as segment from dual
)
select
	id
	, group_cat( with_separator( segment, '//' )) as segmenty
from data_table
group by id
;

--       RESULT       --
--
--     ID    SEGMENTY
--     --    --------
--      1    01//03
--      2    01//02
--      3    01//03//08
--      4    04
