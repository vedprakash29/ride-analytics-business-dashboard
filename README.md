# Ride Analytics & Business Performance Dashboard

## 📌 Project Overview

An end-to-end Data Analytics project built to analyze ride bookings, revenue, cancellations, customers, drivers, vehicles, locations, and payment performance.

The project demonstrates data cleaning, data modeling, DAX-based KPI creation, interactive dashboard development, and business insight generation using Excel and Power BI.

---

## 🎯 Business Objective

The main objectives of this project are:

- Analyze overall ride performance
- Track completed and cancelled rides
- Measure cancellation rate
- Analyze revenue by city, vehicle type, and payment method
- Identify high-performing vehicle categories
- Analyze driver performance
- Understand customer and operational patterns
- Build an interactive business dashboard

---

## 🛠️ Tools & Technologies

- **Microsoft Excel** — Data cleaning and preparation
- **Power BI** — Data modeling, DAX, visualization, and dashboard
- **SQL** — Data querying and analytical preparation
- **Python** — Planned advanced analysis and data processing

---

## 📂 Dataset

The project contains the following tables:

| Table | Description |
|---|---|
| Customers | Customer master information |
| Drivers | Driver information and ratings |
| Vehicles | Vehicle and driver-vehicle information |
| Locations | City, area, and zone information |
| Rides | Ride transactions, fare, distance, date, and status |
| Payments | Payment method, status, and amount |
| Data Dictionary | Table purpose and grain documentation |

---

## 🧹 Data Cleaning

Data preparation was performed in Excel.

Major cleaning activities included:

- Checking duplicate records
- Checking blank/missing values
- Validating date fields
- Validating Location IDs
- Preparing cleaned versions of the project tables
- Maintaining separate Raw and Cleaned data folders

---

## 🔗 Data Modeling

The Power BI model contains relationships between the major tables:

- Customers → Rides
- Drivers → Rides
- Vehicles → Rides
- Locations → Rides
- Payments → Rides
- Drivers → Vehicles

The Locations table is connected to Rides through the pickup location ID.

---

## 📊 Power BI Dashboard

The dashboard includes:

- KPI cards
- Ride status distribution
- Revenue by pickup city
- Rides by vehicle type
- Revenue by vehicle type
- Ride volume trend
- Rides by customer city
- Driver-wise ride analysis
- Top 10 drivers by average rating
- Cancellation analysis by vehicle type
- Revenue by payment method
- Interactive Date, City, Vehicle Type, and Ride Status filters

---

## 🔑 Key KPIs

| KPI | Value |
|---|---:|
| Total Rides | ~20K |
| Completed Rides | ~17K |
| Cancelled Rides | ~2K |
| Cancellation Rate | 12% |
| Total Revenue | 2.09M |
| Average Fare | 124.36 |
| Average Distance | 7.34 km |
| No Driver Found | 799 |

---

## 💡 Key Business Insights

- **Delhi** is the highest-revenue city in the analyzed dataset.
- **Sedan** is the highest-performing vehicle type by ride volume.
- Sedan generated approximately **697.07K revenue**, the highest among vehicle categories.
- **UPI** is the leading payment method by revenue.
- **Customer cancellations (1,381)** are higher than **driver cancellations (1,025)**.
- The overall cancellation rate is **12%**, highlighting an opportunity to investigate cancellation drivers.

---

## 📈 Business Value

The dashboard can help stakeholders:

- Monitor ride and revenue performance
- Identify high-performing vehicle categories
- Understand cancellation behavior
- Compare city-level performance
- Monitor driver performance
- Identify operational improvement opportunities

---

## 🚀 Future Enhancements

- Perform advanced exploratory analysis using Python
- Add customer segmentation
- Build advanced driver performance metrics
- Analyze cancellation patterns by time and location
- Develop ride-demand prediction
- Develop cancellation-risk prediction
- Automate reporting
- Publish the final project with dashboard screenshots

---

## 👨‍💻 Project Type

**Portfolio Data Analytics Project**

**Focus:** Business Intelligence | Data Analytics | Power BI | Excel | SQL | Python