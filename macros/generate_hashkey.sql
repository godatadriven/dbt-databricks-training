{% macro generate_hashkey(columns) -%}
    md5(concat_ws('||', {{ columns | join(', ') }}))
{%- endmacro %}