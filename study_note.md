# 📝 Study Note 
## 1. Setting Up DB Container with Docker and Environment Configuration
- Filled in the database information in the `.env` file.
- Created the `docker-compose.yml` file.
- Launched Docker using `docker compose up -d` and verified the container status with `docker ps`.


## 2. Excel Data DB Loading Script
- Developed an automated script in `load.py` to ingest raw data.
- Utilised `pandas` to exclude unnecessary rows (metadata, final totals, etc.) during the ingestion phase, rename columns, modify filenames, and implement logging.
- Reasons for using a Python script for data loading:
  1. Automation: Can be integrated with scheduling to download files daily from TfL and load raw data into the database.
  2. Scalability: Allows daily or weekly generated data to be ingested into the database with a single command.
  3. Idempotency Guarantee: Implemented a try-except-rollback structure to prevent database corruption.
- In production environments, `Apache Airflow` is typically used as a workflow orchestration tool to manage complex pipeline DAGs (Directed Acyclic Graphs) for Extract, Transform, and Load (ETL/ELT) tasks.
- A DAG structure is a directed acyclic graph that does not cycle, ensuring it never enters an infinite loop. It consists of a graph of interconnected tasks with a clear start, end, and directional flow.
- Advantages: Guarantees task execution order, manages errors, and enables parallel processing.

---
- Extract: In this project, the extraction step relies on manually downloaded Excel files. This will be automated in the future using API fetching.
- OLTP (Online Transaction Processing): Normalisation is mandatory. Since data insertions and modifications occur frequently, the ACID principles must be strictly followed.
- OLAP (Online Analytical Processing): Large-scale data querying is the core focus. Rather than splitting tables and performing JOINs, it is more advantageous to use denormalisation into a single large table or adopt a star schema.


## 3. Data Cleansing and Querying
- Checked for null values or anomalies in the loaded database using SQL queries.
- Analysed the data profile:
  - Duplicate `station_name` values may exist within the same `mode`.
  - Values may need to be backfilled based on the `coverage` column (e.g., when the `mode` is 'LU' but `coverage` indicates '---see LO---' and values are filled with '--').
  - Identified acronyms: LU (London Underground), LO (London Overground), DLR (Docklands Light Railway), TfL Rail: Elizabeth Line.
- Data Type Casting: Converted text columns to numeric types and date formats in `clean_data_type.sql` to generate the `cleaned` table.
- Queried the top 10 busiest London Underground stations in `transform_lu_station_traffic_ranking.sql`.
  - For interchange stations that reference other rows in the coverage column (e.g., '---see LO---'), a self-join was applied to append the missing values.
  - Connected two CTE tables to derive the final results.
  - Used the `row_number()` window function to generate the rankings.

## 4. README Compilation and Wrap-up
- Documented the system architecture.
- Outlined the steps to execute the project.

---
# Korean Version


## 1. 도커로 DB 컨테이너 띄우고 환경설정
- `.env`에 DB 정보 채움
- `docker-compose.yml`을 작성
- `docker compose up -d` 으로 도커 띄우고 `docker ps`로 컨테이너 상태 확인  


## 2. 엑셀 데이터 DB 로딩 스크립트  
- `load.py`에서 원본 로우 데이터 자동 적재 스크립트 작성 
- `pandas`를 이용해 적재 단계에서 불필요한 행(메타데이터, 마지막 총계) 등 제외, 컬럼 이름 수정, 파일 이름 변경, 로깅 
- 로딩을 파이썬 스크립트로 하는 이유 
  1. 자동화: 스케쥴링으로 매일 TfL에서 파일 다운로드 받아 raw data를 DB에 넣게 만들 수 있음
  2. 확장성: 매일, 매주 생성되는 데이터를 명령어 하나로 DB에 넣을 수 있음 
  3. 멱등성 보장: try-except-rollback 구조로 DB가 오염되지 않는 구조를 만들 수 있음 
- 현업에서는 `Apache Airflow`를 이용해 복잡한 파이프라인 DAG(Directed Acyclic Graph) 를 추출, 로드, 변환(ETL/ELT) 작업을 관리하는 워크플로우 오케스트레이션 도구를 사용함 
- DAG 구조는 방향성 비순환 그래프로 순환 하지 않아서 무한 루프에 빠지지 않고 명확한 시작과 끝 방향성이 있는 여러 작업간 연결관계 그래프로 이루어짐. 
- 장점: 작업 순서를 보장하고, 오류를 관리하고, 병렬 처리가 가능하게 함 

---
- Extract: 이 프로젝트에서는 extract는 매뉴얼 다운로드받은 엑셀 파일을 사용함. 추후 API fetch로 다운로드 자동화.
- OLTP (Online Transaction Processing): 정규화 필수, 데이터 추가/수정이 빈번하므로 ACID 원칙 지켜야함 
- `OLAP` (Online Analytical Processing): 대규모 데이터 대량 조회가 핵심. 테이블 쪼개서 JOIN 하지 않고 하나의 큰 테이블로 합쳐두는 역정규화 Denormalisation나 star schema를 쓰는것이 유리함 

## 3. 데이터 정제 및 쿼리
- DB에 적재된 데이터를 보며 널(Null) 값이나 이상한 데이터가 있는지 SQL 쿼리로 확인
- 데이터의 프로파일을 파악함
  - mode에 중복된 station_name이 존재 할 수 있음 
  - coverage를 기준으로 값을 채워줘야 할 수 있음 (e.g. mode LU인데 coverage는 '---see LO---'이고 value 들은 '--'로 채워져있음)
  - 약자 내용 파악: LU (London Underground), LO (London Overground), DLR (Docklands Light Railway), TfL Rail: Elizabeth Line
- 데이터 형변환: `clean_data_type.sql`에서 텍스트를 숫자 타입으로 바꾸고, 데이트 타입으로 변환하여 cleaned 테이블 생성  
- `transform_lu_station_traffic_ranking.sql`에서 런던 언더그라운드 역중 가장 붐비는 역 10개 리스트 쿼리 
  - 환승역은 coverage에서 '---see LO---'처럼 다른 로우 값을 참조해야할 수 있으므로 셀프조인으로 값을 추가해줌 
  - 2개의 CTE 테이블을 연결해 값 도출   
  - 윈도우 함수의 row_number()를 이용해 랭킹을 구해줌 


## 4. 리드미 작성 및 마무리 
- 아키텍처 구조 정리 
- 프로젝트 실행 방법 






