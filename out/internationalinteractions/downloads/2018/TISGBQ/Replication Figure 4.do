/*Replication Figure 4*/

/*Model 1*/
/*Regional percieved Q50*/
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
estsimp   logit  agreeQ50missing HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling

setx (HI_AWI_district_comp comp_AWI_induvidual  relative_lc_2 Abia Delta Rivers man age oil_producing ///
 primary_secondary  informal_schooling) mean


setx HI_LC_district_comp p0.1
simqi, pr
 
setx HI_LC_district_comp p10
simqi, pr


setx HI_LC_district_comp p20
simqi, pr
 

setx HI_LC_district_comp p30
simqi, pr
 

setx HI_LC_district_comp p40
simqi, pr
 

setx HI_LC_district_comp p50
simqi, pr
 

setx HI_LC_district_comp p60
simqi, pr
 

setx HI_LC_district_comp p70
simqi, pr
 
setx HI_LC_district_comp p80
simqi, pr
 
setx HI_LC_district_comp p90
simqi, pr
 
setx HI_LC_district_comp p99.9
simqi, pr
 
 /*Model 1*/
/*Regional percieved Q50*/
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
estsimp   logit  agreeQ50missing HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling

setx (HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling) mean

setx HI_AWI_district_comp p0.1
simqi, pr

 
setx HI_AWI_district_comp p10
simqi, pr


setx HI_AWI_district_comp p20
simqi, pr
 

setx HI_AWI_district_comp p30
simqi, pr
 

setx HI_AWI_district_comp p40
simqi, pr
 

setx HI_AWI_district_comp p50
simqi, pr
 

setx HI_AWI_district_comp p60
simqi, pr
 

setx HI_AWI_district_comp p70
simqi, pr
 
setx HI_AWI_district_comp p80
simqi, pr
 
setx HI_AWI_district_comp p90
simqi, pr

setx HI_AWI_district_comp p99.9
simqi, pr 
 
