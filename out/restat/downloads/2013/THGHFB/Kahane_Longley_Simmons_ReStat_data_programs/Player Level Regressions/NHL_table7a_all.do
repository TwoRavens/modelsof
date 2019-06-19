# delimit ;		

log using NHL_table7a_all.log, replace;	

u NHL_player_data;			

tsset pid season;

set more off;



****Regresssions for Table 7(a)****;



*ALL PLAYERS*;



**Points per game**;

xtreg points_pg l.points_pg pct_same  new_nhl, robust fe;


**Goals per game**;

xtreg goals_pg l.goals_pg pct_same  new_nhl, robust fe;


**Assists per game**;

xtreg assists_pg l.assists_pg pct_same  new_nhl, robust fe;







