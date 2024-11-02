--import data from salary_data.csv--
--Retrievedd all data with select query--
 
select * from salary_emp

-- as we can see, the hrd and sales have a space (not allowed in table structure) --
-- The format of status also inconsistency upper and lower value, as well the column city and state --
-- The phone number format also terible, with unnecessary character --
-- The Addresses is separate by street, city and state. we wan to combine it. --
-- We need age group for job level like Junior, Middle and Senior from age column.--
-- Change the data according to its value--

--## Let's Begin Cleansing the Data ##--

-- Change the data according to its value--
-- Change data type from text to int at phone_no column , change text to date at join_date column, and so on--


--## show the unique value ## --
select distinct (dept) from salary_emp se 

 --## Remove space at first and end the data ##--
update salary_emp
set dept = ltrim(rtrim(dept));

--## replace space in specific value ##--
update salary_emp
set dept = replace(dept,' ','')
where dept = 'H RD' or dept = 'SA LES' 

--## replace multiple space ##--

update salary_emp 
set dept=regexp_replace(dept,'\s+','') 

-- check again with select query--
select * from salary_emp
order by no 

-- There are inconsistency value in Status ( lower and Upper), City and State (Upper) --
-- ## Change Status to Upper value ## --
update salary_emp 
set status = upper(status) 

-- ## Change City and State to Proper value ## --
-- Capitalizes the first letter of each word using INITCAP --
update salary_emp 
set city = initcap(city) 

update salary_emp 
set state = initcap(state) 


-- Combine Street, City, State --
--Add new column (full_Address) for store combined data ##--
alter table salary_emp 
add full_address varchar(100);

--Combinde the column to full_address--
update salary_emp 
set full_address=concat(street,',',city,',',state) 

-- Convert Numerical to Categorical for Age Column--
--add new column for age_group
alter table salary_emp 
add age_group varchar(10)

--convert to category
update salary_emp 
set age_group=
case when age < 25 then 'Junior'
when age between 25 and 35 then 'Middle'
else 'Senior' end

--Check the data --
select * from salary_emp
order by no 

-- Remove Special characters from Phone Number column--
update salary_emp 
set phone_no=regexp_replace(phone_no,'[^0-9]','') 

update salary_emp 
set phone_no = replace (phone_no,'-','')

update salary_emp 
set phone_no = regexp_replace(phone_no,'[^a-zA-Z0-9]','')

-- Extract Year from Join Date Column --
alter table salary_emp 
add join_year int

update salary_emp 
set join_year=EXTRACT(YEAR from join_date); 

-- Change data type to date for Join Date Column (currrently is varchar) --
update salary_emp 
set join_date=to_date(join_date,'MM/DD/YYYY') 

-- Replace Null Value with Default Value --
update salary_emp 
set id_unik = coalesce(id_unik,'NA') 

--Remove Duplicate with using queryand compare with unique or primary key value--

--Check the duplicate values --
select * from salary_emp se
inner join salary_emp se2 
on se."no" = se2."no"  and se.id > se2.id

--delete with using query and where clause--
delete from salary_emp se
using salary_emp se2
where se."no" = se2."no" and se.id > se2.id

--Split full name into first and last name--

alter table salary_emp 
add column first_name varchar(50),
add column last_name varchar(50)

update salary_emp 
set first_name = split_part(full_name,' ',1),
last_name = split_part(full_name,' ',2); 

-- Last Check data --
select * from salary_emp
order by no 

-- awesome, it's seems to be in order for further analysis---
