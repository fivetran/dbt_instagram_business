{% if var('instagram_business_union_schemas', []) | length > 0 or var('instagram_business_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='media_insights', 
        database_variable='instagram_business_database', 
        schema_variable='instagram_business_schema', 
        default_database=target.database,
        default_schema='instagram_business_pages',
        default_variable='media_insights',
        union_schema_variable='instagram_business_union_schemas',
        union_database_variable='instagram_business_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='instagram_business_sources',
        single_source_name='instagram_business',
        single_table_name='media_insights'
    )
}}

{% endif %}