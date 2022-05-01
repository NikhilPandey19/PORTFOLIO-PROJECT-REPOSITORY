--Setting The Table
SELECT*
FROM dataset_1;

ALTER TABLE dataset_1 
RENAME COLUMN row_count TO UniqueID;

ALTER TABLE dataset_1 
DROP COLUMN CustomerID;


--Finding Empty Cells
--CarryAway

SELECT CarryAway, UniqueID
FROM dataset_1 d 
WHERE CarryAway = 'NULL' IS TRUE 
ORDER BY UniqueID;

SELECT AVG(CarryAway)
FROM dataset_1 d;

UPDATE dataset_1 
SET CarryAway = '1~2' WHERE CarryAway = 'NULL';

SELECT*
FROM dataset_1;

--Bar

SELECT Bar , UniqueID
FROM dataset_1 d 
WHERE Bar  = '' IS TRUE 
ORDER BY UniqueID;

UPDATE dataset_1 
SET Bar  = 'no answer' WHERE Bar  = '';

SELECT*
FROM dataset_1;

--car

SELECT car  , UniqueID
FROM dataset_1 d 
WHERE car = '' IS TRUE 
ORDER BY UniqueID;

ALTER TABLE dataset_1 
DROP COLUMN car;

SELECT*
FROM dataset_1;

--RestaurantLessThan20

SELECT RestaurantLessThan20 , UniqueID
FROM dataset_1 d 
WHERE RestaurantLessThan20 = '' IS TRUE 
ORDER BY UniqueID;

UPDATE dataset_1 
SET RestaurantLessThan20 = 'no answer' WHERE RestaurantLessThan20 = '';

SELECT*
FROM dataset_1;


SELECT Restaurant20To50 , UniqueID
FROM dataset_1 d 
WHERE Restaurant20To50 = '' IS TRUE 
ORDER BY UniqueID;

UPDATE dataset_1 
SET Restaurant20To50 = 'no answer' WHERE Restaurant20To50 = '';


ALTER TABLE dataset_1 
DROP COLUMN Y;

