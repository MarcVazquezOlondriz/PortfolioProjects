
---- CLEANING AIRBNB DATA FROM MADRID------------

---DATA CLEANING ---

-- Change date of last review to drop hours/minutes/seconds

select last_review, convert(date, last_review)
from PortfolioSQL..Airbnb

alter table Airbnb
add last_review_converted Date

update PortfolioSQL..Airbnb
set last_review_converted=convert(date, last_review)

select last_review_converted from PortfolioSQL..Airbnb

alter table Airbnb
drop column last_review
-------------------------------------------

-- Fixing character problems in the neighbourhood columns (� always appears in tilded words and other special characters)

-- Checking which characters give problems

select distinct neighbourhood
from PortfolioSQL..Airbnb
where neighbourhood like '%�%'

-- Fixing the problems
update PortfolioSQL..Airbnb
set neighbourhood = replace(neighbourhood, 'ü', '�');

update PortfolioSQL..Airbnb
set neighbourhood = replace(neighbourhood, 'á', '�');

update PortfolioSQL..Airbnb
set neighbourhood = replace(neighbourhood, 'ó', '�');

update PortfolioSQL..Airbnb
set neighbourhood = replace(neighbourhood, 'é', '�');

update PortfolioSQL..Airbnb
set neighbourhood = replace(neighbourhood, 'ñ', '�');

update PortfolioSQL..Airbnb
set neighbourhood = replace(neighbourhood, 'ú', '�');

update PortfolioSQL..Airbnb
set neighbourhood = replace(neighbourhood, 'í', '�')

--Checking if it worked
select distinct neighbourhood
from PortfolioSQL..Airbnb

-------------------------


-- Repeating the same procedure for neighbourhood_group
select distinct neighbourhood_group
from PortfolioSQL..Airbnb
where neighbourhood_group like '%�%'

update PortfolioSQL..Airbnb
set neighbourhood_group = replace(neighbourhood_group, 'á', '�');

update PortfolioSQL..Airbnb
set neighbourhood_group = replace(neighbourhood_group, 'í', '�')

select distinct neighbourhood_group
from PortfolioSQL..Airbnb


-- Setting NULL reviews_per_month equal to 0

-- Checking that all NULL values are 'correct'(i.e. that correspond only to rooms where number_of_reviews is 0)

select distinct number_of_reviews, reviews_per_month
from PortfolioSQL..Airbnb
where reviews_per_month is null

-- Changing the values

update PortfolioSQL..Airbnb
set reviews_per_month = 0
where number_of_reviews = 0

-- Checking if it worked
select reviews_per_month
from PortfolioSQL..Airbnb
where reviews_per_month is null

-------------------

-- Checking for duplicates
select count(id) as NumberRows, count(distinct id) as DistinctIds
from PortfolioSQL..Airbnb


--- END OF DATA CLEANING ---
