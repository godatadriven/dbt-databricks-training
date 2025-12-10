with

stg_order as ( select * from {{ ref('stg_order') }} ),
stg_customer as ( select * from {{ ref('stg_customer') }} ),
stg_store as ( select * from {{ ref('stg_store') }} )

select
    o.order_id,
    o.customer_id,
    c.customer_name,
    o.ordered_at,
    o.subtotal,
    o.tax_paid,
    o.order_total,
    o.store_id,
    s.store_name,
    s.store_opened_at,
    s.store_tax_rate
from stg_order as o
left join stg_customer as c
    on o.customer_id = c.customer_id
left join stg_store as s
    on o.store_id = s.store_id
