# sql_learning
Code Snippets for sql/postgresql


- #### [LIMIT with a conditional Statement](https://stackoverflow.com/questions/51022146/how-to-set-limit-within-a-conditional-statement-postgresql)
  ```sql
  ORDER BY id DESC
  LIMIT CASE WHEN @condition THEN 1 END;
  ```
  `LIMIT NULL` is the same as omitting the LIMIT clause
  
- #### [Select first row in each GROUP BY group?](https://stackoverflow.com/questions/3800551/select-first-row-in-each-group-by-group)
  ```sql
  SELECT DISTINCT ON (customer)
        id, customer, total
  FROM   purchases
  ORDER  BY customer, total DESC, id;
  ```
  Or shorter (if not as clear) with ordinal numbers of output columns:
  ```sql
  SELECT DISTINCT ON (2)
         id, customer, total
  FROM   purchases
  ORDER  BY 2, 3 DESC, 1;
  ```
  If `total` can be NULL (won't hurt either way, but you'll want to match existing indexes):
  ```sql
    ...
  ORDER  BY customer, total DESC NULLS LAST, id;
  ```

