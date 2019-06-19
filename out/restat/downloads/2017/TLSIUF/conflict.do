clear
* In the directory used to store the dta and do file, create a folder called "regressions" that will contain the output files
use conflict
set more off

* Version of September 2015

* Define elevation and distance variables
gen ldiff_elev=log(diff_elev)
gen ldist=log(dist)

* Define linguistic and religious variables
replace fst_distance_weighted=fst_distance_weighted/10000
label variable fst_distance_weighted "Fst genetic distance"
replace fst_distance_dominant=fst_distance_dominant/10000
replace nei_distance_dominant=nei_distance_dominant/1000
replace nei_distance_weighted=nei_distance_weighted/1000
replace gendist_fst_1500=gendist_fst_1500/10000
replace gendist_nei_1500=gendist_nei_1500/1000
replace fst_dist_europe=fst_dist_europe/10000
gen lingdist_dominant_formula=((15-lingprox_dominant)/15)^.5
gen lingdist_weighted_formula=((15-lingprox_weighted)/15)^.5
gen reldist_dominant_formula=((5-relprox_dominant_fearon)/5)^.5
gen reldist_weighted_formula=((5-relprox_weighted_fearon)/5)^.5
gen reldist_dominant_formula_WCD=((3-relprox_dominant_WCD)/3)^.5
gen reldist_weighted_formula_WCD=((3-relprox_weighted_WCD)/3)^.5
gen ldcognate=1-(cognate_dominant/1000)
gen lwcognate=1-(cognate_weighted/1000)

* Define conflict variables
gen conflict=(cwhostd>2)
replace conflict=. if cwhostd==.
gen war=(cwhostd==5)
replace war=. if (cwhostd==.)
gen alliancedum=(alliance<4)
replace alliancedum=. if alliance==.

* Other definitions
gen majdum=(majpow1==1 | majpow2==2)
gen inter1=fst_distance_weighted*contig
gen proximity=(contig==1 | dist<2500)
gen inter2=fst_distance_weighted*proximity
gen split=(fst_distance_weighted>.1046553)
gen inter3=fst_distance_weighted*split
gen inter4=majdum*fst_distance_weighted 
gen both_in_eurasia=(eurasia_1 & eurasia_2)
gen both_in_asia=(asia_1==1 & asia_2==1)
gen both_in_europe=(europe_1==1 & europe_2==1)
gen both_in_africa=(africa_1==1 & africa_2==1)
gen both_in_oceania=(oceania_1==1 & oceania_2==1)
gen both_in_america=(america_1==1 & america_2==1)
gen same_continent=(both_in_america+both_in_africa+both_in_europe+both_in_oceania+both_in_asia)

gen one_in_asia=(asia_1==1 | asia_2==1)
replace one_in_asia=one_in_asia-both_in_asia
gen one_in_africa=(africa_1==1 | africa_2==1)
replace one_in_africa=one_in_africa-both_in_africa
gen one_in_europe=(europe_1==1 | europe_2==1)
replace one_in_europe=one_in_europe-both_in_europe
gen one_in_america=(america_1==1 | america_2==1)
replace one_in_america=one_in_america-both_in_america
gen one_in_oceania=(oceania_1==1 | oceania_2==1)
replace one_in_oceania=one_in_oceania-both_in_oceania

gen fstdistsq=fst_distance_weighted^2
gen intergeo=ldist*fst_distance_weighted
gen ldistsq=ldist^2

gen drugged=abs(rugged_1-rugged_2)
gen drugged_popw=abs(rugged_popw_1-rugged_popw_2)
gen drugged_slope=abs(rugged_slope_1-rugged_slope_2)
gen drugged_lsd=abs(rugged_lsd_1-rugged_lsd_2)
gen drugged_pc=abs(rugged_pc_1-rugged_pc_2)
gen dsoil=abs(soil_1-soil_2)
gen ddesert=abs(desert_1-desert_2)
gen dtropical=abs(tropical_1-tropical_2)
gen ddist_coast=abs(dist_coast_1-dist_coast_2)
gen dnear_coast=abs(near_coast_1-near_coast_2)
gen dsurexp=abs(surexp_1-surexp_2)
gen dtrasec=abs(trasec_1-trasec_2)
gen dsurexp_1960=abs(surexp_cohort_1960_1-surexp_cohort_1960_2)
gen dtrasec_1960=abs(trasec_cohort_1960_1-trasec_cohort_1960_2)

* Territorial and Non Territorial Conflicts
* Define territorial conflict as conflicts with at least one side seeking a territorial revision (for either revision type 1 or 2)
* Define nonterritorial conflict as conflicts with at least one side seeking policy, regime or other revision (for either revision type 1 or 2)
* and that conflict is not also coded as territorial
* This results in 3392 nonterritorial conflicts and 2328 territorial conflicts
* Note that there are 8354 conflicts so 2634 conflicts are not characterized by COW (no revision sought by either side)
* These will have to be recoded as nonterritorial since they are not explicitly coded as territorial

gen ter=(cwrevt11==1 | cwrevt12==1 | cwrevt21==1 | cwrevt22==1)
gen policy=(cwrevt11==2 | cwrevt12==2 | cwrevt21==2 | cwrevt22==2)
gen regime=(cwrevt11==3 | cwrevt12==3 | cwrevt21==3 | cwrevt22==3)
gen other=(cwrevt11==4 | cwrevt12==4 | cwrevt21==4 | cwrevt22==4)
gen nonter=(policy==1 | regime==1 | other==1)
replace nonter=0 if conflict==0
replace ter=0 if conflict==0
replace nonter=0 if ter==1
gen polreg=(policy==1 | regime==1)
replace polreg=0 if conflict==0
gen nonpolreg=ter
replace nonpolreg=0 if polreg==1

#delimit ;

gen dclimate_area=(100*(abs(kg_a_af_1-kg_a_af_2)+abs(kg_a_am_1-kg_a_am_2)+abs(kg_a_aw_1-kg_a_aw_2)+abs(kg_a_bs_1-kg_a_bs_2)
+abs(kg_a_bw_1-kg_a_bw_2)+abs(kg_a_cf_1-kg_a_cf_2)+abs(kg_a_cs_1-kg_a_cs_2)+abs(kg_a_cw_1-kg_a_cw_2)
+abs(kg_a_dw_1-kg_a_dw_2)+abs(kg_a_df_1-kg_a_df_2)+abs(kg_a_h_1-kg_a_h_2)+abs(kg_a_e_1-kg_a_e_2)))/12;
gen dtropics=abs(kgatr_2-kgatr_1);

* Define endowments variables for interactions tests;

gen doil=(oil_producer_1==1 | oil_producer_2==1);
label variable doil "Dummy for at least one country in the pair a major oil producer";

gen temp_1=(kgatemp_1>0.6);
replace temp_1=. if kgatemp_1==.;
gen temp_2=(kgatemp_2>0.6);
replace temp_2=. if kgatemp_2==.;
gen dtemp=(temp_1==1 | temp_2==1);
replace dtemp=. if (temp_1==. | temp_2==.);
label variable dtemp "=1 if one or more country in the pair has >60% land in temperate zone";

gen soildum_1=(soil_1>40);
replace soildum_1=. if soil_1==.;
gen soildum_2=(soil_2>40);
replace soildum_2=. if soil_2==.;
gen dfertsoil=(soildum_1==1 | soildum_2==1);
replace dfertsoil=. if (soildum_1==. | soildum_2==.);
label variable dfertsoil "=1 if one or more country in the pair has >40% fertile soil";

gen dabbis=abs(mdist_addis_1-mdist_addis_2);
label variable dabbis "Absolute difference in migratory distance to East Africa (Ashraf-Galor)";
gen dabbisq=abs(mdist_addis_sqr_1-mdist_addis_sqr_2);
label variable dabbisq "Absolute difference in squared migratory distance to East Africa, (Ashraf-Galor)";

* Drop symmetric subsample to avoid pair replication;

drop if wacziarg_1>wacziarg_2;
gen pair=wacziarg_1+(wacziarg_2/1000);

sort pair;
by pair: egen everaconflict=max(conflict);
sum everaconflict if conflict==.;
by pair: egen everawar=max(war);
by pair: egen everaterconflict=max(ter);
by pair: egen everanonterconflict=max(nonter);
by pair: egen everapolregconflict=max(polreg);
by pair: egen everanonpolregconflict=max(nonpolreg);
by pair: egen intensity=max(cwhostd);
by pair: egen fatalities=sum(cwfatald);

gen junk=conflict; replace junk=0 if year>1900; by pair: egen everaconflictpre1901=max(junk); drop junk;
gen junk=conflict; replace junk=0 if year<1901; by pair: egen everaconflictpost1900=max(junk); drop junk;
gen junk=conflict; replace junk=0 if year<1945; by pair: egen everaconflictpost1945=max(junk); drop junk;
gen junk=conflict; replace junk=0 if year<1919; replace junk=0 if year>1989; by pair: egen everaconflict19191989=max(junk); drop junk;
gen junk=conflict; replace junk=0 if year<1989; by pair: egen everaconflictpost1989=max(junk); drop junk;

* Tables 1-3 - Summary Statistics and Collapsed (cross sectional) regressions;

collapse(mean) wacziarg_1 wacziarg_2 everaconflict everawar everaterconflict everanonterconflict everapolregconflict everanonpolregconflict everaconflictpre1901 
everaconflictpost1900 everaconflictpost1945 everaconflict19191989 everaconflictpost1989 intensity fatalities majdum inter1 inter2 inter3 inter4 fstdistsq intergeo 
ldistsq both_in_eurasia both_in_asia both_in_europe both_in_africa both_in_oceania both_in_america same_continent fst_distance_weighted gendist_fst_1500 
fst_distance_dominant nei_distance_weighted nei_distance_dominant gendist_nei_1500 fst_dist_europe europe_1 europe_2 min_av_elev dclimate_area dtropics dist 
ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry reldist_weighted_formula lingdist_weighted_formula lwcognate drugged 
drugged_popw drugged_slope drugged_lsd drugged_pc dsoil ddesert dtropical ddist_coast dnear_coast one_in_asia one_in_africa one_in_europe one_in_america 
one_in_oceania hmicost hmiseacost rixdist cultdist dsurexp dtrasec dsurexp_1960 dtrasec_1960 total_1 diff_elev doil dtemp dfertsoil dabbis dabbisq, by(pair);

label variable wacziarg_1 "Country 1 code";
label variable wacziarg_2 "Country 2 code";
label variable majdum "Dummy=1 if at least one country is a major power";
label variable inter1 "Fst Gen. Dist * contiguity";
label variable inter2 "Fst Gen. Dist * proximity";
label variable inter3 "Fst Gen. Dist * dummy for FST GD > median";
label variable inter4 "Fst Gen. Dist * major power dummy";
label variable fstdistsq "Squared Fst genetic distance, weighted";
label variable same_continent "1 of both countries are on the same continent";
label variable fstdistsq "Squared Fst genetic distance, weighted";
label variable intergeo "Interaction of log distance and Fst gen. dist.";
label variable ldistsq "Log distance, squared";
label variable pair "Pair specific code";
label variable fst_distance_weighted "Fst genetic distance, weighted";
label variable gendist_fst_1500 "Fst genetic distance between plurality groups, 1500 match";
label variable fst_distance_dominant "Fst genetic distance between plurality groups";
label variable nei_distance_weighted "Nei genetic distance, weighted";
label variable nei_distance_dominant "Nei genetic distance between plurality groups";
label variable gendist_nei_1500 "Nei genetic distance between plurality groups, 1500 match";
label variable fst_dist_europe "Fst genetic distance, European Matrix";
label variable reldist_weighted_formula "Religious Distance Index, weighted";
label variable lingdist_weighted_formula "Linguistic Distance Index, weighted";
label variable lwcognate "1 - % cognate measure of linguistic similarity, weighted";
label variable ldist "Log geodesic distance";
label variable ldifflong "Log absolute difference in longitudes";
label variable ldifflat "Log absolute difference in latitudes";
label variable contig "1 for contiguity";
label variable landlock "Number of landlocked countries in the pair";
label variable island "Number of island countries in the pair";
label variable common_water "1 if pair shares at least one sea or ocean";
label variable lareaprod "Log product of land areas in square km";
label variable colony "1 for pairs ever in colonial relationship";
label variable smctry "1 if countries were or are the same country";
label variable everaconflict "=1 if ever a conflict, 1816-2001";
label variable everawar "=1 if ever a war dummy, 1816-2001";
label variable everaterconflict "=1 if ever a territorial conflict, 1816-2001";
label variable everanonterconflict "=1 if ever a non-territorial conflict, 1816-2001";
label variable everapolregconflict "=1 if ever a policy/regime conflict, 1816-2001";
label variable everapolregconflict "=1 if ever a non policy/regime conflict, 1816-2001";
label variable everaconflictpre1901 "=1 if ever a conflict, 1816-1900";
label variable everaconflictpost1900 "=1 if ever a conflict, 1901-2001";
label variable everaconflictpost1945 "=1 if ever a conflict, 1946-2001";
label variable everaconflict19191989 "=1 if ever a conflict, 1919-1989";
label variable everaconflictpost1989 "=1 if ever a conflict, 1990-2001";
label variable intensity "Maximal intensity of conflict in a pair";
label variable fatalities "Index of total casualties in conflicts involving the pair (sum of yearly indices)";
label variable dclimate_area "Measure of climatic difference of land areas, by 12 KG zones";
label variable dtropics "Difference in % land area in KG tropical climates (Am+Af+Aw)";
label variable drugged "Abs. difference in Terrain Ruggedness Index";
label variable drugged_popw "Abs. difference in ruggedness index, pop weighted";
label variable drugged_slope "Abs. difference in ruggedness index, avg. slope %";
label variable drugged_lsd "Abs. difference in ruggedness index, local s.d. in elevation";
label variable drugged_pc "Abs. difference in ruggedness index (% moderately to highly rugged)";
label variable dsoil "Abs. difference in % fertile soil";
label variable ddesert "Abs. difference in % desert area";
label variable dtropical "Abs. difference in % tropical area";
label variable ddist_coast "Abs. difference in avg. distance to coast";
label variable dnear_coast "Abs. difference in % within 100 km. of ice-free coast";
label variable both_in_asia "Both in Asia Dummy";
label variable both_in_africa "Both in Africa Dummy";
label variable both_in_europe "Both in Europe Dummy";
label variable both_in_america "Both in America Dummy";
label variable both_in_oceania "Both in Oceania Dummy";
label variable same_continent "Same Continent dummy";
label variable one_in_asia "Dummy if one and only one country is in Asia";
label variable one_in_africa "Dummy if one and only one country is in Africa";
label variable one_in_europe "Dummy if one and only one country is in Europe";
label variable one_in_america "Dummy if one and only one country is in America";
label variable one_in_oceania "Dummy if one and only one country is in Oceania";
label variable hmicost "HMI cost (weeks), avg. of both directions, Ozak";
label variable hmiseacost "HMIsea cost (weeks), avg. of both directions, Ozak";
label variable rixdist "RIX distance (100's km), avg. of both directions, Ozak";
label variable cultdist "Cultural distance, from Desmet stability paper";
label variable dsurexp "Abs. Difference in Survival vs. Self Expression score";
label variable dtrasec "Abs. Difference in Trad. vs. Secular score";
label variable dsurexp_1960 "Abs. Difference in Survival vs. Self Expression score, 1960 cohort";
label variable dtrasec_1960 "Abs. Difference in Trad. vs. Secular score, 1960 cohort";
label variable total_1 "Summary index of cultural distance";
label variable diff_elev "Absolute value of difference in average elevation, 1000s of ft";
label variable doil "Dummy for at least one country in the pair being a major oil producer";
label variable dtemp "=1 if one or more country in the pair has >60% land in temperate zone";
label variable dfertsoil "=1 if one or more country in the pair has >40% fertile soil";
label variable dabbis "Absolute difference in migratory distance to East Africa (Ashraf-Galor)";
label variable dabbisq "Absolute difference in squared migratory distance to East Africa, (Ashraf-Galor)";

* Now we have 825 conflicts left, 278 territorial and 451 nonterritorial (729 classified);
* Reclassify territorial and nonterritorial pairs so they don't overlap;
replace everanonterconflict=0 if everaterconflict==1;
replace everanonterconflict=1 if (everaterconflict==0 & everaconflict==1);
* Now we have 825 conflicts, 278 territorial and 547 nonterritorial - i.e. pairs that had a conflict but that conflict was never territorial;
* Now do the same for the alternative definition;
replace everanonpolregconflict=0 if everapolregconflict==1;
replace everanonpolregconflict=1 if (everapolregconflict==0 & everaconflict==1);

* Create trichotomous conflict variables;
gen triconflict1=everaterconflict+2*everanonterconflict;
label variable triconflict1 "Trichotomous conflict indic. (0=no conflict, 1=territorial, 2=non territorial)";
label define triconflict1 0 "No conflict" 1 "Territorial conflict" 2 "Nonterritorial conflict";

gen triconflict2=everapolregconflict+2*everanonpolregconflict;
label variable triconflict2 "Trichotomous conflict variable (0=no conflict, 1=policy/regime, 2=non policy/regime)";
label define triconflict2 0 "No conflict" 1 "Policy/regime conflict" 2 "Non policy/regime conflict";

sort wacziarg_1 wacziarg_2;
merge wacziarg_1 wacziarg_2 using cultdist;
drop if _merge==2;
drop _merge; 

* Summary statistics for Table 1-2;

log using regressions\table1-2.doc, text replace;

sum everaconflict everawar fst_distance_weighted ldist contig reldist_weighted_formula lingdist_weighted_formula if ldist~=. & contig~=. & common_water~=. & fst_distance_weighted~=. & ldifflong~=. & ldifflat~=.;
pwcorr everaconflict everawar fst_distance_weighted ldist contig reldist_weighted_formula lingdist_weighted_formula if ldist~=. & contig~=. & common_water~=. & fst_distance_weighted~=. & ldifflong~=. & ldifflat~=., star(.05) obs;

sum fst_distance_weighted if (everaconflict~=. & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.), detail;
scalar p10=r(p10);
scalar p25=r(p25);
scalar p50=r(p50);
scalar p75=r(p75);

* All conflicts;
sum everaconflict fst_distance_weighted ldist contig;
sum fst_distance_weighted if fst_distance_weighted<p10 & everaconflict==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & fst_distance_weighted>=p10 & everaconflict==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & fst_distance_weighted>=p25 & everaconflict==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & fst_distance_weighted>=p50 & everaconflict==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted>=p75 & everaconflict==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

sum fst_distance_weighted if fst_distance_weighted<p10 & everaconflict==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & everaconflict==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & everaconflict==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & everaconflict==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if everaconflict==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

sum fst_distance_weighted if fst_distance_weighted<p10 & everaconflict==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & everaconflict==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & everaconflict==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & everaconflict==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if everaconflict==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

sum fst_distance_weighted if fst_distance_weighted<p10 & everaconflict==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & everaconflict==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & everaconflict==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & everaconflict==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if everaconflict==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

* Wars only;

sum fst_distance_weighted if fst_distance_weighted<p10 & everawar==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & fst_distance_weighted>=p10 & everawar==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & fst_distance_weighted>=p25 & everawar==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & fst_distance_weighted>=p50 & everawar==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted>=p75 & everawar==1 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

sum fst_distance_weighted if fst_distance_weighted<p10 & everawar==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & everawar==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & everawar==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & everawar==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if everawar==1 & contig==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

sum fst_distance_weighted if fst_distance_weighted<p10 & everawar==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & everawar==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & everawar==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & everawar==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if everawar==1 & common_water==0 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

sum fst_distance_weighted if fst_distance_weighted<p10 & everawar==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p25 & everawar==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p50 & everawar==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if fst_distance_weighted<p75 & everawar==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;
sum fst_distance_weighted if everawar==1 & dist>1000 & ldist~=. & contig~=. & common_water~=. & ldifflong~=. & ldifflat~=.;

log close;

* Table 3 - Baseline cross-sectional regressions;

dprobit everaconflict fst_distance_weighted if (ldist<1000000000 & ldifflong<100000 & ldifflat<100000 & common_water<10000), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) 
title("Table 3 - Cross-sectional regressions") ctitle("Conflict, univariate specification") replace;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Conflict, baseline specification") append;

ivprobit everaconflict ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry (fst_distance_weighted=gendist_fst_1500), robust;
sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
mfx, predict(p) force;
matrix coeffs=e(Xmfx_dydx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table3.doc, 2aster label tstat bdec(6) tdec(3) mfx addstat("Standardized effect (%)", effect) ctitle("Conflict, baseline specification, IV") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat landlock island common_water lareaprod colony smctry if contig==0, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Excluding contiguous pairs") append;

dprobit everawar fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everawar if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("War, baseline specification") append;

ivprobit everawar ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry (fst_distance_weighted=gendist_fst_1500), robust;
sum everawar if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
mfx, predict(p) force;
matrix coeffs=e(Xmfx_dydx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table3.doc, 2aster label tstat bdec(6) tdec(3) mfx addstat("Standardized effect (%)", effect) ctitle("War, baseline specification IV") append;

* Table 4- Further geographic, endowment and climatic controls;
* Start with Nunn-Puga variables: ruggedness, desert terrain, soil quality, tropical, distance from coast, all bilateralized;
* Ruggedness: We include the difference in the degree of ruggedness. There are 5 measures of ruggedness. Include one ("drugged") in paper;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry drugged_popw dtropical dsoil ddesert ddist_coast dnear_coast, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Nunn-Puga controls") title("Table 4 - Additional Geographic Controls") replace;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry dclimate_area, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Climatic conditions control") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry diff_elev, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Elevation difference control") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry hmiseacost, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Ozak distance") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry drugged_popw dtropical dsoil ddesert ddist_coast 
dnear_coast dclimate_area hmiseacost diff_elev, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("All together") append;

* Table 5 - Alternative measures of human relatedness/historical distance [linguistic and religious];
* Add each one by one to basic specification with genetic distance, and then both;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if (reldist_weighted_formula<100000 & lingdist_weighted_formula<100000), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Baseline specification") 
title("Table 5 - Alternative measures of historical distance, including GD") replace;

corr fst_distance_weighted ldist reldist_weighted_formula lingdist_weighted_formula if e(sample);

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry lingdist_weighted_formula if reldist_weighted_formula<100000, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Add linguistic distance") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry reldist_weighted_formula if lingdist_weighted_formula<100000, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Add religious distance") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry reldist_weighted_formula lingdist_weighted_formula, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Add religious and linguistic distances") append;

* Table 6: Endowment Interactions: Climate, fertile soil and oil;

gen interdoil=doil*fst_distance_weighted;
label variable interdoil "Interaction of oil producer dummy and gen. dist.";

* Note, limit to post 1945 conflicts;
dprobit everaconflictpost1945 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if doil~=., robust;
scalar pr2=e(r2_p); sum everaconflictpost1945 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Post-1945 baseline") 
title("Table 6: Endowments Interactions") replace;

dprobit everaconflictpost1945 fst_distance_weighted interdoil doil ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflictpost1945 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar interef=coeffs[1,2]; scalar effect=100*(fsteff+interef)*sdwgd/avconf;
outreg2 using regressions\table6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Oil post-1945") append;

gen intertemp=fst_distance_weighted*dtemp;
label variable intertemp "Interaction of temperate climate and gen. dist.";

* Note, limit to pre-19001 conflicts;
dprobit everaconflictpre1901 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if dtemp~=., robust;
scalar pr2=e(r2_p); sum everaconflictpre1901 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) 
ctitle("Pre-1901 baseline") append;

dprobit everaconflictpre1901 fst_distance_weighted intertemp dtemp ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflictpre1901 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar interef=coeffs[1,2]; scalar effect=100*(fsteff+interef)*sdwgd/avconf;
outreg2 using regressions\table6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) 
ctitle("Temperate climate") append;

* Note, limit to pre-1901 conflicts;
gen interfertsoil=fst_distance_weighted*dfertsoil;
label variable interfertsoil "Interaction of fertile soil dummy and gen. dist.";

dprobit everaconflictpre1901 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if dfertsoil~=., robust;
scalar pr2=e(r2_p); sum everaconflictpre1901 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Pre-1901 baseline") append;

dprobit everaconflictpre1901 fst_distance_weighted interfertsoil dfertsoil ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflictpre1901 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar interef=coeffs[1,2]; scalar effect=100*(fsteff+interef)*sdwgd/avconf;
outreg2 using regressions\table6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Fertile Soil pre-1901") append;

* Tables in the Online Appendix (cross-sectional results only); 

* Table AUR 0 - Removing genetic distance from the baseline specification to see the effect on the geographic coefficients;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR0.doc, 2aster label tstat bdec(4) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) 
title("Table AUR0: Effect of controlling for genetic distance on the geographic coefficients") ctitle("With GD") replace;

dprobit everaconflict ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if e(sample), robust;
scalar pr2=e(r2_p); 
outreg2 using regressions\tableAUR0.doc, 2aster label tstat bdec(4) tdec(3) addstat("Pseudo-R2", pr2) ctitle("Without GD") append;

* Table AUR1 - Alternative measures of genetic distance;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR1.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Baseline specification") title("Table AUR1 - Alternative measures of genetic distance") replace;

dprobit everaconflict fst_distance_dominant ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if e(sample), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_dominant if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR1.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Fst GD between plurality groups") append;

dprobit everaconflict nei_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if e(sample), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum nei_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR1.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Nei GD, weighted") append;

dprobit everaconflict nei_distance_dominant ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if e(sample), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum nei_distance_dominant if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR1.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Nei GD between plurality groups") append;

dprobit everaconflict gendist_fst_1500 ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if e(sample), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum gendist_fst_1500 if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR1.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Fst GD, 1500 match") append;

dprobit everaconflict gendist_nei_1500 ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if e(sample), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum gendist_nei_1500 if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR1.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Nei GD, 1500 match") append;

* Table AUR2 - Territorial and Nonterritorial Conflicts;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR2.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Baseline specification") title("Table AUR2 - Sample breakdown by type of conflict") replace;

ivprobit everaconflict ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry (fst_distance_weighted=gendist_fst_1500), robust;
sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
mfx, predict(p) force;
matrix coeffs=e(Xmfx_dydx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR2.doc, 2aster label tstat bdec(6) tdec(3) mfx addstat("Standardized effect (%)", effect) ctitle("IV probit, instrumenting with 1500 GD") append;

dprobit everaterconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaterconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR2.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Territorial conflicts") append;

ivprobit everaterconflict ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry (fst_distance_weighted=gendist_fst_1500), robust;
sum everaterconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
mfx, predict(p) force;
matrix coeffs=e(Xmfx_dydx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR2.doc, 2aster label tstat bdec(6) tdec(3) mfx addstat("Standardized effect (%)", effect) ctitle("IV, Territorial conflicts") append;

dprobit everanonterconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everanonterconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR2.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Non territorial conflicts") append;

ivprobit everanonterconflict ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry (fst_distance_weighted=gendist_fst_1500), robust;
sum everanonterconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
mfx, predict(p) force;
matrix coeffs=e(Xmfx_dydx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR2.doc, 2aster label tstat bdec(6) tdec(3) mfx addstat("Standardized effect (%)", effect) ctitle("IV, Non territorial conflicts") append;

* Table AUR3 - Continent dummies and breakdown by continent;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Baseline specification") title("Table AUR3 - Sample breakdown by region") replace;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry same_continent, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Same continent") append;

* note: drop both_in_oceania because there were no conflicts within Oceania, so the variable predicts failure perfectly;
dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry
both_in_asia both_in_africa both_in_europe both_in_america one_in_asia one_in_africa one_in_europe one_in_america one_in_oceania, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Full set") append;

dprobit everaconflict fst_dist_europe ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_europe==1, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_dist_europe if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Europe, with Europe Gen. Dist.") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if (europe_1~=1 & europe_2~=1), robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Removing all European countries") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_asia==1, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Asia") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_africa==1, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR3.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Africa") append;

* Note: No conflicts among Oceanian countries, so skip this region;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_america==1, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\table5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("America") append;

* Table AUR4 - Further regressions for Europe;

label variable everaconflictpre1901 "=1 if ever a conflict, 1816-1900";
label variable everaconflictpost1900 "=1 if ever a conflict, 1901-2001";
label variable everaconflictpost1945 "=1 if ever a conflict, 1946-2001";
label variable everaconflict19191989 "=1 if ever a conflict, 1919-1989";
label variable everaconflictpost1989 "=1 if ever a conflict, 1990-2001";

dprobit everaconflict fst_dist_europe ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_europe==1, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_dist_europe if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) title("Table AUR4 - Further regressions for Europe") ctitle("European regression baseline") replace;

dprobit everaconflict fst_dist_europe ldist ldifflong ldifflat contig landlock island min_av_elev common_water lareaprod colony smctry if both_in_europe==1, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_dist_europe if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Europe, with elevation control") append;

dprobit everaconflictpre1901 fst_dist_europe ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_europe==1, robust;
scalar pr2=e(r2_p); sum everaconflictpre1901 if e(sample); scalar avconf=r(mean); sum fst_dist_europe if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("European regression, pre-1900") append;

dprobit everaconflictpost1900 fst_dist_europe ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_europe==1, robust;
scalar pr2=e(r2_p); sum everaconflictpost1900 if e(sample); scalar avconf=r(mean); sum fst_dist_europe if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("European regression, post-1900") append;

dprobit everaconflictpost1945 fst_dist_europe ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if both_in_europe==1, robust;
scalar pr2=e(r2_p); sum everaconflictpost1945 if e(sample); scalar avconf=r(mean); sum fst_dist_europe if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR4.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("European regression, post-1945") append;

* Table AUR5 - Historical regression with period breakdowns;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) title("Table AUR5: Sample breakdown by historical subperiod") ctitle("1816-2001 baseline") replace;

dprobit everaconflictpre1901 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflictpre1901 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("1816-1900") append;

dprobit everaconflictpost1900 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflictpost1900 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("1901-2001") append;

dprobit everaconflictpost1945 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflictpost1945 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("1946-2001") append;

dprobit everaconflict19191989 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict19191989 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("1919-1989") append;

dprobit everaconflictpost1989 fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflictpost1989 if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR5.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("1990-2001") append;

* Table AUR6 - Add Cultural Measures based on the WVS;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if total~=., robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) title("Table AUR6 - Including Cultural Distance Measures") 
ctitle("Baseline, cultural distance sample") replace;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry total, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Add cultural distance index") append;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry total_a total_c total_d total_e total_f total_g, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR6.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Add cultural distance index by category") append;

* Table AUR7 - Nonlinearities and interactions;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Baseline") title("Table AUR7 - Nonlinearities and sample splits") replace;

dprobit everaconflict fst_distance_weighted ldist ldifflong ldifflat landlock island common_water lareaprod colony smctry if contig==0, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Excluding contiguous pairs") append;

dprobit everaconflict fst_distance_weighted inter1 ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Contiguity interaction") append;

dprobit everaconflict fst_distance_weighted inter2 ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Proximity interaction") append;

dprobit everaconflict fst_distance_weighted inter4 majdum ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Major power interaction") append;

dprobit everaconflict fst_distance_weighted inter3 ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Spline") append;

dprobit everaconflict fst_distance_weighted fstdistsq ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR7.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Quadratic") append;

* Table AUR8 - Intensity of conflict; 

regress intensity fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
sum intensity if e(sample); scalar sdconf=r(sd); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar beta=100*fsteff*sdwgd/sdconf;
outreg2 using regressions\tableAUR8.doc, 2aster label tstat adjr2 bdec(4) tdec(3) addstat("Beta", beta) title("Table AUR8 - Intensity of conflict") ctitle("OLS on Max Intensity") replace;

regress intensity fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if intensity>0, robust;
sum intensity if e(sample); scalar sdconf=r(sd); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar beta=100*fsteff*sdwgd/sdconf;
outreg2 using regressions\tableAUR8.doc, 2aster label tstat adjr2 bdec(4) tdec(3) addstat("Beta", beta) ctitle("Subsample with conflict") append;

ivreg intensity (fst_distance_weighted=gendist_fst_1500) ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
sum intensity if e(sample); scalar sdconf=r(sd); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar beta=100*fsteff*sdwgd/sdconf;
outreg2 using regressions\tableAUR8.doc, 2aster label tstat adjr2 bdec(4) tdec(3) addstat("Beta", beta) ctitle("IV with 1500 GD") append;

regress fatalities fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
sum fatalities if e(sample); scalar sdconf=r(sd); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar beta=100*fsteff*sdwgd/sdconf;
outreg2 using regressions\tableAUR8.doc, 2aster label tstat adjr2 bdec(4) tdec(3) addstat("Beta", beta) ctitle("Index of casualties") append;

regress fatalities fst_distance_weighted ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry if fatalities>0, robust;
sum fatalities if e(sample); scalar sdconf=r(sd); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar beta=100*fsteff*sdwgd/sdconf;
outreg2 using regressions\tableAUR8.doc, 2aster label tstat adjr2 bdec(4) tdec(3) addstat("Beta", beta) ctitle("Only positive casualties") append;

ivreg fatalities (fst_distance_weighted=gendist_fst_1500) ldist ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
sum fatalities if e(sample); scalar sdconf=r(sd); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar beta=100*fsteff*sdwgd/sdconf;
outreg2 using regressions\tableAUR8.doc, 2aster label tstat adjr2 bdec(4) tdec(3) addstat("Beta", beta) ctitle("Total casualties index, IV with 1500 GD") append;

* Table AUR9 - Nonlinearities and other geographic controls;

dprobit everaconflict fst_distance_weighted ldist intergeo ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR9.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) title("Table AUR9 - Nonlinearities and other geographic controls") 
ctitle("Distance interaction term") replace;

dprobit everaconflict fst_distance_weighted ldist ldistsq ldifflong ldifflat contig landlock island common_water lareaprod colony smctry, robust;
scalar pr2=e(r2_p); sum everaconflict if e(sample); scalar avconf=r(mean); sum fst_distance_weighted if e(sample); scalar sdwgd=r(sd);
matrix coeffs=e(dfdx); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwgd/avconf;
outreg2 using regressions\tableAUR9.doc, 2aster label tstat bdec(6) tdec(3) addstat("Pseudo-R2", pr2, "Standardized effect (%)", effect) ctitle("Add distance squared") append;

