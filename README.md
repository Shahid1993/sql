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
  
- #### [PosgreSQL Recursive Query](http://www.postgresqltutorial.com/postgresql-recursive-query/)
         [What is the equivalent PostgreSQL syntax to Oracle's CONNECT BY … START WITH?](https://stackoverflow.com/questions/24898681/what-is-the-equivalent-postgresql-syntax-to-oracles-connect-by-start-with)
    ```sql
                    WITH base as(								   
											WITH RECURSIVE parents AS (
												SELECT f3.file_id, f3.parent_file_id, name
												FROM file f3
												WHERE f3.file_id = f.file_id
												UNION
												SELECT f4.file_id, f4.parent_file_id, f4.name
												FROM file f4
												INNER JOIN parents p ON f4.file_id = p.parent_file_id
											) SELECT * FROM parents order by file_id limit ((select count(*) from parents) - 1)
										) SELECT ARRAY[string_agg(file_id::text, ''/''), string_agg(name, ''/'')]  FROM base
     ```
- #### [Concatenate multiple result rows of one column into one](https://stackoverflow.com/questions/15847173/concatenate-multiple-result-rows-of-one-column-into-one-group-by-another-column)
  Simpler with the aggregate function [`string_agg()`](https://www.postgresql.org/docs/current/functions-aggregate.html) (Postgres 9.0 or later):
  ```sql
  SELECT movie, string_agg(actor, ', ') AS actor_list
  FROM   tbl
  ```
  
     
     

