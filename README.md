# App

There are news on 'user/:user_id/feed'.


# Choosing query

The common fetching script for page is:
```
SELECT items.name, items.geo, items.id, items.picture_path
  FROM items
INNER JOIN items_users
  ON items_users.item_id = items.id
WHERE
  items_users.user_id = 1
ORDER BY items.order_key DESC
LIMIT 10
OFFSET 100000
```

I assumed that sorting by items_users.order_key may improve performance. But it has extra logic on dublicating order_key from table items. And it shows better performance sometimes. 
```
SELECT items.name, items.geo, items.id, items.picture_path
  FROM items
INNER JOIN items_users
  ON items_users.item_id = items.id
WHERE
  items_users.user_id = 1
ORDER BY items_users.order_key DESC
LIMIT 10
OFFSET 100000
```
But most effecient is sorting by primary key users.id. But it often is not enough accurate. So I chose previous query. 
