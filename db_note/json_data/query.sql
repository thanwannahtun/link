-- https://chatgpt.com/c/c13fd8ab-4093-45a0-9cde-45e3c019a7d2 ( my.thanwanna@gmail.com )

-- 1 . JSON_OBJECT()
-- The JSON_OBJECT function in MySQL creates a JSON object from a list of key-value pairs.

-- syntax  = JSON_OBJECT(key, value, key, value, ...)

SELECT JSON_OBJECT(
    'id', id,
    'firstName', firstName,
    'lastName', lastName,
    'email', email
) AS user_json
FROM users
WHERE id = 1;

-- output 
/* 
    {
     "user_json": {
         "id": 1,
         "firstName": "John",
         "lastName": "Doe",
         "email": "john.doe@example.com"
     }
    }
*/

-- xxx --

-- 2. JSON_ARRAY()
-- The JSON_ARRAY function creates a JSON array from a list of values.

-- Syntax  = JSON_ARRAY(value, value, ...)

SELECT JSON_ARRAY(
    email
) AS emails_json
FROM users;

-- Output
/* 
    {
     "emails_json": ["john.doe@example.com", "jane.smith@example.com"]
    }
*/

-- xxx --

-- 3. JSON_OBJECTAGG()
-- The JSON_OBJECTAGG function creates a JSON object from a set of key-value pairs.

-- Syntax: JSON_OBJECTAGG(key, value)

-- To create a JSON object where the keys are user IDs and the values are user names:

SELECT JSON_OBJECTAGG(
    id,
    CONCAT(firstName, ' ', lastName)
) AS users_json
FROM users;

-- Output
/*
{
    "users_json": {
        "1": "John Doe",
        "2": "Jane Smith"
    }
}
*/

-- xxx --

-- 4. JSON_ARRAYAGG
-- The JSON_ARRAYAGG function creates a JSON array from a set of values.

-- Syntax: JSON_ARRAYAGG(value)

SELECT JSON_ARRAYAGG(
    CONCAT(firstName, ' ', lastName)
) AS user_names_json
FROM users;

-- Output:
/*
{
    "user_names_json": ["John Doe", "Jane Smith"]
}
*/

-- xxx --

---------------------- EXERCISE -----------------------

-- write query for output belows

-- Output 
/*
{
    "users_json": [
        {
            "id": 1,
            "firstName": "John",
            "lastName": "Doe",
            "email": "john.doe@example.com",
            "role": "admin"
        },
        {
            "id": 2,
            "firstName": "Jane",
            "lastName": "Smith",
            "email": "jane.smith@example.com",
            "role": "user"
        }
    ]
}
*/
-- Answer
SELECT JSON_ARRAYAGG(
    JSON_OBJECT(
        'id', id,
        'firstName', firstName,
        'lastName', lastName,
        'email', email,
        'role', role
    )
) AS users_json
FROM users;

-- xxx --

-- Output
/*
{
    "orders_json": [
        {
            "orderId": 1,
            "orderDate": "2023-07-01",
            "status": "Shipped",
            "customer": {
                "id": 1,
                "firstName": "John",
                "lastName": "Doe",
                "email": "john.doe@example.com",
                "phone": "123-456-7890"
            },
            "items": [
                {
                    "productId": 1,
                    "name": "Laptop",
                    "description": "A high-performance laptop",
                    "price": 999.99,
                    "quantity": 1
                },
                {
                    "productId": 2,
                    "name": "Smartphone",
                    "description": "A latest-gen smartphone",
                    "price": 699.99,
                    "quantity": 2
                }
            ],
            "shippingInfo": {
                "address": "123 Main St",
                "city": "Springfield",
                "state": "IL",
                "zip": "62701",
                "country": "USA"
            }
        },
        {
            "orderId": 2,
            "orderDate": "2023-07-05",
            "status": "Processing",
            "customer": {
                "id": 2,
                "firstName": "Jane",
                "lastName": "Smith",
                "email": "jane.smith@example.com",
                "phone": "098-765-4321"
            },
            "items": [
                {
                    "productId": 1,
                    "name": "Laptop",
                    "description": "A high-performance laptop",
                    "price": 999.99,
                    "quantity": 1
                }
            ],
            "shippingInfo": {
                "address": "456 Elm St",
                "city": "Dayton",
                "state": "OH",
                "zip": "45402",
                "country": "USA"
            }
        }
    ]
}
*/

-- Query
SELECT JSON_ARRAYAGG(
    JSON_OBJECT(
        'orderId', o.id,
        'orderDate', o.orderDate,
        'status', o.status,
        'customer', JSON_OBJECT(
            'id', c.id,
            'firstName', c.firstName,
            'lastName', c.lastName,
            'email', c.email,
            'phone', c.phone
        ),
        'items', (SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'productId', p.id,
                'name', p.name,
                'description', p.description,
                'price', oi.price,
                'quantity', oi.quantity
            )
        ) FROM order_items oi
        JOIN products p ON oi.productId = p.id
        WHERE oi.orderId = o.id),
        'shippingInfo', JSON_OBJECT(
            'address', s.address,
            'city', s.city,
            'state', s.state,
            'zip', s.zip,
            'country', s.country
        )
    )
) AS orders_json
FROM orders o
JOIN customers c ON o.customerId = c.id
JOIN shipping_info s ON o.id = s.orderId;



