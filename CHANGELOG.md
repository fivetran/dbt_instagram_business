# dbt_instagram_business v1.1.0
[PR #26](https://github.com/fivetran/dbt_instagram_business/pull/26) includes the following updates:

## Features
- Increases the required dbt version upper limit to v3.0.0.

# dbt_instagram_business v1.0.0

[PR #23](https://github.com/fivetran/dbt_instagram_business/pull/23) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/instagram_business_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/instagram_business_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/instagram_business_source` package will also need to be removed or updated to reference this package.
  - Update any instagram_business_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_instagram_business/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Removed all `accepted_values` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_instagram_business.yml`.

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_instagram_business v0.3.0
[PR #18](https://github.com/fivetran/dbt_instagram_business/pull/18) includes the following updates.

## Schema Changes  
4 total changes • 0 possible breaking changes  

| Data Model | Change type | Old name | New name | Notes |
|------------|-------------|----------|----------|-------|
| [`instagram_business__posts`](https://fivetran.github.io/dbt_instagram_business/#!/model/model.instagram_business.instagram_business__posts) | New Columns | | `carousel_album_shares`, `carousel_album_views`, `story_shares`, `story_views`, `video_photo_shares`, `video_photo_views`, `reel_views` | |
| [`instagram_business__posts`](https://fivetran.github.io/dbt_instagram_business/#!/model/model.instagram_business.instagram_business__posts) | Deprecated Columns | `carousel_album_impressions`, `carousel_album_video_views`, `story_impressions`, `video_photo_impressions`, `video_views`, `reel_plays` | | Retained for backward compatibility but will be removed in a future release |
| [`stg_instagram_business__media_insights`](https://fivetran.github.io/dbt_instagram_business/#!/model/model.instagram_business_source.stg_instagram_business__media_insights) | New Columns | | `carousel_album_shares`, `carousel_album_views`, `story_shares`, `story_views`, `video_photo_shares`, `video_photo_views`, `reel_views` | |
| [`stg_instagram_business__media_insights`](https://fivetran.github.io/dbt_instagram_business/#!/model/model.instagram_business_source.stg_instagram_business__media_insights) | Deprecated Columns | `carousel_album_impressions`, `carousel_album_video_views`, `story_impressions`, `video_photo_impressions`, `video_views`, `reel_plays` | | Retained for backward compatibility but will be removed in a future release  |

- `*_views` will replace `*_impressions`, but since the metrics are not exactly identical, we’ve kept them separate rather than coalescing them. For more context, see [this decision log entry](https://github.com/fivetran/dbt_social_media_reporting/blob/main/DECISIONLOG.md) from the `dbt_social_media_reporting` rollup package.
  - Note: In the rollup package, we do coalesce `*_views` and `*_impressions` fields to simplify downstream use.

## Updates
- Applied schema changes to align with the [April 2025](https://fivetran.com/docs/connectors/applications/instagram-business/changelog#april2025) and [December 2024](https://fivetran.com/docs/connectors/applications/instagram-business/changelog#december2024) Fivetran connector updates:
    - Deprecated metrics are retained for backward compatibility but will be removed in a future release.
    - Refer to the [Instagram API documentation](https://developers.facebook.com/docs/instagram-platform/reference/instagram-media/insights) for more context on updated fields.

## Documentation
- Added definitions for newly introduced fields.
- Marked deprecated fields accordingly.
- Added Quickstart model counts to README. ([#16](https://github.com/fivetran/dbt_instagram_business/pull/16))
- Corrected references to connectors and connections in the README. ([#16](https://github.com/fivetran/dbt_instagram_business/pull/16))

## Under the Hood
- Expanded seed data with new columns to support testing of recent schema changes.
- Added consistency and integrity tests.

# dbt_instagram_business v0.2.1
[PR #9](https://github.com/fivetran/dbt_instagram_business/pull/9) includes the following updates.

## Feature Updates
- Addition of the following fields and accompanying documentation to the `instagram_business__posts` model:
    - `reel_comments`
    - `reel_likes`
    - `reel_plays`
    - `reel_reach`
    - `reel_shares`
    - `reel_total_interactions`

## Under the Hood
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

## Contributors
- [@IbraFal](https://github.com/IbraFal) ([PR #9](https://github.com/fivetran/dbt_instagram_business/pull/9))

# dbt_instagram_business v0.2.0

## 🚨 Breaking Changes 🚨:
[PR #5](https://github.com/fivetran/dbt_instagram_business/pull/5) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_instagram_business v0.1.0

The original release! The main focus of the package is to transform the core social media object tables into analytics-ready models that can be easily unioned in to other social media platform packages to get a single view. This is especially easy using our [Social Media Reporting package](https://github.com/fivetran/dbt_social_media_reporting).
