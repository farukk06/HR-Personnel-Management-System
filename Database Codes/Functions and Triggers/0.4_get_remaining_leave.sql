CREATE OR REPLACE FUNCTION public.fn_get_remaining_leave(emp_id INTEGER)
 RETURNS INTEGER
 LANGUAGE plpgsql
AS $$
DECLARE
    quota INT;
    used_days INT;
BEGIN
    SELECT "AnnualLeaveQuota"
    INTO quota
    FROM "FullTimeEmployee"
    WHERE "EmployeeID" = emp_id;

    SELECT COALESCE(SUM("RequestedDays"), 0)
    INTO used_days
    FROM "LeaveRequest"
    WHERE "EmployeeID" = emp_id
      AND "Status" = 'APPROVED';

    RETURN quota - used_days;
END;
$$;