class ItemsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :item

  before_validation :set_created_at

  private

  def set_created_at
    self.order_key = item.order_key
  end
end