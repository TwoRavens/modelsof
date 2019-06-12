/*Substatial effect from Models 1, refered to on page 20 in the Manuscript*/

/*Model 1*/
/*Regional percieved Q50*/
/*Man from Rivers*/
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
estsimp   logit  agreeQ50missing HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling

setx (man Rivers)max (HI_AWI_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta  age oil_producing  primary_secondary  informal_schooling) mean
 
setx HI_LC_district_comp p10
simqi, pr

setx HI_LC_district_comp p90
simqi, pr

/*Model 1*/
/*Regional percieved Q50*/
/*Women from Abia*/
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
estsimp   logit  agreeQ50missing HI_AWI_district_comp HI_LC_district_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta Rivers man age oil_producing  primary_secondary  informal_schooling

setx (Abia)max (man)min (HI_AWI_district_comp comp_AWI_induvidual  relative_lc_2 ///
Delta Rivers age oil_producing  primary_secondary  informal_schooling) mean
 
setx HI_LC_district_comp p10
simqi, pr

setx HI_LC_district_comp p90
simqi, pr

/*Substatial effects in Table A1 in the appendix*/
/*Model 3*/
/*Ethnic percived Q50*/
/*Man from Rivers*/
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
estsimp   logit agreeQ50missing  HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers  man age oil_producing  primary_secondary  informal_schooling

setx (man Rivers)max (HI_AWI_ethnicALL_comp comp_AWI_induvidual  relative_lc_2 ///
Abia Delta  age oil_producing  primary_secondary  informal_schooling) mean
 
setx HI_LC_ethnicALL_comp p10
simqi, pr

setx HI_LC_ethnicALL_comp p90
simqi, pr


/*Model 3*/
/*Ethnic percived Q50*/
/*Man from Rivers*/
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
estsimp   logit agreeQ50missing  HI_AWI_ethnicALL_comp HI_LC_ethnicALL_comp  comp_AWI_induvidual  relative_lc_2 ///
 Abia Delta Rivers  man age oil_producing  primary_secondary  informal_schooling

setx (Abia)max (man)min (HI_AWI_ethnicALL_comp comp_AWI_induvidual  relative_lc_2 ///
Delta Rivers age oil_producing  primary_secondary  informal_schooling) mean
 
setx HI_LC_ethnicALL_comp p10
simqi, pr

setx HI_LC_ethnicALL_comp p90
simqi, pr
