# sql_learning
Code Snippets for sql/postgresql


#### [LIMIT with a conditional Statement](https://stackoverflow.com/questions/51022146/how-to-set-limit-within-a-conditional-statement-postgresql)
```sql
ORDER BY id DESC
LIMIT CASE WHEN @condition THEN 1 END;
```
`LIMIT NULL` is the same as omitting the LIMIT clause
