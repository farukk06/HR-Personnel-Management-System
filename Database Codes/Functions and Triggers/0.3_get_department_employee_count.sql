CREATE OR REPLACE FUNCTION public.fn_get_department_employee_count(dept_id INTEGER)
 RETURNS INTEGER
 LANGUAGE plpgsql
AS $$
DECLARE 
    dept_exists INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO dept_exists
    FROM "Department"
    WHERE "DepartmentID" = dept_id;
    
    IF dept_exists = 0 THEN
        RAISE EXCEPTION 'Invalid Department ID: %',dept_id;
    END IF;
    
    RETURN (
        SELECT COUNT(*)
        FROM "Employee"
        WHERE "DepartmentID" = dept_id
    );
END;
$$;