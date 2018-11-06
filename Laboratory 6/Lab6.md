# Laboratorul nr. 6

## Crearea tabelelor si indecsilor


Sarcini:

1. Sa se scrie o intructiune T-SQL, care ar popula coloana Adresa_Postala_Profesor
din tabelul profesori cu valoarea 'mun.Chisinau', unde adresa este necunoscuta.

Interogarea:

``` sql
UPDATE profesori SET Adresa_Postala_Profesor='mun.Chisinau' where Adresa_Postala_Profesor is Null; 
Select * from profesori  
```

Rezultat:

![Task-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-1.PNG)

2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarele cerinte:
a) Campul Cod_Grupa sa accepte numai valorile unice si sa nu accepte valori necunoscute.
b) Sa se tina cont ca cheia primara, deja, este definita asupra coloanei Id_Grupa 

Interogarea:

``` sql
Alter table grupe 
alter column Cod_Grupa varchar(10) Not null 

Alter table grupe 
add Unique(Cod_Grupa,Id_Grupa)

select * from grupe
```

Rezultat:

![Task-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-2.PNG)

3. La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa si Prof_Indrumator, ambele de tip Int.
Sa se populeze campurile nou-create cu cele mai potrivite candidaturi in baza criteriilor de mai jos.

a) Seful grupei trebuie sa aiba cea mai buna reusita (media) din grupa la toate formele de evaluare
si la toate disciplinile. Un student nu poate fi sef de grupa la mai multe grupe.

b) Profesorul indrumator trebuie sa predea un numar maximal posibil de disciplina la grupa data.
Daca nu exista o singura candidatura, care corespunde primei cerinte, atunci este ales din grupul de candidati
acel cu identificatorul (Id_Profesor) minimal. Un profesor nu poate fi indrumator la mai multe grupe.

c) Sa se scire instructiuile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor in tabelul
grupe, pentru selectarea candidatilor si inserarea datelor. 

Interogarea:

``` sql
ALTER TABLE grupe
ADD Sef_Grupa int,Prof_Indrumator int;

DECLARE c1 CURSOR FOR 
SELECT id_grupa FROM grupe 

DECLARE @gid int
  ,@sid int
  ,@pid int

OPEN c1
FETCH NEXT FROM c1 into @gid 
WHILE @@FETCH_STATUS = 0
BEGIN
SELECT TOP 1 @sid=id_student
 FROM studenti_reusita
 WHERE id_grupa = @gid and Id_Student NOT IN (SELECT isnull(sef_grupa,'') FROM grupe)
 GROUP BY id_student
 ORDER BY cast(avg (NOTA*1.0)as decimal(5,2)) DESC

SELECT TOP 1 @pid=id_profesor
    FROM studenti_reusita
    WHERE id_grupa = @gid AND Id_profesor NOT IN (SELECT isnull (prof_indrumator, '') FROM grupe)
    GROUP BY id_profesor
    ORDER BY count (DISTINCT id_disciplina) DESC, id_profesor

UPDATE grupe
  SET   sef_grupa = @sid
    ,prof_indrumator = @pid
WHERE Id_Grupa=@gid
FETCH NEXT FROM c1 into @gid 
END
CLOSE c1
DEALLOCATE c1

Select *
from grupe
```

Rezultat:

![Task-3](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-3(1).PNG)
![Task-3](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-3(2).PNG)


4. Sa se scrie o instructiune T-SQL, care ar mari toate notele de evaluare sefilor de grupe cu un punct
Nota maximala (10) nu poate fi marita.

Interogarea:

``` sql
DECLARE @ID_1 int, @ID_2 int, @ID_3 int;
SET @ID_1=(SELECT TOP 1 Sef_grupa FROM grupe)
SET @ID_2=(SELECT TOP 1 Sef_grupa FROM grupe 
               WHERE Sef_grupa IN(SELECT TOP 2 Sef_grupa FROM grupe
				  ORDER BY Sef_grupa ASC)
               ORDER BY Sef_grupa DESC)
SET @ID_3=(SELECT TOP 1 Sef_grupa FROM grupe 
               WHERE Sef_grupa IN (SELECT top 3 Sef_grupa FROM grupe
				   ORDER BY Sef_grupa asc)
	       ORDER BY Sef_grupa DESC)
UPDATE studenti_reusita SET 
	Nota=Nota+1 
	WHERE Id_Student IN(@ID_1, @ID_2, @ID_3) AND Nota!=10 

SELECT * FROM studenti_reusita
```

Rezultat:

![Task-4](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-4.PNG)

5. Sa se creeze un tabel profesori_new, care include urmatoarele coloane: Id_Profesor, Nume_Profesor,
Prenume_Profesor, Localitate, Adresa_1, Adresa_2.

a) Coloana Id_Profesor trebuie sa fie definita drept cheie primara si, in baza ei, sa fie constuit un index 
CLUSTERED.
b) Cimpul localitate treebuie sa posede proprietatea DEFAULT='mun.Chisinau'.
c) Sa se insereze toate datele din tabelul profesori in tabelul profesori_new. Sa se scrie cu acest scop un 
numar potrivit de instructiuni T-SQL. Datele trebuie sa fie transferate in felul urmator

|Coloana-sursa|Coloana-destinatie|
|Id_Profesor|Id_Profesor|
|Nume_Profesor|Nume_Profesor|
|Prenume_Profesor|Prenume_Profesor|
|Adresa_Postala_Profesor|Localitate|
|Adresa_Postala_Profesor|Adresa 1|
|Adresa_Postala_Profesor|Adresa 2|

In coloana Localitate sa fie inserata doar informatia despre denumirea localitatii din coloana-sursa
Adresa_Postala_Profesor. In coloana Adresa_1, doar denumirea strazii. In coloana Adresa_2,
sa se pastreze numarul casei si (posibil) a apartamentului.

Interogarea:

``` sql
/*
create table profesori_new(
	Id_Profesor int not null,
	Nume_Profesor varchar(255) not null,
	Prenume_Profesor varchar(255) not null,
	Localitate varchar(255) default('mun.Chisinau'),
	Adresa_1 varchar(60),
	Adresa_2 varchar(60),
	CONSTRAINT [PK_profesori_new] PRIMARY KEY CLUSTERED (Id_Profesor )
);
*/

CREATE FUNCTION INSTR(@str VARCHAR(8000), @substr VARCHAR(255), @start INT, @occurrence INT)
  RETURNS INT
  AS
  BEGIN
	DECLARE @found INT = @occurrence,
			@pos INT = @start;
 
	WHILE 1=1 
	BEGIN
		-- Find the next occurrence
		SET @pos = CHARINDEX(@substr, @str, @pos);
 
		-- Nothing found
		IF @pos IS NULL OR @pos = 0
			RETURN @pos;
 
		-- The required occurrence found
		IF @found = 1
			BREAK;
 
		-- Prepare to find another one occurrence
		SET @found = @found - 1;
		SET @pos = @pos + 1;
	END
 
	RETURN @pos;
  END
  GO

INSERT INTO profesori_new(Id_Profesor, Nume_Profesor, Prenume_Profesor, Localitate, Adresa_1, Adresa_2)
 SELECT Id_Profesor,
        Nume_Profesor,
	Prenume_Profesor,
	CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,1, dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,1, charindex(',',Adresa_Postala_Profesor)-1)
		ELSE Adresa_Postala_Profesor
		END as  localitate,
	CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1,
		(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1)+1,
		(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1))-1)
		ELSE NULL
		END as  Adresa_1,
	CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 
		THEN  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3)+1, 5)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 
		THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1, 5)
		ELSE NULL
		END as  Adresa_2
	FROM profesori;

select * from profesori_new
```

Rezultat:

![Task-5](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-5(1).PNG)
![Task-5](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-5(2).PNG)
![Task-5](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-5(3).PNG)
![Task-5](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-5(4).PNG)

6. Sa se insereze datele in tabelul orarul pentru Grupa= 'CIBJ 71' (Id_ Grupa= 1) pentru 
ziua de luni. Toate lectiile vor avea loc in blocul de studii 'B'. 

Mai jos, sunt prezentate detaliile de inserare:
(ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202);
(Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501);
(ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501);

Interogarea:

``` sql
create table orarul(
		Id_Disciplina INT, 
		Id_Grupa INT,
		Id_Profesor INT,
		Zi CHAR(2),
		Ora TIME,
		Auditoriu INT,
		Bloc CHAR (1)
		CHECK (Bloc in ('A','B','C')) DEFAULT('B') 
	);

	insert into orarul VALUES(107,1,101,'LU','08:00',203,'B');
	insert into orarul VALUES(108,1,101,'LU','11:30',501,'B');
	insert into orarul VALUES(119,1,117,'LU','13:00',501,'B');
```

Rezultat:

![Task-6](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-6.PNG)

7. Sa se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa 
INF 171, ziua de luni. Datele necesare pentru inserare trebuie sa fie colectate cu 
ajutorul instructiunii/instructiunilor SELECT si introduse in tabelul-destinatie, stiind ca:
lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Profesor ='Bivol Ion')
lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin')
lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena')


Interogarea:

``` sql
Insert into orarul(Id_Disciplina,Id_Grupa,Id_Profesor,Zi,Ora,Bloc) VALUES(
						(SELECT Id_Disciplina from discipline where Disciplina='Structuri de date si algoritmi'),
						(SELECT Id_Grupa from grupe where Cod_Grupa='INF171'),
						(SELECT Id_Profesor from profesori where Nume_Profesor='Bivol' and Prenume_Profesor='ION'),
						'LU','08:00','B'
						);
Insert into orarul(Id_Disciplina,Id_Grupa,Id_Profesor,Zi,Ora,Bloc) VALUES(
						(SELECT Id_Disciplina from discipline where Disciplina='Programe aplicative'),
						(SELECT Id_Grupa from grupe where Cod_Grupa='INF171'),
						(SELECT Id_Profesor from profesori where Nume_Profesor='Mircea' and Prenume_Profesor='Sorin'),
						'LU','11:30','B'
						);
Insert into orarul(Id_Disciplina,Id_Grupa,Id_Profesor,Zi,Ora,Bloc) VALUES(
						(SELECT Id_Disciplina from discipline where Disciplina='Baze de date'),
						(SELECT Id_Grupa from grupe where Cod_Grupa='INF171'),
						(SELECT Id_Profesor from profesori where Nume_Profesor='Micu' and Prenume_Profesor='Elena'),
						'LU','13:00','B'
						);

select Disciplina,Cod_Grupa,Nume_Profesor,Prenume_Profesor,Zi,Ora,Bloc from orarul as o
inner join discipline as d 
on o.Id_Disciplina=d.Id_Disciplina
inner join grupe as g
on g.Id_Grupa=o.Id_Grupa
inner join profesori as p
on p.Id_Profesor=o.Id_Profesor
```

Rezultat:

![Task-7](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-7(1).PNG)
![Task-7](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-7(2).PNG)


8. Sa se scrie interogarile de creare a indecsilor asupra tabelelor din baza de date 
universitatea pentru a asigura o performanta sporita la executarea interogarilor SELECT 
din Lucrarea practica 4. Rezultatele optimizarii sa fie analizate in baza planurilor de 
executie, pana la si dupa crearea indecsilor.
Indecsii nou-creati sa fie plasati fizic in grupul de fisiere userdatafgroupl (Crearea si
intrefinerea bazei de date - sectiunea 2.2.2)


Interogarea:

``` sql
create index ix_grupe on grupe(Id_Grupa)
create index ix_profesori on profesori(Id_Profesor)
create index ix_studenti on studenti(Id_Student)
create index ix_disciplina on discipline(Id_Disciplina)
create index ix_reusita on studenti_reusita(Id_Grupa,Id_Profesor,Id_Student,Id_Disciplina)
```

Rezultat:

![Task-8](https://github.com/verasv81/DataBase/blob/master/Laboratory%206/images/Task-8.PNG)

