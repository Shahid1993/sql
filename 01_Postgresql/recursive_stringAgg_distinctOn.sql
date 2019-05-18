-- FUNCTION: public.file_search(integer, integer, text, integer, integer)

-- DROP FUNCTION public.file_search(integer, integer, text, integer, integer);

CREATE OR REPLACE FUNCTION public.file_search(
	userid integer,
	companyid integer,
	search_text text,
	offset_val integer,
	limit_val integer)
    RETURNS TABLE(total_count integer, file_id bigint, file_name character varying, is_archived boolean, folder_id integer, prev_folder_id integer, modified_date text, service_id integer, task_id integer, project_details_id integer, project_id integer, acronym_name character varying, project_name character varying, service_name text, status character varying, is_active boolean, company_id integer, project_category_type_id integer, created_by integer, path text[]) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$ DECLARE uzone text; 
Begin 
	select time_zone_name from time_zone  tz left join users us on us.time_zone_id = tz.id where tz.is_active=true 
	and us.user_id = userid into uzone; 
	
	if exists(select rights_permission from rights r left join role_rights_mapping rrm on rrm.rights_id=r.rights_id 
			  join users u on u.role_id=rrm.role_id and u.user_id=userid  where lower(rights_name)='view_all_project' 
			  and coalesce(rights_permission,false) = true) then
			  return query execute('with file_list as(select distinct on (task_id) f.file_id, f.name file_name, f.is_archived, 
								   f.parent_file_id folder_id,(select f2.parent_file_id from file f2 
								   where f2.file_id = f.parent_file_id) prev_folder_id, 
								   coalesce(nullif(to_char(f.modified_date,''DD-MM-YYYY''),''''),to_char(f.created_date,''DD-MM-YYYY'')),
								   tm.id service_id, tm.task_id, pd.project_details_id, p.project_id, p.acronym_name, p.project_name, 
								   s.service_name, p.status , p.is_active, p.company_id , p.project_category_type_id , p.created_by,
								   (WITH base as(								   
											WITH RECURSIVE parents AS (
												SELECT f3.file_id, f3.parent_file_id, name
												FROM file f3
												WHERE f3.file_id = f.file_id
												UNION
												SELECT f4.file_id, f4.parent_file_id, f4.name
												FROM file f4
												INNER JOIN parents p ON f4.file_id = p.parent_file_id
											) SELECT * FROM parents order by file_id
										) SELECT ARRAY[string_agg(file_id::text, ''/''), string_agg(name, ''/'')]  FROM base
									) path
								   from file f, file_mapping fm, task_mapping tm, service s, project_details pd, project p
								   left join project_team pt on pt.project_id=p.project_id and pt.user_id= '||userid||' 
								   and pt.is_active=true left join role r on r.role_id=pt.role_id where  f.name ~* '''||search_text||''' 
								   and fm.file_id = f.file_id and tm.task_id = fm.id and s.service_id = tm.id 
								   and pd.project_details_id = tm.project_details_id and p.project_id = pd.project_id 
								   and p.company_id = '||companyId||' order by task_id, file_id asc)
								   select count(*) OVER()::integer, fl.* from file_list fl OFFSET '||offset_val||' LIMIT CASE WHEN '||limit_val||' != 0 THEN '||limit_val||' END ');
	else return query  execute('with file_list as(select distinct on (task_id) f.file_id, f.name file_name, f.is_archived, 
								   f.parent_file_id folder_id,(select f2.parent_file_id from file f2 
								   where f2.file_id = f.parent_file_id) prev_folder_id, 
								   coalesce(nullif(to_char(f.modified_date,''DD-MM-YYYY''),''''),to_char(f.created_date,''DD-MM-YYYY'')),
								   tm.id service_id, tm.task_id, pd.project_details_id, p.project_id, p.acronym_name, p.project_name, 
								   s.service_name, p.status , p.is_active, p.company_id , p.project_category_type_id , p.created_by,
								   (WITH base as(								   
											WITH RECURSIVE parents AS (
												SELECT f3.file_id, f3.parent_file_id, name
												FROM file f3
												WHERE f3.file_id = f.file_id
												UNION
												SELECT f4.file_id, f4.parent_file_id, f4.name
												FROM file f4
												INNER JOIN parents p ON f4.file_id = p.parent_file_id
											) SELECT * FROM parents order by file_id
										) SELECT ARRAY[string_agg(file_id::text, ''/''), string_agg(name, ''/'')]  FROM base
									) path
								   from file f, file_mapping fm, task_mapping tm, service s, project_details pd, project p
								   join project_team pt on pt.project_id=p.project_id and pt.user_id= '||userid||'
								   and pt.is_active=true join role r on r.role_id=pt.role_id where  f.name ~* '''||search_text||''' 
								   and fm.file_id = f.file_id and tm.task_id = fm.id and s.service_id = tm.id 
								   and pd.project_details_id = tm.project_details_id and p.project_id = pd.project_id 
								   and p.company_id = '||companyId||' order by task_id, file_id asc)
								   select count(*) OVER()::integer, fl.* from file_list fl OFFSET '||offset_val||' LIMIT CASE WHEN '||limit_val||' != 0 THEN '||limit_val||' END ');
 	end if;   
end $BODY$;

ALTER FUNCTION public.file_search(integer, integer, text, integer, integer)
    OWNER TO cw;

GRANT EXECUTE ON FUNCTION public.file_search(integer, integer, text, integer, integer) TO cw WITH GRANT OPTION;

GRANT EXECUTE ON FUNCTION public.file_search(integer, integer, text, integer, integer) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public.file_search(integer, integer, text, integer, integer) TO postgres;

