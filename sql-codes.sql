Top Competitors

SELECT H.hacker_id, 
   H.name 
FROM   submissions S 
   JOIN challenges C 
     ON S.challenge_id = C.challenge_id 
   JOIN difficulty D 
     ON C.difficulty_level = D.difficulty_level 
   JOIN hackers H 
     ON S.hacker_id = H.hacker_id 
        AND S.score = D.score 
GROUP  BY H.hacker_id, 
  H.name 
HAVING Count(S.hacker_id) > 1 
ORDER  BY Count(S.hacker_id) DESC,  S.hacker_id ASC;

------------------------------------------------------------------------------------------------------------------

Ollivanders Inventory

SELECT a.id, 
   b.age, 
   a.coins_needed, 
   a.power 
FROM   wands a 
   JOIN wands_property b 
     ON a.code = b.code 
WHERE  b.is_evil = 0 
    AND a.coins_needed = (SELECT Min(a1.coins_needed) 
    FROM   wands a1 
        JOIN wands_property b1 
          ON a1.code = b1.code 
    WHERE  b.age = b1.age 
        AND a.power = a1.power) 
ORDER  BY a.power DESC, 
          b.age DESC;

---------------------------------------------------------------------------------------------------------------------

Challenges

SELECT h.hacker_id, 
       h.name, 
       COUNT(c.challenge_id) AS c_count
FROM Hackers h
JOIN Challenges c ON c.hacker_id = h.hacker_id
GROUP BY h.hacker_id, h.name
HAVING c_count = 
    (SELECT COUNT(c2.challenge_id) AS c_max
     FROM challenges as c2 
     GROUP BY c2.hacker_id 
     ORDER BY c_max DESC limit 1)
OR c_count IN 
    (SELECT DISTINCT c_compare AS c_unique
     FROM (SELECT h2.hacker_id, 
                  h2.name, 
                  COUNT(challenge_id) AS c_compare
           FROM Hackers h2
           JOIN Challenges c ON c.hacker_id = h2.hacker_id
           GROUP BY h2.hacker_id, h2.name) counts
     GROUP BY c_compare
     HAVING COUNT(c_compare) = 1)

ORDER BY c_count DESC, h.hacker_id;

-------------------------------------------------------------------------------------------------------------------------

New Companies

select c.company_code, c.founder, count(distinct lm.lead_manager_code), count(distinct sm.senior_manager_code), count(distinct m.manager_code), count(distinct e.employee_code) from Company c, Lead_Manager lm, Senior_Manager sm, Manager m, Employee e
where c.company_code = lm.company_code and lm.lead_manager_code = sm.lead_manager_code and sm.senior_manager_code = m.senior_manager_code and m.manager_code = e.manager_code group by c.company_code, c.founder
order by c.company_code

--------------------------------------------------------------------------------------------------------------------------

Binary Tree Nodes

SELECT N, CASE WHEN P IS NULL THEN 'Root' 
WHEN(SELECT COUNT(*) FROM BST WHERE P = A.N) > 0 THEN 'Inner'
ELSE 'Leaf'
END
FROM BST A
ORDER BY N;

---------------------------------------------------------------------------------------------------------------------------

Occupations

set @r1=0, @r2=0, @r3=0, @r4=0;
select min(Doctor), min(Professor), min(Singer), min(Actor)
from(select case when Occupation="Doctor" then (@r1:=@r1+1) when Occupation="Professor" then (@r2:=@r2+1) when Occupation="Singer" then (@r3:=@r3+1) when Occupation="Actor" then (@r4:=@r4+1) end as RowNumber,
case when Occupation="Doctor" then Name end as Doctor,
case when Occupation="Professor" then Name end as Professor,
case when Occupation="Singer" then Name end as Singer,
case when Occupation="Actor" then Name end as Actor from OCCUPATIONS order by Name
) Temp group by RowNumber;

--------------------------------------------------------------------------------------------------------------------------

Contest Leaderboard

select h.hacker_id,h.name,sum(sscore)
from Hackers h inner join (select s.hacker_id,max(score) as sscore from Submissions s group by s.hacker_id,s.challenge_id) st on h.hacker_id=st.hacker_id
group by h.hacker_id,h.name
having sum(sscore)>0
order by sum(sscore) desc,h.hacker_id asc;

---------------------------------------------------------------------------------------------------------------------------

SQL Project Planning 

SELECT START_DATE, MIN(END_DATE)
FROM
  (SELECT START_DATE
   FROM PROJECTS
   WHERE START_DATE NOT IN
       (SELECT END_DATE
        FROM PROJECTS)) A,
  (SELECT END_DATE
   FROM PROJECTS
   WHERE END_DATE NOT IN
       (SELECT START_DATE
        FROM PROJECTS)) B
WHERE START_DATE < END_DATE
GROUP BY START_DATE
ORDER BY (MIN(END_DATE) - START_DATE), START_DATE;

----------------------------------------------------------------------------------------------------------------------------

Placements

Select S.NAME
FROM STUDENTS S 
JOIN FRIENDS F ON S.ID = F.ID
JOIN PACKAGES P1 ON S.ID = P1.ID
JOIN PACKAGES P2 ON F.FRIEND_ID = P2.ID
WHERE P2.SALARY > P1.SALARY
ORDER BY P2.SALARY;

---------------------------------------------------------------------------------------------------------------------------

Symmetric Pairs 

SELECT X,
       Y
FROM FUNCTIONS F1
WHERE EXISTS
    (SELECT *
     FROM FUNCTIONS F2
     WHERE F2.Y = F1.X
       AND F2.X = F1.Y
       AND F2.X > F1.X)
  AND (X != Y)
UNION
SELECT X,
       Y
FROM FUNCTIONS F1
WHERE X = Y
  AND (
         (SELECT COUNT(*)
          FROM FUNCTIONS
          WHERE X = F1.X
            AND Y = F1.X) > 1)
ORDER BY X;

----------------------------------------------------------------------------------------------------------------------------

Print Prime Numbers

SET @number = 1;
   SET @divisor = 1;
SELECT GROUP_CONCAT(n SEPARATOR '&')
  FROM (SELECT @number := @number + 1 AS n 
          FROM information_schema.tables AS t1, information_schema.tables AS t2
         LIMIT 1000
       ) AS n1
 WHERE NOT EXISTS(SELECT *
                    FROM (SELECT @divisor := @divisor + 1 AS d
                            FROM information_schema.tables AS t3, information_schema.tables AS t4
                           LIMIT 1000
                         ) AS n2
                   WHERE MOD(n, d) = 0 AND n <> d)

-----------------------------------------------------------------------------------------------------------------------------

Weather Observation Station 20

Select round(S.LAT_N,4) from station AS S where (select count(Lat_N) from station where Lat_N < S.LAT_N ) = (select count(Lat_N) from station where Lat_N > S.LAT_N);

------------------------------------------------------------------------------------------------------------------------------

15 Days of Learning SQL

SELECT SUBMISSION_DATE,
(SELECT COUNT(DISTINCT HACKER_ID)  
 FROM SUBMISSIONS S2  
 WHERE S2.SUBMISSION_DATE = S1.SUBMISSION_DATE AND    
(SELECT COUNT(DISTINCT S3.SUBMISSION_DATE) 
 FROM SUBMISSIONS S3 WHERE S3.HACKER_ID = S2.HACKER_ID AND S3.SUBMISSION_DATE < S1.SUBMISSION_DATE) = DATEDIFF(S1.SUBMISSION_DATE , '2016-03-01')),
(SELECT HACKER_ID FROM SUBMISSIONS S2 WHERE S2.SUBMISSION_DATE = S1.SUBMISSION_DATE 
GROUP BY HACKER_ID ORDER BY COUNT(SUBMISSION_ID) DESC, HACKER_ID LIMIT 1) AS TMP,
(SELECT NAME FROM HACKERS WHERE HACKER_ID = TMP)
FROM
(SELECT DISTINCT SUBMISSION_DATE FROM SUBMISSIONS) S1
GROUP BY SUBMISSION_DATE;