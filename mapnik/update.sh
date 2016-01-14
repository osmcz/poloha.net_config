if [ ! -f ~/in/lock ]
then
    if [ -f ~/in/changes.osc.gz ]
    then
     touch ~/in/lock
     osm2pgsql -d pedro -U mapnik -S default.style  -I --append -H localhost  --number-processes 1 --disable-parallel-indexing -p "cz" -s ~/in/changes.osc.gz && \
     if [ `stat --printf="%s" ~/in/changes.osc.gz` -gt "1000" ]
     then
	echo "select gis.clean_deleted();"|psql
        psql -f kct.sql && \
        rm -rf ~/mod_tile/tiles/default/1[6-9]/*
        rm -rf ~/mod_tile/tiles/default/20/*
        rm -rf ~/mod_tile/tiles/kct/[7-9]/*
        rm -rf ~/mod_tile/tiles/kct/1[0-9]/*
        rm -rf ~/mod_tile/tiles/kct/20/*
        echo "refresh materialized view concurrently rozbite_relace;"|psql
        echo "update import.datatimestamp set osm = (select max(closed_at) from osm.changesets);"|psql
	tirex-batch -p 3 map=kct bbox=12.09,48.55,18.87,51.06 z=7-13
	(exec ~/autodirty.sh)
	sleep 250
        echo "select ruian.buildings_todo();"|psql && \
        ~/render-todo.sh
     fi
    fi
    rm -f ~/in/changes.osc.gz ~/in/lock
fi
