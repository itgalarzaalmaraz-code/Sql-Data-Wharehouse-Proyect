# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀
This project showcases an end-to-end **data engineering and analytics solution**, covering everything from designing and building a Data Warehouse to analyzing data and generating **valuable insights for decision-making**.
Developed as a **portfolio project**, it demonstrates the use of industry-standard practices and methodologies in the fields of **Data Engineering and Data Analytics**.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
//Añadire imagen

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

---

## 🛠️ Important Links & Tools:

Everything is for Free!
- **[Datasets](datasets/):** Access to the project dataset (csv files).
- **[Dbeaver Management Tool](https://dbeaver.io/download/):** GUI for managing, querying, and interacting with SQL databases.
- **[DrawIO](https://www.drawio.com/):** Design data architecture, models, flows, and diagrams.
- **[Notion Project Steps]():** Access the project template and documentation on Notion.

---

## 📂 Repository Structure
```
data-warehouse-project/
│
├── datasets/                           # Raw datasets used for the project (ERP and CRM data)
│   ├── source_crm/                     # CRM source: customers, products, sales details
│   └── source_erp/                     # ERP source: customer birthdates and gender, locations, product categories
│
├── docs/                               # Project documentation and architecture details
│   ├── data_architecture.png           # The project's architecture (bronze, silver, gold)
│   ├── data_flow.png                   # Data flow diagram
│   ├── data_integration.png            # How the source tables relate to each other
│   ├── data_model.png                  # Data model (star schema)
│   ├── ETL.png                         # The ETL techniques and methods used
│   ├── data_catalog.md                 # Catalog of the gold layer, field descriptions and metadata
│   └── naming_conventions.md           # Consistent naming guidelines for tables, columns, and files
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── init_database.sql               # Creates the database and the three schemas
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   └── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Quality checks for the silver and gold layers
│
├── README.md                           # Project overview and instructions
├── LICENSE                             # License information for the repository
└── .gitignore                          # Files and directories to be ignored by Git
```
---

## ☕ Stay Connected

Let's stay in touch! Feel free to connect with me on the following platforms:

[![YouTube](https://img.shields.io/badge/YouTube-red?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@DataBy_Galarza)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/alvaro-santiago-galarza-almaraz-6a783039a)
[![Instagram](https://img.shields.io/badge/Join-E1306C?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/databy_galarza?stkn=MWJjYW1qZnJidXN1ag==)
[![Tik Tok](https://img.shields.io/badge/Website-000000?style=for-the-badge&logo=tiktok&logoColor=white)](https://www.tiktok.com/@itgalarzaalmaraz?_r=1&_t=ZS-9ADiVftFom8)

If you want to fully understand how this project works, I have prepared this SQL course containing everything you need to master the concepts used here.

- ✅ **Curso de SQL desde 0 para Datos:** [Course Link](https://youtu.be/CCCzhFR0las?si=bLzV4u6z9S4nf73V) | [GIT Repo](https://github.com/itgalarzaalmaraz-code/postgresql-data)

