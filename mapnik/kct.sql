\set ON_ERROR_STOP on
set work_mem='128MB';

-- vytvorime tabuli vsech cest a relaci, ktere maji neco s KCT
create temp table cz_kct_temp as 
  select osm_id,route,name,ref,network,kct_yellow,kct_green,kct_blue,kct_red
  from cz_line where
    kct_yellow is not NULL or kct_green is not NULL or kct_blue is not NULL or kct_red is not NULL or network = 'iwn';
create index cz_kct_temp_id on cz_kct_temp using btree (osm_id);

-- vytvorime tabuli relaci s parts cest
create temp table cz_kct_rels_temp as
  select id,unnest(parts) as parts, NULL::text as route, NULL::text as name, NULL::text as network, NULL::text as ref, NULL::text as kct_yellow, NULL::text as kct_green, NULL::text as kct_blue, NULL::text as kct_red
    from cz_rels where id in (select - osm_id from cz_kct_temp where osm_id < 0);
create index cz_kct_rels_temp_idx on cz_kct_rels_temp using btree(id);
create index cz_kct_rels_temp_parts on cz_kct_rels_temp using btree(parts);

-- tabuli s relacemi oznackujeme kct_* a network ve srozumitelne forme pro BFU (t.j. pro me)
update cz_kct_rels_temp
  set route = x.route,name = x.name,ref = x.ref,network = x.network,kct_yellow = x.kct_yellow,kct_green = x.kct_green,kct_blue = x.kct_blue,kct_red = x.kct_red
  from (
    select osm_id, max(route) as route, max(name) as name, max(ref) as ref, networkmax(network) as network, kctmax(kct_yellow) as kct_yellow, kctmax(kct_green) as kct_green, kctmax(kct_blue) as kct_blue, kctmax(kct_red) as kct_red 
    from cz_kct_temp where osm_id < 0 group by osm_id
   ) as x where id =  - x.osm_id;

-- ted uz nebudeme potrebovat relace v tabuli cest
delete from cz_kct_temp where osm_id < 0;

-- do tabule cest pridame ty cesty, ktere jsou soucasti relace KCT
insert into cz_kct_temp (osm_id,route,name,ref,network,kct_yellow,kct_green,kct_blue,kct_red)
   select parts as osm_id,route,name,ref,network,kct_yellow,kct_green,kct_blue,kct_red
    from cz_kct_rels_temp;

-- procisteni - v parts jsou i jine veci nez cesty
delete from cz_kct_temp where osm_id not in (select osm_id from cz_line) or (kct_yellow is NULL and kct_green is NULL and kct_blue is NULL and kct_red is NULL and network != 'iwn');

-- na zaver to pak nasypat do cz_kct (max, group by) a pridat geometrii
create temp table cz_kct_full (like cz_kct);
insert into cz_kct_full (osm_id,route,name,network,kct_yellow,kct_green,kct_blue,kct_red) select osm_id,max(route) as route, max(name) as name, networkmax(network) as network, kctmax(kct_yellow) as kct_yellow, kctmax(kct_green) as kct_green, kctmax(kct_blue) as kct_blue, kctmax(kct_red) as kct_red from cz_kct_temp group by osm_id;
update cz_kct_full set way = (select way from cz_line where cz_kct_full.osm_id = cz_line.osm_id);
update cz_kct_full set kct_red='international' where network = 'iwn' and kct_red is NULL;

begin;
truncate cz_kct;
insert into cz_kct (select * from cz_kct_full);
commit;
analyze cz_kct;
