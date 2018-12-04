# Laboratorul nr. 11

## Tema: Recuperarea bazei de date


Sarcini:

1. Sa se creeze un dosar Backup_labll. Sa se execute un backup complet al bazei de date
universitatea in acest dosar. Fisierul copiei de rezerva sa se numeasca exercitiull.bak. Sa se
scrie instructiunea SQL respectiva.

Interogarea:
``` sql
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup1')
EXEC sp_dropdevice 'backup1' , 'delfile';
GO
EXEC sp_addumpdevice 'DISK', 'backup1', 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul1.bkp'
GO
BACKUP DATABASE universitatea
TO DISK = 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul1.bkp'
WITH FORMAT,
NAME = 'universitatea - Full DB backup'
GO
```

Rezultat:

![Task1](https://github.com/verasv81/DataBase/blob/master/Laboratory%2011/images/Task1.PNG)

2. Sa se scrie instructiunea unui backup diferentiat al bazei de date universitatea. Fisierul copiei
de rezerva sa se numeasca exercitiul2.bak.

Interogare:

```sql
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup2')
EXEC sp_dropdevice 'backup2' , 'delfile';
GO
EXEC sp_addumpdevice 'DISK', 'backup2', 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul2.bkp'
GO
BACKUP DATABASE universitatea
TO DISK = 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul2.bkp'
WITH FORMAT,
NAME = 'universitatea - Differential DB backup'
GO
```

Rezultat:

![Task2](https://github.com/verasv81/DataBase/blob/master/Laboratory%2011/images/Task2.PNG)

3. Sa se scrie instructiunea unui backup al jurnalului de tranzactii al bazei de date universitatea.
Fisierul copiei de rezerva sa se numeasca exercitiul3.bak

Interogare:
``` sql
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='backup3')
EXEC sp_dropdevice 'backup3' , 'delfile';
GO
EXEC sp_addumpdevice 'DISK', 'backup3', 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul3.bkp'
GO
BACKUP LOG universitatea
TO DISK = 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiu32.bkp'
WITH FORMAT,
NAME = 'universitatea - Full DB backup'
GO
```

Rezultat:

![Task3](https://github.com/verasv81/DataBase/blob/master/Laboratory%2011/images/Task3.PNG)


4.  Sa se execute restaurarea consecutiva a tuturor copiilor de rezerva create. Recuperarea trebuie
sa fie realizata intr-o baza de date noua universitatea_labll. Fisierele bazei de date noi se afla
in dosarul BD_labll. Sa se scrie instructiunile SQL respective

Interogare:
``` sql

IF EXISTS (SELECT * FROM master.sys.databases WHERE name='universitatea_lab11')
DROP DATABASE universitatea_lab11;
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul1.bkp'
WITH MOVE 'universitatea' TO 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\data.mdf',
MOVE 'universitatea_log' TO 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\log.ldf',
NORECOVERY
GO
RESTORE LOG universitatea_lab11
FROM DISK = 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul3.bkp'
WITH NORECOVERY
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'D:\UTM\Anul II\Semester 1\Data Base\Laboratory 11\Backup_lab11\exercitiul2.bkp'
WITH NORECOVERY
GO
```
![Task4](https://github.com/verasv81/DataBase/blob/master/Laboratory%2011/images/Task4.PNG)