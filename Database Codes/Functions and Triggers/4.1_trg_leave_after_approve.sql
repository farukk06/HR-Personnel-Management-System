CREATE OR REPLACE FUNCTION public.trg_leave_after_approve()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."Status" = 'APPROVED'
       AND OLD."Status" <> 'APPROVED' THEN NULL;
    END IF;

    RETURN NEW;
END;
$$;