# Laboratorul nr. 4


## Sarcini 



4. Afișați care din discipline au denumirea formată din mai mult de 20 caractere.



Interogarea:


``` sql

select * 
from discipline 
where DATALENGTH(discipline.Disciplina)>20;
```



Resultat:



![Task4](https://github.com/verasv81/DataBase/blob/master/Laboratory%204/images/task4.PNG)



19. Gasiti numele si prenumele profesorilor, care au predat discipline, in care studentul "Cosovanu" a
fost respins (nota <5) 
la cel putin o proba.



Interogarea:

``` sql
select profesori.Nume_Profesor,profesori.Prenume_Profesor 
from profesori where exists
	(select studenti_reusita.Id_Disciplina 
	from studenti_reusita 
	where studenti_reusita.Nota<5 and studenti_reusita.Id_Student=
		(select Id_Student 
		from studenti 
		where studenti_reusita.Id_Student=studenti.Id_Student 
		and studenti.Nume_Student='Cosovanu'))
```



Resultat:



![Task19](https://github.com/verasv81/DataBase/blob/master/Laboratory%204/images/task19.PNG)



24. Sa se afisase lista disciplinelor (Disciplina) predate de cel putin doi profesori.



Interogarea:



``` sql 
select Disciplina from discipline as ds 
	where 
	(select count(distinct sr.Id_Profesor) from studenti_reusita sr
	inner join profesori as pr on sr.Id_Profesor=pr.Id_Profesor
	where sr.Id_Disciplina=ds.Id_Disciplina
	)>1
```

Resultat:



![Task24](https://github.com/verasv81/DataBase/blob/master/Laboratory%204/images/task24.PNG)





35. Gasiti denumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii
mai mari de 7.0.



Interogarea:


``` sql
select d.Disciplina, AVG(Nota) as Media_notelor 
	from discipline as d
inner join studenti_reusita as s
	on s.Id_Disciplina=d.Id_Disciplina
group by Disciplina
having Avg(Nota)>7
```

Resultat:



![Task35](https://github.com/verasv81/DataBase/blob/master/Laboratory%204/images/task35.PNG)


The sql file you can find at : [Sql File Lab4](https://github.com/verasv81/DataBase/blob/master/Laboratory%204/sql%20file/mylab4.sql)

