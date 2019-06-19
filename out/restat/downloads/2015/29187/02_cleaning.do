
set more off
clear all
set mem 500m

log using "C:\output\logs\cleaning_log", replace

use c:\research\denver\temp\newcodes.dta

***** START: DROPS *****

* summary stats before drops
egen hh_before=tag(panid)
egen trip_before=tag(tdate panid store) 
gen scan_before=1
egen cat_before=tag(good_group)
egen hhs_before=sum(hh_before)
egen trips_before=sum(trip_before)
egen gtrips_before=sum(trip_before) if store_type=="grocery"
egen scans_before=sum(scan_before)
egen cats_before=sum(cat_before)

* keep households with at least 24 months of data
egen mindate=min(tdate), by(panid)
egen maxdate=max(tdate), by(panid)
gen startdate=mdy(2,1,1993)
gen enddate=mdy(1,31,1995)
keep if mindate<=startdate
keep if maxdate>=enddate

* * keep households with at least 48 two week intervals of data
* egen mindate=min(jweek), by(panid)
* egen maxdate=max(jweek), by(panid)
* gen startdate=1730
* gen enddate=1826
* keep if mindate<startdate
* keep if maxdate>=enddateegen hh_after1=tag(panid)

egen hh_after1=tag(panid)
egen trip_after1=tag(tdate panid store) 
gen scan_after1=1
egen cat_after1=tag(good_group)
egen hhs_after1=sum(hh_after1)
egen trips_after1=sum(trip_after1)
egen gtrips_after1=sum(trip_after1) if store_type=="grocery"
egen scans_after1=sum(scan_after1)
egen cats_after1=sum(cat_after1)

* trim data to 24 months
drop if tdate<startdate
drop if tdate>enddate

* monthly intervals
sort year month
egen period=group(year month)

* * trim data to 48 two weeks intervals
* drop if jweek<startdate
* drop if jweek>=enddate

* * two week intervals
* gen twoweek=jweek
* replace twoweek=twoweek-1 if mod(twoweek,2)==1
* * table twoweek
* sort twoweek
* egen period=group(twoweek)

egen hh_after2=tag(panid)
egen trip_after2=tag(tdate panid store) 
gen scan_after2=1
egen cat_after2=tag(good_group)
egen hhs_after2=sum(hh_after2)
egen trips_after2=sum(trip_after2)
egen gtrips_after2=sum(trip_after2) if store_type=="grocery"
egen scans_after2=sum(scan_after2)
egen cats_after2=sum(cat_after2)

* drop household if no expenditures in a period
drop if price==0
egen period_count=tag(panid period)
egen period_counts=sum(period_count), by(panid)
summarize period, meanonly
drop if period_counts<`r(max)'

egen hh_after3=tag(panid)
egen trip_after3=tag(tdate panid store) 
gen scan_after3=1
egen cat_after3=tag(good_group)
egen hhs_after3=sum(hh_after3)
egen trips_after3=sum(trip_after3)
egen gtrips_after3=sum(trip_after3) if store_type=="grocery"
egen scans_after3=sum(scan_after3)
egen cats_after3=sum(cat_after3)

***** END: DROPS *****

* summary stats after drops
summarize period 
summarize hhs_before hhs_after1 hhs_after2 hhs_after3
summarize trips_before trips_after1 trips_after2 trips_after3 
summarize gtrips_before gtrips_after1 gtrips_after2 gtrips_after3
summarize scans_before scans_after1 scans_after2 scans_after3 
summarize cats_before cats_after1 cats_after2 cats_after3

* drop excess variables
drop mindate maxdate startdate enddate
drop hh_before hh_after1 hh_after2 hh_after3 
drop trip_before trip_after1 trip_after2 trip_after3
drop scan_before scan_after1 scan_after2 scan_after3 
drop cat_before cat_after1 cat_after2 cat_after3
drop hhs_before hhs_after1 hhs_after2 hhs_after3
drop trips_before trips_after1 trips_after2 trips_after3
drop gtrips_before gtrips_after1 gtrips_after2 gtrips_after3 
drop scans_before scans_after1 scans_after2 scans_after3 
drop cats_before cats_after1 cats_after2 cats_after3 

save c:\research\denver\temp\cleaning.dta, replace

log close

clear all
set more on

