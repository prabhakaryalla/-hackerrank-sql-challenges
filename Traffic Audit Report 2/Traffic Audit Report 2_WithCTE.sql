WITH cteClients (ratio,mac) as 
(
    select cast(ceiling(cast(downstream_rate as float)/cast(upstream_rate as float)) as int) as ratio, mac as ratio from clients
)
select ratio_class = IIF(ratio > 26 ,Concat(Replicate('Z', ratio/26),char(64 + ratio%26)), char(64 + ratio)),
       ratio, 
       mac = STUFF((select ', ' + mac from cteClients a where a.ratio = b.ratio FOR XML PATH('')), 1, 2, '') from cteClients b group by ratio;