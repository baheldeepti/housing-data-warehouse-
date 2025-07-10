{{ config(materialized = 'table', schema = 'mart') }}

with dates as (
    {{ dbt_utils.date_spine(
        datepart   = "day",
        start_date = "date '1990-01-01'",
        end_date   = "current_date + interval '2 year'"
    ) }}
)

select
    date_day                           as full_date,
    to_char(date_day,'YYYYMMDD')::int  as date_id,
    extract(year   from date_day)      as year,
    extract(month  from date_day)      as month_num,
    to_char(date_day,'Month')          as month_name,
    extract(day    from date_day)      as day_of_month,
    extract(dow    from date_day)      as day_of_week,
    extract(quarter from date_day)     as quarter
from dates
