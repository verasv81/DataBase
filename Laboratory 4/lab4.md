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



![Task4](images/task4.png)



19. Gasiti numele si prenumele profesorilor, care au predat discipline, in care studentul "Cosovanu" a
fost respins (nota <5) 
la cel putin o proba.



Interogarea:



Resultat:



![Task19](images/task19.png)



24. Sa se afisase lista disciplinelor (Disciplina) predate de cel putin doi profesori.



Interogarea:




Resultat:



![Task24](images/task24.png)





35. Gasiti denumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii
mai mari de 7.0.



Interogarea:



Resultat:



![Task35](images/task35.png)
