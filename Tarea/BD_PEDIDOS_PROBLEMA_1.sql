/*############################################################################################
## 1) Hacer uso de un bloque an�nimo para insertar dos (2) registros en la tabla productos. ##
## En caso de que se produzca un error de llave primaria duplicada o de llave for�nea       ##
## inexistente, se deben gestionar estos errores mediante el bloque de excepciones. En caso ##
## de que no haya error, se deben aprobar los cambios y si hay error entonces se deben      ##
## deshacer todos los cambios. Utilizar el c�digo -2291 para controlar el error de llave    ##
## for�nea inexistente.                                                                     ##
############################################################################################*/

--SOLUCION--

DECLARE
  MSJ_ERROR VARCHAR2(1000);
  CODIGO_ERROR NUMBER;
BEGIN 
  --CORRECTOS
  INSERT INTO PRODUCTOS VALUES (14,60,100,'PECHUGA DE RES',22.3,200);
  INSERT INTO PRODUCTOS VALUES (15,60,100,'PECHUGA DE CERDO',20.3,150);
  --INSERT INTO PRODUCTOS VALUES (16,60,100,'PIERNAS DE CERDO',20.3,150);
  --INSERT INTO PRODUCTOS VALUES (17,60,100,'PIERNAS DE POLL',20.3,150);

  --INCORRECTOS
  --ERROR DE LLAVE PRIMARIA, SE ESTA INGRESANDO UN VALOR DUPLICADO
  --INSERT INTO PRODUCTOS VALUES (1,60,100,'PECHUGA DE RES',22.3,200);
  --ERROR DE LLAVE FORANEA, SE ESTA INGRESANDO UN VALOR INEXISTENTE EN LA TABLA PROVEEDORES (1)
  --INSERT INTO PRODUCTOS VALUES (18,1,100,'PECHUGA DE RES',22.3,200);
  COMMIT;--SE APRUEBAN TODOS LOS CAMBIOS
  
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX  THEN
      CODIGO_ERROR:=SQLCODE;
      MSJ_ERROR:=SQLERRM;
      DBMS_OUTPUT.PUT_LINE('ERROR DE LLAVE PRIVARIA VALOR DUPLICADO');
      DBMS_OUTPUT.PUT_LINE('EL CODIGO DE ERROR ES: '||CODIGO_ERROR); 
      DBMS_OUTPUT.PUT_LINE('EL MENSAJE DE ERROR ES: '||MSJ_ERROR);
      ROLLBACK; -- SE DESHACEN TODOS LOS CAMBIOS.
      
    WHEN OTHERS THEN
      CODIGO_ERROR:=SQLCODE;
      MSJ_ERROR:=SQLERRM;
      
      IF(SQLCODE=-2291) THEN
        DBMS_OUTPUT.PUT_LINE('VALOR DE LLAVE FORANEA INEXISTENTE.');
      END IF;
      
      DBMS_OUTPUT.PUT_LINE('EL CODIGO DE ERROR ES: '||CODIGO_ERROR); 
      DBMS_OUTPUT.PUT_LINE('EL MENSAJE DE ERROR ES: '||MSJ_ERROR);
      ROLLBACK; -- SE DESHACEN TODOS LOS CAMBIOS.
END;


SET SERVEROUTPUT ON; --SE HABILITA LA SALIDA DE DATOS ESTANDAR
