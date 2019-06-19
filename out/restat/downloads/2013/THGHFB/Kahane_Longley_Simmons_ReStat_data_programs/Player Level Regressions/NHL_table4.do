# delimit ;		

log using NHL_table4.log, replace;	

u NHL_player_data;			


set more off;


****Produces difference in means tests for Table 4****;


ttest c_goalspg,by(usa_can) une;

ttest c_goalspg,by(cze_svk) une;

ttest c_goalspg,by(swe) une;

ttest c_goalspg,by(fin) une;

ttest c_goalspg,by(rus) une;

ttest c_goalspg,by(other) une;

;
;

ttest c_asstspg,by(usa_can) une;

ttest c_asstspg,by(cze_svk) une;

ttest c_asstspg,by(swe) une;

ttest c_asstspg,by(fin) une;

ttest c_asstspg,by(rus) une;

ttest c_asstspg,by(other) une;

;
;

ttest c_pointspg,by(usa_can) une;

ttest c_pointspg,by(cze_svk) une;

ttest c_pointspg,by(swe) une;

ttest c_pointspg,by(fin) une;

ttest c_pointspg,by(rus) une;

ttest c_pointspg,by(other) une;

;
;

ttest c_pmpg,by(usa_can) une;

ttest c_pmpg,by(cze_svk) une;

ttest c_pmpg,by(swe) une;

ttest c_pmpg,by(fin) une;

ttest c_pmpg,by(rus) une;

ttest c_pmpg,by(other) une;

;
;

ttest c_plumipg,by(usa_can) une;

ttest c_plumipg,by(cze_svk) une;

ttest c_plumipg,by(swe) une;

ttest c_plumipg,by(fin) une;

ttest c_plumipg,by(rus) une;

ttest c_plumipg,by(other) une;








 

 

 



