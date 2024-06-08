create database lms;
show databases;
use lms;

CREATE TABLE FileSystem (
    NodeID INT PRIMARY KEY,
    NodeName VARCHAR(100),
    ParentID INT,
    SizeBytes INT
);

INSERT INTO FileSystem (NodeID, NodeName, ParentID, SizeBytes) VALUES
(1, 'Documents', NULL, NULL),
(2, 'Pictures', NULL, NULL),
(3, 'File1.txt', 1, 500),
(4, 'Folder1', 1, NULL),
(5, 'Image.jpg', 2, 1200),
(6, 'Subfolder1', 4, NULL),
(7, 'File2.txt', 4, 750),
(8, 'File3.txt', 6, 300),
(9, 'Folder2', 2, NULL),
(10, 'File4.txt', 9, 250);

WITH RECURSIVE FileSystemSizes AS (
    -- Base case: select files with their sizes
    SELECT 
        NodeID,
        NodeName,
        ParentID,
        SizeBytes
    FROM 
        FileSystem
    WHERE
        SizeBytes IS NOT NULL
    
    UNION ALL
    
    -- Recursive case: calculate folder sizes
    SELECT
        fs.NodeID,
        fs.NodeName,
        fs.ParentID,
        COALESCE(fss.SizeBytes, 0) AS SizeBytes
    FROM
        FileSystem fs
        LEFT JOIN FileSystemSizes fss
        ON fs.NodeID = fss.ParentID
)
SELECT 
    fs.NodeID,
    fs.NodeName,
    SUM(fss.SizeBytes) AS sizeBytes
FROM 
    FileSystem fs
    LEFT JOIN FileSystemSizes fss
    ON fs.NodeID = fss.ParentID
GROUP BY 
    fs.NodeID,
    fs.NodeName
ORDER BY
    fs.NodeID;


