Select *
FROM SurveyOnProfessionals.dbo.Survey

--DROP COLUMNS THAT WE DON'T NEED
ALTER TABLE SurveyOnProfessionals..Survey
DROP COLUMN Browser, OS, City, Country, Referrer

 --TO SPLIT THE JOB TITLE COLUMN AND REMOVE EVERYTHING AFTER THE PARENTHESIS IN THE 'OTHER' OPTION--
SELECT
CASE WHEN CHARINDEX('(',JobTitle) > 0
THEN LEFT(JobTitle, CHARINDEX('(', JobTITLE) -1) 
ELSE JobTitle
END AS first_part,
CASE WHEN CHARINDEX('(',JobTitle) > 0
THEN SUBSTRING(JobTitle, CHARINDEX('(', JobTitle), LEN(JobTitle) - CHARINDEX('(', JobTitle) +1) 
ELSE NULL
END AS second_part
FROM SurveyOnProfessionals..Survey

--TO ADD THE NEW SPLITTED COLUMN TO THE TABLE--
ALTER TABLE SurveyOnProfessionals..Survey
ADD first_part VARCHAR(255)

--TO UPDATE THE NEWLY ADDED TABLE--
UPDATE SurveyOnProfessionals..Survey
SET first_part = CASE WHEN CHARINDEX('(', JobTitle) > 0
THEN LEFT(JobTitle, CHARINDEX('(', JobTitle) -1)
ELSE JobTitle
END

--DELETE THE FORMER JOB TITLE AND RENAME THE FIRST_PART TO CURRENT ROLE--
ALTER TABLE SurveyOnProfessionals..Survey
DROP COLUMN JobTitle

--RENAME COLUMN NAMED 'FAVORITE PROGRAMMING LANGUAGE' TO 'FavLang' from sidebar then split column by delimiter as seen earlier. Delimiter might be different.--



 --TO SPLIT THE FavLang COLUMN AND REMOVE EVERYTHING AFTER THE PARENTHESIS IN THE 'OTHER' OPTION--
SELECT
CASE WHEN CHARINDEX(':',FavLang) > 0
THEN LEFT(FavLang, CHARINDEX(':', FavLang) -1) 
ELSE FavLang
END AS first_part,
CASE WHEN CHARINDEX(':',FavLang) > 0
THEN SUBSTRING(FavLang, CHARINDEX(':', FavLang), LEN(FavLang) - CHARINDEX(':', FavLang) +1) 
ELSE NULL
END AS second_part
FROM SurveyOnProfessionals..Survey


--TO ADD THE NEW SPLITTED COLUMN TO THE TABLE--
ALTER TABLE SurveyOnProfessionals..Survey
ADD first_part VARCHAR(255)

--TO UPDATE THE NEWLY ADDED TCOLUMN--
UPDATE SurveyOnProfessionals..Survey
SET first_part = CASE WHEN CHARINDEX(':', FavLang) > 0
THEN LEFT(FavLang, CHARINDEX(':', FavLang) -1)
ELSE FavLang
END

ALTER TABLE SurveyOnProfessionals..Survey
DROP COLUMN FavLang

--TO CREATE MINIMUM AND MAXIMUM SALARY COLUMNS FROM 'Q3-CURRENT YEARLY SALARY IN USD'
ALTER TABLE SurveyOnProfessionals..Survey
ADD min_salary, max_salary

--UPDATE MIN SALARY & MAX SALARY COLUMNS WITH APPROPRIATE FIGURES
UPDATE SurveyOnProfessionals..Survey
SET
min_salary = CASE WHEN CHARINDEX('-', [Q3 - Current Yearly Salary (in USD)]) > 0 THEN LEFT([Q3 - Current Yearly Salary (in USD)], CHARINDEX('-', [Q3 - Current Yearly Salary (in USD)])-1) ELSE REPLACE([Q3 - Current Yearly Salary (in USD)], 'k','') END,
max_salary = CASE WHEN CHARINDEX('-', [Q3 - Current Yearly Salary (in USD)]) > 0 THEN RIGHT([Q3 - Current Yearly Salary (in USD)], LEN([Q3 - Current Yearly Salary (in USD)]) - CHARINDEX('-', [Q3 - Current Yearly Salary (in USD)])) ELSE REPLACE([Q3 - Current Yearly Salary (in USD)], 'k', '') END

--REMOVE 'K' and '+' FROM MIN &  MAX SALARY
UPDATE SurveyOnProfessionals..Survey
SET min_salary = REPLACE(min_salary, 'k', '')

UPDATE SurveyOnProfessionals..Survey
SET min_salary = REPLACE(min_salary, '+', '')

UPDATE SurveyOnProfessionals..Survey
SET max_salary = REPLACE(max_salary, 'k', '')

UPDATE SurveyOnProfessionals..Survey
SET max_salary = REPLACE(max_salary, '+', '')

--CREATE AVG SALARY PER PROFESSIONAL WHICH WE HAVE TAKEN TO BE MIN SALARY + MAX SALARY DIVIDED BY 2
ALTER TABLE SurveyOnProfessionals..Survey
ADD AvgSalary INT

UPDATE SurveyOnProfessionals..Survey
SET AvgSalary = (CONVERT(INT, min_salary) + CONVERT(INT, max_salary)) / 2

--WE DON'T NEED THE MIN_SALARY & MAX SALARY COLUMNS ANYMORE SO WE CAN DELETE THEM
ALTER TABLE SurveyOnProfessionals..Survey
DROP COLUMN min_salary, max_salary

--WE NEED THE "WHAT INDUSTRY DO YOU WORK IN?" & "WHICH COUNTRY DO YOU LIVE IN?" COLUMNS SO WE NEED TO REMOVE THE 'OTHERS' FROM THOSE TWO COLUMS JUST LIKE WE DID TO FAVOURITE LANGUAGE BUT BECAUSE I'M NIGERIAN, I WANT TO KEEP 'NIGERIA'
--FIRST, RENAME THEM TO INDUSTRY AND COUNTRY OF RESIDENCE

ALTER TABLE SurveyOnProfessionals..Survey
ADD CountryOfResidence2 VARCHAR(255)

UPDATE SurveyOnProfessionals..Survey
SET CountryOfResidence2 = CountryOfResidence

UPDATE SurveyOnProfessionals..Survey
Set CountryOfResidence2 =
CASE
WHEN CountryOfResidence LIKE 'Other (Please Specify):Nigeria%' THEN 'Nigeria'
WHEN CountryOfResidence LIKE 'Other (Please Specify)%' THEN 'Other'
ELSE CountryOfResidence
END

ALTER TABLE SurveyOnProfessionals..Survey
ADD Industry2 VARCHAR(255)

UPDATE SurveyOnProfessionals..Survey
SET Industry2 = Industry

UPDATE SurveyOnProfessionals..Survey
Set Industry2 =
CASE
WHEN Industry LIKE 'Other %' THEN 'Other'
ELSE Industry
END

--DROP COLUMNS THAT WE DON'T NEED--
ALTER TABLE SurveyOnProfessionals..Survey
DROP COLUMN Email, [Time Taken (America/New_York)], [Time Spent], [Q3 - Current Yearly Salary (in USD)], Industry, CountryOfResidence

--VIEW ENTIRE TABLE AGAIN
Select *
FROM SurveyOnProfessionals.dbo.Survey

--PROCEED TO VISUALIZE WITH POWERBI