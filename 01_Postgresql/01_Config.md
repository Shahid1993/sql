#### Show all DB Config
```sql
show all
```

#### Show active Connections
```sql
select *
from pg_stat_activity
where datname = 'mydatabasename';
```
