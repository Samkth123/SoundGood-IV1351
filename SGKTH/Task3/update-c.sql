CREATE TABLE address (
 street VARCHAR(100),
 zip VARCHAR(100),
 city VARCHAR(100)
);


CREATE TABLE desiredInstrument (
);


CREATE TABLE Instrument (
 name VARCHAR(100) NOT NULL
);


CREATE TABLE instrumentGP (
 intrument_in_group_lesson VARCHAR(100)
);


CREATE TABLE instrumentHeCanTeach (
 Attribute9 CHAR(10)
);


CREATE TABLE lessonsLevel (
);


CREATE TABLE number_of_lessons (
);


CREATE TABLE number_of_places (
 number_of_Students_In_GP INT
);


CREATE TABLE person (
 personal_number VARCHAR(12) NOT NULL,
 first_name VARCHAR(100) NOT NULL,
 last_name VARCHAR(100) NOT NULL,
 age INT,
 street VARCHAR(100),
 zip VARCHAR(100),
 city VARCHAR(100)
);


CREATE TABLE school(
 school_name VARCHAR(100) NOT NULL,
 street VARCHAR(100),
 zip VARCHAR(100),
 city VARCHAR(100)
);


CREATE TABLE Skill (
 type_of VARCHAR(300) NOT NULL
);


CREATE TABLE skillLevel (
);


CREATE TABLE skills (
 level_of_skill VARCHAR(100)
);


CREATE TABLE aplication (
 id INT NOT NULL,
 phone_Number VARCHAR(100) NOT NULL,
 name VARCHAR(100) NOT NULL,
 if_has_sibling VARCHAR(100),
 personal_number VARCHAR(12) NOT NULL,
 aplication_date DATE NOT NULL,
 main_instrument VARCHAR(100) NOT NULL,
 email VARCHAR(100) NOT NULL,
 street VARCHAR(100),
 zip VARCHAR(100),
 city VARCHAR(100),
 current_skill_level CHAR(10)
);



CREATE TABLE ContactDetails (
 phoneNumber VARCHAR(10),
 personalNumber VARCHAR(10),
 name VARCHAR(10),
 ifHasSibling CHAR(10),
 id INT
);


CREATE TABLE instructor (
 id INT NOT NULL,
 can_teach_ensemble VARCHAR(100)
)INHERITS (person);

ALTER TABLE Instructor ADD CONSTRAINT PK_Instructor PRIMARY KEY (id);


CREATE TABLE instructor_payments (
 id INT NOT NULL,
 group_or_induvidual_lessons_or_ensemble VARCHAR(100),
 instructor_id INT
);

ALTER TABLE instructor_payments ADD CONSTRAINT PK_instructor_payments PRIMARY KEY (id);


CREATE TABLE room (
 aplication_id INT NOT NULL,
 room_for_new_students VARCHAR(100)
);

ALTER TABLE room ADD CONSTRAINT PK_room PRIMARY KEY (aplication_id);


CREATE TABLE student (
 id INT NOT NULL,
 main_instrument VARCHAR(100),
 total_lessons INT NOT NULL,
 aplication_id INT NOT NULL,
 total_ensembles INT,
 total_group_lessons INT
)INHERITS (person);

ALTER TABLE student ADD CONSTRAINT PK_student PRIMARY KEY (id);


CREATE TABLE student_payments (
 id INT NOT NULL,
 price_catagory_skill_level VARCHAR(100),
 price_catagory_lesson VARCHAR(100),
 siblin_discount VARCHAR(100),
 student_id INT NOT NULL
);

ALTER TABLE student_payments ADD CONSTRAINT PK_student_payments PRIMARY KEY (id);


CREATE TABLE amount_of_lessons_per_month (
 instructor_id INT NOT NULL,
 amount_of_lessons INT,
 amount_of_gp INT,
 amount_of_en INT,
 instructor_payment_id INT NOT NULL
);

ALTER TABLE amount_of_lessons_per_month ADD CONSTRAINT PK_amount_of_lessons_per_month PRIMARY KEY (instructor_id);


CREATE TABLE available_time (
 instructor_id INT NOT NULL,
 time TIMESTAMP(6),
 date DATE
);

ALTER TABLE available_time ADD CONSTRAINT PK_available_time PRIMARY KEY (instructor_id);

CREATE TABLE lestot(
    instructor_id INT NOT NULL,
    datum DATE
    );

CREATE TABLE ensemble (
 id INT NOT NULL,
 level VARCHAR(100),
 genre VARCHAR(100) NOT NULL,
 max_seats INT
)INHERITS(lestot);

ALTER TABLE ensemble ADD CONSTRAINT PK_ensemble PRIMARY KEY (id);


CREATE TABLE group_lesson (
 id INT NOT NULL,
 level VARCHAR(100),
 instrument VARCHAR(100)
)INHERITS(lestot);

ALTER TABLE group_lesson ADD CONSTRAINT PK_group_lesson PRIMARY KEY (id);


CREATE TABLE instrument_renting (
 id INT NOT NULL,
 brand VARCHAR(100),
 is_rented BOOLEAN NOT null, 
 instrument VARCHAR(100),
 price int,
 student_id INT 
);

ALTER TABLE instrument_renting ADD CONSTRAINT PK_instrument_renting PRIMARY KEY (id);

CREATE TABLE instrument_renting_history (
 instrument_renting_id INT NOT NULL,
 return_date DATE,
 student_id INT 
);

ALTER TABLE instrument_renting_history ADD CONSTRAINT FK_instrument_renting_history_0 FOREIGN KEY (instrument_renting_id) REFERENCES instrument_renting(id);


CREATE TABLE lease_time (
 instrument_renting_id INT NOT NULL,
 rented_time TIME(6)
);

ALTER TABLE lease_time ADD CONSTRAINT PK_lease_time PRIMARY KEY (instrument_renting_id);


CREATE TABLE Lesson (
 id INT NOT NULL,
 pay_per_lesson INT,
 undisclosed_timeframe TIME(6),
 unlimited VARCHAR(10),
 instrument VARCHAR(100),
 student_id INT
)INHERITS(lestot);

ALTER TABLE Lesson ADD CONSTRAINT PK_Lesson PRIMARY KEY (id);


CREATE TABLE max_student_enrollment (
 ensemble_id INT NOT NULL,
 max_students_in_en INT NOT NULL
);

ALTER TABLE max_student_enrollment ADD CONSTRAINT PK_max_student_enrollment PRIMARY KEY (ensemble_id);

CREATE TABLE ensemble_students (
 student_id INT NOT NULL,
 ensemble_id INT NOT NULL
);
ALTER TABLE ensemble_students ADD CONSTRAINT FK_ensemble_student_0 FOREIGN KEY (student_id) REFERENCES student (id);
ALTER TABLE ensemble_students ADD CONSTRAINT FK_ensemble_student_1 FOREIGN KEY (ensemble_id) REFERENCES ensemble(id);

CREATE TABLE group_students (
 student_id INT NOT NULL,
 group_lesson_id INT NOT NULL
);

ALTER TABLE group_students ADD CONSTRAINT FK_group_student_0 FOREIGN KEY (student_id) REFERENCES student(id);
ALTER TABLE group_students ADD CONSTRAINT FK_group_student_1 FOREIGN KEY (group_lesson_id) REFERENCES group_lesson(id);

CREATE TABLE min_student_enrollment_ensemble (
 ensemble_id INT NOT NULL,
 min_etudent_enrollment_en INT
);

ALTER TABLE min_student_enrollment_ensemble ADD CONSTRAINT PK_min_student_enrollment_ensemble PRIMARY KEY (ensemble_id);


CREATE TABLE min_student_enrollment_group_lesson (
 group_lesson_id INT NOT NULL,
 min_student_enrollment_gp INT NOT NULL
);

ALTER TABLE min_student_enrollment_group_lesson ADD CONSTRAINT PK_min_student_enrollment_group_lesson PRIMARY KEY (group_lesson_id);


CREATE TABLE siblings (
 student_id INT NOT NULL,
 nr_siblings INT
);

ALTER TABLE siblings ADD CONSTRAINT PK_siblings PRIMARY KEY (student_id);


CREATE TABLE differentInstrument (
 ensemble_id INT NOT NULL,
 instrument VARCHAR(300)
);

ALTER TABLE differentInstrument ADD CONSTRAINT PK_differentInstrument PRIMARY KEY (ensemble_id);


CREATE TABLE discount_amount (
 student_id INT NOT NULL,
 discount INT NOT NULL
);

ALTER TABLE discount_amount ADD CONSTRAINT PK_discount_amount PRIMARY KEY (student_id);


CREATE TABLE fee (
 instrument_renting_id INT NOT NULL,
 price INT
);

ALTER TABLE fee ADD CONSTRAINT PK_fee PRIMARY KEY (instrument_renting_id);


CREATE TABLE name_of_siblings (
 student_id INT NOT NULL
)INHERITS (person);

ALTER TABLE name_of_siblings ADD CONSTRAINT PK_name_of_siblings PRIMARY KEY (student_id);
/*virtuell table, sparas inte på databases, till uppgfiten för annars blev de för många selects, så vi gjorde tavell med
exakt de vi ville ha */

CREATE MATERIALIZED VIEW booked_students AS 
SELECT ensemble_id, count(*) as boked
FROM ensemble_students
group by ensemble_id
order by ensemble_id;



/*ALTER TABLE ContactDetails ADD CONSTRAINT FK_ContactDetails_0 FOREIGN KEY (id) REFERENCES aplication (id);*/


ALTER TABLE instructor_payments ADD CONSTRAINT FK_instructor_payments_0 FOREIGN KEY (instructor_id) REFERENCES Instructor (id);


/*ALTER TABLE room ADD CONSTRAINT FK_room_0 FOREIGN KEY (aplication_id) REFERENCES aplication (id);*/


/*ALTER TABLE student ADD CONSTRAINT FK_student_0 FOREIGN KEY (aplication_id) REFERENCES aplication (id);*/


ALTER TABLE student_payments ADD CONSTRAINT FK_student_payments_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE amount_of_lessons_per_month ADD CONSTRAINT FK_amount_of_lessons_per_month_0 FOREIGN KEY (instructor_id) REFERENCES Instructor (id);
ALTER TABLE amount_of_lessons_per_month ADD CONSTRAINT FK_amount_of_lessons_per_month_1 FOREIGN KEY (instructor_payment_id) REFERENCES instructor_payments (id);


ALTER TABLE available_time ADD CONSTRAINT FK_available_time_0 FOREIGN KEY (instructor_id) REFERENCES Instructor (id);


ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_0 FOREIGN KEY (instructor_id) REFERENCES Instructor (id);
--ALTER TABLE ensemble ADD CONSTRAINT FK_ensemble_1 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_0 FOREIGN KEY (instructor_id) REFERENCES Instructor (id);
--ALTER TABLE group_lesson ADD CONSTRAINT FK_group_lesson_1 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE instrument_renting ADD CONSTRAINT FK_instrument_renting_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE lease_time ADD CONSTRAINT FK_lease_time_0 FOREIGN KEY (instrument_renting_id) REFERENCES instrument_renting (id);


ALTER TABLE Lesson ADD CONSTRAINT FK_Lesson_0 FOREIGN KEY (instructor_id) REFERENCES Instructor (id);
ALTER TABLE Lesson ADD CONSTRAINT FK_Lesson_1 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE max_student_enrollment ADD CONSTRAINT FK_max_student_enrollment_0 FOREIGN KEY (ensemble_id) REFERENCES ensemble (id);


ALTER TABLE min_student_enrollment_ensemble ADD CONSTRAINT FK_min_student_enrollment_ensemble_0 FOREIGN KEY (ensemble_id) REFERENCES ensemble (id);


ALTER TABLE min_student_enrollment_group_lesson ADD CONSTRAINT FK_min_student_enrollment_group_lesson_0 FOREIGN KEY (group_lesson_id) REFERENCES group_lesson (id);


ALTER TABLE siblings ADD CONSTRAINT FK_siblings_0 FOREIGN KEY (student_id) REFERENCES student (id);


ALTER TABLE differentInstrument ADD CONSTRAINT FK_differentInstrument_0 FOREIGN KEY (ensemble_id) REFERENCES ensemble (id);


ALTER TABLE discount_amount ADD CONSTRAINT FK_discount_amount_0 FOREIGN KEY (student_id) REFERENCES siblings (student_id);


ALTER TABLE fee ADD CONSTRAINT FK_fee_0 FOREIGN KEY (instrument_renting_id) REFERENCES instrument_renting (id);


ALTER TABLE name_of_siblings ADD CONSTRAINT FK_name_of_siblings_0 FOREIGN KEY (student_id) REFERENCES siblings (student_id);

/*
insert into student (personal_number, first_name, last_name, age, street, zip, city, id, main_instrument, total_lessons, aplication_id, total_ensembles, total_group_lessons) values ('608336704864', 'Sher', 'Rawsen', 9, '19 Scoville Hill', '3', 'Longgang', '3372', null, 1, '2213', 0, 0);
insert into student (personal_number, first_name, last_name, age, street, zip, city, id, main_instrument, total_lessons, aplication_id, total_ensembles, total_group_lessons) values ('165487277245', 'Elihu', 'Milburn', 29, '72462 Anthes Avenue', '6', 'Sukkozero', '3902', null, 2, '1260', 0, 0);
insert into student (personal_number, first_name, last_name, age, street, zip, city, id, main_instrument, total_lessons, aplication_id, total_ensembles, total_group_lessons) values ('774429691466', 'Allie', 'Nancekivell', 14, '82910 David Court', '193', 'Petaling Jaya', '1082', null, 1, '6065', 0, 0);
insert into student (personal_number, first_name, last_name, age, street, zip, city, id, main_instrument, total_lessons, aplication_id, total_ensembles, total_group_lessons) values ('828944401352', 'Vin', 'Muneely', 19, '38 Porter Center', '33837', 'Lukou', '8631', null, 1, '0948', 2, 1);
insert into student (personal_number, first_name, last_name, age, street, zip, city, id, main_instrument, total_lessons, aplication_id, total_ensembles, total_group_lessons) values ('859800086312', 'Elsinore', 'Van Hesteren', 28, '7364 Eliot Street', '8502', 'Gaocun', '7491', null, 2, '3854', 1, 1);

insert into instrument_renting(id,brand,is_rented,instrument,price,student_id) values ('1','yamaha',TRUE, 'piano',1200,'3372');
insert into instrument_renting(id,brand,is_rented,instrument,price,student_id) values ('2','pioner',TRUE, 'gitar',400,'3902');  --3902
insert into instrument_renting(id,brand,is_rented,instrument,price,student_id) values ('3','Arvada',FALSE, 'fiol',600,null);





insert into instructor (personal_number, first_name, last_name, age, id, street, zip, city, can_teach_ensemble) values ('997137283954', 'Beverlee', 'Gritsaev', 51, '2482', '20364 Spaight Place', '8164', 'Sanankerto', false);
insert into instructor (personal_number, first_name, last_name, age, id, street, zip, city, can_teach_ensemble) values ('405608868629', 'Ivory', 'Habbema', 26, '9367', '611 Hooker Road', '89', 'Huanshan', true);

insert into lesson (id, instructor_id, student_id, instrument, datum) values ('1',  '2482', '3372', 'piano', '2022-01-07');
insert into lesson (id, instructor_id, student_id, instrument, datum) values ('2',  '2482', '3902', 'piano', '2021-02-02');
insert into lesson (id, instructor_id, student_id, instrument, datum) values ('3',  '2482', '3902', 'piano', '2021-03-12');
insert into lesson (id, instructor_id, student_id, instrument, datum) values ('4', '2482', '1082', 'piano', '2021-04-18');
insert into lesson (id, instructor_id, student_id, instrument, datum) values ('5',  '9367', '8631', 'piano', '2021-06-09');
insert into lesson (id, instructor_id, student_id, instrument, datum) values ('6',  '9367', '7491', 'piano', '2021-10-10');
insert into lesson (id, instructor_id, student_id, instrument, datum) values ('7', '9367', '7491', 'piano', '2021-12-05');

insert into ensemble (id, level, genre, instructor_id, datum, max_seats) values ('3363', 'Advanced', 'gospel band', '9367', '2021-03-07', '1');
insert into ensemble (id, level, genre, instructor_id, datum, max_seats) values ('0126', 'Beginner', 'punk rock', '9367', '2022-01-20', '2');
insert into ensemble (id, level, genre, instructor_id, datum, max_seats) values ('6590', 'Intermediate', 'punk rock', '9367', '2021-05-07', '5');

insert into ensemble_students(student_id, ensemble_id) values ('7491','0126');
insert into ensemble_students(student_id, ensemble_id) values ('8631','3363');
insert into ensemble_students(student_id, ensemble_id) values ('8631','6590');


insert into group_lesson (id, level, instructor_id, datum) values ('1', 'Beginner', '2482', '2021-02-07');
insert into group_lesson (id, level, instructor_id, datum) values ('2', 'Advanced', '9367', '2021-04-07');

insert into group_students(student_id, group_lesson_id) values ('8631','1');
insert into group_students(student_id, group_lesson_id) values ('7491','2');
*/
-- UPDATE lesson SET instrument = 'piano';


-- quiry till instrumetn 
--select * from instrument_renting where is_rented = TRUE and instrument = 'piano';


/*
CREATE TABLE instrument_renting (
 id INT NOT NULL,
 brand VARCHAR(100),
 is_rented BOOLEAN NOT null, 
 instrument VARCHAR(100),
 price int,
 student_id INT 
);

*/