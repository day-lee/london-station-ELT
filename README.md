"""
# 🚇 London Station ELT Project
`E(Extract) -> L(Load) -> T(Transform)`

An automated **ELT pipeline project** utilising Transport for London (TfL) annual station footfall data.

## 📌 Project Objectives
- **Automated Pipeline**: Built a robust data loading and transformation pipeline driven by Python scripts.
- **ELT Architecture Implementation**: Adhered to ELT best practices by loading raw data directly into the database, utilising SQL for all transformation tasks.
- **Data Quality Improvement**: Resolved data anomalies by removing commas (`,`), handling hyphens (`---`) as `NULL`, and safely casting text fields into precise numeric/date types.
- **Containerised Database Environment**: Provisioned and managed a isolated, reliable **PostgreSQL database instance utilising Docker** to ensure consistent environment configuration.
- **Database Management & Verification**: Integrated **DBeaver** as the primary database administration tool to efficiently manage schemas, execute test queries, and verify transformed datasets.

---

## 🏗️ Architecture & Data Pipeline
`Excel Data ─> Python: src/load.py ─> PostgreSQL: Raw Table ─> SQL: Transform ─> PostgreSQL: Cleaned Table`

1. **Extract & Load**: Extracts Excel datasets using Python and loads them wholesale into the PostgreSQL `raw` layer.
   - Utilised `pandas` to programmatically parse and clean complex, multi-row spreadsheet headers.
2. **Transform (SQL-centric)**: 
   - Cleanses special characters and missing entries using `CASE WHEN`, `REPLACE`, and `NULLIF`.
   - Utilises `CTE`, `Self-Join`, and `Window Functions` to impute missing footfall figures for interchange stations and compute final congestion rankings by transport mode.

---

## 📊 Analytical Results 

Below are the top 10 busiest stations under the London Underground (LU) mode, derived through data cleansing and `ROW_NUMBER()` window function partitioning.

```text
 rank | mode | station_name             | Annualised_En/Ex |
------+------+--------------------------+------------------+
    1 | LU   | King's Cross St. Pancras |         73571468 |
    2 | LU   | Waterloo LU              |         70786749 |
    3 | LU   | Tottenham Court Road     |         60813501 |
    4 | LU   | Victoria LU              |         60156525 |
    5 | LU   | Liverpool Street LU      |         60077617 |
    6 | LU   | Paddington TfL           |         57967470 |
    7 | LU   | London Bridge LU         |         56194070 |
    8 | LU   | Stratford                |         53193118 |
    9 | LU   | Oxford Circus            |         52338421 |
   10 | LU   | Bond Street              |         42304231 |
```

---

## 🚀 How to Run

### 1. DB & Docker Setup
Configure your database credentials inside the `.env` file, then launch the Docker containers in the background.
```bash
# Spin up Docker containers
docker compose up -d

# Verify containers are running successfully
docker ps
```

### 2. Virtual Environment Setup
Create an isolated environment and install the required dependencies.
```bash
# Create and activate virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install required libraries
pip install -r requirements.txt 
```

### 3. Run Pipeline (Extract & Load)
Execute the pipeline script by passing the target year as a command-line argument.
```bash
# Run the data loading process for the year 2025
python src/load.py 2025
```

---

## 🛠️ Tech Stack 
- **Language**: Python 
- **Database**: PostgreSQL
- **Infrastructure**: Docker, Docker Compose
- **Tools**: Git
"""
