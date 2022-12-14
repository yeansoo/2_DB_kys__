-- 1
SELECT STUDENT_NAME , STUDENT_ADDRESS 
FROM TB_STUDENT 
ORDER BY 1;

-- 2
SELECT STUDENT_NAME , STUDENT_SSN 
FROM TB_STUDENT 
WHERE ABSENCE_YN ='Y'
ORDER BY STUDENT_SSN DESC;

-- 3

SELECT STUDENT_NAME 학생이름 , STUDENT_NO 학번 , STUDENT_ADDRESS "거주지 주소" 
FROM TB_STUDENT 
WHERE (SUBSTR(STUDENT_ADDRESS,1,3)='경기도'
OR SUBSTR(STUDENT_ADDRESS,1,3)='강원도')
AND SUBSTR(STUDENT_NO,1,1)='9';

-- 4
SELECT PROFESSOR_NAME , PROFESSOR_SSN 
FROM TB_PROFESSOR 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME ='법학과'
ORDER BY PROFESSOR_SSN ;

-- 5
SELECT STUDENT_NO , POINT  -- TO_CHAR(POINT, 'FM9.00' ) 학점 
FROM TB_GRADE 
WHERE TERM_NO ='200402'
AND CLASS_NO ='C3118100'
ORDER BY POINT DESC, STUDENT_NO ;

-- 6

SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME 
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
ORDER BY STUDENT_NAME;

-- 7 

SELECT  CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO);

-- 8 

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS 
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR tp  USING(PROFESSOR_NO);

-- 9 결과가 좀 다름 

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS 
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR tp  USING(PROFESSOR_NO)
JOIN TB_DEPARTMENT td ON (tp.DEPARTMENT_NO  = td.DEPARTMENT_NO)
WHERE CATEGORY='인문사회';
-- 중복되는 컬럼명을 구분할 수 있도록
-- 테이블명.컬럼명 또는 별칭.컬럼명으로 구분 


SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_DEPARTMENT 
JOIN TB_CLASS USING(DEPARTMENT_NO)
JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_PROFESSOR USING(PROFESSOR_NO)
WHERE CATEGORY='인문사회';

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_PROFESSOR 
JOIN TB_CLASS_PROFESSOR USING(PROFESSOR_NO)
JOIN TB_CLASS USING(CLASS_NO)
JOIN TB_DEPARTMENT ON(TB_CLASS.DEPARTMENT_NO=TB_DEPARTMENT.DEPARTMENT_NO)
WHERE CATEGORY='인문사회';


-- 10 ORDER ERROR



SELECT STUDENT_NO 학번 , STUDENT_NAME 이름 ,ROUND(AVG(POINT),1) "전체 평점"
FROM TB_GRADE 
JOIN TB_STUDENT USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME='음악학과'
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY 학번;



SELECT STUDENT_NO , STUDENT_NAME ,ROUND(AVG(POINT),1)
FROM TB_DEPARTMENT  
JOIN TB_STUDENT USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(STUDENT_NO)
WHERE DEPARTMENT_NAME='음악학과'
GROUP BY STUDENT_NO, STUDENT_NAME;


-- 11

SELECT DEPARTMENT_NAME 학과이름 , STUDENT_NAME 학생이름 , PROFESSOR_NAME 지도교수이름 
FROM TB_DEPARTMENT 
JOIN TB_STUDENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON(PROFESSOR_NO=COACH_PROFESSOR_NO)
WHERE STUDENT_NO ='A313047';


-- 12
SELECT STUDENT_NAME, TERM_NO 
FROM TB_STUDENT 
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE SUBSTR(TERM_NO,1,4)='2007'
AND CLASS_NAME='인간관계론'
ORDER BY TERM_NO ;


-- 13 예체능 계열 과목 중 과목 담당교수를 한명


SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS 
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE PROFESSOR_NO IS NULL 
AND CATEGORY='예체능';

-- left join으로 null까지 출력 


SELECT *
FROM TB_CLASS_PROFESSOR TCP
LEFT JOIN TB_CLASS TC ON(TCP.CLASS_NO=TC.CLASS_NO)
LEFT JOIN TB_DEPARTMENT TD USING(TC.DEPARTMENT_NO=TD.DEPARTMENT_NO)
--WHERE CATEGORY='예체능'
WHERE PROFESSOR_NO IS NULL;

--WHERE PROFESSOR_NO IS NULL;
--FROM TB_CLASS 
--JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
----JOIN TB_DEPARTMENT USING(PROFESSOR_NO)
--WHERE CATEGORY ='예체능';

SELECT *
FROM TB_DEPARTMENT  
WHERE CATEGORY ='예체능';


-- 14
SELECT STUDENT_NAME 학생이름 , NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수 
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
LEFT JOIN TB_PROFESSOR ON(PROFESSOR_NO=COACH_PROFESSOR_NO)
WHERE DEPARTMENT_NAME ='서반아어학과';



-- 15

SELECT STUDENT_NO , STUDENT_NAME , DEPARTMENT_NAME, AVG(POINT)
FROM TB_STUDENT 
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_GRADE MAIN USING(STUDENT_NO)
WHERE ABSENCE_YN='N'
GROUP BY STUDENT_NO
HAVING AVG(POINT)>4.0;

SELECT AVG(POINT) 
FROM TB_GRADE 
GROUP BY STUDENT_NO;


SELECT TABLESPACE_NAME, TABLE_NAME FROM ALL_ALL_TABLES WHERE TABLE_NAME LIKE '%TB_STUDENT%';




-- 16 

SELECT CLASS_NO, CLASS_NAME, AVG(POINT)
FROM TB_CLASS 
JOIN TB_GRADE USING(CLASS_NO)
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
GROUP BY CLASS_NO , CLASS_NAME
WHERE DEPARTMANT_NAME='환경조경학과';


-- 17 
SELECT STUDENT_NAME, STUDENT_ADDRESS
FROM TB_STUDENT 
WHERE DEPARTMENT_NO =
(SELECT DEPARTMENT_NO FROM TB_STUDENT 
WHERE STUDENT_NAME='최경희');




-- 18 
SELECT STUDENT_NO, STUDENT_NAME 
FROM(
SELECT STUDENT_NO, STUDENT_NAME, AVG(POINT) 평점 
FROM TB_GRADE 
JOIN TB_STUDENT USING(STUDENT_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME='국어국문학과'
GROUP BY STUDENT_NO , STUDENT_NAME 
ORDER BY 평점 DESC
)
WHERE ROWNUM=1;

--19

SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT),1) 전공평점 
FROM TB_DEPARTMENT 
JOIN TB_CLASS USING(DEPARTMENT_NO)
JOIN TB_GRADE USING(CLASS_NO)
WHERE CLASS_TYPE LIKE '전공%'
AND CATEGORY=(SELECT CATEGORY 
				FROM TB_DEPARTMENT 
				WHERE DEPARTMENT_NAME ='환경조경학과')
GROUP BY DEPARTMENT_NAME
ORDER BY 1;

SELECT CATEGORY 
FROM TB_DEPARTMENT 
WHERE DEPARTMENT_NAME ='환경조경학과';


