CREATE OR REPLACE FUNCTION public.fn_calculate_net_salary(base_salary REAL, bonus REAL)
 RETURNS REAL
 LANGUAGE plpgsql
AS $$
BEGIN
    RETURN base_salary + bonus;
END;
$$;