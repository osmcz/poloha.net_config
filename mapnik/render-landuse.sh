rm -rf ~/mod_tile/tiles/landuse/1[5-9]/*
rm -rf ~/mod_tile/tiles/landuse/20/*
tirex-batch -p 4 map=landuse bbox=12.09,48.55,18.87,51.06 z=12-14
