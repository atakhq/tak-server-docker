#!/bin/bash

# Added for 4.7 REL 18 where they broke DB auth
#sed -i 's/127.0.0.1\/32/0.0.0.0\/0/g' /opt/tak/db-utils/pg_hba.conf

if [ -f "/var/lib/postgresql/data/postgresql.conf" ];
then
	echo "-------DB Exists-------"
	rm -f /var/lib/postgresql/data/postmaster.pid
	echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf
	cp /opt/tak/db-utils/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
	su - postgres -c "/usr/lib/postgresql/14/bin/pg_ctl -D /var/lib/postgresql/data -l logfile start -o '-c max_connections=2100 -c shared_buffers=2560MB'"

else

	echo "-------NO DB-------"
	chown postgres:postgres /var/lib/postgresql/data
	su - postgres -c '/usr/lib/postgresql/14/bin/pg_ctl initdb -D /var/lib/postgresql/data'
	cp /opt/tak/db-utils/pg_hba.conf /var/lib/postgresql/data/pg_hba.conf
	su - postgres -c "/usr/lib/postgresql/14/bin/pg_ctl -D /var/lib/postgresql/data -l logfile start -o '-c max_connections=2100 -c shared_buffers=2560MB'"	

	cd /opt/tak/db-utils
	./configure.sh
fi


tail -f /dev/null
