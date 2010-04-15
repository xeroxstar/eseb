Instructions to Import GeoNetMap in MySql

The following article assumes you have already created a database or are planning to import it into an existing database.

1. Copy all the map files into the databases data directory. For example:  c:\mysql\data\db_name

2. Download the MySqlGeoNetMapImport.sql script file and save the file to the current directory.

3. Open a MySql command window, and select the target database. ie Use db_name

4. Run the following command
source MySqlGeoNetMapImport.sql;
