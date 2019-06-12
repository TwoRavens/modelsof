///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//////////////////        A BETTER LIFE FOR ALL?       ////////////////////
////////////////// DEMOCRATIZATION AND ELECTRIFICATION ////////////////////
//////////////////   IN POST-APARTHEID SOUTH AFRICA    ////////////////////
////////////////// BY V.KROTH, V.LARCINESE, & J.WEHNER ////////////////////
//////////////////        DATE: 8 DECEMBER 2015        ////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////



* For full variable definitions and sources, refer to the online appendix.
* Use this do file with "dataverse_dataset_MN_2015-12-10.dta".



set more off



* Table 1: The impact of enfranchisement on electrification

xi:reg  D_El_light VA_nonwhite, robust
xi:reg  D_El_light VA_nonwhite i.Province, robust
xi:reg  D_El_light VA_nonwhite distance_grid_km distance_road_km slope_mean elevation_mean i.Province , robust
xi:reg  D_El_light VA_nonwhite distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, robust
xi:reg  D_El_light VA_black96 VA_Coloured96 VA_Indian96 noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, robust



* Table 2: Replication with satellite data and test for pre-existing trends

* 1996-2001
xi:reg  D_night VA_nonwhite, robust
xi:reg  D_night VA_nonwhite i.Province, robust
xi:reg  D_night VA_nonwhite distance_grid_km distance_road_km slope_mean elevation_mean i.Province , robust
xi:reg  D_night VA_nonwhite distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_night VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_night VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, robust
xi:reg  D_night VA_black96 VA_Coloured96 VA_Indian96 noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, robust

* 1992-1996
xi:reg  D_night92 VA_nonwhite, robust
xi:reg  D_night92 VA_nonwhite i.Province, robust
xi:reg  D_night92 VA_nonwhite distance_grid_km distance_road_km slope_mean elevation_mean i.Province , robust
xi:reg  D_night92 VA_nonwhite distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_night92 VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_night92 VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, robust
xi:reg  D_night92 VA_black96 VA_Coloured96 VA_Indian96 noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density i.Province, robust



* Table 4: The role of the ANCÕs seat share on local councils

xi:reg  D_El_light VA_nonwhite seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_El_light seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_El_light VA_nonwhite seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist == 0, robust
xi:reg  D_El_light VA_nonwhite seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist == 1, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist == 0, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist == 1, robust
xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist==0, robust
xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist==1, robust



* Figure 3: Enfranchisement conditional on ANC seat share quarter

xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
margins, dydx(VA_nonwhite) at(seatshare_q = (0(1)3))
* Some evidence of a "core constituency" effect, let's graph it.
marginsplot, recast(scatter) graphregion(color(white)) ylabel(-.5 0 .5 1 1.5, nogrid) yline(0, lcolor(gs12) lpattern(shortdash)) /*
*/ ymticks(-.4 -.3 -.2 -.1 .1 .2 .3 .4 .6 .7 .8 .9 1.1 1.2 1.3 1.4 ) ytitle("Marginal Effect of Enfranchised", color(black)) title("            (a) Full Sample", color(black) margin(medsmall) size(medsmall)) recastci(rspike) /*
*/ xtitle("ANC Seat Share Quarter", color(white)) xlabel(0 "Q1" 1 "Q2" 2 "Q3" 3 "Q4") xscale(range(-.5 3.5)) name(core1, replace)

* munidist == 0
xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist==0, robust
margins, dydx(VA_nonwhite) at(seatshare_q = (0(1)3))
* Some evidence of a "core constituency" effect, let's graph it.
marginsplot, plotopts(color(cranberry)) ciopts(color(cranberry)) recast(scatter) graphregion(color(white)) ylabel(-.5 0 .5 1 1.5, nogrid) yline(0, lcolor(gs12) lpattern(shortdash)) /*
*/ ymticks(-.4 -.3 -.2 -.1 .1 .2 .3 .4 .6 .7 .8 .9 1.1 1.2 1.3 1.4 ) ytitle("Marginal Effect of Enfranchised", color(white)) title("            (b) Eskom Distribution", color(black) margin(medsmall) size(medsmall)) recastci(rspike) /*
*/ xtitle("ANC Seat Share Quarter", color(black)) xlabel(0 "Q1" 1 "Q2" 2 "Q3" 3 "Q4") xscale(range(-.5 3.5)) name(core2, replace)

* munidist == 1
xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if munidist==1, robust
margins, dydx(VA_nonwhite) at(seatshare_q = (0(1)3))
* Some evidence of a "core constituency" effect, let's graph it.
marginsplot, plotopts(color(eltgreen)) ciopts(color(eltgreen)) recast(scatter) graphregion(color(white)) ylabel(-.5 0 .5 1 1.5, nogrid) yline(0, lcolor(gs12) lpattern(shortdash)) /*
*/ ymticks(-.4 -.3 -.2 -.1 .1 .2 .3 .4 .6 .7 .8 .9 1.1 1.2 1.3 1.4 ) ytitle("Marginal Effect of Enfranchised", color(white)) title("            (c) Municipal Distribution", color(black) margin(medsmall) size(medsmall)) recastci(rspike) /*
*/ xtitle("ANC Seat Share Quarter", color(white)) xlabel(0 "Q1" 1 "Q2" 2 "Q3" 3 "Q4") xscale(range(-.5 3.5)) name(core3, replace)

* Combined graph of all three interactions
graph combine core1 core2 core3, imargin(vsmall) graphregion(color(white) lwidth(large)) /*
*/ rows(1) xsize(5) ysize(4) graphregion(margin(l=1 r=1 t=27 b=27)) name(core, replace)
graph export "SA_fig_interact1.eps", replace

* Formal test if seat quarter effects are significantly different across Eskom and municipal distribution samples
* The main specification now includes a three-way interaction between enfranchised, seat share quarter dummies, and municipal distribution dummy
gen Eskom = 1 - munidist
xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q##i.Eskom noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust

* To recover the coefficients from the split sample, all controls need to interact with the municipal distribution dummy
tab Province, gen(p)
xi:reg  D_El_light c.VA_nonwhite##i.seatshare_q##i.Eskom /*
*/ c.noel1996##i.Eskom c.distance_grid_km##i.Eskom c.distance_road_km##i.Eskom c.slope_mean##i.Eskom c.elevation_mean##i.Eskom c.h96##i.Eskom c.density96##i.Eskom /*
*/ c.noschool96##i.Eskom c.lowincome96##i.Eskom c.median1996##i.Eskom /*
*/ p1##i.Eskom p2##i.Eskom p3##i.Eskom p4##i.Eskom p5##i.Eskom p6##i.Eskom p7##i.Eskom p8##i.Eskom p9##i.Eskom, robust



* Table B1: Descriptive statistics for municipality dataset

egen VA_nonwhite_median = median(VA_nonwhite)
tabstat D_El_light D_night Electricity96 nightlight1996 Electricity01 nightlight2001 VA_nonwhite VA_black96 VA_Coloured96 VA_Indian96 seatshare NP_seatshare IFP_seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density if VA_nonwhite >= VA_nonwhite_median, stat(N mean sd p25 p50 p75 min max) col(stat)
tabstat D_El_light D_night Electricity96 nightlight1996 Electricity01 nightlight2001 VA_nonwhite VA_black96 VA_Coloured96 VA_Indian96 seatshare NP_seatshare IFP_seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density if VA_nonwhite < VA_nonwhite_median, stat(N mean sd p25 p50 p75 min max) col(stat)
tabstat D_El_light D_night Electricity96 nightlight1996 Electricity01 nightlight2001 VA_nonwhite VA_black96 VA_Coloured96 VA_Indian96 seatshare NP_seatshare IFP_seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 D_noschool Dmedian Dh D_density, stat(N mean sd p25 p50 p75 min max) col(stat)



* Table B3: Robustness to excluding municipalities with high levels of electrification in 1996

* Direct effects
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<90, robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<80, robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<70, robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<60, robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<50, robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<40, robust

* Conditional effects
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<90, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<80, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<70, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<60, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<50, robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Electricity96<40, robust



* Table B4: Robustness to excluding municipalities in individual provinces

* Direct effects
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Western Cape", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Northern Cape", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Eastern Cape", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="KwaZulu-Natal", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Free State", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Gauteng", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Northern Province/ LIM", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="North West", robust
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Mpumalanga", robust

* Conditional effects
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Western Cape", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Northern Cape", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Eastern Cape", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="KwaZulu-Natal", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Free State", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Gauteng", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Northern Province/ LIM", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="North West", robust
xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province if Province~="Mpumalanga", robust



* Figure B2: Coefficients on province fixed effects

tab Province, gen(pfe)
xi:reg  D_El_light VA_nonwhite noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 pfe1-pfe9, nocon robust
margins, dydx(pfe1 pfe2 pfe3 pfe4 pfe5 pfe6 pfe7 pfe8 pfe9) level(95) vsquish post
marginsplot, recast(scatter) graphregion(color(white)) ylabel(-20 -15 -10 -5 0 5 10, nogrid labsize(3.5)) yline(0, lcolor(gs12) lpattern(shortdash)) ymticks() ytitle("Coefficient", size(4.5) height(8)) title("") recastci(rspike) yscale(titlegap(-1)) xtitle("") xlabel(1 "EC" 2 "FS" 3 "GP" 4 "KZN" 5 "MP" 6 "NW" 7 "NC" 8 "NP" 9 "WC", labsize(3.5)) xscale(range(0 10) titlegap(1)) name(fixedeffects, replace)



* Figure B3: Conditional effect with alternative measures of partisan representation

xi:reg  D_El_light c.VA_nonwhite##c.seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
margins , dydx(VA_nonwhite) at(seatshare=(0(10)100)) vsquish
marginsplot , plotopts(msym(i)) recastci(rline) ciopts(lp(dash)) yline(0) graphregion(fcolor(white)) graphregion(color(white)) /*
*/ ylabel(-.4 -.2 0 .2 .4 .6 .8, nogrid) ytick(-.4(.1).8) xlabel(0 20 40 60 80 100, nogrid) xtick(10(10)100) /*
*/ title("") ytitle("Marginal Effect of Enfranchised") xtitle("ANC Seat Share") name(interact1, replace)

xi:reg  D_El_light c.VA_nonwhite##c.NP_seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
margins , dydx(VA_nonwhite) at(NP_seatshare=(0(10)100)) vsquish
marginsplot , plotopts(msym(i)) recastci(rline) ciopts(lp(dash)) yline(0) graphregion(fcolor(white)) graphregion(color(white)) /*
*/ ylabel(-.4 -.2 0 .2 .4 .6 .8, nogrid) ytick(-.4(.1).8) xlabel(0 20 40 60 80 100, nogrid) xtick(10(10)100) /*
*/ title("") ytitle("   ") xtitle("NP Seat Share") name(interact2, replace)

xi:reg  D_El_light c.VA_nonwhite##c.IFP_seatshare noel1996 distance_grid_km distance_road_km slope_mean elevation_mean h96 density96 noschool96 lowincome96 median1996 i.Province, robust
margins , dydx(VA_nonwhite) at(IFP_seatshare=(0(10)100)) vsquish
marginsplot , plotopts(msym(i)) recastci(rline) ciopts(lp(dash)) yline(0) graphregion(fcolor(white)) graphregion(color(white)) /*
*/ ylabel(-.4 -.2 0 .2 .4 .6 .8, nogrid) ytick(-.4(.1).8) xlabel(0 20 40 60 80 100, nogrid) xtick(10(10)100) /*
*/ title("") ytitle("   ") xtitle("IFP Seat Share") name(interact3, replace)

graph combine interact1 interact2 interact3, imargin(vsmall) graphregion(color(white) lwidth(large)) /*
*/ rows(1) graphregion(margin(l=1 r=1 t=27 b=27)) name(interactions1, replace)


