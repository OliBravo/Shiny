create or replace function bytea_import(p_path text, p_result out bytea) 
                   language plpgsql as $$
declare
  l_oid oid;
begin
  select lo_import(p_path) into l_oid;
  select lo_get(l_oid) INTO p_result;
  perform lo_unlink(l_oid);
end;$$;



insert into users (first_name, last_name, email, avatar) values (
	'John', 'Deere', 'john.deere@company.com',
	bytea_import('C:\Users\jakub.malecki\Documents\_Repos\___PRIV\my_apps\shiny\Project_management\PostgreSQL\Male_avatar.jpg')
);