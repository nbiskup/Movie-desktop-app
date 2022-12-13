
CREATE DATABASE JavaMovieProject
GO

USE  JavaMovieProject
GO

--creating tables

CREATE TABLE Movie
(
	IDMovie int constraint PK_Movie primary key identity,
	Title nvarchar(200),
	PublishedDate nvarchar(100),
	[Description] nvarchar(1500),
	OriginalTitle nvarchar(100),
	Duration int,
	PicturePath nvarchar(300),
	Link nvarchar(300),
	OpeningDate nvarchar(100)
)
GO

CREATE TABLE Genre
(
	IDGenre int constraint PK_Genre primary key identity,
	[Name] nvarchar(50)
)
GO

CREATE TABLE MovieGenre
(
	IDMovieGenre int constraint PK_Movie_Genre primary key identity,
	MovieID int constraint FK_MovieGenre_Movie foreign key references Movie(IDMovie),
	GenreID int constraint FK_MovieGenre_Genre foreign key references Genre(IDGenre)
)
GO

CREATE TABLE PersonType
(
	IDPersonType int constraint PK_Person_Type primary key identity,
	[Name] nvarchar(50)
)
GO

CREATE TABLE Person
(
	IDPerson int constraint PK_Person primary key identity,
	FirstName nvarchar(50),
	LastName nvarchar(50),
	PersonTypeID int constraint FK_Person_PersonType foreign key references PersonType(IDPersonType)
)
GO

CREATE TABLE MoviePerson
(
	IDMoviePerson int constraint PK_Movie_Person primary key identity,
	MovieID int constraint FK_MoviePerson_Movie foreign key references Movie(IDMovie),
	PersonID int constraint FK_MoviePerson_Person foreign key references Person(IDPerson)
)
GO

CREATE TABLE UserType
(
	IDUserType int constraint PK_User_Type primary key identity,
	[Name] nvarchar(50)
)
GO

CREATE TABLE [User]
(
	IDUser int constraint PK_User primary key identity,
	Username nvarchar(50),
	[Password] nvarchar(20),
	UserTypeID int constraint FK_User_UserType foreign key references UserType(IDUserType)
)
GO


CREATE TABLE UserMovie
(
	IDUserMovie int constraint PK_User_Movie primary key identity,
	UserID int constraint FK_UserMovie_User foreign key references [User](IDUser),
	MovieID int constraint FK_UserMovie_Movie foreign key references Movie(IDMovie)
)
GO

CREATE TABLE UserGenre
(
	IDUserGenre int constraint PK_User_Genre primary key identity,
	UserID int constraint FK_UserGenre_User foreign key references [User](IDUser),
    GenreID int constraint FK_UserGenre_Genre foreign key references Genre(IDGenre)
)
GO

CREATE TABLE UserPerson
(
	IDUserPerson int constraint PK_User_Person primary key identity,
	UserID int constraint FK_UserPerson_User foreign key references [User](IDUser),
	PersonID int constraint FK_UserPerson_Person foreign key references Person(IDPerson)
)
GO

/*
INSERTING NEEDED DATA INTO TABLES UserType AND PersonType
*/
INSERT INTO UserType values('Admin') --ID=1
GO
INSERT INTO UserType values('User')--ID=2
GO

INSERT INTO PersonType values('Director') -- ID=1
GO
INSERT INTO PersonType values('Actor') --ID=2
GO


--CREATING PROCEDURES

--CRUD operations on table Genre
CREATE  OR ALTER PROCEDURE createGenre
	@Name nvarchar(50),
	@ID int output
AS 
BEGIN 
	if not exists (select IDGenre from Genre where [Name] = @Name) 
		BEGIN
			insert into Genre values(@Name)
			set @ID = SCOPE_IDENTITY()
		END
	else
		BEGIN
			select @ID=IDGenre from Genre where [Name] = @Name
		END
END
GO

CREATE  OR ALTER PROCEDURE updateGenre
	@IDGenre int,
	@Name nvarchar(50)
	 
AS 
BEGIN 
	update Genre set Name = @Name
	where IDGenre = @IDGenre
END
GO


CREATE  OR ALTER PROCEDURE deleteGenre
	@IDGenre int	 
AS 
BEGIN 
	delete from MovieGenre
	where GenreID = @IDGenre

	delete from UserGenre
	where GenreID = @IDGenre
	
	delete from Genre
	where IDGenre = @IDGenre
END
GO

CREATE  OR ALTER PROCEDURE selectGenre
	@IDGenre int
AS 
BEGIN 
	select * from Genre
	where IDGenre = @IDGenre
END
GO


CREATE  OR ALTER PROCEDURE selectGenres
AS 
BEGIN 
	select * from Genre
END
GO


--	CRUD operations on table Person

CREATE  OR ALTER PROCEDURE createActor
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@ID int output
AS 
BEGIN 
	if not exists (select IDPerson from Person where FirstName = @FirstName AND LastName = @LastName AND PersonTypeID=2) 
	BEGIN
		insert into Person values(@FirstName, @LastName, 2)
		set @ID = SCOPE_IDENTITY()
	END
	else
	BEGIN
		select @ID=IDPerson from Person where FirstName = @FirstName AND LastName = @LastName AND PersonTypeID=2
	END
END
GO


CREATE  OR ALTER PROCEDURE updateActor
	@IDPerson int,
	@FirstName nvarchar(50),
	@LastName nvarchar(50)
	 
AS 
BEGIN 
	update Person set FirstName = @FirstName, LastName = @LastName
	where IDPerson = @IDPerson
END
GO


CREATE  OR ALTER PROCEDURE deleteActor
	@IDPerson int	 
AS 
BEGIN 
	delete from MoviePerson
	where PersonID = @IDPerson

	delete from Person
	where IDPerson = @IDPerson
END
GO


CREATE  OR ALTER PROCEDURE selectActor
	@IDPerson int
AS 
BEGIN 
	select * from Person
	where IDPerson = @IDPerson AND PersonTypeID=2
END
GO

CREATE  OR ALTER PROCEDURE selectActors
AS 
BEGIN 
	select * from Person
	where PersonTypeID = 2
END
GO



CREATE  OR ALTER PROCEDURE createDirector
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@ID int output
AS 
BEGIN 
	if not exists (select IDPerson from Person where FirstName = @FirstName AND LastName = @LastName AND PersonTypeID=1) 
	BEGIN
		insert into Person values(@FirstName, @LastName, 1)
		set @ID = SCOPE_IDENTITY()
	END
	else
	BEGIN
		select @ID=IDPerson from Person where FirstName = @FirstName AND LastName = @LastName AND PersonTypeID=1
	END
END
GO


CREATE  OR ALTER PROCEDURE updateDirector
	@IDPerson int,
	@FirstName nvarchar(50),
	@LastName nvarchar(50)
	 
AS 
BEGIN 
	update Person set FirstName = @FirstName, LastName = @LastName
	where IDPerson = @IDPerson AND PersonTypeID=1
END
GO


CREATE  OR ALTER PROCEDURE deleteDirector
	@IDPerson int	 
AS 
BEGIN 
	delete from MoviePerson
	where PersonID = @IDPerson

	delete from Person
	where IDPerson = @IDPerson AND PersonTypeID=1
END
GO


CREATE  OR ALTER PROCEDURE selectDirector
	@IDPerson int
AS 
BEGIN 
	select * from Person
	where IDPerson = @IDPerson AND PersonTypeID=1
END
GO


CREATE  OR ALTER PROCEDURE selectDirectors
AS 
BEGIN 
	select * from Person
	where PersonTypeID = 1
END
GO

---------------------------------------------------------------------------------------------------------------------------------------------------
--CRUD operations on table Movie

CREATE  OR ALTER PROCEDURE createMovie
	@Title nvarchar(200),
	@PublishedDate nvarchar(100),
	@Description nvarchar(1500),
	@OriginalTitle nvarchar(100),
	@Duration int,
	@PicturePath nvarchar(300),
	@Link nvarchar(300),
	@OpeningDate nvarchar(100),
	@ID int output
AS 
BEGIN 
	if not exists (select IDMovie from Movie where Title=@Title)
		begin
		insert into Movie values(@Title,@PublishedDate,@Description,@OriginalTitle,@Duration,@PicturePath,@Link,@OpeningDate)
		set @ID = SCOPE_IDENTITY()
		end
	else
	 begin
		select IDMovie from Movie where Title=@Title
	end
END
GO


CREATE  OR ALTER PROCEDURE updateMovie
	@IDMovie int,
	@Title nvarchar(200),
	@PublishedDate nvarchar(100),
	@Description nvarchar(1500),
	@OriginalTitle nvarchar(100),
	@Duration int,
	@PicturePath nvarchar(300),
	@Link nvarchar(300),
	@OpeningDate nvarchar(100)
as 
  BEGIN 
	update Movie set 
		Title = @Title,
		PublishedDate = @PublishedDate,
		[Description] = @Description,
		OriginalTitle = @OriginalTitle,
		Duration = @Duration,
		PicturePath = @PicturePath,
		Link = @Link,
		OpeningDate = @OpeningDate		
	where IDMovie = @IDMovie
END
GO


CREATE  OR ALTER PROCEDURE deleteMovie
	@IDMovie int	 
AS 
BEGIN 
	delete from MovieGenre
	where MovieID = @IDMovie

	delete from UserMovie
	where MovieID = @IDMovie

	delete from MoviePerson
	where MovieID = @IDMovie
		
	delete from Movie
	where IDMovie = @IDMovie
END
GO



CREATE  OR ALTER PROCEDURE selectMovie
	@IDMovie int
AS 
BEGIN 
	select * from Movie
	where IDMovie = @IDMovie
END
GO



CREATE  OR ALTER PROCEDURE selectMovies
AS 
BEGIN 
	select * from Movie
END
GO

--------------------------------------------------------------------------------------------------------------------------------------------

--CRUD operations on table USER


CREATE OR ALTER PROCEDURE createUser
	@Username nvarchar(50),
	@Password nvarchar(20),
	@id int output
AS 
BEGIN 
	if not exists (select IDUser from [User] where Username = @Username) 
	BEGIN
		insert into [User] values(@Username, @Password, 2)
		set @id=SCOPE_IDENTITY();
	END
	else
	BEGIN
		select IDUser from [User] where Username = @Username
	END
END
GO


CREATE  OR ALTER PROCEDURE createAdmin
	@Username nvarchar(50),
	@Password nvarchar(20),
	@ID int output
AS 
BEGIN 
	if not exists (select IDUser from [User] where Username = @Username) 
	BEGIN
		insert into [User] values(@Username, @Password, 1)
		set @ID = SCOPE_IDENTITY()
	END
	else
	BEGIN
		select @ID=IDUser from [User] where Username = @Username
	END
END
GO


CREATE  OR ALTER PROCEDURE updateUser
	@IDUser int,
	@Username nvarchar(50),
	@Password nvarchar(10)	 
AS 
BEGIN 
	update [User] set 
		[Username] = @Username,
		[Password] = @Password
	where IDUser = @IDUser
END
GO


CREATE OR ALTER PROCEDURE deleteUser
	@IDUser int	 
AS 
BEGIN
	delete from UserMovie
	where UserID=@IDUser

	delete from UserGenre
	where UserID=@IDUser

	delete from [User]
	where IDUser = @IDUser and UserTypeID=2
END
GO


CREATE  OR ALTER PROCEDURE selectUser
	@IDUser int
AS 
BEGIN 
	select * from [User]
	where IDUser = @IDUser 
END
GO


CREATE  OR ALTER PROCEDURE selectUsers
AS 
BEGIN 
	select * from [User] 
	
END
GO

-------------------------------------------------------------------------------------------------------------------------------------------------

--	CRUD operations on table MoviePerson

CREATE  OR ALTER PROCEDURE createMovieDirector
	@MovieID int,
	@PersonID int,
	@ID int output
AS 
BEGIN 
	if not exists (
	select IDMoviePerson from MoviePerson
	inner join Person as p on p.IDPerson=MoviePerson.PersonID 
	where PersonID = @PersonID and MovieID=@MovieID and PersonTypeID=1) 
	BEGIN
		insert into MoviePerson values(@MovieID, @PersonID)
		set @ID = SCOPE_IDENTITY()
	END
else
	BEGIN
		SELECT @ID=IDMoviePerson 
		FROM MoviePerson 
		INNER JOIN Person on Person.PersonTypeID = MoviePerson.PersonID
		WHERE PersonID = @PersonID and MovieID=@MovieID and PersonTypeID=1
	END
END
GO


CREATE  OR ALTER PROCEDURE updateMovieDirector
	@IDMoviePerson int, 
	@MovieID int,
	@PersonID int
AS 
BEGIN 
	update MoviePerson set PersonID=@PersonID ,MovieID=@MovieID
	where IDMoviePerson=@IDMoviePerson 
END
GO


CREATE  OR ALTER PROCEDURE deleteMovieDirector
	@IDMovie int
AS 
BEGIN 
	delete from MoviePerson where MovieID=@IDMovie
END
GO


CREATE  OR ALTER PROCEDURE selectMovieDirector
	@IDMoviePerson int
AS 
BEGIN 
	select pm.*
	from MoviePerson as pm
	inner join Person as p on p.IDPerson = pm.PersonID
	where IDMoviePerson=@IDMoviePerson AND p.PersonTypeID=1
END
GO


CREATE  OR ALTER PROCEDURE selectMovieDirectors
AS 
BEGIN 
	select * from MoviePerson as mp
	inner join Person as p on p.IDPerson = mp.PersonID
	where p.PersonTypeID=1
END
GO


CREATE  OR ALTER PROCEDURE getMovieDirectors
  @IDMovie int
AS 
BEGIN 
	select p.* from MoviePerson as mp
	inner join Person as p on p.IDPerson = mp.PersonID
	where p.PersonTypeID=1 AND mp.MovieID=@IDMovie
END
GO



----------------------------------------------------------------------------------------------------------------------------------------------------


--	CRUD operations on table MoviePerson


CREATE  OR ALTER PROCEDURE createMovieActor
	@MovieID int,
	@PersonID int,
	@ID int output
AS 
BEGIN 
	if not exists (
	select IDMoviePerson from MoviePerson
	inner join Person as p on p.IDPerson=MoviePerson.PersonID 
	where PersonID = @PersonID and MovieID=@MovieID and PersonTypeID=2) 
	BEGIN
		insert into MoviePerson values(@MovieID, @PersonID)
		set @ID = SCOPE_IDENTITY()
	END
else
	BEGIN
		SELECT @ID=IDMoviePerson 
		FROM MoviePerson 
		INNER JOIN Person on Person.PersonTypeID = MoviePerson.PersonID
		WHERE PersonID = @PersonID and MovieID=@MovieID and PersonTypeID=2
	END
END
GO


CREATE  OR ALTER PROCEDURE updateMovieActor
	@IDMoviePerson int, 
	@MovieID int,
	@PersonID int
AS 
BEGIN 
	update MoviePerson set PersonID=@PersonID ,MovieID=@MovieID
	where IDMoviePerson=@IDMoviePerson 
END
GO


CREATE  OR ALTER PROCEDURE deleteMovieActor
	@IDMovie int
AS 
BEGIN 
	delete from MoviePerson where MovieID=@IDMovie
END
GO


CREATE  OR ALTER PROCEDURE selectMovieActor
	@IDMoviePerson int
AS 
BEGIN 
	select pm.*
	from MoviePerson as pm
	inner join Person as p on p.IDPerson = pm.PersonID
	where IDMoviePerson=@IDMoviePerson AND p.PersonTypeID=2
END
GO


CREATE  OR ALTER PROCEDURE selectMovieActors
AS 
BEGIN 
	select * from MoviePerson as mp
	inner join Person as p on p.IDPerson = mp.PersonID
	where p.PersonTypeID=2
END
GO


CREATE  OR ALTER PROCEDURE getMovieActors
  @IDMovie int
AS 
BEGIN 
	select p.* from MoviePerson as mp
	inner join Person as p on p.IDPerson = mp.PersonID
	where p.PersonTypeID=2 AND mp.MovieID=@IDMovie
END
GO

-------------------------------------------------------------------------------------------------------------------

--	CRUD operations on table MovieGenre

CREATE  OR ALTER PROCEDURE createMovieGenre
	@MovieID int,
	@GenreID int,
	@ID int output
AS 
BEGIN 
	if not exists (
	select IDMovieGenre from MovieGenre
	where GenreID = @GenreID and MovieID=@MovieID ) 
	BEGIN
		insert into MovieGenre values(@MovieID, @GenreID)
		set @ID = SCOPE_IDENTITY()
	END
else
	BEGIN
		SELECT @ID=IDMovieGenre 
		FROM MovieGenre
		WHERE GenreID = @GenreID and MovieID=@MovieID
	END
END
GO


CREATE  OR ALTER PROCEDURE updateMovieGenre
	@IDMovieGenre int, 
	@MovieID int,
	@GenreID int
AS 
BEGIN 
	update MovieGenre set GenreID=@GenreID ,MovieID=@MovieID
	where IDMovieGenre=@IDMovieGenre 
END
GO


CREATE  OR ALTER PROCEDURE deleteMovieGenre
	@IDMovie int
AS 
BEGIN 
	delete from MovieGenre where MovieID=@IDMovie
END
GO


CREATE  OR ALTER PROCEDURE selectMovieGenre
	@IDMovieGenre int
AS 
BEGIN 
	select *
	from MovieGenre
	where IDMovieGenre=@IDMovieGenre
END
GO


CREATE  OR ALTER PROCEDURE selectMovieGenres
AS 
BEGIN 
	select * from MovieGenre
END
GO


CREATE  OR ALTER PROCEDURE getMovieGenres
  @IDMovie int
AS 
BEGIN 
	select g.* from MovieGenre as mg
	inner join Genre as g on g.IDGenre=mg.GenreID
	where  mg.MovieID=@IDMovie
END
GO


----------------------------------------------------------------------------------------------------------------------------------------------

--CRUD operations on table UserMovie

CREATE  OR ALTER PROCEDURE createUserMovie
   @UserID int,
   @MovieID int
AS
BEGIN 
	if not exists (
	select IDUserMovie from UserMovie
	where UserID = @UserID and MovieID=@MovieID ) 
	BEGIN
		insert into UserMovie values(@UserID, @MovieID)
	END
else
	BEGIN
		SELECT * 
		FROM UserMovie
		WHERE UserID= @UserID and MovieID=@MovieID
	END
END
GO


CREATE  OR ALTER PROCEDURE updateUserMovie
	@IDUserMovie int, 
	@UserID int,
	@MovieID int
AS 
BEGIN 
	update UserMovie set UserID=@UserID,MovieID=@MovieID
	where IDUserMovie=@IDUserMovie 
END
GO


CREATE  OR ALTER PROCEDURE deleteUserMovie
	@UserID int,
	@MovieID int
AS 
BEGIN 
	delete from UserMovie where  UserID= @UserID and MovieID=@MovieID
END
GO


CREATE  OR ALTER PROCEDURE selectUserMovie
	@IDUserMovie int
AS 
BEGIN 
	select *
	from UserMovie
	where IDUserMovie= @IDUserMovie
END
GO


CREATE  OR ALTER PROCEDURE selectUserMovies
 @id int
AS 
BEGIN 
	select m.* from UserMovie
	inner join Movie as m on m.IDMovie=MovieID
	where UserID=@id
END
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------


--CRUD operations on table UserGenre

CREATE  OR ALTER PROCEDURE createUserGenre
   @UserID int,
   @GenreID int,
   @ID int output
AS
BEGIN 
	if not exists (
	select IDUserGenre from UserGenre
	where UserID = @UserID and GenreID=@GenreID ) 
	BEGIN
		insert into UserGenre values(@UserID, @GenreID)
		set @ID=SCOPE_IDENTITY()
	END
else
	BEGIN
		SELECT IDUserGenre
		FROM UserGenre
		WHERE UserID= @UserID and GenreID=@GenreID
	END
END
GO


CREATE  OR ALTER PROCEDURE updateUserGenre
	@IDUserGenre int, 
	@UserID int,
	@GenreID int
AS 
BEGIN 
	update UserGenre set UserID=@UserID,GenreID=@GenreID
	where IDUserGenre=@IDUserGenre 
END
GO


CREATE  OR ALTER PROCEDURE deleteUserGenre
	@UserID int,
	@GenreID int
AS 
BEGIN 
	delete from UserGenre where UserID= @UserID and GenreID=@GenreID
END
GO


CREATE  OR ALTER PROCEDURE selectUserGenre
	@IDUserGenre int
AS 
BEGIN 
	select *
	from UserGenre
	where IDUserGenre= @IDUserGenre
END
GO


CREATE  OR ALTER PROCEDURE selectUserGenres
   @id int
AS 
BEGIN 
	select g.* from UserGenre
	inner join Genre as g on g.IDGenre=GenreID
	where UserID=@id
END
GO


-----------------------------------------------------------------------------------------------------------------------------

/* creating admin login in database and admin procedute deleteAll*/

declare @id int
exec createAdmin 'admin', 'admin', @id output
GO



CREATE  OR ALTER PROCEDURE deleteAll
AS
BEGIN
	delete from UserMovie
	delete from UserGenre
	delete from UserPerson
	delete from [User]
	where UserTypeID=2
	delete from MoviePerson
	delete from MovieGenre
	delete from Movie
	delete from Person
	delete from Genre
END
GO



/*TABLE DATA*/


GO
SET IDENTITY_INSERT [dbo].[Movie] ON 
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (1, N'Rumba terapija', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Toni je pedesetogodišnji vozač školskog autobusa na selu koji je usamljenik i živi povučeno. Uznemiren srčanim udarom, odlučuje da se suoči sa svojom prošlošću i stupi u kontakt sa Marijom, ćerkom koju nikada nije poznavao, tako što će se upisati u školu plesa koju ona vodi. Ali… ne možete improvizovati rumbu! U svojim kaubojskim čizmama i džins jakni, Toni će morati dobro da se pomuči i potrudi kako bi se približio svojoj ćerki… i za to vreme će bolje upoznati sebe, ali i otvoriti se prema drugima.</div>
<br />Početak prikazivanja: 1.9.202', N'Rumba Therapy', 102, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/rumba-terapija/8345//1', N'1.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (3, N'Tri hiljade godina čežnje', N'2022-08-29T17:38:21', N'Usamljena naučnica, na putovanju u Istanbul, otkriva Džina koji joj nudi tri želje u zamenu za svoju slobodu.
<br />Početak prikazivanja: 1.9.202', N'Three Thousand Years of Longing', 108, N'src\assets\1273e250-0963-40eb-aeda-f6b4b9635d59.jpg', N'https://www.blitz-cinestar.hr/root/tri-hiljade-godina-ceznje/8256//1', N'1.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (4, N'Tri tisuće godina čežnje', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Uspješna, ali usamljena akademkinja, dr. Alithea Binnie zadovoljna je svojim životom i stvorenje je razuma. Na konferenciji u Istanbulu susreće Djina koji joj nudi tri želje u zamjenu za svoju slobodu. Ovo predstavlja dva problema. Prvo, doktorica sumnja da je on uopće stvaran, a drugo, budući da je znanstvenica, zna vrlo dobro sve priče o ‘pogrešnim’ željama. Djin je pak nastoji uvjeriti u suprotno pričajući joj fantastične priče o svojoj prošlosti. U konačnici doktorica zaželi želju koja ih oboje iznenadi.</div>
<br />Početak prikazivanja: 1.9.202', N'Three Thousand Years of Longing', 108, N'src\assets\1273e250-0963-40eb-aeda-f6b4b9635d59.jpg', N'https://www.blitz-cinestar.hr/root/tri-tisuce-godina-ceznje/8333//1', N'1.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (5, N'Vatreno srce - sink', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Šesnaestogodišnja Georgia Nolan želi krenuti stopama svog oca i sanja o tome da bude prva vatrogaskinja na svijetu.<br />
Kad misteriozni piroman počne paliti seriju podmetnutih požara po Broadwayu, njujorški vatrogasci počinju misteriozno nestajati. Gradonačelnik New Yorka poziva Georgijina oca iz mirovine da vodi istragu o nestancima. Očajnički želeći pomoći ocu i spasiti svoj grad, Georgia se prerušava u mladića zvanog "Joe" i pridružuje se maloj skupini hrabrih vatrogasaca koji pokušavaju zaustaviti piromana.</div>
<br />Početak prikazivanja: 1.9.202', N'Fireheart', 92, N'src\assets\5fd8e767-5020-4389-baeb-f48ef8d9e873.jpg', N'https://www.blitz-cinestar.hr/root/vatreno-srce-sink/8272//1', N'1.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (6, N'Ajkula ljudožder', N'2022-08-29T17:38:21', N'Nakon nesreće tokom njihovog odmora na rajskom ostrvu, grupu prijatelja uhodi velika ajkula.
<br />Početak prikazivanja: 8.9.202', N'Maneater', 87, N'src\assets\5a8ea94d-9722-410b-a842-f0357ebf684a.jpg', N'https://www.blitz-cinestar.hr/root/ajkula-ljudozder/8255//1', N'8.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (7, N'Ja sam Zlatan', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">„Ja sam Zlatan“ filmska je priča o Zlatanu Ibrahimoviću odnosno o njegovom odrastanju u neuglednom predgrađu švedskog grada. Kao sin imigranata s Balkana, nogomet je Zlatanu predstavljao oslobođenje od teške zajednice u kojoj je živio, a tijekom kojeg je pokazao svu veličinu svog nevjerojatnog talenta i samopouzdanja koji su ga kasnije, unatoč potpuno drugačijim predviđanjima, katapultirali u jednog od najvećih nogometnih igrača 21. stoljeća koji je zaigrao za klubove kao što su Ajax, Juventus, Inter, Milan, Barcelona, Paris Saint-Germain te Manchester United.</div>
<br />Početak prikazivanja: 8.9.202', N'I Am Zlatan', 102, N'src\assets\9390bfc4-37f7-4951-b690-66a067f1c1ed.jpg', N'https://www.blitz-cinestar.hr/root/ja-sam-zlatan/8299//1', N'8.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (8, N'Kung Fu Zohra', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Uvjerena da će je razvod zauvijek odvojiti od kćeri, Zohra se ne može natjerati da napusti muža, unatoč njegovom nasilnom ponašanju. U tišini trpi njegove udarce, ali sve se mijenja kada upozna Chang Sue.<br />
Zohra je u početku zadovoljna svojim brakom s Omarom, ali njegova ljubomorna strana sve više izlazi na vidjelo. Kada je udari i odmah se krene ispričavati, Zohra mu želi oprostiti, kao što to čine mnoge žrtve obiteljskog nasilja. Tek kad on stvarno ode predaleko, Zohra shvaća da se mora od njega maknuti zauvijek. Međutim, odluka nije laka: imaju zajedničku kćer, koja voli svog oca.<br />
Zohra je oduvijek voljela kung fu filmove te počinje učiti azijsku borilačku vještinu. Pomaže joj tajanstveni zaštitar u teretani u kojoj radi. Korak po korak, Zohra radi na svom oslobođenju.</div>
<br />Početak prikazivanja: 8.9.202', N'Kung Fu Zohra', 100, N'src\assets\a2c5abb8-6f5c-479e-9265-a55ddb578dcb.jpg', N'https://www.blitz-cinestar.hr/root/kung-fu-zohra/8274//1', N'8.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (9, N'Sveta Petka - Krst u pustinji', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Pobožna devojka Paraskeva, napušta svoj život među ljudima u gradu Konstantinopolju i odlazi u Jordansku pustinju gde provodi narednih 40 godina svog života boreći se sa iskušenjima, gresima i unutarnjim demonima. Pratimo njen put od obične devojke do najvoljenije i najpoštovanije Svetiteljke Pravoslavlja.<br />
Bočna priča nam govori o dve žene (arapkinji Zejnebi iz beduinskog plemena i Paraskevi) koje potiču iz različitih kulturnih, socijalnih i verskih sredina, ali dele iste ljudske emocije, vrednosti i stvaraju neobično prijateljstvo svojim čistim srcima. Tokom boravka u pustinji, Zejneba je Paraskevin jedini prijatelj, ali i ogledalo i odraz spoljnjeg sveta koji je Paraskeva napustila.<br />
Film je nastao po istinitoj priči i romanu "Petkana" Ljiljane Habjanović Đurović.<br />
Ova priča nam govori kako ljudi mogu da pobede svoje slabosti. Teme filma su univerzalna moralna pitanja čovečanstva, što ga čini aktuelnim i danas, bilo gde na svetu.</div>
<br />Početak prikazivanja: 8.9.202', N'Sveta Petka - Krst u pustinji', 123, N'src\assets\48381a35-17c1-4bf6-8270-65506112515f.jpg', N'https://www.blitz-cinestar.hr/root/sveta-petka-krst-u-pustinji/8346//1', N'8.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (10, N'Dvostruka prijevara', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Dobitnik nagrade za najbolju režiju na filmskom festivalu u Cannesu! Novi film velikog južnokorejskog redatelja Parka Chana Wooka kriminalistička je drama koja prati policijskog detektiva Hae-joona (Park Hae-il) pozvanog da istraži tajanstvenu smrt muškarca koji je pao s planinskog vrha. Tijekom istrage detektiv počinje razvijati osjećaje prema udovici unesrećenog, Seo-rae (Tang Wei), koja je osumnjičena u slučaju.<br />
 </div>
<br />Početak prikazivanja: 15.9.202', N'Decision to Leave', 138, N'src\assets\efca5be5-9ed4-485a-977c-997f37c2e91b.jpg', N'https://www.blitz-cinestar.hr/root/dvostruka-prijevara/8301//1', N'15.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (11, N'Pad', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Nakon što Dan pogine penjući se na Rocky Mountains, njegova djevojka Becky i njezina prijateljica Hunter odluče se popeti na golemi komunikacijski toranj, visok preko 600 metara, s kojeg žele baciti Danov pepeo. Na znatnoj udaljenosti od tla, kada dio istrošene konstrukcije tornja otpadne, njihov se uspon nepovratno zakomplicira. Ne mogu sići, ni tražiti pomoć putem mobitela, jer su totalno odsječene od civilizacije i mobilnog signala. Neće imati drugog izbora nego boriti se za preživljavanje.</div>
<br />Početak prikazivanja: 15.9.202', N'Fall', 107, N'src\assets\5f49794b-8657-4dbd-a824-bd0971a0218e.jpg', N'https://www.blitz-cinestar.hr/root/pad/8336//1', N'15.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (12, N'Avatar', N'2022-08-29T17:38:21', N'<div style="text-align: justify;"><span style="font-family:arial,sans-serif; font-size:10pt; line-height:107%">Nagradom Oscar&reg; nagrađena epska avantura Jamesa Camerona iz 2009. godine, Avatar, film s najvećom zaradom svih vremena, vraća se u kina u zanosnom 4K visoko dinamičnom rasponu. Ljubitelji filmova će imati priliku istražiti daleki svijet Pandore u 2154. godini, u 3D, 4DX i IMAX formatu. U Avataru, koji je napisao i režirao dobitnik nagrade Oscar&reg; James Cameron, glume Sam Worthington, Zoe Saldana, Stephen Lang, Michelle Rodriguez i Sigourney Weaver. Film su producirali James Cameron i Jon Landau. Avatar je bio nominiran za devet nagrada Oscar&reg;, uključujući najbolji film i najbolji redatelj, a osvojio je tri nagrade Oscar&reg; - za najbolju fotografiju, produkcijski dizajn i vizualne efekte.</span></div>
<br />Početak prikazivanja: 22.9.202', N'Avatar', 163, N'src\assets\1d996513-19e6-40c5-bdfe-777fd214ba65.jpg', N'https://www.blitz-cinestar.hr/root/avatar/8354//1', N'22.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (13, N'Avatar 3D 4DX', N'2022-08-29T17:38:21', N'Nagradom Oscar® nagrađena epska avantura Jamesa Camerona iz 2009. godine, Avatar, film s najvećom zaradom svih vremena, vraća se u kina u zanosnom 4K visoko dinamičnom rasponu. Ljubitelji filmova će imati priliku istražiti daleki svijet Pandore u 2154. godini, u 3D, 4DX i IMAX formatu. U Avataru, koji je napisao i režirao dobitnik nagrade Oscar® James Cameron, glume Sam Worthington, Zoe Saldana, Stephen Lang, Michelle Rodriguez i Sigourney Weaver. Film su producirali James Cameron i Jon Landau. Avatar je bio nominiran za devet nagrada Oscar®, uključujući najbolji film i najbolji redatelj, a osvojio je tri nagrade Oscar® - za najbolju fotografiju, produkcijski dizajn i vizualne efekte.
<br />Početak prikazivanja: 22.9.202', N'Avatar 3D 4DX', 163, N'src\assets\1d996513-19e6-40c5-bdfe-777fd214ba65.jpg', N'https://www.blitz-cinestar.hr/root/avatar-3d-4dx/8355//1', N'22.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (14, N'Avatar 3D IMAX', N'2022-08-29T17:38:21', N'Nagradom Oscar® nagrađena epska avantura Jamesa Camerona iz 2009. godine, Avatar, film s najvećom zaradom svih vremena, vraća se u kina u zanosnom 4K visoko dinamičnom rasponu. Ljubitelji filmova će imati priliku istražiti daleki svijet Pandore u 2154. godini, u 3D, 4DX i IMAX formatu. U Avataru, koji je napisao i režirao dobitnik nagrade Oscar® James Cameron, glume Sam Worthington, Zoe Saldana, Stephen Lang, Michelle Rodriguez i Sigourney Weaver. Film su producirali James Cameron i Jon Landau. Avatar je bio nominiran za devet nagrada Oscar®, uključujući najbolji film i najbolji redatelj, a osvojio je tri nagrade Oscar® - za najbolju fotografiju, produkcijski dizajn i vizualne efekte.
<br />Početak prikazivanja: 22.9.202', N'Avatar 3D IMAX', 163, N'src\assets\1d996513-19e6-40c5-bdfe-777fd214ba65.jpg', N'https://www.blitz-cinestar.hr/root/avatar-3d-imax/8356//1', N'22.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (15, N'Ne brini draga', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Alis i Džek imaju sreće što žive u idealizovanoj zajednici „Viktorija“, eksperimentalnom kompanijskom gradu u kom žive muškarci koji rade za tajni projekat „Viktorija“ i njihove porodice. Društveni optimizam iz 1950-ih koji je zastupao njihov izvršni direktor Frenk – korporativni vizionarski i motivacioni životni trener – usidrio se u svaki aspekt svakodnevnog života u tesno povezanoj pustinjskoj utopiji. Dok muževi provode svaki dan u sedištu projekta „Viktorija“, radeći na „razvoju progresivnih materijala“, njihove žene – uključujući Frenkovu elegantnu partnerku Šeli – provode vreme uživajući u lepoti, luksuzu i razvratu svoje zajednice. Život je savršen, a potrebe svakog stanara ispunjava kompanija. Sve što traže zauzvrat je diskrecija i neupitna posvećenost cilju pobede. Ali kada počnu da se pojavljuju pukotine u njihovom idiličnom životu, otkrivajući bljeskove nečeg mnogo zlokobnijeg što vreba ispod atraktivne fasade, Alisa ne može, a da ne dovede u pitanje šta tačno rade u „Viktoriji“ i zašto. Koliko je Alisa spremna da izgubi da bi otkrila šta se zaista dešava u ovom raju?</div>

<br />Početak prikazivanja: 22.9.202', N'Don’t Worry Darling', 122, N'src\assets\b37ccac4-3c64-4604-a8d7-296aa6519180.jpg', N'https://www.blitz-cinestar.hr/root/ne-brini-draga/8262//1', N'22.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (16, N'Put oko sveta za 80 dana - sinh', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Paspartu je mlad i učeni marmozet koji sanja da postane istraživač. Jednog dana, on upoznaje Fileja, nepromišljenog i pohlepnog žabca, koji želi da se opkladi da će oploviti svet za 80 dana i zaradite 10 miliona školjki u tom procesu. Iskoristivši priliku koju čeka ceo svoj život, da istražuje svet, Paspartu kreće sa svojim novim prijateljem u ludu i uzbudljiva avanturu punu obrta i iznenađenja.<br />
 </div>
<br />Početak prikazivanja: 22.9.202', N'Around the World in 80 Days', 82, N'src\assets\1f3cf69f-e764-4b77-822d-2bd897974023.jpg', N'https://www.blitz-cinestar.hr/root/put-oko-sveta-za-80-dana-sinh/8261//1', N'22.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (17, N'Put oko svijeta za 80 dana - sink', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Simpatični minijaturni Passepartout je mladi znanstvenik koji oduvijek sanja o tome da postane veliki istraživač. Jednog dana, on se susreće s Phileasom, žapcem koji prihvaća okladu da će u 80 dana obići svijet. Iskoristivši životnu priliku u kojoj će obići niz egzotičnih zemalja, Passepartout kreće sa svojim novim prijateljem u ludu i uzbudljivu avanturu punu obrata i iznenađenja.<br />
 </div>
<br />Početak prikazivanja: 22.9.202', N'Around the World in 80 Days', 82, N'src\assets\1f3cf69f-e764-4b77-822d-2bd897974023.jpg', N'https://www.blitz-cinestar.hr/root/put-oko-svijeta-za-80-dana-sink/8337//1', N'22.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (18, N'Madam Baterflaj', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Ljubav ne ubija već donosi novi život<br />
Tokom zvezdane noći u Nagasakiju, upravo je te reči mladoj gejši Cio – Cio San izgovorio oficir Američke ratne mornarice. Ali kako su oboje naučili, reči i obećanja nesmotreno izgovoreni, mogu imati dugoročne posledice.<br />
S pozorišnim komadom koji uključuje i ariju od Butterfly, Un bel di, vedremo I “Humming Chorus”, opera Giacoma Puccinija je prelepa i u celosti srceparajuća. Za ovu izuzetnu produkciju opera, Moshe Leiser i Patrice Caurier, inspiraciju su crpili iz evropskog poimanja Japana tokom 19. veka.</div>
<br />
<br />Početak prikazivanja: 27.9.202', N'Madama Butterfly', 190, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/madam-baterflaj/8305//1', N'27.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (19, N'Madama Butterfly', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Ljubav ne ubija već donosi novi život<br />
Tijekom zvjezdane noći u Nagasakiju, upravo je te riječi mladoj gejši Cio – Cio San izgovorio časnike Američke ratne mornarice. Ali kako su oboje naučili, riječi I obećanja nesmotreno izgovoreni, mogu imati dalekosežne posljedice.<br />
S kazališnim komadom koji uključuje i ariju od Butterfly, Un bel di, vedremo I “Humming Chorus”, opera Giacoma Puccinija je prekrasna i u cijelosti srcedrapajuća. Za ovu izuzetnu produkciju opera, Moshe Leiser I Patrice Caurier, inspiraciju su crpili iz europskog poimanja Japana iz 19. stoljeća.</div>
<br />Početak prikazivanja: 27.9.202', N'Madame Butterfly', 190, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/madama-butterfly/8318//1', N'27.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (20, N'Dobra kuća', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Život agentkinje za nekretnine u Novoj Engleskoj Hildi Gud počinje da se raspliće kada se ponovo poveže sa svojim starim iskrama iz Njujorka.<br />
Zasnovano na knjizi The Good House spisateljice En Liri.</div>

<br />Početak prikazivanja: 29.9.202', N'The Good House', 114, N'src\assets\20b47004-b991-4f03-a514-3db1415cec20.jpg', N'https://www.blitz-cinestar.hr/root/dobra-kuca/8263//1', N'29.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (21, N'Moonage Daydream', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Moonage Daydream osvjetljava život i genijalnost Davida Bowieja, jednog od najplodnijih i najutjecajnijih umjetnika našeg vremena i prvi je film koji je podržao David Bowie Estate, koji je redatelju omogućio neviđeni pristup njihovoj kolekciji.<br />
Ispričan uzvišenim, kaleidoskopskim slikama, osobnim arhiviranim snimkama, neviđenim izvedbama, te utemeljen glazbom i riječima Davida Bowieja, MOONAGE DAYDREAM poziva publiku da urone u jedinstveni svijet koji je "Bowie".<br />
Godine 2018. Morgenu je dodijeljen pristup bez presedana Bowiejevom arhivu koji obuhvaća cijeli životni materijal, uključujući opsežan katalog neviđenih snimaka i osobnu kolekciju njegove vlastite umjetnosti i poezije. Morgen je proveo četiri godine sklapajući film i još 18 mjeseci dizajnirajući zvučnu kulisu, animacije i paletu boja.<br />
Tijekom svoje karijere, kroz generacije, Bowie nas je učio da su naše razlike naše snage.<br />
S MOONAGE DAYDREAM, Bowie nam daje putokaz kako preživjeti 21. stoljeće, pozivajući publiku da slavi njegovu ostavštinu kao nikada prije.</div>
<br />Početak prikazivanja: 29.9.202', N'Moonage Daydream', 140, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/moonage-daydream/8347//1', N'29.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (22, N'Osmeh', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Nakon što je bila svedok bizarnog, traumatičnog događaja u koji je bio umešan i jedan pacijent, doktorka Rouz Koter počinje da oseća zastrašujuće pojave koje ne može da objasni. Dok nezamislivi užas polako obuzima njen život, Rouz mora da se suoči sa svojom problematičnom prošlošću, kako bi preživela i pobegla od svoje zastrašujuće, nove stvarnosti.</div>
<br />Početak prikazivanja: 29.9.202', N'Smile', 115, N'src\assets\c1b13b18-4f20-46bc-98bf-c39c5f7953c8.jpg', N'https://www.blitz-cinestar.hr/root/osmeh/8331//1', N'29.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (23, N'Smiješak', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Nakon što je bila svjedok bizarnog, traumatičnog događaja u koji je bio umiješan i jedan pacijent, doktorica Rose Cotter počinje osjećati zastrašujuće pojave koje ne može objasniti. Dok nezamislivi užas počinje obuzimati njezin život, Rose se mora suočiti sa svojom problematičnom prošlošću, kako bi preživjela i pobjegla od zastrašujuće, nove stvarnosti.</div>
<br />Početak prikazivanja: 29.9.202', N'Smile', 115, N'src\assets\c1b13b18-4f20-46bc-98bf-c39c5f7953c8.jpg', N'https://www.blitz-cinestar.hr/root/smijesak/8339//1', N'29.9.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (24, N'Majerling', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Inspirisan mračnim i uzbudljivim događajima iz stvarnog života, ovaj klasik Royal baleta prikazuje seksualne i morbidne opsesije prestolonaslednika Rudolfa koje su dovele do skandala ubistva i samoubistva sa njegovom ljubavnicom Mary Vetsera. Opresivni glamur austrougarskog dvora 1880-ih idealno je vreme za napetu dramu psiholoških i političkih intriga dok se Rudolf bavi sopstvenom smrtnošću.<br />
Balet Kennetha MacMillana iz 1978. ostaje remek-delo pripovedanja, a ovo uprizorenje obeležava 30 godina od koreografove smrti. Očekujte Royal balet u njegovom dramatičnom vrhuncu kroz moćne scene ansambla i neke od najhrabrijih i emocionalno najzahtevnijih pas de deux-ova na baletnom repertoaru.</div>
<br />Početak prikazivanja: 5.10.202', N'Mayerling', 205, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/majerling/8306//1', N'5.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (25, N'Mayerling', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Inspiriran mračnim i uzbudljivim događajima iz stvarnog života, ovaj klasik Royal baleta prikazuje seksualne i morbidne opsesije prijestolonasljednika Rudolfa koje su dovele do skandala ubojstva i samoubojstva s njegovom ljubavnicom Mary Vetsera. Opresivni glamur austrougarskog dvora 1880-ih idealno je vrijeme za napetu dramu psiholoških i političkih intriga dok se Rudolf  bavi vlastitom smrtnošću.<br />
Balet Kennetha MacMillana iz 1978. ostaje remek-djelo pripovijedanja, a ovo uprizorenje obilježava 30 godina od koreografove smrti. Očekujte Royal belt u njegovom dramatičnom vrhuncu kroz moćne scene ansambla i neke od najhrabrijih i emocionalno najzahtjevnijih pas de deux-ova na baletnom repertoaru.</div>
<br />Početak prikazivanja: 5.10.202', N'Mayerling', 205, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/mayerling/8319//1', N'5.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (26, N'Amsterdam', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Radnja smeštena u 30-te, prati tri prijatelja koji su svedoci ubistva, sami postaju osumnjičeni i otkrivaju jednu od najneverovatnijih zavera u američkoj istoriji.</div>
<br />Početak prikazivanja: 6.10.202', N'Amsterdam', 0, N'src\assets\f3d31250-7e15-4327-bbf4-6221b9539792.jpg', N'https://www.blitz-cinestar.hr/root/amsterdam/8343//1', N'6.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (27, N'Aida', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Princeza Aida, dragocen plen iz rata između Egipta i Etiopije- je oteta. U međuvremenu, ambiciozni vojnik Radames bori se sa svojim osjećanjima prema Aidi. Kako se zbližavaju, oboje moraju napraviti mučan izbor između odanosti prema domu i međusobnoj ljubavi.<br />
U ovoj novoj produkciji, reditelj Robert Carsen smešta Verdijevu političku dramu velikih razmera u savremeni svet, smeštajući borbu za moć i otrovnu ljubomoru u kontekst moderne, totalitarne države. Muzički direktor Royal Opere Antonio Pappano diriguje Verdijevom slavnom, monumentalnom partiturom.</div>
<br />Početak prikazivanja: 12.10.202', N'Aida', 205, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/aida/8307//1', N'12.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (28, N'Black Adam', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">DC i Warner Bros. predstavljaju novog antiheroja čiju će glavnu ulogu preuzeti legendarni The Rock. Black Adam je Johnsonov veliki projekt koji svaki glumac doživi jednom u životu.<br />
Gotovo 5.000 godina nakon što je dobio sve moći egipatskih bogova te isto tako bio zatvoren, Black Adam oslobođen je iz svoje zemaljske grobnice, spreman osloboditi svoj jedinstveni oblik pravde u modernom svijetu.<br />
Black Adam donosi neke od najvećih filmskih borbi ove godine.</div>
<br />Početak prikazivanja: 20.10.202', N'Black Adam', 0, N'src\assets\5aeec123-e506-4afd-813e-3633e695c985.jpg', N'https://www.blitz-cinestar.hr/root/black-adam/8275//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (29, N'Black Adam 4DX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">DC i Warner Bros. predstavljaju novog antiheroja čiju će glavnu ulogu preuzeti legendarni The Rock. Black Adam je Johnsonov veliki projekt koji svaki glumac doživi jednom u životu.<br />
Gotovo 5.000 godina nakon što je dobio sve moći egipatskih bogova te isto tako bio zatvoren, Black Adam oslobođen je iz svoje zemaljske grobnice, spreman osloboditi svoj jedinstveni oblik pravde u modernom svijetu.<br />
Black Adam donosi neke od najvećih filmskih borbi ove godine.</div>
<br />Početak prikazivanja: 20.10.202', N'Black Adam 4DX', 0, N'src\assets\5aeec123-e506-4afd-813e-3633e695c985.jpg', N'https://www.blitz-cinestar.hr/root/black-adam-4dx/8276//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (30, N'Black Adam IMAX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">DC i Warner Bros. predstavljaju novog antiheroja čiju će glavnu ulogu preuzeti legendarni The Rock. Black Adam je Johnsonov veliki projekt koji svaki glumac doživi jednom u životu.<br />
Gotovo 5.000 godina nakon što je dobio sve moći egipatskih bogova te isto tako bio zatvoren, Black Adam oslobođen je iz svoje zemaljske grobnice, spreman osloboditi svoj jedinstveni oblik pravde u modernom svijetu.<br />
Black Adam donosi neke od najvećih filmskih borbi ove godine.</div>
<br />Početak prikazivanja: 20.10.202', N'Black Adam IMAX', 0, N'src\assets\5aeec123-e506-4afd-813e-3633e695c985.jpg', N'https://www.blitz-cinestar.hr/root/black-adam-imax/8277//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (31, N'Boemi', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Pariz, 1900. Siromašni pisac Rodolfo veruje da je umetnost sve što mu je potrebno za život - sve dok ne upozna Mimi, usamljenu krojačicu koja živi na spratu. Tako počinje bezvremenska ljubavna priča koja cveta, bledi i ponovno se razbuktava sa svakim novim godišnjim dobom. Ali dok se prijatelji para, Marcello i Musetta, strastveno svađaju i mire, Rodolfu i Mimi preti sila veća od ljubavi.<br />
Produkcija Richarda Jonesa evocira živopisne kontraste s kraja 20. veka, od boemskih stanova do svetlucavih arkada.</div>
<br />Početak prikazivanja: 20.10.202', N'La Boheme', 180, N'src\assets\9cfc838a-cca1-4314-89bb-819b1efc7b49.jpg', N'https://www.blitz-cinestar.hr/root/boemi/8308//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (32, N'Crni Adam', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">DC i Warner Bros. predstavljaju novog antiheroja čiju će glavnu ulogu preuzeti legendarni The Rock. Crni Adam je Džonsonov veliki projekt koji svaki glumac doživi jednom u životu.<br />
Gotovo 5.000 godina nakon što je dobio sve moći egipatskih bogova i isto tako bio zatvoren, Crni Adam oslobođen je iz svoje zemaljske grobnice, spreman da oslobodi  svoj jedinstveni oblik pravde u modernom svetu. Crni Adam donosi neke od najvećih filmskih borbi ove godine.</div>
<br />Početak prikazivanja: 20.10.202', N'Black Adam', 0, N'src\assets\5aeec123-e506-4afd-813e-3633e695c985.jpg', N'https://www.blitz-cinestar.hr/root/crni-adam/8287//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (33, N'Crni Adam 4DX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">DC i Warner Bros. predstavljaju novog antiheroja čiju će glavnu ulogu preuzeti legendarni The Rock. Crni Adam je Džonsonov veliki projekt koji svaki glumac doživi jednom u životu.<br />
Gotovo 5.000 godina nakon što je dobio sve moći egipatskih bogova i isto tako bio zatvoren, Crni Adam oslobođen je iz svoje zemaljske grobnice, spreman da oslobodi  svoj jedinstveni oblik pravde u modernom svetu. Crni Adam donosi neke od najvećih filmskih borbi ove godine.</div>
<br />Početak prikazivanja: 20.10.202', N'Black Adam 4DX', 0, N'src\assets\5aeec123-e506-4afd-813e-3633e695c985.jpg', N'https://www.blitz-cinestar.hr/root/crni-adam-4dx/8288//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (34, N'Đavolji plen', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Neki su rođeni za egzorcizam.<br />
Katolička crkva se bori protiv globalnog porasta opsednutosti demonima otvaranjem škole za obuku sveštenika koji će provoditi obrede egzorcizma. Na ovom duhovnom bojnom polju pojavljuje se neobičan ratnik: mlada časna sestra En. Iako je časnim sestrama zabranjeno da izvode egzorcizme, profesor prepoznaje njenu nadarenost i pristaje da je trenira. Uz podršku mentora, dopušteno joj je da posmatra i prisustvuje stvarnim praksama. Kada se susretne s jednim od najtežih slučajeva, splasnuće njena želja i volja za dokazivanjem. Tokom tih mučnih susreta, sestra En suočava se licem u lice s demonskom silom koja napada ustanovu u kojoj radi i ima tajanstvene veze s njenom prošlošću. Tada se moć zla i njene vlastite zapanjujuće sposobnosti u potpunosti razotkrivaju.</div>

<br />Početak prikazivanja: 20.10.202', N'Prey for the Devil', 0, N'src\assets\db7a4ed9-0ba4-46fc-a901-2363398d3ec5.jpg', N'https://www.blitz-cinestar.hr/root/djavolji-plen/8303//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (35, N'Đavolji plijen', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Neki su rođeni za egzorcizam.<br />
Katolička se crkva bori protiv globalnog porasta opsjednutosti demonima otvaranjem škole za obuku svećenika koji će provoditi obrede egzorcizma. Na ovom duhovnom bojnom polju pojavljuje se neobičan ratnik: mlada redovnica, sestra Ann. Iako je časnim sestrama zabranjeno izvoditi egzorcizme, profesor prepoznaje njezinu nadarenost i pristaje je trenirati. Uz podršku mentora, dopušteno joj je promatrati stvarne prakse. Kada se susretne s jednim od najtežih slučajeva, splasnut će njezina želja i volja za dokazivanjem. Tijekom tih mučnih susreta, sestra Ann suočava se licem u lice s demonskom silom koja napada ustanovu u kojoj radi i ima tajanstvene veze s njezinom prošlošću. Tada se moć zla i njezine vlastite zapanjujuće sposobnosti u potpunosti razotkrivaju.</div>

<br />Početak prikazivanja: 20.10.202', N'Prey for the Devil', 0, N'src\assets\db7a4ed9-0ba4-46fc-a901-2363398d3ec5.jpg', N'https://www.blitz-cinestar.hr/root/djavolji-plijen/8296//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (36, N'La Boheme', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Pariz, 1900. Siromašni pisac Rodolfo vjeruje da je umjetnost sve što mu je potrebno za život - sve dok ne upozna Mimi, usamljenu krojačicu koja živi na katu. Tako počinje bezvremenska ljubavna priča koja cvjeta, blijedi i ponovno se razbuktava sa svakim novim godišnjim dobom. Ali dok se prijatelji para, Marcello i Musetta, strastveno svađaju i mire, Rodolfu i Mimi prijeti sila veća od ljubavi.<br />
Produkcija Richarda Jonesa evocira živopisne kontraste s kraja 20, stoljeća, od boemskih stanova do svjetlucavih arkada.</div>
<br />Početak prikazivanja: 20.10.202', N'La Boheme', 180, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/la-boheme/8321//1', N'20.10.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (37, N'Black Panther: Wakanda Zauvijek', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Nastavak filma Black Panther iz 2018. godine koji je diljem svijeta zaradio preko $1.34 milijarde dolara. Film je oduševio kritičare i publiku, a na Rotten Tomatoes drži 96%. Uz to, film je osvojio i tri Oscara, za najbolju originalnu glazbu, najbolji dizajn kostima i najbolju scenografiju.<br />
U novom nastavku Marvel Studios neće promijeniti lik, već će istražiti svijet Wakande i likove predstavljene u prvom filmu.</div>
<br />Početak prikazivanja: 10.11.202', N'Black Panther: Wakanda Forever', 0, N'src\assets\0eeda89f-6e72-402c-9e82-47809a11ac6c.jpg', N'https://www.blitz-cinestar.hr/root/black-panther-wakanda-zauvijek/8278//1', N'10.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (38, N'Black Panther: Wakanda Zauvijek 3D', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Nastavak filma Black Panther iz 2018. godine koji je diljem svijeta zaradio preko $1.34 milijarde dolara. Film je oduševio kritičare i publiku, a na Rotten Tomatoes drži 96%. Uz to, film je osvojio i tri Oscara, za najbolju originalnu glazbu, najbolji dizajn kostima i najbolju scenografiju.<br />
U novom nastavku Marvel Studios neće promijeniti lik, već će istražiti svijet Wakande i likove predstavljene u prvom filmu.</div>
<br />Početak prikazivanja: 10.11.202', N'Black Panther: Wakanda Forever 3D', 0, N'src\assets\0eeda89f-6e72-402c-9e82-47809a11ac6c.jpg', N'https://www.blitz-cinestar.hr/root/black-panther-wakanda-zauvijek-3d/8279//1', N'10.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (39, N'Black Panther: Wakanda Zauvijek 3D 4DX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Nastavak filma Black Panther iz 2018. godine koji je diljem svijeta zaradio preko $1.34 milijarde dolara. Film je oduševio kritičare i publiku, a na Rotten Tomatoes drži 96%. Uz to, film je osvojio i tri Oscara, za najbolju originalnu glazbu, najbolji dizajn kostima i najbolju scenografiju.<br />
U novom nastavku Marvel Studios neće promijeniti lik, već će istražiti svijet Wakande i likove predstavljene u prvom filmu.</div>
<br />Početak prikazivanja: 10.11.202', N'Black Panther: Wakanda Forever 3D 4DX', 0, N'src\assets\0eeda89f-6e72-402c-9e82-47809a11ac6c.jpg', N'https://www.blitz-cinestar.hr/root/black-panther-wakanda-zauvijek-3d-4dx/8280//1', N'10.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (40, N'Black Panther: Wakanda Zauvijek 3D IMAX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Nastavak filma Black Panther iz 2018. godine koji je diljem svijeta zaradio preko $1.34 milijarde dolara. Film je oduševio kritičare i publiku, a na Rotten Tomatoes drži 96%. Uz to, film je osvojio i tri Oscara, za najbolju originalnu glazbu, najbolji dizajn kostima i najbolju scenografiju.<br />
U novom nastavku Marvel Studios neće promijeniti lik, već će istražiti svijet Wakande i likove predstavljene u prvom filmu.</div>
<br />Početak prikazivanja: 10.11.202', N'Black Panther: Wakanda Forever 3D IMAX', 0, N'src\assets\0eeda89f-6e72-402c-9e82-47809a11ac6c.jpg', N'https://www.blitz-cinestar.hr/root/black-panther-wakanda-zauvijek-3d-imax/8281//1', N'10.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (41, N'Dijamantni pir', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Osebujni voditelji Royal baleta vode večer koju ne smijete propustiti, a njihovi nevjerojatni talenti savršeno odgovaraju dijamantnom piru. Slaveći šezdesetu godišnjicu Prijatelja Covent Gardena, ovaj program je svojevrsna zahvala svim sponzorima Royal Opera Housea, na nevjerojatno podršci svih godina kao i ubuduće.<br />
Nastup će predstaviti širinu i raznolikost repertoara Royal baleta u klasičnim, suvremenim i baštinskim djelima. Također će uključivati ??svjetske premijere kratkih baleta koreografa Pam Tanowitz, Josepha Toonge i Valentina Zucchettija, kao i prvu izvedbu <em>Za četvero </em> umjetničkog suradnika Royal baleta, Christophera Wheeldona te izvedbu “Dijamanti” Georgea Balanchinea.</div>
<br />Početak prikazivanja: 16.11.202', N'The Royal Ballet: A Diamond Celebration', 0, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/dijamantni-pir/8322//1', N'16.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (42, N'Dijamantska proslava', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Fantastični direktori Royal baleta vode veče koje ne smete propustiti, a njihovi neverovatni talenti savršeno odgovaraju dijamantskoj godišnjici. Slaveći šezdesetu godišnjicu Prijatelja Covent Gardena, ovaj program je svojevrsna zahvalnica svim sponzorima Royal Opera House-a, na neverovatnoj podršci tokom godina, kao i ubuduće.<br />
Nastup će predstaviti širinu i raznolikost repertoara Royal baleta u klasičnim, savremenim i delima u nasleđe. Takođe će uključivati ??svetske premijere kratkih baleta koreografa Pam Tanowitz, Josepha Toonge i Valentina Zucchettija, kao i prvu izvedbu <em>Za četvero </em> umetničkog saradnika Royal baleta, Christophera Wheeldona , kao i izvedbu “Dijamanti” Georgea Balanchinea.</div>
<br />Početak prikazivanja: 16.11.202', N'The Royal Ballet: A Diamond Celebration', 0, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/dijamantska-proslava/8309//1', N'16.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (43, N'Meni', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Mladi par putuje na udaljeno ostrvo kako bi jeli u ekskluzivnom restoranu u kojem šef kuhinje priprema izvrsna jela, uz šokantna iznenađenja.</div>
<br />Početak prikazivanja: 17.11.202', N'The Menu', 0, N'src\assets\8fea377a-9554-4534-9d70-b451a5b2ea6c.jpg', N'https://www.blitz-cinestar.hr/root/meni/8344//1', N'17.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (44, N'Šesti autobus', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Mlada Amerikanka pokušava pronaći čovjeka iz svoje prošlosti, koji nikad neće biti pronađen, i to tijekom najvećeg sukoba na europskom tlu od Drugog svjetskog rata – bitke za Vukovar. Riječ je o potrazi za identitetom i istinom na mjestu gdje je istina selektivna, neuhvatljiva i čak se boji. Ispod te potrage ključa potreba za vjerom, vezom i otkupljenjem.</div>
<br />Početak prikazivanja: 17.11.202', N'Šesti autobus', 0, N'src\assets\943bcdc4-aba3-417c-824c-9df11f894c1c.jpg', N'https://www.blitz-cinestar.hr/root/sesti-autobus/8297//1', N'17.11.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (45, N'Krcko Oraščić', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Pridružite se Klari na očaravajućoj Božićnoj žurci koja postaje čarobna pustolovina nakon što svi ostali zaspu. Neka vas ponese briljantna muzika Čajkovskog, dok se Klara i njen začarani Krcko Oraščić bore protiv kralja miševa i posećuju vilu šećerne šljive i njenog princa u blještavom kraljevstvu slatkiša. Omiljena produkcija Petera Wrighta za Royal balet, s predivnom scenografijom Julije Trevelyan Oman, ostaje verna duhu ovog svečanog baletnog klasika, kombinujući čaroliju bajke sa spektakularnim klasičnim plesom.</div>
<br />Početak prikazivanja: 8.12.202', N'The Nutcracker', 165, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/krcko-orascic/8310//1', N'8.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (46, N'Orašar', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Pridružite se Clari na Badnjak, kad prekrasna zabavcaa postaje čarobna pustolovina nakon što svi ostali zaspu. Neka vas ponese briljantna glazba Čajkovskog, dok se Clara i njezin začarani Orašar bore protiv kralja miševa i posjećuju vilu šećerne šljive i njezinog princa u blještavom kraljevstvu slatkiša. Omiljena produkcija Petera Wrighta za Royal balet, s prekrasnom scenografijom Julije Trevelyan Oman, ostaje vjerna duhu ovog svečanog baletnog klasika, kombinirajući čaroliju bajke sa spektakularnim klasičnim plesom.</div>
<br />Početak prikazivanja: 8.12.202', N'The Nutcracker', 165, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/orasar/8323//1', N'8.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (47, N'Avatar: Put vode', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Radnja filma „Avatar: Put vode“ odvija se više od jednog desetljeća nakon događaja iz prvog dijela.<br />
Otkad je odlučio trajno prenijeti ljudsku svijest u svoje tijelo Avatara i postati novi vođa naroda Na’vi, Jake Sully živi sa svojom obitelji na Pandori. On i Neytiri su osnovali obitelj i dobili djecu. Kolonizirajuće su se snage vratile na Pandoru kako bi završili prvotnu potragu za rijetkim mineralom, prisiljavajući Jakea i Neytiri da pobjegnu iz svog doma, istražujući do tada nepoznate dijelove Pandore gdje će se upoznati s ljudima Metkayine, klanom domorodaca koji žive okruženi morem.<br />
 </div>
<br />Početak prikazivanja: 15.12.202', N'Avatar: The Way of Water', 0, N'src\assets\1d996513-19e6-40c5-bdfe-777fd214ba65.jpg', N'https://www.blitz-cinestar.hr/root/avatar-put-vode/8207//1', N'15.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (48, N'Avatar: Put vode 3D', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Džejk Sali živi sa svojom porodicom na planeti Pandori. Kada se vrati poznati neprijatelj koji pokušava da ih uništi, Džejk i Nejtiri se udružuju sa vojskom Navi naroda kako bi zaštitili svoju planetu.</div>

<br />Početak prikazivanja: 15.12.202', N'Avatar: The Way of Water 3D', 0, N'src\assets\1d996513-19e6-40c5-bdfe-777fd214ba65.jpg', N'https://www.blitz-cinestar.hr/root/avatar-put-vode-3d/8214//1', N'15.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (49, N'Avatar: Put vode 3D 4DX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Radnja filma „Avatar: Put vode“ odvija se više od jednog desetljeća nakon događaja iz prvog dijela.<br />
Otkad je odlučio trajno prenijeti ljudsku svijest u svoje tijelo Avatara i postati novi vođa naroda Na’vi, Jake Sully živi sa svojom obitelji na Pandori. On i Neytiri su osnovali obitelj i dobili djecu. Kolonizirajuće su se snage vratile na Pandoru kako bi završili prvotnu potragu za rijetkim mineralom, prisiljavajući Jakea i Neytiri da pobjegnu iz svog doma, istražujući do tada nepoznate dijelove Pandore gdje će se upoznati s ljudima Metkayine, klanom domorodaca koji žive okruženi morem.<br />
 </div>
<br />Početak prikazivanja: 15.12.202', N'Avatar: The Way of Water 3D 4DX', 0, N'src\assets\1d996513-19e6-40c5-bdfe-777fd214ba65.jpg', N'https://www.blitz-cinestar.hr/root/avatar-put-vode-3d-4dx/8209//1', N'15.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (50, N'Avatar: Put vode 3D IMAX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Radnja filma „Avatar: Put vode“ odvija se više od jednog desetljeća nakon događaja iz prvog dijela.<br />
Otkad je odlučio trajno prenijeti ljudsku svijest u svoje tijelo Avatara i postati novi vođa naroda Na’vi, Jake Sully živi sa svojom obitelji na Pandori. On i Neytiri su osnovali obitelj i dobili djecu. Kolonizirajuće su se snage vratile na Pandoru kako bi završili prvotnu potragu za rijetkim mineralom, prisiljavajući Jakea i Neytiri da pobjegnu iz svog doma, istražujući do tada nepoznate dijelove Pandore gdje će se upoznati s ljudima Metkayine, klanom domorodaca koji žive okruženi morem.<br />
 </div>
<br />Početak prikazivanja: 15.12.202', N'Avatar: The Way of Water 3D IMAX', 0, N'src\assets\1d996513-19e6-40c5-bdfe-777fd214ba65.jpg', N'https://www.blitz-cinestar.hr/root/avatar-put-vode-3d-imax/8210//1', N'15.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (51, N'Shazam! Bijes Bogova', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Ulogu naslovnog heroja u Shazamu 2 će ponovno imati Zachary Levi, a očekuje se da će mu se pridružiti i Asher Angel i Jack Dylan Grazer. David F. Sandberg vratit će se režiji nastavka nakon što je prvi film zaradio $365 milijuna širom svijeta. Henry Gayden se vraća kao scenarist.</div>
<br />Početak prikazivanja: 22.12.202', N'Shazam! Fury of the Gods', 0, N'src\assets\4e2a05e0-67cf-46b4-a0c6-163c7a81af29.jpg', N'https://www.blitz-cinestar.hr/root/shazam-bijes-bogova/8282//1', N'22.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (52, N'Shazam! Bijes Bogova 3D IMAX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Ulogu naslovnog heroja u Shazamu 2 će ponovno imati Zachary Levi, a očekuje se da će mu se pridružiti i Asher Angel i Jack Dylan Grazer. David F. Sandberg vratit će se režiji nastavka nakon što je prvi film zaradio $365 milijuna širom svijeta. Henry Gayden se vraća kao scenarist.</div>
<br />Početak prikazivanja: 22.12.202', N'Shazam! Fury of the Gods 3D IMAX', 0, N'src\assets\4e2a05e0-67cf-46b4-a0c6-163c7a81af29.jpg', N'https://www.blitz-cinestar.hr/root/shazam-bijes-bogova-3d-imax/8285//1', N'22.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (53, N'Šazam! Gnev Bogova', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Ulogu naslovnog heroja u Šazamu 2 će ponovno imati Zakari Levi, a očekuje se da će mu se pridružiti i Ašer Ejndžl i Džek Dila Grejzer. David F. Sandberg vratiće se režiji nastavka nakon što je prvi film zaradio $365 miliona širom sveta. Henri Gajden se vraća kao scenarista.</div>
<br />Početak prikazivanja: 22.12.202', N'Shazam! Fury of the Gods', 0, N'src\assets\4e2a05e0-67cf-46b4-a0c6-163c7a81af29.jpg', N'https://www.blitz-cinestar.hr/root/sazam-gnev-bogova/8334//1', N'22.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (54, N'Šazam! Gnev Bogova 4DX', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Ulogu naslovnog heroja u Šazamu 2 će ponovno imati Zakari Levi, a očekuje se da će mu se pridružiti i Ašer Ejndžl i Džek Dila Grejzer. David F. Sandberg vratiće se režiji nastavka nakon što je prvi film zaradio $365 miliona širom sveta. Henri Gajden se vraća kao scenarista.</div>
<br />Početak prikazivanja: 22.12.202', N'Shazam! Fury of the Gods 4DX', 0, N'src\assets\4e2a05e0-67cf-46b4-a0c6-163c7a81af29.jpg', N'https://www.blitz-cinestar.hr/root/sazam-gnev-bogova-4dx/8335//1', N'22.12.2022')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (55, N'Kao voda za čokoladu', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Moderni meksički klasik čarobnog realizma temelj je nove baletske predstave Royal baleta. Ponovo je ujedinio umetničkog saradnika Christophera Wheeldona sa kreativnim timom koji je do sada uspešno pretvorio <em>Alisu u zemlji čuda</em> i <em>Zimsku bajku</em> – u ples, a to su kompozitor Joby Talbor i scenograf Bob Crowley.<br />
Balet je inspirisan romanom Laure Esquivel – zadivljujućom porodičnom sagom u kojoj središnji lik svoje emocije  dočarava kroz kuvanje i na taj, zapanjujuć i dramatičan način, utiče na sve oko sebe.<br />
U ovoj koprodukciji sa Američkim baletnim pozorištem, meksički dirigent Alondra de la Parra takođe sarađuje kao muzički savetnik za Talbotovu novu partituru, a Wheeldon je blisko sarađivao s Esquivel kako bi njenu bogatu slojevitu priču pretvorio u zabavni i zadivljujući novi balet.</div>
<br />Početak prikazivanja: 19.1.202', N'Like Water For Chocolate', 190, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/kao-voda-za-cokoladu/8311//1', N'19.1.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (56, N'Seviljski Berberin', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Kad se Rosina zaljubi u tajanstvenog mladog udvarača koji sebe naziva Lindoro, mora upotrebiti svu svoju lukavost – i malu pomoć svog lokalnog berbera – kako bi nadmudrila svog proračunatog staratelja dr. Bartola.<br />
Očekujte dirljive serenade, smešne maske i završetak kao iz bajke koji vas čeka nadomak ruke.<br />
Od berberove slavne uvodne pesme Largo al factotum, sa povikom Figaro! Figaro!, do Rosinine živahne arije Una voce poco fa, komična opera Gioachina Rossinija je vanserijski zabavna! Rafael Payare debitovao je ovom operom u Royal Opera House uz izvanrednu međunarodnu postavu koja uključuje Andrzeja Filończyka, Aigul Akhmetshinu, Lawrencea Brownleeja i Bryn Terfel.</div>
<br />Početak prikazivanja: 15.2.202', N'The Barber of Seville', 225, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/seviljski-berberin/8312//1', N'15.2.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (57, N'Seviljski brijač', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Kad se Rosina zaljubi u tajanstvenog mladog udvarača koji sebe naziva Lindoro, mora upotrijebiti svu svoju lukavost – i malu pomoć svog lokalnog brijača – kako bi nadmudrila svog proračunatog skrbnika dr. Bartola.<br />
Očekujte dirljive serenade, smiješne maske i završetak kao iz bajke koji vas čeka nadomak ruke.<br />
Od brijačeve slavne uvodne pjesme Largo al factotum, s povikom Figaro! Figaro!, do Rosinine živahne arije Una voce poco fa, komična opera Gioachina Rossinija je vanserijski zabavna! Rafael Payare debitirao je ovom operom u Royal Opera House uz izvanrednu međunarodnu postavu koja uključuje Andrzeja Filończyka, Aigul Akhmetshinu, Lawrencea Brownleeja i Bryn Terfel.</div>
<br />Početak prikazivanja: 15.2.202', N'The Barber of Seville', 225, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/seviljski-brijac/8325//1', N'15.2.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (58, N'Turandot', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Na dvoru princeze Turandot, prosioce koji ne uspeju rešiti njene zagonetke, brutalno ubijaju.<br />
Ali kada misteriozni princ odgovori tačno, odjednom postaje moćan - i čuva slavnu tajnu.<br />
 <br />
Kad život visi o koncu, može li ljubav sve pobediti?<br />
 <br />
Puccinijeva partitura bogata je muzičkim čudesima (sadrži poznatu ariju Nessun dorma), dok se produkcija Andreja Serbana oslanja na kinesku pozorišnu tradiciju kako bi dočarala živopisnu šarenoliku sliku drevnog Pekinga. Antonio Pappano umetnički vodi Annu Pirozzi u naslovnoj ulozi te Yonghoona Leeja u ulozi Calafe.</div>
<br />Početak prikazivanja: 22.3.202', N'Turandot', 200, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/turandot/8313//1', N'22.3.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (59, N'Pepeljuga', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Pepeljuga koreografa utemeljivača Royal baleta, Fredericka Ashtona, ove sezone slavi 75. godišnjicu. Premijera baleta davne 1948., sa Moirom Shearer i Michaelom Somesom u glavnim ulogama, dočekana je s ovacijama. Nakon više od decenije odsutnosti s pozornice Royal Opera House-a, vraća se Ashtonova bezvremenska obrada slavne priče od-ničega-do-bogatstva Charlesa Perraulta, pokazujući koreografovu smelu muzikalnost i lepotu Prokofjevljeve transcendentne partiture. Iskorak kreativnog tima u čari pozorišta, filma, plesa i opere donosi novu atmosferu u Pepeljugin eterični svet kuma vila i kočija od bundeva, zgodnim prinčevima i pronalaskom prave ljubavi.</div>
<br />Početak prikazivanja: 12.4.202', N'Cinderella', 180, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/pepeljuga/8314//1', N'12.4.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (60, N'Figarov pir', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Sluge Figaro i Susanna uzbuđeni su na dan svog vjenčanja, ali postoji začkoljica: njihov poslodavac, grof Almaviva, ima nečasne namjere prema budućoj nevjesti.<br />
S velikim brojem neočekivanih obrata, priča o Mozartovoj komičnoj operi iznenadit će vas i oduševiti u svakom trenutku. Dođite zbog glazbe i ostanite zbog smijeha, a sve se odvija tijekom jednog ludog, naopakog dana u kućanstvu Almaviva. Glazbeni ravnatelj Royal Opera Housea Antonio Pappano dirigira međunarodnom glumačkom ekipom u bezvremenskoj produkciji Davida McVicara.</div>
<br />Početak prikazivanja: 27.4.202', N'The Marriage of Figaro', 0, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/figarov-pir/8328//1', N'27.4.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (61, N'Figarova ženidba', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Sluge Figaro i Susanna uzbuđeni su na dan svog venčanja, ali postoji začkoljica: njihov poslodavac, grof Almaviva, ima nečasne namere prema budućoj nevesti.<br />
Uz više neočekivanih obrta, priča o Mozartovoj komičnoj operi iznenadiće vas i oduševiti u svakom trenu. Dođite zbog muzike i ostanite zbog smeha, a sve se odvija tokom jednog haotičnog, naopakog dana u domaćinstvu Almaviv-ovih. Muzički direktor Royal Opera Housea Antonio Pappano diriguje međunarodnom glumačkom ekipom u bezvremenskoj produkciji Davida McVicara.</div>
<br />Početak prikazivanja: 27.4.202', N'The Marriage of Figaro', 0, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/figarova-zenidba/8315//1', N'27.4.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (62, N'Trnoružica', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Uspavana ljepotica ima vrlo posebno mjesto u srcu i povijesti Royal baleta.<br />
Bila je to prva izvedba ansambla u  ovoj opernoj kući 1946. godine, nakon završetka Drugog svjetskog rata. Godine 2006. ponovno su oživjeli  ovaj balet i od tada uvijek iznova oduševljava publiku. Frederick Ashton izvrsno je prenio čisti klasicizam baleta Mariusa Petipe iz 19. stoljeća pretvorivši je u privatnu lekciju nama, o atmosferičnoj umjetnosti i zanatu koreografije. Neka vas oduševi zanosna glazba Čajkovskog i raskošna bajkovita scenografija Olivera Messela uz ovaj istinski dragulj klasičnog baleta.</div>
<br />Početak prikazivanja: 24.5.202', N'The Sleeping Beauty', 205, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/trnoruzica/8329//1', N'24.5.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (63, N'Uspavana lepotica', N'2022-08-29T17:38:21', N'<div style="text-align: justify;"><em>Uspavana lepotica</em> ima veoma posebno mesto u srcu i istoriji Royal baleta.<br />
Bila je to prva izvedba ansambla u ovoj opernoj kući 1946. godine, nakon završetka Drugog svetskog rata. Godine 2006. ponovo su oživeli ovaj balet i od tada uvek iznova oduševljava publiku. Frederick Ashton izvrsno je preneo čist klasicizam baleta Mariusa Petipe iz 19. veka pretvorivši je u privatnu lekciju nama, o atmosferičnoj umetnosti i majstorstvu koreografije. Neka vas oduševi zanosna muzika Čajkovskog i raskošna bajkovita scenografija Olivera Messela uz ovaj istinski dragulj klasičnog baleta.</div>
<br />Početak prikazivanja: 24.5.202', N'The Sleeping Beauty', 205, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/uspavana-lepotica/8316//1', N'24.5.2023')
GO
INSERT [dbo].[Movie] ([IDMovie], [Title], [PublishedDate], [Description], [OriginalTitle], [Duration], [PicturePath], [Link], [OpeningDate]) VALUES (64, N'Trubadur', N'2022-08-29T17:38:21', N'<div style="text-align: justify;">Strasti su uzburkane dok se Manrico i grof di Luna takmiče za Leonorinu naklonost. Manricova majka Azucena decenijama je čuvala strašnu tajnu. Uskoro će se prokletstvo iz prošlosti dići iz pepela sa razornim posledicama za sve njih.<br />
S Ludovicom Tézierom i Jamiejem Bartonom u glavnim ulogama, energična inscenacija rediteljke Adele Thomas, postavlja Verdijevu priču u univerzum srednjovekovnog sujeverja nadahnut likovnim delima Hieronymusa Boscha. Antonio Pappano diriguje Verdijevom dramatičnom partiturom, koja sadrži i poznatu izvedbu hora Cigana.</div>
<br />Početak prikazivanja: 13.6.202', N'Il Trovatore', 205, N'src\assets\0cedb4c3-556e-4a29-b4cb-1f198754575f.jpg', N'https://www.blitz-cinestar.hr/root/trubadur/8317//1', N'13.6.2023')
GO
SET IDENTITY_INSERT [dbo].[Movie] OFF
GO
SET IDENTITY_INSERT [dbo].[Genre] ON 
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (1, N'komedija')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (2, N'drama')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (3, N'fantazija')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (4, N'romantični')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (5, N'animirani')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (6, N'akcija')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (7, N'triler')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (8, N'horor')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (9, N'sportski')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (10, N'biografska drama')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (11, N'avantura')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (12, N'SF')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (13, N'opera')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (14, N'glazbeni')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (15, N'dokumentarni')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (16, N'balet')
GO
INSERT [dbo].[Genre] ([IDGenre], [Name]) VALUES (17, N'istorijski')
GO
SET IDENTITY_INSERT [dbo].[Genre] OFF
GO
SET IDENTITY_INSERT [dbo].[MovieGenre] ON 
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (1, 1, 1)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (2, 2, 1)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (3, 3, 2)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (4, 3, 3)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (5, 3, 4)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (6, 4, 2)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (7, 4, 3)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (8, 4, 4)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (9, 5, 5)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (10, 6, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (11, 6, 7)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (12, 6, 8)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (13, 7, 2)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (14, 7, 9)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (15, 8, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (16, 9, 10)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (17, 10, 2)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (18, 11, 7)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (19, 12, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (20, 12, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (21, 12, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (22, 13, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (23, 13, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (24, 13, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (25, 14, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (26, 14, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (27, 14, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (28, 15, 7)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (29, 16, 5)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (30, 17, 5)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (31, 18, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (32, 19, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (33, 20, 1)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (34, 20, 2)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (35, 21, 14)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (36, 21, 15)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (37, 22, 8)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (38, 23, 8)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (39, 24, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (40, 25, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (41, 26, 2)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (42, 26, 17)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (43, 27, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (44, 28, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (45, 28, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (46, 29, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (47, 29, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (48, 30, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (49, 30, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (50, 31, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (51, 32, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (52, 32, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (53, 32, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (54, 33, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (55, 33, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (56, 33, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (57, 34, 8)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (58, 35, 8)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (59, 36, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (60, 37, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (61, 37, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (62, 38, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (63, 38, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (64, 39, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (65, 39, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (66, 40, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (67, 40, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (68, 41, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (69, 42, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (70, 43, 1)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (71, 43, 8)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (72, 44, 2)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (73, 45, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (74, 46, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (75, 47, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (76, 47, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (77, 47, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (78, 48, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (79, 48, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (80, 48, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (81, 49, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (82, 49, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (83, 49, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (84, 50, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (85, 50, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (86, 50, 12)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (87, 51, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (88, 51, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (89, 52, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (90, 52, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (91, 53, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (92, 53, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (93, 54, 6)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (94, 54, 11)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (95, 55, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (96, 56, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (97, 57, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (98, 58, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (99, 59, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (100, 60, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (101, 61, 13)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (102, 62, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (103, 63, 16)
GO
INSERT [dbo].[MovieGenre] ([IDMovieGenre], [MovieID], [GenreID]) VALUES (104, 64, 13)
GO
SET IDENTITY_INSERT [dbo].[MovieGenre] OFF
GO
SET IDENTITY_INSERT [dbo].[PersonType] ON 
GO
INSERT [dbo].[PersonType] ([IDPersonType], [Name]) VALUES (1, N'Director')
GO
INSERT [dbo].[PersonType] ([IDPersonType], [Name]) VALUES (2, N'Actor')
GO
SET IDENTITY_INSERT [dbo].[PersonType] OFF
GO
SET IDENTITY_INSERT [dbo].[Person] ON 
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (1, N'Franck', N'Dubosc', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (2, N'', N'Jean-Pierre Darroussin', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (3, N'', N'Launa Espinosa', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (4, N'Franck', N'Dubosc', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (5, N'Alexandra', N'Lamy', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (6, N'', N'Philippe Katerine', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (7, N'', N'Matteo Perez', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (8, N'Emmanuel', N'Poulain-Arnaud', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (9, N'Tilda', N'Swinton', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (10, N'', N'Idris Elba', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (11, N'George', N'Miller', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (12, N'Zrinka', N'Cvitešić', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (13, N'', N'Živko Anočić', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (14, N'', N'Saša Buneta', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (15, N'', N'Lana Blaće', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (16, N'', N'Toma Medvešek', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (17, N'', N'Tin Rožman', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (18, N'Theodore', N'Ty', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (19, N'', N'Laurent Zeitoun', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (20, N'Shane', N'West', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (21, N'', N'Nicky Whelan', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (22, N'', N'Jeff Fahey', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (23, N'Justin', N'Lee', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (24, N'Granit', N'Rushiti', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (25, N'', N'Čedomir Glisović', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (26, N'', N'Merima Dizdarević', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (27, N'Jens', N'Sjögren', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (28, N'Sabrina', N'Ouazani', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (29, N'', N'Ramzy Bedia', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (30, N'', N'Eye Haidara', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (31, N'Mabrouk', N'El Mechri', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (32, N'Milena', N'Predić', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (33, N'', N'Milica Stefanović', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (34, N'', N'Filip Hajduković', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (35, N'', N'Jadranka Selec', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (36, N'', N'Daniel Sič', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (37, N'', N'Branislav Tomašević', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (38, N'', N'Andrej Šepetkovski', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (39, N'', N'Mladen Sovilj', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (40, N'Hadži-Aleksandar', N'Đurović', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (41, N'Tang', N'Wei', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (42, N'', N'Go Kyung-Pyo', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (43, N'', N'Park Hae-il', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (44, N'Park', N'Chan-wook', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (45, N'Grace', N'Caroline Currey', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (46, N'', N'Virginia Gardner', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (47, N'', N'Jeffrey Dean Morgan', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (48, N'Scott', N'Mann', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (49, N'Sam', N'Worthington', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (50, N'', N'Zoe Saldana', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (51, N'', N'Sigourney Weaver', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (52, N'James', N'Cameron', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (53, N'Florence', N'Pugh', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (54, N'', N'Harry Styles', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (55, N'', N'Olivia Wilde', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (56, N'', N'Gemma Chan', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (57, N'', N'	Chris Pine', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (58, N'Olivia', N'Wilde', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (59, N'Samuel', N'Tourneux', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (60, N'Sigourney', N'Weaver', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (61, N'', N'Kevin Kline', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (62, N'', N'Morena Baccarin', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (63, N'Maya', N'Forbes', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (64, N'', N'Wallace Wolodarsky', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (65, N'David', N'Bowie', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (66, N'Brett', N'Morgen', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (67, N'Sosie', N'Bacon', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (68, N'', N'Jessie T. Usher', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (69, N'', N'Kyle Gallner', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (70, N'', N'Robin Weigert', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (71, N'', N'Caitlin Stasey', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (72, N'', N'Kal Penn', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (73, N'', N'Rob Morgan', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (74, N'Parker', N'Finn', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (75, N'Koen', N'Kessels', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (76, N'Margot', N'Robbie', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (77, N'', N'Anya Taylor-Joy', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (78, N'', N'Christian Bale', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (79, N'David', N'O. Russell', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (80, N'Robert', N'Carsen', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (81, N'Dwayne', N'Johnson', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (82, N'', N'Sarah Shahi', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (83, N'', N'Noah Centineo', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (84, N'', N'Pierce Brosnan', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (85, N'', N'Aldis Hodge', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (86, N'Jaume', N'Collet-Serra', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (87, N'Richard', N'Jones', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (88, N'Virginia', N'Madsen', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (89, N'', N'Jacqueline Byers', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (90, N'', N'Colin Salmon', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (91, N'', N'Ben Cross', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (92, N'Daniel', N'Stamm', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (93, N'Martin', N'Freeman', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (94, N'', N'Letitia Wright', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (95, N'', N'Angela Bassett', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (96, N'Ryan', N'Coogler', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (97, N'Christopher', N'Wheeldon', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (98, N'Anya', N'Taylor – Joy', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (99, N'', N'Nicholas Hoult', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (100, N'', N'Janet McTeer', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (101, N'', N'Ralph Fiennes', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (102, N'Mark', N'Mylod', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (103, N'Zala', N'Đurić', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (104, N'', N'Marko Petrić', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (105, N'', N'Toni Gojanović', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (106, N'', N'Muhamed Hadžović', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (107, N'', N'Filip Mayer', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (108, N'Eduard', N'Galić', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (109, N'Peter', N'Wright', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (110, N'', N'Giovanni Ribisi', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (111, N'', N'Stephen Lang', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (112, N'', N'Vin Diesel', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (113, N'', N'Michelle Yeoh', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (114, N'', N'Kate Winslet', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (115, N'Zachary', N'Levi', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (116, N'Helen', N'Mirren', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (117, N'', N'Lucy Liu', 2)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (118, N'David', N'F. Sandberg', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (119, N'Alondra', N'de la Parra', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (120, N'Moshe', N'Leiser i Patrice Caurier', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (121, N'Andrei', N'Serban', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (122, N'Frederick', N'Ashton', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (123, N'David', N'McVicar', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (124, N'Marius', N'Petipa', 1)
GO
INSERT [dbo].[Person] ([IDPerson], [FirstName], [LastName], [PersonTypeID]) VALUES (125, N'Adele', N'Thomas', 1)
GO
SET IDENTITY_INSERT [dbo].[Person] OFF
GO
SET IDENTITY_INSERT [dbo].[MoviePerson] ON 
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (1, 1, 1)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (2, 1, 2)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (3, 1, 3)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (4, 1, 4)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (5, 2, 5)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (6, 2, 6)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (7, 2, 7)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (8, 2, 8)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (9, 3, 9)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (10, 3, 10)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (11, 3, 11)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (12, 4, 9)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (13, 4, 10)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (14, 4, 11)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (15, 5, 12)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (16, 5, 13)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (17, 5, 14)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (18, 5, 15)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (19, 5, 16)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (20, 5, 17)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (21, 5, 18)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (22, 5, 19)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (23, 6, 20)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (24, 6, 21)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (25, 6, 22)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (26, 6, 23)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (27, 7, 24)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (28, 7, 25)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (29, 7, 26)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (30, 7, 27)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (31, 8, 28)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (32, 8, 29)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (33, 8, 30)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (34, 8, 31)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (35, 9, 32)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (36, 9, 33)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (37, 9, 34)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (38, 9, 35)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (39, 9, 36)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (40, 9, 37)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (41, 9, 38)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (42, 9, 39)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (43, 9, 40)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (44, 10, 41)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (45, 10, 42)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (46, 10, 43)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (47, 10, 44)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (48, 11, 45)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (49, 11, 46)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (50, 11, 47)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (51, 11, 48)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (52, 12, 49)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (53, 12, 50)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (54, 12, 51)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (55, 12, 52)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (56, 13, 49)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (57, 13, 50)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (58, 13, 51)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (59, 13, 52)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (60, 14, 49)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (61, 14, 50)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (62, 14, 51)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (63, 14, 52)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (64, 15, 53)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (65, 15, 54)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (66, 15, 55)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (67, 15, 56)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (68, 15, 57)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (69, 15, 58)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (70, 16, 59)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (71, 17, 59)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (72, 20, 60)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (73, 20, 61)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (74, 20, 62)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (75, 20, 63)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (76, 20, 64)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (77, 21, 65)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (78, 21, 66)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (79, 22, 67)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (80, 22, 68)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (81, 22, 69)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (82, 22, 70)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (83, 22, 71)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (84, 22, 72)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (85, 22, 73)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (86, 22, 74)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (87, 23, 67)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (88, 23, 68)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (89, 23, 69)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (90, 23, 70)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (91, 23, 71)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (92, 23, 72)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (93, 23, 73)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (94, 23, 74)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (95, 24, 75)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (96, 25, 75)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (97, 26, 76)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (98, 26, 77)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (99, 26, 78)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (100, 26, 79)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (101, 27, 80)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (102, 28, 81)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (103, 28, 82)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (104, 28, 83)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (105, 28, 84)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (106, 28, 85)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (107, 28, 86)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (108, 29, 81)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (109, 29, 82)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (110, 29, 83)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (111, 29, 84)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (112, 29, 85)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (113, 29, 86)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (114, 30, 81)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (115, 30, 82)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (116, 30, 83)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (117, 30, 84)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (118, 30, 85)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (119, 30, 86)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (120, 31, 87)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (121, 32, 81)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (122, 32, 82)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (123, 32, 83)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (124, 32, 84)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (125, 32, 85)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (126, 32, 86)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (127, 33, 81)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (128, 33, 82)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (129, 33, 83)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (130, 33, 84)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (131, 33, 85)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (132, 33, 86)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (133, 34, 88)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (134, 34, 89)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (135, 34, 90)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (136, 34, 91)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (137, 34, 92)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (138, 35, 88)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (139, 35, 89)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (140, 35, 90)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (141, 35, 91)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (142, 35, 92)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (143, 36, 87)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (144, 37, 93)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (145, 37, 94)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (146, 37, 95)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (147, 37, 96)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (148, 38, 93)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (149, 38, 94)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (150, 38, 95)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (151, 38, 96)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (152, 39, 93)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (153, 39, 94)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (154, 39, 95)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (155, 39, 96)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (156, 40, 93)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (157, 40, 94)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (158, 40, 95)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (159, 40, 96)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (160, 41, 97)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (161, 42, 97)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (162, 43, 98)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (163, 43, 99)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (164, 43, 100)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (165, 43, 101)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (166, 43, 102)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (167, 44, 103)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (168, 44, 104)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (169, 44, 105)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (170, 44, 106)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (171, 44, 107)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (172, 44, 108)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (173, 45, 109)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (174, 46, 109)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (175, 47, 49)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (176, 47, 50)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (177, 47, 110)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (178, 47, 111)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (179, 47, 112)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (180, 47, 113)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (181, 47, 114)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (182, 47, 51)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (183, 47, 52)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (184, 48, 49)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (185, 48, 50)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (186, 48, 110)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (187, 48, 111)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (188, 48, 112)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (189, 48, 113)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (190, 48, 114)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (191, 48, 52)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (192, 49, 49)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (193, 49, 50)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (194, 49, 110)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (195, 49, 111)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (196, 49, 112)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (197, 49, 113)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (198, 49, 114)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (199, 49, 51)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (200, 49, 52)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (201, 50, 49)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (202, 50, 50)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (203, 50, 110)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (204, 50, 111)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (205, 50, 112)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (206, 50, 113)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (207, 50, 114)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (208, 50, 51)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (209, 50, 52)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (210, 51, 115)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (211, 51, 116)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (212, 51, 117)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (213, 51, 118)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (214, 52, 115)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (215, 52, 116)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (216, 52, 117)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (217, 52, 118)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (218, 53, 115)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (219, 53, 116)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (220, 53, 117)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (221, 53, 118)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (222, 54, 115)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (223, 54, 116)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (224, 54, 117)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (225, 54, 118)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (226, 55, 119)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (227, 56, 120)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (228, 57, 120)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (229, 58, 121)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (230, 59, 122)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (231, 60, 123)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (232, 61, 123)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (233, 62, 124)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (234, 63, 124)
GO
INSERT [dbo].[MoviePerson] ([IDMoviePerson], [MovieID], [PersonID]) VALUES (235, 64, 125)
GO
SET IDENTITY_INSERT [dbo].[MoviePerson] OFF
GO
SET IDENTITY_INSERT [dbo].[UserType] ON 
GO
INSERT [dbo].[UserType] ([IDUserType], [Name]) VALUES (1, N'Admin')
GO
INSERT [dbo].[UserType] ([IDUserType], [Name]) VALUES (2, N'User')
GO
SET IDENTITY_INSERT [dbo].[UserType] OFF
GO
SET IDENTITY_INSERT [dbo].[User] ON 
GO
INSERT [dbo].[User] ([IDUser], [Username], [Password], [UserTypeID]) VALUES (1, N'nikola', N'biskup', 1)
GO
INSERT [dbo].[User] ([IDUser], [Username], [Password], [UserTypeID]) VALUES (2, N'john', N'wick', 2)
GO
INSERT [dbo].[User] ([IDUser], [Username], [Password], [UserTypeID]) VALUES (1002, N'ivan', N'ivanoovic', 2)
GO
SET IDENTITY_INSERT [dbo].[User] OFF
GO

