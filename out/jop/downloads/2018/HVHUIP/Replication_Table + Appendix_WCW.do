set more off
#delimit;


*************************************************************************
*																		*
*																		*
*					Replication Do File for								*
*		"Natural Resource Exploitation and Sexual Violence              *
*                        by Rebel Groups"		                        *
*	Beth Elise Whitaker, Justin Conrad and James Igoe Walsh         	*
*						Journal of Politics             				*
*																		*
*																		*
*************************************************************************;


*TABLE 1;

ologit hrw_prev1 anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit hrw_prev1 extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 anystrategy abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 extortion smuggling abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);

*APPENDIX;
tab anystrategy if e(sample);
tab extortion if e(sample);
tab smuggling if e(sample);

tab cannabis_extortion if e(sample);
tab cannabis_smuggling if e(sample);
tab coca_extortion if e(sample);
tab coca_smuggling if e(sample);
tab diamondsalluvial_extortion if e(sample);
tab diamondsalluvial_smuggling if e(sample);
tab drugs_extortion if e(sample);
tab drugs_smuggling if e(sample);
tab gems_extortion if e(sample);
tab gems_smuggling if e(sample);
tab opium_extortion if e(sample);
tab opium_smuggling if e(sample);
tab timber_extortion if e(sample);
tab timber_smuggling if e(sample);

*BIVARIATE;
ologit hrw_prev1 anystrategy;
ologit hrw_prev1 extortion;
ologit hrw_prev1 smuggling;

ologit state_prev1 anystrategy;
ologit state_prev1 extortion;
ologit state_prev1 smuggling;

*GROUP STRENGTH;
ologit hrw_prev1 extortion smuggling rebest relativestrength orgcapacity abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 extortion smuggling rebest relativestrength orgcapacity abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);

*HIGH CERTAINTY;
ologit hrw_prev1 anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp  if certain==1 & certains==1, robust cluster(dyadid);
ologit hrw_prev1 extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp if certain==1 & certains==1, robust cluster(dyadid);
ologit state_prev1 anystrategy abduction forcedrecruit external_exists tc pop polity2 lngdp if certain==1 & certains==1, robust cluster(dyadid);
ologit state_prev1 extortion smuggling abduction forcedrecruit external_exists tc pop polity2 lngdp if certain==1 & certains==1, robust cluster(dyadid);

*CIVILIAN DEATHS;
ologit hrw_prev1 fat_best anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit hrw_prev1 fat_best extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 fat_best anystrategy abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 fat_best extortion smuggling abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);

*CIVILIAN DEATHS AS DV;
reg fat_best anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
reg fat_best extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);

*INTERACTION;
ologit hrw_prev1 i.extortion##i.smuggling  abduction forcedrecruit external_exists tc pop 
polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 i.extortion##i.smuggling  abduction forcedrecruit external_exists tc pop 
polity2 lngdp, robust cluster(dyadid);

*COUNT OF ACTIVITIES;
ologit hrw_prev1 extortioncount smugglingcount  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 extortioncount smugglingcount abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);

*LAGGED DV;
ologit hrw_prev1 hrw_prev anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit hrw_prev1 hrw_prev extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 state_prev anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
ologit state_prev1 state_prev extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);

*REMOVE DRC, SL, & LIBERIA;
ologit hrw_prev1 anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp if gwnoa!=490 & gwnoa!=450 & gwnoa!=451, robust cluster(dyadid);
ologit hrw_prev1 extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp if gwnoa!=490 & gwnoa!=450 & gwnoa!=451, robust cluster(dyadid);
ologit state_prev1 anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp if gwnoa!=490 & gwnoa!=450 & gwnoa!=451, robust cluster(dyadid);
ologit state_prev1 extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp if gwnoa!=490 & gwnoa!=450 & gwnoa!=451, robust cluster(dyadid);

*BINARY DV;
logit hrw_collapse1 anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
logit hrw_collapse1 extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
logit state_collapse1 anystrategy  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);
logit state_collapse1 extortion smuggling  abduction forcedrecruit external_exists tc pop polity2 lngdp, robust cluster(dyadid);

log close;
exit;
