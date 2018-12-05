# Laboratorul nr. 9

## Tema: Proceduri stocate si functii definite de utilizator


Sarcini:

1. Sa se creeze doua viziuni in baza interogarilor formulate in doua exercitii indicate din capitolul 4. 
Prima viziune sa fie construita in Editorul de interogari, iar a doua, utilizand View Designer.

Interogare:

``` sql
--19. Gasiti numele si prenumele profesorilor, care au predat discipline, in care studentul "Cosovanu" a
 fost respins (nota <5) la cel putin o proba.
*/
use universitatea
go
drop procedure if exists exercitiul19
go
create procedure exercitiul19
@NumeStudent varchar(50)='Cosovanu'
as
begin
select Nume_Profesor,Prenume_Profesor 
from profesori where exists
	(select studenti_reusita.Id_Disciplina 
	from studenti_reusita 
	where studenti_reusita.Nota<5 and studenti_reusita.Id_Student=
		(select Id_Student 
		from studenti 
		where studenti_reusita.Id_Student=studenti.Id_Student 
		and studenti.Nume_Student=@NumeStudent));
end
exec exercitiul19;

--4. Afi?a?i care din discipline au denumirea formata din mai mult de 20 caractere.

drop procedure if exists ex4
go
create procedure ex4
@length int=20
as
begin
	select * from discipline 
		where DATALENGTH(discipline.Disciplina)>@length;
end

exec ex4;
```

Rezultat:

![Task1-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task1-1.PNG)
![Task1-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task1-2.PNG)


2. Sa se creeze o procedura stocata, care nu are niciun parametru de intrare si poseda un
parametru de iesire. Parametrul de iesire trebuie sa returneze numarul de studenti, care nu au
sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL).

Interogare:

``` sql
drop procedure if exists nrStudenti
go
create procedure nrStudenti
	@nr int=null output
	as
		begin
			set nocount on;
			SET @nr=(select Count(distinct Id_Student) 
							from studenti_reusita 
								where Nota<5 or Nota is NULL)
			print ('Numarul studentilor care au nu au sustinut cel putin o forma de evaluare este '+CAST(@nr as varchar(10))+'.');
end

exec nrStudenti;
```

Rezultat:

![Task2](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task2.PNG)


3.Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student
nou. In calitate de parametri de intrare sa serveasca datele personale ale studentului nou si
Cod_Grupa. Sa se genereze toate intrarile-cheie necesare in tabelul studenti_reusita. Notele
de evaluare sa fie inserate ca NULL.

Interogare:

``` sql
drop procedure if exists addStudent
go
create procedure addStudent
	@Id_Student int, @Nume_Student varchar(50), @Prenume_Student varchar(50), @Data_Nastere_Student datetime,
	@Adresa_Postala_Student varchar(80), @Cod_Grupa varchar(5) as
	begin
		SET NOCOUNT ON
		DECLARE @Id_Profesor int,
				@Id_Disciplina int,
				@Id_Grupa smallint,
				@Tip_Evaluare varchar(30)='Examen',
				@Nota int=7,
				@Data_Evaluare varchar(10)='2018-11-26';

		SET @Id_Grupa=(Select TOP(1) Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa);
		SET @Id_Profesor=116;
		SET @Id_Disciplina=(Select TOP(1) Id_Disciplina from studenti_reusita where Id_Profesor=@Id_Profesor);

		INSERT INTO studenti(Id_Student,Nume_Student,Prenume_Student,Data_Nastere_Student,Adresa_Postala_Student) 
			VALUES(@Id_Student,@Nume_Student,@Prenume_Student,@Data_Nastere_Student,@Adresa_Postala_Student);

		INSERT INTO studenti_reusita(Id_Student,Id_Disciplina,Id_Profesor,Id_Grupa,Tip_Evaluare,Nota,Data_Evaluare)
			VALUES(@Id_Student,@Id_Disciplina,@Id_Profesor,@Id_Grupa,@Tip_Evaluare,@Nota,@Data_Evaluare)
end
exec addStudent
@Id_Student=180,
@Nume_Student='Maria',
@Prenume_Student='Neamtu',
@Data_Nastere_Student='1997-01-01',
@Adresa_Postala_Student='mun. Chisinau, Ioan Botezatorul 10, ap 44',
@Cod_Grupa='INF171'

select * from studenti

```


Rezultat:
![Task3-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task3-1.PNG)
![Task3-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task3-2.PNG)

4. Fie ca un profesor se elibereaza din functie la mijlocul semestrului. Sa se creeze o procedura
stocata care ar reatribui inregistrarile din tabelul studenti_reusita unui alt profesor. Parametri
de intrare: numele si prenumele profesorului vechi, numele si prenumele profesorului nou,
disciplina. In cazul in care datele inserate sunt incorecte sau incomplete, sa se afiseze un
mesaj de avertizare.

Interogare:

``` sql

drop procedure if exists changeProfesor
go
create procedure changeProfesor
	@Nume_Profesor_vechi varchar(50), 
	@Prenume_Profesor_vechi varchar(50),
	@Nume_Profesor_nou varchar(50), 
	@Prenume_Profesor_nou varchar(50),
	@Disciplina varchar(50)
as
IF ((select Id_Disciplina from discipline where Disciplina=@Disciplina) 
	in (select distinct Id_Disciplina from studenti_reusita where Id_Profesor=
		(select Id_Profesor from profesori where Nume_Profesor=@Nume_Profesor_vechi and Prenume_Profesor=@Prenume_Profesor_vechi)))
 begin
		UPDATE profesori set Nume_Profesor=@Nume_Profesor_nou, Prenume_Profesor=@Prenume_Profesor_nou
			where Nume_Profesor=@Nume_Profesor_vechi and Prenume_Profesor=@Prenume_Profesor_vechi
		print('Profesorul: '+@Nume_Profesor_vechi+' '+@Prenume_Profesor_vechi+' a fost inlocuit cu profesorul: '+
			@Nume_Profesor_nou+' '+@Prenume_Profesor_nou)
end
ELSE 
	BEGIN
		print('Erroare!!!')
		print(@Nume_Profesor_vechi+ ' '+@Prenume_Profesor_vechi+' nu preda disciplina '+'"'+@Disciplina+'"'+'!')
END;

exec changeProfesor
@Nume_Profesor_vechi='Micu',
@Prenume_Profesor_vechi='Elena',
@Nume_Profesor_nou='Irina',
@Prenume_Profesor_nou='Cojanu',
@Disciplina='Baze de date'

select * from profesori 
select * from discipline where Id_Disciplina=107
```


Rezultat:
![Task4](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task-4.PNG)

5. Sa se creeze o procedura stocata care ar forma o lista cu primii 3 cei mai buni studenti la o
disciplina, si acestor studenti sa le fie marita nota la examenul final cu un punct (nota
maximala posibila este 10). In calitate de parametru de intrare, va servi denumirea disciplinei.
Procedura sa returneze urmatoarele campuri: Cod_ Grupa, Nume_Prenume_Student,
Disciplina, Nota Veche, Nota Noua.

Interogare:

``` sql
DROP PROCEDURE IF EXISTS ex5
GO
CREATE PROCEDURE ex5 
@disciplina VARCHAR(50)
AS
DECLARE @stud_list TABLE (Id_Student int, Media float)
INSERT INTO @stud_list
	SELECT TOP (3) Id_Student, AVG(cast (Nota as float)) as Media
	FROM studenti_reusita, discipline
	WHERE discipline.Id_Disciplina = studenti_reusita.Id_Disciplina
	AND Disciplina = @disciplina
	GROUP BY studenti_reusita.Id_Student
	ORDER BY Media desc		

SELECT cod_grupa, studenti.Id_Student, CONCAT(nume_student, ' ', Prenume_Student) as Nume, Disciplina, nota AS Nota_Veche, iif(nota > 9, 10, nota + 1) AS Nota_Noua 
	FROM studenti_reusita, discipline, grupe, studenti WHERE discipline.id_disciplina = studenti_reusita.id_disciplina
	AND grupe.Id_Grupa = studenti_reusita.Id_Grupa
	AND  studenti.Id_Student = studenti_reusita.Id_Student
	AND studenti.Id_Student in (select Id_Student from @stud_list)
	AND Disciplina = @disciplina
	AND Tip_Evaluare = 'Examen'

DECLARE @id_dis SMALLINT = (SELECT  Id_Disciplina  FROM discipline WHERE   Disciplina = @disciplina)

UPDATE studenti_reusita SET Nota = (CASE WHEN nota >= 9 THEN 10 ELSE nota + 1 END)
WHERE Tip_Evaluare = 'Examen' AND Id_Disciplina = @id_dis AND Id_Student in (select Id_Student from @stud_list)
go

execute ex5 @disciplina = 'Structuri de date si algoritmi'
```


Rezultat:
![Task5](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task-5.PNG)

6. Sa se creeze functii definite de utilizator in baza exercitiilor (2 exercitii) din capitolul 4.
Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor
respective.

Interogare:

``` sql

--19. Gasiti numele si prenumele profesorilor, care au predat discipline, in care studentul "Cosovanu" a
-- fost respins (nota <5) la cel putin o proba.

drop function if exists ex19
go
create function ex19 (@NumeStudent varchar(50))
returns table
as 
return
	(select Nume_Profesor,Prenume_Profesor 
		from profesori where exists
			(select studenti_reusita.Id_Disciplina 
				from studenti_reusita 
				where studenti_reusita.Nota<5 and studenti_reusita.Id_Student=
					(select Id_Student 
						from studenti 
							where studenti_reusita.Id_Student=studenti.Id_Student 
								and studenti.Nume_Student=@NumeStudent)));
select * from ex19('Cosovanu');


--4. Afi?a?i care din discipline au denumirea formata din mai mult de 20 caractere.

drop function if exists ex_4
go
create function ex_4(@length int)
returns table
with encryption
as
return
(select * from discipline 
		where DATALENGTH(discipline.Disciplina)>@length);

select * from ex_4(20);
```


Rezultat:
![Task6-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task6-1.PNG)
![Task6-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task6-2.PNG)


7. Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al
functiei: <nume Functie>(<Data _ Nastere _Student>).

Interogare:

``` sql
drop function if exists calculateAge
go
create function calculateAge(@Data_Nastere date)
	returns int
	as
		begin
			DECLARE @Now datetime,@age int;
			SET @Now=GETDATE();      
			SELECT @age=(CONVERT(int,CONVERT(char(8),@Now,112))-CONVERT(char(8),@Data_Nastere,112))/10000;
			return @age;
		end;
```


Rezultat:
![Task7](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task7.PNG)

8. Sa se creeze o functie definita de utilizator, care ar returna datele referitoare la reusita unui
student. Se defineste urmatorul format al functiei: <nume Functie>
(<Nume_Prenume_Student>). Sa fie afisat tabelul cu urmatoarele campuri:
Nume_Prenume_Student, Disticiplina, Nota, Data_Evaluare.

Interogare:

``` sql
drop function if exists reusitaStudent
go
create function reusitaStudent(@Nume_Student varchar(50),@Prenume_Student varchar(50))
returns @reusita table
(Nume_Student varchar(50),Prenume_Student varchar(50),Disciplina varchar(50),Nota int,Data_Evaluare date)
as
begin
Insert @reusita
SELECT distinct Nume_Student,Prenume_Student,Disciplina,Nota,Data_Evaluare 
from studenti_reusita inner join studenti
on studenti_reusita.Id_Student=studenti.Id_Student
inner join discipline
on discipline.Id_Disciplina=studenti_reusita.Id_Disciplina
where Nume_Student=@Nume_Student and Prenume_Student=@Prenume_Student
return
end;

Select * from reusitaStudent('Dan','David')
```


Rezultat:
![Task8](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task8.PNG)

9. Se cere realizarea unei functii definite de utilizator, care ar gasi cel mai sarguincios sau cel
mai slab student dintr-o grupa. Se defineste urmatorul format al functiei: <numeFunctie>
(<Cod_ Grupa>, <is_good>). Parametrul <is_good> poate accepta valorile "sarguincios" sau
"slab", respectiv. Functia sa returneze un tabel cu urmatoarele campuri Grupa,
Nume_Prenume_Student, Nota Medie , is_good. Nota Medie sa fie cu precizie de 2 zecimale.

Interogare:

``` sql
use universitatea
go
drop function if exists goodStudent
go
create function goodStudent(@Cod_Grupa varchar(7),@is_good varchar(30))
returns @reusita table
(Grupa varchar(7), Nume_Prenume_Student varchar(80),Nota_Medie decimal(5,2),is_good varchar(30))
as
begin
if (@is_good='sarguincios')	
	insert into @reusita 
 Select @Cod_grupa,concat(Nume_Student,' ',Prenume_Student) as Nume_Prenume_Student,cast(avg(Nota)as decimal(4,2)) as Nota_Medie ,@is_good
  from studenti s
  inner join studenti_reusita r
  on s.Id_Student=r.Id_Student
  where Nume_Student=(select top 1 Nume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) DESC) 
  and Prenume_Student=(select top 1 Prenume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) DESC)
Group by Nume_Student,Prenume_Student
else if(@is_good='slab')
INSERT INTO @reusita
 Select @Cod_grupa,concat(Nume_Student,' ',Prenume_Student) as Nume_Prenume_Student,cast(avg(Nota)as decimal(4,2)) as Nota_Medie ,@is_good
  from studenti s
  inner join studenti_reusita r
  on s.Id_Student=r.Id_Student
  where Nume_Student=(select top 1 Nume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) ASC) 
  and Prenume_Student=(select top 1 Prenume_Student
                      from studenti s
                      inner join studenti_reusita r
                      on s.Id_Student=r.Id_Student
                      where Id_Grupa =(Select Id_Grupa from grupe where Cod_Grupa=@Cod_Grupa )
                      Group by Nume_Student,Prenume_Student
                      Order by AVG(Nota) ASC)
Group by Nume_Student,Prenume_Student
return;
end;


select * from dbo.goodStudent('CIB171','sarguincios')
```


Rezultat:
![Task9-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task9-1.PNG)
![Task9-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task9-2.PNG)
![Task9-3](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task9-3.PNG)
![Task9-4](https://github.com/verasv81/DataBase/blob/master/Laboratory%209/images/Task9-4.PNG)
