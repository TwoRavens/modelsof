# delimit ;

log using NHL_table7b.log, replace;	

u NHL_player_data;			

tsset pid season;

set more off;



****Regresssions for Table 7(b)****;


*****GENERATES INTERACTIONS****;

gen i_cze_svk = pct_same*cze_svk;
gen i_swe = pct_same*swe;
gen i_fin = pct_same*fin;
gen i_rus= pct_same*rus;
gen i_other= pct_same*other;
gen i_usa_can = pct_same*usa_can;



***no lags***;

**Points per game**;

xtreg points_pg pct_same i_cze_svk i_swe i_fin i_rus i_other 
 new_nhl, robust fe;



**Goals per game**;

xtreg goals_pg pct_same i_cze_svk i_swe i_fin i_rus i_other 
new_nhl, robust fe;



**Assists per game**;

xtreg assists_pg pct_same i_cze_svk i_swe i_fin i_rus i_other 
new_nhl, robust fe;




***with lags***;

**Points per game**;

xtreg points_pg l.points_pg pct_same i_cze_svk i_swe i_fin i_rus i_other 
new_nhl, robust fe;



**Goals per game**;

xtreg goals_pg l.goals_pg pct_same i_cze_svk i_swe i_fin i_rus i_other 
new_nhl, robust fe;



**Assists per game**;

xtreg assists_pg l.assists_pg pct_same i_cze_svk i_swe i_fin i_rus i_other 
new_nhl, robust fe;







