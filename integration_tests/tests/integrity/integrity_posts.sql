
{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set metrics = [
    'carousel_album_engagement',
    'carousel_album_reach',
    'carousel_album_saved',
    'carousel_album_shares',
    'carousel_album_views',
    'comment_count',
    'like_count',
    'story_exits',
    'story_reach',
    'story_replies',
    'story_taps_back',
    'story_taps_forward',
    'story_shares',
    'story_views',
    'video_photo_engagement',
    'video_photo_reach',
    'video_photo_saved',
    'video_photo_shares',
    'video_photo_views',
    'reel_comments',
    'reel_likes',
    'reel_reach',
    'reel_shares',
    'reel_total_interactions',
    'reel_views'
] %}

with staging as (
    select
        {% for metric in metrics %}
            sum({{ metric }}) as staging_sum_{{ metric }}{{ ','  if not loop.last }}
        {% endfor %}
    from {{ target.schema }}_instagram_business_dev.stg_instagram_business__media_insights
    where is_most_recent_record
),

transform as (
    select
        {% for metric in metrics %}
            sum({{ metric }}) as transform_sum_{{ metric }}{{ ','  if not loop.last }}
        {% endfor %}
    from {{ target.schema }}_instagram_business_dev.instagram_business__posts
),

select *
from staging
full join transform

where 
{% for metric in metrics %}
    staging_sum_{{ metric }} != transform_sum_{{ metric }}
    {{ 'or' if not loop.last }}
{% endfor %}