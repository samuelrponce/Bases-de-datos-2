/*####################################################################################### 
## 3) Crear un trigger para la tabla PROVEEDORES, se debe ejecutar después de un       ##
## INSERT o un UPDATE o un DELETE en esta tabla, este trigger debe guardar un registro ##
## en la tabla LOGS con la información de la operación que se realizó. Además, se debe ##
## controlar cualquier error que pueda suceder y en caso de error se debe insertar un  ##
## registro en la tabla LOGS con la información del error. El trigger es el que debe   ##
## aprobar o deshacer los cambios                                                      ##
#######################################################################################*/

--SOLUCION
CREATE OR REPLACE TRIGGER TG_PROVEEDORES
AFTER INSERT OR UPDATE OR DELETE ON PROVEEDORES
FOR EACH ROW
DECLARE
  PRAGMA AUTONOMOUS_TRANSACTION; --ESTO PERMITE PODER HACER USO DE LAS INSTRUCCIONES COMMIT Y ROLLBACK DENTRO DE UN TRIGGER
  MSJ_ERROR VARCHAR2(1000);
  CODIGO_ERROR NUMBER;
  OPERACION VARCHAR2(50);
BEGIN
  IF (INSERTING) THEN
    OPERACION:= 'OPERACION INSERT';
  ELSIF (UPDATING) THEN
    OPERACION:= 'OPERACION UPDATE';
  ELSE
    OPERACION:= 'OPERACION DELETE';
  END IF;
  
  IF(INSERTING) THEN
    INSERT INTO LOGS (DESCRIPCION, FECHA, USUARIO, OPERACION) VALUES(
      'SE REALIZO UN INSERT EN LA TABLA PROVEEDORES Y EL DATO NUEVO EN EL ID ES: '||:NEW.PROVEEDORID||
      ', EL NUEVO VALOR DEL NOMBRE DEL PROVEEDOR ES: '||:NEW.NOMBREPROV||
      ', EL NUEVO CONTACTO DEL PROVEEDOR ES: '||:NEW.CONTACTO||
      ', EL NUEVO CELULAR DEL PROVEEDOR ES: '||:NEW.CELUPROV||
      ', EL NUEVO CELULAR FIJO DEL PROVEEDOR ES: '||:NEW.FIJOPROV,
      /*SYSTIMESTAMP*/'HOLA MUNDO',
      USER,
      'OPERACION INSERT'
    );
  END IF;

  IF(UPDATING) THEN
    INSERT INTO LOGS (DESCRIPCION, FECHA, USUARIO, OPERACION) VALUES(
      'SE REALIZO UN UPDATE EN LA TABLA PROVEEDORES, 
      LOS DATOS ANTERIORES SON:
       NOMBRE DEL PROVEEDOR: '||:OLD.NOMBREPROV||
      ', CONTACTO DEL PROVEEDOR: '||:OLD.CONTACTO||
      ', CELULAR DEL PROVEEDOR: '||:OLD.CELUPROV||
      ', CELULAR FIJO DEL PROVEEDOR: '||:OLD.FIJOPROV||
      'LOS NUEVOS DATOS SON: 
       NOMBRE DEL PROVEEDOR: '||:NEW.NOMBREPROV||
      ', CONTACTO DEL PROVEEDOR: '||:NEW.CONTACTO||
      ', CELULAR DEL PROVEEDOR: '||:NEW.CELUPROV||
      ', CELULAR FIJO DEL PROVEEDOR: '||:NEW.FIJOPROV,
      SYSTIMESTAMP,
      USER,
      'OPERACION UPDATE'
    );
  END IF;

  IF(DELETING) THEN
    INSERT INTO LOGS (DESCRIPCION, FECHA, USUARIO, OPERACION) VALUES(
      'SE REALIZO UN DELETE EN LA TABLA PROVEEDORES Y EL DATO ELIMINADO EN EL ID ES: '||:OLD.PROVEEDORID||
      ' Y EL NOMBRE DEL PROVEEDOR ERA: '||:OLD.NOMBREPROV,
      SYSTIMESTAMP,
      USER,
      'OPERACION DELETE'
    );
  END IF;
  
  COMMIT; --SE APRUEBAN TODOS LOS CAMBIOS

  EXCEPTION      
    WHEN OTHERS THEN
      CODIGO_ERROR:=SQLCODE;
      MSJ_ERROR:=SQLERRM;
      
      IF(SQLCODE=-2291) THEN
        DBMS_OUTPUT.PUT_LINE('VALOR DE LLAVE FORANEA INEXISTENTE.');
      END IF;
      
      IF(SQLCODE=-1858) THEN
        DBMS_OUTPUT.PUT_LINE('SE ESTAN ASIGNANDO TIPOS DE DATOS INCOMPATIBLES.');
      END IF;
      
      --ROLLBACK; -- SE DESHACEN TODOS LOS CAMBIOS.   
      
      INSERT INTO LOGS (DESCRIPCION, FECHA, USUARIO, OPERACION) VALUES(
        'SE GENERO UN ERROR, EL SIGUIENTE CODIGO DE ERROR ES: '||CODIGO_ERROR||
        '. EL MENSAJE DE ERROR ES: '||MSJ_ERROR,
        SYSTIMESTAMP,
        USER,
        OPERACION
      );
      COMMIT;
      
      DBMS_OUTPUT.PUT_LINE('EL CODIGO DE ERROR ES: '||CODIGO_ERROR); 
      DBMS_OUTPUT.PUT_LINE('EL MENSAJE DE ERROR ES: '||MSJ_ERROR);
    
      ROLLBACK; -- SE DESHACEN TODOS LOS CAMBIOS.      
END; 


--BLOQUE ANONIMO PARA LAS PRUEBAS
DECLARE
BEGIN
  --CORRECTOS
  --INSERT INTO PROVEEDORES VALUES (111,'DIANA','DANIEL ACOSTA',099234567,2124456);
  --INSERT INTO PROVEEDORES VALUES (112,'SULA','DANIEL ACOSTA',099234567,2124456);
  INSERT INTO PROVEEDORES VALUES (117,'MERCO SUR','DANIEL ACOSTA',099234567,2124456);
  
  --UPDATE PROVEEDORES SET NOMBREPROV='DIANA NUEVA VERSION' WHERE NOMBREPROV='DIANA';
  --UPDATE PROVEEDORES SET CONTACTO='MARLON MEGIA' WHERE NOMBREPROV='SULA';
  
  --DELETE FROM PROVEEDORES WHERE NOMBREPROV='DIANA NUEVA VERSION';
 -- DELETE FROM PROVEEDORES WHERE NOMBREPROV='SULA';
  
  --INCORRECTOS
  --INSERT INTO PROVEEDORES VALUES (111,'DIANA','DANIEL ACOSTA',099234567,2124456);
  --NO FUNCIONA COMO ERROR VALIDO UPDATE PROVEEDORES SET CELUPROV=11111111 WHERE NOMBREPROV='SULA';
  --NO FUNCIONA COMO ERROR DELETE FROM PROVEEDORES WHERE NOMBREPROV='SULA';
  
  --COMMIT;
END;

/*####################################################################################### 
## 3) Crear un trigger para la tabla PROVEEDORES, se debe ejecutar después de un       ##
## INSERT o un UPDATE o un DELETE en esta tabla, este trigger debe guardar un registro ##
## en la tabla LOGS con la información de la operación que se realizó. Además, se debe ##
## controlar cualquier error que pueda suceder y en caso de error se debe insertar un  ##
## registro en la tabla LOGS con la información del error. El trigger es el que debe   ##
## aprobar o deshacer los cambios                                                      ##
#######################################################################################*/
