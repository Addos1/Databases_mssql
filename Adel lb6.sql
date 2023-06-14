Create database university
Go
USE university                                          
Go
-- ������ �����
create table STUDENTS                             -- �������� ������� ��������
(
  ID_STUD       smallint	primary key		identity	not null,
  IIN           char(12)				 not null	unique,-- ��� ��������,
  SURNAME       varchar(30)			     not null,-- ������� ��������,
  NAME          varchar(30)				 not null,-- ��� ��������,
  KURS          tinyint				   	 not null   check(kurs>0 and kurs<=4),-- ����, �� ������� ������ �������,
  DATEBIRTH     date    				 not null,-- ���� �������� ��������
  SEX           bit						 not null,-- ��� ��������
  RW            rowversion
)
create table DISCIPLINES						  -- �������� ������� ����������
(
  ID_DIS        smallint	primary key		identity	not null,
  NAME			varchar(50)			     not null,-- ������������ �������� ��������,
  HOURS_LEC		tinyint				     not null,-- ���������� �����, ��������� �� ������,
  HOURS_PRAC	tinyint,						  -- ���������� �����, ��������� �� ��������,
  HOURS_SRS	    tinyint					 not null,--���������� �����, ��������� �� ���,  
  LEC_DIS		smallint				 not null,
  RW            rowversion
)
create table LECTURERS							  -- �������� ������� ��������������
(
  ID_LEC        smallint	primary key		identity	not null,
  IIN           char(12)                 not null	unique,-- ��� �������������,
  SURNAME       varchar(30)              not null,-- ������� �������������,
  NAME          varchar(50)              not null,-- ��� �������������,
  SEX           bit                      not null,-- ��� �������������,
  LEN_WORK		smallint	default('��� ����� ������'), -- ���� ������				
  deg_LEC		smallint				 not null,
  pos_LEC		smallint				 not null,
  title_LEC		smallint				 not null,
  RW            rowversion
)

create table degree								  -- �������� ������� ������� ������� 
(
  id_deg	    smallint	primary key		identity	not null,
  name			varchar(40)			     not null,-- ��� ������������� �������
  rw            rowversion
)
create table position							  -- �������� ������� ������������� ��������� 
(
  id_pos        smallint	primary key		identity	not null,
  name			varchar(40)              not null,-- �������� ������������� ��������� 
  rw            rowversion
)
create table title								  -- �������� ������� ������ ������ 
(
  id_title      smallint	primary key		identity	not null,
  name			varchar(40)              not null,-- �������� ������ 
  rw            rowversion
)
create table STUD_DIS							  -- �������� ������� ��� ����� M:N 
(
  ID_STUD2      smallint,
  ID_DIS2       smallint,
  rw            rowversion
)


--C������� ��������� ������
alter table STUD_DIS	add constraint	stud
foreign key (ID_STUD2)	references STUDENTS		(ID_STUD)

alter table STUD_DIS	add constraint	dis
foreign key (ID_DIS2)	references DISCIPLINES  (ID_DIS)

alter table DISCIPLINES add  constraint LEC_DIS   --����� ������������� ���������� 1:N 
foreign key (LEC_DIS)	references LECTURERS	(ID_LEC)

alter table LECTURERS	add constraint	deg_LEC	  --����� ������� ������� �������������  1:N
foreign key (deg_LEC)	references degree		(id_deg)

alter table LECTURERS	add constraint	pos_LEC	  --����� ������������� ��������� �������������  1:N
foreign key (pos_LEC)	references position		(id_pos)

alter table LECTURERS	add constraint	title_LEC --����� ������� ������ �������������  1:N
foreign key (title_LEC) references title		(id_title)


--C������� �������� ��� ��������� ������
create index STUD_DIS	on STUD_DIS		(ID_STUD2)
create index LEC_DIS	on DISCIPLINES	(LEC_DIS)	
create index deg_LEC	on LECTURERS	(deg_LEC)	
create index pos_LEC	on LECTURERS	(pos_LEC)	
create index title_LEC	on LECTURERS	(title_LEC)	
--C������� �������� ��� �������� �� ���������� ������ 
create index SURNAME_LEC	on LECTURERS	(SURNAME)
create index SURNAME_STUD	on STUDENTS		(SURNAME)
create index NAME_DIS		on DISCIPLINES	(NAME)


--���������� ������ �������
declare	 @id_stud	tinyint
declare	 @id_dis	tinyint
declare	 @id_lec	tinyint
declare	 @id_deg	tinyint
declare	 @id_pos	tinyint
declare	 @id_title	tinyint

INSERT INTO Degree 
(name) 
VALUES
(	  '�������� ����'							),
(	  '������ ����'								),
(	  '��������'								),
(	  '�������'									),
(	  '������ ���������'						)
select @@ERROR as '������', @@rowcount as '���������� ��������'
SELECT @id_deg=@@IDENTITY

INSERT INTO position
(name) 
VALUES
(	  '��������'								),
(	  '���������'								),
(	  '������� ������� ���������'				),
(	  '������� ������� ���������'				),
(	  '���������'								),
(	  '������'									),
(	  '������� ������� ���������'				)
select @@ERROR as '������', @@rowcount as '���������� ������������� ����������'
SELECT @id_pos=@@IDENTITY

INSERT INTO Title 
(name) 
VALUES
(	  '������'									),
(	  '���������'								),
(	  '����-������������� �������� ����'		),
(	  '���� �������� ����'						)
select @@ERROR as '������', @@rowcount as '���������� ������'
SELECT @id_title=@@IDENTITY

INSERT INTO STUDENTS 
(IIN, SURNAME, NAME, KURS, DATEBIRTH, SEX) 
VALUES
(     1111111111,        '������',		   '����',			1,      '2003-01-01',     1),
(     1222222222,        '������',		   '����',			1,      '2003-02-02',     1),
(     1444444444,        '��������',	   '�����',		    1,      '2003-03-03',     1),
(     1555555555,        '������',		   '����',		    1,      '2003-04-04',     1),
(     1666666666,        '������',	       '������',	    1,      '2003-05-05',     1),
(     1777777777,        '�����',		   '�����',			1,      '2002-06-06',     1),
(     1999999999,		 '������',		   '�����',			1,      '2002-07-07',     1),
(     1000000000,		 '������',		   '�����',			1,      '2002-08-08',     1),
(     1888888888,        '�����',		   '�����',		    1,      '2002-09-09',     1),
(     1333333333,        '�������',		   '�����',		    1,      '2002-10-10',     1),

(     2111111111,        '������',		   '���',			1,      '2003-11-11',     0),
(     2222222222,        '��������',	   '���',			1,      '2003-12-12',     0),
(     2444444444,        '�������',		   '���������',		1,      '2003-01-13',     0),
(     2555555555,        '��������',	   '������',		1,      '2003-02-14',     0),
(     2666666666,        '��������',	   '����',			1,      '2003-03-15',     0),
(     2777777777,        '���������',	   '����',			1,      '2003-04-16',     0),
(     2999999999,		 '��������',	   '�����',			1,      '2002-05-17',     0),
(     2000000000,		 '�������',		   '����������',	1,      '2002-06-18',     0),
(     2888888888,        '������',		   '��������',		1,      '2002-07-19',     0),
(     2333333333,        '��������',	   '�������',	    1,      '2002-08-20',     0),

(     3111111111,        '����������',	   '�������',		1,      '2002-01-21',     1),
(     3222222222,        '���������',	   '������',		1,      '2002-09-22',     1),
(     3444444444,        '���������',	   '������',		1,      '2002-10-23',     1),
(     3555555555,        '�������',		   '�����',			1,      '2002-11-24',     1),
(     3666666666,        '������',	       '������',		1,      '2002-12-25',     1),
(     3777777777,        '��������',	   '����',			1,      '2003-01-26',     1),
(     3999999999,		 '��������',       '�������',	    1,      '2003-02-27',     1),
(     3000000000,		 '��������',       '�������',		1,      '2003-03-28',     1),
(     3888888888,        '�������',		   '����',			1,      '2003-04-29',     1),
(     3333333333,        '�������',        '����',			1,      '2003-05-01',     1),

(     4111111111,        '��������',	   '����',			2,      '2002-06-02',     0),
(     4222222222,        '��������',	   '������',	    2,      '2002-07-03',     0),
(     4444444444,        '��������',	   '�����',			2,      '2002-09-04',     0),
(     4555555555,        '��������',	   '�����',		    2,      '2002-10-05',     0),
(     4666666666,        '��������',	   '�����',			2,      '2002-11-06',     0),
(     4777777777,        '��������',	   '������',		2,      '2001-12-07',     0),
(     4999999999,		 '��������',	   '������',		2,      '2001-01-08',     0),
(     4000000000,		 '��������',	   '�����',		    2,      '2001-02-09',     0),
(     4888888888,        '������',		   '������',		2,      '2001-03-10',     0),
(     4333333333,        '���������',	   '�����',		    2,      '2001-04-11',     0),

(     5111111111,        '������',		   '�����',			2,      '2002-05-12',     1),
(     5222222222,        '�������',		   '��������',		2,      '2002-06-13',     1),
(     5444444444,        '���������',	   '��������',		2,      '2002-07-14',     1),
(     5555555555,        '�������',		   '�������',		2,      '2002-08-15',     1),
(     5666666666,        '�����������',    '�����',			2,      '2002-09-16',     1),
(     5777777777,        '����������',     '�����',		    2,      '2001-10-17',     1),
(     5999999999,		 '������',		   '�������',	    2,      '2001-11-18',     1),
(     5000000000,		 '�������',		   '������',	    2,      '2001-12-19',     1),
(     5888888888,        '���������',      '���������',		2,      '2001-01-20',     1),
(     5333333333,        '�������',		   '�������',		2,      '2001-02-21',     1),

(     6111111111,        '����������',      '�����',	    2,      '2001-03-22',     0),
(     6222222222,        '��������',		'����',		    2,      '2001-04-23',     0),
(     6444444444,        '��������',		'�����',	    2,      '2001-05-24',     0),
(     6555555555,        '������������',    '�����',	    2,      '2001-06-25',     0),
(     6666666666,        '�����������',     '�����',	    2,      '2001-07-26',     0),
(     6777777777,        '��������',		'������',	    2,      '2002-08-27',     0),
(     6999999999,		 '��������',		'�����',	    2,      '2002-09-28',     0),
(     6000000000,		 '��������',		'����',			2,      '2002-10-29',     0),
(     6888888888,        '�����������',     '������',		2,      '2002-11-01',     0),
(     6333333333,        '����������',	    '������',	    2,      '2002-12-02',     0),

(     7111111111,        '���������',       '����',			3,      '2001-01-03',     1),
(     7222222222,        '������',		    '��������',		3,      '2001-02-04',     1),
(     7444444444,        '�����������',     '����',			3,      '2001-03-05',     1),
(     7555555555,        '��������',	    '���������',	3,      '2001-04-06',     1),
(     7666666666,        '�����',		    '�������',		3,      '2001-05-07',     1),
(     7777777777,        '����������',      '����',			3,      '2000-06-08',     1),
(     7999999999,		 '��������',	    '�����',		3,      '2000-07-09',     1),
(     7000000000,		 '������',		    '�����',		3,      '2000-08-10',     1),
(     7888888888,        '������',		    '������',		3,      '2000-09-11',     1),
(     7333333333,        '�������',		    '�����',		3,      '2000-10-12',     1),

(     8111111111,        '����������',	    '������',		3,      '2000-11-13',     0),
(     8222222222,        '���������',		'�������',		3,      '2000-12-14',     0),
(     8444444444,        '����������',	    '���',		    3,      '2000-01-14',     0),
(     8555555555,        '��������',	    '������',		3,      '2000-02-15',     0),
(     8666666666,        '������������',    '������',		3,      '2000-03-16',     0),
(     8777777777,        '���������',	    '�������',		3,      '1999-04-17',     0),
(     8999999999,		 '����������',	    '������',		3,      '1999-05-18',     0),
(     8000000000,		 '����������',	    '����',		    3,      '1999-06-19',     0),
(     8888888888,        '�������������',   '����',		    3,      '1999-07-20',     0),
(     8333333333,        '���������',		'����',			3,      '1999-08-21',     0),

(     9111111111,        '�������',			'���������',	4,      '1999-09-22',     1),
(     9222222222,        '������',			'���������',	4,      '1999-10-23',     1),
(     9444444444,        '���������',		'������',		4,      '1999-11-24',     1),
(     9555555555,        '����������',		'������',	    4,      '1999-12-25',     1),
(     9666666666,        '��������',		'�������',		4,      '1999-01-26',     1),
(     9777777777,        '����������',      '�������',		4,      '1998-02-27',     1),
(     9999999999,		 '��������',		'����',		    4,      '1998-03-28',     1),
(     9000000000,		 '�����������',     '������',	    4,      '1998-04-29',     1),
(     9888888888,        '�������',			'�����',		4,      '1998-05-01',     1),
(     9333333333,        '�������',			'�����������',  4,      '1998-06-02',     1),

(     0111111111,        '�����',			'�����',        4,      '1999-07-03',     0),
(     0222222222,        '��������',	    '�����',		4,      '1999-08-04',     0),
(     0444444444,        '�������',			'���',		    4,      '1999-09-05',     0),
(     0555555555,        '�����������',	    '�����',		4,      '1999-10-06',     0),
(     0666666666,        '�����',		    '�����',		4,      '1999-11-07',     0),
(     0777777777,        '��������',	    '�����',		4,      '1998-12-08',     0),
(     0999999999,		 '������',			'���������',    4,      '1998-01-09',     0),
(     0000000000,		 '�����������',     '����',			4,      '1998-02-10',     0),
(     0888888888,        '���������',	    '��������',     4,      '1998-03-11',     0),
(     0333333333,        '������',			'������',       4,      '1998-04-12',     0)
select @@ERROR as '������', @@rowcount as '���������� ���������'
SELECT @id_stud=@@IDENTITY



INSERT INTO LECTURERS 
(IIN, SURNAME, NAME, SEX, LEN_WORK, deg_LEC, pos_LEC, title_LEC) 
VALUES
(     142424242421,       '����������',      '�����',         1,	 30,	@id_deg,	@id_pos,	@id_title),
(     164646464641,       '�������',         '����',          1,	 12,	@id_deg,	@id_pos,	@id_title),
(     147474747471,       '�������',         '�����',         1,	 null,	@id_deg,	@id_pos,	@id_title),
(     101010101011,       '�������',         '�������',       1,	 20,	@id_deg,	@id_pos,	@id_title),
(     172727272721,       '��������',        '������',        1,	 5,		@id_deg,	@id_pos,	@id_title),

(     242424242420,       '��������',	     '�������',       0,	 8,		@id_deg,	@id_pos,	@id_title),
(     264646464640,       '���������',       '�����',         0,     32,	@id_deg,	@id_pos,	@id_title),
(     247474747470,       '���������',       '�����',         0,	 21,	@id_deg,	@id_pos,	@id_title),
(     201010101010,       '�������',         '�������',       0,	 35,	@id_deg,	@id_pos,	@id_title),
(     272727272720,       '��������',        '���������',     0,	 2,		@id_deg,	@id_pos,	@id_title),

(     323232323231,       '�������',		 '�������',		  1,	 17,	@id_deg,	@id_pos,	@id_title),
(     787878778781,       '���������',       '������',        1,	 15,	@id_deg,	@id_pos,	@id_title),
(     347474747471,       '������',          '�����',         1,	 27,	@id_deg,	@id_pos,	@id_title),
(     301010101011,       '�������',         '����',		  1,	 6,		@id_deg,	@id_pos,	@id_title),
(     372727272721,       '�����',			 '��������',      1,	 13,	@id_deg,	@id_pos,	@id_title)
select @@ERROR as '������', @@rowcount as '���������� ��������������'
SELECT @id_lec=@@IDENTITY

INSERT INTO DISCIPLINES
(NAME, HOURS_LEC, HOURS_PRAC, HOURS_SRS, LEC_DIS) 
VALUES
---------------------------------����--------------------------------------
(    '�������������-���������������� ����������',       100,	100,	40,		@id_lec),
(    '������������ �������',							100,	100,	40,		@id_lec),
(    '�������� ������������ �����������',				100,	100,	40,		@id_lec),
(    '������������ �������',							100,	100,	40,		@id_lec),
(    '������ ����������',								100,	100,	40,		@id_lec),
(    '��������������� ���������� ���������������',		100,	100,	40,		@id_lec),
(    'CAD/CAM ����������',								100,	100,	40,		@id_lec),
(    '���������, ��������� ������ � ����������������',	100,	100,	40,		@id_lec),
(    '������� � ���������� �������������� ������',		100,	100,	40,		@id_lec),
(    '���������������� ���������� � ��������',			100,	100,	40,		@id_lec),
---------------------------------���---------------------------------------
(    '����������� ������',								100,	100,	40,		@id_lec),
(    '��������������',									100,	100,	40,		@id_lec),
(    '��������������',									100,	100,	40,		@id_lec),
(    '�������',											100,	null,	40,		@id_lec),
(    '���������',										100,	null,	40,		@id_lec),
(    '������ ���������',								100,	null,	40,		@id_lec),
(    '������������',									100,	100,	40,		@id_lec),
(    '���������� ����',									100,	100,	40,		@id_lec),
(    '���������� ����� � ����������',					100,	null,	40,		@id_lec),
(    '�������������� ����',								100,	100,	40,		@id_lec),
---------------------------------���---------------------------------------
(    '������� � ��������� �����',						100,	null,	40,		@id_lec),
(    '�����������',										100,	null,	40,		@id_lec),
(    '�������������',									100,	null,	40,		@id_lec),
(    '������ ������������� ���������',					100,	null,	40,		@id_lec),
(    '��������� ������������� �����',					100,	null,	40,		@id_lec),
(    '������� ������������� ���������',					100,	null,	40,		@id_lec),
(    'Co��������',										100,	null,	40,		@id_lec),
(    '������������� �����������',						100,	null,	40,		@id_lec),
(    '������� �������� � ��I ����',						100,	null,	40,		@id_lec),
(    '���������������� ��������',						100,	100,	40,		@id_lec)
select @@ERROR as '������', @@rowcount as '���������� ���������'
SELECT @id_dis=@@IDENTITY

INSERT INTO STUD_DIS
(ID_STUD2, ID_DIS2) 
VALUES
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis),
(@id_stud, @id_dis)
select @@ERROR as '������',  @@rowcount as '���������� ������'




select *
from STUDENTS
where KURS like 2 
select *
from STUDENTS
where KURS not like 2 
select *
from STUDENTS
where KURS between 3 and 4
select *
from STUDENTS
where KURS not between 3 and 4
select *
from STUDENTS
where KURS in (2,4)
select *
from STUDENTS
where KURS not in (2,4)
select *
from STUDENTS
where NAME like '�%'
select *
from STUDENTS
where NAME not like '�%'
select *
from STUDENTS
where NAME in ('������','��������')
select *
from STUDENTS
where NAME not in ('������','��������')
--�	��������� ������ � �������� ����������� ����� ���������.
select *
from disciplines 
where exists (select * from lecturers) 



--------------------------------------------------------------
/*1)	�� ������ ������� ���������� ��� ���������� ������������ ������ �������� �������� 
���������, ��������� ������� ����� �������������� ��� ������ �������� � ���� ������ �
������� �������. ��������� ����������� ������ ���� ���������� ��������� �����, ��� ������ 
� ��������� �� ������;*/
create or alter proc adel
@i		int,
@errmes varchar(50) out,
@count	int			out,
@err	int			out,
@b1		smallint,
@b2		smallint,
@l		varchar(20),
@in1	smallint,
@in2	smallint

as
begin try
	if @i=1 begin
		select *
		from STUDENTS
		where KURS between @b1 and @b2
		goto E
	end
	if @i=2 begin
		select *
		from STUDENTS
		where KURS not between @b1 and @b2
		goto E
	end
	if @i=3 begin
		select *
		from STUDENTS
		where NAME like @l
		goto E
	end
	if @i=4 begin
		select *
		from STUDENTS
		where NAME not like @l
		goto E
	end
	if @i=5 begin
		select *
		from STUDENTS
		where KURS in (@in1,@in2)
		goto E
	end
	if @i=6 begin
		select *
		from STUDENTS
		where KURS not in (@in1,@in2)
		goto E
	end
	if @i=7 begin
		select SURNAME as '�������', NAME as '���', case
									when SEX=1 then '�������'
									when SEX=0 then '�������'
									end as '���'
		from STUDENTS
		goto E

	end else begin
		select @errmes = '�������� i ��� ���������'
	end
	E:
	select @count=@@ROWCOUNT
end try
begin catch
		select @err=ERROR_NUMBER()
	end catch


--2)	�������� �������� ��������� � ���� ������ � ��������� ��������� � ���, ������� ��������� �������� ��� ������� ���������� � ��� ����� � ������������;
declare @e int,
		@errmes varchar(50),
		@count	int,
		@err	int
--�������� � �� ��������� 
exec @e=adel 10, @errmes out, @count out, @err out, 1, 2,'�%', 3, 4
select @e, @count as '���������� �����', @err as '��� ������', @errmes as '������� ������'

exec @e=adel -1, @errmes out, @count out, @err out, 1, 2,'�%', 3, 4
select @e, @count as '���������� �����', @err as '��� ������', @errmes as '������� ������'

--���������� ��������
exec @e=adel 1, @errmes out, @count out, @err out, 1, 2, 0, 0, 0
select @e, @count as '���������� �����', @err as '��� ������', @errmes as '������� ������'

exec @e=adel 3, @errmes out, @count out, @err out, 0, 0,'�%', 0, 0
select @e, @count as '���������� �����', @err as '��� ������', @errmes as '������� ������'

exec @e=adel 5, @errmes out, @count out, @err out, 0, 0,0, 3, 4
select @e, @count as '���������� �����', @err as '��� ������', @errmes as '������� ������'

exec @e=adel 7, @errmes out, @count out, @err out, 0, 0, 0, 0, 0
select @e, @count as '���������� �����', @err as '��� ������', @errmes as '������� ������'

--3)	���������������� ������� � ������ � ��� � �������� ������� ����������� ��������� ��� ���������� ��� � �������� ��������; 
create or alter function gender
(@gender	tinyint)
returns varchar (10)
as
begin
	declare @name varchar(10)
	if @gender=1 select @name ='�������' else select @name = '�������'
	return @name
end

create or alter function HName
(@w varchar(60))
returns varchar (1)
as
begin
	declare @nam varchar(60)
	select @nam = UPPER(@w)
	return @nam
end


--4)	�������� ������� � ���� ������ � ������������ �� ��� ��� ���������� �������� � ���� ������ ��� � ��� ���;
select SURNAME AS '�������', NAME AS '���', SEX as '���'
from STUDENTS

select SURNAME AS '�������', NAME AS '���', dbo.GENDER(SEX) as '���'
from STUDENTS

select SURNAME AS '�������', NAME AS '���', SEX as '���'
from LECTURERS

select SURNAME AS '�������', NAME AS '���', dbo.GENDER(SEX) as '���'
from LECTURERS

SELECT Surname, dbo.HName(NAME) AS '���'
FROM STUDENTS

SELECT Surname, NAME AS '���'
FROM STUDENTS
--5)	������� ������� ��� ��������� �������� ��� ������� ������ � �������;
create or alter trigger pos_insert on position 
after insert
as
declare @name varchar(40)
select @name =name
from inserted
if @name= '��������' rollback tran

--������������ ������
insert into position
(name)
values
('��������')
--���������� ������
insert into position
(name)
values
('������')

drop trigger pos_insert
--6)	������� ������� ��� ��������� �������� ��� ������������� ������ � �������;
create or alter trigger pos_update on position 
after update
as
begin
	declare @name varchar(40)
	select @name =name
	from deleted
	if @name= '��������' rollback tran
end

--������������ ������
update position
set name ='�����'
where id_pos=1

--���������� ������
update position
set name ='�����'
where id_pos=2
drop trigger pos_update
--7)	������� ������� ��� ��������� �������� ��� �������� ������ � �������;
create or alter trigger pos_delete on position 
after delete 
as
begin
	declare @name varchar(40)
	select @name =name
	from deleted
	if @name= '��������' rollback tran
end

--������������ ������
delete  from position
where name ='��������'
--���������� ������
delete  from position
where name ='������'
drop trigger pos_delete
--8)	������� ������� ��� ��������� �������� ��� �������/�������������/�������� �������� ������ � ��������;
create trigger pos_al
on position
after UPDATE, INSERT, DELETE
as
declare @id_pos tinyint, @name varchar(20)
if exists(SELECT * from inserted) and exists (SELECT * from deleted)
begin
    SET @name = 'UPDATE';
  
    SELECT @id_pos  = id_pos from inserted i
    INSERT into position(id_pos,name) values (@id_pos,@name)
end

If exists (Select * from inserted) and not exists(Select * from deleted)
begin
    SET @name = 'INSERT';
    SELECT @id_pos  = id_pos from inserted i
	INSERT into position(id_pos,name) values (@id_pos,@name)
end

If exists(select * from deleted) and not exists(Select * from inserted)
begin 
    SET @name = 'DELETE';
    SELECT @id_pos  = id_pos from inserted i
	INSERT into position(id_pos,name) values (@id_pos,@name)
end

--������������ �������
delete  from position
where name ='��������'

update position
set name ='�����'
where id_pos=1

insert into position
(name)
values
('��������')

drop trigger pos_al

GO
USE master
GO
Drop database university
