use sakila;
select -- List each pair of actors that have worked together
    a1.actor_id as actor1_id, 
    a1.first_name as actor1_first_name, 
    a1.last_name as actor1_last_name,
    a2.actor_id as actor2_id, 
    a2.first_name as actor2_first_name, 
    a2.last_name as actor2_last_name
from 
    film_actor fa1
join 
    film_actor fa2 on fa1.film_id = fa2.film_id and fa1.actor_id < fa2.actor_id
join 
    actor a1 on fa1.actor_id = a1.actor_id
join 
    actor a2 on fa2.actor_id = a2.actor_id;

with ActorFilmCounts as (
    select 
        fa.film_id, 
        fa.actor_id,
        count(*) as film_count
    from 
        film_actor fa
    group by 
        fa.film_id, 
        fa.actor_id
)

select 
    afc.film_id,
    f.title as film_title,
    a.actor_id,
    a.first_name,
    a.last_name,
    afc.film_count
from 
    ActorFilmCounts afc
join 
    actor a on afc.actor_id = a.actor_id
join 
    film f on afc.film_id = f.film_id
where 
    afc.film_count = (
        select 
            max(film_count) 
        from 
            ActorFilmCounts 
        where 
            film_id = afc.film_id
    );
