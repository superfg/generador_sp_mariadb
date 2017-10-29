CREATE DEFINER=`root`@`localhost` PROCEDURE `Generar_Sp`(
	IN `Tablename` LONGTEXT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'Generador de Procedimientos Almacenados para Tablas Maestras'
Begin
	-- Declaración de variables
 	Declare _CadenaSQL    LongText  Default '';
	Declare _tableName1   VarChar(50) Default '';
  Declare _bd           VarChar(200) Default '';
  Declare _nl           VarChar(3) Default '';
  Declare _spHeadersFG    LongText  Default '';
  Declare _spHeaders    LongText  Default '';
  Declare _spcondicion  LongText  Default '';
  Declare _sptoupdates  LongText  Default '';
  Declare _spcampos     LongText  Default '';
  Declare _spvariables  LongText  Default '';
  Declare _spcamposclaves      LongText  Default '';
  Declare _spvariablesclaves   LongText  Default '';
  Declare _spvardescriclaves   LongText  Default '';
  Declare _ColumnName    VarChar(50) Default '';
  Declare _column_key    VarChar(50) Default '';
	Declare _DataType     VarChar(50) Default '';
	Declare _MaxLenChar   SmallInt(10) Default 0;
	Declare _NumericPrec  SmallInt(10) Default 0;
	Declare _NumericScale SmallInt(10) Default 0;
	Declare _column_type  VarChar(50) Default '';
	Declare _CadenaSQL1   LongText Default '';
	Declare _spParameters LongText Default '';
	Declare _iniparam     LongText Default '';
	Declare _Contadorindices int(3) Default 0;
	Declare _lenind int(6) Default 0;
  Declare _lencam int(6) Default 0;
  Declare _Lenupdate  int(6) Default 0;

-- Declaración de Cursor 
	Declare _latablaes Cursor
		For Select column_name,data_type,character_maximum_length,numeric_precision,numeric_scale, column_type, column_key
		From INFORMATION_SCHEMA.COLUMNS
		Where Table_name = tableName and table_schema = database();
   Open _latablaes;
	Begin
	Declare Exit Handler For SqlState '02000' Begin End;
		Loop
			Fetch _latablaes Into _ColumnName,_DataType,_MaxLenChar,_NumericPrec,_NumericScale,_column_type,_column_key;
			Set _iniparam = '...';
			Set _iniparam = Concat('IN _X',Trim(_ColumnName),' ', Trim(_column_type),' ' );
			Set _CadenaSQL = Concat(_CadenaSQL,If(_CadenaSQL='','',', '),Trim(_ColumnName));
			Set _CadenaSQL1= Concat(_CadenaSQL1,If(_CadenaSQL1='','',', '),'_X',Trim(_ColumnName));
			Set _spcampos = Concat(_spcampos,If(_CadenaSQL='','',', '),Trim(_ColumnName));
			Set _spParameters = Concat(_spParameters,If(_spParameters='','',';'),_iniparam );
			If (_column_key <> '') Then
					Set _spcamposclaves =  Concat(_spcamposclaves,'( ',Trim(_ColumnName),' = ',' _X', Trim(_ColumnName),' ) and ' );
					Set _spvariablesclaves =  Concat(_spvariablesclaves,Trim(_ColumnName),',');
					Set _spvardescriclaves = Concat(_spvardescriclaves ,'IN _X',Trim(_ColumnName),' ', Trim(_column_type),' ' );
					Set _Contadorindices = _Contadorindices + 1;
			End if;
			Set _spcondicion =  Concat(_spcondicion,'( ',Trim(_ColumnName),' = ',' _X', Trim(_ColumnName),' ) and ' );
			Set _sptoupdates = Concat(_sptoupdates,'',Trim(_ColumnName),' = ',' _X', Trim(_ColumnName),' ,' );
	    End Loop;
    End;
    Close _latablaes;
 -- Gestion de Bariables y Creación de Procedimientos
    If (_Contadorindices = 1) then 
     		Set _lenind = CHAR_LENGTH(_spcamposclaves) - 4 ;
    		Set _lencam = CHAR_LENGTH(_spvariablesclaves) - 1;
    	  Set _spcamposclaves = SUBSTRING(_spcamposclaves,1,_lenind );
      	Set _spvariablesclaves =SUBSTRING(_spvariablesclaves,1, _lencam);
	  End if;
	  
 Set _Lenupdate = CHAR_LENGTH(_sptoupdates) - 1;
 Set _sptoupdates =SUBSTRING(_sptoupdates, 1,  _Lenupdate );
 SET _nl = '\n';   
 SET _spHeadersFG = Concat(_spHeadersFG,_nl);
 SET _spHeadersFG = Concat(_spHeadersFG, '-- ==========================================================',_nl);
 SET _spHeadersFG = Concat(_spHeadersFG, '--  Autor: Freddy García -  Superfg@hotmail.com ( Venezuela )',_nl);
 SET _spHeadersFG = Concat(_spHeadersFG, '--  Creado el : ',NOW() ,_nl);
 SET _spHeadersFG = Concat(_spHeadersFG, '-- ==========================================================',_nl);
 SET _spParameters = Replace(_spParameters,';',concat(',',_nl));
 SET _tableName1 = CONCAT(ucase(LEFT(tableName,1)),LCASE(SUBSTRING(tableName,2))); 
 SET _bd = (SELECT table_schema FROM information_schema.columns	WHERE table_name = _tableName1 LIMIT 1);
 SET _spHeaders = concat(_spHeaders,_spHeadersFG);
 SET _spHeaders = concat(_spHeaders ,'Delimiter $$',_nl);
 SET _spHeaders = concat(_spHeaders ,' USE ' , _bd,';' ); 
 SET _spHeaders = concat(_spHeaders ,_nl);
 SET _spHeaders = concat(_spHeaders ,'Drop Procedure If Exists `Act_', _tableName1, '`;',_nl);
 SET _spHeaders = concat(_spHeaders ,'CREATE PROCEDURE `Act_', _tableName1, '`(',_nl); 
 SET _spHeaders = concat(_spHeaders , _spParameters,',', _nl,'IN _modo Varchar(1), Out _Bandera int(11))', _nl);  
 SET _spHeaders = concat(_spHeaders ,'Begin', _nl);
 -- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl); 
 SET _spHeaders = concat(_spHeaders ,'	If  _modo = ',char(39),'1',char(39),' Then', _nl);
 SET _spHeaders = concat(_spHeaders ,'		if EXISTS ( SELECT ',_spvariablesclaves,' From ', _tableName1, ' Where ',_spcamposclaves ,' ) then' , _nl);
 SET _spHeaders = concat(_spHeaders ,'			Set _modo =  ',char(39),'2',char(39),';', _nl);
 SET _spHeaders = concat(_spHeaders ,'		Else', _nl);
 SET _spHeaders = concat(_spHeaders ,'			Insert Into ', _tableName1,'(',_CadenaSQL,')',' Values (',_CadenaSQL1,');', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 	Set  _Bandera = LAST_INSERT_ID();', _nl);
 SET _spHeaders = concat(_spHeaders ,'		End if; ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	End if; ', _nl);
 -- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	If  _modo = ',char(39),'2',char(39),' Then', _nl);
 SET _spHeaders = concat(_spHeaders ,'		if EXISTS ( SELECT ',_spvariablesclaves,' From ', _tableName1, ' Where ',_spcamposclaves ,' ) then' , _nl);
 SET _spHeaders = concat(_spHeaders ,'				Update ', _tableName1,' Set ',_sptoupdates,  ' Where ',_spcamposclaves,';', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = 0;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		Else', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = -1;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		End if; ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	End if; ', _nl);
 SET _spHeaders = concat(_spHeaders ,'End', _nl);
 -- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl);
 SET _spHeaders = concat(_spHeaders ,' $$', _nl); 
 SET _spHeaders = concat(_spHeaders ,'Delimiter ;', _nl); 
 SET _spHeaders = concat(_spHeaders , _nl);
 SET _spHeaders = concat(_spHeaders,_spHeadersFG);
 SET _spHeaders = concat(_spHeaders ,'Delimiter $$',_nl);
 SET _spHeaders = concat(_spHeaders ,' USE ' , _bd,';' ); 
 SET _spHeaders = concat(_spHeaders ,_nl);
 SET _spHeaders = concat(_spHeaders ,'Drop Procedure If Exists `Elim_', _tableName1, '`;',_nl);
 SET _spHeaders = concat(_spHeaders ,'CREATE PROCEDURE `Elim_', _tableName1, '`(',_nl);
 SET _spHeaders = concat(_spHeaders , _spvardescriclaves);
 SET _spHeaders = concat(_spHeaders ,',', _nl,'IN _modo Varchar(1), Out _Bandera int(11))', _nl);  
 SET _spHeaders = concat(_spHeaders ,'Begin', _nl);
 -- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	If  _modo = ',char(39),'3',char(39),' Then', _nl);
 SET _spHeaders = concat(_spHeaders ,'		if EXISTS ( SELECT ',_spvariablesclaves,' From ', _tableName1, ' Where ',_spcamposclaves ,' ) then' , _nl);
 SET _spHeaders = concat(_spHeaders ,'				Delete From ', _tableName1,' Where ',_spcamposclaves,';', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = 0;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		Else', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = -1;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		End if; ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	End if; ', _nl);
-- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl);
 SET _spHeaders = concat(_spHeaders ,'End', _nl);
 SET _spHeaders = concat(_spHeaders ,' $$', _nl); 
 SET _spHeaders = concat(_spHeaders ,'Delimiter ;', _nl); 
 SET _spHeaders = concat(_spHeaders , _nl);
 SET _spHeaders = concat(_spHeaders,_spHeadersFG);
 SET _spHeaders = concat(_spHeaders ,'Delimiter $$',_nl);
 SET _spHeaders = concat(_spHeaders ,' USE ' , _bd,';' ); 
 SET _spHeaders = concat(_spHeaders ,_nl);
 SET _spHeaders = concat(_spHeaders ,'Drop Procedure If Exists `List_', _tableName1, '`;',_nl);
 SET _spHeaders = concat(_spHeaders ,'CREATE DEFINER=`root`@`localhost` PROCEDURE `List_', _tableName1, '`(',_nl);
 SET _spHeaders = concat(_spHeaders , _spvardescriclaves);
 SET _spHeaders = concat(_spHeaders ,',', _nl,'IN _modo Varchar(1), Out _Bandera int(11))', _nl); 
 SET _spHeaders = concat(_spHeaders ,'Begin', _nl);
 -- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	If  _modo = ',char(39),'1',char(39),' Then', _nl);
 SET _spHeaders = concat(_spHeaders ,'		if EXISTS ( SELECT ',_spvariablesclaves,' From ', _tableName1, ' Where ',_spcamposclaves ,' ) then' , _nl);
 SET _spHeaders = concat(_spHeaders ,'				Select ', _CadenaSQL,' From ', _tableName1, ' Where ',_spcamposclaves,' Limit 1;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = 0;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		Else', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = -1;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		End if; ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	End if; ', _nl);
 -- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	If  _modo = ',char(39),'2',char(39),' Then', _nl);
 SET _spHeaders = concat(_spHeaders ,'		if EXISTS ( SELECT ',_spvariablesclaves,' From ', _tableName1 ,') then' , _nl);
 SET _spHeaders = concat(_spHeaders ,'				Select ', _CadenaSQL,' From ', _tableName1, ' order by ', _spvariablesclaves,' ;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = 0;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		Else', _nl);
 SET _spHeaders = concat(_spHeaders ,'		 		Set  _Bandera = -1;', _nl);
 SET _spHeaders = concat(_spHeaders ,'		End if; ', _nl);
 SET _spHeaders = concat(_spHeaders ,'	End if; ', _nl);
 -- SET _spHeaders = concat(_spHeaders ,'-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- ', _nl); 
 SET _spHeaders = concat(_spHeaders ,'End', _nl);
 SET _spHeaders = concat(_spHeaders ,' $$', _nl); 
 SET _spHeaders = concat(_spHeaders ,'Delimiter ;', _nl); 
 SET _spHeaders = concat(_spHeaders , _nl);
--   Select _CadenaSQL,_CadenaSQL1, _tableName1,_bd,_spParameters,_spHeaders,_spcondicion,_sptoupdates,_spvariablesclaves,_spcamposclaves ;  Para Depurar
   Select  _spHeaders as Procedimientos ;
 End
