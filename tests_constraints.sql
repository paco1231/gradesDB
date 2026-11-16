
-- Autor: Francisco Rosado Molina
-- Fecha: noviembre 2026


USE grados;


DROP TABLE IF EXISTS test_results;

CREATE TABLE test_results (
    test_result_id INT AUTO_INCREMENT,
    rule_id VARCHAR(10) NOT NULL,
    test_description VARCHAR(255) NOT NULL,
    test_status VARCHAR(4) NOT NULL,
    executed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (test_result_id),
    CONSTRAINT ck_test_results_status CHECK (test_status IN ('PASS','FAIL'))
);

DELIMITER //


CREATE OR REPLACE PROCEDURE p_log_test(
    IN p_rule_id VARCHAR(10),
    IN p_test_description VARCHAR(255),
    IN p_test_status VARCHAR(4)
)
BEGIN
    INSERT INTO test_results (rule_id, test_description, test_status)
    VALUES (p_rule_id, p_test_description, p_test_status);
END //




CREATE OR REPLACE PROCEDURE p_test_rn01_mh_requirement()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN01', 'Matrícula de honor con nota < 9', 'PASS');
    CALL p_populate();
    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (6, 1, 8.5, 'Segunda', 1);
    CALL p_log_test('RN01', 'Matrícula de honor con nota < 9', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_test_rn09_not_null()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN09', 'Persona con nombre NULL', 'PASS');
    CALL p_populate();
    INSERT INTO people (dni, first_name, last_name, age, email)
    VALUES ('99999999Z', NULL, 'Test', 20, 'test.rn09@us.es');
    CALL p_log_test('RN09', 'Persona con nombre NULL', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_test_rn10_subject_credits()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN10', 'Asignatura con 8 créditos', 'PASS');
    CALL p_populate();
    INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type)
    VALUES (3, 'Asignatura Test RN10', 'TST10', 8, 1, 'Obligatoria');
    CALL p_log_test('RN10', 'Asignatura con 8 créditos', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_test_rn11_grade_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN11', 'Nota con valor 11', 'PASS');
    CALL p_populate();
    INSERT INTO grades (student_id, group_id, grade_value, exam_call, with_honors)
    VALUES (6, 1, 11.0, 'Segunda', 0);
    CALL p_log_test('RN11', 'Nota con valor 11', 'FAIL');
END //

CREATE OR REPLACE PROCEDURE p_test_rn12_age_range()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN12', 'Persona con 15 años', 'PASS');
    CALL p_populate();
    INSERT INTO people (dni, first_name, last_name, age, email)
    VALUES ('99999998Y', 'Test', 'RN12', 15, 'test.rn12@us.es');
    CALL p_log_test('RN12', 'Persona con 15 años', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_test_rn13_degree_duration()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN13', 'Grado con 2 años', 'PASS');
    CALL p_populate();
    INSERT INTO degrees (degree_name, duration_years)
    VALUES ('Grado Test RN13', 2);
    CALL p_log_test('RN13', 'Grado con 2 años', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_test_rn14_dni_format()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN14', 'Persona con DNI "INVALIDO"', 'PASS');
    CALL p_populate();
    INSERT INTO people (dni, first_name, last_name, age, email)
    VALUES ('INVALIDO', 'Test', 'RN14', 20, 'test.rn14@us.es');
    CALL p_log_test('RN14', 'Persona con DNI "INVALIDO"', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_test_rn15_academic_year()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN15', 'Grupo del año 1999', 'PASS');
    CALL p_populate();
    INSERT INTO groups (subject_id, group_name, activity, academic_year)
    VALUES (11, 'T9', 'Teoría', 1999);
    CALL p_log_test('RN15', 'Grupo del año 1999', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_test_rn16_subject_course()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        CALL p_log_test('RN16', 'Asignatura en curso 7', 'PASS');
    CALL p_populate();
    INSERT INTO subjects (degree_id, subject_name, acronym, credits, course, subject_type)
    VALUES (3, 'Asignatura Test RN16', 'TST16', 6, 7, 'Obligatoria');
    CALL p_log_test('RN16', 'Asignatura en curso 7', 'FAIL');
END //


CREATE OR REPLACE PROCEDURE p_run_tests()
BEGIN
    DELETE FROM test_results;

    CALL p_test_rn01_mh_requirement();
    CALL p_test_rn09_not_null();
    CALL p_test_rn10_subject_credits();
    CALL p_test_rn11_grade_range();
    CALL p_test_rn12_age_range();
    CALL p_test_rn13_degree_duration();
    CALL p_test_rn14_dni_format();
    CALL p_test_rn15_academic_year();
    CALL p_test_rn16_subject_course();


    CALL p_populate();

    SELECT test_status AS Estado, COUNT(*) AS Total
    FROM test_results
    GROUP BY test_status;
END //

DELIMITER ;


CALL p_run_tests();


SELECT rule_id, test_description, test_status
FROM test_results
ORDER BY test_result_id;