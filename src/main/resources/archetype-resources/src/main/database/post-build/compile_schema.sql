DECLARE
    l_compilation_errors   VARCHAR2(32767);
    CURSOR lcu_invalid_objects IS SELECT
        object_type,
        object_name
       FROM user_objects
       WHERE
        status = 'INVALID'
       GROUP BY
        object_type,
        object_name
       ORDER BY
        object_type,
        object_name;
begin
  dbms_output.put_line('Schema Name ' || user);
  dbms_utility.compile_schema(user); 
FOR rec_invalid_object IN lcu_invalid_objects loop 
l_compilation_errors := l_compilation_errors
                        || CHR(10)
                        || ' '
                        || rpad ( rec_invalid_object.object_type, 20 )
                        || rec_invalid_object.object_name; 
end loop;

IF l_compilation_errors IS NOT NULL THEN
    l_compilation_errors := chr(10)
    || chr(10)
    || 'Invalid objects in schema '
    || user
    || ':'
    || l_compilation_errors;

    raise_application_error(-20000, l_compilation_errors || chr(10) );
END IF;

end;