SET SERVEROUTPUT ON;

--Firma

create or replace package PKG_JOBS as
/*
    Un procedimiento Alta_Job para insertar un nuevo cargo en la tabla JOBS
*/

    procedure Alta_Job 
    (
        p_job_id jobs.job_id%TYPE,
        p_job_title jobs.job_title%TYPE,
        p_min_salary jobs.min_salary%TYPE,
        p_max_salary jobs.max_salary%TYPE
    );
    
/*
    Un procedimiento Upd_Job para actualizar los salarios minimos 
    y maximos de los cargos
*/

    procedure Upd_Job 
    (
        p_job_id jobs.job_id%TYPE,
        p_min_salary jobs.min_salary%TYPE,
        p_max_salary jobs.max_salary%TYPE
    );
    
/*
    Un procedimiento Lista_job que recibe mediante un parámetro el 
    código de un cargo e informe el nombre y apellido de todos los
    empleados que lo poseen
*/

    procedure Lista_job (p_job_id jobs.job_id%TYPE);
    
end;

--Cuerpo

create or replace package body PKG_JOBS as

/*
    Un procedimiento Alta_Job para insertar un nuevo cargo en la tabla JOBS: 
    
        a. Se deben pasar todos los parametros necesarios para completar el 
           registro de la tabla.
    
        b. El nombre del cargo debe estár en mayúsculas.
    
        c. El código del cargo no puede repetirse. En ese caso, tratarlo con la 
           excepción DUP_VAL_ON_INDEX.
*/

    procedure Alta_Job 
    (
        p_job_id jobs.job_id%TYPE,
        p_job_title jobs.job_title%TYPE,
        p_min_salary jobs.min_salary%TYPE,
        p_max_salary jobs.max_salary%TYPE
    ) is
    begin
            insert into jobs
                (job_id, job_title, min_salary, max_salary)
            values
                (UPPER(p_job_id), INITCAP(p_job_title), p_min_salary, p_max_salary);
            exception
                when DUP_VAL_ON_INDEX then
                    dbms_output.put_line('Erro en Alta_Job, el id ' || p_job_id || ' ya existe');
    end;

/*
    Un procedimiento Upd_Job para actualizar los salarios minimos y maximos
    de los cargos:
    
        a. Informar el job_id y nuevo salario minimo y maximo.
        
        b. Si el job_id no existe, informar mediante un mensaje y cancelar 
           el procedimiento.
        
        c. Debera validarse que el salario maximo sea mayor al minimo.
*/

    procedure Upd_Job 
    (
        p_job_id jobs.job_id%TYPE,
        p_min_salary jobs.min_salary%TYPE,
        p_max_salary jobs.max_salary%TYPE
    ) is
        e_sal_mim_max exception;
        v_id jobs.job_id%TYPE;
    begin
        
        select job_id 
            into v_id
        from jobs
        where job_id = UPPER(p_job_id);
        
        if p_min_salary > p_max_salary then
            raise e_sal_mim_max;
        end if;
        
        update jobs
        set
            min_salary = p_min_salary,
            max_salary = p_max_salary
        where
            job_id = UPPER(p_job_id);
            
        dbms_output.put_line('ID: ' || p_job_id);
        dbms_output.put_line('Salario minimo: ' || p_min_salary);
        dbms_output.put_line('Salario maximo: ' || p_max_salary);
        
        exception
            WHEN no_data_found THEN
                dbms_output.put_line('Error en Upd_Job, el ID '
                                     || p_job_id ||' no existe');
            when e_sal_mim_max then
                dbms_output.put_line('Error en Upd_Job, el salario minimo ' || p_min_salary 
                                      || ' es mayor al maximo ' || p_max_salary); 
    end;

/*
    Un procedimiento Lista_job que recibe mediante un parámetro el código 
    de un cargo e informe el nombre y apellido de todos los empleados 
    que lo poseen. 

    a. Contemplar todos los siguientes errores posibles.
    
    b. El código no corresponde a un cargo.
    
    c. No hay empleados en el cargo
*/
    procedure Lista_job (p_job_id jobs.job_id%TYPE) is
        cont number :=0;
        cursor c_full_name (v_job_id jobs.job_id%TYPE) is
            select first_name, last_name from employees
            where job_id like UPPER(v_job_id); 
    begin
        select 0
            into cont
        from jobs
        where job_id = p_job_id;
    
         for reg in c_full_name (p_job_id ) loop
            dbms_output.put_line('-----------------------------------');
            dbms_output.put_line('Nombre: ' || reg.first_name);
            dbms_output.put_line('Apellido: ' || reg.last_name);
            dbms_output.put_line(' ');
            cont := cont + 1;
         end loop;
         
         if cont = 0 then
            raise_application_error(-20001,'Error en Lista_job, no existen empleados en el cargo');
         end if;
         
        exception
            when no_data_found then
                dbms_output.put_line('Error en Lista_job, el id ' || p_job_id || ' No existe');  
    end;

end PKG_JOBS;


--PUNTO 2   

/*
    2. Generar un trigger llamado valida_emp_job_sal que realice 
       una validacion por la cual, cuando se de el alta a un nuevo 
       empleado, su salario debera estar en el rango permitido por 
       el maximo y minimo definido para el cargo.
*/

create or replace trigger valida_emp_job_sal
after insert on employees
for each row
declare 
    v_sal_min number;
    v_sal_max number;
begin
    select min_salary, max_salary 
        into v_sal_min, v_sal_max
    from jobs
    where job_id = :new.job_id;
    
    if :new.salary not between v_sal_min and v_sal_max then
        ---No ejecutar el insert
        raise_application_error(-20001,'Error, el salario se encuentra fuera del rango establecido');
    end if;
    
end;



