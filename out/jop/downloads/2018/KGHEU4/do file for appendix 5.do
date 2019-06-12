
*results presented in online appendix 5
*data is brawl 2017 for appendix 5

gen male=0
replace male=1 if sex==1
gen pid_blue=0
gen pid_green=0
replace pid_blue=1 if partyid==1
replace pid_green=1 if partyid==2
gen edu_uni=0
gen edu_post=0
replace edu_uni=1 if edu==6
replace edu_post=1 if edu==7
gen area_central=0
gen area_south=0
replace area_central=1 if arear==4
replace area_south=1 if arear==5 | arear==6
gen ethnic_hakka=0
gen ethnic_mainlander=0
replace ethnic_hakka=1 if sengi==1
replace ethnic_mainlander=1 if sengi==3
gen ui_unify=0
gen ui_indep=0
replace ui_unify=1 if tondu==1 | tondu==2
replace ui_indep=1 if tondu==5 | tondu==6
gen identity_taiwanese=0
replace identity_taiwanese=1 if t_cidentity==1
gen career_public=0
gen career_manage=0
gen career_clerk=0
replace career_public=1 if career8==1
replace career_manage=1 if career8==2
replace career_clerk=1 if career8==3
gen pension_kmtbetter=0
gen pension_dppbetter=0
replace pension_kmtbetter=1 if q30==1
replace pension_dppbetter=1 if q30==2
gen infra_kmtbetter=0
gen infra_dppbetter=0
replace infra_kmtbetter=1 if ipq4==1
replace infra_dppbetter=1 if ipq4==2
gen kbetter=q27-q28
gen kbetter2=kbetter*kbetter

*table A5.1
#delimit ;
regress q6_w21 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;
regress q6_w32 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;
regress q22_w21 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;
regress q22_w32 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;

*table A5.2 (remove all control variables);
#delimit ;
regress q6_w21 kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;
regress q6_w32 kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;
regress q22_w21 kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;
regress q22_w32 kbetter kbetter2 if allwaves==1;
test kbetter kbetter2;

*Table A5.4; 
*seemingly unrelated regression;
#delimit ;
sureg (q6_w21 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2) 
   (q6_w32 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2) 
   (q22_w21 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2) 
   (q22_w32 male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2) if allwaves==1; 


*Table A5.3 (interacted model);
*data is brawl 2017 for appendix 5.3;

gen male=0
replace male=1 if sex==1
gen pid_blue=0
gen pid_green=0
replace pid_blue=1 if partyid==1
replace pid_green=1 if partyid==2
gen edu_uni=0
gen edu_post=0
replace edu_uni=1 if edu==6
replace edu_post=1 if edu==7
gen area_central=0
gen area_south=0
replace area_central=1 if arear==4
replace area_south=1 if arear==5 | arear==6
gen ethnic_hakka=0
gen ethnic_mainlander=0
replace ethnic_hakka=1 if sengi==1
replace ethnic_mainlander=1 if sengi==3
gen ui_unify=0
gen ui_indep=0
replace ui_unify=1 if tondu==1 | tondu==2
replace ui_indep=1 if tondu==5 | tondu==6
gen identity_taiwanese=0
replace identity_taiwanese=1 if t_cidentity==1
gen career_public=0
gen career_manage=0
gen career_clerk=0
replace career_public=1 if career8==1
replace career_manage=1 if career8==2
replace career_clerk=1 if career8==3
gen pension_kmtbetter=0
gen pension_dppbetter=0
replace pension_kmtbetter=1 if q30==1
replace pension_dppbetter=1 if q30==2
gen infra_kmtbetter=0
gen infra_dppbetter=0
replace infra_kmtbetter=1 if ipq4==1
replace infra_dppbetter=1 if ipq4==2
gen kbetter=q27-q28
gen kbetter2=kbetter*kbetter

#delimit ;
regress q6change male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese kbetter kbetter2;
g change2=(change-1);
g c2kb=change2*kbetter;
g c2kb2=change2*kbetter2;
#delimit ;
*Table A5.3, model 1;
regress q6change male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese change2 kbetter c2kb if allwaves==1;
*Table A5.3, model 2;
regress q6change male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese change2 kbetter kbetter2 c2kb c2kb2 if allwaves==1;
*Table A5.3, model 3;
regress q22change male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese change2 kbetter c2kb if allwaves==1;
*Table A5.3, model 4;
regress q22change male nage edu_uni edu_post area_central area_south career_public career_manage career_clerk 
   ethnic_hakka ethnic_mainlander ui_unify ui_indep identity_taiwanese change2 kbetter kbetter2 c2kb c2kb2 if allwaves==1;


