rm -rf ~/mod_tile/tiles/adresy/1[5-9]/*
rm -rf ~/mod_tile/tiles/adresy/20/*
rm -rf ~/mod_tile/tiles/budovy/1[5-9]/*
rm -rf ~/mod_tile/tiles/budovy/20/*
rm -rf ~/mod_tile/tiles/ulice/1[5-9]/*
rm -rf ~/mod_tile/tiles/ulice/20/*
rm -rf ~/mod_tile/tiles/parcely/1[5-9]/*
rm -rf ~/mod_tile/tiles/parcely/20/*
tirex-batch -p 5 map=budovy  bbox=12.09,48.55,18.87,51.06 z=12-14
tirex-batch -p 100 map=adresy,ulice,parcely bbox=12.09,48.55,18.87,51.06 z=12-14
