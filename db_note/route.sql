
----------------------- fetching for routes --------------------
-- querying => id , agency , origin , destination , schedule_date , price_per_traveler , mid_points [] , seats_available [] 
 -- (1)
SELECT 
    r.id, 
    a.name AS agency, 
    origin.name AS origin, 
    destination.name AS destination, 
    r.schedule_date, 
    r.price_per_traveler,
    mid_points.mid_points,
    seats.seats_available
FROM 
    routes r
LEFT JOIN 
    agencies a ON r.agency_id = a.id
LEFT JOIN 
    cities origin ON r.origin_city_id = origin.id
LEFT JOIN 
    cities destination ON r.destination_city_id = destination.id
LEFT JOIN 
    (SELECT 
         rc.route_id, 
         JSON_ARRAYAGG(JSON_OBJECT('cityId', c.id, 'cityName', c.name, 'cityOrder', rc.city_order)) AS mid_points
     FROM 
         routecities rc
     LEFT JOIN 
         cities c ON rc.city_id = c.id
     GROUP BY 
         rc.route_id) AS mid_points ON r.id = mid_points.route_id
LEFT JOIN 
    (SELECT
         route_id,
         JSON_ARRAYAGG(seat_number) AS seats_available
     FROM
         seats
     WHERE
         status = "Available"
     GROUP BY
         route_id) AS seats ON r.id = seats.route_id
WHERE 
    r.agency_id = 1
GROUP BY 
    r.id, a.name, origin.name, destination.name, r.schedule_date, r.price_per_traveler, mid_points.mid_points, seats.seats_available
ORDER BY 
    origin.name;

 -- here the correct query --
-- (2)
 USE social_media_db;

SELECT JSON_ARRAYAGG(
    JSON_OBJECT(
        'routeId', r.id,
        'agency', a.name,
        'origin', origin.name,
        'destination', destination.name,
        'scheduleDate', r.schedule_date,
        'pricePerTraveler', r.price_per_traveler,
        'midPoints', (SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'cityId', c.id,
                'cityName', c.name,
                'cityOrder', rc.city_order
            )
        ) FROM routecities rc
        JOIN cities c ON rc.city_id = c.id
        WHERE rc.route_id = r.id),
        'seatsAvailable', (SELECT JSON_ARRAYAGG(s.seat_number)
            FROM seats s
            WHERE s.route_id = r.id)
    )
) AS routes
FROM routes r
LEFT JOIN agencies a ON r.agency_id = a.id
LEFT JOIN cities origin ON r.origin_city_id = origin.id
LEFT JOIN cities destination ON r.destination_city_id = destination.id
GROUP BY r.id, a.name, origin.name, destination.name, r.schedule_date, r.price_per_traveler;



-- GROUP_CONCAT(s.seat_number ORDER BY s.seat_number) AS seats_available  => for string of value separated by comma by default like "a,b,v" not for ["a","b","c"]
----------- response format ------------------

/*
[
  {
    "routeId": 1,
    "agency": "Agency Name",
    "origin": "Origin City",
    "destination": "Destination City",
    "scheduleDate": "2023-07-15",
    "pricePerTraveler": 50.00,
    "midPoints": [
      {
        "cityId": 101,
        "cityName": "Midpoint City 1",
        "cityOrder": 1
      },
      {
        "cityId": 102,
        "cityName": "Midpoint City 2",
        "cityOrder": 2
      }
    ],
    "seatsAvailable": ["A1","A2","B1"] 
  },
  {
    "routeId": 2,
    "agency": "Another Agency",
    "origin": "Another Origin City",
    "destination": "Another Destination City",
    "scheduleDate": "2023-07-16",
    "pricePerTraveler": 60.00,
    "midPoints": [
      {
        "cityId": 201,
        "cityName": "Another Midpoint City 1",
        "cityOrder": 1
      },
      {
        "cityId": 202,
        "cityName": "Another Midpoint City 2",
        "cityOrder": 2
      }
    ],
    "seatsAvailable": ["A3", "A4", "B2"]

  }
]

*/

-- XXX --
-- (3)
USE social_media_db;

SELECT JSON_ARRAYAGG(
    JSON_OBJECT(
        'routeId', r.id,
        'agency', a.name,
        'origin', origin.name,
        'destination', destination.name,
        'scheduleDate', r.schedule_date,
        'pricePerTraveler', r.price_per_traveler,
        'midPoints', (SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'cityId', c.id,
                'cityName', c.name,
                'cityOrder', rc.city_order
            )
        ) FROM routecities rc
        JOIN cities c ON rc.city_id = c.id
        WHERE rc.route_id = r.id),
        'seatsAvailable', (SELECT JSON_ARRAYAGG(s.seat_number)
            FROM seats s
            WHERE s.route_id = r.id)
    )
) AS routes
FROM routes r
LEFT JOIN agencies a ON r.agency_id = a.id
LEFT JOIN cities origin ON r.origin_city_id = origin.id
LEFT JOIN cities destination ON r.destination_city_id = destination.id
-- deleted gruoup by clause

-- routes : [{}, {}]
