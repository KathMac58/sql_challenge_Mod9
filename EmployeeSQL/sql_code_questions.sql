
-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/TqUuzK
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "Dept_no" char(30)   NOT NULL,
    "Dept_name" varchar(50)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "Dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "Emp_no" int   NOT NULL,
    "Dept_no" char(30)   NOT NULL
);

CREATE TABLE "dept_manager" (
    "Dept_no" char(30)   NOT NULL,
    "Emp_no" int   NOT NULL
);

CREATE TABLE "employees" (
    "Emp_no" int   NOT NULL,
    "Title_id" char(10)   NOT NULL,
    "Birth_date" date   NOT NULL,
    "First_name" varchar(30)   NOT NULL,
    "Last_name" varchar(30)   NOT NULL,
    "Sex" char(1)   NOT NULL,
    "Hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "Emp_no"
     )
);

CREATE TABLE "salaries" (
    "Emp_no" int   NOT NULL,
    "Salary" int   NOT NULL
);

CREATE TABLE "titles" (
    "Title_id" char(10)   NOT NULL,
    "Title" varchar(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "Title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_Emp_no" FOREIGN KEY("Emp_no")
REFERENCES "employees" ("Emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_Dept_no" FOREIGN KEY("Dept_no")
REFERENCES "departments" ("Dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_Dept_no" FOREIGN KEY("Dept_no")
REFERENCES "departments" ("Dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_Emp_no" FOREIGN KEY("Emp_no")
REFERENCES "employees" ("Emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_Emp_title_id" FOREIGN KEY("Emp_title_id")
REFERENCES "titles" ("Title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_Emp_no" FOREIGN KEY("Emp_no")
REFERENCES "employees" ("Emp_no");


--Question 1: List the employee number, last name, first name, sex, and salary of each employee.
-- Confirm Emp_no column actually exists
SELECT *
FROM information_schema.columns
WHERE table_name = 'employees' OR table_name = 'salaries';

--Join public.employees and public.salaries on Emp_on column 
SELECT e."Emp_no", e."Last_name", e."First_name", e."Sex", s."Salary"
FROM public.employees AS e
JOIN public.salaries AS s ON e."Emp_no" = s."Emp_no";
--Total Rows: 300,024

--

--Question 2: List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT e."Last_name", e."First_name", e."Hire_date"
FROM public.employees AS e
WHERE DATE_PART('year', e."Hire_date") = 1986;

--Question 2: List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT "Last_name", "First_name", "Hire_date"
FROM public.employees 
WHERE EXTRACT(YEAR FROM "Hire_date") = 1986;

--

--Question 3: List the manager of each department along with their department number, department name, employee number, last name, aFROMnd first name.
SELECT m."Dept_no", m."Emp_no", d."Dept_name", e."Last_name", e."First_name"
FROM public.dept_manager AS m
INNER JOIN public.departments AS d ON m."Dept_no" = d."Dept_no"
INNER JOIN public.employees AS e ON m."Emp_no" = e."Emp_no"
--Total Rows: 24

--

--Question 4: List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT de."Dept_no", de."Emp_no", d."Dept_name", e."Last_name", e."First_name"
FROM public.dept_emp AS de
INNER JOIN public.employees AS e ON de."Emp_no" = e."Emp_no"
INNER JOIN public.departments AS d ON de."Dept_no" = d."Dept_no";
--Total Rows: 331,603

--

--Question 5: List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT e."Last_name", e."First_name", e."Sex"
FROM public.employees AS e
WHERE e."First_name" = 'Hercules' AND e."Last_name" LIKE 'B%';
--Total Rows: 20

--

--Question 6: List each employee in the Sales department, including their employee number, last name, and first name.
SELECT e."Emp_no", e."Last_name", e."First_name"
FROM public.employees AS e
INNER JOIN public.dept_emp AS de ON e."Emp_no" = de."Emp_no"
INNER JOIN public.departments AS d ON d."Dept_no" = de."Dept_no"
WHERE d."Dept_name" = 'Sales';
--Total Rows: 52,245

--

--Question 7: List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT d."Dept_name", e."Last_name", e."First_name", e."Emp_no"
FROM public.employees AS e
INNER JOIN public.dept_emp AS de ON e."Emp_no" = de."Emp_no"
INNER JOIN public.departments AS d ON d."Dept_no" = de."Dept_no"
WHERE d."Dept_name" IN ('Sales', 'Development');
--Total Rows: 137,952

--

--Question 8: List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT e."Last_name"
FROM public.employees AS e
GROUP BY e."Last_name"
ORDER BY COUNT(e."Last_name")DESC;
--Total Rows: 1,638

--















