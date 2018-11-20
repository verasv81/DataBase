# Laboratorul nr. 8

## Tema: Administrarea viziunilor si a expresiilor-tabel


Sarcini:

1. Sa se creeze doua viziuni in baza interogarilor formulate in doua exercitii indicate din capitolul 4. 
Prima viziune sa fie construita in Editorul de interogari, iar a doua, utilizand View Designer.

Interogare:

``` sql

/*Exercitiul 24. Sa se afisase lista disciplinelor (Disciplina) predate de cel putin doi profesori. */

use universitatea 
go
drop view if exists profesori_discipline1;
go
create view profesori_discipline1 AS
select Disciplina from dbo.disciplina1 as ds 
	where 
	(select count(distinct sr.Id_Profesor) from studenti_reusita1 sr
	inner join profesori1 as pr on sr.Id_Profesor=pr.Id_Profesor
	where sr.Id_Disciplina=ds.Id_Disciplina
	)>1
GO

select * from profesori_discipline1;

/*Exercitiul 35. Gasiti denumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii
mai mari de 7.0. */
use universitatea 
go
drop view if exists reusita;
go
create view reusita AS
select d.Disciplina, AVG(Nota) as Media_notelor 
	from disciplina1 as d
inner join studenti_reusita1 as s
	on s.Id_Disciplina=d.Id_Disciplina
group by Disciplina
having Avg(Nota)>7
go

select * from reusita
```

Rezultat:


![Task1-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-1(1).PNG)
![Task1-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-1(2).PNG)
![Task1-3](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-1(3).PNG)
![Task1-4](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-1(4).PNG)


2. Sa se scrie cate un exemplu de instructiuni INSERT, UPDATE, DELETE asupra viziunilor
create. Sa se adauge comentariile respective referitoare la rezultatele executarii acestor
instructiuni.

Interogare:
``` sql
/*Exercitiul 24. Sa se afisase lista disciplinelor (Disciplina) predate de cel putin doi profesori. */
/*
use universitatea 
go
drop view if exists exercitiul24;
go
create view exercitiul24 AS
select Id_Disciplina,Disciplina from dbo.disciplina1 as ds 
	where 
	(select count(distinct sr.Id_Profesor) from studenti_reusita1 sr
	inner join profesori1 as pr on sr.Id_Profesor=pr.Id_Profesor
	where sr.Id_Disciplina=ds.Id_Disciplina
	)>1
GO

select * from exercitiul24;

INSERT INTO exercitiul24(Id_Disciplina,Disciplina) VALUES(123,'Grafica')

UPDATE exercitiul24 SET Disciplina='Proiectare' where Id_Disciplina=122;

Delete from exercitiul24 where Id_Disciplina=122;
*/
/*Insert, update si delete nu pot fi executate pe interogarea aceasta deoarece este join, nu avem un singur tabel. */

/*2. Sorteaza disciplinile dupa nr de ore */
/*order by nu este permis in view deci view contine datele din discipline nesortate*/
use universitatea 
go
create view exercitiul2 as
select * from disciplina1;
go

insert into exercitiul2 VALUES(124,'Aplicatii mobile',60);

update exercitiul2 set Nr_ore_plan_disciplina=80 where Id_Disciplina=122;

delete from exercitiul2 where Id_Disciplina=123;

select * from exercitiul2;


/*4. Afisati care din discipline au denumirea formata din mai mult de 20 caractere
select * from discipline where DATALENGTH(discipline.Disciplina)>20;*/

use universitatea 
go
create view exercitiul4 as
select * from disciplina1 where DATALENGTH(disciplina1.Disciplina)>20;
go

insert into exercitiul4 VALUES(125,'Dezvoltarea personala si profesionala',70);

update exercitiul4 set Nr_ore_plan_disciplina=80 where Id_Disciplina=125;

delete from exercitiul4 where Id_Disciplina=122;

select * from exercitiul4;

```

Rezultat:


![Task2-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-2(1).PNG)
![Task2-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-2(2).PNG)


3. Sa se scrie instructiunile SQL care ar modifica viziunile create (in exercitiul 1) in asa fel, incat
sa nu fie posibila modificarea sau stergerea tabelelor pe care acestea sunt definite si viziunile
sa nu accepte operatiuni DML, daca conditiile clauzei WHERE nu sunt satisfacute.

Interogare:

``` sql
/*Exercitiul 24. Sa se afisase lista disciplinelor (Disciplina) predate de cel putin doi profesori. */
use universitatea
go
alter view profesori_discipline1
with SCHEMABINDING --pentru ca sa nu fie posibila modificarea sau stergerea tabelelor pe care acestea sunt definite
as
select Disciplina from plan_studii.discipline  as ds 
	where 
	(select count(distinct sr.Id_Profesor) from studenti.studenti_reusita sr
	inner join cadre_didactice.profesori as pr on sr.Id_Profesor=pr.Id_Profesor
	where sr.Id_Disciplina=ds.Id_Disciplina
	)>1
with check option --sa nu accepte operatiuni DML, daca conditiile clauzei WHERE nu sunt satisfacute
GO

/*Exercitiul 35. Gasiti denumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii
mai mari de 7.0. */
use universitatea 
go
alter view reusita 
with schemabinding -- nu permite modificarea sau stergerea tabelelor pe care acestea sunt definite
AS
select d.Disciplina, AVG(Nota) as Media_notelor 
	from plan_studii.discipline as d
inner join studenti.studenti_reusita as s
	on s.Id_Disciplina=d.Id_Disciplina
group by Disciplina
having Avg(Nota)>7
with check option --sa nu accepte operatiouni DML, daca conditiile clauzei WHERE nu sunt satisfacute conditiile
go

```

Rezultat:

![Task3-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-3(1).PNG)
![Task3-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-3(2).PNG)

4. Sa se scrie instructiunile de testare a proprietatilor noi definite.

Interogare:

``` sql
drop table plan_studii.discipline;
update reusita set Disciplina='Etica si comunicarea'
```

Rezultat:

![Task4](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-4.PNG)

5. Sa se rescrie 2 interogari formulate in exercitiile din capitolul 4, in asa fel. incat interogarile
imbricate sa fie redate sub forma expresiilor CTE.

Interogare:

``` sql
/*Exercitiul 35. Gasiti denumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii
mai mari de 7.0. */
use universitatea go
with mediaNotelorperDisciplina(Id_Disciplina,Media_notelor) as
	(select Id_Disciplina, AVG(Nota)
	from studenti.studenti_reusita
	group by Id_Disciplina)

Select DISTINCT d.Disciplina, m.Media_notelor from studenti.studenti_reusita as s
	inner join mediaNotelorperDisciplina as m
	on m.Id_Disciplina=s.Id_Disciplina
	and m.Media_notelor>7
	inner join plan_studii.discipline as d
	on d.Id_Disciplina=m.Id_Disciplina

/*4. Afisati care din discipline au denumirea formata din mai mult de 20 caractere
select * from discipline where DATALENGTH(discipline.Disciplina)>20;*/
use universitatea 
go
with lungimeDisciplina(Id_Disciplina, Nume_Disciplina) as
	(select Id_Disciplina,Disciplina 
		from plan_studii.discipline)
Select l.Id_Disciplina,l.Nume_Disciplina from lungimeDisciplina as l
where DATALENGTH(l.Nume_Disciplina)>20
```

Rezultat:

![Task5-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-5(1).PNG)
![Task5-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-5(2).PNG)

6. Se considera un graf orientat, precum e el din figura de mai jos si fie se doreste parcursa calea
de la nodul id = 3 la nodul unde id = 0. Sa se faca reprezentarea grafului orientat in forma de
expresie-tabel recursiv.
Sa se observe instructiunea de dupa UNION ALL a membrului recursiv, precum si partea de
pana la UNION ALL reprezentata de membrul-ancora.

``` sql
use universitatea
go
DECLARE @Graph_tab table
(ID INT,
prev_ID INT)
INSERT @Graph_tab
select 5, null union all
select 4, null union all
select 3, null union all
select 0, 5 union all
select 2, 4 union all
select 2, 3 union all
select 1, 2 union all
select 0, 1;

with graph_ex6
as
(SELECT *, prev_ID as pred_Nod,0 as generation from @Graph_tab where prev_ID IS NULL and ID=3
	UNION ALL
		SELECT graph.*,graph_ex6.ID as pred_Nod, generation+1
			from @Graph_tab as graph
			inner join graph_ex6
			on graph.prev_ID=graph_ex6.ID)

SELECT * FROM graph_ex6;
```

Rezultat:


![Task6](https://github.com/verasv81/DataBase/blob/master/Laboratory%208/images/Task-6.PNG)