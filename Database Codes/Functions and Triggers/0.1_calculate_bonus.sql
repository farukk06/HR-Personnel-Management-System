CREATE OR REPLACE FUNCTION public.fn_calculate_bonus(base_salary REAL)
 RETURNS REAL
 LANGUAGE plpgsql
AS $$
BEGIN
    RETURN base_salary * 0.10;
END;
$$;