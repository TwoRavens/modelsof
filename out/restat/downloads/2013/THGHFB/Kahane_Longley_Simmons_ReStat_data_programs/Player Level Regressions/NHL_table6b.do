# delimit ;		

log using NHL_table6b.log, replace;	

u NHL_player_data;			

tsset pid season;

set more off;

drop if namerica==1;



****Regressions for Table 6(b)****;



***no lags***;


**Points per game by Euro players**;

xtreg points_pg rel_euro_shr hhi new_nhl, robust fe;



**Goals per game by Euro playres**;

xtreg goals_pg rel_euro_shr hhi new_nhl, robust fe;



**Assists per game by Euro playres**;

xtreg assists_pg rel_euro_shr hhi new_nhl, robust fe;







***with lags***;


**Points per game by euro players**;

xtreg points_pg l.points_pg rel_euro_shr hhi new_nhl, robust fe;



**Goals per game by euro playres**;

xtreg goals_pg l.goals_pg rel_euro_shr hhi new_nhl, robust fe;


**Assists per game by euro playres**;

xtreg assists_pg l.assists_pg rel_euro_shr hhi new_nhl, robust fe;




