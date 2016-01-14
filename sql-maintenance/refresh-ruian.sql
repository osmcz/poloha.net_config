\set ON_ERROR_STOP on
begin;
refresh MATERIALIZED VIEW ruian.rozbite_budovy_mview;
truncate ruian.rozbite_budovy;
insert into ruian.rozbite_budovy select * from ruian.rozbite_budovy_mview;
refresh MATERIALIZED VIEW ruian.rozbite_budovy_mview with no data;
commit;
select ruian.update_dkm();
analyze ruian.rozbite_budovy;

--select ruian.render_updated();
--select ruian.render_dkm();
--update dkm set new=false where new;

refresh materialized view concurrently ruian.dkm_rss_view;

update import.datatimestamp set ruian = (select max(transakce_od_zapsano) as datum from ruian.hlavicka);
