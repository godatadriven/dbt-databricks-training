with

int_enriched_order as (select * from {{ ref('int_enriched_order') }})

select
    customer_id,
    customer_name,
    min(ordered_at) as min_order_date,
    max(ordered_at) as max_order_date,
    count(distinct order_id) as total_orders,
    sum(order_total) as total_revenue
from int_enriched_order
group by customer_id, customer_name