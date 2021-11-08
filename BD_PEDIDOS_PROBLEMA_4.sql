4) Suponiendo que tenemos una tabla llamada EMP, en la cual existen tres campos:
nombreEmp VARCHAR2(100), direccionEmp VARCHAR2(255), telefonoEmp
NUMBER(15), identidad NUMBER(15) y que se tiene la siguiente declaración de
variables:


CREATE TABLE EMP(
  nombreEmp VARCHAR2(100),
  direccionEmp VARCHAR2(255),
  telefonoEmp NUMBER(15),
  identidad NUMBER(15)
);

insert into emp values ('primer ejemplo', 'calle 1',12345,1);
commit;
insert into emp values ('primer ejemplo', 'calle 1',12345,2);
commit;

DECLARE
  var1 emp%ROWTYPE; --forma correcta
  --va2 emp.nombre%TYPE; --ERROR: no se puede ya que en la tabla EMP no existe un campo llamado nombre, el que existe es nombreEmp.
  var2 emp.nombreEmp%TYPE;--forma correcta
  var3 emp%ROWTYPE; --forma correcta
  CURSOR cEmp IS SELECT nombreEmp, direccionEmp, telefonoEmp, identidad FROM EMP;--forma correcta
  REGISTRO cEmp%ROWTYPE; 
  CURSOR cNomTelEmp IS SELECT nombreEmp, telefonoEmp FROM EMP;--forma correcta
  var4 cEmp%ROWTYPE; --forma correcta
  --var5 emp.telefono%TYPE;--ERROR: no es correcto ya que en la tabla EMP no existe un campo llamado telefono, el que existe es telefonoEmp.
  var5 emp.telefonoEmp%TYPE;--forma correcta
  var6 cNomTelEmp%ROWTYPE;
begin
  select nombreemp, direccionemp, telefonoemp, identidad into var1 from emp where emp.identidad=1;
  select nombreemp, direccionemp, telefonoemp, identidad into var3 from emp where emp.identidad=1;
  
  --la comparacion de var1 = var 3 no se puede hacer ya que el simpolo igual solo puede comparar entre dos elementos
  --a la vez y en la forma que esta variables se declararon son como un arreglo que internamente tienen las variables
  --de la tabla emp. entonces no se pueden comparar de esta manera todos estos registros a pesar de que sepamos que
  --si son iguales todos sus registros, lo que se puede hacer comparando uno a uno o usando otra duncion de PL-SQL
  --una posible forma correcta
  
  if (var1.identidad = var3.identidad ) then
    DBMS_OUTPUT.PUT_LINE('SE CUMPLE LA IGUALDAD DE QUE VAR1 ES IGUAL A VAR3');
  end if;
  
  --var1:=var3;
  --var4:=var1;
  SELECT identidad INTO var5 FROM EMP where emp.identidad=2;
  DBMS_OUTPUT.PUT_LINE('slect identidad into var5 from emp: '||var5);
  --var3:= var6;
  var2:='Luis Escoto 1';
  --var2:=Luis;
  DBMS_OUTPUT.PUT_LINE('var2: '||var2);
  /*DBMS_OUTPUT.PUT_LINE('EL NOMBRE DEL PRODUCTO ES: '|| var1.identidad);
  
  open cEmp;
    LOOP
      FETCH cEmp INTO REGISTRO;
      EXIT WHEN cEmp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('EL NOMBRE ES: '||REGISTRO.NOMBREEMP);
        DBMS_OUTPUT.PUT_LINE('LA DIRECCION ES: '||REGISTRO.DIRECCIONEMP);
        DBMS_OUTPUT.PUT_LINE('EL TELEFONO ES: '||REGISTRO.TELEFONOEMP);
        DBMS_OUTPUT.PUT_LINE('LA IDENTIDAD ES: '||REGISTRO.IDENTIDAD);
    END LOOP;
  close cEmp;
  */
end;

SET SERVEROUTPUT ON;

¿Serían correctas las siguientes asignaciones?
  var1:=var3; -- en una sentencia if no se puede, pero compararlas de esta manera si, ya que no se generaria ningun error.
  var4:=var1; -- en una sentencia if no se puede, pero compararlas de esta manera si, ya que no se generaria ningun error.
  SELECT identidad INTO var5 FROM EMP;-- no es correcto. 
  --   no se puede porque se generaria un error por dos razones
  --1. la variable var5 esta mal declarada porque esta copiando el formato de un registro que no existe (telefono)
  --si corregimos la declaracion de esta variable, nos encontramos con el segundo error.
  --2. la instruccion select al no tener una condicion where nos estaria retornando mas de un registro,
  --   en si todos los registros que esten guardados, entonces en la forma que se declaro la variable var5
  --   esta solo puede almacenar un registro a la vez. 
  --entonces por estas dos razones esto no es correcto de hacer.
  var3:= var6;--no es correcto
  --Porque la variable var3 al copiar la estructura de la tabla EMP, esta compuesta
  --por 4 elementos (nombreEmp, direccionEmp, telefonoEmp, identidad), miestras que la variable var6 solo esta compuesta
  --por 2 elementos (nombreEmp, telefonoEmp).
  var2:=Luis Escoto 1-- no es correcto hacerlo porque tiene errores de sintaxis
  --1 le falta el ;
  --2 cuando se declaro se le puso como nombre va2 y no var2
  --3 cuando se declaro copio el formato de un elemento que no existe en la tambla EMP
  --el cual debio ser nombreEmp y no nombre.

