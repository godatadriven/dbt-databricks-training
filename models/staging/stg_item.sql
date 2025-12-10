select
    id as item_id,
    order_id,
    sku
from {{ source('dbt_training_marijn', 'raw_items') }}