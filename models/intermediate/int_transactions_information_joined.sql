{{ config(
    materialized="view",
    database="dbt_hiive",
    schema="intermediate")
}}

with transition_mock_data as (
  select 
    transaction_id,
    transaction_bid_accepted_at,
    transaction_pending_approval_at,
    transaction_closed_at,
    datediff(month,transaction_bid_accepted_at,transaction_closed_at) as transaction_duration_month 
  
  from  {{ ref('int_transaction_transitions_mock_data') }}
)

, mock_data as (
  select
    transaction_id,
    bid_id,
    company_id,
    case 
      when current_transaction_state in ('expired','closed_paid','cancelled','approval_declined') then 'closed'
      else current_transaction_state
    end as current_transaction_state,
    transfer_method,
    num_shares,
    price_per_share,
    gross_proceeds,
    inserted_at

  from {{ ref('stg_transactions_mock_data') }}
)

, termination_reason as (
  select
    transaction_id,
    termination_reason
    
  from {{ ref('stg_transaction_termination_reasons') }}
)

, joined as (
  select
    transaction_id,
    bid_id,
    company_id,
    current_transaction_state,
    transfer_method,
    termination_reason,
    num_shares,
    price_per_share,
    gross_proceeds,
    transaction_duration_month,
    transaction_bid_accepted_at,
    transaction_pending_approval_at,
    transaction_closed_at,
    
  from transition_mock_data

  left join mock_data
    using (transaction_id)

  left join termination_reason
    using (transaction_id)
)

select 
  * 
from joined  
