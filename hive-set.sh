# install SQL
sudo apt-get update
sudo apt-get install mysql-server
service mysql start
# service mysql stop
sudo netstat -tap | grep mysql
mysql -u -root -p

# username&password
# host     = localhost
# user     = debian-sys-maint
# password = QdgqO*******

# reset the count/pw
>GRANT ALL PRIVILEGES ON *.* TO 'zkx'@'localhost' IDENTIFIED BY'pw' WITH GRANT OPTION;

# download mysql jdbc
tar -zxvf 
cp
# initial the dataBase
schematool -dbType mysql -initSchema
# dump -uhive -phive hive > /home/zkx/sda2/my_backup.sql
# drop database hive;
# create database hive;

hive
# run the script
hive -f script.q

# add a little table
echo 'x' > /home/zkx/data/dummy.txt
hive -e "create TABLE dummy (value STRING);
load DATA LOCAL INPATH '/home/zkx/data/dummy.txt' OVERWRITE INTO TABLE dummy"

hive -e 'SELECT * FROM dummy'
>show tables
>exit
