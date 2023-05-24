-- DIVIDING DATA ON BASIS OF COMMUNITY BLOCK CODE
SELECT * FROM dbo.rudrapryagmain;
SELECT * FROM dbo.marginal1;
SELECT * FROM dbo.mainworker;

select count(distinct(name)) from dbo.rudrapryagmain;

--GHOST VILLAGES OF RUDRYAPRAYAG

select name from dbo.rudrapryagmain where Total_Population_Person=0; 

--TOP 1O VILLAGES WITH MAX POPULATION
select top(10)* from dbo.rudrapryagmain order by Total_Population_Person desc;

--MEMBERS IN EACH HOUSE
select No_of_Households,name, Total_Population_Person,(Total_Population_Person /No_of_Households) AS predicted_members_of_house
from dbo.rudrapryagmain WHERE Total_Population_Person>0 order by Total_Population_Person desc;

--TOP 10 VILLAGES WITH HIGH LITERACY RATE
select  top(10) Literates_Population_Person,name,Total_Population_Person ,( Total_Population_Person - Literates_Population_Person - Population_in_the_age_group_0_6_person)
AS ILLITERATE_POPULATION 
from dbo.rudrapryagmain   order by Literates_Population_Person desc;

--TOP 10 VILLAGES WITH MAXIMUM POPULATION WORKING
select top(10)  Total_Population_Person,Total_Worker_Population_Person , name,(Total_Population_Person-Total_Worker_Population_Person -Population_in_the_age_group_0_6_Person)
AS NON_WORKING_POP 
from dbo.rudrapryagmain order by Total_Worker_Population_Person desc;

--TOTAL LITERATE FEMALE POPULATION VS WORKING FEMALE POPULATION
select Literates_Population_Female , name, Total_Worker_Population_Female ,(Literates_Population_Female - Total_Worker_Population_Female) 
as Non_Working_Literate_Females from dbo.rudrapryagmain order by  Literates_Population_Female desc;

--TOTAL WORKING POPULATION IN EACH CD BLOCK

select CD_Block_Code,count(total_worker_population_person) as No_Of_Household_Blockwise from dbo.rudrapryagmain group by CD_Block_Code;

--PERCENTAGE OF SC  WOMEN

select  scheduled_castes_population_person,name ,scheduled_castes_population_female,
(convert(float,[scheduled_castes_population_female]) *100/convert(float,[scheduled_castes_population_person])) as
SC_FEMALE_WORKER_PERCENT from dbo.rudrapryagmain where scheduled_castes_population_person>0 order by SC_FEMALE_WORKER_PERCENT desc;

--PERCENTAGE OF  ST WOMEN

select top(25) scheduled_tribes_population_person,name ,scheduled_tribes_population_female,(scheduled_tribes_population_female *100/scheduled_tribes_population_person) as 
ST_FEMALE_WORKER_PERCENT from dbo.rudrapryagmain where scheduled_tribes_population_person>0 order by ST_FEMALE_WORKER_PERCENT desc;

--PERCENTAGE DISTRIBUTION OF MAIN WORKING POPULATION IN DIFFRENT SECTORS
select name,(convert(float,[main_cultivator_population_person] *100)/convert(float,[Main_Working_Population_Person] )) as MAIN_CULTIVATOR_PERCENT,
(convert(float,[Main_agricultural_labourers_population_person] *100)/convert(float,[Main_Working_Population_Person]) ) as MAIN_AGRO_LABOURS_PERCENT,
(convert(float,[main_household_industries_population_person]*100)/convert(float,[Main_Working_Population_Person])) as MAIN_HOUSEHOLD_INDUSTRIES_PERCENT,
(convert(float,[main_other_workers_population_person] *100)/convert(float,[Main_Working_Population_Person]) ) as MAIN_OTHER_WORKERS_PERCENT FROM dbo.mainworker where Main_Working_Population_Person>0;

--TOTAL NUMBER OF MEN AND WOMEN IN DIFFRENT SECTORS
select sum(main_working_population_person) as tot_main_work,sum(main_cultivator_population_person) as tot_main_cultivators,
sum(Main_agricultural_labourers_population_person) as tot_agricultural_labours,sum(main_household_industries_population_person)as tot_household_workers,
sum(main_other_workers_population_person)as tot_other_workers from dbo.mainworker;

--MAIN WORKING POPULATION PERCENT WITH RESPECT TO TOTAL WORKING POPULATION
select r.Name, r.level,convert(float,(e.Main_Working_Population_Person)*100)/convert(float,(r.Total_Population_Person)) as PERCENT_MAIN_WORKER ,
convert(float,(e.Main_agricultural_labourers_population_person)*100)/convert(float,(r.Total_Population_Person)) as PERCENT_AGRO_WORKER,
convert(float,(e.main_household_industries_population_person)*100)/convert(float,(r.Total_Population_Person)) as PERCENT_HOUSEHOLD_INDUSTRIES_WORKER,
convert(float,(e.main_other_workers_population_person)*100)/convert(float,(r.Total_Population_Person)) as PERCENT_OTHER_WORKER,
convert(float,(e.main_cultivator_population_person)*100)/convert(float,(r.Total_Population_Person)) as PERCENT_CULTIVATOR
from dbo.mainworker e
join dbo.rudrapryagmain  r on e.Town_Village_Code=r.Town_Village_Code where r.Total_Population_Person>0;


--PLACES WHERE THERE IS NO MARGINAL WORKER PRESENT

select * from dbo.marginal1 where Marginal_Worker_Population_Person=0;
select sum(Marginal_worker_population_female) as total_marginal_working_female from dbo.marginal1;

--PLACES WHERE THERE ARE MORE FEMALE WORKERS THEN MALE
select Name,Marginal_worker_population_male,Marginal_worker_population_female,Marginal_worker_population_Person 
from dbo.marginal1 where Marginal_worker_population_female>Marginal_worker_population_male;

--MARGINAL FEMALE AND MALE POPULATION CHECK IN AGRICULTURE SECTOR

select sum(Marginal_Cultivator_Population_Male) as MARGINAL_CULTIVATOR_MALE,sum(Marginal_Cultivator_Population_feMale) as MARGINAL_CULTIVATOR_FEMALE,
sum(Marginal_Agriculture_Labourers_Population_Male) as MARGINAL_AGRICULTURAL_MALE,sum(Marginal_Agriculture_Labourers_Population_Female) as MARGINAL_AGRICULTURAL_FEMALE
from dbo.marginal1;

--TOTAL NUMBER OF KIDS AGED 3-6 WORKING MARGINALY
Select sum(marginal_worker_population_3_6_person) as WORKING_CHILDREN from dbo.marginal1;
