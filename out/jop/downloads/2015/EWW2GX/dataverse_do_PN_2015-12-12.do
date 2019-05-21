///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//////////////////        A BETTER LIFE FOR ALL?       ////////////////////
////////////////// DEMOCRATIZATION AND ELECTRIFICATION ////////////////////
//////////////////   IN POST-APARTHEID SOUTH AFRICA    ////////////////////
////////////////// BY V.KROTH, V.LARCINESE, & J.WEHNER ////////////////////
//////////////////        DATE: 12 DECEMBER 2015       ////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////



* For full variable definitions and sources, refer to the online appendix.
* Use this do file with "dataverse_dataset_PN_2015-12-12.dta".



set more off



* Table 3: Matching contiguous census tracts from different municipalities
 
* These regressions use xtivreg2, which allows double clustering. Not specifying the instruments means the estimates are OLS. We report SEs from these regressions.
xtivreg2  D_El_light VA_nonwhite_MN, fe cluster(MN_code MN_border) 
xi:xtivreg2  D_El_light VA_nonwhite_MN i.Province, fe cluster(MN_code MN_border)
xi:xtivreg2  D_El_light VA_nonwhite_MN distance_grid_km distance_road_km slope_mean elevation_mean i.Province, fe cluster(MN_code MN_border)
xi:xtivreg2  D_El_light VA_nonwhite_MN distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, fe cluster(MN_code MN_border)
xi:xtivreg2  D_El_light VA_nonwhite_MN noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, fe cluster(MN_code MN_border)
xi:xtivreg2  D_El_light VA_nonwhite_MN noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, fe cluster(MN_code MN_border)
xi:xtivreg2  D_El_light VA_black96_MN VA_Coloured96_MN VA_Indian96_MN noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, fe cluster(MN_code MN_border)

* We repeat the regressions using xtreg (no clustering) in order to get the correct R2.
xtreg  D_El_light VA_nonwhite_MN, fe 
xi:xtreg  D_El_light VA_nonwhite_MN i.Province, fe
xi:xtreg  D_El_light VA_nonwhite_MN distance_grid_km distance_road_km slope_mean elevation_mean i.Province, fe
xi:xtreg  D_El_light VA_nonwhite_MN distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, fe
xi:xtreg  D_El_light VA_nonwhite_MN noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, fe
xi:xtreg  D_El_light VA_nonwhite_MN noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, fe
xi:xtreg  D_El_light VA_black96_MN VA_Coloured96_MN VA_Indian96_MN noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, fe



* Table B2: Descriptive statistics for contiguous census tracts dataset

tabstat D_El_light VA_nonwhite_MN VA_black96_MN VA_Coloured96_MN VA_Indian96_MN distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 noel1996 Dh D_density D_noschool Dmedian, stat(N mean sd p25 p50 p75 min max) col(stat)
