/*1. Completati urmatorul cod pentru a afisa cel 
mai mare numar dintre cele trei numerre prezentate:*/

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

/*2. Afisati primele zece date (numele, prenumele studentului) in functie de valoarea notei (cu exceptia
notelor 6 si 8) a studentului la primul test al disciplinei Baze de date, folosind structura de
altemativa IF. .. ELSE. Sa se foloseasca variabilele.*/

DECLARE @nota int , @disciplina char(255), @tip_test char(255) 
SET @disciplina=(SELECT Disciplina FROM discipline where Disciplina='Baze de date') 
SET @tip_test = (SELECT DISTINCT Tip_Evaluare FROM studenti_reusita where Tip_Evaluare='Testul 1')

IF (@nota in (SELECT Nota FROM studenti_reusita WHERE Nota not in (6,8)))
	PRINT 'There are no students with such characteristics'

ELSE SELECT  TOP (10) Nume_Student ,Prenume_Student ,Nota
			FROM studenti, studenti_reusita, discipline
			WHERE studenti.Id_Student=studenti_reusita.Id_Student
			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
			and Disciplina=@disciplina
			and Tip_evaluare=@tip_test
			ORDER BY Nota DESC;

/*3. Rezolvati aceesi sarcina, 1, apeland la structura 
selectiva CASE.*/

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


/*4. Modificati exercitiile din sarcinile 1 si 2 pentru a include procesarea erorilor cu TRY si CATCH, si
RAISERRROR.*/
--sarcina 1 

BEGIN TRY
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

--sarcina 2
DECLARE @nota int , @disciplina char(255), @tip_test char(255) 
SET @disciplina=(SELECT Disciplina FROM discipline where Disciplina='Baze de date') 
SET @tip_test = (SELECT DISTINCT Tip_Evaluare FROM studenti_reusita where Tip_Evaluare='Testul 1')

BEGIN TRY
IF (@nota in (SELECT Nota FROM studenti_reusita WHERE Nota not in (6,8)))
	PRINT 'There are no students with such characteristics'

ELSE SELECT  TOP (10) Nume_Student ,Prenume_Student ,Nota
			FROM studenti, studenti_reusita, discipline
			WHERE studenti.Id_Student=studenti_reusita.Id_Student
			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
			and Disciplina=@disciplina
			and Tip_evaluare=@tip_test
			ORDER BY Nota DESC;
END TRY
BEGIN CATCH
	PRINT 'A aparut o eroare la accesarea bazei de date'
END CATCH


if @nota=6
	BEGIN 
		RAISERROR('Verifici aceiasi nota',10,1)
	END
else
BEGIN
IF (@nota in (SELECT Nota FROM studenti.studenti_reusita WHERE Nota not in (6,8)))
	PRINT 'There are no students with such characteristics'

ELSE SELECT  TOP (10) Nume_Student ,Prenume_Student ,Nota
			FROM studenti.studenti, studenti.studenti_reusita, plan_studii.discipline
			WHERE studenti.Id_Student=studenti_reusita.Id_Student
			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
			and Disciplina=@disciplina
			and Tip_evaluare=@tip_test
			ORDER BY Nota DESC;
END