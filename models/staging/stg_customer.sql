select
    id as customer_id,
    name as customer_name,
    {{ generate_hashkey(['id', 'name']) }} as customer_hashkey
from {{ source('dbt_training_marijn', 'raw_customer') }}