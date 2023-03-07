SET NOCOUNT ON;

/*
Enter your query below.
Please append a semicolon ";" at the end of the query
*/
DECLARE @TEMPTABLE TABLE(
   Customer varchar(max),
   Debt Decimal(5,2),
   balance_type varchar(100)
);
INSERT INTO @TEMPTABLE
	SELECT Customer, (Debit-Credit) As Debt, CASE WHEN (Debit-Credit)>=0 THEN 'positive'Else 'negative' END AS balance_type FROM(
	SELECT Customer,Sum(debit) As Debit,Sum(credit) As Credit from transactions
	Where Month(dt)=12
	group by Customer
) As T1 order by Debt desc
SELECT  DISTINCT balance_type,STUFF((SELECT ','+customer from @TEMPTABLE 
where balance_type='positive' order by debt desc FOR XML PATH('')),1,1,'') As Customer FROM @TEMPTABLE
where balance_type='positive'
UNION ALL 
SELECT  DISTINCT balance_type,STUFF((SELECT ','+customer from @TEMPTABLE 
where balance_type='negative' order by debt asc FOR XML PATH('')),1,1,'') As Customer FROM @TEMPTABLE
where balance_type='negative'
go