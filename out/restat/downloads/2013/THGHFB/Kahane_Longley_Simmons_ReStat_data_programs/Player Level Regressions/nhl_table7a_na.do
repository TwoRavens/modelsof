# delimit ;		

log using NHL_table7a_na.log, replace;	

u NHL_player_data;			

tsset pid season;

set more off;

drop if namerica==0;


****Regresssions for Table 7(a) North Americans****;



**Points per game**;

xtreg points_pg l.points_pg pct_same  new_nhl, robust fe;


**Goals per game**;

xtreg goals_pg l.goals_pg pct_same  new_nhl, robust fe;


**Assists per game**;

xtreg assists_pg l.assists_pg pct_same  new_nhl, robust fe;





