import pandas as pd

file_path = "../02_Excel/rides_cleaned.xlsx"

df= pd.read_excel(file_path)

print("First 5 rows of ride data:")
print(df.head())

print("\nTotal rows and columns:")
print(df.shape)

print("\nColumn names:")
print(df.columns.tolist())


print("\nMissing values in each column:")
print(df.isnull().sum())

print("\nDuplicate rows:")
print(df.duplicated().sum())

print("\nFirst 5 rows of data:")
print(df.head())

print("\nColumn names:")
print(df.columns.tolist())

print("\nMissing values:")
print(df.isnull().sum())

print("\n--- RIDE DATA SUMMARY ---")

print("\nTotal rides:")
print(len(df))

print("\nRide status count:")
print(df["ride_status"].value_counts())

print("\nAverage ride distance:")
print(df["distance_km"].mean())

print("\nAverage fare:")
print(df["fare_amount"].mean())

print("\n--- CANCELLATION RATE ANALYSIS ---")

cancelled_rides = df["ride_status"].isin([
    "Cancelled by Customer",
    "Cancelled by Driver",
    "No Driver Found"
]).sum()

total_rides = len(df)

cancellation_rate = (cancelled_rides / total_rides) * 100

print("Total rides:", total_rides)
print("Cancelled rides:", cancelled_rides)
print("Cancellation rate:", round(cancellation_rate, 2), "%")

print("\n--- COMPLETED RIDES ANALYSIS ---")

completed_rides = (
    df["ride_status"].str.strip().str.lower() == "completed"
).sum()

completion_rate = (completed_rides / len(df)) * 100

print("Completed rides:", completed_rides)
print("Completion rate:", round(completion_rate, 2), "%")

print("\n--- RIDE METRICS ---")

print("Average distance (km):", round(df["distance_km"].mean(), 2))
print("Average fare (Rs):", round(df["fare_amount"].mean(), 2))

print(df.columns.tolist())

print("\n--- VEHICLE DATA CHECK ---")

vehicles_path = "../02_Excel/vehicles_cleaned.xlsx"
vehicles_df = pd.read_excel(vehicles_path)

print("Vehicle rows and columns:", vehicles_df.shape)
print("Vehicle column names:", vehicles_df.columns.tolist())

print("\n--- MERGING RIDES AND VEHICLES ---")

merged_df = pd.merge(
    df,
    vehicles_df,
    on="vehicle_id",
    how="left"
)

print("Merged data shape:", merged_df.shape)
print("Merged columns:", merged_df.columns.tolist())

print("\n--- RIDES BY VEHICLE TYPE ---")

vehicle_ride_counts = (
    merged_df.groupby("vehicle_type")
    .size()
    .sort_values(ascending=False)
)

print(vehicle_ride_counts)

print("\n--- AVERAGE FARE BY VEHICLE TYPE ---")

average_fare_by_vehicle = (
    merged_df.groupby("vehicle_type")["fare_amount"]
    .mean()
    .round(2)
    .sort_values(ascending=False)
)

print(average_fare_by_vehicle)

print("\n--- COMPLETED RIDES BY VEHICLE TYPE ---")

completed_by_vehicle = (
    merged_df[merged_df["ride_status"] == "Completed"]
    .groupby("vehicle_type")
    .size()
    .sort_values(ascending=False)
)

print(completed_by_vehicle)

print("\n--- COMPLETION RATE BY VEHICLE TYPE ---")

total_by_vehicle = merged_df.groupby("vehicle_type").size()

completed_by_vehicle = (
    merged_df[merged_df["ride_status"] == "Completed"]
    .groupby("vehicle_type")
    .size()
)

completion_rate_by_vehicle = (
    completed_by_vehicle / total_by_vehicle * 100
).round(2)

print(completion_rate_by_vehicle.sort_values(ascending=False))

print("\n--- REVENUE BY VEHICLE TYPE ---")

revenue_by_vehicle = (
    merged_df.groupby("vehicle_type")["fare_amount"]
    .sum()
    .round(2)
)

print(revenue_by_vehicle.sort_values(ascending=False))

print("\n--- REVENUE BY VEHICLE TYPE ---")

revenue_by_vehicle = (
    merged_df.groupby("vehicle_type")["fare_amount"]
    .sum()
    .round(2)
)

print(revenue_by_vehicle.sort_values(ascending=False))

print("\n--- MONTHLY REVENUE TREND ---")

merged_df["ride_date"] = pd.to_datetime(merged_df["ride_date"])

monthly_revenue = (
    merged_df.groupby(merged_df["ride_date"].dt.to_period("M"))["fare_amount"]
    .sum()
    .round(2)
)

print(monthly_revenue)

print("\n--- MONTHLY RIDES TREND ---")

monthly_rides = (
    merged_df.groupby(merged_df["ride_date"].dt.to_period("M"))
    .size()
)

print(monthly_rides)

print("\n--- MONTHLY RIDES AND REVENUE COMPARISON ---")

monthly_comparison = pd.concat(
    [monthly_rides, monthly_revenue],
    axis=1
)

monthly_comparison.columns = ["Total_Rides", "Total_Revenue"]

print(monthly_comparison)

print("\n--- MONTHLY AVERAGE FARE ---")

monthly_comparison["Average_Fare"] = (
    monthly_comparison["Total_Revenue"]
    / monthly_comparison["Total_Rides"]
).round(2)

print(monthly_comparison) 

print("\n--- LOADING DRIVERS DATA ---")
drivers_path = "../02_Excel/Drivers_cleaned.xlsx"
drivers_df = pd.read_excel(drivers_path)
print("Drivers data shape:", drivers_df.shape)
print("Drivers columns:", drivers_df.columns.tolist())

print("\n--- CHECKING RIDES DATA ---")

print("Rides data loaded:", "rides_df" in globals())

if "rides_df" in globals():
    print("Rides data shape:", rides_df.shape)
    print("Rides columns:", rides_df.columns.tolist())

    print("\n--- LOADING RIDES DATA ---")

rides_path = "../02_Excel/Rides_cleaned.xlsx"

rides_df = pd.read_excel(rides_path)

print("Rides data shape:", rides_df.shape)
print("Rides columns:", rides_df.columns.tolist())

print("\n--- TOP 10 DRIVERS BY COMPLETED RIDES ---")

completed_rides = rides_df[
    rides_df["ride_status"].str.strip().str.lower() == "completed"
]

driver_ride_counts = (
    completed_rides.groupby("driver_id")
    .size()
    .reset_index(name="completed_rides")
)

top_10_drivers = driver_ride_counts.merge(
    drivers_df,
    on="driver_id",
    how="left"
)

top_10_drivers = top_10_drivers.sort_values(
    by="completed_rides",
    ascending=False
).head(10)

print(
    top_10_drivers[
        ["driver_id", "completed_rides"]
    ]
)

print("\n--- DRIVER COLUMN NAMES ---")
print(drivers_df.columns.tolist())

print("\n--- TOP 10 DRIVERS WITH NAMES ---")

print(
    top_10_drivers[
        ["driver_id", "driver_name", "completed_rides"]
    ].to_string(index=False))


print("\n--- DRIVER PERFORMANCE ANALYSIS ---")

driver_performance = drivers_df[
    ["driver_id", "driver_name", "rating"]
].copy()

completed_counts = (
    rides_df[
        rides_df["ride_status"].str.strip().str.lower() == "completed"
    ]
    .groupby("driver_id")
    .size()
    .reset_index(name="completed_rides")
)

driver_performance = driver_performance.merge(
    completed_counts,
    on="driver_id",
    how="left"
)

driver_performance["completed_rides"] = (
    driver_performance["completed_rides"].fillna(0).astype(int)
)

driver_performance = driver_performance.sort_values(
    by="rating",
    ascending=False
).head(10)

print(driver_performance.to_string(index=False))

print("\n--- CITY-WISE COMPLETED RIDE ANALYSIS ---")

city_rides = rides_df[
    rides_df["ride_status"].str.strip().str.lower() == "completed"
].merge(
    drivers_df[["driver_id", "city"]],
    on="driver_id",
    how="left"
)

city_summary = (
    city_rides.groupby("city")
    .size()
    .reset_index(name="completed_rides")
    .sort_values(by="completed_rides", ascending=False)
)

print(city_summary.to_string(index=False))

print("\n--- LOADING VEHICLES DATA ---")

vehicles_path = "../02_Excel/Vehicles_cleaned.xlsx"

vehicles_df = pd.read_excel(vehicles_path)

print("Vehicles data shape:", vehicles_df.shape)
print("Vehicles columns:", vehicles_df.columns.tolist())

print("\n--- VEHICLE-WISE COMPLETED RIDES ---")

completed_rides = rides_df[
    rides_df["ride_status"].str.strip().str.lower() == "completed"
]

vehicle_rides = completed_rides.merge(
    vehicles_df[["vehicle_id", "vehicle_type"]],
    on="vehicle_id",
    how="left"
)

vehicle_summary = (
    vehicle_rides.groupby("vehicle_type")
    .size()
    .reset_index(name="completed_rides")
    .sort_values(by="completed_rides", ascending=False)
)

print(vehicle_summary.to_string(index=False))


print("\n--- LOADING PAYMENTS DATA ---")

payments_path = "../02_Excel/Payments_cleaned.xlsx"

payments_df = pd.read_excel(payments_path)

print("Payments data shape:", payments_df.shape)

print("Payments column names:")
print(payments_df.columns.tolist())

print("\nFirst 5 payment records:")
print(payments_df.head())

print("\n--- PAYMENT DATA QUALITY CHECK ---")

print("\nMissing values:")
print(payments_df.isnull().sum())

print("\nDuplicate rows:")
print(payments_df.duplicated().sum())

print("\nPayment status count:")
print(payments_df["payment_status"].value_counts())

print("\nPayment method count:")
print(payments_df["payment_method"].value_counts())

print("\n--- PAYMENT METHOD ANALYSIS ---")

payment_summary = (
    payments_df.groupby("payment_method")["amount"]
    .agg(["count", "sum", "mean"])
    .round(2)
    .sort_values(by="sum", ascending=False)
)

payment_summary.columns = [
    "Total_Payments",
    "Total_Amount",
    "Average_Payment"
]

print(payment_summary)


print("\n--- PAID VS FAILED PAYMENT ANALYSIS ---")

payment_status_summary = (
    payments_df.groupby("payment_status")["amount"]
    .agg(["count", "sum", "mean"])
    .round(2)
)

payment_status_summary.columns = [
    "Total_Payments",
    "Total_Amount",
    "Average_Payment"
]

print(payment_status_summary)

print("\n--- PAYMENT SUCCESS RATE ANALYSIS ---")

total_payments = len(payments_df)

successful_payments = (
    payments_df["payment_status"].str.strip().str.lower() == "paid"
).sum()

failed_payments = (
    payments_df["payment_status"].str.strip().str.lower() == "failed"
).sum()

success_rate = (successful_payments / total_payments) * 100

failure_rate = (failed_payments / total_payments) * 100

print("Total payments:", total_payments)

print("Successful payments:", successful_payments)

print("Failed payments:", failed_payments)

print("Payment success rate:", round(success_rate, 2), "%")

print("Payment failure rate:", round(failure_rate, 2), "%")


print("\n--- PAYMENT SUCCESS RATE BY METHOD ---")

payment_method_status = pd.crosstab(
    payments_df["payment_method"],
    payments_df["payment_status"]
)

print(payment_method_status)

print("\n--- PAYMENT SUCCESS PERCENTAGE BY METHOD ---")

payment_method_status["Success_Rate"] = (
    payment_method_status["Paid"]
    / payment_method_status.sum(axis=1)
    * 100
).round(2)

print(payment_method_status[["Success_Rate"]].sort_values(
    by="Success_Rate",
    ascending=False
))



print("\n--- LOADING CUSTOMER DATA ---")

customers_path = "../02_Excel/customers_cleaned.xlsx"

customers_df = pd.read_excel(customers_path)

print("Customer data shape:", customers_df.shape)

print("Customer columns:")
print(customers_df.columns.tolist())

print("\nFirst 5 customer records:")
print(customers_df.head())


print("\n--- CUSTOMER DATA QUALITY CHECK ---")

print("\nMissing values:")
print(customers_df.isnull().sum())

print("\nDuplicate rows:")
print(customers_df.duplicated().sum())

print("\nDuplicate customer IDs:")
print(customers_df["customer_id"].duplicated().sum())

print("\nCustomer city count:")
print(customers_df["city"].value_counts())

print("\nCustomer gender count:")
print(customers_df["gender"].value_counts())

print("\n--- TOP 10 CUSTOMERS BY TOTAL RIDES ---")

customer_ride_counts = (
    rides_df.groupby("customer_id")
    .size()
    .reset_index(name="total_rides")
)

top_10_customers = customer_ride_counts.merge(
    customers_df,
    on="customer_id",
    how="left"
)

top_10_customers = top_10_customers.sort_values(
    by="total_rides",
    ascending=False
).head(10)

print(
    top_10_customers[
        ["customer_id", "customer_name", "city", "total_rides"]
    ].to_string(index=False)
)


print("\n--- TOP 10 CUSTOMERS BY REVENUE ---")

customer_revenue = (
    rides_df.groupby("customer_id")["fare_amount"]
    .sum()
    .round(2)
    .reset_index(name="total_revenue")
)

top_10_revenue_customers = customer_revenue.merge(
    customers_df,
    on="customer_id",
    how="left"
)

top_10_revenue_customers = top_10_revenue_customers.sort_values(
    by="total_revenue",
    ascending=False
).head(10)

print(
    top_10_revenue_customers[
        ["customer_id", "customer_name", "city", "total_revenue"]
    ].to_string(index=False)
)


print("\n--- CITY-WISE CUSTOMER AND RIDE ANALYSIS ---")

city_customer_summary = (
    customers_df.groupby("city")
    .agg(
        total_customers=("customer_id", "nunique")
    )
    .reset_index()
)

city_rides = rides_df.merge(
    customers_df[["customer_id", "city"]],
    on="customer_id",
    how="left"
)

city_ride_summary = (
    city_rides.groupby("city")
    .agg(
        total_rides=("ride_id", "count"),
        total_fare=("fare_amount", "sum")
    )
    .round(2)
    .reset_index()
)

city_summary = city_customer_summary.merge(
    city_ride_summary,
    on="city",
    how="left"
)

city_summary = city_summary.sort_values(
    by="total_rides",
    ascending=False
)

print(city_summary.to_string(index=False))


print("\n--- CITY-WISE RIDE STATUS ANALYSIS ---")

city_status = rides_df.merge(
    customers_df[["customer_id", "city"]],
    on="customer_id",
    how="left"
)

city_status_summary = pd.crosstab(
    city_status["city"],
    city_status["ride_status"]
)

print(city_status_summary)

print("\n--- CITY-WISE CANCELLATION RATE ---")

cancelled_statuses = [
    "Cancelled by Customer",
    "Cancelled by Driver",
    "No Driver Found"
]

city_status["is_cancelled"] = city_status["ride_status"].isin(
    cancelled_statuses
)

city_cancellation = (
    city_status.groupby("city")
    .agg(
        total_rides=("ride_id", "count"),
        cancelled_rides=("is_cancelled", "sum")
    )
)

city_cancellation["cancellation_rate"] = (
    city_cancellation["cancelled_rides"]
    / city_cancellation["total_rides"]
    * 100
).round(2)

print(
    city_cancellation.sort_values(
        by="cancellation_rate",
        ascending=False
    ).to_string()
)


print("\n--- DRIVER-WISE CANCELLATION ANALYSIS ---")

driver_rides = rides_df.merge(
    drivers_df[["driver_id", "driver_name"]],
    on="driver_id",
    how="left"
)

driver_rides["is_cancelled"] = driver_rides["ride_status"].isin([
    "Cancelled by Customer",
    "Cancelled by Driver",
    "No Driver Found"
])

driver_cancellation = (
    driver_rides.groupby(["driver_id", "driver_name"])
    .agg(
        total_rides=("ride_id", "count"),
        cancelled_rides=("is_cancelled", "sum")
    )
)

driver_cancellation["cancellation_rate"] = (
    driver_cancellation["cancelled_rides"]
    / driver_cancellation["total_rides"]
    * 100
).round(2)

driver_cancellation = driver_cancellation.sort_values(
    by="cancellation_rate",
    ascending=False
)

print(driver_cancellation.head(10).to_string())


print("\n--- TOP 10 DRIVERS BY REVENUE ---")

driver_revenue = rides_df.merge(
    drivers_df[["driver_id", "driver_name"]],
    on="driver_id",
    how="left"
)

driver_revenue_summary = (
    driver_revenue.groupby(["driver_id", "driver_name"])
    .agg(
        total_rides=("ride_id", "count"),
        total_fare=("fare_amount", "sum")
    )
    .round(2)
    .reset_index()
)

driver_revenue_summary = driver_revenue_summary.sort_values(
    by="total_fare",
    ascending=False
).head(10)

print(driver_revenue_summary.to_string(index=False))


print("\n--- EXPORTING PYTHON ANALYSIS REPORT ---")

output_path = "../04_Python/Ride_Analytics_Python_Report.xlsx"

with pd.ExcelWriter(output_path, engine="openpyxl") as writer:

    payment_summary.to_excel(
        writer, sheet_name="Payment_Method", index=True
    )

    payment_status_summary.to_excel(
        writer, sheet_name="Payment_Status", index=True
    )

    monthly_comparison.to_excel(
        writer, sheet_name="Monthly_Trend", index=True
    )

    city_summary.to_excel(
        writer, sheet_name="City_Analysis", index=False
    )

    driver_performance.to_excel(
        writer, sheet_name="Driver_Ratings", index=False
    )

    driver_revenue_summary.to_excel(
        writer, sheet_name="Driver_Revenue", index=False
    )

print("Python analysis report exported successfully!")
print("Saved at:", output_path)


print("\n--- CHECKING EXTRA CUSTOMER COLUMN ---")

print("Unnamed: 6 column values:")
print(customers_df["Unnamed: 6"].head(10))

print("\nMissing values in this column:")
print(customers_df["Unnamed: 6"].isnull().sum())

print("\nTotal customer rows:")
print(len(customers_df))


print("\n--- CHECKING NON-EMPTY CUSTOMER VALUES ---")

print(
    customers_df.loc[
        customers_df["Unnamed: 6"].notna(),
        ["customer_id", "Unnamed: 6"]
    ]
)

print("\n--- CHECKING CUSTOMER 10002 ---")

print(
    customers_df.loc[
        customers_df["customer_id"] == 10002
    ].to_string(index=False)
)

print("\n--- CLEANING CUSTOMER DATA ---")

customers_df = customers_df.drop(
    columns=["Unnamed: 6"]
)

print("Updated customer data shape:", customers_df.shape)

print("Updated customer columns:")
print(customers_df.columns.tolist())

print("\n--- FINAL PYTHON REPORT EXPORT ---")

report_tables = {
    "Payment_Method": "payment_summary",
    "Payment_Status": "payment_status_summary",
    "Monthly_Trend": "monthly_comparison",
    "City_Analysis": "city_summary",
    "Driver_Ratings": "driver_performance",
    "Driver_Revenue": "driver_revenue_summary",
    "Customer_Rides": "customer_ride_counts",
    "Customer_Revenue": "customer_revenue",
    "Vehicle_Analysis": "vehicle_summary",
    "City_Cancellations": "city_cancellation",
    "Driver_Cancellations": "driver_cancellation",
}

output_path = "../04_Python/Ride_Analytics_Python_Report.xlsx"

with pd.ExcelWriter(output_path, engine="openpyxl") as writer:
    for sheet_name, variable_name in report_tables.items():
        if variable_name in globals():
            table = globals()[variable_name]

            if isinstance(table, (pd.DataFrame, pd.Series)):
                table.to_excel(writer, sheet_name=sheet_name)
                print(sheet_name, "exported")

print("\nFinal Python report exported successfully!")
print("Saved at:", output_path)