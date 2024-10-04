use olist;

# KPI 1 : Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select 
case when dayofweek(str_to_date(o.order_purchase_timestamp, '%Y-%m-%d'))
	in(1,7) then 'weekend' else'weekday' end as Daytype,
	count(distinct o.order_id) as TotalOrders,
    concat(round(sum(p.payment_value)/1000000 , 2), 'M') as TotalPayments,
    round(avg(p.payment_value)) as AveragePayment
from
	olist_order_dataset as o
join olist_order_payments_dataset as p on o.order_id = p.ï»¿order_id
group by Daytype;

# KPI 2 Number of Orders with review score 5 and payment type as credit card.

SELECT 
    rev.review_score,
    pmt.payment_type,
    COUNT(rev.order_id) AS Total_Orders
FROM 
    olist_order_payments_dataset AS pmt 
INNER JOIN 
    olist_order_reviews_dataset AS rev ON pmt.ï»¿order_id = rev.order_id
WHERE 
    rev.review_score = 5
    AND pmt.payment_type = 'credit_card'
GROUP BY
    rev.review_score,
    pmt.payment_type;

# KPI 3 Average number of days taken for order_delivered_customer_date for pet_shop
#not done

select product_category_name,
	round(avg(datediff(order_delivered_carrier_date,order_purchase_timestamp))) as avg_delivery_day
from olist_orders_dataset as o inner join olist_order_items_dataset as i
on o.order_id = i.ï»¿order_id
inner join olist_products_dataset as p on i.product_id = p.product_id
where product_category_name = 'pet_shop';
 
# KPI 4 Average price and payment values from customers of sao paulo city

select
ROUND(AVG(i.price)) as Avg_price,
round(avg(payment_value)) as avg_payment
from olist_customers_dataset as c
join olist_orders_dataset as o on c.ï»¿customer_id = o.ï»¿customer_id
join olist_order_items_dataset as i on o.order_id = i.ï»¿order_id
join olist_order_payments_dataset as p on o.order_id = p.ï»¿order_id
where c.city = 'sao paulo';


 
# KPI 5 Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.
#not completed

SELECT 
    r.review_score,
    ROUND(AVG(DATEDIFF(DATE(order_delivered), DATE(order_purchase_timestamp)))) AS Shippingdays
FROM 
    olist_orders_dataset AS o
INNER JOIN 
    olist_order_reviews_dataset AS r ON o.order_id = r.order_id
GROUP BY 
    r.review_score
ORDER BY 
    r.review_score;
