{{ config(
    materialized="table",
    database="dbt_hiive",
    schema="core")
}}

with transaction_termination_reasons as (
  select
   transaction_id,
   termination_reason

  from {{ ref('stg_transaction_termination_reasons') }}
)

select
  *
from transaction_termination_reasons
