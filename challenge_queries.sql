SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO ret_titles
FROM current_emp as ce
	INNER JOIN titles as ti
		ON (ce.emp_no = ti.emp_no)
ORDER BY ce.emp_no;

SELECT * FROM ret_titles;

--Partition the data to show only the most recent title for each employee.
-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 to_date,
 title
INTO ret_emp_recent_title
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM ret_titles
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM ret_emp_recent_title;

--Counting the number of employees per title
SELECT COUNT(title), title
INTO retiring_titles_count
FROM ret_emp_recent_title
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles_count;

--Creating a list of employees eligibile for potential mentorship.
SELECT e.emp_no, 
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
INTO mentorship_elig
From employees as e
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
	ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

SELECT * FROM mentorship_elig;

--Partition the data so that the employees only show most recent title (NO DUPLICATES!)
-- Partition the data to show only most recent title per employee
SELECT emp_no,
 first_name,
 last_name,
 birth_date,
 from_date,
 to_date,
 title
INTO ment_elig_empl
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 birth_date,
 from_date,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM mentorship_elig
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM ment_elig_empl;