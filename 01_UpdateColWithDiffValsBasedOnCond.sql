UPDATE table_users
    SET cod_user = (case when user_role = 'student' then '622057'
                         when user_role = 'assistant' then '2913659'
                         when user_role = 'admin' then '6160230'
                    end),
        date = '12082014'
    WHERE user_role in ('student', 'assistant', 'admin') AND
          cod_office = '17389551';





update express_address 
set is_default = (case when addr_id = 16 then true else false end),
modified_by = 1411, modified_date = CURRENT_DATE
WHERE customer_id = 1411 and is_active = true and is_deleted = false 
and (addr_id = 16 or is_default = true)
