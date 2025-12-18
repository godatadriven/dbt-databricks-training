select
    sku,
    name as product_name,
    type as product_type,
    price as selling_price,
    description as product_description
from {{ source('dbt_training_marijn', 'raw_products') }}