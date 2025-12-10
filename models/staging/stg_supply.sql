select
    {{ generate_hashkey(['id', 'sku'] )}} as supply_identifier,
    id as supply_id,
    name as supply_name,
    cost as supply_cost,
    perishable,
    sku
from {{ source('dbt_training_marijn', 'raw_supplies') }}