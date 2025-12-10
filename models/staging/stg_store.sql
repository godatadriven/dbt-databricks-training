select
    id as store_id,
    name as store_name,
    opened_at as store_opened_at,
    tax_rate as store_tax_rate
from {{ source('dbt_training_marijn', 'raw_stores') }}