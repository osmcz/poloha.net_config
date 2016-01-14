if [ ! -f ~/replication/changes.osc.gz ] && [ ! -f ~/replication/lock ] && [ `osmosis -q --read-replication-lag workingDirectory=~/replication/` -gt "0" ]
then
    tirex-rendering-control --stop normal background
    osmosis -q --read-replication-lag humanReadable=yes workingDirectory=~/replication/ && \
    osmosis -q --read-replication-interval workingDirectory=~/replication/  --write-xml-change file=~/replication/changes.osc.gz && \
     touch ~/replication/lock && \
     osmosis -q --read-xml-change file=~/replication/changes.osc.gz enableDateParsing=yes --write-apidb-change validateSchemaVersion="No" host=$PGHOST database=$PGDATABASE user=$PGUSER password=$PGPASSWORD && \
     osmosis -q --replicate-apidb  host=$PGHOST database=$PGDATABASE user=$PGUSER password=$PGPASSWORD allowIncorrectSchemaVersion=yes validateSchemaVersion=no --write-replication workingDirectory=~/replication/out && \
    echo "select import.update_building_source_stat ();"|psql
     cp ~/replication/changes.osc.gz ~/../nominatim/in/ && \
     cp ~/replication/changes.osc.gz ~/../mapnik/in/ && \
     mv ~/replication/changes.osc.gz ~/replication/bak/ && rm ~/replication/lock
    tirex-rendering-control --continue normal background
fi
