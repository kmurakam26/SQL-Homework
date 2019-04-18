/* 1a. Display the first and last names of all actors from the table `actor`.*/
use sakila;
select first_name, last_name
from actor;

/** 1b. Display the first and last name of each actor in a single column in upper 
case letters. Name the column `Actor Name`.*/
SET SQL_SAFE_UPDATES = 0;
select *, concat(first_name, ' ', last_name) as full_name
from actor;

SELECT * FROM ACTOR;

/** 2a. You need to find the ID number, first name, and last name of an actor, 
of whom you know only the first name, "Joe." What is one query would you use to obtain this information?*/

select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

/* 2b. Find all actors whose last name contain the letters `GEN`:*/
select first_name, last_name
from actor
where last_name like '%GEN%';

/** 2c. Find all actors whose last names contain the letters `LI`. 
This time, order the rows by last name and first name, in that order:*/

select first_name, last_name
from actor
where last_name like '%LI%'
ORDER BY last_name asc,
first_name asc;

/** 2d. Using `IN`, display the `country_id` and `country` columns of the 
following countries: Afghanistan, Bangladesh, and China:*/

select country_id, country
from country
where country IN ('Afghanistan', 'Bangladesh', 'China');

/** 3a. You want to keep a description of each actor. You don't think you will 
be performing queries on a description, so create a column in the table `actor` 
named `description` and use the data type `BLOB` (Make sure to research the type 
`BLOB`, as the difference between it and `VARCHAR` are significant).*/

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE actor
ADD COLUMN description blob(110);


/* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
Delete the `description` column.*/

alter table actor
drop description;

select *
from actor;

/* 4a. List the last names of actors, as well as how many actors have that last name.*/

select last_name, count(last_name)
from actor
group by last_name
order by count(last_name) desc;


/* 4b. List last names of actors and the number of actors who have that last name, but only 
for names that are shared by at least two actors*/

select last_name, count(last_name)
from actor
group by last_name
having count(last_name) > 1
order by count(last_name) desc;


/* 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. 
Write a query to fix the record.*/

select *
from actor
where first_name = 'GROUCHO';
UPDATE actor 
set first_name = 'HARPO'
where actor_id = 172;

SELECT * FROM actor
where actor_id = 172;

/* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the 
correct name after all! In a single query, if the first name of the actor is currently `HARPO`, 
change it to `GROUCHO`.*/

UPDATE actor 
set first_name = 'GROUCHO'
where actor_id = 172;

  describe address;
/** 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?*/

  describe address;
  
/*CREATE TABLE address (
  address_id int(11) NOT NULL AUTO_INCREMENT,
  address char(60) DEFAULT NULL,
  address2 char(60) DEFAULT NULL,
  district char(60) DEFAULT NULL,
  FOREIGN KEY (city_id) REFERENCES city(id),
  postal_code INTEGER(50),
  phone INTEGER(50),
  location char(50) DEFAULT NULL,
  last_update VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (address_id) */
  
/* 6a. Use `JOIN` to display the first and last names, as well as the address, 
of each staff member. Use the tables `staff` and `address`:*/

select a.first_name, a.last_name, b.address
from staff a
join address b
on a.address_id=b.address_id;


/* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. 
Use tables `staff` and `payment`.*/

select distinct  sum(b.amount) as Total, a.first_name, a.last_name
from staff a
join payment b
on a.staff_id=b.staff_id
where b.payment_date like '%2005-08%'
group by a.first_name, a.last_name;


select payment_date
from payment
where payment_date like '%2005-08%';


/* 6c. List each film and the number of actors who are listed for that film. 
Use tables `film_actor` and `film`. Use inner join.*/

select count(a.actor_id) as Actors, b.title
from film_actor a
inner join film b
on a.film_id=b.film_id
group by b.title
order by Actors desc;

/* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?*/
select count(a.inventory_id)
from inventory a
join film b
on a.film_id=b.film_id
where b.title = `HUNCHBACK IMPOSSIBLE`
group by b.title;

select distinct title
from film
WHERE TITLE = 'HUNCHBACK IMPOSSIBLE'
order by title desc;


/* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. 
List the customers alphabetically by last name:*/

select sum(a.amount) Amount, b.first_name, b.last_name, b.customer_id
from payment a
join customer b
on a.customer_id=b.customer_id
group by b.customer_id
order by b.last_name desc;

/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.*/
/*film, language*/

select title
from film
where title like 'K%'
or title like 'Q%'
and language_id IN 
(
  select language_id
  from language
  where name = 'English'
  );
  

/* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.*/

select first_name, last_name
from actor
where actor_id IN 
(
  select actor_id 
  from film_actor
  where film_id IN
  (
    select film_id
    from film
    where title = 'Alone Trip'
  )
)
;

/* 7c. You want to run an email marketing campaign in Canada, for which you will need the 
names and email addresses of all Canadian customers. Use joins to retrieve this information.*/

select email
from customer
where address_id IN
  (
  select address_id
  from address
  where city_id in
    (
    SELECT city_id
    from city
    where country_id in
      (
      select country_id
      from country
      where country = 'Canada'
      )
	)
  );
  


/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as _family_ films.*/

select title
from film
where film_id in
  (
  select film_id
  from film_category
  where category_id IN
    (
    select category_id
    from category
    where name = 'Family'
    )
  )
;


/* 7e. Display the most frequently rented movies in descending order.*/

select a.title as Title, count(c.rental_id) as Times_Rented
from film a
join inventory b
on a.film_id=b.film_id
join rental c
on b.inventory_id=c.inventory_id
group by title;


/* 7f. Write a query to display how much business, in dollars, each store brought in.*/

select a.store_id as Store, sum(c.amount) as Total_Business
from store a
join customer b
on a.store_id=b.store_id
join payment c
on b.customer_id=c.customer_id
group by a.store_id;

/* 7g. Write a query to display for each store its store ID, city, and country.*/

select a.store_id as Store, c.city, d.country
from store a
join address b
on a.address_id=b.address_id
join city c
on b.city_id=c.city_id
join country d
on c.country_id=d.country_id
group by a.store_id;

/* 7h. List the top five genres in gross revenue in descending order. 
(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/

select a.name as Category, sum(e.amount) as Revenue
from category a
join film_category b
on a.category_id=b.category_id
join inventory c
on b.film_id=c.film_id
join rental d
on c.inventory_id=d.inventory_id
join payment e
on d.rental_id=e.rental_id
group by a.name
order by Revenue desc
limit 5;

/* 8a. In your new role as an executive, you would like to have an easy way of viewing the 
Top five genres by gross revenue. Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view.*/

CREATE VIEW REVENUE
 as select a.name as Category, sum(e.amount) as Revenue
from category a
join film_category b
on a.category_id=b.category_id
join inventory c
on b.film_id=c.film_id
join rental d
on c.inventory_id=d.inventory_id
join payment e
on d.rental_id=e.rental_id
group by a.name
order by Revenue desc
limit 5;


/* 8b. How would you display the view that you created in 8a?*/
SELECT * FROM REVENUE;

/* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.*/
DROP VIEW REVENUE;











