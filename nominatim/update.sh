if [ ! -f ~/in/lock ]
then
    if [ -f ~/in/changes.osc.gz ]
    then
     touch ~/in/lock && \
     ~/Nominatim/utils/update.php --import-diff ~/in/changes.osc.gz && \
     echo "select clean_deleted();"|psql && \
     ~/Nominatim/utils/update.php --osm2pgsql-cache 200 --index && \
     rm -f ~/in/changes.osc.gz ~/in/lock
    fi
fi
