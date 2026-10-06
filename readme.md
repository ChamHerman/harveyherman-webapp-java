<div align="center">

  <img src="./web/assets/images/favicon.png" width="130" alt="HarveyHerman Official Logo" />

  <br />

  <a href="https://git.io/typing-svg">
    <img src="https://readme-typing-svg.demolab.com?font=Roboto+Mono&weight=700&size=22&duration=3000&pause=1000&color=2E7D32&center=true&vCenter=true&width=700&lines=HarveyHerman+E-Commerce+Web+Platform;Enterprise+Java+EE+%26+GlassFish+5.1.0+Architecture;Modern+Furniture+%26+Home+Appliances+Retail;Multi-Role+Customer%2C+Staff+%26+Manager+Portals;Real-Time+Analytics%2C+Orders+%26+Promotions" alt="Typing SVG Banner" />
  </a>

  <p align="center">
    <strong>An enterprise-grade Java EE e-commerce web platform engineered for modern furniture, home living, and household appliances retail, featuring complete member self-service and multi-tiered staff and manager administrative portals.</strong>
  </p>

  <p align="center">
    <a href="./LICENSE"><img src="https://img.shields.io/badge/License-MIT-2E7D32.svg?style=for-the-badge" alt="License: MIT" /></a>
    <a href="https://www.oracle.com/java/"><img src="https://img.shields.io/badge/Java-1.8_(JDK_8)-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white" alt="Java 1.8" /></a>
    <a href="https://javaee.github.io/glassfish/"><img src="https://img.shields.io/badge/GlassFish-5.1.0-FF6600?style=for-the-badge&logo=eclipse-glassfish&logoColor=white" alt="GlassFish 5.1.0" /></a>
    <a href="https://www.mysql.com/"><img src="https://img.shields.io/badge/MySQL-8.4-4479A1?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL 8.4" /></a>
    <a href="https://netbeans.apache.org/"><img src="https://img.shields.io/badge/NetBeans-20%2B-1B6AC6?style=for-the-badge&logo=apache-netbeans-ide&logoColor=white" alt="Apache NetBeans 20+" /></a>
    <a href="https://getbootstrap.com/"><img src="https://img.shields.io/badge/Bootstrap-5-7952CE?style=for-the-badge&logo=bootstrap&logoColor=white" alt="Bootstrap 5" /></a>
  </p>

</div>

---

## 📖 Executive Summary

**HarveyHerman** is an enterprise-grade Java EE e-commerce web application engineered for contemporary home living, furniture, and household appliances. The platform delivers a complete retail lifecycle spanning customer storefront self-service to administrative back-office operations.

The platform is designed around four fundamental architecture pillars:

* **Customer Storefront Experience**: Dynamic product browsing, multi-category faceted filtering, instant keyword search, persistent shopping cart management, voucher redemption at checkout, and self-service order tracking.
* **Dual-Tier Administrative Governance**: Role-Based Access Control (RBAC) separating operational **Staff** duties (item management, order fulfillment lifecycle, promotion configuration) from executive **Manager** oversight (system user provisioning, staff assignment, revenue telemetry, sales reporting).
* **Enterprise Java Web Architecture**: Robust 3-tier MVC model leveraging native **Java Servlets 4.0**, **JavaServer Pages (JSP)**, custom Servlet Filters, and **GlassFish 5.1.0 JNDI Connection Pooling** connected to **MySQL 8.4**.
* **Security & Session Integrity**: Centralized route interception via `AccessFilter`, hashed credentials using `PasswordUtil`, security challenge questions for account recovery, and unified HTTP error dispatching via `web.xml`.

---

## 🛠️ Technology Stack

<div align="center">

### Frontend (Presentation Layer)
![JSP](https://img.shields.io/badge/JSP_2.3-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![JSTL](https://img.shields.io/badge/JSTL_1.2-5382A1?style=for-the-badge&logo=java&logoColor=white)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![Sass/SCSS](https://img.shields.io/badge/SCSS-CC6699?style=for-the-badge&logo=sass&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript_ES6-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Bootstrap](https://img.shields.io/badge/Bootstrap_5-7952CE?style=for-the-badge&logo=bootstrap&logoColor=white)

### Backend & Business Logic (Application Layer)
![Java EE](https://img.shields.io/badge/Java_EE_8-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![Java Servlets](https://img.shields.io/badge/Java_Servlets_4.0-007396?style=for-the-badge&logo=java&logoColor=white)
![DAO Pattern](https://img.shields.io/badge/Architecture-DAO_Pattern-2E7D32?style=for-the-badge)
![Security Filter](https://img.shields.io/badge/Security-AccessFilter_RBAC-D32F2F?style=for-the-badge)
![Session Auth](https://img.shields.io/badge/Auth-Session_Management-1976D2?style=for-the-badge)

### Database & Persistence Layer
![MySQL](https://img.shields.io/badge/MySQL_8.4.4-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![MySQL Workbench](https://img.shields.io/badge/MySQL_Workbench_8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![MySQL Connector/J](https://img.shields.io/badge/MySQL_Connector%2FJ_9.2.0-F29111?style=for-the-badge&logo=mysql&logoColor=white)
![GlassFish JNDI](https://img.shields.io/badge/JNDI-Connection_Pool-FF6600?style=for-the-badge&logo=eclipse-glassfish&logoColor=white)

### Application Server & Tooling
![GlassFish Server](https://img.shields.io/badge/GlassFish_Server_5.1.0-FF6600?style=for-the-badge&logo=eclipse-glassfish&logoColor=white)
![Apache NetBeans](https://img.shields.io/badge/Apache_NetBeans_20%2B-1B6AC6?style=for-the-badge&logo=apache-netbeans-ide&logoColor=white)
![OpenJDK](https://img.shields.io/badge/OpenLogic_OpenJDK-1.8_(JDK_8)-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)

</div>

---

## 🧩 Core System Modules & Features

HarveyHerman is partitioned into functional subsystems serving customers, operational staff, and store managers:

### 1. Item & Catalog Management Module
* **Admin Inventory CRUD**: Add new product items, edit pricing, update descriptions, adjust stock quantities, and upload product showcase images.
* **Customer Product Catalog**: Responsive catalog page (`item.jsp`, `itemDetails.jsp`) featuring multi-category filtering (`Kitchen Appliances`, `Cooking & Bakeware`, `Refrigeration & Cooling`, `Laundry & Cleaning`, `Lighting & Electrical`, `Heating & Air Conditioning`, `Bathroom Essentials`).
* **Real-Time Search & Stock Badges**: Instant keyword lookup by product title or description, dynamic stock quantity status indicators, and sorting controls.

### 2. User Management & Authentication Module
* **Member Registration & Login**: Full customer sign-up workflow (`register.jsp`, `login.jsp`) with real-time input validation, password encryption, and session initialization.
* **Profile Management & Security**: Customer profile editing, password changes, and account recovery with custom security challenge questions (`challengeQuestion.jsp`, `resetPassword.jsp`).
* **Staff & Manager Administration**: Manager portal user provisioning (`ap_user.jsp`, `ap_staff.jsp`), role assignments (`staff` vs `manager`), and soft/hard user account deactivation.

### 3. Order Processing & Shopping Cart Module
* **Shopping Cart System**: Session-backed cart (`cart.jsp`) with asynchronous/synchronous quantity increment, item deletion, subtotal calculations, and cart persistence (`CartDAO`, `CartItemDAO`).
* **Checkout & Payment**: Streamlined checkout pipeline (`checkout.jsp`) capturing shipping addresses, contact info, and payment method selection.
* **Order Tracking & Fulfillment Lifecycle**: Order tracking view for customers (`viewOrders.jsp`) and administrative order status transitions (`ap_order.jsp`: `Pending` ➔ `Processing` ➔ `Shipped` ➔ `Delivered` ➔ `Cancelled`).

### 4. Promotion & Discount Engine
* **Voucher Administration**: Staff/Manager interface (`promotion.jsp`) to configure promotional codes, discount values, minimum purchase requirements, and active date windows.
* **Dynamic Checkout Redemption**: Automatic validation of promotion codes against customer cart values, enforcing minimum spend thresholds and active date eligibility during checkout.

### 5. Analytics & Report Generation Module
* **Manager & Staff Dashboards**: Real-time sales telemetry (`ap_index.jsp`), summary statistics (total revenue, active orders, low-stock alerts, customer volume), and top-selling product breakdowns (`TopSalesServlet`).
* **Sales Report Engine**: Dedicated reporting interface (`generatingReport.jsp`, `salesReport.jsp`, `viewHistoryReport.jsp`) allowing managers to query historical transactions and compute aggregate financial sales reports over custom time periods.

### 6. Web Security & System Infrastructure
* **Access Control Filter (`AccessFilter`)**: Centralized security layer intercepting restricted URLs (`/staff/*`, `/manager/*`, `/user/*`), preventing unauthorized direct JSP access, and enforcing role hierarchy.
* **Centralized Error Routing (`web.xml`)**: Clean error-page mappings for HTTP `404 Not Found`, `405 Method Not Allowed`, `500 Internal Server Error`, and uncaught `java.lang.Throwable` exceptions routing to a styled error view (`/user/errorPage.jsp`).

---

## 🏛️ System Architecture

HarveyHerman follows a standard **3-Tier Enterprise Java Architecture** (Model-View-Controller) running on GlassFish 5.1.0:

```text
harveyherman-webapp-java/
├── web/                                      # Presentation Layer (JSP, HTML5, CSS3, JS, Assets)
│   ├── user/                                 # Customer Storefront (Home, Catalog, Cart, Checkout, Profile)
│   ├── staff/                                # Operational Staff Portal (Item CRUD, Order Processing, Promotions)
│   ├── manager/                              # Executive Manager Portal (User/Staff Admin, Sales Reports, Dashboards)
│   ├── assets/                               # Static Resources (SCSS, compiled CSS, JS libraries, product images)
│   └── WEB-INF/                              # Java EE Deployment Descriptors
│       ├── web.xml                           # Context parameters, session timeouts, error pages, welcome files
│       └── glassfish-web.xml                 # GlassFish runtime properties and JVM compiler target configuration
│
├── src/java/                                 # Business Logic & Data Access Layers
│   ├── controller/                           # Java Servlets & Security Handlers
│   │   ├── AccessFilter.java                 # RBAC Route Interceptor & Session Security
│   │   ├── AddItemsServlet.java              # Inventory & Catalog Management Controllers
│   │   ├── CartServlet.java                  # Cart Mutation & Calculation Controllers
│   │   ├── CheckOutServlet.java              # Order Creation & Payment Controllers
│   │   ├── GeneratingReportServlet.java      # Sales Aggregation & Reporting Controllers
│   │   ├── UserLoginServlet.java             # Customer Authentication & Lifecycle Controllers
│   │   └── StaffLoginServlet.java            # Staff/Manager Administrative Authentication Controllers
│   │
│   └── model/                                # Enterprise Data Entities & Data Access Objects (DAOs)
│       ├── Item.java / ItemDAO.java          # Product Catalog Entities & JDBC Operations
│       ├── Orders.java / OrderDAO.java       # Customer Order & Line Item Operations
│       ├── Cart.java / CartDAO.java          # Shopping Cart Data Persistence
│       ├── Promotion.java / PromotionDAO.java # Promotional Code & Voucher Entities
│       ├── Report.java / ReportDAO.java      # Financial Telemetry & Aggregation DAOs
│       └── UserData.java / UserLoginDAO.java # Customer & Staff Account Entities
│
├── queryTable.sql                            # DDL Script: Database creation, tables, constraints, default admin
├── queryImport.sql                           # DML Script: Canonical product catalog, sample users, promotions
├── HarveyHerman - AMIT3083 Assignment Guidelines.docx # Official visual guide & assignment documentation
└── LICENSE                                   # MIT License
```

---

## ⚡ Quick Start: Full Setup Guide

> 📌 **Important Reference**: Please open **`HarveyHerman - AMIT3083 Assignment Guidelines.docx`** in the repository root for visual screenshots and additional understanding.

### 🌐 Quick Access URLs

| Portal | URL | Description |
|---|---|---|
| **Customer Homepage** | [http://localhost:8080/HarveyHerman/user/index.jsp](http://localhost:8080/HarveyHerman/user/index.jsp) | Public storefront, product catalog, cart & checkout |
| **Admin Portal** | [http://localhost:8080/HarveyHerman/staff/ap_login.jsp](http://localhost:8080/HarveyHerman/staff/ap_login.jsp) | Unified administrative login for Staff and Managers |

---

### Step 1: Software Prerequisites

Install or extract the following software components if they are not already installed on your workstation:

| No | Software Component | Package / File | Action Required |
|:---:|---|---|---|
| **[1]** | **MySQL 8.4.4** | `mysql-8.4.4-winx64.msi` | Install on local system |
| **[2]** | **MySQL Workbench 8.0.41** | `mysql-workbench-community-8.0.41-winx64.msi` | Install on local system |
| **[3]** | **Apache NetBeans IDE** | Version `20` / `20+` | Install IDE |
| **[4.1]** | **JDK 8 (Option A - Manual)** | `jdk-1.8 openlogic.zip` | Extract to `C:/ProgramFiles/java/jdk-8.1`<br>In NetBeans: **Tools** ➔ **Java Platform** ➔ **Add Platform...** ➔ **Java Standard Edition** ➔ Select `jdk-1.8` |
| **[4.2]** | **JDK 8 (Option B - IDE Download)** | NetBeans Built-in | In NetBeans: **Tools** ➔ **Java Platform** ➔ **Add Platform...** ➔ **Download OpenJDK** |
| **[5]** | **MySQL Connector/J 9.2.0** | `mysql-connector-j-9.2.0.zip` | Extract anywhere \| Import when opening our project |
| **[6]** | **GlassFish Server 5.1.0** | `GlassFishServer_5.1.0` | Use this server runtime to execute the project |

---

### Step 2: MySQL Database Setup

#### [1] MySQL Configuration (after installing MySQL 8.4.4)
1. Click **[Next >]** until you reach **[Accounts and Roles]**.
2. **MySQL Root Password**: `root`
3. **Repeat Password**: `root`
4. Click **[Next >]** until you reach **[Apply Configuration]**.
5. Click **[Execute]**.

#### [2] MySQL Workbench Setup
* **If not detected automatically**, add the connection manually:
  1. Click **[+]** next to MySQL Connections.
  2. Set **Connection Name**: `MySQL 8.4.4`.
  3. Set **Username**: `root`.
  4. Set **Password** (Store in vault): `root`.
* **If detected automatically**:
  - Select `Local instance MySQL84`.
* **Execute Schema and Data Scripts**:
  1. Open connection **[MySQL 8.4.4]** / **[Local instance MySQL84]**.
  2. Execute **`queryTable.sql`** (creates `harveyhermandb`, tables, and default manager login data).
  3. Execute **`queryImport.sql`** (imports all default catalog items and promotion data).

---

### Step 3: GlassFish Server Setup

*(Required if configuring a fresh GlassFish instance rather than our pre-configured server)*

#### [1] Server Application Configuration
1. Navigate to: **Domain** ➔ **Application Configuration**
2. Ensure both options are disabled:
   - **Reload**: `[ ]` *(Unchecked)*
   - **Auto Deploy**: `[ ]` *(Unchecked)*

#### [2] Configure JDBC Connection Pool
1. Navigate to: **Resources** ➔ **JDBC** ➔ **JDBC Connection Pools** ➔ **New...**
   - **Pool Name**: `mysql_harveyhermandb_rootPool`
   - **Resource Type**: `javax.sql.DataSource`
   - **Database Driver Vendor**: `MySql`
2. Click **Next** to proceed to **[JDBC Connection Pool Advanced Attributes]**:
   - **Datasource Classname**: `com.mysql.cj.jdbc.MysqlDataSource`
   - **Ping**: `[/]` *(Checked)*
3. Scroll down to **[JDBC Connection Pool Properties]** and enter the following properties *(if a property name is not visible, edit an existing unused property)*:

| Property Name | Value |
|---|---|
| `user` | `root` |
| `password` | `root` |
| `databaseName` | `harveyhermandb` |
| `URL` | `jdbc:mysql://localhost:3306/harveyhermandb?serverTimezone=Asia/Kuala_Lumpur&useSSL=false&allowPublicKeyRetrieval=true` |
| `serverName` | `localhost` |
| `portNumber` | `3306` |

#### [3] Configure JDBC Resource
1. Navigate to: **Resources** ➔ **JDBC** ➔ **JDBC Resources** ➔ **New...**
   - **JNDI Name**: `jdbc/harveyhermandb`
   - **Pool Name**: `mysql_harveyhermandb_rootPool`

#### [4 | IMPORTANT] Import MySQL Connector/J 9.2.0 into Server Library
1. Locate and copy the extracted **`mysql-connector-j-9.2.0.jar`** file inside the `mysql-connector-j-9.2.0` folder.
2. Paste the JAR file directly into your GlassFish domain library folder:
   ```text
   <glassfish-install-dir>\glassfish\domains\<your-domain>\lib\<paste here>
   ```
   *Example path:*
   ```text
   C:\Users\user\Desktop\HarveyHerman\GlassFishServer_5.1.0\glassfish\domains\domain1\lib\mysql-connector-j-9.2.0.jar
   ```

---

### Step 4: NetBeans Project Setup & Launch

Once all prerequisites and server configurations are completed:

1. Confirm that **GlassFish Server 5.1.0** (given or newly configured) is visible under:  
   **NetBeans IDE** ➔ **Services** ➔ **Servers**
2. Open the **`HarveyHerman`** project in NetBeans.
3. Right-click the project and select **Clean and Build** (clears compiled caches and recompiles source classes).
4. Right-click the project and select **Deploy**.
5. Right-click the project and select **Run** (or launch from your browser using the portal URLs above).

---

## 🔑 Default Portal & Test Credentials

The database scripts initialize default administrative and testing accounts:

### Administrative Portals

| Portal | URL | Default Role | Username | Password |
|---|---|---|---|---|
| **Admin Portal** | `http://localhost:8080/HarveyHerman/staff/ap_login.jsp` | **Manager** (`S000`) | `admin` | `admin` |
| **Customer Storefront** | `http://localhost:8080/HarveyHerman/user/index.jsp` | **Member** | *Register or use seeded user* | *Set upon creation* |

> 💡 **Manager Account Note**: The default manager account (`Staff ID: S000`, Email: `manager@harveyherman.my`) has full system clearance to manage staff accounts, view all customer orders, adjust promotions, and generate sales reports.

---

## 👥 Project Team & Contributions
| No. | Team Member | GitHub Profile | Task(s) Completed & Responsibilities | Overall Contribution |
|:---:|---|:---:|---|:---:|
| **1.** | **CHAM HERMAN** | [@ChamHerman](https://github.com/ChamHerman) | **Overall Project Lead & Architecture**<br>• Handled whole project setup, technical management, and module distribution<br>• **Item Module**: End-to-end Item Management (CRUD)<br>• **Member Storefront**: Product Catalog page, Home page, item search, category filtering, product listing, and Add-to-Cart functionality<br>• **Order Module**: View Orders page (Member side)<br>• **Web Configuration**: Centralized `web.xml` (application-wide initialization parameters, context config, and error page routing) | **25%** |
| **2.** | **OOI KAI SHENG** | [@kai-2909](https://github.com/kai-2909) | **Analytics & Promotion Engineering**<br>• **Promotion Module**: Full Promotion & Voucher Management (CRUD), discount code creation, threshold validation, and date window controls<br>• **Manager/Staff Dashboard**: Executive analytics dashboard, sales metrics telemetry, and KPIs<br>• **Report Module**: Complete Sales Report Management (CRUD), aggregate revenue queries, and report generation | **25%** |
| **3.** | **WONG KAI BIN** | [@Kaibin-96](https://github.com/Kaibin-96) | **Order & Fulfillment Engineering**<br>• **Order Module**: Complete Order Management lifecycle (CRUD)<br>• **Cart Page**: Shopping Cart implementation, persistent quantity updates, and subtotal recalculation<br>• **Checkout & Payment**: Checkout page workflow, shipping destination capture, payment processing, and member-side order status tracking | **25%** |
| **4.** | **YEOW WEI KANG** | [@weikang8777](https://github.com/weikang8777) | **User Security & Access Governance**<br>• **Login Module**: Customer authentication, staff/manager login, logout, and session lifecycle<br>• **User Module**: Complete User Management (CRUD), customer registration, profile editing, and security challenge questions<br>• **Manager / Staff Module**: Staff account administration and role provisioning<br>• **Web Security**: Route security interceptor filter (`AccessFilter`), RBAC enforcement, and credential protection | **25%** |

---

## 📄 License

This project is open-source software licensed under the **[MIT License](./LICENSE)**.
