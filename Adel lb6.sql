Create database university
Go
USE university                                          
Go
-- Первая часть
create table STUDENTS                             -- Создание таблицы студенты
(
  ID_STUD       smallint	primary key		identity	not null,
  IIN           char(12)				 not null	unique,-- иин студента,
  SURNAME       varchar(30)			     not null,-- фамилия студента,
  NAME          varchar(30)				 not null,-- имя студента,
  KURS          tinyint				   	 not null   check(kurs>0 and kurs<=4),-- курс, на котором учится студент,
  DATEBIRTH     date    				 not null,-- дата рождения студента
  SEX           bit						 not null,-- пол студента
  RW            rowversion
)
create table DISCIPLINES						  -- Создание таблицы дисциплины
(
  ID_DIS        smallint	primary key		identity	not null,
  NAME			varchar(50)			     not null,-- наименование предмета обучения,
  HOURS_LEC		tinyint				     not null,-- количество часов, отводимых на лекцию,
  HOURS_PRAC	tinyint,						  -- количество часов, отводимых на практику,
  HOURS_SRS	    tinyint					 not null,--количество часов, отводимых на СРС,  
  LEC_DIS		smallint				 not null,
  RW            rowversion
)
create table LECTURERS							  -- Создание таблицы преподавателей
(
  ID_LEC        smallint	primary key		identity	not null,
  IIN           char(12)                 not null	unique,-- ИИН преподавателя,
  SURNAME       varchar(30)              not null,-- фамилия преподавателя,
  NAME          varchar(50)              not null,-- имя преподавателя,
  SEX           bit                      not null,-- пол преподавателя,
  LEN_WORK		smallint	default('Нет опыта работы'), -- стаж работы				
  deg_LEC		smallint				 not null,
  pos_LEC		smallint				 not null,
  title_LEC		smallint				 not null,
  RW            rowversion
)

create table degree								  -- Создание таблицы ученная степень 
(
  id_deg	    smallint	primary key		identity	not null,
  name			varchar(40)			     not null,-- тип академической степени
  rw            rowversion
)
create table position							  -- Создание таблицы академическая должность 
(
  id_pos        smallint	primary key		identity	not null,
  name			varchar(40)              not null,-- название академической должности 
  rw            rowversion
)
create table title								  -- Создание таблицы ученое звание 
(
  id_title      smallint	primary key		identity	not null,
  name			varchar(40)              not null,-- название звания 
  rw            rowversion
)
create table STUD_DIS							  -- Создание таблицы для связи M:N 
(
  ID_STUD2      smallint,
  ID_DIS2       smallint,
  rw            rowversion
)


--Cоздание вторичных ключей
alter table STUD_DIS	add constraint	stud
foreign key (ID_STUD2)	references STUDENTS		(ID_STUD)

alter table STUD_DIS	add constraint	dis
foreign key (ID_DIS2)	references DISCIPLINES  (ID_DIS)

alter table DISCIPLINES add  constraint LEC_DIS   --связь преподаватель дисциплины 1:N 
foreign key (LEC_DIS)	references LECTURERS	(ID_LEC)

alter table LECTURERS	add constraint	deg_LEC	  --связь научная степень преподаватели  1:N
foreign key (deg_LEC)	references degree		(id_deg)

alter table LECTURERS	add constraint	pos_LEC	  --связь академическая должность преподаватели  1:N
foreign key (pos_LEC)	references position		(id_pos)

alter table LECTURERS	add constraint	title_LEC --связь ученное звание преподаватели  1:N
foreign key (title_LEC) references title		(id_title)


--Cоздание индексов для вторичных ключей
create index STUD_DIS	on STUD_DIS		(ID_STUD2)
create index LEC_DIS	on DISCIPLINES	(LEC_DIS)	
create index deg_LEC	on LECTURERS	(deg_LEC)	
create index pos_LEC	on LECTURERS	(pos_LEC)	
create index title_LEC	on LECTURERS	(title_LEC)	
--Cоздание индексов для столбцов не содержащих ключей 
create index SURNAME_LEC	on LECTURERS	(SURNAME)
create index SURNAME_STUD	on STUDENTS		(SURNAME)
create index NAME_DIS		on DISCIPLINES	(NAME)


--Заполнение таблиц данными
declare	 @id_stud	tinyint
declare	 @id_dis	tinyint
declare	 @id_lec	tinyint
declare	 @id_deg	tinyint
declare	 @id_pos	tinyint
declare	 @id_title	tinyint

INSERT INTO Degree 
(name) 
VALUES
(	  'Кандидат наук'							),
(	  'Доктор наук'								),
(	  'Бакалавр'								),
(	  'Магистр'									),
(	  'Доктор философии'						)
select @@ERROR as 'Ошибки', @@rowcount as 'количество степеней'
SELECT @id_deg=@@IDENTITY

INSERT INTO position
(name) 
VALUES
(	  'Аспирант'								),
(	  'Ассистент'								),
(	  'Ведущий научный сотрудник'				),
(	  'Главный научный сотрудник'				),
(	  'Докторант'								),
(	  'Доцент'									),
(	  'Младший научный сотрудник'				)
select @@ERROR as 'Ошибки', @@rowcount as 'количество академических должностей'
SELECT @id_pos=@@IDENTITY

INSERT INTO Title 
(name) 
VALUES
(	  'Доцент'									),
(	  'Профессор'								),
(	  'Член-корреспондент Академии наук'		),
(	  'Член Академии наук'						)
select @@ERROR as 'Ошибки', @@rowcount as 'количество званий'
SELECT @id_title=@@IDENTITY

INSERT INTO STUDENTS 
(IIN, SURNAME, NAME, KURS, DATEBIRTH, SEX) 
VALUES
(     1111111111,        'Иванов',		   'Иван',			1,      '2003-01-01',     1),
(     1222222222,        'Петров',		   'Петр',			1,      '2003-02-02',     1),
(     1444444444,        'Кузнецов',	   'Борис',		    1,      '2003-03-03',     1),
(     1555555555,        'Зайцев',		   'Олег',		    1,      '2003-04-04',     1),
(     1666666666,        'Павлов',	       'Андрей',	    1,      '2003-05-05',     1),
(     1777777777,        'Котов',		   'Павел',			1,      '2002-06-06',     1),
(     1999999999,		 'Петров',		   'Антон',			1,      '2002-07-07',     1),
(     1000000000,		 'Белкин',		   'Вадим',			1,      '2002-08-08',     1),
(     1888888888,        'Лукин',		   'Артем',		    1,      '2002-09-09',     1),
(     1333333333,        'Сидоров',		   'Вадим',		    1,      '2002-10-10',     1),

(     2111111111,        'Абаева',		   'Аня',			1,      '2003-11-11',     0),
(     2222222222,        'Андреева',	   'Яна',			1,      '2003-12-12',     0),
(     2444444444,        'Асанова',		   'Анастасия',		1,      '2003-01-13',     0),
(     2555555555,        'Бабакова',	   'Оливия',		1,      '2003-02-14',     0),
(     2666666666,        'Бажанова',	   'Мира',			1,      '2003-03-15',     0),
(     2777777777,        'Бейсенова',	   'Анна',			1,      '2003-04-16',     0),
(     2999999999,		 'Берикбол',	   'Жанна',			1,      '2002-05-17',     0),
(     2000000000,		 'Белкина',		   'Александра',	1,      '2002-06-18',     0),
(     2888888888,        'Лукина',		   'Артемида',		1,      '2002-07-19',     0),
(     2333333333,        'Сидорова',	   'Василия',	    1,      '2002-08-20',     0),

(     3111111111,        'Бейсенгазы',	   'Василий',		1,      '2002-01-21',     1),
(     3222222222,        'Берикбаев',	   'Кирилл',		1,      '2002-09-22',     1),
(     3444444444,        'Кудрявцев',	   'Максим',		1,      '2002-10-23',     1),
(     3555555555,        'Замиров',		   'Альби',			1,      '2002-11-24',     1),
(     3666666666,        'Егоров',	       'Азамат',		1,      '2002-12-25',     1),
(     3777777777,        'Максимов',	   'Егор',			1,      '2003-01-26',     1),
(     3999999999,		 'Прохоров',       'Азербай',	    1,      '2003-02-27',     1),
(     3000000000,		 'Азаматов',       'Телкозы',		1,      '2003-03-28',     1),
(     3888888888,        'Ломинов',		   'Амир',			1,      '2003-04-29',     1),
(     3333333333,        'Сериков',        'Алим',			1,      '2003-05-01',     1),

(     4111111111,        'Самарова',	   'Даша',			2,      '2002-06-02',     0),
(     4222222222,        'Дмитрова',	   'Камила',	    2,      '2002-07-03',     0),
(     4444444444,        'Смерцева',	   'Адель',			2,      '2002-09-04',     0),
(     4555555555,        'Забилова',	   'Асель',		    2,      '2002-10-05',     0),
(     4666666666,        'Салинова',	   'Анель',			2,      '2002-11-06',     0),
(     4777777777,        'Ходилова',	   'Данель',		2,      '2001-12-07',     0),
(     4999999999,		 'Кушакова',	   'Жанель',		2,      '2001-01-08',     0),
(     4000000000,		 'Доминова',	   'Ольга',		    2,      '2001-02-09',     0),
(     4888888888,        'Лукиан',		   'Мелиса',		2,      '2001-03-10',     0),
(     4333333333,        'Малвинова',	   'Жания',		    2,      '2001-04-11',     0),

(     5111111111,        'Павлов',		   'Тимур',			2,      '2002-05-12',     1),
(     5222222222,        'Ильясов',		   'Темирлан',		2,      '2002-06-13',     1),
(     5444444444,        'Валиханов',	   'Тамирлан',		2,      '2002-07-14',     1),
(     5555555555,        'Бегалин',		   'Жасулан',		2,      '2002-08-15',     1),
(     5666666666,        'Абдрахманов',    'Аслан',			2,      '2002-09-16',     1),
(     5777777777,        'Альжапаров',     'Архат',		    2,      '2001-10-17',     1),
(     5999999999,		 'Тлеуов',		   'Дмитрий',	    2,      '2001-11-18',     1),
(     5000000000,		 'Халыков',		   'Прохор',	    2,      '2001-12-19',     1),
(     5888888888,        'Ибрагимов',      'Александр',		2,      '2001-01-20',     1),
(     5333333333,        'Сабыров',		   'Аркадий',		2,      '2001-02-21',     1),

(     6111111111,        'Жанпеисова',      'Дания',	    2,      '2001-03-22',     0),
(     6222222222,        'Искакова',		'Дина',		    2,      '2001-04-23',     0),
(     6444444444,        'Идрисова',		'Диана',	    2,      '2001-05-24',     0),
(     6555555555,        'Молдахметова',    'Даяна',	    2,      '2001-06-25',     0),
(     6666666666,        'Жаксылыкова',     'Алиса',	    2,      '2001-07-26',     0),
(     6777777777,        'Ахметова',		'Ксения',	    2,      '2002-08-27',     0),
(     6999999999,		 'Какимова',		'Лилия',	    2,      '2002-09-28',     0),
(     6000000000,		 'Касымова',		'Лола',			2,      '2002-10-29',     0),
(     6888888888,        'Байсалбаева',     'Лариса',		2,      '2002-11-01',     0),
(     6333333333,        'Шаяхметова',	    'Полина',	    2,      '2002-12-02',     0),

(     7111111111,        'Сагинтаев',       'Марк',			3,      '2001-01-03',     1),
(     7222222222,        'Байбек',		    'Владимир',		3,      '2001-02-04',     1),
(     7444444444,        'Суханберлин',     'Влад',			3,      '2001-03-05',     1),
(     7555555555,        'Ерканова',	    'Владислав',	3,      '2001-04-06',     1),
(     7666666666,        'Мамин',		    'Валерий',		3,      '2001-05-07',     1),
(     7777777777,        'Сагындыков',      'Омар',			3,      '2000-06-08',     1),
(     7999999999,		 'Шайкенов',	    'Асман',		3,      '2000-07-09',     1),
(     7000000000,		 'Омаров',		    'Оспан',		3,      '2000-08-10',     1),
(     7888888888,        'Смаков',		    'Кайрат',		3,      '2000-09-11',     1),
(     7333333333,        'Орманов',		    'Керей',		3,      '2000-10-12',     1),

(     8111111111,        'Войцовская',	    'Карина',		3,      '2000-11-13',     0),
(     8222222222,        'Джакупова',		'Калиман',		3,      '2000-12-14',     0),
(     8444444444,        'Дюсенбаева',	    'Зоя',		    3,      '2000-01-14',     0),
(     8555555555,        'Еркенова',	    'Зарина',		3,      '2000-02-15',     0),
(     8666666666,        'Жолдаспекова',    'Ульяна',		3,      '2000-03-16',     0),
(     8777777777,        'Жолдасова',	    'Томирис',		3,      '1999-04-17',     0),
(     8999999999,		 'Жумадилова',	    'Аружан',		3,      '1999-05-18',     0),
(     8000000000,		 'Ибрагимова',	    'Аиша',		    3,      '1999-06-19',     0),
(     8888888888,        'Ипмагамбетова',   'Айша',		    3,      '1999-07-20',     0),
(     8333333333,        'Исмаилова',		'Роза',			3,      '1999-08-21',     0),

(     9111111111,        'Коппель',			'Светослав',	4,      '1999-09-22',     1),
(     9222222222,        'Крахин',			'Святослав',	4,      '1999-10-23',     1),
(     9444444444,        'Кульбеков',		'Никита',		4,      '1999-11-24',     1),
(     9555555555,        'Кунупиянов',		'Норман',	    4,      '1999-12-25',     1),
(     9666666666,        'Кайратов',		'Николай',		4,      '1999-01-26',     1),
(     9777777777,        'Ралмырзаев',      'Нариман',		4,      '1998-02-27',     1),
(     9999999999,		 'Нурметов',		'Асан',		    4,      '1998-03-28',     1),
(     9000000000,		 'Лукьянчиков',     'Алишер',	    4,      '1998-04-29',     1),
(     9888888888,        'Макаров',			'Альби',		4,      '1998-05-01',     1),
(     9333333333,        'Малышев',			'Абильмансур',  4,      '1998-06-02',     1),

(     0111111111,        'Манен',			'Аяжан',        4,      '1999-07-03',     0),
(     0222222222,        'Маратова',	    'Айжан',		4,      '1999-08-04',     0),
(     0444444444,        'Масанчи',			'Айя',		    4,      '1999-09-05',     0),
(     0555555555,        'Маханбетова',	    'Амина',		4,      '1999-10-06',     0),
(     0666666666,        'Медеу',		    'Алина',		4,      '1999-11-07',     0),
(     0777777777,        'Морозова',	    'Мария',		4,      '1998-12-08',     0),
(     0999999999,		 'Омірбек',			'Маргарита',    4,      '1998-01-09',     0),
(     0000000000,		 'Потехинская',     'Баян',			4,      '1998-02-10',     0),
(     0888888888,        'Прилукова',	    'Бибигуль',     4,      '1998-03-11',     0),
(     0333333333,        'Ракова',			'Фатима',       4,      '1998-04-12',     0)
select @@ERROR as 'Ошибки', @@rowcount as 'количество студентов'
SELECT @id_stud=@@IDENTITY



INSERT INTO LECTURERS 
(IIN, SURNAME, NAME, SEX, LEN_WORK, deg_LEC, pos_LEC, title_LEC) 
VALUES
(     142424242421,       'Колесников',      'Борис',         1,	 30,	@id_deg,	@id_pos,	@id_title),
(     164646464641,       'Никонов',         'Иван',          1,	 12,	@id_deg,	@id_pos,	@id_title),
(     147474747471,       'Лагутин',         'Павел',         1,	 null,	@id_deg,	@id_pos,	@id_title),
(     101010101011,       'Струков',         'Николай',       1,	 20,	@id_deg,	@id_pos,	@id_title),
(     172727272721,       'Николаев',        'Виктор',        1,	 5,		@id_deg,	@id_pos,	@id_title),

(     242424242420,       'Адабаева',	     'Гульшат',       0,	 8,		@id_deg,	@id_pos,	@id_title),
(     264646464640,       'Аимронова',       'Лязат',         0,     32,	@id_deg,	@id_pos,	@id_title),
(     247474747470,       'Михаилова',       'Елена',         0,	 21,	@id_deg,	@id_pos,	@id_title),
(     201010101010,       'Дадаева',         'Татьяна',       0,	 35,	@id_deg,	@id_pos,	@id_title),
(     272727272720,       'Дятелева',        'Бахытгуль',     0,	 2,		@id_deg,	@id_pos,	@id_title),

(     323232323231,       'Федоров',		 'Тимофей',		  1,	 17,	@id_deg,	@id_pos,	@id_title),
(     787878778781,       'Караханов',       'Азамат',        1,	 15,	@id_deg,	@id_pos,	@id_title),
(     347474747471,       'Дубров',          'Павел',         1,	 27,	@id_deg,	@id_pos,	@id_title),
(     301010101011,       'Сатиров',         'Олег',		  1,	 6,		@id_deg,	@id_pos,	@id_title),
(     372727272721,       'Алиев',			 'Темирлан',      1,	 13,	@id_deg,	@id_pos,	@id_title)
select @@ERROR as 'Ошибки', @@rowcount as 'количество преподавателей'
SELECT @id_lec=@@IDENTITY

INSERT INTO DISCIPLINES
(NAME, HOURS_LEC, HOURS_PRAC, HOURS_SRS, LEC_DIS) 
VALUES
---------------------------------ФИИТ--------------------------------------
(    'Информационно-коммуникационные технологии',       100,	100,	40,		@id_lec),
(    'Операционные системы',							100,	100,	40,		@id_lec),
(    'Качество программного обеспечения',				100,	100,	40,		@id_lec),
(    'Операционные системы',							100,	100,	40,		@id_lec),
(    'Высшая математика',								100,	100,	40,		@id_lec),
(    'Мультимодальные технологии транспортировки',		100,	100,	40,		@id_lec),
(    'CAD/CAM Технологии',								100,	100,	40,		@id_lec),
(    'Алгоритмы, структуры данных и программирование',	100,	100,	40,		@id_lec),
(    'Техники и технологии распределенных систем',		100,	100,	40,		@id_lec),
(    'Теплотехнические устройства и процессы',			100,	100,	40,		@id_lec),
---------------------------------ФЭП---------------------------------------
(    'Электронный бизнес',								100,	100,	40,		@id_lec),
(    'Микроэкономика',									100,	100,	40,		@id_lec),
(    'Макроэкономика',									100,	100,	40,		@id_lec),
(    'Финансы',											100,	null,	40,		@id_lec),
(    'Маркетинг',										100,	null,	40,		@id_lec),
(    'Основы экономики',								100,	null,	40,		@id_lec),
(    'Эконометрика',									100,	100,	40,		@id_lec),
(    'Банковское дело',									100,	100,	40,		@id_lec),
(    'Финансовые рынки и посредники',					100,	null,	40,		@id_lec),
(    'Управленческий учет',								100,	100,	40,		@id_lec),
---------------------------------ФМП---------------------------------------
(    'История и философия науки',						100,	null,	40,		@id_lec),
(    'Политология',										100,	null,	40,		@id_lec),
(    'Культурология',									100,	null,	40,		@id_lec),
(    'Теория международных отношений',					100,	null,	40,		@id_lec),
(    'Публичное международное право',					100,	null,	40,		@id_lec),
(    'История международных отношений',					100,	null,	40,		@id_lec),
(    'Coциология',										100,	null,	40,		@id_lec),
(    'Международные организации',						100,	null,	40,		@id_lec),
(    'Мировая политика в ХХI веке',						100,	null,	40,		@id_lec),
(    'Производственная практика',						100,	100,	40,		@id_lec)
select @@ERROR as 'Ошибки', @@rowcount as 'количество дисциплин'
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
select @@ERROR as 'Ошибки',  @@rowcount as 'количество связей'




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
where NAME like 'А%'
select *
from STUDENTS
where NAME not like 'А%'
select *
from STUDENTS
where NAME in ('Данель','Владимир')
select *
from STUDENTS
where NAME not in ('Данель','Владимир')
--•	используя запрос с условием реализуемым через подзапрос.
select *
from disciplines 
where exists (select * from lecturers) 



--------------------------------------------------------------
/*1)	На основе выборок написанных для предыдущей лабораторной работы написать хранимую 
процедуру, параметры которой будут использоваться для выбора запросов к базе данных и
условий выборки. Выходными параметрами должны быть количество выбранных строк, код ошибки 
и сообщение об ошибке;*/
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
		select SURNAME as 'Фамилия', NAME as 'Имя', case
									when SEX=1 then 'мужчина'
									when SEX=0 then 'женщина'
									end as 'Пол'
		from STUDENTS
		goto E

	end else begin
		select @errmes = 'значение i вне диапозона'
	end
	E:
	select @count=@@ROWCOUNT
end try
begin catch
		select @err=ERROR_NUMBER()
	end catch


--2)	Записать хранимую процедуру в базу данных и выполнить обращение к ней, задавая различные значения для входных параметров в том числе и некорректные;
declare @e int,
		@errmes varchar(50),
		@count	int,
		@err	int
--значение в не диапазона 
exec @e=adel 10, @errmes out, @count out, @err out, 1, 2,'А%', 3, 4
select @e, @count as 'количество строк', @err as 'код ошибки', @errmes as 'причина ошибки'

exec @e=adel -1, @errmes out, @count out, @err out, 1, 2,'А%', 3, 4
select @e, @count as 'количество строк', @err as 'код ошибки', @errmes as 'причина ошибки'

--корректные значения
exec @e=adel 1, @errmes out, @count out, @err out, 1, 2, 0, 0, 0
select @e, @count as 'количество строк', @err as 'код ошибки', @errmes as 'причина ошибки'

exec @e=adel 3, @errmes out, @count out, @err out, 0, 0,'А%', 0, 0
select @e, @count as 'количество строк', @err as 'код ошибки', @errmes as 'причина ошибки'

exec @e=adel 5, @errmes out, @count out, @err out, 0, 0,0, 3, 4
select @e, @count as 'количество строк', @err as 'код ошибки', @errmes as 'причина ошибки'

exec @e=adel 7, @errmes out, @count out, @err out, 0, 0, 0, 0, 0
select @e, @count as 'количество строк', @err as 'код ошибки', @errmes as 'причина ошибки'

--3)	Проанализировать таблицы и данные в них и написать функции выполняющие обработку как символьных так и числовых значений; 
create or alter function gender
(@gender	tinyint)
returns varchar (10)
as
begin
	declare @name varchar(10)
	if @gender=1 select @name ='мужчина' else select @name = 'женщина'
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


--4)	Записать функции в базу данных и использовать их как при выполнении запросов к базе данных так и без них;
select SURNAME AS 'Фамилия', NAME AS 'Имя', SEX as 'пол'
from STUDENTS

select SURNAME AS 'Фамилия', NAME AS 'Имя', dbo.GENDER(SEX) as 'пол'
from STUDENTS

select SURNAME AS 'Фамилия', NAME AS 'Имя', SEX as 'пол'
from LECTURERS

select SURNAME AS 'Фамилия', NAME AS 'Имя', dbo.GENDER(SEX) as 'пол'
from LECTURERS

SELECT Surname, dbo.HName(NAME) AS 'ИМЯ'
FROM STUDENTS

SELECT Surname, NAME AS 'ИМЯ'
FROM STUDENTS
--5)	Создать триггер для обработки значений при вставке данных в таблицы;
create or alter trigger pos_insert on position 
after insert
as
declare @name varchar(40)
select @name =name
from inserted
if @name= 'Директор' rollback tran

--неправильный запрос
insert into position
(name)
values
('Директор')
--правильный запрос
insert into position
(name)
values
('Ректор')

drop trigger pos_insert
--6)	Создать триггер для обработки значений при корректировке данных в таблицы;
create or alter trigger pos_update on position 
after update
as
begin
	declare @name varchar(40)
	select @name =name
	from deleted
	if @name= 'Аспирант' rollback tran
end

--неправильный запрос
update position
set name ='Декан'
where id_pos=1

--правильный запрос
update position
set name ='Декан'
where id_pos=2
drop trigger pos_update
--7)	Создать триггер для обработки значений при удалении данных в таблицы;
create or alter trigger pos_delete on position 
after delete 
as
begin
	declare @name varchar(40)
	select @name =name
	from deleted
	if @name= 'Аспирант' rollback tran
end

--неправильный запрос
delete  from position
where name ='Аспирант'
--правильный запрос
delete  from position
where name ='Доцент'
drop trigger pos_delete
--8)	Создать триггер для обработки значений при вставке/корректировке/удалении значений данных в таблицах;
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

--неправильные запросы
delete  from position
where name ='Аспирант'

update position
set name ='Декан'
where id_pos=1

insert into position
(name)
values
('Аспирант')

drop trigger pos_al

GO
USE master
GO
Drop database university
