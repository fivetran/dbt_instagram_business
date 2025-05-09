{{ config(tags="fivetran_validations", enabled=var('fivetran_validation_tests_enabled', false)) }}

{% set table_name = 'instagram_business__posts' %}

{% if execute and target.type == 'bigquery' %}
-- Find the common columns to use in the comparison. This currently only works for BQ.
{% set common_cols_query %}
    select column_name
    from {{ target.database }}.{{ target.schema }}_instagram_business_prod.INFORMATION_SCHEMA.COLUMNS
    where lower(table_name) = {{ table_name }}

    intersect distinct

    select column_name
    from {{ target.database }}.{{ target.schema }}_instagram_business_dev.INFORMATION_SCHEMA.COLUMNS
    where lower(table_name) = {{ table_name }}
{% endset %}

{% set common_cols = run_query(common_cols_query).columns[0].values() %}
{% set column_list = common_cols | join(', ') %}

{% else %}
{% set column_list = '*' %}
{% endif %}

with prod as (
    select {{ column_list }}
    from {{ target.schema }}_instagram_business_prod.{{ table_name }}
),

dev as (
    select {{ column_list }}
    from {{ target.schema }}_instagram_business_dev.{{ table_name }}
),

prod_not_in_dev as (
    -- rows from prod not found in dev
    select * from prod
    except distinct
    select * from dev
),

dev_not_in_prod as (
    -- rows from dev not found in prod
    select * from dev
    except distinct
    select * from prod
),

final as (
    select
        *,
        'from prod' as source
    from prod_not_in_dev

    union all -- union since we only care if rows are produced

    select
        *,
        'from dev' as source
    from dev_not_in_prod
)

select *
from final