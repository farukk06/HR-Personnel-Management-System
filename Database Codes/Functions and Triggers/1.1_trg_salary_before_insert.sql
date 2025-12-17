CREATE OR REPLACE FUNCTION public.trg_salary_before_insert()
 RETURNS TRIGGER
 LANGUAGE plpgsql
AS $$
BEGIN
    NEW."BonusAmount" :=
        fn_calculate_bonus(NEW."BaseSalary");

    NEW."NetSalary" :=
        fn_calculate_net_salary(
            NEW."BaseSalary",
            NEW."BonusAmount"
        );

    RETURN NEW;
END;
$$;