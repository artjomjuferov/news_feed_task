class Item < ActiveRecord::Base

  PER_PAGE = 10

  has_many :items_users, dependent: :delete_all
  has_many :users, through: :items_users

  validates :name, :geo, presence: true

  before_update :update_order_key

  def update_order_key
    ItemsUser.where(item: self).update_all order_key: order_key
  end

  class << self

    def get_on_page user_id, page
      page    ||= 1
      page    = from_param page
      user_id = from_param user_id
      find_by_sql get_query user_id, (page-1)*PER_PAGE
    end

    def last_page user_id
      user_id = from_param user_id
      all     = ItemsUser.where(user_id: user_id).count
      (all.to_f/PER_PAGE).ceil
    end

    private

    def from_param value
      value = Integer value
      raise ArgumentError if value < 0
      value
    end

    # a little bit faster than ORDER BY items.order_key DESC
    def get_query user_id, offset
      %{
        SELECT items.name, items.geo, items.id, items.picture_path
          FROM items
        INNER JOIN items_users
          ON items_users.item_id = items.id
        WHERE
          items_users.user_id = #{user_id}
        ORDER BY items_users.order_key DESC
        LIMIT #{PER_PAGE}
        OFFSET #{offset}
      }
    end

    #explain analyze SELECT items.name, items.geo, items.id FROM items INNER JOIN items_users ON items_users.item_id = items.id WHERE items_users.user_id = 1 ORDER BY items.order_key DESC LIMIT 10 OFFSET 10;
  end
end
