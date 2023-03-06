DECLARE @TEMPTABLE TABLE(
   ratio int,
   mac varchar(64)
);
insert into @TEMPTABLE
select ceiling(cast(downstream_rate as float)/cast(upstream_rate as float)) as ratio, mac as ratio from clients;
select 
       IIF(ratio > 26 ,Concat(Replicate('Z', ratio/26),char(64 + ratio%26)), char(64 + ratio)) as ratio_class,
	   ratio,
	   mac = 
       STUFF((SELECT ',' + mac
           FROM @TEMPTABLE b 
           WHERE b.ratio = a.ratio
		   order by b.ratio, mac asc
          FOR XML PATH('')), 1, 1, '')
from @TEMPTABLE a
group by ratio;