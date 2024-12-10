TIME=`date +%F-%H_%M_%S`
DIR="/backup"
PASS="Sxm@325468"
[ -d $DIR ] || { mkdir $DIR }
for DB in $(mysql -uroot -p"$PASS" -e 'show databases' | grep -Ev "^Database$|.*schema$"); do
 mysqldump -uroot -p"$PASS" --single-transaction --master-data=2 --default-character-set=utf8 -q -B "$DB" | gzip > "${DIR}/${DB}_${TIME}.sql.gz"
done
