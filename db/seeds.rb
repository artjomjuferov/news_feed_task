# users = 100.times.map { User.create }
user = User.first

2_000_000.times do |i|
  item = Item.create name: "name#{i+129060}",
                     geo: "name#{rand(100.0..200.0)}",
                     order_key: Time.now
  item.users << user
end

# Item.where(order_key: nil).each {|x| x.update_attribute :order_key, Time.now }