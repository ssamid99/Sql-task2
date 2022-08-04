CREATE DATABASE BlogDatabase
USE BlogDatabase

CREATE TABLE Posts
(
Id INT PRIMARY KEY IDENTITY,
Content NVARCHAR(500),
ShareDate DATETIME DEFAULT GETUTCDATE(),
LikeCount INT,
IsDeleted BIT DEFAULT 0,
PeopleId INT NOT NULL REFERENCES People(Id)
)

CREATE TABLE Users
(
Id INT PRIMARY KEY IDENTITY,
Login NVARCHAR(35) UNIQUE NOT NULL,
Password NVARCHAR(50) CONSTRAINT CK_PASSWORD CHECK(LEN(Password)>=8) NOT NULL,
Mail NVARCHAR(50) NOT NULL
)

CREATE TABLE Comments
(
Id INT PRIMARY KEY IDENTITY,
LikeCount INT,
IsDeleted BIT DEFAULT 0,
UserId INT REFERENCES Users(Id) NOT NULL,
PostId INT REFERENCES Posts(Id) NOT NULL 
)

CREATE TABLE People
(
Id INT PRIMARY KEY IDENTITY,
Name NVARCHAR(25) NOT NULL,
Surname NVARCHAR(35) NOT NULL,
Age INT,
)

INSERT INTO Users
VALUES
('samadzada123', '1234hds789', 'samidms@code.edu.az'),
('mammadli123', '2345678754mm', 'mammadlifm@code.edu.az'),
('safarli123', '1123123rr', 'raminrs@code.edu.az'),
('safarov123', '123131312zz', 'zamanjs@code.edu.az'),
('nacafov321', '3243422sss', 'seyfisn@code.edu.az')

INSERT INTO People
VALUES
('Rahim', 'Rahimov', 27),
('Cavid', 'Mirzayev', 34),
('Rauf', 'Ganbarli', 24),
('Rafiq', 'Guluzada', 23),
('Anar', 'Humbatov', 18)

INSERT INTO Posts
VALUES
('Relating to the government or public affairs of a country.', '', 25,'', 1),
('An international space crew discovers life on Mars.', '', 491, '', 5),
('International Space Station discover a rapidly', '', 224, '', 3),
('Life: Directed by Ted Demme. With Eddie Murphy', '', 553, '', 2),
('No row was updated .Net SqlClient Data Provider', '', 3300,'', 4),
('Relating to the country.', '', 123, '', 1),
('An international space crew  ...', '', 411, '', 2),
('Internal rapidly', '', 152, '', 3),
('Life: Directed by Ted', '', 518, '', 4),
('SqlClient Data Provider', '', 50,'', 5)
select * from Posts
select * from Comments
select * from Users
select * from People
INSERT INTO Comments(LikeCount, IsDeleted, UserId, PostId)
VALUES
(35, '', 5, 3),
(64, '', 2, 1),
(3000, '', 1, 2),
(1500, '', 3, 4),
(1243, '', 4, 5),
(2334, '', 3, 1),
(223, '', 1, 5),
(765, '', 5, 3),
(321, '', 2, 4)

SELECT COUNT(*) as 'Comment Sayi', Posts.Id as 'Posts' from Comments
JOIN Posts
ON Comments.PostId = Posts.Id
GROUP BY Posts.Id 

CREATE VIEW AllRelations
AS
SELECT Posts.Id as Posts, Posts.Content, Posts.ShareDate, Posts.LikeCount, Posts.IsDeleted, Posts.PeopleId, Comments.Id, Comments.LikeCount as CommentLikes, Comments.IsDeleted as CommentActive, Users.Id as Users, Users.Login, Users.Password, Users.Mail from ((Comments
inner join Posts on Comments.PostId = Posts.Id)
inner join Users on Comments.UserId = Users.Id)

select * from AllRelations

CREATE TRIGGER UpdateIsDeletePosts
ON Posts
INSTEAD OF DELETE
AS
BEGIN
DECLARE @Id INT
SELECT @Id = Id FROM deleted
UPDATE Posts SET IsDeleted = 1 WHERE Id = @Id
END

DELETE Posts
WHERE Id = 4
CREATE TRIGGER UpdateIsDeleteComments
ON Comments
INSTEAD OF DELETE
AS 
BEGIN
DECLARE @Id INT
SELECT @Id = Id FROM deleted
UPDATE Comments SET IsDeleted = 1 WHERE Id = @Id
END
DELETE Comments
WHERE Id = 4

CREATE PROCEDURE PostLikeCountUp (@Id INT)
AS
UPDATE Posts SET LikeCount = LikeCount + 1
WHERE @Id = Posts.Id
GO
EXEC PostLikeCountUp @Id = 3
SELECT * from Posts

CREATE PROCEDURE ResetPassword (@Mail NVARCHAR(50), @Login NVARCHAR(35), @Password NVARCHAR(30))
AS
UPDATE Users SET Password = @Password
WHERE @Mail = Users.Mail or @Login =Users.[Login]
GO

DROP PROCEDURE PostLikeCountUp

EXEC ResetPassword 
@Login = 'samadzada123',
@Mail = '',
@Password = '123fsfttiiyu'
