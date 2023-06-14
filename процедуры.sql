create or alter proc output
@i		int
as
	if @i=1 begin
		select ID_COM, NAME , PHONE , ADRESS 
		from COMPANY
		goto E
	end
	if @i=2 begin
		select ID_CUR, FIO , IIN , W_PHONE , M_PHONE , EMAIL 
		from CURIER
		goto E
	end
	if @i=3 begin
		select ID_CLI, NAME , IIN, PHONE, EMAIL , ADRESS
		from CLIENT
		goto E
	end
	if @i=4 begin
		select ID_PROD, PRODUCT.NAME , PRICE , PROD_COD , dbo.COMPANY.NAME ,
		PROD_W, dbo.measure.name 
		from PRODUCT left join COMPANY  on COMPANY.ID_COM  = PRODUCT.FK_COM 
					 left join measure on  measure.id_meas=PRODUCT.FK_MEAS
		goto E
	end
	if @i=5 begin
		select ID_EXP1, CURIER.FIO , CLIENT.NAME , DATE_EXP , NUM_EXP , case
									when SIGN=1 then 'Подписано'
									when SIGN=0 then 'не подписано'
									end 
		from EXP_NOTE1 left join CURIER  on CURIER.ID_CUR  = EXP_NOTE1.FK_CUR
						left join CLIENT  on CLIENT.ID_CLI  = EXP_NOTE1.FK_CLI
		goto E
	end
	if @i=6 begin
		select dbo.PRODUCT.NAME , DBO.EXP_NOTE2.PRICE, SUM_PROD , PRICE_SUM_PROD
		from EXP_NOTE2 left join PRODUCT  on PRODUCT.ID_PROD  = EXP_NOTE2.FK_PROD
		goto E
	end 
	E:

create or alter proc curier_proc
@i			int,
@IIN		varchar(50),
@FIO		char(12),	
@W_PHONE	char(11), 
@M_PHONE	char(11), 
@EMAIL		varchar(50),
@ID			smallint
as
	if @i=1 begin
		insert into CURIER
		(FIO, IIN,  W_PHONE, M_PHONE, EMAIL)
		values
		(@FIO, @IIN,  @W_PHONE, @M_PHONE, @EMAIL)
		goto E
	end
	if @i=2 begin
		delete  from CURIER
		where ID_CUR=@ID
		goto E
	end
	if @i=4 begin
		update CURIER
		set  FIO= @FIO  , IIN=@IIN ,  W_PHONE=@W_PHONE , M_PHONE=@M_PHONE , EMAIL=@EMAIL
		where ID_CUR=@ID
		goto E
	end
	if @i=3 begin
		SELECT FIO ,IIN,   W_PHONE , M_PHONE , EMAIL 
		FROM CURIER 
		WHERE ID_CUR =@ID
		goto E
	end
	E:





create or alter proc product_proc
@i			int,
@NAME		varchar(70),
@PRICE		money,		
@PROD_COD	char(5),
@FK_COM		smallint,
@PROD_W		decimal,
@FK_MEAS	smallint,
@ID			smallint
as
	if @i=1 begin
		insert into PRODUCT
		(PROD_COD, NAME, PRICE,  FK_COM, PROD_W, FK_MEAS)
		values
		(@PROD_COD, @NAME, @PRICE, @FK_COM, @PROD_W, @FK_MEAS)
		goto E
	end
	if @i=2 begin
		delete  from PRODUCT
		where ID_PROD=@ID
		goto E
	end
	if @i=4 begin
		update PRODUCT
		set PROD_COD=@PROD_COD, NAME=@NAME, PRICE=@PRICE,  FK_COM=@FK_COM, PROD_W=@PROD_W
		where ID_PROD=@ID
		goto E
	end
	if @i=3 begin
		SELECT PROD_COD, NAME, PRICE,  FK_COM, PROD_W, FK_MEAS
		FROM PRODUCT 
		WHERE ID_PROD =@ID
		goto E
	end
	E:

create or alter proc company_proc
@i			int,
@NAME		varchar(50),
@PHONE		char(11),
@ADRESS		varchar(30),
@ID			smallint
as
	if @i=1 begin
		insert into COMPANY
		(NAME, PHONE, ADRESS)
		values
		(@NAME, @PHONE, @ADRESS)
		goto E
	end
	if @i=2 begin
		delete  from COMPANY
		where ID_COM=@ID
		goto E
	end
	if @i=4 begin
		update COMPANY
		set NAME=@NAME, PHONE=@PHONE,  ADRESS=@ADRESS
		where ID_COM=@ID
		goto E
	end
	if @i=3 begin
		SELECT NAME, PHONE, ADRESS
		FROM COMPANY 
		WHERE ID_COM =@ID
		goto E
	end
	E:

create or alter proc exp1_proc
@i			int,
@FK_CUR		smallint,
@FK_CLI		smallint,
@DATE_EXP	date,
@NUM_EXP	char(5),
@SIGN		bit,
@ID			smallint
as
	if @i=1 begin
		insert into EXP_NOTE1
		(FK_CUR, FK_CLI,  NUM_EXP,  DATE_EXP, SIGN)
		values
		(@FK_CUR, @FK_CLI,  @NUM_EXP,  @DATE_EXP, @SIGN)
		goto E
	end
	if @i=2 begin
		delete  from EXP_NOTE1
		where ID_EXP1=@ID
		goto E
	end
	if @i=4 begin
		update EXP_NOTE1
		set FK_CUR=@FK_CUR, FK_CLI=@FK_CLI,  NUM_EXP=@NUM_EXP,  DATE_EXP=@DATE_EXP, SIGN=@SIGN
		where ID_EXP1=@ID
		goto E
	end
	if @i=3 begin
		SELECT FK_CUR, FK_CLI,  NUM_EXP,  DATE_EXP, SIGN
		FROM EXP_NOTE1
		WHERE ID_EXP1 =@ID
		goto E
	end
	E:

create or alter proc exp2_proc
@i			int,
@FK_PROD	smallint,
@SUM_PROD	int,
@PRICE		money, 
@ID			smallint
as
	if @i=1 begin
		select FK_EXP1, dbo.PRODUCT.NAME , DBO.EXP_NOTE2.PRICE, SUM_PROD , PRICE_SUM_PROD
		from EXP_NOTE2 left join PRODUCT  on PRODUCT.ID_PROD  = EXP_NOTE2.FK_PROD
		where FK_EXP1=@ID
		goto E
	end
	if @i=2 begin
		insert into EXP_NOTE2
		( fk_prod, price,  sum_prod, FK_EXP1)
		values
		( @fk_prod, @price, @sum_prod, @id)
		goto E
	end	
	E:

create or alter proc exp2_proc2
@i			int,
@ID			smallint
as
	if @i=1 begin
		select FK_EXP1, dbo.PRODUCT.NAME , DBO.EXP_NOTE2.PRICE, SUM_PROD , PRICE_SUM_PROD
		from EXP_NOTE2 left join PRODUCT  on PRODUCT.ID_PROD  = EXP_NOTE2.FK_PROD
		where FK_EXP1=@ID
		goto E
	end	
	E:
