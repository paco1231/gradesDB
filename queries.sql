--
-- Autor: [Francisco]
-- Fecha: Octubre 2026
-- Descripción: Consultas SQL de ejemplo para GradesDB
--              Cubre conceptos de consultas simples y avanzadas
--

USE grados;
SELECT*
FROM subjects;
SELECT*
FROM subjects s
WHERE s.acronym='IISSI-1';
SELECT s.subject_name, s.acronym 
FROM subjects s;
SELECT s.subject_name, s.acronym, s.subject_type
FROM subjects s
WHERE s.subject_type = 'Formación Básica';
SELECT p.first_name, p.last_name, st.access_method
FROM students st
JOIN people p ON st.student_id = p.person_id
WHERE st.access_method = 'Selectividad';
SELECT p.first_name, p.last_name, pr.category
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id
WHERE pr.category = 'Catedrático';
CREATE OR REPLACE VIEW v_professors AS
SELECT 
   pr.professor_id,
   pr.category,
   p.person_id,
   p.dni,
   p.first_name,
   p.last_name,
   p.age,
   p.email
FROM professors pr
JOIN people p ON pr.professor_id = p.person_id;
CREATE OR REPLACE VIEW v_students AS
SELECT 
   st.student_id,
   st.access_method,
   p.person_id,
   p.dni,
   p.first_name,
   p.last_name,
   p.age,
   p.email
FROM students st
JOIN people p ON st.student_id = p.person_id;
SELECT AVG(g.grade_value) AS average_grade
FROM grades g
WHERE g.group_id = 1;

