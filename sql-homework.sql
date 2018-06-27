use sakila;

set sql_safe_updates = 0;

-- 1a
select first_name, last_name
from actor;

-- 1b
select upper(concat(first_name,' ',last_name)) as 'Actor Name'
from actor;

-- 2a
select actor_id, first_name, last_name from actor
where first_name = 'Joe';

-- 2b
select first_name, last_name from actor
where last_name like '%gen%';

-- 2c
select first_name, last_name from actor
where last_name like '%li%'
order by last_name, first_name;

-- 2d
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
alter table actor 
add column middle_name varchar(25) after first_name;

-- 3b
alter table actor
change column middle_name middle_name blob;

-- 3d
alter table actor
drop column middle_name;

-- 4a
select distinct last_name, count(last_name)
from actor
group by last_name;

-- 4b
select distinct last_name, count(last_name)
from actor
group by last_name
having count(last_name) > 1;

-- 4c
update actor set first_name = 'Harpo'
where first_name = 'Groucho' and last_name = 'Williams';

-- 4d
update actor 
set first_name = 
if(first_name = 'Harpo', 'Groucho', 'Mucho Groucho')
where actor_id in
(
	select * from
    (
		select actor_id
		from actor
		where first_name = 'Harpo' or first_name = 'Groucho' and last_name = 'Williams'
	) as ID
);

-- 5a
show create table address;

-- 6a
select first_name, last_name, address
from staff s
inner join address a
on s.address_id = a.address_id;

-- 6b
select first_name, last_name, sum(amount) as 'Total Payment'
from payment p
join staff s
on p.staff_id = s.staff_id
where payment_date like '2005-08%'
group by last_name;

-- 6c
select title, count(actor_id) as 'Number of Actors'
from film
inner join film_actor
on film.film_id = film_actor.film_id
group by title;

-- 6d
select count(film_id) as 'Copies of Hunchback Impossible'
from inventory
where film_id in
(
	select film_id
    from film
    where title = 'Hunchback Impossible'
);

-- 6e
select first_name, last_name, sum(amount) as 'Total Payment'
from customer c
join payment p
on c.customer_id = p.customer_id
group by last_name;

-- 7a
select title
from film
where language_id in
(
	select language_id
    from language
    where name = 'English'
)
and title like 'K%' or title like 'Q%';

-- 7b
select first_name, last_name
from actor
where actor_id in
(
	select actor_id
    from film_actor
    where film_id in
    (
		select film_id
        from film
        where title = 'Alone Trip'
	)
);

-- 7c
select first_name, last_name, email
from customer c
join address a
on c.address_id = a.address_id
join city
on a.city_id = city.city_id
join country
on city.country_id = country.country_id
where country = 'Canada';

-- 7d
select title
from film
where film_id in
(
	select film_id
    from film_category
    where category_id in
    (
		select category_id
        from category
        where name = 'Family'
	)
);

-- 7e
select title, count(title) as 'Times Rented'
from film f
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id
group by i.film_id
order by count(title) desc;

-- 7f

select store_id, sum(amount) as 'Total Sales'
from payment p
join store
on p.staff_id = store.manager_staff_id
group by store_id;

-- 7g
select store_id, city, country
from store s
join address a
on s.address_id = a.address_id
join city
on a.city_id = city.city_id
join country
on city.country_id = country.country_id;

-- 7h/8a
drop view if exists top_five_genres;

create view top_five_genres as
select name, sum(amount) as 'Total Revenue'
from category c
join film_category f
on c.category_id = f.category_id
join inventory i
on i.film_id = f.film_id
join rental r
on i.inventory_id = r.inventory_id
join payment p
on r.rental_id = p.rental_id
group by name
order by sum(amount) desc
limit 5;

-- 8b
select * from top_five_genres;

-- 8c
drop view top_five_genres;

set sql_safe_updates = 1;











