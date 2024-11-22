{{ config(
    materialized="view",
    database="dbt_hiive",
    schema="staging")
}}

with source as (
  select
    md5(transaction_id) as transaction_id,
    termination_reason
  
  from {{ source('transactions', 'transaction_termination_reasons') }}

  qualify row_number() over (partition by transaction_id order by transaction_id) = 1
)

select
  *
from source