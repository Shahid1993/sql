update express_address 
set is_default = (case when addr_id = 16 then true else false end),
modified_by = 1411, modified_date = CURRENT_DATE
WHERE customer_id = 1411 and is_active = true and is_deleted = false 
and (addr_id = 16 or is_default = true)
