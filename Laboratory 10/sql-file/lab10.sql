/* 1. Sa se modifice declansatorul inregistrare noua, in asa fel, incat in cazul actualizarii
auditoriului sa apara mesajul de informare, care, in afara de disciplina si ora, va afisa codul
grupei afectate, ziua, blocul, auditoriul vechi si auditoriul nou.*/

USE universitatea;
GO
IF OBJECT_ID('inregistrare_noua', 'TR') IS NOT NULL
DROP TRIGGER inregistrare_noua;
GO
Create TRIGGER inregistrare_noua ON orarul
after update
as
if UPDATE(Auditoriu)
	SELECT 'Lectia la discipilina "'+ UPPER(discipline.Disciplina)+'"de la ora '+ CAST(inserted.Ora as varchar(5))+
	' a fost transferara in aula '+ CAST(inserted.Auditoriu as char(3))
	FROM inserted Join discipline on inserted.Id_Disciplina=discipline.Id_Disciplina
GO

UPDATE orarul set Auditoriu=510 where Id_Profesor=108


/*2. Sa se creeze declansatorul, care ar asigura popularea corecta (consecutiva) a tabelelor studenti
si studenti_reusita, si ar permite evitarea erorilor la nivelul cheilor exteme.*/
USE universitatea;
GO
IF OBJECT_ID('Ex2', 'TR') IS NOT NULL
DROP TRIGGER Ex2;
GO
CREATE TRIGGER Ex2 ON studenti
INSTEAD OF INSERT
AS
SET NOCOUNT ON
DECLARE @Id_Student int
SELECT @Id_Student = Id_Student FROM inserted
INSERT INTO studenti_reusita(Id_Disciplina, Id_Grupa,Id_Student,Id_Profesor,Data_Evaluare,Tip_Evaluare,Nota) 
	VALUES (101,2,@Id_Student,105,'2018-12-01','Testul 3',8.00);
INSERT INTO studenti
SELECT * FROM inserted
GO
select * from studenti
INSERT INTO studenti VALUES(189,'Bors','Ion','1997-11-24','mun. Chisinau, str. Zadnipru, 24')


/*3. Sa se creeze un declansator, care ar interzice micsorarea notelor in tabelul studenti_reusita si
modificarea valorilor campului Data_Evaluare, unde valorile acestui camp sunt nenule.
Declansatorul trebuie sa se lanseze, numai daca sunt afectate datele studentilor din grupa
"CIB171". Se va afisa un mesaj de avertizare in cazul tentativei de a incalca constrangerea.*/

use universitatea
go
if OBJECT_ID('Ex3_1','TR') is not null 
	drop trigger ex3_1
	go
	create trigger ex3_1 on studenti_reusita
	after update
	as
	set nocount on
	DECLARE @N decimal(5,2)
	SET @N=(Select Nota from inserted)
	if (UPDATE(Nota)) and (@N<(Select distinct Nota from deleted where Id_Student=101))
		begin
		print 'Nu se permite de micsorat nota!!!'
		rollback;
		end
go

Update studenti_reusita set Nota=(select Nota where Id_Student=101)-1

use universitatea
go
if OBJECT_ID('Ex3_2','TR') is not null 
	drop trigger ex3_2
	go
	create trigger ex3_2 on studenti_reusita
	after update
	as 
	set nocount on
	if (UPDATE(Data_Evaluare)) and ((select Data_Evaluare from inserted ) is null)
		begin 
		PRINT 'Tentativa de modificare a Datei de evaluare care are valorare null'
		ROLLBACK;
	end
go

Update studenti_reusita set Data_Evaluare='2019-12-03' where Data_Evaluare is null

/*4. Sa se creeze un declansator DDL care ar interzice modificarea coloanei 
Id_Disciplina in
tabelele bazei de date universitatea cu afisarea mesajului respectiv.*/

USE universitatea
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE parent_class=0 AND name='Ex4')
DROP TRIGGER Ex4 ON DATABASE;
GO
CREATE TRIGGER Ex4
ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @Id_Disciplina int
SELECT @Id_Disciplina=EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]', 'nvarchar(max)')
IF @Id_Disciplina='Id_Disciplina'
BEGIN
PRINT('Nu poate fi modificata coloana Id_Disciplina');
ROLLBACK;
END
go

use universitatea
go 
alter table discipline alter column Id_Disciplina varchar(30)

/*5. Sa se creeze un declansator DDL care ar interzice modificarea schemei bazei de date in afara
orelor de lucru.*/

USE universitatea
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE parent_class=0 AND name='Ex5')
DROP TRIGGER Ex5 ON DATABASE;
GO
CREATE TRIGGER Ex5 ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @TimpulCurent DATETIME
DECLARE @LucruIncep DATETIME
DECLARE @LucruSf DATETIME
DECLARE @A FLOAT
DECLARE @B FLOAT
SELECT @TimpulCurent = GETDATE()
SELECT @LucruIncep = '2018-12-28 9:00:00.000'
SELECT @LucruSf = '2018-12-28 18:00:00.000'
SELECT @A =(cast(@TimpulCurent as float) - floor(cast(@TimpulCurent as float)))-
(cast(@LucruIncep as float) - floor(cast(@LucruIncep as FLOAT))),
@B = (cast(@TimpulCurent as float) - floor(cast(@TimpulCurent as float))) -
(cast(@LucruSf as float) - floor(cast(@LucruSf as FLOAT)))
IF @A<0 OR @B>0
BEGIN
Print ('Înafara orelor de lucru nu poate fi modificată baza de date')
ROLLBACK
END
go

use universitatea 
go
alter table studenti alter column Nume_Student varchar(50);


/*6. Sa se creeze un declansator DDL care, la modificarea proprietatilor coloanei Id_Profesor
dintr-un tabel, ar face schimbari asemanatoare in mod automat in restul tabelelor.*/

USE universitatea
GO
IF EXISTS (SELECT * FROM sys.triggers WHERE parent_class=0 AND name='Ex_6')
DROP TRIGGER Ex_6 ON DATABASE;
GO
CREATE TRIGGER Ex_6 ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @id int
DECLARE @int_I varchar(500)
DECLARE @int_M varchar(500)
DECLARE @den_T varchar(50)
SELECT @id=EVENTDATA().
value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]','nvarchar(max)')
IF @id = 'Id_Profesor'
BEGIN
SELECT @int_I = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)')
SELECT @den_T = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)')
SELECT @int_M = REPLACE(@int_I, @den_T, 'studenti_reusita');EXECUTE (@int_M)
SELECT @int_M = REPLACE(@int_I, @den_T, 'grupe');EXECUTE (@int_M)
PRINT 'Datele au fost modificate'
END
go

use universitatea
alter table profesori alter column Id_Profesor smallint