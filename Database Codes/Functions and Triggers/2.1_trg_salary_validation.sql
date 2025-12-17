CREATE OR REPLACE FUNCTION public.trg_salary_validation()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW."BaseSalary" < 0 THEN
        RAISE EXCEPTION 'Base salary cannot be negative';
    END IF;

    RETURN NEW;
END;
$$;