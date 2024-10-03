CREATE DATABASE Art_Gallery
use Art_Gallery


-- Create the Artists table
CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

  -- Insert sample data into the Artists table
INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian');

SELECT * FROM Artists

-- Create the Categories table
CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

 -- Insert sample data into the Categories table
INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

 SELECT * FROM Categories

-- Create the Artworks table
CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

 -- Insert sample data into the Artworks table
INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Pablo Picasso powerful anti-war mural.', 'guernica.jpg');

 SELECT * FROM Artworks

-- Create the Exhibitions table
CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

 -- Insert sample data into the Exhibitions table
INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.');

 SELECT * FROM Exhibitions

-- Create a table to associate artworks with exhibitions
CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

-- Insert artworks into exhibitions
INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2);

 SELECT * FROM ExhibitionArtworks


-- 1. Retrieve the names of all artist aalong with the count of artworks.
SELECT a.Name, COUNT(aw.ArtworkID) AS ArtworkCount
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.Name
ORDER BY ArtworkCount DESC

-- 2. List the titles of artworks created by artsits from spanish and dutch
SELECT aw.Title
FROM Artworks aw
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Nationality IN ('Spanish', 'Dutch')
ORDER BY aw.Year ASC

-- 3. Find the names of all artists who have artworkin painting category
SELECT a.Name, COUNT(aw.ArtworkID) AS ArtworkCount
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
WHERE c.Name = 'painting'
GROUP BY a.Name

-- 4. List the names of artworks from the MAM exhibition
SELECT aw.Title, a.Name AS ArtistName, c.Name AS CategoryName
FROM ExhibitionArtworks ea
JOIN Artworks aw on ea.ArtworkID = aw.ArtworkID
JOIN Artists a ON aw.ArtistID = a.ArtistID
JOIN Categories c ON aw.CategoryID = c.CategoryID
JOIN Exhibitions e ON ea.ExhibitionID = e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces'

-- 5. Fint the artists who have more than two artworks in the gallery.
SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtworkID) > 1

-- 6. Fint the titles of artworks that were exhibited in both exhibitions.
SELECT aw.Title
FROM ExhibitionArtworks ea1
JOIN ExhibitionArtworks ea2 on ea1.ArtworkID = ea2.ArtworkID
JOIN Exhibitions e1 ON ea1.ExhibitionID = e1.ExhibitionID
JOIN Exhibitions e2 ON ea2.ExhibitionID = e2.ExhibitionID
JOIN Artworks aw ON ea1.ArtworkID = aw.ArtworkID
WHERE e1.Title = 'Modern Art Masterpieces' AND e2.Title = 'Renaissance Art'

-- 7. Find the total number of artworks in each category.
SELECT c.Name AS CategoryName, COUNT(aw.ArtworkID) AS TotalArtworks
FROM Categories c
LEFT JOIN Artworks aw On c.CategoryID = aw.CategoryID
GROUP BY c.Name

-- 8. List artists who have more than 43 artworks in the gallery.
SELECT a.Name
FROM artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtworkID) > 3;

-- 9. Find te artworks created by artists from a specific nationality.
SELECT aw.Title
FROM Artworks aw
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Nationality = 'Spanish'

-- 10. List exhibitions that feature artwork by gogh and vinci.
SELECT e.Title
FROM Exhibitions e
JOIN ExhibitionArtworks ea ON e.ExhibitionID = ea.ExhibitionID
JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
JOIN Artists a ON aw.ArtistID = a.ArtistID
WHERE a.Name IN ('Vincent van Gogh', 'Leonardo da Vinci')
GROUP BY e.ExhibitionID, e.Title
HAVING COUNT(DISTINCT a.Name) = 2


-- 11. Find all the artworks that have not been included in any exhibition.
SELECT aw.Title
FROM Artworks aw
LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL;

-- 12. List of artists who have created artwoeks in all available categories.
SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(DISTINCT aw.CategoryID) = (SELECT COUNT(*) FROM Categories)

-- 13. List the total number of artworks in each category.
SELECT	c.Name AS CategoryName, COUNT(aw.ArtworkID) AS TotalArtworks
FROM Categories c
LEFT JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name

-- 14. Fint the artists who have more than 2 artwork in gallery.
SELECT a.Name
FROM Artists a
JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtWorkID)>2

-- 15. List the categories with the avg year of artworks they contain,
SELECT c.Name AS CategoryName, AVG(aw.Year) AS AverageYear
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name
HAVING COUNT(aw.ArtworkID) > 1

-- 16. Find the artworks that were exhibited in the 'M A M' exhibition.
SELECT aw.Title
FROM ExhibitionArtworks ea 
JOIN Artworks aw ON ea.ArtworkID = aw.ArtworkID
JOIN Exhibitions e on ea.ExhibitionID = e.ExhibitionID
WHERE e.Title = 'Modern Art Masterpieces';

-- 17. Find the categories where the avg year of artworks is greater than the the avg year of all artworks.
SELECT  c.Name AS CategoryName
FROM Categories c
JOIN Artworks aw ON c.CategoryID = aw.CategoryID
GROUP BY c.Name
HAVING AVG(aw.Year) > (SELECT AVG(Year) FROM Artworks)

-- List the artworks that were not exhibited in any exhibition.
SELECT aw.Title
FROM Artworks aw
LEFT JOIN ExhibitionArtworks ea ON aw.ArtworkID = ea.ArtworkID
WHERE ea.ExhibitionID IS NULL;

-- 19. Show artists who have artworks in same category as 'mona lisa'.
SELECT DISTINCT a.Name
FROM Artists a
JOIN Artworks aw1 ON a.ArtistID = aw1.ArtistID
JOIN Artworks aw2 ON aw1.CategoryID = aw2.CategoryID
WHERE aw2.Title = 'Mona Lisa'

-- 20. List the names of artists and the number of artworks they have in the gallery.
SELECT a.Name, COUNT(aw.ArtworkID) AS ArtworkCount
FROM Artists a
LEFT JOIN Artworks aw ON a.ArtistID = aw.ArtistID
GROUP BY a.Name