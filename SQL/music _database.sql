--Q1: Who is the senior most employee based on job titile?

select * from employee
ORDER BY levels desc
limit 1
--ans-  Madan
--Q2: Which countries have the most invoices?

select COUNT(*) as c, billing_country
from invoice
group by billing_country
order by c desc
ans-USA

--Q3:What are top 3 values of total invoice ?

select total from invoice
order by total desc
limit 3
--ans-23.759,19.8,19.8

--Q4-Which city has best customer ? 
--Returns both the city name and sum of all invoice total

select sum (total) as  invoice_total ,billing_city
from invoice
group by billing_city
order by invoice_total desc
--ans. Prague

--Q5:who is the best customer?

select customer.customer_id, 
customer.first_name ,customer.last_name,
sum (invoice.total)as total
from customer 
JOIN invoice on customer.customer_id=
invoice.customer_id
group by customer.customer_id 
order by total desc
limit 1
--5.Madhav R (144.54)cents 

--SET-2
--Write query to return the email,firstname ,
--last name & genre(rock music listeners) 
select distinct email,first_name,last_name 
from customer 
join invoice on customer.customer_id =invoice.
customer_id
join invoice_line on invoice.invoice_id =
invoice_line.invoice_id
where track_id in (
  select track_id from track
  join genre on track.genre_id=genre.genre_id
  where genre.name LIKE 'Rock'
)
order by email;

--Q2.Artist who have written the most rock music.
--top ten rock bands with artist's name and total count 
select artist.artist_id , artist.name,
count(artist.artist_id) as number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id =album.artist_id 
join genre on genre.genre_id= track.genre_id
where genre.name like 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10;
--Return all the track names that have a song length
--longer than average song lenth(milliseconds)

select name,milliseconds  
from track 
where milliseconds > (
  select avg (milliseconds) as avg_track_length
  from track )
order by milliseconds desc;
--SET-3
--Q1.how much amount spent by each customer on artists?(customer name ,artist name and total spent)
--2
with popular_genre as 
(
    select count (invoice_line.quantity) as 
purchases, customer.country,genre.name,
genre.genre_id,
row_number()over (partition by customer.country
order by count (invoice_line.quantity)desc) as
rowNo
from invoice_line
join invoice on invoice.invoice_id= invoice_line.invoice_id
join customer on customer.customer_id =invoice.customer_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2ASC ,1 desc
)
select * from popular_genre where rowNo <= 1

--3customer that has spent the most on music for each country
with recursive 
  customer_with_country as (
  select customer.customer_id,first_name,last_name,
  billing_country, sum(total) as total_spending 
  from invoice
  join customer on customer.customer_id=
  invoice.customer_id
  group by 1,2,3,4
  order by 1,5 desc),
  
country_max_spending as (
  select billing_country, max (total_spending)
  as max_spending  
  from customer_with_country
  group by billing_country)









