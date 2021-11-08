/*##################################################################################
## 2) Crear una tabla llamada LOGS, que contenga los campos CODIGO NUMBER,        ##
## DESCRIPCION VARCHAR2(800), FECHA TIMESTAMP, USUARIO VARCHAR2(50), OPERACION    ##
## VARCHAR2(50). Adem�s, crear una secuencia para esta tabla y que se gestione    ##
## la misma a trav�s de un trigger para tener valores autoincrementables en el    ##
## campo c�digo de esta tabla. Luego crear un trigger para la tabla categor�as,   ##
## se debe ejecutar despu�s de un UPDATE en esta tabla, este trigger debe guardar ##
## un registro en la tabla LOGS con la informaci�n de la operaci�n que se realiz�.##
##################################################################################*/

--SOLUCION

--CREACION DE LA TABLA LOGS
CREATE TABLE LOGS(
  CODIGO NUMBER,
  DESCRIPCION VARCHAR2(800), 
  FECHA TIMESTAMP, 
  USUARIO VARCHAR2(50), 
  OPERACION VARCHAR2(50)
);

COMMIT;

--CREACION DE LA SECUENCIA EN LA TABLA LOGS
CREATE SEQUENCE SQ_TABLA_LOGS
START WITH 1 --ESTABLECE EL INICIO DE LA SECUENCIA
INCREMENT BY 1; --ESTABLECE EL VALOR DE INCREMENTO POR 'CICLO' DE LA SECUENCIA.

COMMIT;

--CREACION DEL TRIGGER QUE GESTIONA LOS VALORES AUTOINCREMENTABLES EN EL CAMPO
--CODIGO DE LA TABLA LOGS UTILIZANDO LA SECUENCIA SQ_TABLA_LOGS
CREATE OR REPLACE TRIGGER TS_SQ_TABLA_LOGS
BEFORE INSERT ON LOGS
FOR EACH ROW
DECLARE

BEGIN
  :NEW.CODIGO:=SQ_TABLA_LOGS.NEXTVAL;
END;

COMMIT;

/*#######################################################################
## Creacion del trigger para la tabla categor�as, se ejecutara despu�s ##
## de un UPDATE en esta tabla, este trigger guarda un registro en la   ##
## tabla LOGS con la informaci�n de la operaci�n que se realiz�.       ##
#######################################################################*/
CREATE OR REPLACE TRIGGER TG_CATEGORIAS
AFTER UPDATE ON CATEGORIAS 
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION;--ESTO PERMITE PODER HACER USO DE LAS INSTRUCCIONES COMMIT Y ROLLBACK DENTRO DE UN TRIGGER
BEGIN
  INSERT INTO LOGS (DESCRIPCION, FECHA, USUARIO, OPERACION) VALUES(
    'SE REALIZO UN UPDATE EN LA TABLA CATEGORIAS, EL NOMBRE ANTERIOR DE LA CATEGORIA ES: '||:OLD.NOMBRECAT||
    ' Y EL NUEVO VALOR DEL NOMBRE DE LA CATEGORIA ES: '||:NEW.NOMBRECAT,
    SYSTIMESTAMP,
    USER,
    'OPERACION UPDATE'
  );
  COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
END;

COMMIT;

--BLOQUE ANONIMO PARA LAS PRUEBAS
DECLARE
BEGIN
  --UPDATE CATEGORIAS SET NOMBRECAT='LACTEOS Y DERIVADOS' WHERE NOMBRECAT='LACTEOS';
  UPDATE CATEGORIAS SET NOMBRECAT='CARNICOS (RES, CERDO Y POLLO)' WHERE NOMBRECAT='CARNICOS';
  COMMIT;
END;
