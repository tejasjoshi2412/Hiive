{{ config(
    materialized="view",
    database="dbt_hiive",
    schema="staging")
}}

with source as (
  select 
    md5(id) as transaction_transitions_mock_data_id,
    md5(transaction_id) as transaction_id,
    new_state as transaction_state,
    transitioned_at::timestamp as transaction_transitioned_at,
    updated_at::timestamp as transaction_updated_at
  
  from {{ source('transactions', 'transaction_transitions_mock_data') }}
)

select
  *
from 
  source