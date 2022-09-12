-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/b28Rab
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" TEXT   NOT NULL,
    "dept_name" TEXT   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" TEXT   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" TEXT   NOT NULL,
    "emp_no" INTEGER   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title" TEXT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" TEXT   NOT NULL,
    "last_name" TEXT   NOT NULL,
    "sex" TEXT   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL
);

CREATE TABLE "titles" (
    "title_id" TEXT   NOT NULL,
    "title" TEXT   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title" FOREIGN KEY("emp_title")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Alter the date format
ALTER DATABASE employee_db SET datestyle TO "ISO, MDY";

SELECT * FROM "employees";

-- List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex,salaries.salary
FROM "employees"
LEFT JOIN "salaries" ON employees.emp_no = salaries.emp_no
ORDER BY emp_no;

-- List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM "employees"
WHERE DATE_PART('year',hire_date) = 1986;

SELECT * FROM "departments"
SELECT * FROM "dept_manager"
SELECT * FROM "dept_emp"

-- List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT dept_manager.dept_no, employees.emp_no, departments.dept_name , employees.last_name, employees.first_name
FROM "dept_manager"
LEFT JOIN "departments" ON departments.dept_no = dept_manager.dept_no
LEFT JOIN "employees" ON employees.emp_no = dept_manager.emp_no
ORDER BY emp_no;

-- List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name, dept_emp.dept_no
FROM "employees"
INNER JOIN "dept_emp" ON dept_emp.emp_no = employees.emp_no
INNER JOIN "departments" ON departments.dept_no = dept_emp.dept_no
ORDER BY emp_no;

-- List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT * FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE'B%';

-- List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name, dept_emp.dept_no
FROM "employees"
LEFT JOIN "dept_emp" ON dept_emp.emp_no = employees.emp_no
LEFT JOIN "departments" ON departments.dept_no = dept_emp.dept_no
WHERE dept_name = 'Sales';

-- List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name, dept_emp.dept_no
FROM "employees"
LEFT JOIN "dept_emp" ON dept_emp.emp_no = employees.emp_no
LEFT JOIN "departments" ON departments.dept_no = dept_emp.dept_no
WHERE departments.dept_name in ('Sales', 'Development');

-- List the frequency count of employee last names (i.e., how many employees share each last name) in descending order.
SELECT last_name, COUNT(*) AS freq_count
FROM employees
GROUP BY last_name
ORDER BY freq_count DESC;
