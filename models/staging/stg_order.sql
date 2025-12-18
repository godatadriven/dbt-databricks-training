select
    id as order_id,
    customer as customer_id,
    date(ordered_at) as order_date,
    store_id,
    subtotal,
    tax_paid,
    order_total
from {{ source('dbt_training_marijn', 'raw_orders') }}