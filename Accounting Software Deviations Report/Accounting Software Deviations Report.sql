With cteTransactions (customer, netborrowing, balance_type)
as 
(
select customer, (sum(debit)  - sum(credit)) as netborrworing, IIf((sum(debit)  - sum(credit))> 0, 'positive', 'negative') as balance_type  
from transactions where  MONTH(dt) = 12
group by customer  
)
select balance_type, STUFF((select  ',' + customer from cteTransactions b where b.balance_type = a.balance_type order by b.netborrowing desc For XML Path('')), 1, 1, '') as customer    
from cteTransactions a
group by balance_type order by balance_type desc
go



