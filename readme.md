```markdown
# HarveyHerman - AMIT3083 Assignment Setup Guide

**Homepage**: http://localhost:8080/HarveyHerman/user/index.jsp  
**Admin Portal**: http://localhost:8080/HarveyHerman/staff/ap_login.jsp

------------------------------------------------------------------------------------------------------------------------------------------

[IMPORTANT] Please open [HarveyHerman - AMIT3083 Assignment Guidelines.docx] for visuals and better understanding.

------------------------------------------------------------------------------------------------------------------------------------------

## Software Setup [need to install/extract if don't have]

[1] MySQL 8.4.4  
  `mysql-8.4.4-winx64.msi` <-- Install

[2] MySQL Workbench 8.0.41  
  `mysql-workbench-community-8.0.41-winx64.msi` <-- Install

[3] Apache NetBeans IDE 20/20+  

[4.1] JDK 8  
  `jdk-1.8 openlogic.zip` <-- Extract to `C:/ProgramFiles/java/jdk-8.1`  
  NetBeans IDE → Tools → Java Platform → Add Platform... → Java Standard Edition → Select `jdk-1.8`

[4.2] JDK 8  
  NetBeans IDE → Tools → Java Platform → Add Platform... → Download OpenJDK

[5] MySQL Connector J 9.2.0  
  `mysql-connector-j-9.2.0.zip` <-- Extract to anywhere | Import when opening our project.

[6] GlassFish Server 5.1.0  
  `GlassFishServer_5.1.0` | Use this server to run our project.

------------------------------------------------------------------------------------------------------------------------------------------

## MySQL Database Setup

### [1] MySQL Configuration (after install MySQL 8.4.4)

1. Click [Next >] until [Accounts and Roles]  
2. MySQL Root Password: `root`  
3. Repeat Password: `root`  
4. Click [Next >] until [Apply Configuration]  
5. Click [Execute]

### [2] MySQL Workbench

(if not detected by itself, add by yourself)

1. Click [+] next to MySQL Connections  
2. Connection Name: `MySQL 8.4.4`  
  Username: `root`  
  Password (Store in vault): `root`  

(if detected by itself, choose `Local instance MySQL84`)

3. Click [MySQL 8.4.4] / [Local instance MySQL84]  
4. Execute `queryTable.sql` (included default manager's login data)  
5. Execute `queryImport.sql` (included all default data)

------------------------------------------------------------------------------------------------------------------------------------------

## Server Setup (if not using our given server: [GlassFishServer_5.1.0])

### [1] Server Application Config

1. Domain → Application Configuration  
  Reload: [] <-- Unchecked  
  Auto Deploy: [] <-- Unchecked

### [2] JDBC Connection Pools

1. Resources → JDBC → JDBC Connection Pools → New...  
  Pool Name: `mysql_harveyhermandb_rootPool`  
  Resource Type: `javax.sql.DataSource`  
  Database Driver Vendor: `MySql`

[JDBC Connection Pool Advanced Attributes]

2. Next  
  Datasource Classname: `com.mysql.cj.jdbc.MysqlDataSource`  
  Ping: [/] <-- Checked

[JDBC Connection Pool Properties]

3. Scroll down, input all properties as shown below. If can't see the properties name, may change other unrelated to what u want.

- `user`: `root`  
- `password`: `root`  
- `databaseName`: `harveyhermandb`  
- `URL`: `jdbc:mysql://localhost:3306/harveyhermandb?serverTimezone=Asia/Kuala_Lumpur&useSSL=false&allowPublicKeyRetrieval=true`  
- `serverName`: `localhost`  
- `portNumber`: `3306`

### [3] JDBC Resources

1. Resources → JDBC → JDBC Resources → New...  
  JNDI Name: `jdbc/harveyhermandb`  
  Pool Name: `mysql_harveyhermandb_rootPool`

### [4|IMPORTANT] Import MySQL Connector J 9.2.0 into Server Library

1. Copy the extracted `mysql-connector-j-9.2.0.jar` inside `mysql-connector-j-9.2.0` folder  
2. Paste to:  
  `<glassfish-install-dir>\glassfish\domains\<your-domain>\lib\<paste here>`  

  e.g.  
  `C:\Users\user\Desktop\HarveyHerman\GlassFishServer_5.1.0\glassfish\domains\domain1\lib\<paste here>`

------------------------------------------------------------------------------------------------------------------------------------------

## After done all above setup.

------------------------------------------------------------------------------------------------------------------------------------------

## Project Setup

1. Make sure the correct GlassFish Server 5.1.0 (Given/New Setup) is in NetBeans IDE → Services → Servers  
2. Open `HarveyHerman` project  
3. Clean and build (to clear all caches)  
4. Deploy  
5. Run
```
