# generador_sp_mariadb
Generador de Procedimientos ABM para MariaDB
-- ==========================================================
--  Autor: Freddy García -  Superfg@hotmail.com ( Venezuela )
--  Creado el : 2017-10-20 14:00:00
-- ==========================================================
El Presente Generador De Procedimientos Almacenados para la Base de Dato MARIADB Version 10.2
Nace con la finalidad de agilizar en tiempo el desarrollo de procedimientos Basicos Aplicados
a una tabla en una Base de Datos.

Forma de Utilizar.
Descargue el Generador, Copielo en su Sistema Administrador de Preferencia tales como
(HeidySql, Navicat, entre otros) y luego ejecutelo, dicha ejecucion dara como resultado
sera creado en su base de datos un Procedimiento Almacenado Llamado GENERADOR_SP. Ya al
realizar esta ejecución, estaremos listos para darle uso en su base de datos.

Parametros:
  TABLENAME : Nombre de la Tabla a la cual deseas crear los Procedimientos almacenados.
  
Resultados:
  Al realizar la Ejecución del Procedimiento nos retornara una colsulta de una Fila y una
  Columna, en la cual se encuentra en Formato TEXTO las instrucciones necesarias para la
  creacion de los proceimientos almacenados para la tabla que paso como parametro.
  
  Estos procedimientos son:
  * ACT_TABLANAME
  * LIST_TABLENAME
  * ELIM_TABLENAME
  
  -- ********************************
    Procedimiento LIST_TABLENAME
  -- ********************************
    ACT_TABLANAME : ACT_ Donde TABLANAME recuerde que es el parametro pasado al Generador.
    Este Procedimiento se encargara de realizar las Acciones de INSERT y UPDATE 
    de acuerdo a los parametros que se le envien. (Los parametros en este caso corresponden
    a cada campo en la estructura de la tabla), posee Parametros Adicionales los cuales son:
    IN `_modo` Varchar(1),
    OUT `_Bandera` int(11)
    
    Explicación de parametros:
        IN `_modo` Varchar(1), --- Parametro de Entrada que Identifica la Operacion deseada siendo.
             _modo = 1.- Realizar INSERT
             _modo = 2.- Realizar Update
        OUT `_Bandera` int(11)--- Parametro de Salida o Retorno que Identifica el exito en la Operacion.
           Valores:
            0 = Obtuvo Exito en la Operación.
            1 = Ocurrio un Problema en la Operación por lo cual no se realizo.
            
   -- ********************************
    Procedimiento LIST_TABLENAME
   -- ********************************
    LIST_TABLENAME: LIST_ Donde TABLANAME recuerde que es el parametro pasado al Generador.
    Este Procedimiento se encargara de realizar las Acciones de DELETE en la tabla 
    de acuerdo a los parametros que se le envien. (Los parametros en este caso corresponden
    al campo clave en la estructura de la tabla), posee Parametros Adicionales los cuales son:
   
    IN CAMPO_CLAVE TIPODATO (PRESICION) ,
    IN `_modo` Varchar(1),
    OUT `_Bandera` int(11)
    
    Explicación de parametros:
         IN CAMPO_CLAVE TIPODATO (PRESICION) --- Parametro de Entrada que especifica el Valor para
         el campo Clave con el cual se realizara la verificación por si el listado o consulta es de
         un registro en especifico.
         
        IN `_modo` Varchar(1), --- Parametro de Entrada que Identifica la Operacion deseada siendo.
             _modo = 1.- Realizar Busqueda por Registro Especifico (Consulta Individual)
             _modo = 2.- Realizar Listado en General 
             
        OUT `_Bandera` int(11)--- Parametro de Salida o Retorno que Identifica el exito en la Operacion.
          Valores:
            0 = Obtuvo Exito en la Operación.
            1 = Ocurrio un Problema en la Operación por lo cual no se realizo.
   
   
   -- ********************************
    Procedimiento ELIM_TABLENAME
   -- ********************************
   
    ELIM_TABLENAME: ELIM_ Donde TABLANAME recuerde que es el parametro pasado al Generador.
    Este Procedimiento se encargara de realizar los DELETE en la tabla de acuerdo a los parametros
    que se le envien. (Los parametros en este caso corresponden al campo clave en la estructura de la tabla),
    posee Parametros Adicionales los cuales son:
    IN CAMPO_CLAVE TIPODATO (PRESICION) ,
    IN `_modo` Varchar(1),
    OUT `_Bandera` int(11)
    Explicación de parametros:
         IN CAMPO_CLAVE TIPODATO (PRESICION) --- Parametro de Entrada que especifica el Valor para
         el campo Clave con el cual se realizara la verificación y Eliminación de un registro en especifico.
         
        IN `_modo` Varchar(1), --- Parametro de Entrada que Identifica la Operacion deseada siendo.
             _modo = 1.- Realizar Busqueda por Registro Especifico (Consulta Individual)
             _modo = 2.- Realizar Listado en General 
             
        OUT `_Bandera` int(11)--- Parametro de Salida o Retorno que Identifica el exito en la Operacion.
          Valores:
            0 = Obtuvo Exito en la Operación.
            1 = Ocurrio un Problema en la Operación por lo cual no se realizo.
    
    
    Forma de Utilizar El GENERADOR de Procedimientos Almacenados para MARIADB
  -- ********************************
Llamado para INSERTAR UN REGISTRO en la Tabla EDIFICIOS.
    CALL `Act_Edificios`('1', 'edificioSS 1', 'edif 1', 'A', '1', @BANDERAINT );

-- ********************************
Llamado para ACTUALIZAR UN REGISTRO en la Tabla EDIFICIOS.
    CALL `Act_Edificios`('1', 'edificio 1', 'edif 1', 'A', '2', @BANDERAINT );
 
 -- ********************************  
Llamado para REALIZAR UN LISTADO GENERAL en la Tabla EDIFICIOS.
  CALL List_edificios (0,2,@BANDERAINT );

 -- ********************************  
Llamado para REALIZAR UNA CONSULTA ESPECIFICA en la Tabla EDIFICIOS.
  CALL List_edificios (1,1,@BANDERAINT );

 -- ********************************  
Llamado para REALIZAR UNA ELIMINAR UN REGISTRO en la Tabla EDIFICIOS.
  CALL `Elim_Edificios`('1',3,@BANDERAINT );
  
Herramienta a disponibilidad de la comunidad sin responsabilidad atribuible por su uso.
Puede ser Modificada a Su Criterio y Disposición.

Espero la Disfruten y les ayude en sus Desarrollos.
Freddy García -  Superfg@hotmail.com ( Venezuela )
