#delimit;
clear all;
set more off;
macro drop all;
pause on;
set mem 12g;
set maxvar 30000;
set seed 312483;
set logtype text;
version 10;
pause on;


/**********************************************************************************
***
***	This do-file produces the output for the mixed race kids paper.
*** Datasets used: Add Health, Census, Vital Statistics
***
*** last changes: 01/21/2011 (Iolanda Palmieri)
***
***********************************************************************************/

* CHANGE DIRECTORY;

cd "/replication_archive/";


capture log close;
log using mrkids_LOGFILE, replace;


*----------------------------------------------*

                   Globals

*----------------------------------------------*;

*DATA SOURCES OF VARIABLES TO STANDARDIZE;
global home "ahpvt notsuspendedexpelled propertydamage steal violentacts selldrugs encounteredviolence sex std drugs";
global school "trouble_teacher trouble_payattention trouble_homework trouble_getalong effortschool skipschool watchtv drink smoke dare lietoparents fight momcares dadcares feelclose feelaccepted feelloved notdepressed likeoneself liveto35";

*SUMMARY STAT CATEGORIES;
global Nrace "r_white r_black r_mixed";
global Ndem_school "r_Nfemale r_Nage r_Nbornus r_west r_midwest r_northeast r_south";
global Nhomeenv_home "r_hhincome r_nowelfare r_married r_momage r_momevermarried r_yrsinresidence";
global Nhomeenv_school "r_fatherinhh r_momcolgrad";
global Nphys_home "r_birthweight r_currentweight r_height r_bmi r_std_attractive";
global Nachieve_home "r_nolearndisable r_std_ahpvt r_norepeatgrade";
global Nachieve_school "r_gpa";
global Nbehavinschl_home "r_std_notsuspendedexpelled";
global Nbehavinschl_school "r_std_trouble_teacher r_std_trouble_payattention r_std_trouble_homework r_std_trouble_getalong r_std_effortschool r_std_skipschool";
global Nbehavoutschl_home "r_std_propertydamage r_std_steal r_std_violentacts r_std_selldrugs r_std_encounteredviolence r_std_sex r_std_std r_std_drugs";
global Nbehavoutschl_school "r_std_watchtv r_std_drink r_std_smoke r_std_dare r_std_lietoparents r_std_fight";
global Npsych_school "r_std_momcares r_std_dadcares r_std_feelclose r_std_feelaccepted r_std_feelloved r_std_notdepressed r_std_likeoneself r_std_liveto35";
global Nhome "$Nhomeenv_home $Nphys_home $Nachieve_home $Nbehavinschl_home $Nbehavoutschl_home";
global Nschool "$Ndem_school $Nhomeenv_school $Nachieve_school $Nbehavinschl_school $Nbehavoutschl_school $Npsych_school";


*OUTCOME CATEGORIES;
global homeenv "r_lhhincome r_nowelfare r_fatherinhh r_married r_momage r_momcolgrad r_momevermarried r_yrsinresidence";
global phys "r_birthweight r_height r_bmi r_std_attractive";
global achieve "r_nolearndisable r_std_ahpvt r_gpa r_norepeatgrade";
global behavinschl "r_std_trouble_teacher r_std_trouble_payattention r_std_trouble_homework r_std_trouble_getalong r_std_effortschool r_std_skipschool r_notsuspendedexpelled";
global behavoutschl "r_std_watchtv r_std_drink r_std_smoke r_std_dare r_std_lietoparents r_std_fight r_std_propertydamage r_std_steal r_std_violentacts r_std_selldrugs r_std_encounteredviolence r_sex r_std r_drugs";
global psych "r_std_momcares r_std_dadcares r_std_feelclose r_std_feelaccepted r_std_feelloved r_std_notdepressed r_std_likeoneself r_std_liveto35";
global census_kids "r_lhhincome r_nowelfare r_fatherinhh r_married r_momage r_momcolgrad r_momevermarried r_nomigrate5yrs";
global census_adults "r_married r_children r_bachelors r_employed r_weeksworked r_std_occscore r_lhhincome r_poor r_nomigrate5yrs r_ownhome r_lvaluehouse r_outsidecitycenter r_institute r_disabled";

global badbehav_res "res_trouble_teacher res_trouble_payattention res_trouble_homework res_trouble_getalong res_effortschool res_skipschool res_notsuspendedexpelled res_watchtv res_drink res_smoke res_dare res_lietoparents res_fight res_propertydamage res_steal res_violentacts res_selldrugs res_encounteredviolence res_sex res_std res_drugs";

*RACE;
global race "r_white r_black";
global race_alt "r_black r_mixed";

*CONTROLS;
global gender "r_female r_Mgender";
global gender_v2 "r_female_v2 r_Mgender_v2";
global age "r_age r_age_sq r_Mage";
global age_v2 "r_age_v2 r_age_sq_v2 r_Mage_v2";
global age_v3 "r_age_l13 r_age_15t17 r_age_17plus";
global native "r_bornus r_Mbornus";
global native_v2 "r_bornus_v2 r_Mbornus_v2";
global region "r_midwest r_south r_west r_Mregion";
global income "r_hhincome_l25 r_hhincome_45t65 r_hhincome_65plus r_Mhhincome r_Cnowelfare r_Mnowelfare";
global parents "r_Cfatherinhh r_Mfatherinhh r_Cmarried r_Mmarried r_momage_l35 r_momage_40t45 r_momage_45plus r_Mmomage r_Meducmother r_educmother_collegeplus r_educmother_college r_educmother_somecollege r_educmother_vocschool r_educmother_ged r_educmother_9t12y r_educmother_0t8y r_educmother_noschool r_Cmomevermarried r_Mmomevermarried";
global residence "r_Myrsinresidence r_yrsinresidence_0t2 r_yrsinresidence_2t5 r_yrsinresidence_10plus";
global bweight "r_birthweight_l250 r_birthweight_250t325 r_birthweight_375plus r_Mbirthweight";
global controls_basic "$gender $age_v3 $native $region $income $parents $residence $bweight";
global controls_phys "$gender $age_v3 $native $region $income $parents $residence";
global controls_homeenv "$gender $age_v3 $native $region";
global controls_census_kids "r_female r_age_l13 r_age_13t15 r_age_15t17 r_age_17plus r_bornus";
global controls_census_adults "r_female r_age_18t20 r_age_20t25 r_age_25t30 r_age_30t35 r_age_35t40 r_age_40t45 r_age_45t50 r_age_50t55 r_age_55t60 r_age_60t65 r_age_65t70 r_age_70t75 r_age_75t80 r_age_80plus r_bornus";
global controls_census_adults1 "r_female r_bornus";
*global controls_vitalstat_birth_old "r_female r_Mfemale r_region_west r_region_midwest r_region_south r_foreign_res r_popsize2 r_popsize3 r_popsize4 r_popsize5 r_popsize6 r_mevermarr r_educmother_0t8y r_educmother_9t12y r_educmother_hschool r_educmother_somecollege r_educmother_college r_Meducmother r_mage16t20 r_mage21t25 r_mage26t30 r_mage31t35 r_mage36t40 r_mage_over40";
global controls_vitalstat_birth "r_female r_Mfemale r_region_west r_region_midwest r_region_south r_foreign_res r_mevermarr r_educmother_0t8y r_educmother_9t12y r_educmother_hschool r_educmother_somecollege r_educmother_college r_Meducmother r_mage16t20 r_mage21t25 r_mage26t30 r_mage31t35 r_mage36t40 r_mage_over40";

global ctrl_race = "s6a s6b s6c s6d s6e s4  h1gi6a h1gi6b h1gi6c h1gi6d h1gi6e h1gi4 h3od4a h3od4b h3od4c h3od4d h3od2";


*----------------------------------------------*

          Bringing in AddHealth Data

*----------------------------------------------*;

fdause "raw_data\wave3", clear;
gen obsH3 = 1;
tempfile wave3;
quietly: compress;
save `wave3';

fdause "raw_data\Homewt1", clear;
tempfile Homewt1;
quietly: compress;
save `Homewt1';

fdause "raw_data\allwave1", clear;
gen obsH1 = 1;
tempfile allwave1;
quietly: compress;
save `allwave1';

fdause "raw_data\Schadm1", clear;
rename aschlcde sschlcde;
tempfile Schadm1;
quietly: compress;
save `Schadm1';

fdause "raw_data\Inschool", clear;
replace kidwgtps = . if kidwgtps == 0;
duplicates tag sqid sschlcde kidwgtps, gen(dupes);
replace kidwgtps = . if dupes > 0;
drop dupes;
gen obsS = 1;

merge sschlcde using `Schadm1', sort uniqus keep(aregion) nokeep;
tab _merge;
drop _merge;

merge aid using `allwave1', sort uniqus keep(scid h1* bio_sex ah_raw i* pa* pb* pc* obsH1);
tab _merge;
drop _merge;
replace obsS = 0 if obsS == .;
replace obsH1 = 0 if obsH1 == .;

merge aid using `Homewt1', sort uniqus keep(gswgt1);
tab _merge;
drop _merge;

merge aid using `wave3', sort uniqus keep(h3od2 h3od4* obsH3);
tab _merge;
drop _merge;
replace obsS = 0 if obsS == .;
replace obsH1 = 0 if obsH1 == .;
replace obsH3 = 0 if obsH3 == .;

quietly: compress;
save "clean_data\addhealth1.dta", replace;




*----------------------------------------------*

            Cleaning AddHealth Data

*----------------------------------------------*;
use "clean_data\addhealth1.dta", clear;


** DROPS;

*RACE [Strict];
drop if (obsS == 1 & obsH1 == 0 & obsH3 == 0) & ((s6c == 1 | s6d == 1 | s6e == 1) | (s6c > 1 | s6d > 1 | s6e > 1) | (s6a == 0 & s6b == 0));
drop if (obsS == 0 & obsH1 == 1 & obsH3 == 0) & ((h1gi6a > 1 & h1gi6b > 1 & h1gi6c > 1 & h1gi6d > 1 & h1gi6e > 1) | (h1gi6c == 1 | h1gi6d == 1 | h1gi6e == 1) | (h1gi6c > 1 | h1gi6d > 1 | h1gi6e > 1) | (h1gi6a == 0 & h1gi6b == 0));
drop if (obsS == 0 & obsH1 == 0 & obsH3 == 1) & ((h3od4a > 1 & h3od4b > 1 & h3od4c > 1 & h3od4d > 1) | (h3od4c == 1 | h3od4d == 1) | (h3od4c > 1 | h3od4d > 1) | (h3od4a == 0 & h3od4b == 0));
drop if (obsS == 1 & obsH1 == 1 & obsH3 == 0) & (((s6c == 1 | s6d == 1 | s6e == 1) | (h1gi6c == 1 | h1gi6d == 1 | h1gi6e == 1)) | (s6a != h1gi6a | s6b != h1gi6b) | ((s6c > 1 | s6d > 1 | s6e > 1) | (h1gi6c > 1 | h1gi6d > 1 | h1gi6e > 1)) | ((s6a == 0 & s6b == 0) & (h1gi6a == 0 & h1gi6b == 0)));
drop if (obsS == 1 & obsH1 == 0 & obsH3 == 1) & (((s6c == 1 | s6d == 1 | s6e == 1) | (h3od4c == 1 | h3od4d == 1)) | (s6a != h3od4a | s6b != h3od4b) | ((s6c > 1 | s6d > 1 | s6e > 1) | (h3od4c > 1 | h3od4d > 1)) | ((s6a == 0 & s6b == 0) & (h3od4a == 0 & h3od4b == 0)));
drop if (obsS == 0 & obsH1 == 1 & obsH3 == 1) & (((h1gi6a > 1 & h1gi6b > 1 & h1gi6c > 1 & h1gi6d > 1 & h1gi6e > 1) | (h3od4a > 1 & h3od4b > 1 & h3od4c > 1 & h3od4d > 1)) | ((h1gi6c == 1 | h1gi6d == 1 | h1gi6e == 1) | (h3od4c == 1 | h3od4d == 1)) | (h3od4a != h1gi6a | h3od4b != h1gi6b) | ((h1gi6c > 1 | h1gi6d > 1 | h1gi6e > 1) | (h3od4c > 1 | h3od4d > 1)) | ((h1gi6a == 0 & h1gi6b == 0) & (h3od4a == 0 & h3od4b == 0)));
drop if (obsS == 1 & obsH1 == 1 & obsH3 == 1) & (((s6c == 1 | s6d == 1 | s6e == 1) | (h1gi6c == 1 | h1gi6d == 1 | h1gi6e == 1) | (h3od4c == 1 | h3od4d == 1)) | ((s6a != h1gi6a | s6b != h1gi6b) | (s6a != h3od4a | s6b != h3od4b) | (h3od4a != h1gi6a | h3od4b != h1gi6b)) | ((s6c > 1 | s6d > 1 | s6e > 1) | (h1gi6c > 1 | h1gi6d > 1 | h1gi6e > 1) | (h3od4c > 1 | h3od4d > 1)) | ((s6a == 0 & s6b == 0) & (h1gi6a == 0 & h1gi6b == 0) & (h3od4a == 0 & h3od4b == 0)));


*HISPANIC;
gen nonhispanic = 0;
replace nonhispanic = 1 if (obsS == 1 & obsH1 == 0 & obsH3 == 0) & (s4 == 0);
replace nonhispanic = 1 if (obsS == 0 & obsH1 == 1 & obsH3 == 0) & (h1gi4 == 0);
replace nonhispanic = 1 if (obsS == 0 & obsH1 == 0 & obsH3 == 1) & (h3od2 == 0);
replace nonhispanic = 1 if (obsS == 1 & obsH1 == 1 & obsH3 == 0) & (s4 == 0 & h1gi4 == 0);
replace nonhispanic = 1 if (obsS == 1 & obsH1 == 0 & obsH3 == 1) & (s4 == 0 & h3od2 == 0);
replace nonhispanic = 1 if (obsS == 0 & obsH1 == 1 & obsH3 == 1) & (h1gi4 == 0 & h3od2 == 0);
replace nonhispanic = 1 if (obsS == 1 & obsH1 == 1 & obsH3 == 1) & (s4 == 0 & h1gi4 == 0 & h3od2 == 0);
keep if nonhispanic == 1;


** ID'S & WEIGHTS;

*CHILD ID;
rename aid r_childid;

*SCHOOL ID;
rename sschlcde r_schoolid;
replace r_schoolid = scid if r_schoolid == "";

*INTERVIEWER ID;
rename intid r_interviewerid;

*SAMPLE WEIGHTS;
rename gswgt1 r_homeweight;
rename kidwgtps r_schoolweight;


** DEMOGRAPHICS;

*RACE-strict;
gen r_white = 0;
replace r_white = 1 if obsS == 1 & (s6a == 1 & s6b == 0);
replace r_white = 1 if (obsS == 0 & obsH1 == 1) & (h1gi6a == 1 & h1gi6b == 0);
replace r_white = 1 if (obsS == 0 & obsH1 == 0) & (h3od4a == 1 & h3od4b == 0);
gen r_black = 0;
replace r_black = 1 if obsS == 1 & (s6a == 0 & s6b == 1);
replace r_black = 1 if (obsS == 0 & obsH1 == 1) & (h1gi6a == 0 & h1gi6b == 1);
replace r_black = 1 if (obsS == 0 & obsH1 == 0) & (h3od4a == 0 & h3od4b == 1);
gen r_mixed = 0;
replace r_mixed = 1 if obsS == 1 & (s6a == 1 & s6b == 1);
replace r_mixed = 1 if (obsS == 0 & obsH1 == 1) & (h1gi6a == 1 & h1gi6b == 1);
replace r_mixed = 1 if (obsS == 0 & obsH1 == 0) & (h3od4a == 1 & h3od4b == 1);


gen dummy_race = r_white + r_black + r_mixed;
tab dummy_race;
drop dummy_race;

*  check RACE [strict];
sum  $ctrl_race if r_white ==1;
sum  $ctrl_race if r_black ==1;
sum  $ctrl_race if r_mixed ==1;



*GENDER;
gen r_Mgender = 0;
replace r_Mgender = 1 if s2 >= 9;
gen r_male = 0;
replace r_male = 1 if s2 == 1;
gen r_female = 0;
replace r_female = 1 if s2 == 2;
gen r_Nmale = .;
replace r_Nmale = r_male if r_Mgender == 0;
gen r_Nfemale = .;
replace r_Nfemale = r_female if r_Mgender == 0;
gen r_Mgender_v2 = 0;
replace r_Mgender_v2 = 1 if s2 >= 9 & bio_sex >= 6;
gen r_male_v2 = 0;
replace r_male_v2 = 1 if s2 == 1;
replace r_male_v2 = 1 if s2 >= 9 & bio_sex == 1;
gen r_female_v2 = 0;
replace r_female_v2 = 1 if s2 == 2;
replace r_female_v2 = 1 if s2 >= 9 & bio_sex == 2;
gen r_Nmale_v2 = .;
replace r_Nmale_v2 = r_male_v2 if r_Mgender_v2 == 0;
gen r_Nfemale_v2 = .;
replace r_Nfemale_v2 = r_female_v2 if r_Mgender_v2 == 0;

*AGE;
gen r_Mage = 0;
replace r_Mage = 1 if s1 >= 99;
gen r_age = 0;
replace r_age = s1 if r_Mage == 0;
gen r_age_sq = r_age^2;
gen r_Nage = .;
replace r_Nage = r_age if r_Mage == 0;
gen dateofinterview = ym(1995, imonth);
gen yearofbirth = 1900 + h1gi1y if h1gi1y < 96;
gen dateofbirth = ym(yearofbirth, h1gi1m) if (h1gi1m < 96 & h1gi1y < 96);
gen ageimputed = (dateofinterview - dateofbirth)/12;
gen r_Mage_v2 = 0;
replace r_Mage_v2 = 1 if s1 >= 99 & ageimputed == .;
gen r_age_v2 = 0;
replace r_age_v2 = s1 if s1 < 99;
replace r_age_v2 = ageimputed if s1 >= 99 & ageimputed < .;
gen r_age_sq_v2 = r_age_v2^2;
gen r_Nage_v2 = .;
replace r_Nage_v2 = r_age_v2 if r_Mage_v2 == 0;

gen r_age_l13=0;
replace r_age_l13=1 if r_age>0 & r_age<=13 & r_Mage==0;
gen r_age_13t15=0;
replace r_age_13t15=1 if r_age>13 & r_age<=15 & r_Mage==0;
gen r_age_15t17=0;
replace r_age_15t17=1 if r_age>15 & r_age<=17 & r_Mage==0;
gen r_age_17plus=0;
replace r_age_17plus=1 if r_age>17 & r_Mage==0;


*BORN IN US;
gen r_Mbornus = 0;
replace r_Mbornus = 1 if s8 >= 9;
gen r_bornus = 0;
replace r_bornus = 1 if s8 == 1;
gen r_Nbornus = .;
replace r_Nbornus = r_bornus if r_Mbornus == 0;
gen r_Mbornus_v2 = 0;
replace r_Mbornus_v2 = 1 if s8 >= 9 & (h1gi11 == 6 | h1gi11 >= 8);
gen r_bornus_v2 = 0;
replace r_bornus_v2 = 1 if s8 == 1;
replace r_bornus_v2 = 1 if s8 >= 9 & (h1gi11 == 1 | h1gi11 == 7);
gen r_Nbornus_v2 = .;
replace r_Nbornus_v2 = r_bornus_v2 if r_Mbornus == 0;

*REGION;
gen r_Mregion = 0;
replace r_Mregion = 1 if aregion > 4;
gen r_northeast = 0;
replace r_northeast = 1 if aregion == 4;
gen r_midwest = 0;
replace r_midwest = 1 if aregion == 2;
gen r_south = 0;
replace r_south = 1 if aregion == 3;
gen r_west = 0;
replace r_west = 1 if aregion == 1;


** HOME ENVIRONMENT;

*HOUSEHOLD INCOME;
gen r_Mhhincome = 0;
replace r_Mhhincome = 1 if pa55 >= 9996;
gen r_hhincome = .;
replace r_hhincome = pa55*1000 if r_Mhhincome == 0;
gen r_lhhincome = ln(r_hhincome);

gen r_hhincome_l25=0;
replace r_hhincome_l25=1 if r_hhincome>=0 & r_hhincome<=25000 & r_Mhhincome==0;
gen r_hhincome_25t45=0;
replace r_hhincome_25t45=1 if r_hhincome>25000 & r_hhincome<=45000 & r_Mhhincome==0;
gen r_hhincome_45t65=0;
replace r_hhincome_45t65=1 if r_hhincome>45000 & r_hhincome<=65000 & r_Mhhincome==0;
gen r_hhincome_65plus=0;
replace r_hhincome_65plus=1 if r_hhincome>65000 & r_Mhhincome==0;


*NOT ON WELFARE;
gen r_Mnowelfare = 0;
replace r_Mnowelfare = 1 if pa21 >= 6;
gen r_nowelfare = .;
replace r_nowelfare = 0 if pa21 == 1;
replace r_nowelfare = 1 if pa21 == 0;

gen r_Cnowelfare = 0;
replace r_Cnowelfare = 0 if pa21 == 1;
replace r_Cnowelfare = 1 if pa21 == 0;


*FATHER IN HOUSEHOLD;
gen r_Mfatherinhh = 0;
replace r_Mfatherinhh = 1 if s17 >= 9;
gen r_fatherinhh = .;
replace r_fatherinhh = s17 if r_Mfatherinhh == 0;

gen r_Cfatherinhh = 0;
replace r_Cfatherinhh = s17 if r_Mfatherinhh == 0;


*PARENTS MARRIED;
gen r_Mmarried = 0;
replace r_Mmarried = 1 if pa10 >= 6;
gen r_married = .;
replace r_married = 0 if pa10 == 1 | (pa10 >= 3 & pa10 <= 5);
replace r_married = 1 if pa10 == 2;

gen r_Cmarried = 0;
replace r_Cmarried = 0 if pa10 == 1 | (pa10 >= 3 & pa10 <= 5);
replace r_Cmarried = 1 if pa10 == 2;


*MOTHER'S AGE;
gen r_Mmomage = 0;
replace r_Mmomage = 1 if (pa1 == 1 | pa1 == .) | pa2 >= 996;
gen r_momage = .;
replace r_momage = pa2 if r_Mmomage == 0;

gen r_momage_l35=0;
replace r_momage_l35=1 if r_momage>0 & r_momage<=35 & r_Mmomage==0;
gen r_momage_35t40=0;
replace r_momage_35t40=1 if r_momage>35 & r_momage<=40 & r_Mmomage==0;
gen r_momage_40t45=0;
replace r_momage_40t45=1 if r_momage>40 & r_momage<=45 & r_Mmomage==0;
gen r_momage_45plus=0;
replace r_momage_45plus=1 if r_momage>45 & r_Mmomage==0;
gen dummy= r_momage_l35 + r_momage_35t40 + r_momage_40t45 + r_momage_45plus + r_Mmomage;
tab dummy;
drop dummy;

*MOTHER IS COLLEGE GRADUATE;
gen r_Mmomcolgrad = 0;
replace r_Mmomcolgrad = 1 if s12 == 9 | s12 >= 11;
gen r_momcolgrad = .;
replace r_momcolgrad = 0 if s12 <= 6 | s12 == 10;
replace r_momcolgrad = 1 if s12 == 7 | s12 == 8;

*MOTHER'S YEARS OF EDUCATION;
gen r_educmother_noschool=0;
replace r_educmother_noschool=1 if s12==10;
gen r_educmother_0t8y=0;
replace r_educmother_0t8y=1 if s12==1;
gen r_educmother_9t12y=0;
replace r_educmother_9t12y=1 if s12==2;
gen r_educmother_hschool=0;
replace r_educmother_hschool=1 if s12==3;
gen r_educmother_ged=0;
replace r_educmother_ged=1 if s12==4;
gen r_educmother_vocschool=0;
replace r_educmother_vocschool=1 if s12==5;
gen r_educmother_somecollege=0;
replace r_educmother_somecollege=1 if s12==6;
gen r_educmother_college=0;
replace r_educmother_college=1 if s12==7;
gen r_educmother_collegeplus=0;
replace r_educmother_collegeplus=1 if s12==8;
gen r_Meducmother=0;
replace r_Meducmother=1 if s12<1 | s12>=11 | s12==9;
gen dummy= r_educmother_noschool + r_educmother_0t8y + r_educmother_9t12y + r_educmother_hschool + r_educmother_ged  + r_educmother_vocschool + r_educmother_somecollege + r_educmother_college + r_educmother_collegeplus + r_Meducmother;
tab dummy;
drop dummy;

*MOTHER EVER MARRIED;
gen r_Mmomevermarried = 0;
replace r_Mmomevermarried = 1 if (pa1 == 1 | pa1 == .) | pa38 >= 6;
gen r_momevermarried = .;
replace r_momevermarried = pa38 if r_Mmomevermarried == 0;

gen r_Cmomevermarried = -99;
replace r_Cmomevermarried = pa38 if r_Mmomevermarried == 0;


*YEARS IN CURRENT RESIDENCE;
gen r_Myrsinresidence = 0;
replace r_Myrsinresidence = 1 if (h1gi1m == 96 | h1gi1y == 96) | h1gi3 >= 96;
gen r_yrsinresidence = .;
replace r_yrsinresidence = (ageimputed - h1gi3) if r_Myrsinresidence == 0;

gen r_yrsinresidence_0t2=0;
replace r_yrsinresidence_0t2=1 if r_yrsinresidence>=0 & r_yrsinresidence<=2 & r_Myrsinresidence==0;
gen r_yrsinresidence_2t5=0;
replace r_yrsinresidence_2t5=1 if r_yrsinresidence>2 & r_yrsinresidence<=5 & r_Myrsinresidence==0;
gen r_yrsinresidence_5t10=0;
replace r_yrsinresidence_5t10=1 if r_yrsinresidence>5 & r_yrsinresidence<=10 & r_Myrsinresidence==0;
gen r_yrsinresidence_10plus=0;
replace r_yrsinresidence_10plus=1 if r_yrsinresidence>10 & r_Myrsinresidence==0;;
gen dummy= r_yrsinresidence_0t2 + r_yrsinresidence_2t5 + r_yrsinresidence_5t10 + r_yrsinresidence_10plus + r_Myrsinresidence;
tab dummy;
drop dummy;


** PHYSICAL;

*BIRTH WEIGHT;
gen r_Mbirthweight = 0;
replace r_Mbirthweight = 1 if pc19a_p >= 98 | pc19b_o >= 98;
gen r_birthweight = .;
replace r_birthweight = .453592*pc19a_p + .0283495*pc19b_o if r_Mbirthweight == 0 & (pc19a_p >= 4 & pc19a_p <= 11);
replace r_birthweight = .453592*pc19a_p if r_Mbirthweight == 0 & (pc19a_p == 3 | pc19a_p == 12);

gen r_birthweight_l250=0;
replace r_birthweight_l250=1 if r_birthweight>0 & r_birthweight<=2.5 & r_Mbirthweight==0;
gen r_birthweight_250t325=0;
replace r_birthweight_250t325=1 if r_birthweight>2.5 & r_birthweight<=3.25 & r_Mbirthweight==0;
gen r_birthweight_325t375=0;
replace r_birthweight_325t375=1 if r_birthweight>3.25 & r_birthweight<=3.75 & r_Mbirthweight==0;
gen r_birthweight_375plus=0;
replace r_birthweight_375plus=1 if r_birthweight>3.75 & r_Mbirthweight==0;
gen dummy= r_birthweight_l250 + r_birthweight_250t325 + r_birthweight_325t375 + r_birthweight_375plus + r_Mbirthweight;
tab dummy;
drop dummy;

*WEIGHT;
gen r_Mcurrentweight = 0;
replace r_Mcurrentweight = 1 if h1gh60 >= 996;
gen r_currentweight = .;
replace r_currentweight = .45359237*h1gh60 if r_Mcurrentweight == 0;

*HEIGHT;
gen r_Mheight = 0;
replace r_Mheight = 1 if h1gh59a >= 96 | h1gh59b >= 96;
gen r_height = .;
replace r_height = .3048*h1gh59a + 0.0254*h1gh59b if r_Mheight == 0;

*BMI;
gen r_Mbmi = 0;
replace r_Mbmi = 1 if r_Mcurrentweight == 1 | r_Mheight == 1;
gen r_bmi = .;
replace r_bmi = r_currentweight/(r_height^2) if r_Mbmi == 0;

*ATTRACTIVENESS;
gen r_Mattractive = 0;
replace r_Mattractive = 1 if h1ir1 >= 6;
gen r_attractive = .;
replace r_attractive = h1ir1 if r_Mattractive == 0;


** ACHIEVEMENT;

*NO LEARNING DISABILITY;
gen r_Mnolearndisable = 0;
replace r_Mnolearndisable = 1 if pc38 >= 6;
gen r_nolearndisable = .;
replace r_nolearndisable = 0 if pc38 == 1;
replace r_nolearndisable = 1 if pc38 == 0;

*ADD HEALTH PICTURE VOCABULARY TEST;
gen r_Mahpvt = 0;
replace r_Mahpvt = 1 if ah_raw == 0 | ah_raw == .;
gen r_ahpvt = .;
replace r_ahpvt = ah_raw if r_Mahpvt == 0;

*GPA;
gen Mgpa_ela = 0;
replace Mgpa_ela = 1 if s10a >= 5;
gen gpa_ela = 0;
replace gpa_ela = s10a if Mgpa_ela == 0;
recode gpa_ela (1 = 4) (2 = 3) (3 = 2) (4 = 1);
gen Mgpa_mth = 0;
replace Mgpa_mth = 1 if s10b >= 5;
gen gpa_mth = 0;
replace gpa_mth = s10b if Mgpa_mth == 0;
recode gpa_mth (1 = 4) (2 = 3) (3 = 2) (4 = 1);
gen Mgpa_soc = 0;
replace Mgpa_soc = 1 if s10c >= 5;
gen gpa_soc = 0;
replace gpa_soc = s10c if Mgpa_soc == 0;
recode gpa_soc (1 = 4) (2 = 3) (3 = 2) (4 = 1);
gen Mgpa_sci = 0;
replace Mgpa_sci = 1 if s10d >= 5;
gen gpa_sci = 0;
replace gpa_sci = s10d if Mgpa_sci == 0;
recode gpa_sci (1 = 4) (2 = 3) (3 = 2) (4 = 1);
gen r_Mgpa = 0;
replace r_Mgpa = 1 if Mgpa_ela == 1 & Mgpa_mth == 1 & Mgpa_soc == 1 & Mgpa_sci == 1;
gen r_gpa = .;
replace r_gpa = (gpa_ela + gpa_mth + gpa_soc + gpa_sci)/(4 - Mgpa_ela - Mgpa_mth - Mgpa_soc - Mgpa_sci) if r_Mgpa == 0;

*NEVER REPEATED GRADE;
gen r_Mnorepeatgrade = 0;
replace r_Mnorepeatgrade = 1 if h1ed5 >= 6;
gen r_norepeatgrade = .;
replace r_norepeatgrade = 0 if h1ed5 == 1;
replace r_norepeatgrade = 1 if h1ed5 == 0;


** BEHAVIOR IN SCHOOL;

*TROUBLE WITH TEACHERS;
gen r_Mtrouble_teacher = 0;
replace r_Mtrouble_teacher = 1 if s46a >= 9;
gen r_trouble_teacher = .;
replace r_trouble_teacher = s46a if r_Mtrouble_teacher == 0;

*TROUBLE PAYING ATTENTION;
gen r_Mtrouble_payattention = 0;
replace r_Mtrouble_payattention = 1 if s46b >= 9;
gen r_trouble_payattention = .;
replace r_trouble_payattention = s46b if r_Mtrouble_payattention == 0;

*TROUBLE GETTING HOMEWORK DONE;
gen r_Mtrouble_homework = 0;
replace r_Mtrouble_homework = 1 if s46c >= 9;
gen r_trouble_homework = .;
replace r_trouble_homework = s46c if r_Mtrouble_homework == 0;

*TROUBLE GETTING ALONG WITH OTHER STUDENTS;
gen r_Mtrouble_getalong = 0;
replace r_Mtrouble_getalong = 1 if s46d >= 9;
gen r_trouble_getalong = .;
replace r_trouble_getalong = s46d if r_Mtrouble_getalong == 0;

*EFFORT ON SCHOOLWORK;
gen r_Meffortschool = 0;
replace r_Meffortschool = 1 if s48 >= 9;
gen r_effortschool = .;
replace r_effortschool = s48 if r_Meffortschool == 0;

*SKIPPING SCHOOL;
gen r_Mskipschool = 0;
replace r_Mskipschool = 1 if s59g >= 99;
gen r_skipschool = .;
replace r_skipschool = s59g if r_Mskipschool == 0;

*EVER BEEN SUSPENDED OR EXPELLED;
gen r_notsuspendedexpelled = .;
replace r_notsuspendedexpelled = 0 if h1ed7 == 1 | h1ed9 == 1;
replace r_notsuspendedexpelled = 1 if h1ed7 == 0 & h1ed9 == 0;
gen r_Mnotsuspendedexpelled = 0;
replace r_Mnotsuspendedexpelled = 1 if r_notsuspendedexpelled == .;


** BEHAVIOR OUTSIDE SCHOOL;

*WATCHING TV;
gen r_Mwatchtv = 0;
replace r_Mwatchtv = 1 if s47 >= 9;
gen r_watchtv = .;
replace r_watchtv = s47 if r_Mwatchtv == 0;

*DRINKING;
gen r_Mdrink = 0;
replace r_Mdrink = 1 if s59b >= 99;
gen r_drink = .;
replace r_drink = s59b if r_Mdrink == 0;

*SMOKING;
gen r_Msmoke = 0;
replace r_Msmoke = 1 if s59a >= 99;
gen r_smoke = .;
replace r_smoke = s59a if r_Msmoke == 0;

*DARING;
gen r_Mdare = 0;
replace r_Mdare = 1 if s59e >= 99;
gen r_dare = .;
replace r_dare = s59e if r_Mdare == 0;

*LYING TO PARENTS;
gen r_Mlietoparents = 0;
replace r_Mlietoparents = 1 if s59f >= 99;
gen r_lietoparents = .;
replace r_lietoparents = s59f if r_Mlietoparents == 0;

*FIGHTING;
gen r_Mfight = 0;
replace r_Mfight = 1 if s64 >= 9;
gen r_fight = .;
replace r_fight = s64 if r_Mfight == 0;

*PROPERTY DAMAGE;
gen r_Mpropertydamage = 0;
replace r_Mpropertydamage = 1 if h1ds2 >= 6;
gen r_propertydamage = .;
replace r_propertydamage = h1ds2 if r_Mpropertydamage == 0;

*STEALING;
gen r_Msteal = 0;
replace r_Msteal = 1 if h1ds4 >= 6;
gen r_steal = .;
replace r_steal = h1ds4 if r_Msteal == 0;

*VIOLENT ACTS;
gen Mfight = 0;
replace Mfight = 1 if h1fv5 >= 6;
gen fight = 0;
replace fight = h1fv5 if Mfight == 0;
gen Mknife = 0;
replace Mknife = 1 if h1fv7 >= 6;
gen knife = 0;
replace knife = h1fv7 if Mknife == 0;
gen Mshootstab = 0;
replace Mshootstab = 1 if h1fv8 >= 6;
gen shootstab = 0;
replace shootstab = h1fv8 if Mshootstab == 0;
gen r_Mviolentacts = 0;
replace r_Mviolentacts = 1 if Mfight == 1 & Mknife == 1 & Mshootstab == 1;
gen r_violentacts = .;
replace r_violentacts = (fight + knife + shootstab)/(3 - Mfight - Mknife - Mshootstab) if r_Mviolentacts == 0;

*SELLING DRUGS;
gen r_Mselldrugs = 0;
replace r_Mselldrugs = 1 if h1ds12 >= 6;
gen r_selldrugs = .;
replace r_selldrugs = h1ds12 if r_Mselldrugs == 0;

*ENCOUNTERED VIOLENCE;
gen Mshootstabwit = 0;
replace Mshootstabwit = 1 if h1fv1 >= 6;
gen shootstabwit = 0;
replace shootstabwit = h1fv1 if Mshootstabwit == 0;
gen Mpullknife = 0;
replace Mpullknife = 1 if h1fv2 >= 6;
gen pullknife = 0;
replace pullknife = h1fv2 if Mpullknife == 0;
gen Mgotshot = 0;
replace Mgotshot = 1 if h1fv3 >= 6;
gen gotshot = 0;
replace gotshot = h1fv3 if Mgotshot == 0;
gen Mgotcut = 0;
replace Mgotcut = 1 if h1fv4 >= 6;
gen gotcut = 0;
replace gotcut = h1fv4 if Mgotcut == 0;
gen Mjumped = 0;
replace Mjumped = 1 if h1fv6 >= 6;
gen jumped = 0;
replace jumped = h1fv6 if Mjumped == 0;
gen r_Mencounteredviolence = 0;
replace r_Mencounteredviolence = 1 if Mshootstabwit == 1 & Mpullknife == 1 & Mgotshot == 1 & Mgotcut == 1 & Mjumped == 1;
gen r_encounteredviolence = .;
replace r_encounteredviolence = (shootstabwit + pullknife + gotshot + gotcut + jumped)/(5 - Mshootstabwit - Mpullknife - Mgotshot - Mgotcut - Mjumped) if r_Mencounteredviolence == 0;

*EVER HAD SEX;
gen r_Msex = 0;
replace r_Msex = 1 if h1co1 >= 6;
gen r_sex = .;
replace r_sex = h1co1 if r_Msex == 0;

*EVER HAD STD;
gen r_std = .;
replace r_std = 0 if (h1co16a == 0 | h1co16a == 7) & (h1co16b == 0 | h1co16b == 7) & (h1co16c == 0 | h1co16c == 7) & (h1co16d == 0 | h1co16d == 7) & (h1co16e == 0 | h1co16e == 7) & (h1co16f == 0 | h1co16f == 7) & (h1co16g == 0 | h1co16g == 7) & (h1co16h == 0 | h1co16h == 7) & (h1co16i == 0 | h1co16i == 7) & (h1co16j == 0 | h1co16j == 7);
replace r_std = 1 if h1co16a == 1 | h1co16b == 1 | h1co16c == 1 | h1co16d == 1 | h1co16e == 1 | h1co16f == 1 | h1co16g == 1 | h1co16h == 1 | h1co16i == 1 | h1co16j == 1;
gen r_Mstd = 0;
replace r_Mstd = 1 if r_std == .;

*EVER DONE ILLEGAL DRUGS;
gen r_drugs = .;
replace r_drugs = 0 if h1to30 == 0 & h1to34 == 0 & h1to37 == 0 & h1to40 == 0;
replace r_drugs = 1 if (h1to30 >= 1 & h1to30 <= 18) | (h1to34 >= 1 & h1to34 <= 18) | (h1to37 >= 1 & h1to37 <= 18) | (h1to40 >= 1 & h1to40 <= 18);
gen r_Mdrugs = 0;
replace r_Mdrugs = 1 if r_drugs == .;


** PSYCHOLOGICAL;

*MOTHER CARES;
gen r_Mmomcares = 0;
replace r_Mmomcares = 1 if s16 >= 7;
gen r_momcares = .;
replace r_momcares = s16 if r_Mmomcares == 0;

*FATHER CARES;
gen r_Mdadcares = 0;
replace r_Mdadcares = 1 if s22 >= 7;
gen r_dadcares = .;
replace r_dadcares = s22 if r_Mdadcares == 0;

*FEEL CLOSE TO PEOPLE;
gen r_Mfeelclose = 0;
replace r_Mfeelclose = 1 if s62b >= 9;
gen r_feelclose = .;
replace r_feelclose = s62b if r_Mfeelclose == 0;
recode r_feelclose (1 = 5) (2 = 4) (4 = 2) (5 = 1);

*FEEL ACCEPTED;
gen r_Mfeelaccepted = 0;
replace r_Mfeelaccepted = 1 if s62o >= 9;
gen r_feelaccepted = .;
replace r_feelaccepted = s62o if r_Mfeelaccepted == 0;
recode r_feelaccepted (1 = 5) (2 = 4) (4 = 2) (5 = 1);

*FEEL LOVED;
gen r_Mfeelloved = 0;
replace r_Mfeelloved = 1 if s62p >= 9;
gen r_feelloved = .;
replace r_feelloved = s62p if r_Mfeelloved == 0;
recode r_feelloved (1 = 5) (2 = 4) (4 = 2) (5 = 1);

*NOT DEPRESSED;
gen r_Mnotdepressed = 0;
replace r_Mnotdepressed = 1 if s60k >= 9;
gen r_notdepressed = .;
replace r_notdepressed = s60k if r_Mnotdepressed == 0;
recode r_notdepressed (0 = 4) (1 = 3) (3 = 1) (4 = 0);

*LIKE ONESELF;
gen r_Mlikeoneself = 0;
replace r_Mlikeoneself = 1 if s62m >= 9;
gen r_likeoneself = .;
replace r_likeoneself = s62m if r_Mlikeoneself == 0;
recode r_likeoneself (1 = 5) (2 = 4) (4 = 2) (5 = 1);

*CHANCES LIVE TO 35;
gen r_Mliveto35 = 0;
replace r_Mliveto35 = 1 if s45a >= 99;
gen r_liveto35 = .;
replace r_liveto35 = s45a if r_Mliveto35 == 0;


** STANDARDIZATION OF VARIABLES;

*ATTRACTIVENESS;
areg r_attractive [pweight = r_homeweight], absorb(r_interviewerid);
predict residual, res;
mean residual [pweight=r_homeweight];
matrix m=el(e(b),1,1);
sca mean = m[1,1];
matrix s = sqrt(e(N) * el(e(V_srs),1,1));
sca sigma = s[1,1];
gen r_std_attractive = (residual - mean)/sigma;
drop residual;

*OTHER HOME/PARENT INTERVIEW VARIABLES;
foreach v in $home {;
	
	mean r_`v' [pweight=r_homeweight];
	matrix m=el(e(b),1,1);
	sca mean = m[1,1];
	matrix s = sqrt(e(N) * el(e(V_srs),1,1));
	sca sigma = s[1,1];
	gen r_std_`v'=(r_`v'-mean)/sigma;

};

*SCHOOL SURVEY VARIABLES;
foreach v in $school {;
	mean r_`v' [pweight = r_schoolweight];
	matrix m=el(e(b),1,1);
	sca mean = m[1,1];
	matrix s = sqrt(e(N) * el(e(V_srs),1,1));
	sca sigma = s[1,1];
	gen r_std_`v'=(r_`v'-mean)/sigma;
};


gen r_data_racestrict = 1;

keep r_*;
quietly: compress;
save "analysis_data\addhealth1_analysis.dta", replace;
summ $homeenv $phys $achieve $behavinschl $behavoutschl $psych;

*----------------------------------------------*

                AddHealth Tables

*----------------------------------------------*;
use "analysis_data\addhealth1_analysis.dta", clear;


*TABLE 0 - RAW DATA;
mat T1 = J(106,4,.);
mat colnames T1 = Full_Sample	White	Black	Mixed;		
mat rownames T1 = female female_se age age_se bornus bornus_se west west_se midwest midwest_se northeast northeast_se south south_se hhincome hhincome_se nowelfare nowelfare_se married married_se momage momage_se momevermarried momevermarried_se yrsinresidence yrsinresidence_se fatherinhh fatherinhh_se momcolgrad momcolgrad_se birthweight birthweight_se currentweight currentweight_se height height_se bmi bmi_se attractive attractive_se nolearndisable nolearndisable_se ahpvt ahpvt_se gpa gpa_se norepeatgrade norepeatgrade_se trouble_teacher trouble_teacher_se trouble_payattention trouble_payattention_se trouble_homework trouble_homework_se trouble_getalong trouble_getalong_se effortschool effortschool_se skipschool skipschool_se notsuspendedexpelled notsuspendedexpelled_se watchtv watchtv_se drink drink_se smoke smoke_se dare dare_se lietoparents lietoparents_se fight fight_se propertydamage propertydamage_se steal steal_se violentacts violentacts_se selldrugs selldrugs_se encounteredviolence encounteredviolence_se sex sex_se std std_se drugs drugs_se momcares momcares_se dadcares dadcares_se feelclose feelclose_se feelaccepted feelaccepted_se feelloved feelloved_se notdepressed notdepressed_se likeoneself likeoneself_se liveto35 liveto35_se;

loc lnum = -1;
local lnum1 = `lnum' + 1;
	

* Demographics;
foreach var in  Nfemale Nage Nbornus {;

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' [aweight=r_schoolweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 [aweight=r_schoolweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 [aweight=r_schoolweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1 [aweight=r_schoolweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};



foreach var in west midwest northeast south {;

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' if r_Mregion==0 [aweight=r_schoolweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 & r_Mregion==0 [aweight=r_schoolweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 & r_Mregion==0 [aweight=r_schoolweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1 & r_Mregion==0 [aweight=r_schoolweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};




* Home Environment;
foreach var in hhincome nowelfare married momage momevermarried yrsinresidence {;

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' if r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};


foreach var in fatherinhh momcolgrad {;

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' if r_M`var'==0 [aweight=r_schoolweight];	
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_M`var'==0 & r_white==1 [aweight=r_schoolweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_M`var'==0 & r_black==1 [aweight=r_schoolweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_M`var'==0 & r_mixed==1 [aweight=r_schoolweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
	
};


* Physical;
foreach var in birthweight currentweight height bmi {;

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' if r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};


loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_std_attractive [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
sum r_std_attractive if r_white==1 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
sum r_std_attractive if r_black==1 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
sum r_std_attractive if r_mixed==1 [aweight=r_homeweight];

	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);


* Achievement;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_nolearndisable if r_Mnolearndisable==0 [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
sum r_nolearndisable if r_Mnolearndisable==0 & r_white==1 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
sum r_nolearndisable if r_Mnolearndisable==0 & r_black==1 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
sum r_nolearndisable if r_Mnolearndisable==0 & r_mixed==1 [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);

	

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_std_ahpvt [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
sum r_std_ahpvt if r_white==1 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
sum r_std_ahpvt if r_black==1 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
sum r_std_ahpvt if r_mixed==1 [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_gpa if r_Mgpa==0 [aweight=r_schoolweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
sum r_gpa if r_Mgpa==0 & r_white==1 [aweight=r_schoolweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
sum r_gpa if r_Mgpa==0 & r_black==1 [aweight=r_schoolweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
sum r_gpa if r_Mgpa==0 & r_mixed==1 [aweight=r_schoolweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);


loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_norepeatgrade if r_Mnorepeatgrade==0 [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
sum r_norepeatgrade if r_Mnorepeatgrade==0 & r_white==1 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
sum r_norepeatgrade if r_Mnorepeatgrade==0 & r_black==1 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
sum r_norepeatgrade if r_Mnorepeatgrade==0 & r_mixed==1 [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);


* Behavior in School;
foreach var in std_trouble_teacher std_trouble_payattention std_trouble_homework std_trouble_getalong std_effortschool std_skipschool {;

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' [aweight=r_schoolweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 [aweight=r_schoolweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 [aweight=r_schoolweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1  [aweight=r_schoolweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};

loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_notsuspendedexpelled if r_Mnotsuspendedexpelled==0 [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
sum r_notsuspendedexpelled if r_white==1 & r_Mnotsuspendedexpelled==0 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
sum r_notsuspendedexpelled if r_black==1 & r_Mnotsuspendedexpelled==0 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
sum r_notsuspendedexpelled if r_mixed==1 & r_Mnotsuspendedexpelled==0 [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);


* Behavior Outside School;

foreach var in std_watchtv std_drink std_smoke std_dare std_lietoparents std_fight {;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' [aweight=r_schoolweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 [aweight=r_schoolweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 [aweight=r_schoolweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1  [aweight=r_schoolweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};


foreach var in std_propertydamage std_steal std_violentacts std_selldrugs std_encounteredviolence  {;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1  [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};


foreach var in sex std drugs  {;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' if r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1  & r_M`var' == 0 [aweight=r_homeweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};



* Psychological Variables;
foreach var in std_momcares std_dadcares  std_feelclose std_feelaccepted std_feelloved std_notdepressed std_likeoneself std_liveto35 {;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' [aweight=r_schoolweight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);
	
sum r_`var' if r_white==1 [aweight=r_schoolweight];
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);
	
sum r_`var' if r_black==1 [aweight=r_schoolweight];
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);
	
sum r_`var' if r_mixed==1  [aweight=r_schoolweight];
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};

di "Table 1 - Add Health data";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Table0_AddHealth.txt") title("Table0_AddHealth") note("-----") format("%11.5f") replace;

mat drop _all;


*TABLE 2A - Home Environment;
eststo r1a, title("Household Income (log)"): reg r_lhhincome $race $controls_homeenv [pweight = r_homeweight], r;
eststo r2a, title("Not on Welfare"): reg r_nowelfare $race $controls_homeenv [pweight = r_homeweight], r;
eststo r3a, title("Father in Household"): reg r_fatherinhh $race $controls_homeenv [pweight = r_schoolweight], r;
eststo r4a, title("Parents Married"): reg r_married $race $controls_homeenv [pweight = r_homeweight], r;
eststo r5a, title("Mother's Age"): reg r_momage $race $controls_homeenv [pweight = r_homeweight], r;
eststo r6a, title("Mother is College Graduate"): reg r_momcolgrad $race $controls_homeenv [pweight = r_schoolweight], r;
eststo r7a, title("Mother Ever Married"): reg r_momevermarried $race $controls_homeenv [pweight = r_homeweight], r;
eststo r8a, title("Years in Current Residence"): reg r_yrsinresidence $race $controls_homeenv [pweight = r_homeweight], r;
eststo r1b, title("Household Income (log), School Fixed Effects"): areg r_lhhincome $race $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r2b, title("Not on Welfare, School Fixed Effects"): areg r_nowelfare $race $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r3b, title("Father in Household, School Fixed Effects"): areg r_fatherinhh $race $controls_homeenv [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r4b, title("Parents Married, School Fixed Effects"): areg r_married $race $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r5b, title("Mother's Age, School Fixed Effects"): areg r_momage $race $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r6b, title("Mother is College Graduate, School Fixed Effects"): areg r_momcolgrad $race $controls_homeenv [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r7b, title("Mother Ever Married, School Fixed Effects"): areg r_momevermarried $race $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r8b, title("Years in Current Residence, School Fixed Effects"): areg r_yrsinresidence $race $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
estout using "tables\Table2A_HomeEnvironment_AddHealth.txt",
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;

*TABLE 2A - Physical;
eststo r1a, title("Birth Weight (kg)"): reg r_birthweight $race $controls_phys [pweight = r_homeweight], r;
eststo r2a, title("Height (m)"): reg r_height $race $controls_phys [pweight = r_homeweight], r;
eststo r3a, title("BMI"): reg r_bmi $race $controls_phys [pweight = r_homeweight], r;
eststo r4a, title("Attractiveness"): reg r_std_attractive $race $controls_phys [pweight = r_homeweight], cluster(r_interviewerid);
eststo r1b, title("Birth Weight (kg), School Fixed Effects"): areg r_birthweight $race $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r2b, title("Height (m), School Fixed Effects"): areg r_height $race $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r3b, title("BMI, School Fixed Effects"): areg r_bmi $race $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r4b, title("Attractiveness, School Fixed Effects"): areg r_std_attractive $race $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
estout using "tables\Table2A_Physical.txt",
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;

*TABLE 3 - Achievement;
eststo r1a, title("No Learning Disability"): reg r_nolearndisable $race $controls_basic [pweight = r_homeweight], r;
eststo r2a, title("AHPVT Score"): reg r_std_ahpvt $race $controls_basic [pweight = r_homeweight], r;
eststo r3a, title("GPA"): reg r_gpa $race $controls_basic [pweight = r_schoolweight], r;
eststo r4a, title("Never Repeated a Grade"): reg r_norepeatgrade $race $controls_basic [pweight = r_homeweight], r;
eststo r1b, title("No Learning Disability, School Fixed Effects"): areg r_nolearndisable $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r2b, title("AHPVT Score, School Fixed Effects"): areg r_std_ahpvt $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r3b, title("GPA, School Fixed Effects"): areg r_gpa $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r4b, title("Never Repeated a Grade, School Fixed Effects"): areg r_norepeatgrade $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
estout using "tables\Table3_Achievement.txt",
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;


*TABLE 4 - Psychological;
eststo r1a, title("Mother Cares"): reg r_std_momcares $race $controls_basic [pweight = r_schoolweight], r;
eststo r2a, title("Father Cares"): reg r_std_dadcares $race $controls_basic [pweight = r_schoolweight], r;
eststo r3a, title("Close to People"): reg r_std_feelclose $race $controls_basic [pweight = r_schoolweight], r;
eststo r4a, title("Feel Accepted"): reg r_std_feelaccepted $race $controls_basic [pweight = r_schoolweight], r;
eststo r5a, title("Feel Loved"): reg r_std_feelloved $race $controls_basic [pweight = r_schoolweight], r;
eststo r6a, title("Not Depressed"): reg r_std_notdepressed $race $controls_basic [pweight = r_schoolweight], r;
eststo r7a, title("Like Oneself"): reg r_std_likeoneself $race $controls_basic [pweight = r_schoolweight], r;
eststo r8a, title("Chances Live to 35"): reg r_std_liveto35 $race $controls_basic [pweight = r_schoolweight], r;
eststo r1b, title("Mother Cares, School Fixed Effects"): areg r_std_momcares $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r2b, title("Father Cares, School Fixed Effects"): areg r_std_dadcares $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r3b, title("Close to People, School Fixed Effects"): areg r_std_feelclose $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r4b, title("Feel Accepted, School Fixed Effects"): areg r_std_feelaccepted $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r5b, title("Feel Loved, School Fixed Effects"): areg r_std_feelloved $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r6b, title("Not Depressed, School Fixed Effects"): areg r_std_notdepressed $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r7b, title("Like Oneself, School Fixed Effects"): areg r_std_likeoneself $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r8b, title("Chances Live to 35, School Fixed Effects"): areg r_std_liveto35 $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
estout using "tables\Table4_Psychological.txt",
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;

* TABLE 6A -  Behavior in School;
eststo r1a, title("Trouble with Teacher"): reg r_std_trouble_teacher $race $controls_basic [pweight = r_schoolweight], r;
eststo r2a, title("Trouble Paying Attention"): reg r_std_trouble_payattention $race $controls_basic [pweight = r_schoolweight], r;
eststo r3a, title("Trouble with Homework"): reg r_std_trouble_homework $race $controls_basic [pweight = r_schoolweight], r;
eststo r4a, title("Trouble with Students"): reg r_std_trouble_getalong $race $controls_basic [pweight = r_schoolweight], r;
eststo r5a, title("Effort on Schoolwork"): reg r_std_effortschool $race $controls_basic [pweight = r_schoolweight], r;
eststo r6a, title("Skipping School"): reg r_std_skipschool $race $controls_basic [pweight = r_schoolweight], r;
eststo r7a, title("Ever Suspended or Expelled"): reg r_notsuspendedexpelled $race $controls_basic [pweight = r_homeweight], r;
eststo r1b, title("Trouble with Teacher, School Fixed Effects"): areg r_std_trouble_teacher $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r2b, title("Trouble Paying Attention, School Fixed Effects"): areg r_std_trouble_payattention $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r3b, title("Trouble with Homework, School Fixed Effects"): areg r_std_trouble_homework $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r4b, title("Trouble with Students, School Fixed Effects"): areg r_std_trouble_getalong $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r5b, title("Effort on Schoolwork, School Fixed Effects"): areg r_std_effortschool $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r6b, title("Skipping School, School Fixed Effects"): areg r_std_skipschool $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r7b, title("Ever Suspended or Expelled, School Fixed Effects"): areg r_notsuspendedexpelled $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
estout using "tables\Table6A_BehaviorInSchool.txt",
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;


* TABLE 6B - Behavior Outside School;
eststo r1a, title("Watch TV"): reg r_std_watchtv $race $controls_basic [pweight = r_schoolweight], r;
eststo r2a, title("Drinking"): reg r_std_drink $race $controls_basic [pweight = r_schoolweight], r;
eststo r3a, title("Smoking"): reg r_std_smoke $race $controls_basic [pweight = r_schoolweight], r;
eststo r4a, title("Daring"): reg r_std_dare $race $controls_basic [pweight = r_schoolweight], r;
eststo r5a, title("Lie to Parents"): reg r_std_lietoparents $race $controls_basic [pweight = r_schoolweight], r;
eststo r6a, title("Fight"): reg r_std_fight $race $controls_basic [pweight = r_schoolweight], r;
eststo r7a, title("Property Damage"): reg r_std_propertydamage $race $controls_basic [pweight = r_homeweight], r;
eststo r8a, title("Steal"): reg r_std_steal $race $controls_basic [pweight = r_homeweight], r;
eststo r9a, title("Violent Acts"): reg r_std_violentacts $race $controls_basic [pweight = r_homeweight], r;
eststo r10a, title("Sell Drugs"): reg r_std_selldrugs $race $controls_basic [pweight = r_homeweight], r;
eststo r11a, title("See Violence"): reg r_std_encounteredviolence $race $controls_basic [pweight = r_homeweight], r;
eststo r12a, title("Ever Sex"): reg r_sex $race $controls_basic [pweight = r_homeweight], r;
eststo r13a, title("Ever STD"): reg r_std $race $controls_basic [pweight = r_homeweight], r;
eststo r14a, title("Ever Illegal Drugs"): reg r_drugs $race $controls_basic [pweight = r_homeweight], r;
eststo r1b, title("Watch TV, School Fixed Effects"): areg r_std_watchtv $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r2b, title("Drinking, School Fixed Effects"): areg r_std_drink $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r3b, title("Smoking, School Fixed Effects"): areg r_std_smoke $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r4b, title("Daring, School Fixed Effects"): areg r_std_dare $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r5b, title("Lie to Parents, School Fixed Effects"): areg r_std_lietoparents $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r6b, title("Fight, School Fixed Effects"): areg r_std_fight $race $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r7b, title("Property Damage, School Fixed Effects"): areg r_std_propertydamage $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r8b, title("Steal, School Fixed Effects"): areg r_std_steal $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r9b, title("Violent Acts, School Fixed Effects"): areg r_std_violentacts $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r10b, title("Sell Drugs, School Fixed Effects"): areg r_std_selldrugs $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r11b, title("See Violence, School Fixed Effects"): areg r_std_encounteredviolence $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r12b, title("Ever Sex, School Fixed Effects"): areg r_sex $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r13b, title("Ever STD, School Fixed Effects"): areg r_std $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
eststo r14b, title("Ever Illegal Drugs, School Fixed Effects"): areg r_drugs $race $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
estout using "tables\Table6B_BehaviorOutsideSchool.txt",
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;



*** standardize residuals for BAD BEHAVIORS;
areg r_std_trouble_teacher $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_trouble_teacher, residuals;
areg r_std_trouble_payattention $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_trouble_payattention, residuals;
areg r_std_trouble_homework $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_trouble_homework, residuals;
areg r_std_trouble_getalong $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_trouble_getalong, residuals;
areg r_std_effortschool $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_effortschool, residuals;
areg r_std_skipschool $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_skipschool, residuals;
areg r_notsuspendedexpelled $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_notsuspendedexpelled, residuals;
areg r_std_watchtv $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_watchtv, residuals;
areg r_std_drink $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_drink, residuals;
areg r_std_smoke $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_smoke, residuals;
areg r_std_dare $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_dare, residuals;
areg r_std_lietoparents $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_lietoparents, residuals;
areg r_std_fight $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_fight, residuals;
areg r_std_propertydamage $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_propertydamage, residuals;
areg r_std_steal $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_steal, residuals;
areg r_std_violentacts $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_violentacts, residuals;
areg r_std_selldrugs $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_selldrugs, residuals;
areg r_std_encounteredviolence $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_encounteredviolence, residuals;
areg r_sex $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_sex, residuals;
areg r_std $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_std, residuals;
areg r_drugs $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_drugs, residuals;

foreach variable in $badbehav_res {;
	
	egen r_std`variable'=std(r_`variable');
	
	};

*TABLE 9;
*which behaviors are stat different for blacks and whites?;
areg r_std_trouble_teacher $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_trouble_payattention $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_trouble_homework $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_trouble_getalong $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_effortschool $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_skipschool $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_notsuspendedexpelled $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);

areg r_std_watchtv $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_drink $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_smoke $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_dare $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_lietoparents $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_fight $race_alt $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_propertydamage $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_steal $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_violentacts $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_selldrugs $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std_encounteredviolence $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_sex $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_std $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
areg r_drugs $race_alt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);


*factor analyze typical black behaviors;	
factor r_stdres_trouble_teacher r_stdres_trouble_payattention r_stdres_trouble_homework r_stdres_trouble_getalong r_stdres_watchtv r_stdres_fight, factors(1) altdivisor;
predict tBlack;
* men typical black behaviors;
egen tBlack2=rowmean( r_stdres_trouble_teacher r_stdres_trouble_payattention r_stdres_trouble_homework r_stdres_trouble_getalong r_stdres_watchtv r_stdres_fight r_stdres_violentacts r_stdres_sex r_stdres_std);

* percent blacks in school;
by r_schoolid, sort: egen pBlack=mean(r_black);

mat T1 = J(22,1,.);
mat colnames T1 = Index_Value;
mat rownames T1 = 1Qtile 1Qtile_se 2Qtile 2Qtile_se 3Qtile 3Qtile_se 4Qtile 4Qtile_se;

mean tBlack if r_mixed==1 & pBlack<=.0412595; 						*1st quartile;
mat T1[1, 1] = _b[tBlack];
mat T1[2, 1] = _se[tBlack];
mean tBlack if r_mixed==1 & pBlack>.0412595  & pBlack<=.1723716; 	*2nd quartile;
mat T1[3, 1] = _b[tBlack];
mat T1[4, 1] = _se[tBlack];
mean tBlack if r_mixed==1 & pBlack>.1723716  & pBlack<=.4847458; 	*3rd quartile;
mat T1[5, 1] = _b[tBlack];
mat T1[6, 1] = _se[tBlack];
mean tBlack if r_mixed==1 & pBlack>.4847458; 						*4th quartile;
mat T1[7, 1] = _b[tBlack];
mat T1[8, 1] = _se[tBlack];


di "Table 7";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Table7.txt") title("Table 9 Data") note("-----") format("%11.5f") replace;

mat drop _all;

* FIGURE 3 - AddHealth;
*** standardize residuals for HOME ENVIRONMENT variables;
areg r_lhhincome $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_lhhincome, residuals;
areg r_nowelfare $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_nowelfare, residuals;
areg r_fatherinhh $controls_homeenv [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_fatherinhh, residuals;
areg r_married $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_married, residuals;
areg r_momage $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_momage, residuals;
areg r_momcolgrad $controls_homeenv [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_momcolgrad, residuals;
areg r_momevermarried $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_momevermarried, residuals;
areg r_yrsinresidence $controls_homeenv [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_yrsinresidence, residuals;

foreach variable in res_lhhincome res_nowelfare res_fatherinhh res_married res_momage res_momcolgrad res_momevermarried res_yrsinresidence {;
	
	egen r_std`variable'=std(r_`variable');
	
	};

*** standardize residuals for PHYSICAL variables;
areg r_birthweight $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_birthweight, residuals;
areg r_height $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_height, residuals;
areg r_bmi $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_bmi, residuals;
areg r_std_attractive $controls_phys [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_attractive, residuals;

foreach variable in res_birthweight res_height res_bmi res_attractive {;
	
	egen r_std`variable'=std(r_`variable');
	
	};

*** standardize residuals for ACHIEVEMENT variables;
areg r_nolearndisable $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_nolearndisable, residuals;
areg r_std_ahpvt $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_ahpvt, residuals;
areg r_gpa $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_gpa, residuals;
areg r_norepeatgrade $controls_basic [pweight = r_homeweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_norepeatgrade, residuals;

foreach variable in res_nolearndisable res_ahpvt res_gpa res_norepeatgrade {;
	
	egen r_std`variable'=std(r_`variable');
	
	};

*** standardize residuals for PSYCHOLOGICAL variables;
areg r_std_momcares $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_momcares, residuals;
areg r_std_dadcares $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_dadcares, residuals;
areg r_std_feelclose $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_feelclose, residuals;
areg r_std_feelaccepted $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_feelaccepted, residuals;
areg r_std_feelloved $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_feelloved, residuals;
areg r_std_notdepressed $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_notdepressed, residuals;
areg r_std_likeoneself $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_likeoneself, residuals;
areg r_std_liveto35 $controls_basic [pweight = r_schoolweight], absorb(r_schoolid) cluster(r_schoolid);
predict double r_res_liveto35, residuals;

foreach variable in res_momcares res_dadcares res_feelclose res_feelaccepted res_feelloved res_notdepressed res_likeoneself res_liveto35 {;
	
	egen r_std`variable'=std(r_`variable');
	
	};

***reverse sign on some vars such that bigger is better;
foreach variable in r_stdres_watchtv r_stdres_drink r_stdres_smoke r_stdres_dare r_stdres_lietoparents r_stdres_fight r_stdres_propertydamage r_stdres_steal r_stdres_violentacts r_stdres_selldrugs r_stdres_encounteredviolence r_stdres_sex r_stdres_std r_stdres_drugs r_stdres_skipschool r_stdres_trouble_getalong r_stdres_trouble_homework r_stdres_trouble_payattention r_stdres_trouble_teacher r_stdres_bmi {;
	
	replace `variable' = -`variable';
	
	};




mat T1 = J(6,6,.);
mat colnames T1 = white white_se white_ci black black_se black_ci;
mat rownames T1 = homeenv physical achievement psychology schoolbehav homebehav;


*** create indices;
egen r_index_homeenv = rowmean(r_stdres_lhhincome r_stdres_nowelfare r_stdres_fatherinhh r_stdres_married r_stdres_momage r_stdres_momcolgrad r_stdres_momevermarried r_stdres_yrsinresidence);
egen r_index_homeenv_std = std(r_index_homeenv);
egen r_index_physical = rowmean(r_stdres_birthweight r_stdres_height r_stdres_bmi r_stdres_attractive);
egen r_index_physical_std = std(r_index_physical);
egen r_index_achievement = rowmean(r_stdres_nolearndisable r_stdres_ahpvt r_stdres_gpa r_stdres_norepeatgrade);
egen r_index_achievement_std = std(r_index_achievement);
egen r_index_psychology = rowmean(r_stdres_momcares r_stdres_dadcares r_stdres_feelclose r_stdres_feelaccepted r_stdres_feelloved r_stdres_notdepressed r_stdres_likeoneself r_stdres_liveto35);
egen r_index_psychology_std = std(r_index_psychology);
egen r_index_schoolbehav = rowmean(r_stdres_trouble_teacher r_stdres_trouble_payattention r_stdres_trouble_homework r_stdres_trouble_getalong r_stdres_effortschool r_stdres_skipschool r_stdres_notsuspendedexpelled);
egen r_index_schoolbehav_std = std(r_index_schoolbehav);
egen r_index_homebehav = rowmean(r_stdres_watchtv r_stdres_drink r_stdres_smoke r_stdres_dare r_stdres_lietoparents r_stdres_fight r_stdres_propertydamage r_stdres_steal r_stdres_violentacts r_stdres_selldrugs r_stdres_encounteredviolence r_stdres_sex r_stdres_std r_stdres_drugs);
egen r_index_homebehav_std = std(r_index_homebehav);


loc rnum = 1;
foreach var in homeenv physical achievement psychology schoolbehav homebehav {;

reg r_index_`var'_std $race [pweight = r_schoolweight], r;
mat T1[`rnum', 1] = _b[r_white];
mat T1[`rnum', 2] = _se[r_white];
mat T1[`rnum', 3] = _se[r_white]*invttail(e(df_r),0.025);
mat T1[`rnum', 4] = _b[r_black];
mat T1[`rnum', 5] = _se[r_black];
mat T1[`rnum', 6] = _se[r_black]*invttail(e(df_r),0.025);
loc ++rnum;

};

di "Figure 3 - AddHealth Data";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Figure3_AddHealth Data.txt") title("Composite Outcome - AddHealth Data") note("-----") format("%11.5f") replace;
mat drop _all;

*----------------------------------------------*

           Bringing in Census Data

*----------------------------------------------*;

*KIDS;
infix
 int     year                                 1-4
 double  serial                               5-12
 int     hhwt                                13-16
 byte    region                              17-18
 byte    statefip                            19-20
 byte    metro                               21
 byte    gq                                  22
 long    hhincome                            23-29
 byte    nmothers                            30
 byte    nfathers                            31
 int     pernum                              32-35
 int     perwt                               36-39
 byte    momloc                              40-41
 byte    poploc                              42-43
 byte    famsize                             44-45
 byte    nsibs                               46
 int     age                                 47-49
 byte    sex                                 50
 byte    marst                               51
 int     race                                52
 int     raced                               53-55
 long    bpl                                 56-58
 long    bpld                                59-63
 byte    citizen                             64
 byte    yrsusa1                             65-66
 int     language                            67-68
 int     languaged                           69-72
 byte    speakeng                            73
 int     hispan                              74
 int     hispand                             75-77
 byte    racesing                            78
 byte    racesingd                           79-80
 byte    racnum                              81
 byte    school                              82
 byte    educrec                             83
 byte    educ99                              84-85
 byte    gradeatt                            86
 byte    schltype                            87
 byte    empstat                             88
 byte    empstatd                            89-90
 byte    uhrswork                            91-92
 long    inctot                              93-98
 long    incwelfr                            99-103
 int     poverty                            104-106
 byte    occscore                           107-108
 byte    migrate5                           109
 byte    migrate5d                          110-111
 byte    vetstat                            112
 byte    vetyrs                             113-114
 int     pernum_mom                         115-118
 int     pernum_pop                         119-122
 int     perwt_mom                          123-126
 int     perwt_pop                          127-130
 int     age_mom                            131-133
 int     age_pop                            134-136
 byte    sex_mom                            137
 byte    sex_pop                            138
 byte    marst_mom                          139
 byte    marst_pop                          140
 int     race_mom                           141
 int     race_pop                           142
 int     raced_mom                          143-145
 int     raced_pop                          146-148
 byte    citizen_mom                        149
 byte    citizen_pop                        150
 byte    yrsusa1_mom                        151-152
 byte    yrsusa1_pop                        153-154
 int     hispan_mom                         155
 int     hispan_pop                         156
 int     hispand_mom                        157-159
 int     hispand_pop                        160-162
 byte    racesing_mom                       163
 byte    racesing_pop                       164
 byte    racesingd_mom                      165-166
 byte    racesingd_pop                      167-168
 byte    racnum_mom                         169
 byte    racnum_pop                         170
 byte    school_mom                         171
 byte    school_pop                         172
 byte    educrec_mom                        173
 byte    educrec_pop                        174
 byte    educ99_mom                         175-176
 byte    educ99_pop                         177-178
 byte    gradeatt_mom                       179
 byte    gradeatt_pop                       180
 byte    schltype_mom                       181
 byte    schltype_pop                       182
 byte    empstat_mom                        183
 byte    empstat_pop                        184
 byte    empstatd_mom                       185-186
 byte    empstatd_pop                       187-188
 long    inctot_mom                         189-194
 long    inctot_pop                         195-200
 long    incwelfr_mom                       201-205
 long    incwelfr_pop                       206-210
 byte    occscore_mom                       211-212
 byte    occscore_pop                       213-214
 byte    vetstat_mom                        215
 byte    vetstat_pop                        216
 byte    vetyrs_mom                         217-218
 byte    vetyrs_pop                         219-220
using clean_data\census2000kids.dat, clear;

drop if age < 10 | age > 19;
quietly: compress;
save clean_data/census2000kids, replace;



*ADULTS;
infix ///
 byte    region                               1-2 ///
 byte    statefip                             3-4 ///
 byte    metro                                5 ///
 byte    gq                                   6 ///
 byte    ownershp                             7 ///
 byte    ownershpd                            8-9 ///
 long    hhincome                            10-16 ///
 long    valueh                              17-23 ///
 int     perwt                               24-27 ///
 byte    nchild                              28 ///
 int     age                                 29-31 ///
 byte    sex                                 32 ///
 byte    marst                               33 ///
 int     race                                34 ///
 int     raced                               35-37 ///
 long    bpl                                 38-40 ///
 int     hispan                              41 ///
 int     hispand                             42-44 ///
 byte    racesing                            45 ///
 byte    racesingd                           46-47 ///
 byte    racamind                            48 ///
 byte    racasian                            49 ///
 byte    racblk                              50 ///
 byte    racpacis                            51 ///
 byte    racwht                              52 ///
 byte    racother                            53 ///
 byte    racnum                              54 ///
 byte    school                              55 ///
 int     educ                                56-57 ///
 int     educd                               58-60 ///
 byte    gradeatt                            61 ///
 byte    gradeattd                           62-63 ///
 byte    empstatd                            64-65 ///
 byte    wkswork1                            66-67 ///
 int     poverty                             68-70 ///
 byte    occscore                            71-72 ///
 byte    migrate5                            73 ///
 byte    migrate5d                           74-75 ///
 byte    disabwrk                            76 ///
 byte    diffrem                             77 ///
 byte    diffphys                            78 ///
 byte    diffmob                             79 ///
 byte    diffcare                            80 ///
 byte    diffsens                            81 ///
 int     race_sp                             82 ///
 int     raced_sp                            83-85 ///
 int     hispan_sp                           86 ///
 int     hispand_sp                          87-89 ///
 byte    racesing_sp                         90 ///
 byte    racesingd_sp                        91-92 ///
 byte    racamind_sp                         93 ///
 byte    racasian_sp                         94 ///
 byte    racblk_sp                           95 ///
 byte    racpacis_sp                         96 ///
 byte    racwht_sp                           97 ///
 byte    racother_sp                         98 ///
 byte    racnum_sp                           99 ///
using clean_data/census2000adults.dat, clear;

drop if age < 18;
quietly: compress;
save clean_data/census2000adults, replace;




*----------------------------------------------*

          Cleaning Census Kids Data

*----------------------------------------------*;

use clean_data/census2000kids, clear;


** DROPS;

*RACE;
keep if raced == 100 | raced == 200 | raced == 801;

*HISPANIC;
drop if hispan > 0;


** DEMOGRAPHICS;

*RACE;
gen r_white = 0;
replace r_white = 1 if raced == 100;
gen r_black = 0;
replace r_black = 1 if raced == 200;
gen r_mixed = 0;
replace r_mixed = 1 if raced == 801;
label variable r_white "White";
label variable r_black "Black";

*GENDER;
gen r_male = 0;
replace r_male = 1 if sex == 1;
gen r_female = 0;
replace r_female = 1 if sex == 2;

*AGE;
rename age r_age;
gen r_age_sq = r_age^2;

gen r_age_l13=0;
replace r_age_l13=1 if r_age>=10 & r_age<=13;
gen r_age_13t15=0;
replace r_age_13t15=1 if r_age>13 & r_age<=15;
gen r_age_15t17=0;
replace r_age_15t17=1 if r_age>15 & r_age<=17;
gen r_age_17plus=0;
replace r_age_17plus=1 if r_age>17;


*BORN IN US;
gen r_bornus = 0;
replace r_bornus = 1 if bpl >= 1 & bpl <= 56;

*REGION;
gen r_northeast = 0;
replace r_northeast = 1 if region == 11 | region == 12;
gen r_midwest = 0;
replace r_midwest = 1 if region == 21 | region == 22;
gen r_south = 0;
replace r_south = 1 if region == 31 | region == 32 | region == 33;
gen r_west = 0;
replace r_west = 1 if region == 41 | region == 42;


** HOME ENVIRONMENT OUTCOMES;

*HOUSEHOLD INCOME;
gen r_hhincome = .;
replace r_hhincome = hhincome if hhincome >= 0 & hhincome < 9999999;
gen r_lhhincome = ln(r_hhincome);

*NOT ON WELFARE;
gen r_nowelfare = .;
replace r_nowelfare = 0 if (incwelfr > 0 & incwelfr < 99999);
replace r_nowelfare = 1 if incwelfr == 0;

*FATHER IN HOUSEHOLD;
gen r_fatherinhh = .;
replace r_fatherinhh = 0 if poploc == 0;
replace r_fatherinhh = 1 if poploc > 0;

*PARENTS MARRIED;
gen r_married = .;
replace r_married = 0 if (marst_mom > 1 & marst_mom < .) | (marst_pop > 1 & marst_pop < .);
replace r_married = 1 if marst_mom == 1 & marst_pop == 1;

*MOTHER'S AGE;
rename age_mom r_momage;

*MOTHER IS A COLLEGE GRADUATE;
gen r_momcolgrad = .;
replace r_momcolgrad = 0 if educ99_mom < 15;
replace r_momcolgrad = 1 if educ99_mom >= 15 & educ99_mom <= 18;

*MOTHER EVER MARRIED;
gen r_momevermarried = .;
replace r_momevermarried = 0 if marst_mom == 6;
replace r_momevermarried = 1 if marst_mom >= 1 & marst_mom <= 5;

*NOT MIGRATED WITHIN LAST 5 YEARS;
gen r_nomigrate5yrs = .;
replace r_nomigrate5yrs = 0 if migrate5 > 1; 
replace r_nomigrate5yrs = 1 if migrate5 == 1;

*WEIGHT;
gen r_weight = perwt;

* STATE;
rename statefip r_state;

keep r_*;
quietly: compress;
save analysis_data/census2000kids_analysis, replace;




*----------------------------------------------*

            Census Kids Regressions

*----------------------------------------------*;

use analysis_data/census2000kids_analysis, clear;

* TABLE 2B - Home Environment - Raw Data(Census); 

mat T1 = J(16,4,.);
mat colnames T1 = Full_Sample	White	Black	Mixed;		
mat rownames T1 = lhhincome lhhincome_se nowelfare nowelfare_se fatherinhh fatherinhh_se married married_se momage momage_se momcolgrad momcolgrad_se momevermarried momevermarried_se nomigrate5yrs nomigrate5yrs_se ;

loc lnum = -1;
local lnum1 = `lnum' + 1;

foreach var in lhhincome nowelfare fatherinhh married momage momcolgrad momevermarried nomigrate5yrs {;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var' [aweight=r_weight];
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);

sum r_`var' [aweight=r_weight] if r_white==1;
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);

sum r_`var' [aweight=r_weight] if r_black==1;
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);

sum r_`var' [aweight=r_weight] if r_mixed==1;
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);

};


di "Table 2B: Home Environment - RAW DATA(Census)";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Table2B_HomeEnvironment_Census_Raw.txt") title("Table 2B: Home Environment - RAW DATA(Census)") note("-----") format("%11.5f") replace;

mat drop _all;

* TABLE 2B - Home Environment (Census); 
eststo r1, title("Household Income (log)"): areg r_lhhincome $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
eststo r2, title("Not on Welfare"): areg r_nowelfare $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
eststo r3, title("Father in Household"): areg r_fatherinhh $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
eststo r4, title("Parents Married"): areg r_married $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
eststo r5, title("Mother's Age"): areg r_momage $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
eststo r6, title("Mother is College Graduate"): areg r_momcolgrad $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
eststo r7, title("Mother Ever Married"): areg r_momevermarried $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
eststo r8, title("Years in Current Residence"): areg r_nomigrate5yrs $race $controls_census_kids [pweight=r_weight], r absorb(r_state);
estout using tables/Table2B_HomeEnvironment_Census.txt,
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;



*----------------------------------------------*

         Cleaning Census Adults Data

*----------------------------------------------*;

use clean_data/census2000adults, clear;


** DROPS;

*RACE;
keep if raced == 100 | raced == 200 | raced == 801;

*HISPANIC;
drop if hispand > 0;


** DEMOGRAPHICS;

*RACE;
gen r_white = 0;
replace r_white = 1 if raced == 100;
gen r_black = 0;
replace r_black = 1 if raced == 200;
gen r_mixed = 0;
replace r_mixed = 1 if raced == 801;
label variable r_white "White";
label variable r_black "Black";

*GENDER;
gen r_male = 0;
replace r_male = 1 if sex == 1;
gen r_female = 0;
replace r_female = 1 if sex == 2;

*AGE;
rename age r_age;
gen r_age_sq = r_age^2;

gen r_age_18t20=0;
replace r_age_18t20=1 if r_age>=18 & r_age<=20;
gen r_age_20t25=0;
replace r_age_20t25=1 if r_age>20 & r_age<=25;
gen r_age_25t30=0;
replace r_age_25t30=1 if r_age>25 & r_age<=30;
gen r_age_30t35=0;
replace r_age_30t35=1 if r_age>30 & r_age<=35;
gen r_age_35t40=0;
replace r_age_35t40=1 if r_age>35 & r_age<=40;
gen r_age_40t45=0;
replace r_age_40t45=1 if r_age>40 & r_age<=45;
gen r_age_45t50=0;
replace r_age_45t50=1 if r_age>45 & r_age<=50;
gen r_age_50t55=0;
replace r_age_50t55=1 if r_age>50 & r_age<=55;
gen r_age_55t60=0;
replace r_age_55t60=1 if r_age>55 & r_age<=60;
gen r_age_60t65=0;
replace r_age_60t65=1 if r_age>60 & r_age<=65;
gen r_age_65t70=0;
replace r_age_65t70=1 if r_age>65 & r_age<=70;
gen r_age_70t75=0;
replace r_age_70t75=1 if r_age>70 & r_age<=75;
gen r_age_75t80=0;
replace r_age_75t80=1 if r_age>75 & r_age<=80;
gen r_age_80plus=0;
replace r_age_80plus=1 if r_age>80;


*BORN IN US;
gen r_bornus = 0;
replace r_bornus = 1 if bpl >= 100 & bpl <= 5600;

*REGION;
gen r_northeast = 0;
replace r_northeast = 1 if region == 11 | region == 12;
gen r_midwest = 0;
replace r_midwest = 1 if region == 21 | region == 22;
gen r_south = 0;
replace r_south = 1 if region == 31 | region == 32 | region == 33;
gen r_west = 0;
replace r_west = 1 if region == 41 | region == 42;


** OUTCOME VARIABLES;

*MARRIED;
gen r_married = .;
replace r_married = 0 if marst > 2;
replace r_married = 1 if marst == 1 | marst == 2;

*HAVE CHILDREN;
gen r_children = .;
replace r_children = 0 if nchild == 0;
replace r_children = 1 if nchild > 0;

*BACHELOR'S DEGREE;
gen r_bachelors = .;
replace r_bachelors = 0 if educd >=2 & educd<=81;
replace r_bachelors = 1 if educd >= 101 & educd <= 116;

*EMPLOYED;
gen r_employed = .;
replace r_employed = 0 if empstatd >= 20;
replace r_employed = 1 if empstatd < 20 & empstatd > 0;

*WEEKS WORKED LAST YEAR;
gen r_weeksworked = .;
replace r_weeksworked = wkswork1 if wkswork1 > 0;

*OCCUPATIONAL SCORE;
gen r_occscore = .;
replace r_occscore = occscore if occscore > 0;
egen r_std_occscore = std(r_occscore);

*HOUSEHOLD INCOME;
gen r_hhincome = .;
replace r_hhincome = hhincome if (hhincome >= 0 & hhincome < 9999999);
gen r_lhhincome = ln(r_hhincome);

*POOR;
gen r_poor = .;
replace r_poor = 0 if poverty >= 100;
replace r_poor = 1 if poverty > 0 & poverty < 100;

*NOT MIGRATED WITHIN LAST 5 YEARS;
gen r_nomigrate5yrs = .;
replace r_nomigrate5yrs = 0 if migrate5 > 1; 
replace r_nomigrate5yrs = 1 if migrate5 == 1;

*OWN HOME;
gen r_ownhome = .;
replace r_ownhome = 0 if ownershp == 2;
replace r_ownhome = 1 if ownershp == 1;

*VALUE OF HOUSE;
gen r_valuehouse = .;
replace r_valuehouse = valueh if (valueh >= 0 & valueh < 9999999);
gen r_lvaluehouse = ln(r_valuehouse);

*LIVE OUTSIDE CITY CENTER;
gen r_outsidecitycenter = .;
replace r_outsidecitycenter = 0 if metro == 1 | metro == 2;
replace r_outsidecitycenter = 1 if metro == 3;

*INSTITUTIONALIZED;
gen r_institute = .;
replace r_institute = 0 if gq == 1 | gq == 2 | gq == 4 | gq == 5;
replace r_institute = 1 if gq == 3;

*DISABLED;
gen r_disabled = .;
replace r_disabled = 0 if disabwrk == 1 & diffrem == 1 & diffphys == 1 & diffmob == 1 & diffcare == 1 & diffsens == 1;
replace r_disabled = 1 if disabwrk == 4 | diffrem == 2 | diffphys == 2 | diffmob == 2 | diffcare == 2 | diffsens == 2;

*WEIGHT;
gen r_weight = perwt;

* STATE;
rename statefip r_state;

keep r_*;
quietly: compress;
save analysis_data/census2000adults_analysis, replace;



*----------------------------------------------*

          Census Adults Summary Stats

*----------------------------------------------*;

use analysis_data/census2000adults_analysis, clear;

* TABLE 0 - ADULT OUTCOMES RAW DATA;
mat T1 = J(28,4,.);
mat colnames T1 = Full_Sample	White	Black	Mixed;		
mat rownames T1 = married	married_se	children	children_se	bachelors	bachelors_se	employed	employed_se	weeksworked	weeksworked_se	std_occscore	std_occscore_se	lhhincome	lhhincome_se	poor	poor_se	nomigrate5yrs	nomigrate5yrs_se	ownhome	ownhome_se	lvaluehouse	lvaluehouse_se	outsidecitycenter	outsidecitycenter_se	institute	institute_se	disabled	disabled_se ;

loc lnum = -1;
local lnum1 = `lnum' + 1;

foreach var in married children bachelors employed weeksworked  std_occscore lhhincome poor  nomigrate5yrs ownhome lvaluehouse outsidecitycenter institute disabled {;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

sum r_`var';
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);

sum r_`var' if r_white==1;
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);

sum r_`var' if r_black==1;
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);

sum r_`var' if r_mixed==1;
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);

};


di "Table 0 - CENSUS - Adult Outcomes RAW DATA";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Table0_AdultOutcomes.txt") title("Table0_CENSUS - Adult Outcomes") note("-----") format("%11.5f") replace;

mat drop _all;




*----------------------------------------------*

          Census Adults Regressions

*----------------------------------------------*;


use analysis_data/census2000adults_analysis, clear;

* TABLE 5: Adult Outcomes, All Ages (Census);
eststo r1, title ("Married"): 							xi: areg r_married $race r_female r_bornus				i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r2, title ("Have Children"): 					xi: areg r_children $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r3, title ("Bachelor's Degree"): 				xi: areg r_bachelors $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r4, title ("Employed"): 							xi: areg r_employed $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r5, title ("Weeks Worked Last Year"): 			xi: areg r_weeksworked $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r6, title ("Occupational Score"): 				xi: areg r_std_occscore $race r_female r_bornus 		i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r7, title ("Household Income (log)"): 			xi: areg r_lhhincome $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r8, title ("Poor"): 								xi: areg r_poor $race r_female r_bornus					i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r9, title ("Not Migrated within Last 5 Years"): 	xi: areg r_nomigrate5yrs $race r_female r_bornus 		i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r10, title ("Own Home"): 						xi: areg r_ownhome $race r_female r_bornus 				i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r11, title ("Value House (log)"): 				xi: areg r_lvaluehouse $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r12, title ("Live Outside City Center"): 		xi: areg r_outsidecitycenter $race r_female r_bornus 	i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r13, title ("Institutionalized"): 				xi: areg r_institute $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
eststo r14, title ("Disabled"): 						xi: areg r_disabled $race r_female r_bornus 			i.r_age [pweight=r_weight], r absorb(r_state) ;
estout using "tables/Table5_Census_AllAge.txt",
replace
keep($race)
collabels(none)
label
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""')))
starlevels(* .10 ** .05 *** .01)
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;





* FIGURE 3 - CENSUS - Adult Outcomes;
*** Standardize residuals for ADULT variables;
areg r_married $controls_census_adults [pweight=r_weight], r absorb(r_state) ;
predict double r_res_married, residuals;
areg r_children $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_children, residuals;
areg r_bachelors $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_bachelors, residuals;
areg r_employed $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_employed, residuals;
areg r_weeksworked $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_weeksworked, residuals;
areg r_std_occscore $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_occscore, residuals;
areg r_lhhincome $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_lhhincome, residuals;
areg r_poor $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_poor, residuals;
areg r_nomigrate5yrs $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_nomigrate5yrs, residuals;
areg r_ownhome $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_ownhome, residuals;
areg r_lvaluehouse $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_lvaluehouse, residuals;
areg r_outsidecitycenter $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_outsidecitycenter, residuals;
areg r_institute $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_institute, residuals;
areg r_disabled $controls_census_adults [pweight=r_weight], r absorb(r_state);
predict double r_res_disabled, residuals;	


foreach variable in res_married res_children res_bachelors res_employed res_weeksworked res_occscore res_lhhincome res_poor res_nomigrate5yrs res_ownhome res_lvaluehouse res_outsidecitycenter res_institute res_disabled {;
	
	egen r_std`variable'=std(r_`variable');
	
	};

***reverse sign on some vars such that bigger is better;
foreach variable in r_res_poor r_res_institute r_res_disabled {;
	
	replace `variable' = -`variable';
	
	};


*** create indices;
egen r_index_adult = rowmean(r_res_married r_res_children r_res_bachelors r_res_employed r_res_weeksworked r_res_occscore r_res_lhhincome r_res_poor r_res_nomigrate5yrs r_res_ownhome r_res_lvaluehouse r_res_outsidecitycenter r_res_institute r_res_disabled);
egen r_index_adult_std = std(r_index_adult);

mat T1 = J(1,6,.);
mat colnames T1 = White White_se White_ci	Black Black_se Black_ci;		
mat rownames T1 = AdultOutcomes;

reg r_index_adult_std $race [pweight = r_weight], r;
mat T1[1, 1] = _b[r_white];
mat T1[1, 2] = _se[r_white];
mat T1[1, 3] = _se[r_white]*invttail(e(df_r),0.025);
mat T1[1, 4] = _b[r_black];
mat T1[1, 5] = _se[r_black];
mat T1[1, 6] = _se[r_black]*invttail(e(df_r),0.025);


di "Figure 3 - Census - Adult Outcomes Data";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Figure3_Census_Adults_Data.txt") title("Figure 3 - Census - Adult Outcomes Data") note("-----") format("%11.5f") replace;

mat drop _all;
											




*----------------------------------------------*

         Bringing in Vital Statistics:
			Births, 1968 -2004
	
*----------------------------------------------*;

* FIGURE 2 - BIRTH OUTCOMES;
	* Black-White Births as Percentage of all Black and White Births;
	
forvalues i = 1968(1)1991 {;
use frace mrace using "clean_data\VitalStat\\`i'\natl`i'.dta", clear;


compress;

gen year = `i';

gen r_crace = -99;
replace r_crace = 11 if mrace != frace;					/*other mixed*/
replace r_crace = 10 if mrace == 1 & frace == 2;				/*white-black*/
replace r_crace = 10 if mrace == 2 & frace == 1	;			/*white-black*/
replace r_crace = 0 if mrace == 0 & frace == 0	;			/*Guamian*/
replace r_crace = 1 if mrace == 1 & frace == 1	;			/*white*/
replace r_crace = 2 if mrace == 2 & frace == 2	;			/*black*/
replace r_crace = 3 if mrace == 3 & frace == 3	;			/*Indian*/
replace r_crace = 4 if mrace == 4 & frace == 4	;			/*Chinese*/
replace r_crace = 5 if mrace == 5 & frace == 5	;			/*Japanese*/
replace r_crace = 6 if mrace == 6 & frace == 6	;			/*Hawaiian*/
replace r_crace = 7 if mrace == 7 & frace == 7	;			/*Other Nonwhite*/
replace r_crace = 7 if (mrace == 9 & frace == 9	) & year >= 1989;	/*Other Nonwhite*/
replace r_crace = 8 if mrace == 8 & frace == 8;				/*Filipino*/
replace r_crace = 9 if (mrace == 9 | frace == 9	) & year < 1989	;	/*Not stated*/
replace r_crace = 9 if (mrace == 99 | frace == 99) & year >= 1989;	/*Not stated*/

label define l_race 0"Guamian" 1"White" 2"Negro" 3"Indian" 4"Chinese" 5"Japanese" 6"Hawaiian" 7"Other non-white" 8"Filipino" 9"Unknown or not stated" 10"White-Black" 11"Other Mixed Race";
label values r_crace l_race;

label var r_crace "Race of Child";

gen r_white = 0;
replace r_white = 1		if r_crace == 1 ;
gen r_black = 0;
replace r_black = 1		if r_crace == 2 ;
gen r_blackwhite = 0;
replace r_blackwhite = 1	if r_crace == 10 ;
gen r_asian = 0;
replace r_asian = 1		if r_crace == 4 | r_crace == 5 |  r_crace == 8;
gen r_otherrace=0;
replace r_otherrace = 1		if r_crace == 0 | r_crace == 3 | r_crace == 6 | r_crace == 7;
gen r_othermixed = 0;
replace r_othermixed = 1	if r_crace == 11 ;
gen r_Mrace = 0;
replace r_Mrace = 1		if r_crace == 9;

gen dummy = r_white + r_black + r_blackwhite + r_asian + r_otherrace  + r_othermixed + r_Mrace;
tab dummy;
drop dummy*;

tab  r_crace;
tab  r_crace if r_Mrace == 0;
 
gen count = 1;

collapse (sum) r_white  r_black  r_blackwhite count (first) year if r_Mrace == 0;

gen pc_blackwhite = r_blackwhite/(r_white + r_black);
label var pc_blackwhite " Black-White Births as % of all Black and White Births";

gen pc_blackwhite_all = r_blackwhite/count;
label var pc_blackwhite_all " Black-White Births as % of all Births";

label var count "Total Births";

order year count;

quietly: compress;
save "analysis_data\VitalStat\natl`i'.dta", replace;

};


*** RACE 1992 - 2002 ***;
forvalues i = 1992(1)2002 {;
use frace mrace using "clean_data\VitalStat\\`i'\\natl`i'.dta", clear;

compress;

gen year = `i';

gen r_crace = -99;
replace r_crace = 11 if mrace != frace;			/*other mixed*/
replace r_crace = 10 if mrace == 1 & frace == 2;	/*white-black*/
replace r_crace = 10 if mrace == 2 & frace == 1;		 /*white-black*/
replace r_crace = 1 if mrace == 1 & frace == 1;		/*white*/
replace r_crace = 2 if mrace == 2 & frace == 2;		/*black*/
replace r_crace = 3 if mrace == 3 & frace == 3;		/*American Indian*/
replace r_crace = 4 if mrace == 4 & frace == 4;		/*Chinese*/
replace r_crace = 5 if mrace == 5 & frace == 5;		/*Japanese*/
replace r_crace = 6 if mrace == 6 & frace == 6;		/*Hawaiian*/
replace r_crace = 7 if mrace == 7 & frace == 7;		/*Filipino*/
replace r_crace = 18 if mrace == 18 & frace == 18;	/*Asian Indian*/	
replace r_crace = 28 if mrace == 28 & frace == 28;	/*Korean*/
replace r_crace = 38 if mrace == 38 & frace == 38;	/*Samoan*/
replace r_crace = 48 if mrace == 48 & frace == 48;	/*Vietnamese*/
replace r_crace = 58 if mrace == 58 & frace == 58;	/*Guamanian*/
replace r_crace = 68 if mrace == 68 & frace == 68;	/*Other Asian or Pacific Islander*/
replace r_crace = 78 if mrace == 78 & frace == 78;	/*Combined Other Asian or Pacific Islander*/
replace r_crace = 9 if mrace == 99 | frace == 99;	/*Not stated*/
replace r_crace = 9 if mrace == . | frace == .	;	/*Not on certificate - Coded only in 2003 and 2004*/


label define l_race 1"White" 2"Black" 3"American Indian" 4"Chinese" 5"Japanese" 6"Hawaiian" 7"Filipino"  9"Unknown or Not stated or Not on certificate" 10"White-Black"  11"Other Mixed Race" 
18"Asian Indian" 28"Korean" 38"Samoan" 48"Vietnamese" 58"Guamanian" 68"Other Asian or Pacific Islander" 78"Combined Other Asian or Pacific Islander";
label values  r_crace l_race;

label var r_crace "Race of Child";

gen r_white = 0;
replace r_white = 1		if r_crace == 1 ;
gen r_black = 0;
replace r_black = 1		if r_crace == 2 ;
gen r_blackwhite = 0;
replace r_blackwhite = 1	if r_crace == 10 ;
gen r_asian = 0;
replace r_asian = 1		if r_crace == 4 | r_crace == 5 |  r_crace == 7 | r_crace == 18 | r_crace == 28 | r_crace == 38 | r_crace == 48 | r_crace == 68 | r_crace == 78;
gen r_otherrace=0;
replace r_otherrace = 1		if r_crace == 3 | r_crace == 6 | r_crace == 58 ;
gen r_othermixed = 0;
replace r_othermixed = 1	if r_crace == 11 ;
gen r_Mrace = 0;
replace r_Mrace = 1		if r_crace == 9;

gen dummy = r_white + r_black + r_blackwhite + r_asian + r_otherrace  + r_othermixed + r_Mrace;
tab dummy;
drop dummy*;


tab  r_crace;
tab  r_crace if r_Mrace == 0;


gen count = 1;

collapse (sum) r_white  r_black  r_blackwhite count (first) year if r_Mrace == 0;

gen pc_blackwhite = r_blackwhite/(r_white + r_black);
label var pc_blackwhite " Black-White Births as % of all Black and White Births";

gen pc_blackwhite_all = r_blackwhite/count;
label var pc_blackwhite_all " Black-White Births as % of all Births";

label var count "Total Births";

order year count;


quietly: compress;
save "analysis_data\VitalStat\natl`i'.dta", replace;

};


* RACE 2003 and 2004;
forvalues i = 2003(1)2004 {;
use frace mrace using "clean_data\VitalStat\\`i'\natl`i'.dta", clear;
keep  frace mrace;
compress;

gen year = `i';

gen r_crace = -99;
replace r_crace = 11 if mrace != frace		;	/*other mixed*/;
replace r_crace = 10 if mrace == 1 & frace == 2	;	/*white-black*/;
replace r_crace = 10 if mrace == 2 & frace == 1	;	 /*white-black*/;
replace r_crace = 1 if mrace == 1 & frace == 1	;	/*white*/;
replace r_crace = 2 if mrace == 2 & frace == 2	;	/*black*/;
replace r_crace = 3 if mrace == 3 & frace == 3	;	/*American Indian*/;
replace r_crace = 4 if mrace == 4 & frace == 4	;	/*Asian / Pacific Islander Native*/;
replace r_crace = 9 if mrace == 9 | frace == 9	;	/*Unknown or not stated*/;
replace r_crace = 5 if mrace == 5 & frace == 5	;	/*Japanese*/;
replace r_crace = 6 if mrace == 6 & frace == 6	;	/*Hawaiian*/;
replace r_crace = 7 if mrace == 7 & frace == 7	;	/*Filipino*/;
replace r_crace = 18 if mrace == 18 & frace == 18;  /*Asian Indian*/;	
replace r_crace = 28 if mrace == 28 & frace == 28;	/*Korean*/;
replace r_crace = 38 if mrace == 38 & frace == 38;	/*Samoan*/;
replace r_crace = 48 if mrace == 48 & frace == 48;	/*Vietnamese*/;
replace r_crace = 58 if mrace == 58 & frace == 58;	/*Guamanian*/;
replace r_crace = 68 if mrace == 68 & frace == 68;	/*Other Asian or Pacific Islander*/;
replace r_crace = 78 if mrace == 78 & frace == 78;	/*Combined Other Asian or Pacific Islander*/;
replace r_crace = 9 if mrace == 99 | frace == 99;	/*Not stated*/;
replace r_crace = 9 if mrace == . | frace == .;		/*Missing*/;


gen r_white = 0;
replace r_white = 1		if r_crace == 1 ;
gen r_black = 0;
replace r_black = 1		if r_crace == 2 ;
gen r_blackwhite = 0;
replace r_blackwhite = 1	if r_crace == 10 ;
gen r_asian = 0;
replace r_asian = 1		if r_crace == 4 ;
gen r_otherrace=0;
replace r_otherrace = 1		if r_crace == 3 ;
gen r_othermixed = 0;
replace r_othermixed = 1	if r_crace == 11 ;
gen r_Mrace = 0;
replace r_Mrace = 1		if r_crace == 9;

gen dummy = r_white + r_black + r_blackwhite + r_asian + r_otherrace  + r_othermixed + r_Mrace;
tab dummy;
drop dummy*;


tab  r_crace;
tab  r_crace if r_Mrace == 0;

 
gen count = 1;

collapse (sum) r_white  r_black  r_blackwhite count (first) year if r_Mrace == 0;

gen pc_blackwhite = r_blackwhite/(r_white + r_black);
label var pc_blackwhite " Black-White Births as % of all Black and White Births";

gen pc_blackwhite_all = r_blackwhite/count;
label var pc_blackwhite_all " Black-White Births as % of all Births";

label var count "Total Births";

order year count;

quietly: compress;
save "analysis_data\VitalStat\natl`i'.dta", replace;

};


* Appending;
use "analysis_data\VitalStat\natl1968.dta", clear;

forvalues i = 1969(1)2004 {;

append using  "analysis_data\VitalStat\natl`i'.dta";

};

order year r_white r_black r_blackwhite ;

quietly: compress;
save "analysis_data\natl1968-2004_AllBirths.dta", replace;

xmlsave "tables\Figure2_VitalStat1968_2004_AllBirths", doctype(excel)  replace;
clear;



*----------------------------------------------*

       Bringing in VITAL STAT Data:
	Births and Infant Mortality, 2000
*----------------------------------------------*;

use "clean_data\linkco2000us_den.dta", clear;
keep matchs idnumber recwt stoccfipb brstate biryr csex dmage mrace dmeduc dmar frace dbirwt anemia diabetes gestat tobacco alcohol drink cigar distress;

* ID;
rename  idnumber r_idnumber;

* INFANT DEATH DUMMY;
rename  matchs r_matchs;

gen r_death = 0;
replace r_death = 1 if r_matchs == 1;

gen r_Mdeath = 0;
replace r_Mdeath =  1 if r_matchs != 1 & r_matchs != 2;
replace r_death = 0 if r_Mdeath == 1;

tab r_death;


* PERSON/RECORD WEIGHT;
rename recwt r_weight ;
label var r_weight "Record Weight";

* STATE ;
gen r_stated = "";
replace r_stated = "AL" if stoccfipb == 1;
replace r_stated = "AK" if stoccfipb == 2;
replace r_stated = "AZ" if stoccfipb == 3;
replace r_stated = "AR" if stoccfipb == 4;
replace r_stated = "CA" if stoccfipb == 5;
replace r_stated = "CO" if stoccfipb == 6;
replace r_stated = "CT" if stoccfipb == 7;
replace r_stated = "DE" if stoccfipb == 8;
replace r_stated = "DC" if stoccfipb == 9;
replace r_stated = "FL" if stoccfipb == 10;
replace r_stated = "GA" if stoccfipb == 11;
replace r_stated = "HI" if stoccfipb == 12;
replace r_stated = "ID" if stoccfipb == 13;
replace r_stated = "IL" if stoccfipb == 14;
replace r_stated = "IN" if stoccfipb == 15;
replace r_stated = "IA" if stoccfipb == 16;
replace r_stated = "KS" if stoccfipb == 17;
replace r_stated = "KY" if stoccfipb == 18;
replace r_stated = "LA" if stoccfipb == 19;
replace r_stated = "ME" if stoccfipb == 20;
replace r_stated = "MD" if stoccfipb == 21;
replace r_stated = "MA" if stoccfipb == 22;
replace r_stated = "MI" if stoccfipb == 23;
replace r_stated = "MN" if stoccfipb == 24;
replace r_stated = "MS" if stoccfipb == 25;
replace r_stated = "MO" if stoccfipb == 26;
replace r_stated = "MT" if stoccfipb == 27;
replace r_stated = "NE" if stoccfipb == 28;
replace r_stated = "NV" if stoccfipb == 29;
replace r_stated = "NH" if stoccfipb == 30;
replace r_stated = "NJ" if stoccfipb == 31;
replace r_stated = "NM" if stoccfipb == 32;
replace r_stated = "NY" if stoccfipb == 33;
replace r_stated = "NY" if stoccfipb == 34;
replace r_stated = "NC" if stoccfipb == 35;
replace r_stated = "ND" if stoccfipb == 36;
replace r_stated = "OH" if stoccfipb == 37;
replace r_stated = "OK" if stoccfipb == 38;
replace r_stated = "OR" if stoccfipb == 39;
replace r_stated = "PA" if stoccfipb == 40;
replace r_stated = "RI" if stoccfipb == 41;
replace r_stated = "SC" if stoccfipb == 42;
replace r_stated = "SD" if stoccfipb == 43;
replace r_stated = "TN" if stoccfipb == 44;
replace r_stated = "TX" if stoccfipb == 45;
replace r_stated = "UT" if stoccfipb == 46;
replace r_stated = "VT" if stoccfipb == 47;
replace r_stated = "VA" if stoccfipb == 48;
replace r_stated = "WA" if stoccfipb == 49;
replace r_stated = "WV" if stoccfipb == 50;
replace r_stated = "WI" if stoccfipb == 51;
replace r_stated = "WY" if stoccfipb == 52;
replace r_stated = "FR" if stoccfipb >= 53 &  stoccfipb <= 58 | stoccfipb == 60;



rename stoccfipb r_state;
label var r_state "State of Occurrence (FIPS) - Birth";


* REGION;
* NE;
gen r_region_northeast = 0;
replace r_region_northeast = 1 if r_stated == "CT"| r_stated == "ME"| r_stated == "MA"| r_stated == "NH"| r_stated == "NJ"| 
	r_stated == "NY"| r_stated == "PA"| r_stated == "RI"| r_stated == "VT";

* MIDWEST;
gen r_region_midwest = 0;
replace r_region_midwest = 1 if r_stated == "IL"| r_stated == "IN"| r_stated == "IA"| r_stated == "KS"| 
	r_stated == "MI"| r_stated == "MN"| r_stated == "MO"| r_stated == "NE"| r_stated == "ND"| 
	r_stated == "OH"| r_stated == "SD"| r_stated == "WI";

* SOUTH;
gen r_region_south = 0;
replace r_region_south = 1 if r_stated == "AL" | r_stated == "AR" | r_stated == "DE" | r_stated == "DC" | 
	r_stated == "FL" |	r_stated == "GA" |	r_stated == "KY" |	r_stated == "LA" |	r_stated == "MD" |	r_stated == "MS" | 
	r_stated == "NC" |	r_stated == "OK" |	r_stated == "SC" |	r_stated == "TN" |	r_stated == "TX" |	r_stated == "VA" |	r_stated == "WV" ;

* WEST;
gen r_region_west = 0;
replace r_region_west = 1 if r_stated == "AK" | r_stated == "AZ" | r_stated == "CA" | r_stated == "CO" | r_stated == "HI" | 
	r_stated == "ID" |	r_stated == "MT" |	r_stated == "NV" |	r_stated == "NM" |	r_stated == "OR" |	r_stated == "UT" | 
	r_stated == "WA" |	r_stated == "WY";

gen r_foreign_res = 0;
replace r_foreign_res = 1 if r_stated == "FR";

gen dummy = r_region_west + r_region_midwest + r_region_south + r_region_northeast + r_foreign_res;
tab dummy;
drop dummy r_stated;




* YEAR
rename biryr r_biryr;



* RACE;
* Kid's race recoded based on parents race;
tab mrace;
tab frace;

gen r_crace = -99;
replace r_crace = 11 if mrace != frace	;			/*other mixed*/
replace r_crace = 10 if mrace == 1 & frace == 2	;	/*white-black*/
replace r_crace = 10 if mrace == 2 & frace == 1;	 /*white-black*/
replace r_crace = 1 if mrace == 1 & frace == 1;		/*white*/
replace r_crace = 2 if mrace == 2 & frace == 2;		/*black*/
replace r_crace = 3 if mrace == 3 & frace == 3;		/*American Indian*/
replace r_crace = 4 if mrace == 4 & frace == 4;		/*Chinese*/
replace r_crace = 5 if mrace == 5 & frace == 5;		/*Japanese*/
replace r_crace = 6 if mrace == 6 & frace == 6;		/*Hawaiian*/
replace r_crace = 7 if mrace == 7 & frace == 7;		/*Filipino*/
replace r_crace = 18 if mrace == 18 & frace == 18;	/*Asian Indian*/	
replace r_crace = 28 if mrace == 28 & frace == 28;	/*Korean*/
replace r_crace = 38 if mrace == 38 & frace == 38;	/*Samoan*/
replace r_crace = 48 if mrace == 48 & frace == 48;	/*Vietnamese*/
replace r_crace = 58 if mrace == 58 & frace == 58;	/*Guamanian*/
replace r_crace = 68 if mrace == 68 & frace == 68;	/*Other Asian or Pacific Islander*/
replace r_crace = 78 if mrace == 78 & frace == 78;	/*Combined Other Asian or Pacific Islander*/
replace r_crace = 9 if mrace == 99 | frace == 99;	/*Not stated*/
replace r_crace = 9 if mrace == . | frace == .	;	/*Not on certificate - Coded only in 2003 and 2004*/


label define l_race 1"White" 2"Black" 3"American Indian" 4"Chinese" 5"Japanese" 6"Hawaiian" 7"Filipino"  
	9"Unknown or Not stated or Not on certificate" 10"White-Black"  11"Other Mixed Race" 
	18"Asian Indian" 28"Korean" 38"Samoan" 48"Vietnamese" 58"Guamanian" 
	68"Other Asian or Pacific Islander" 78"Combined Other Asian or Pacific Islander";
label values  r_crace l_race;

label var r_crace "Race of Child";


gen r_Mrace = 0;
replace r_Mrace = 1	if r_crace == 9;
replace r_crace = 9		if r_Mrace == 1;

tab r_crace;
tab  r_Mrace;
tab r_crace r_Mrace;


gen r_white = 0;
replace r_white = 1		if r_crace == 1 ;
gen r_black = 0;
replace r_black = 1		if r_crace == 2 ;
gen r_blackwhite = 0;
replace r_blackwhite = 1	if r_crace == 10 ;
gen r_asian = 0;
replace r_asian = 1		if r_crace == 4 | r_crace == 5 |  r_crace == 7 | r_crace == 18 | r_crace == 28 | r_crace == 38 | r_crace == 48 | r_crace == 68 | r_crace == 78;
gen r_otherrace=0;
replace r_otherrace = 1		if r_crace == 3 | r_crace == 6 | r_crace == 58 ;
gen r_othermixed = 0;
replace r_othermixed = 1	if r_crace == 11 ;


gen dummy = r_white + r_black + r_blackwhite + r_asian + r_otherrace  + r_othermixed + r_Mrace;
tab dummy;
drop dummy*;

tab r_crace;


* SEX;
tab csex;

gen r_female = -99;
replace r_female = 0 if csex == 1;
replace r_female = 1 if csex == 2;
gen r_Mfemale = 0;
replace r_Mfemale = 1 if csex != 1 & csex != 2;
replace r_female = 0 if r_Mfemale == 1;

tab r_female;
tab r_Mfemale;


* AGE OF MOTHER ;
tab dmage;

gen r_mage0t15 = 0;
replace r_mage0t15 = 1	if dmage > 0 & dmage <= 15;
label var r_mage0t15 "Mother Age: 0 to 15 years old";
gen r_mage16t20 = 0;
replace r_mage16t20 = 1 if dmage > 15 & dmage <= 20;
label var r_mage16t20 "Mother Age: 16 to 20 years old";
gen r_mage21t25 = 0;
replace r_mage21t25 = 1 if dmage > 20 & dmage <= 25;
label var r_mage21t25 "Mother Age: 21 to 25 years old";
gen r_mage26t30 = 0;
replace r_mage26t30 = 1 if dmage > 25 & dmage <= 30;
label var r_mage26t30 "Mother Age: 26 to 30 years old";
gen r_mage31t35 = 0;
replace r_mage31t35 = 1 if dmage > 30 & dmage <= 35;
label var r_mage31t35 "Mother Age: 31 to 35 years old";
gen r_mage36t40 = 0;
replace r_mage36t40 = 1 if dmage > 35 & dmage <= 40;
label var r_mage36t40 "Mother Age: 36 to 40 years old";
gen r_mage_over40 = 0;
replace r_mage_over40 = 1 if dmage > 40;
label var r_mage_over40 "Mother Age: over 40 years old";


gen dummy = r_mage0t15 + r_mage16t20 + r_mage21t25 + r_mage26t30 + r_mage31t35 + r_mage36t40 + r_mage_over40;
tab dummy;
drop dummy;



* EDUCATION OF MOTHER;
tab dmeduc;

gen r_educmother_noschool = 0;
replace r_educmother_noschool = 1 if dmeduc == 0 ;
gen r_educmother_0t8y = 0;
replace r_educmother_0t8y = 1 if dmeduc >= 1 & dmeduc < 9;
gen r_educmother_9t12y = 0;
replace r_educmother_9t12y = 1 if dmeduc >= 9 & dmeduc < 12;
gen r_educmother_hschool = 0;
replace r_educmother_hschool = 1 if dmeduc == 12;
gen r_educmother_somecollege = 0;
replace r_educmother_somecollege = 1 if dmeduc >= 13 & dmeduc < 17;
gen r_educmother_college = 0;
replace r_educmother_college = 1 if dmeduc == 17;

gen r_Meducmother = 0;
replace r_Meducmother = 1 if dmeduc == 99;

gen dummy = r_educmother_noschool + r_educmother_0t8y + r_educmother_9t12y + r_educmother_hschool +  r_educmother_somecollege + r_educmother_college + r_Meducmother;
tab dummy;
drop dummy;


* MARITAL STATUS OF MOTHER;
tab dmar;

gen r_mevermarr = -99;
replace r_mevermarr = 0 if dmar == 2;
replace r_mevermarr = 1 if dmar == 1;


gen r_Mmevermarr = 0;
replace r_Mmevermarr = 1 if dmar == 9;
replace r_mevermarr = 0 if r_Mmevermarr == 1;

label var r_mevermarr "Mother Ever Married";

tab r_mevermarr;
tab r_Mmevermarr;


* BIRTH WEIGHT;
sum dbirwt;

gen r_bweight = -99;
replace r_bweight = dbirwt if dbirwt >= 227 & dbirwt <= 8136;
replace r_bweight = dbirwt/1000 ;

gen r_Mbweight = 0;
replace r_Mbweight = 1 if dbirwt == 9999;
replace r_bweight = 0 if r_Mbweight == 1;

label var r_bweight "Birth Weight(Kilograms)";

sum r_bweight;
tab r_Mbweight;


* ANEMIA;
tab anemia;

gen r_anemia = -99;
replace r_anemia = 0 if anemia == 2;
replace r_anemia = 1 if anemia == 1;

gen r_Manemia = 0;
replace r_Manemia = 1 if anemia == 8 | anemia == 9;
replace r_anemia = 0 if r_Manemia == 1 ;

tab r_anemia;
tab r_Manemia;




* Gestation - Detail in Weeks;
tab gestat;

gen r_gestat = -99;
replace r_gestat = gestat if gestat >= 17 & gestat <= 47;

gen r_Mgestat = 0;
replace r_Mgestat = 1 if gestat == 99;
replace r_gestat = 0 if r_Mgestat == 1;

label var r_gestat "Gestation - # Weeks";

tab r_gestat;
tab r_Mgestat;



* DIABETES;
tab diabetes;

gen r_diabetes = -99;
replace r_diabetes = 0 if diabetes == 2;
replace r_diabetes = 1 if diabetes == 1;

gen r_Mdiabetes = 0;
replace r_Mdiabetes = 1 if diabetes == 8 | diabetes == 9;
replace r_diabetes = 0 if r_Mdiabetes == 1 ;

tab r_diabetes;
tab r_Mdiabetes;


* FETAL DISTRESS;
tab distress;

gen r_distress = -99;
replace r_distress = 0 if distress == 2;
replace r_distress = 1 if distress == 1;

gen r_Mdistress = 0;
replace r_Mdistress = 1 if distress == 8 | distress == 9;
replace r_distress = 0 if r_Mdistress == 1 ;

label var r_distress"Fetal distress";

tab r_distress;
tab r_Mdistress;


* TOBACCO - Tobacco Use During Pregnancy;
tab tobacco;

gen r_tobacco = -99;
replace r_tobacco = 0 if tobacco == 2;
replace r_tobacco = 1 if tobacco == 1;

gen r_Mtobacco = 0;
replace r_Mtobacco = 1 if tobacco == 9;
replace r_tobacco = 0 if r_Mtobacco ==1 ;

label var r_tobacco "Tobacco Use During Pregnancy";

tab r_tobacco;
tab r_Mtobacco;


* ALCOHOL - Alcohol Use During Pregnancy;
tab alcohol;

gen r_alcohol = -99;
replace r_alcohol = 0 if alcohol == 2;
replace r_alcohol = 1 if alcohol == 1;

gen r_Malcohol = 0;
replace r_Malcohol = 1 if alcohol == 9;
replace r_alcohol = 0 if r_Malcohol == 1 ;

label var r_alcohol "Alcohol Use During Pregnancy";

tab r_alcohol;
tab r_Malcohol;


keep r_*;
quietly: compress;
save "analysis_data\BirthOutcomes2000_analysis.dta", replace ;




* FIGURE 3 - BIRTH OUTCOMES;
*** standardize residuals for BIRTH OUTCOMES variables;

use "analysis_data\BirthOutcomes2000_analysis.dta", clear;

foreach var in bweight anemia diabetes gestat distress tobacco alcohol death {;

areg r_`var' $controls_vitalstat_birth [pweight = r_weight] if  r_M`var' == 0, r absorb(r_state) ;

predict double r_res_`var', residuals;

	
egen r_std_`var' = std(r_res_`var');
	
};



egen r_index_birth = rowmean(r_std_*);
egen r_index_birth_std = std(r_index_birth);


mat T1 = J(1,6,.);
mat colnames T1 = White White_se White_ci	Black Black_se Black_ci;		
mat rownames T1 = BirthOutcomes;

reg r_index_birth_std r_white r_black [pweight = r_weight], r;
mat T1[1, 1] = _b[r_white];
mat T1[1, 2] = _se[r_white];
mat T1[1, 3] = _se[r_white]*invttail(e(df_r),0.025);
mat T1[1, 4] = _b[r_black];
mat T1[1, 5] = _se[r_black];
mat T1[1, 6] = _se[r_black]*invttail(e(df_r),0.025);


di "Figure 3 - VitalStat - Birth Outcomes Data";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Figure3_VitalStat_Birth_Data.txt") title("Figure 3 - VitalStat - Birth Outcomes Data") note("-----") format("%9.3f") replace;

mat drop _all;
clear;



* TABLE 1 - BIRTH OUTCOMES;
	* BIRTH OUTCOMES: Summary Statistics by Race;

use  r_female r_state r_weight r_bweight r_Mbweight r_anemia r_Manemia r_diabetes r_Mdiabetes r_gestat r_Mgestat r_distress r_Mdistress r_tobacco r_Mtobacco  r_alcohol r_Malcohol r_death r_Mdeath r_white r_black r_blackwhite 
using "analysis_data\BirthOutcomes2000_analysis.dta";


mat T1 = J(16,4,.);
mat colnames T1 = Full_Sample	White	Black	Mixed;
mat rownames T1 = Birth_wght Birth_wght_sd Anemia Anemia_sd Diabetes Diabetes_sd Gestation Gestation_sd Distress Distress_sd Mother_Smoked Mother_Smoked_sd Mother_Drank Mother_Drank_sd Infant_Mortality Infant_Mortality_sd;

loc lnum = -1;
local lnum1 = `lnum' + 1;
	
foreach var in bweight anemia diabetes gestat distress tobacco alcohol death {;
loc lnum = `lnum' + 2;
local lnum1 = `lnum1' + 2;

	* Full Sample;
	sum r_`var'  [aweight = r_weight] if r_M`var' == 0;
	mat T1[`lnum',1] = r(mean);
	mat T1[`lnum1',1] = r(sd);

	* White	;
	sum r_`var' [aweight = r_weight] if r_M`var' == 0 & r_white == 1;
	mat T1[`lnum',2] = r(mean);
	mat T1[`lnum1',2] = r(sd);	
	
	* Black	;
	sum r_`var' [aweight = r_weight] if r_M`var' == 0 & r_black == 1;
	mat T1[`lnum',3] = r(mean);
	mat T1[`lnum1',3] = r(sd);		
	
	* Mixed	;
	sum r_`var' [aweight = r_weight] if r_M`var' == 0 & r_blackwhite == 1;	
	mat T1[`lnum',4] = r(mean);
	mat T1[`lnum1',4] = r(sd);
};

di "TABLE 1: Vital Stat 2000 - Birth Outcomes ";
mat list T1, f("%9.3f");
mat2txt, matrix(T1) saving("tables\Table0_BirthOutcomes.txt") title("Table 0: Vital Stat 2000 - Birth Outcomes RAW DATA") note("-----") format("%9.3f") replace;

mat drop _all;
clear;


* TABLE 1 - BIRTH OUTCOMES;
	* Regressions;
use "analysis_data\BirthOutcomes2000_analysis.dta";

keep if r_white == 1 | r_black == 1 | r_blackwhite == 1;


eststo r1, title ("Birth Weight (Kg)"): areg r_bweight	$race  $controls_vitalstat_birth [pweight = r_weight] if r_Mbweight == 0, r absorb(r_state) ;
eststo r2, title ("Duration of Pregnancy (weeks)"): areg r_gestat	$race  $controls_vitalstat_birth [pweight = r_weight] if r_Mgestat == 0, r  absorb(r_state) ;
eststo r3, title ("Anemia"): areg r_anemia	$race  $controls_vitalstat_birth [pweight = r_weight]	if r_Manemia == 0, r  absorb(r_state) ;
eststo r4, title ("Diabetes"): areg r_diabetes	$race  $controls_vitalstat_birth  [pweight = r_weight] if r_Mdiabetes == 0, r  absorb(r_state) ;
eststo r5, title ("Fetal Distress"): areg r_distress	$race  $controls_vitalstat_birth  [pweight = r_weight] if r_Mdistress == 0, r absorb(r_state);
eststo r6, title ("Mother Smoked During Pregnancy"): areg r_tobacco	$race  $controls_vitalstat_birth  [pweight = r_weight] if r_Mtobacco == 0, r absorb(r_state);
eststo r7, title ("Mother Drank During Pregnancy"): areg r_alcohol	$race  $controls_vitalstat_birth [pweight = r_weight] if r_Malcohol == 0, r absorb(r_state);
eststo r8, title ("Infant Death"): areg  r_death	$race  $controls_vitalstat_birth [pweight = r_weight], r absorb(r_state);

estout using "tables\Table1_BirthOutcomes.txt", 
replace 
keep($race) 
collabels(none) 
label 
cells(b(star fmt(3)) se(fmt(3) par(`"="("' `")""'))) 
starlevels(* .10 ** .05 *** .01) 
stats(N r2, fmt(%9.0f %9.3f) labels("Obs." "R2"));
eststo clear;


clear;
log close;

