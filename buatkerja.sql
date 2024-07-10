-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 10 Jul 2024 pada 18.08
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `buatkerja`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_student_class_teacher` ()   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_unique_student` (IN `student_name` VARCHAR(100), IN `student_age` INT, IN `student_class_id` INT)   BEGIN
    DECLARE student_exists INT;

    -- Cek apakah data yang sama sudah ada
    SELECT COUNT(*) INTO student_exists
    FROM students
    WHERE name = student_name AND age = student_age AND class_id = student_class_id;

    -- Jika data tidak ada, masukkan data baru
    IF student_exists = 0 THEN
        INSERT INTO students (name, age, class_id) 
        VALUES (student_name, student_age, student_class_id);
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Data already exists';
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `classes`
--

CREATE TABLE `classes` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `teacher_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `classes`
--

INSERT INTO `classes` (`id`, `name`, `teacher_id`) VALUES
(1, 'Kelas 10A', 1),
(2, 'Kelas 11B', 2),
(3, 'Kelas 12C', 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `class_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `students`
--

INSERT INTO `students` (`id`, `name`, `age`, `class_id`) VALUES
(1, 'Budi', 16, 1),
(2, 'Ani', 17, 2),
(3, 'Candra', 18, 3);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `student_class_teacher_view`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `student_class_teacher_view` (
`student_name` varchar(100)
,`class_name` varchar(50)
,`teacher_name` varchar(100)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `teachers`
--

CREATE TABLE `teachers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `teachers`
--

INSERT INTO `teachers` (`id`, `name`, `subject`) VALUES
(1, 'Pak Anton', 'Matematika'),
(2, 'Bu Dina', 'Bahasa Indonesia'),
(3, 'Pak Eko', 'Biologi');

-- --------------------------------------------------------

--
-- Struktur untuk view `student_class_teacher_view`
--
DROP TABLE IF EXISTS `student_class_teacher_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `student_class_teacher_view`  AS SELECT `students`.`name` AS `student_name`, `classes`.`name` AS `class_name`, `teachers`.`name` AS `teacher_name` FROM ((`students` join `classes` on(`students`.`class_id` = `classes`.`id`)) join `teachers` on(`classes`.`teacher_id` = `teachers`.`id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- Indeks untuk tabel `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD KEY `class_id` (`class_id`);

--
-- Indeks untuk tabel `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `classes`
--
ALTER TABLE `classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `classes`
--
ALTER TABLE `classes`
  ADD CONSTRAINT `classes_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`);

--
-- Ketidakleluasaan untuk tabel `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `students_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
