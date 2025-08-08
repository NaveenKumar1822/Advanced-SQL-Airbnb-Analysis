# Advanced SQL Analysis of Airbnb Market Data 🏡

## Project Overview

This project performs a comprehensive analysis of an Airbnb dataset using **MySQL** to answer 15 distinct business questions. The primary objective is to transform raw listing data into actionable insights for strategic decision-making. The analysis explores inventory distribution, market segmentation, host performance, and pricing strategies across different New York City boroughs.

The project workflow involved creating a normalized database schema, importing the dataset, and executing a series of structured SQL queries grouped into three categories: **Descriptive Analytics**, **Performance & Market Analysis**, and **Advanced & Strategic Insights**.

-----

## Database Schema & Data

The dataset was normalized into a relational database schema to ensure data integrity and query efficiency. The schema consists of three primary tables:

  * **`hosts`**: Contains unique information for each host, including `host_id` and `host_name`.
  * **`neighbourhoods`**: Stores geographical data, including `neighbourhood` and `neighbourhood_group` (borough).
  * **`listings`**: The core table containing detailed information for each property, such as `price`, `room_type`, `number_of_reviews`, and `availability_365`. It is linked to the other two tables via foreign keys.

Data was loaded into the MySQL database using the **Table Data Import Wizard** in MySQL Workbench.

### Schema Diagram

*The relational schema consists of three normalized tables: `hosts`, `neighbourhoods`, and the central `listings` table, which is linked via foreign keys.*

-----

## Technologies Used

  * **Database**: `MySQL`
  * **IDE**: `MySQL Workbench`
  * **Data Import**: `MySQL Table Data Import Wizard`
  * **Version Control**: `Git & GitHub`

-----

## Project Structure

The repository is organized as follows:

```
├── sql_script/
│   └── Airbnb_Listings_Analysis.sql
├── data/
│   ├── hosts.csv
│   ├── neighbourhoods.csv
│   └── listings.csv
├── assets/
│   └── schema_diagram.png
└── README.md
```

  * **`sql_script/`**: Contains the complete SQL script with all schema creation and analysis queries.
  * **`data/`**: Contains the raw `.csv` files used for this project.
  * **`assets/`**: Contains visual assets for the project, such as the ERD schema diagram.
  * **`README.md`**: This file, providing a complete overview of the project.

-----

## SQL Queries & Analysis

The 15 queries are structured to build a narrative, starting from broad descriptive metrics and moving toward specific, strategic insights.

### 📊 Descriptive Analytics & Inventory Reporting

| \#   | Query Title                                       | Key SQL Concepts Used                       | Insights                                                                                                                                                             |
| :-- | :------------------------------------------------ | :------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Listing distribution in 'Brooklyn'                | `JOIN`, `COUNT`, `GROUP BY`, `WHERE`        | Williamsburg leads with the highest number of listings, followed closely by Bedford-Stuyvesant. These neighborhoods are high-demand markets but also highly competitive for hosts. |
| 2   | Listing count by room type                        | `COUNT`, `GROUP BY`                         | "Entire home/apt" dominates the market share, followed by "Private room". This shows guests prefer full property rentals over shared spaces.                            |
| 3   | Mid-tier listings ($150–$250)                       | `JOIN`, `BETWEEN`, `ORDER BY`               | Mid-tier properties are concentrated mainly in Manhattan and Brooklyn, reflecting strong demand from budget-conscious tourists seeking prime locations.                      |
| 4   | Hosts with a single property                      | `JOIN`, `WHERE`                             | The majority of hosts manage only one listing, suggesting that Airbnb in this dataset is primarily made up of small, individual property owners rather than large-scale operators. |
| 5   | Listings reviewed since June 2019                 | `JOIN`, `WHERE` (Date filtering)            | A large proportion of active listings have received reviews after June 2019, indicating continued demand and host engagement post that date.                             |

### 📈 Performance & Market Analysis

| \#   | Query Title                                   | Key SQL Concepts Used                   | Insights                                                                                                                                               |
| :-- | :-------------------------------------------- | :-------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------- |
| 6   | Avg. availability in Queens vs. Manhattan     | `JOIN`, `AVG`, `GROUP BY`, `IN`         | Manhattan listings show slightly lower annual availability than Queens, hinting at higher occupancy rates and more consistent bookings in Manhattan.       |
| 7   | Top 5 hosts by total reviews                  | `Subquery`, `SUM`, `ORDER BY`, `LIMIT`  | The top hosts have accumulated thousands of reviews across multiple properties, showing professional-scale operations with consistently high booking turnover. |
| 8   | Listings with zero reviews                    | `COUNT`, `WHERE`                        | A significant number of listings have zero reviews, pointing to either newly added properties or those struggling to attract guests.                     |
| 9   | Neighborhood with the most 'Entire home/apt'  | `JOIN`, `COUNT`, `GROUP BY`, `LIMIT`    | Bedford-Stuyvesant has the highest concentration of entire property rentals, making it a hotspot for travelers seeking privacy.                          |
| 10  | Average price by borough                      | `JOIN`, `AVG`, `GROUP BY`, `ORDER BY`   | Manhattan commands the highest average nightly rate, followed by Brooklyn, confirming its premium positioning in the market.                           |

### 💡 Advanced & Strategic Insights

| \#   | Query Title                                          | Key SQL Concepts Used                                   | Insights                                                                                                                                                           |
| :-- | :--------------------------------------------------- | :------------------------------------------------------ | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 11  | Listings priced above neighborhood average           | `JOIN`, `Subquery` in `WHERE` clause                    | Premium listings are clustered in tourist-heavy neighborhoods, indicating that location strongly drives the ability to charge higher-than-average prices.           |
| 12  | Listings with above-average reviews per month        | `CTE`, `Window Functions` (`AVG`, `RANK`)               | Certain private room listings outperform their category in review velocity, suggesting exceptional guest experience or competitive pricing.                          |
| 13  | Availability of high-volume vs. low-volume listings  | `CASE`, `AVG`, `MIN/MAX`, `GROUP BY`                    | Listings with over 100 reviews tend to have higher annual availability, reflecting strong occupancy and efficient turnover management.                               |
| 14  | Ranked list of neighborhoods by average price        | `CTE`, `Window Functions` (`RANK`), `AVG`               | SoHo and Tribeca consistently rank at the top within Manhattan, showcasing ultra-premium micro-markets within already expensive boroughs.                           |
| 15  | Identifying "Power Hosts"                            | `CTE`, `ROW_NUMBER`, `AVG`, `COUNT`, `HAVING`           | A small elite group of hosts meets the “Power Host” criteria, managing multiple high-performing listings with strong review counts and year-round availability.       |

-----

## Final Findings & Recommendations

The analysis uncovered several key trends that can inform business strategy:

  * **Market Dominance**: Manhattan and Brooklyn are the dominant boroughs, not only in listing volume but also in commanding higher average prices. Manhattan has the highest average listing price overall.
  * **Inventory Composition**: "Entire home/apt" is the most common room type and a key driver of the market. Bedford-Stuyvesant has the highest concentration of this room type.
  * **Host Performance is Key**: A small segment of "Power Hosts" who manage multiple, highly-rated properties can be identified through composite metrics. These hosts are valuable assets for maintaining quality and occupancy.
  * **Occupancy & Reviews**: There is a discernible difference in annual availability between listings with many reviews and those with few, suggesting that popular listings have higher occupancy rates.
  * **Actionable Segments**: The ability to isolate listings with zero reviews or single-property hosts allows for targeted engagement strategies, such as offering support to new hosts or running promotions for underperforming listings.

**Recommendation**: Focus business development on supporting hosts in high-value neighborhoods like those in Manhattan. Develop a "Power Host" program to reward top performers and create a mentorship system where they can guide new hosts or those with underperforming listings.

-----

## How to Run This Project

To replicate this analysis on your local machine, please follow these steps:

1.  **Clone the Repository**

    ```sh
    git clone https://github.com/your-username/your-repo-name.git
    cd your-repo-name
    ```

2.  **Set Up the Database**

      * Open MySQL Workbench and connect to your database instance.
      * Open the `sql_script/Airbnb_Listings_Analysis.sql` file.
      * Execute the `CREATE DATABASE` and `CREATE TABLE` statements from the script to set up the schema.

3.  **Import Data**

      * In MySQL Workbench, right-click on each table (`hosts`, `neighbourhoods`, `listings`) in the Navigator pane.
      * Select the **Table Data Import Wizard**.
      * Navigate to the corresponding `.csv` file in the `data/` folder and follow the wizard's steps to import the data into each table.

4.  **Run the Analysis Queries**

      * With the schema set and data imported, execute the 15 analysis queries from the `Airbnb_Listings_Analysis.sql` script to see the results.

-----

## Contact Information

  * **Name**: Naveen Kumar K
  * **LinkedIn**: `https://www.linkedin.com/in/naveen840/`
  * **GitHub**: `https://github.com/NaveenKumar1822`