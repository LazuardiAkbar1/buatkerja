# Queries

 --1. Tampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut

SELECT 
    students.name AS student_name, 
    classes.name AS class_name, 
    teachers.name AS teacher_name
FROM 
    students
JOIN 
    classes ON students.class_id = classes.id
JOIN 
    teachers ON classes.teacher_id = teachers.id;

 --2. Tampilkan daftar kelas yang diajar oleh guru yang sama

SELECT 
    teachers.name AS teacher_name, 
    GROUP_CONCAT(classes.name) AS class_names
FROM 
    classes
JOIN 
    teachers ON classes.teacher_id = teachers.id
GROUP BY 
    teachers.name;

 --3. Buat query view untuk siswa, kelas, dan guru yang mengajar

CREATE VIEW student_class_teacher_view AS
SELECT 
    students.name AS student_name, 
    classes.name AS class_name, 
    teachers.name AS teacher_name
FROM 
    students
JOIN 
    classes ON students.class_id = classes.id
JOIN 
    teachers ON classes.teacher_id = teachers.id;

 --4. Buat query yang sama tapi menggunakan stored procedure

DELIMITER //
CREATE PROCEDURE get_student_class_teacher()
BEGIN
    SELECT 
        students.name AS student_name, 
        classes.name AS class_name, 
        teachers.name AS teacher_name
    FROM 
        students
    JOIN 
        classes ON students.class_id = classes.id
    JOIN 
        teachers ON classes.teacher_id = teachers.id;
END //
DELIMITER ;


CALL get_student_class_teacher();

 5. Buat query input, yang akan memberikan warning error jika ada data yang sama pernah masuk

DELIMITER //
CREATE PROCEDURE insert_unique_student(
    IN student_name VARCHAR(100),
    IN student_age INT,
    IN student_class_id INT
)
BEGIN
    DECLARE student_exists INT;

    
    SELECT COUNT(*) INTO student_exists
    FROM students
    WHERE name = student_name AND age = student_age AND class_id = student_class_id;

    
    IF student_exists = 0 THEN
        INSERT INTO students (name, age, class_id) 
        VALUES (student_name, student_age, student_class_id);
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Data already exists';
    END IF;
END //
DELIMITER ;


CALL insert_unique_student('Budi', 16, 1);

