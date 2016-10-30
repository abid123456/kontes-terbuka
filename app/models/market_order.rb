# == Schema Information
#
# Table name: market_orders
#
#  id                   :integer          not null, primary key
#  point_transaction_id :integer
#  market_item_id       :integer
#  quantity             :integer
#  email                :string
#  phone                :string
#  user_memo            :text
#  internal_memo        :text
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_market_orders_on_market_item_id        (market_item_id)
#  index_market_orders_on_point_transaction_id  (point_transaction_id)
#

class MarketOrder < ActiveRecord::Base
  has_paper_trail

  # Associations
  belongs_to :point_transaction
  belongs_to :market_item
end
