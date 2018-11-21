# Laboratorul nr. 7

## Diagrame, scheme si sinonime


Sarcini:

1. Creati o diagrama a bazei de date, folosind forma de vizualizare standard, structura careia este
descrisa la inceputul sarcinilor practice din capitolul 4.

Rezultat:

![Task1](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-1.PNG)


2. Sa se adauge constrangeri referentiale (legate cu tabelele studenti si profesori) necesare
coloanelor Sef_grupa si Prof_Indrumator (sarcina3, capitolul 6) din tabelul grupe.


Rezultat:

![Task2](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-2.PNG)

3. La diagrama construită, să se adauge și tabelul orarul definit în capitolul 6 al acestei lucrari:tabelul orarul conține identificatorul 
disciplinei (ld_Disciplina), identificatorul profesorului(Id_Profesor) și blocul de studii (Bloc). Cheia tabelului este constituită din trei cîmpuri:
identificatorul grupei (Id_ Grupa), ziua lectiei (Z1), ora de inceput a lectiei (Ora), sala unde are loc lectia (Auditoriu).

Rezultat:

![Task3](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-3.PNG)

4. Tabelul orarul trebuie să conțină și 2 chei secundare: (Zi, Ora, Id_ Grupa, Id_ Profesor) și (Zi, Ora, ld_Grupa, ld_Disciplina).



Rezultat:

![Task4](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-4.PNG)


5.  În diagrama, de asemenea, trebuie sa se defineasca constrangerile referentiale (FK-PK) ale atributelor ld_Disciplina, ld_Profesor, 
Id_ Grupa din tabelului orarul cu atributele tabelelor respective.


Rezultat:

![Task5](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-5.PNG)


6. Creați, în baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii și studenti. 
Transferați tabelul profesori din schema dbo in schema cadre didactice, ținînd cont de dependentele definite asupra tabelului menționat. 
În același mod să se trateze tabelele orarul,discipline care aparțin schemei plan_studii și 
tabelele studenți, studenti_reusita, care apartin schemei studenti. Se scrie instructiunile SQL respective.

Interogare:
``` sql
use universitatea
GO
CREATE SCHEMA cadre_didactice;
GO
ALTER SCHEMA cadre_didactice TRANSFER dbo.profesori

GO
CREATE SCHEMA plan_studii;
GO
ALTER SCHEMA plan_studii TRANSFER dbo.orarul
ALTER SCHEMA plan_studii TRANSFER dbo.discipline

GO
CREATE SCHEMA studenti;
GO
ALTER SCHEMA studenti TRANSFER dbo.studenti
ALTER SCHEMA studenti TRANSFER dbo.studenti_reusita
```

Rezultat:

![Task6](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-6.PNG)


7. Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele tabelelor 
accesate sa fie descrise in mod explicit, ținînd cont de faptul ca tabelele au fost mutate in scheme noi.
Interogarare:

``` sql
/*19. Gasiti numele si prenumele profesorilor, care au predat discipline, in care studentul "Cosovanu" a
fost respins (nota <5) la cel putin o proba.*/

select cadre_didactice.profesori.Nume_Profesor,cadre_didactice.profesori.Prenume_Profesor 
from cadre_didactice.profesori where exists
	(select studenti.studenti_reusita.Id_Disciplina 
	from studenti.studenti_reusita 
	where studenti.studenti_reusita.Nota<5 and studenti.studenti_reusita.Id_Student=
		(select studenti.studenti.Id_Student 
		from studenti.studenti 
		where studenti.studenti_reusita.Id_Student=studenti.studenti.Id_Student 
		and studenti.studenti.Nume_Student='Cosovanu'))


/*24. Sa se afisase lista disciplinelor (Disciplina) predate de cel putin doi profesori. */
select Disciplina from plan_studii.discipline as ds 
	where 
	(select count(distinct sr.Id_Profesor) from studenti.studenti_reusita sr
	inner join cadre_didactice.profesori as pr on sr.Id_Profesor=pr.Id_Profesor
	where sr.Id_Disciplina=ds.Id_Disciplina
	)>1
```

Rezultat:

![Task7-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-7(1).PNG)
![Task7-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-7(2).PNG)


8. Creați sinonimele respective pentru a simplifica interogările construite în exercițiul precedent și reformulați interogările, 
folosind sinonimele create.

Interogare:

``` sql
/*19. Gasiti numele si prenumele profesorilor, care au predat discipline, in care studentul "Cosovanu" a
fost respins (nota <5) la cel putin o proba.*/

GO
CREATE SYNONYM studenti1 FOR
studenti.studenti

GO 
CREATE SYNONYM studenti_reusita1 FOR 
studenti.studenti_reusita

GO
CREATE SYNONYM profesori1 FOR
cadre_didactice.profesori;

select Nume_Profesor,Prenume_Profesor 
from profesori1 where exists
	(select Id_Disciplina from studenti_reusita1 
	where Nota<5 and Id_Student=
		(select Id_Student from studenti1 
		where studenti_reusita1.Id_Student=studenti1.Id_Student 
		and studenti1.Nume_Student='Cosovanu'))


/*24. Sa se afisase lista disciplinelor (Disciplina) predate de cel putin doi profesori. */

GO
CREATE SYNONYM disciplina1 FOR
plan_studii.discipline;

select Disciplina from disciplina1 as ds 
	where 
	(select count(distinct sr.Id_Profesor) from studenti_reusita1 sr
	inner join profesori1 as pr on sr.Id_Profesor=pr.Id_Profesor
	where sr.Id_Disciplina=ds.Id_Disciplina
	)>1 
```

Rezultat:

![Task8-1](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-8(1).PNG)
![Task8-2](https://github.com/verasv81/DataBase/blob/master/Laboratory%207/images/Task-8(2).PNG)
