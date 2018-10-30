# Laboratorul nr. 5

## Transact-SQL: intructiuni procedurale


Sarcini:

1. Completati urmatorul cod pentru a afisa cel mai mare numar dintre
cele trei numere prezentate:

Interogarea:

``` sql
DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE	@MAI_MARE INT;
SET @N1=60*RAND();
SET @N2=60*RAND();
SET @N3=60*RAND();

SET @MAI_MARE=@N1;
IF @N2>@MAI_MARE  SET @MAI_MARE=@N2;
	ELSE IF @N3>@MAI_MARE  SET @MAI_MARE=@N3;

PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));
```

Rezultat:

![Task1][https://github.com/verasv81/DataBase/blob/master/Laboratory%205/images/Task1.PNG]


2. Afisati primele zece date (numele, prenumele studentului) in functie de valoarea notei (cu exceptia
notelor 6 si 8) a studentului la primul test al disciplinei Baze de date, folosind structura de
altemativa IF. .. ELSE. Sa se foloseasca variabilele.

Interogare:

``` sql
use universitatea
go
SELECT top(10)
Nume_Student,Prenume_Student, Nota
	from studenti as s
	inner join studenti_reusita as r
	on s.Id_Student=r.Id_Student
	inner join discipline as d
	on r.Id_Disciplina=d.Id_Disciplina
	where Nota!='6' or Nota!='8'
	and Disciplina='Baze de date'
	and Tip_Evaluare='Testul 1'
```

Rezultat:

![Task2][https://github.com/verasv81/DataBase/blob/master/Laboratory%205/images/Task2.PNG]

3. Rezolvati aceesi sarcina, 1, apeland la structura selectiva CASE.

Interogare:

``` sql
DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE	@MAI_MARE INT;
SET @N1=60*RAND();
SET @N2=60*RAND();
SET @N3=60*RAND();

SET @MAI_MARE=@N1;
SET @MAI_MARE = CASE 
		WHEN @N2>@MAI_MARE THEN @N2
		WHEN @N3>@MAI_MARE THEN @N3
		ELSE @MAI_MARE
		END

PRINT @N1;
PRINT @N2;
PRINT @N3;
PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));

```

Rezultat:

![Task3][https://github.com/verasv81/DataBase/blob/master/Laboratory%205/images/Task3.PNG]

4. Modificati exercitiile din sarcinile 1 si 2 pentru a include procesarea erorilor cu TRY si CATCH, si
RAISERRROR.

Interogare(sarcina 1):

``` sql
BEGIN TRY
	DECLARE @N1 INT, @N2 INT, @N3 INT;
	DECLARE	@MAI_MARE INT;
	SET @N1=60*RAND();
	SET @N2=60*RAND();
	SET @N3=60*RAND();

	SET @MAI_MARE=@N1;
	IF @N2>@MAI_MARE  SET @MAI_MARE=@N2;
		ELSE IF @N3>@MAI_MARE  SET @MAI_MARE=@N3;

	PRINT @N1;
	PRINT @N2;
	PRINT @N3;
	PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));
END TRY
BEGIN CATCH
	PRINT 'A aparut o eroare'
END CATCH

if @N1=@N2 and @N1=@N3
	begin
		RAISERROR('Numerele sunt egale',10,1)
		end
		else 
		begin
		SET @MAI_MARE=@N1;
	IF @N2>@MAI_MARE  SET @MAI_MARE=@N2;
		ELSE IF @N3>@MAI_MARE  SET @MAI_MARE=@N3;

	PRINT @N1;
	PRINT @N2;
	PRINT @N3;
	PRINT 'Mai mare = '+CAST(@MAI_MARE AS VARCHAR(2));
	end 
```

Rezultat(sarcina 1):

![Task4_s1-1][https://github.com/verasv81/DataBase/blob/master/Laboratory%205/images/Task4-1.PNG]

![Task4_s1-2][https://github.com/verasv81/DataBase/blob/master/Laboratory%205/images/Task4-2.PNG]

Interogare(sarcina 2):

``` sql
BEGIN TRY
use universitatea
SELECT top(10)
Nume_Student,Prenume_Student, Nota
	from studenti as s
	inner join studenti_reusita as r
	on s.Id_Student=r.Id_Student
	inner join discipline as d
	on r.Id_Disciplina=d.Id_Disciplina
	where Nota!='6' or Nota!='8'
	and Disciplina='Baze de date'
	and Tip_Evaluare='Testul 1'
END TRY
BEGIN CATCH
	PRINT 'A aparut o eroare la accesarea bazei de date'
END CATCH


DECLARE @Nota1 int, @Nota2 int;
SET @Nota1=6
SET @Nota2=8
if @Nota1=@Nota2
	BEGIN 
		RAISERROR('Verifici aceiasi nota',10,1)
	END
else
BEGIN
	SELECT top(10)
	Nume_Student,Prenume_Student, Nota
		from studenti as s
		inner join studenti_reusita as r
			on s.Id_Student=r.Id_Student
		inner join discipline as d
			on r.Id_Disciplina=d.Id_Disciplina
		where Nota!=@Nota1 or Nota!=@Nota2
			and Disciplina='Baze de date'
			and Tip_Evaluare='Testul 1'
END
```

Rezultat(sarcina 2):

![Task4_s2-1][https://github.com/verasv81/DataBase/blob/master/Laboratory%205/images/Task4-3.PNG]

![Task4_s2-2][https://github.com/verasv81/DataBase/blob/master/Laboratory%205/images/Task4-4.PNG]
