CREATE OR REPLACE FUNCTION public.trg_leave_quota_check()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."RequestedDays" >
       fn_get_remaining_leave(NEW."EmployeeID") THEN
        RAISE EXCEPTION 'Leave quota exceeded';
    END IF;

    RETURN NEW;
END;
$$;