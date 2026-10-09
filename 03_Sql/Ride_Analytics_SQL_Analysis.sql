-- ============================================================
-- Query 1: Overall Ride Performance
-- ============================================================

SELECT
    COUNT(*) AS total_rides,
    SUM(CASE WHEN Ride_status = 'Completed' THEN 1 ELSE 0 END) AS completed_rides,
    SUM(CASE
        WHEN Ride_status IN ('Cancelled by Customer', 'Cancelled by Driver')
        THEN 1 ELSE 0
    END) AS cancelled_rides,
    SUM(CASE WHEN Ride_status = 'No Driver Found' THEN 1 ELSE 0 END) AS no_driver_found_rides
FROM rides;


-- ============================================================
-- Query 2: Ride Status Analysis
-- ============================================================

SELECT
    Ride_status,
    COUNT(*) AS ride_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rides), 2) AS percentage
FROM rides
GROUP BY Ride_status
ORDER BY ride_count DESC;


-- ============================================================
-- Query 3: Revenue Analysis
-- ============================================================

SELECT
    COUNT(*) AS total_payment_records,
    SUM(Amount) AS total_revenue,
    ROUND(AVG(Amount), 2) AS average_payment
FROM payments;


-- ============================================================
-- Query 4: Revenue by Payment Method
-- ============================================================

SELECT
    Payment_method,
    COUNT(*) AS payment_count,
    SUM(Amount) AS total_revenue,
    ROUND(AVG(Amount), 2) AS average_payment
FROM payments
GROUP BY Payment_method
ORDER BY total_revenue DESC;


-- ============================================================
-- Query 5: Cancellation Analysis
-- ============================================================

SELECT
    Ride_status AS cancellation_type,
    COUNT(*) AS cancellation_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM rides
         WHERE Ride_status IN ('Cancelled by Customer', 'Cancelled by Driver')),
        2
    ) AS percentage_of_cancellations
FROM rides
WHERE Ride_status IN ('Cancelled by Customer', 'Cancelled by Driver')
GROUP BY Ride_status
ORDER BY cancellation_count DESC;


-- ============================================================
-- Query 6: Vehicle Performance Analysis
-- ============================================================

SELECT
    v.Vehicle_type,
    COUNT(r.ride_id) AS total_rides,
    ROUND(AVG(r.Fare_amount), 2) AS average_fare,
    ROUND(SUM(p.Amount), 2) AS total_revenue
FROM vehicles v
LEFT JOIN rides r
    ON v.Vehicle_id = r.vehicle_id
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY v.Vehicle_type
ORDER BY total_revenue DESC;


-- ============================================================
-- Query 7: City-wise Revenue Analysis
-- ============================================================

SELECT
    l.City,
    COUNT(r.ride_id) AS total_rides,
    ROUND(SUM(p.Amount), 2) AS total_revenue,
    ROUND(AVG(r.Fare_amount), 2) AS average_fare
FROM locations l
LEFT JOIN rides r
    ON l.Location_id = r.pickup_location
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY l.City
ORDER BY total_revenue DESC;


-- ============================================================
-- Query 8: Driver Performance Analysis
-- ============================================================

SELECT
    d.Driver_id,
    d.Driver_name,
    d.City,
    d.Rating,
    COUNT(r.ride_id) AS total_rides,
    ROUND(AVG(r.Fare_amount), 2) AS average_fare
FROM drivers d
LEFT JOIN rides r
    ON d.Driver_id = r.driver_id
GROUP BY
    d.Driver_id,
    d.Driver_name,
    d.City,
    d.Rating
ORDER BY total_rides DESC;


-- ============================================================
-- Query 9: Customer Analysis
-- ============================================================

SELECT
    c.Customer_id,
    c.Customer_name,
    c.City,
    c.Gender,
    COUNT(r.ride_id) AS total_rides,
    ROUND(SUM(p.Amount), 2) AS total_spent,
    ROUND(AVG(p.Amount), 2) AS average_spend_per_ride
FROM customers c
LEFT JOIN rides r
    ON c.Customer_id = r.customer_id
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY
    c.Customer_id,
    c.Customer_name,
    c.City,
    c.Gender
ORDER BY total_spent DESC;


-- ============================================================
-- Query 10: Ride Status Analysis
-- ============================================================

SELECT
    Ride_status,
    COUNT(ride_id) AS total_rides,
    ROUND(
        COUNT(ride_id) * 100.0 /
        (SELECT COUNT(*) FROM rides),
        2
    ) AS percentage_of_total
FROM rides
GROUP BY Ride_status
ORDER BY total_rides DESC;


-- ============================================================
-- Query 11: Revenue Analysis by Payment Method
-- ============================================================

SELECT
    p.Payment_method,
    COUNT(p.Payment_id) AS total_transactions,
    ROUND(
        SUM(CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END), 2
    ) AS total_paid_revenue,
    ROUND(
        AVG(CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
        END), 2
    ) AS average_paid_transaction
FROM payments p
GROUP BY p.Payment_method
ORDER BY total_paid_revenue DESC;


-- ============================================================
-- Query 12: City-wise Ride & Revenue Analysis
-- ============================================================

SELECT
    c.City,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,
    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue,
    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Fare_amount
        END
    ), 2) AS average_fare
FROM customers c
LEFT JOIN rides r
    ON c.Customer_id = r.customer_id
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY c.City
ORDER BY total_revenue DESC;


-- ============================================================
-- Query 13: Vehicle Performance Analysis
-- ============================================================

SELECT
    v.Vehicle_type,
    v.Vehicle_model,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,
    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue,
    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Fare_amount
        END
    ), 2) AS average_fare
FROM vehicles v
LEFT JOIN rides r
    ON v.Vehicle_id = r.vehicle_id
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY
    v.Vehicle_type,
    v.Vehicle_model
ORDER BY total_revenue DESC;


-- ============================================================
-- Query 14: Driver Cancellation Analysis
-- ============================================================

SELECT
    d.Driver_id,
    d.Driver_name,
    d.City,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Cancelled by Driver'
        THEN r.ride_id
    END) AS driver_cancelled_rides,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN r.Ride_status = 'Cancelled by Driver'
            THEN r.ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT r.ride_id), 0),
        2
    ) AS driver_cancellation_rate
FROM drivers d
LEFT JOIN rides r
    ON d.Driver_id = r.driver_id
GROUP BY
    d.Driver_id,
    d.Driver_name,
    d.City
ORDER BY driver_cancellation_rate DESC;


-- ============================================================
-- Query 15: Customer Ride Frequency Analysis
-- ============================================================

SELECT
    c.Customer_id,
    c.Customer_name,
    c.City,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_spent,
    CASE
        WHEN COUNT(DISTINCT r.ride_id) >= 20
            THEN 'High Frequency'
        WHEN COUNT(DISTINCT r.ride_id) >= 10
            THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS customer_frequency
FROM customers c
LEFT JOIN rides r
    ON c.Customer_id = r.customer_id
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY
    c.Customer_id,
    c.Customer_name,
    c.City
ORDER BY total_rides DESC;

-- ============================================================
-- Query 16: Monthly Revenue & Ride Trend Analysis
-- ============================================================

SELECT
    DATE_FORMAT(r.ride_date, '%Y-%m') AS ride_month,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,
    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue,
    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Fare_amount
        END
    ), 2) AS average_fare
FROM rides r
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY DATE_FORMAT(r.ride_date, '%Y-%m')
ORDER BY ride_month;

-- ============================================================
-- ============================================================
-- Query 17: Zone Performance Analysis
-- ============================================================

SELECT
    l.Zone_type,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT r.ride_id), 0),
        2
    ) AS completion_rate,
    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue
FROM locations l
LEFT JOIN rides r
    ON l.Location_id = r.pickup_location_id
LEFT JOIN payments p
    ON r.ride_id = p.Ride_id
GROUP BY l.Zone_type
ORDER BY total_revenue DESC;


-- ============================================================
-- Query 18: Pickup Location Performance Analysis
-- ============================================================

SELECT
    l.City,
    l.Area,
    l.Zone_type,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT r.ride_id), 0),
        2
    ) AS completion_rate,
    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Distance_km
        END
    ), 2) AS average_distance_km
FROM locations l
LEFT JOIN rides r
    ON l.Location_id = r.pickup_location_id
GROUP BY
    l.City,
    l.Area,
    l.Zone_type
ORDER BY total_rides DESC;



-- ============================================================
-- Query 19: Driver Rating & Performance Analysis
-- ============================================================

SELECT
    d.Driver_id,
    d.Driver_name,
    d.Rating,
    COUNT(DISTINCT r.ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT r.ride_id), 0),
        2
    ) AS completion_rate,
    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Fare_amount
        END
    ), 2) AS average_fare
FROM drivers d
LEFT JOIN rides r
    ON d.Driver_id = r.driver_id
GROUP BY
    d.Driver_id,
    d.Driver_name,
    d.Rating
ORDER BY d.Rating DESC, completion_rate DESC;

-- ============================================================
-- Query 20: Peak Hour Analysis
-- ============================================================

SELECT
    HOUR(Ride_time) AS ride_hour,
    COUNT(DISTINCT ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN Ride_status = 'Completed'
        THEN ride_id
    END) AS completed_rides,
    COUNT(DISTINCT CASE
        WHEN Ride_status LIKE 'Cancelled%'
        THEN ride_id
    END) AS cancelled_rides
FROM rides
GROUP BY HOUR(Ride_time)
ORDER BY total_rides DESC;



-- ============================================================
-- Query 21: Cancellation Analysis by Hour
-- ============================================================

SELECT
    HOUR(Ride_time) AS ride_hour,
    COUNT(DISTINCT ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN Ride_status LIKE 'Cancelled%'
        THEN ride_id
    END) AS cancelled_rides,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN Ride_status LIKE 'Cancelled%'
            THEN ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT ride_id), 0),
        2
    ) AS cancellation_rate
FROM rides
GROUP BY HOUR(Ride_time)
ORDER BY cancellation_rate DESC;


-- ============================================================
-- Query 22: Distance vs Fare Analysis
-- ============================================================

SELECT
    CASE
        WHEN Distance_km < 5 THEN '0-5 km'
        WHEN Distance_km < 10 THEN '5-10 km'
        WHEN Distance_km < 20 THEN '10-20 km'
        ELSE '20+ km'
    END AS distance_range,
    COUNT(DISTINCT ride_id) AS total_rides,
    ROUND(AVG(Fare_amount), 2) AS average_fare,
    ROUND(AVG(Distance_km), 2) AS average_distance
FROM rides
WHERE Ride_status = 'Completed'
GROUP BY
    CASE
        WHEN Distance_km < 5 THEN '0-5 km'
        WHEN Distance_km < 10 THEN '5-10 km'
        WHEN Distance_km < 20 THEN '10-20 km'
        ELSE '20+ km'
    END
ORDER BY average_distance;

-- ============================================================
-- Query 23: Day-wise Ride Performance Analysis
-- ============================================================

SELECT
    DAYNAME(ride_date) AS day_of_week,
    COUNT(DISTINCT ride_id) AS total_rides,
    COUNT(DISTINCT CASE
        WHEN Ride_status = 'Completed'
        THEN ride_id
    END) AS completed_rides,
    COUNT(DISTINCT CASE
        WHEN Ride_status LIKE 'Cancelled%'
        THEN ride_id
    END) AS cancelled_rides,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN Ride_status = 'Completed'
            THEN ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT ride_id), 0),
        2
    ) AS completion_rate
FROM rides
GROUP BY DAYNAME(ride_date)
ORDER BY total_rides DESC;


-- ============================================================
-- Query 24: Payment Status Analysis
-- ============================================================

SELECT
    p.Payment_status,
    COUNT(DISTINCT p.Payment_id) AS total_transactions,
    ROUND(SUM(p.Amount), 2) AS total_amount,
    ROUND(AVG(p.Amount), 2) AS average_transaction_value
FROM payments p
GROUP BY p.Payment_status
ORDER BY total_amount DESC;

-- ============================================================
-- Query 25: Top Drivers by Revenue
-- ============================================================

SELECT
    d.Driver_id,
    d.Driver_name,
    d.City,
    d.Rating,

    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,

    ROUND(SUM(
        CASE
            WHEN r.Ride_status = 'Completed'
                 AND p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue,

    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Fare_amount
        END
    ), 2) AS average_fare

FROM drivers d

LEFT JOIN rides r
    ON d.Driver_id = r.driver_id

LEFT JOIN payments p
    ON r.ride_id = p.Ride_id

GROUP BY
    d.Driver_id,
    d.Driver_name,
    d.City,
    d.Rating

ORDER BY total_revenue DESC
LIMIT 10;

-- ============================================================
-- Query 26: Top Customers by Spending
-- ============================================================

SELECT
    c.Customer_id,
    c.Customer_name,
    c.City,
    c.Gender,

    COUNT(DISTINCT r.ride_id) AS total_rides,

    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_spent,

    ROUND(
        SUM(
            CASE
                WHEN p.Payment_status = 'Paid'
                THEN p.Amount
                ELSE 0
            END
        ) / NULLIF(
            COUNT(DISTINCT CASE
                WHEN p.Payment_status = 'Paid'
                THEN r.ride_id
            END),
            0
        ),
        2
    ) AS average_spend_per_ride

FROM customers c

LEFT JOIN rides r
    ON c.Customer_id = r.customer_id

LEFT JOIN payments p
    ON r.ride_id = p.Ride_id

GROUP BY
    c.Customer_id,
    c.Customer_name,
    c.City,
    c.Gender

ORDER BY total_spent DESC
LIMIT 10;


-- ============================================================
-- Query 27: Revenue by Vehicle Type
-- ============================================================

SELECT
    v.Vehicle_type,

    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,

    ROUND(SUM(
        CASE
            WHEN r.Ride_status = 'Completed'
                 AND p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue,

    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Fare_amount
        END
    ), 2) AS average_fare,

    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Distance_km
        END
    ), 2) AS average_distance_km

FROM vehicles v

LEFT JOIN rides r
    ON v.Vehicle_id = r.vehicle_id

LEFT JOIN payments p
    ON r.ride_id = p.Ride_id

GROUP BY v.Vehicle_type

ORDER BY total_revenue DESC;

-- ============================================================
-- Query 28: Cancellation Reason Analysis
-- ============================================================

SELECT
    Ride_status AS cancellation_reason,

    COUNT(DISTINCT ride_id) AS cancelled_rides,

    ROUND(
        COUNT(DISTINCT ride_id) * 100.0 /
        NULLIF(
            (SELECT COUNT(DISTINCT ride_id)
             FROM rides
             WHERE Ride_status LIKE 'Cancelled%'),
            0
        ),
        2
    ) AS percentage_of_cancellations

FROM rides

WHERE Ride_status LIKE 'Cancelled%'

GROUP BY Ride_status

ORDER BY cancelled_rides DESC;

-- ============================================================
-- Query 29: Driver Workload Analysis
-- ============================================================

SELECT
    d.Driver_id,
    d.Driver_name,
    d.City,
    d.Rating,

    COUNT(DISTINCT r.ride_id) AS total_rides,

    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,

    COUNT(DISTINCT CASE
        WHEN r.Ride_status LIKE 'Cancelled%'
        THEN r.ride_id
    END) AS cancelled_rides,

    ROUND(AVG(
        CASE
            WHEN r.Ride_status = 'Completed'
            THEN r.Distance_km
        END
    ), 2) AS average_distance_km

FROM drivers d

LEFT JOIN rides r
    ON d.Driver_id = r.driver_id

GROUP BY
    d.Driver_id,
    d.Driver_name,
    d.City,
    d.Rating

ORDER BY total_rides DESC
LIMIT 10;



-- ============================================================
-- Query 30: Revenue by Distance Range
-- ============================================================

SELECT
    CASE
        WHEN r.Distance_km < 5 THEN '0-5 km'
        WHEN r.Distance_km < 10 THEN '5-10 km'
        WHEN r.Distance_km < 20 THEN '10-20 km'
        ELSE '20+ km'
    END AS distance_range,

    COUNT(DISTINCT r.ride_id) AS completed_rides,

    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue,

    ROUND(AVG(r.Fare_amount), 2) AS average_fare,

    ROUND(AVG(r.Distance_km), 2) AS average_distance_km

FROM rides r

LEFT JOIN payments p
    ON r.ride_id = p.Ride_id

WHERE r.Ride_status = 'Completed'

GROUP BY
    CASE
        WHEN r.Distance_km < 5 THEN '0-5 km'
        WHEN r.Distance_km < 10 THEN '5-10 km'
        WHEN r.Distance_km < 20 THEN '10-20 km'
        ELSE '20+ km'
    END

ORDER BY average_distance_km;

-- ============================================================
-- Query 31: Driver vs Customer Cancellation Analysis
-- ============================================================

SELECT
    CASE
        WHEN Ride_status = 'Cancelled by Driver'
            THEN 'Driver Cancellation'
        WHEN Ride_status = 'Cancelled by Customer'
            THEN 'Customer Cancellation'
    END AS cancellation_type,

    COUNT(DISTINCT ride_id) AS cancelled_rides,

    ROUND(
        COUNT(DISTINCT ride_id) * 100.0 /
        NULLIF(
            (SELECT COUNT(DISTINCT ride_id)
             FROM rides
             WHERE Ride_status LIKE 'Cancelled%'),
            0
        ),
        2
    ) AS percentage_of_cancellations

FROM rides

WHERE Ride_status IN (
    'Cancelled by Driver',
    'Cancelled by Customer'
)

GROUP BY
    CASE
        WHEN Ride_status = 'Cancelled by Driver'
            THEN 'Driver Cancellation'
        WHEN Ride_status = 'Cancelled by Customer'
            THEN 'Customer Cancellation'
    END

ORDER BY cancelled_rides DESC;


-- ============================================================
-- Query 32: Average Fare by City
-- ============================================================

SELECT
    c.City,

    COUNT(DISTINCT r.ride_id) AS completed_rides,

    ROUND(AVG(r.Fare_amount), 2) AS average_fare,

    ROUND(AVG(r.Distance_km), 2) AS average_distance_km,

    ROUND(
        SUM(
            CASE
                WHEN p.Payment_status = 'Paid'
                THEN p.Amount
                ELSE 0
            END
        ), 2
    ) AS total_revenue

FROM customers c

LEFT JOIN rides r
    ON c.Customer_id = r.customer_id

LEFT JOIN payments p
    ON r.ride_id = p.Ride_id

WHERE r.Ride_status = 'Completed'

GROUP BY c.City

ORDER BY average_fare DESC;

-- ============================================================
-- Query 33: Monthly Cancellation Trend
-- ============================================================

SELECT
    DATE_FORMAT(ride_date, '%Y-%m') AS ride_month,

    COUNT(DISTINCT ride_id) AS total_rides,

    COUNT(DISTINCT CASE
        WHEN Ride_status LIKE 'Cancelled%'
        THEN ride_id
    END) AS cancelled_rides,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN Ride_status LIKE 'Cancelled%'
            THEN ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT ride_id), 0),
        2
    ) AS cancellation_rate

FROM rides

GROUP BY DATE_FORMAT(ride_date, '%Y-%m')

ORDER BY ride_month;


-- ============================================================
-- Query 34: Driver Rating Category Analysis
-- ============================================================

SELECT
    CASE
        WHEN d.Rating >= 4.5 THEN 'Excellent (4.5+)'
        WHEN d.Rating >= 4.0 THEN 'Good (4.0-4.49)'
        WHEN d.Rating >= 3.0 THEN 'Average (3.0-3.99)'
        ELSE 'Low (Below 3.0)'
    END AS rating_category,

    COUNT(d.Driver_id) AS total_drivers,

    ROUND(AVG(d.Rating), 2) AS average_rating,

    ROUND(AVG(
        COALESCE(rc.completed_rides, 0)
    ), 2) AS avg_completed_rides

FROM drivers d

LEFT JOIN (
    SELECT
        driver_id,
        COUNT(DISTINCT ride_id) AS completed_rides
    FROM rides
    WHERE Ride_status = 'Completed'
    GROUP BY driver_id
) rc
    ON d.Driver_id = rc.driver_id

GROUP BY
    CASE
        WHEN d.Rating >= 4.5 THEN 'Excellent (4.5+)'
        WHEN d.Rating >= 4.0 THEN 'Good (4.0-4.49)'
        WHEN d.Rating >= 3.0 THEN 'Average (3.0-3.99)'
        ELSE 'Low (Below 3.0)'
    END

ORDER BY average_rating DESC;


-- ============================================================
-- Query 35: Repeat Customer Analysis
-- ============================================================

SELECT
    c.Customer_id,
    c.Customer_name,
    c.City,

    COUNT(DISTINCT r.ride_id) AS total_rides,

    COUNT(DISTINCT CASE
        WHEN r.Ride_status = 'Completed'
        THEN r.ride_id
    END) AS completed_rides,

    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_spent

FROM customers c

LEFT JOIN rides r
    ON c.Customer_id = r.customer_id

LEFT JOIN payments p
    ON r.ride_id = p.Ride_id

GROUP BY
    c.Customer_id,
    c.Customer_name,
    c.City

HAVING COUNT(DISTINCT r.ride_id) >= 2

ORDER BY total_rides DESC;

-- ============================================================
-- Query 36: Payment Method Analysis
-- ============================================================

SELECT
    p.Payment_method,

    COUNT(DISTINCT p.Payment_id) AS total_transactions,

    COUNT(DISTINCT CASE
        WHEN p.Payment_status = 'Paid'
        THEN p.Payment_id
    END) AS successful_transactions,

    ROUND(SUM(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
            ELSE 0
        END
    ), 2) AS total_revenue,

    ROUND(AVG(
        CASE
            WHEN p.Payment_status = 'Paid'
            THEN p.Amount
        END
    ), 2) AS average_transaction_value

FROM payments p

GROUP BY p.Payment_method

ORDER BY total_revenue DESC;


-- ============================================================
-- Query 37: Business KPI Summary
-- ============================================================

SELECT
    COUNT(DISTINCT ride_id) AS total_rides,

    COUNT(DISTINCT CASE
        WHEN Ride_status = 'Completed'
        THEN ride_id
    END) AS completed_rides,

    COUNT(DISTINCT CASE
        WHEN Ride_status LIKE 'Cancelled%'
        THEN ride_id
    END) AS cancelled_rides,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN Ride_status = 'Completed'
            THEN ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT ride_id), 0),
        2
    ) AS completion_rate,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN Ride_status LIKE 'Cancelled%'
            THEN ride_id
        END) * 100.0
        / NULLIF(COUNT(DISTINCT ride_id), 0),
        2
    ) AS cancellation_rate,

    ROUND(AVG(
        CASE
            WHEN Ride_status = 'Completed'
            THEN Fare_amount
        END
    ), 2) AS average_fare,

    ROUND(AVG(
        CASE
            WHEN Ride_status = 'Completed'
            THEN Distance_km
        END
    ), 2) AS average_distance_km

FROM rides;


