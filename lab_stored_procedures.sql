-- Lab | Stored procedures

/* In the previous lab we wrote a query to find first name, last name, and emails of all the customers 
who rented Action movies. Convert the query into a simple stored procedure. Use the following query:
*/
use sakila;
select first_name, last_name, email
from customer
join rental on customer.customer_id = rental.customer_id
join inventory on rental.inventory_id = inventory.inventory_id
join film on film.film_id = inventory.film_id
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
where category.name = "Action"
group by first_name, last_name, email;

DELIMITER //
create procedure procedure1 ()
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action" 
  group by first_name, last_name, email;
end //
DELIMITER ;
call procedure1();
drop procedure if exists procedure1;

/* 
Now keep working on the previous stored procedure to make it more dynamic. Update the stored 
procedure in a such manner that it can take a string argument for the category name and return 
the results for all customers that rented movie of that category/genre. For eg., it could be 
action, animation, children, classics, etc.
*/ 

DELIMITER //
create procedure procedure2 (in param1 varchar(100))
begin
  select first_name, last_name, email, category.name
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name COLLATE utf8mb4_general_ci = param1
  group by first_name, last_name, email, name;
end //
DELIMITER ;

call procedure2("Action");
drop procedure if exists procedure2;

/*
Write a query to check the number of movies released in each movie category. Convert the query 
in to a stored procedure to filter only those categories that have movies released greater than
a certain number. Pass that number as an argument in the stored procedure.
*/

select count(film.film_id), category.name from film
join film_category on film_category.film_id = film.film_id
join category on category.category_id = film_category.category_id
group by category.name
having count(film.film_id) > 68
order by count(film.film_id) desc;


DELIMITER //
create procedure procedure3 (in param3 int)
begin
  select count(film.film_id) as number_of_movies, category.name from film
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  group by category.name
  having count(film.film_id) > param3
  order by count(film.film_id) desc
  ;
end //
DELIMITER ;

call procedure3 (68) ;
drop procedure if exists procedure3;
