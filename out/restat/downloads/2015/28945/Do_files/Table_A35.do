*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file constructs Table A35 in the appendix of Berman and Couttenier (2014)											  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
*
			*--------------------------------------------*
			*--------------------------------------------*
			*   	TABLE A35- SPATIAL CORRELATION       *
			*--------------------------------------------*
			*--------------------------------------------*
*
*********************************
*A:100 KM DISTANCE, 2 YEAR LAGS *
*********************************
*
foreach shock in "lshock_fao" "exposure_crisis"{
forvalues x=3(1)3{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(100) dropvar lag(2)
	*
	}
*
forvalues x=1(1)2{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(100) dropvar lag(2)
	*
	}
}
log using Table_A35.log, replace
set linesize 250
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
*********************************
*B:100 KM DISTANCE, 10 YEAR LAG *
*********************************
*
foreach shock in "lshock_fao" "exposure_crisis"{
forvalues x=3(1)3{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(100) dropvar lag(10)
	*
	}
*
forvalues x=1(1)2{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(100) dropvar lag(10)
	*
	}
}
log using Table_A35.log, append
set linesize 250
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

*
*********************************
*C:1000 KM DISTANCE, 2 YEAR LAG *
*********************************
*
foreach shock in "lshock_fao" "exposure_crisis"{
forvalues x=3(1)3{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(1000) dropvar lag(2)
	**
	}
*
forvalues x=1(1)2{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(1000) dropvar lag(2)
	**
	}
}
log using Table_A35.log, append
set linesize 250
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
**********************************
*D:1000 KM DISTANCE, 10 YEAR LAG *
**********************************
*
foreach shock in "lshock_fao" "exposure_crisis"{
forvalues x=3(1)3{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(1000) dropvar lag(10)
	*
	}
*
forvalues x=1(1)2{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_c`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	bys gid: egen mean_conflict_c`x' = mean(conflict_c`x')
	g dm_conflict_c`x'               = conflict_c`x'-mean_conflict_c`x'
	drop mean_conflict_c`x'
    *
	foreach name in "shock" "shock_ldist"{
	bys gid: egen mean_`name' = mean(`name')
	g dm_`name'               = `name'-mean_`name'
	drop mean_`name'
	}
	forvalues i=1(1)31{
	bys gid: egen mean_yeard`i' = mean(yeard`i')
	g dm_yeard`i'               = yeard`i'-mean_yeard`i'
	drop mean_yeard`i'
	}
	egen country_num = group(iso3)
    *
	xtreg conflict_c`x' shock shock_ldist yeard*, fe ro cluster(fao_region)
	*
	eststo: ols_spatial_HAC dm_conflict_c`x' dm_shock dm_shock_ldist dm_yeard*, lat(latitude) lon(longitude) p(gid) t(year) dist(1000) dropvar lag(10)
	*
	}
}
log using Table_A35.log, append
set linesize 250
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(dm_shock dm_shock_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close
*
***************************
*E: COUNTRY-YEAR CLUSTERS *
***************************
*
foreach shock in "lshock_fao" "exposure_crisis"{
foreach x in  c3 c1 c2{
	use "$Output_data\data_BC_Restat2014", clear
	*
	g shock=`shock'
	g shock_ldist=`shock'*ldist
	qui xtreg conflict_`x' shock shock_ldist yeard*, fe cluster(fao_region) ro
	keep if e(sample)
	* 
	eststo: xtreg conflict_`x' shock shock_ldist yeard*, fe ro cluster(country_year) nonest 
	*
	}
}
log using Table_A35.log, append
set linesize 250
esttab, mtitles keep(shock shock_ldist) b(%5.3f) se(%5.3f) compress r2 starlevels(c 0.1 b 0.05 a 0.01)  se 
esttab, mtitles keep(shock shock_ldist) b(%5.3f) se(%5.3f) r2  starlevels({$^c$} 0.1 {$^b$} 0.05 {$^a$} 0.01) se tex label  title() 
eststo clear
log close

