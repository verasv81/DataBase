/*
1. Sa se scrie o intructiune T-SQL, care ar popula coloana Adresa_Postala_Profesor
din tabelul profesori cu valoarea 'mun.Chisinau', unde adresa este necunoscuta.*/

/*
UPDATE profesori SET Adresa_Postala_Profesor='mun.Chisinau' where Adresa_Postala_Profesor is Null; 
Select * from profesori  
*/

/* 
2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarele cerinte:
a) Campul Cod_Grupa sa accepte numai valorile unice si sa nu accepte valori necunoscute.
b) Sa se tina cont ca cheia primara, deja, este definita asupra coloanei Id_Grupa 
*/

/*
Alter table grupe 
alter column Cod_Grupa varchar(10) Not null 

Alter table grupe 
add Unique(Cod_Grupa,Id_Grupa)
*/

/*
3. La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa si Prof_Indrumator, ambele de tip Int.
Sa se populeze campurile nou-create cu cele mai potrivite candidaturi in baza criteriilor de mai jos.

a) Seful grupei trebuie sa aiba cea mai buna reusita (media) din grupa la toate formele de evaluare
si la toate disciplinile. Un student nu poate fi sef de grupa la mai multe grupe.

b) Profesorul indrumator trebuie sa predea un numar maximal posibil de disciplina la grupa data.
Daca nu exista o singura candidatura, care corespunde primei cerinte, atunci este ales din grupul de candidati
acel cu identificatorul (Id_Profesor) minimal. Un profesor nu poate fi indrumator la mai multe grupe.

c) Sa se scire instructiuile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor in tabelul
grupe, pentru selectarea candidatilor si inserarea datelor. ---
*/


Alter table grupe add Sef_grupa int 
Alter table grupe add Prof_Indrumator int

UPDATE grupe SET Sef_grupa=(
SELECT top(1) Id_Student, avg(Nota) from studenti_reusita 
group by Id_Grupa
having AVG(Nota)>ANY (
select avg(Nota) from studenti_reusita group by Id_Student)
)

/*4.----*/

/*5.----*/
/*
create table profesori_new(
	Id_Profesor int Primary Key,
	Nume_Profesor varchar(60) not null,
	Prenume_Profesor varchar(60) not null,
	Localitate varchar(20) default('mun.Chisinau'),
	Adresa_1 varchar(30),
	Adresa_2 varchar(30)
);

select * from profesori_new

delete  from profesori_new

insert into profesori_new(Id_Profesor,Nume_Profesor,Prenume_Profesor,Adresa_1,Adresa_2)
SELECT Id_Profesor,Nume_Profesor,Prenume_Profesor,
	LEFT(Adresa_Postala_Profesor,CHARINDEX(' ',Adresa_Postala_Profesor)-1) AS Adresa_1,
	STUFF(Adresa_Postala_Profesor,1,CHARINDEX(' ',Adresa_Postala_Profesor),'') AS Adresa_2
FROM
	profesori*/

	select * from profesori