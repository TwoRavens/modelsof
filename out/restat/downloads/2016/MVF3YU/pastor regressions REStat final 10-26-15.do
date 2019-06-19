cap log close

clear *
set mem 500m
set matsize 10000
use preachers_010912,clear


log using preachers_071912,replace


* logs where appropriate
g ln_attendance=log(attendance)

* these are components of d_attendance and d_membership
g dln_trans_denom=log(cm__rec_trans_denom+1) -log(cm__rem_trans_denom+1)
g ln_deaths=log(1+cm__rem_dead)
g dln_trans_meth=log(cm__rec_trans_meth+1) -log(cm__rem_trans_meth+1)
g ln_baptisms=log(1+baptisms)
g ln_conf_faith=log(1+cm__rec_faith)
g net_trans=ln(1+cm__rec_trans_meth+cm__rec_trans_denom) - ln(1+cm__rem_trans_meth+cm__rem_trans_denom)

* generate a time-invariant church size measure
* note that since churches enter at different points in time, we need to 
* be very careful with this. here is my attempt at doing so
* note also that there is the complication of church circuit 
* reshuffling, so i require at least 15 obs to be defined
* as large or small

egen church_obs=count(attendance),by(dom_church_id)
egen attendance_median=median(attendance),by(year)
g large=attendance>attendance_median if attendance~=.

* global outcomes "dln_trans_denom dln_trans_meth attendance_change rev_proxy08_change ln_deaths membership_change cm__rec_faith_change ln_baptisms ln_conf_faith"
global outcomes "attendance_change ln_baptisms ln_deaths rev_proxy08_change membership_change net_trans"

***********************************************************
* generate 'performance' measures - log deaths, attendance (winsorized) net methodist transfers net other denom transfers, and "faith total" 
***********************************************************

* winsorize all outcome variables
foreach meas in $outcomes {
	egen `meas'__99=pctile(`meas'),p(99)
	replace `meas'=`meas'__99 if `meas'>`meas'__99 & `meas'~=.
	egen `meas'__1=pctile(`meas'),p(1)
	replace `meas'=`meas'__1 if `meas'<`meas'__1 & `meas'~=.
}	


* measure of first church performance
* we start by generating some attributes of the pastor's first church
egen minyear_pastor=min(year),by(pastoru)
g firstchurch=churchnumber==1

* average size of first observed church
sort pastoru year
egen temp=median(attendance) if firstchurch==1,by(pastoru)
egen att_firstchurch_mean=mean(temp),by(pastoru)
drop temp
g temp=attendance if minyear_pastor==year
egen att_firstchurch_start=mean(temp),by(pastoru)
drop temp
egen minyear_church=min(year),by(dom_church_id churchnumber pastoru)

* time at each church
g church_tenure=year-minyear_church+1
g ln_church_tenure=log(church_tenure)

* time in sample
g time_in_sample=year-minyear_pastor
g ln_time_in_sample=log(time_in_sample+1)

save temp,replace

*********************************************************************
* TABLE 1 **********************************************************
*********************************************************************

* generate summary stats here - look at 010112 for starting point on file
use temp,clear

* number of churches per pastor
g churchno=1
forvalues c=2/5 {
	g temp=church`c'~=""
	replace churchno=churchno+temp
	drop temp
}
egen churchobs=sum(churchno),by(year)
egen pastorobs=count(dom_church_id),by(year)

collapse pastorobs,by(year)

* ROW 1 OF TABLE 1
sum pastorobs,d

use temp,clear
keep if minyear_pastor>1961 & minyear_pastor<1990

egen maxtenure=max(church_tenure),by(pastoru dom_church_id)
egen maxtime=max(time_in_sample+1),by(pastoru)
egen maxchurch=max(churchnumber),by(pastoru)
collapse maxtenure maxtime maxchurch,by(pastoru dom_church_id)
* ROW 3 OF TABLE 1
sum maxtenure ,d
collapse maxchurch maxtime,by(pastoru)
* ROWS 4 AND 2 OF TABLE 1
sum maxchurch maxtime,d

use temp,replace
g newpastor=minyear_pastor==year
egen maxyear_pastor=max(year),by(pastoru)
g departpastor=maxyear_pastor==year
egen pastorsadded=sum(newpastor),by(year)
egen pastorsexit=sum(departpastor),by(year)

collapse pastorsadded pastorsexit oil,by(year)

* DATA FOR FIGURE 3
tab year, sum(pastorsexit)
tab year, sum(oil)
* ROW 5 AND 6 OF TABLE 1 
sum pastorsadded if year>1961,d
sum pastorsexit if year<2003,d

* ROWS 7-9 OF TABLE 1
use temp,replace
g attendance_change_adj=attendance_change-population_change
sum attendance attendance_change attendance_change_adj,d


* TABLE 2 - EMPIRICAL BAYES ESTIMATES

* this won't run with short-paneled churches
drop if church_obs<20

xtmixed attendance_change population_change i.dom_church_id || pastorunique:
estimates store RE2
predict pastor_re2,reffects

* to compare role of pastors, calculate SD of within-church variance in growth
egen avgrowth=mean(attendance_change),by(dom_church_id)
g d_growth=attendance_change-avgrowth
sum d_growth,d

xtmixed attendance_change population_change i.dom_church_id || pastorunique:, vce(cluster pastoru)
estimates store RE
predict pastor_re,reffects

xtmixed attendance_change population_change i.dom_church_id , vce(cluster pastoru)
estimates store FE

lrtest RE FE

egen large_pastoru=group(pastoru large) if large~=.

* large vs. small
xtmixed attendance_change population_change i.dom_church_id || large_pastoru:
predict pastor_re_size,reffects
bys large: sum pastor_re_size,d


* TABLE 3 - VARIANCE DECOMPOSITION

use temp,replace

drop if pastorunique==.
drop if dom_church_id==.

tsset dom_church_id year

* this requires that there be at least one pre-pastor obs - otherwise we can't be
* sure that this is an actual switch, or just a first appearance in the data
gen Pastor_Switch = l.pastorunique~=pastorunique & l.pastorunique~=. 
drop if attendance_change==.
/*
* add these lines if you want to do placebo
 g p2=l1.Pastor_Switch
replace Pastor_Switch=p2
*/
* add this line for placebo test - it ensures that there aren't multiple adjacent switches. You need this
* even for the non-placebo version to ensure that you are comparing a like set of observations
* replace Pastor_Switch=. if l.Pastor_Switch==1 | f.Pastor_Switch==1


egen obs_0=count(pastorunique) if Pastor_Switch==0
egen obs_1=count(pastorunique) if Pastor_Switch==1


// PANEL A
egen mean_attendance_change = mean(attendance_change)

gen Squared_Error1 = (attendance_change-mean_attendance_change)^2

egen SSE1_0 = sum(Squared_Error1) if Pastor_Switch==0
egen SSE1_1 = sum(Squared_Error1) if Pastor_Switch==1


// PANEL B
by dom_church_id: egen mean_attendance_change_bc = mean(attendance_change)

gen Squared_Error1_bc = (attendance_change-mean_attendance_change_bc)^2

egen SSE1_0_bc = sum(Squared_Error1_bc) if Pastor_Switch==0
egen SSE1_1_bc= sum(Squared_Error1_bc) if Pastor_Switch==1


duplicates drop Pastor_Switch, force
keep SSE* obs_0 obs_1

* OUTPUT FOR TABLE 3 IS HERE
sum


*********************************************************
* TABLE 4 - PERSISTENCE OF PERFORMANCE, REGRESSION FORM, AND FOCUSED ON FIRST CHURCH
*********************************************************

use temp,replace
* time at first church
egen time_at_church=count(attendance_change),by(pastoru churchnumber)
egen temp=count(attendance_change) if firstchurch==1,by(pastoru churchnumber)
egen time_at_firstchurch=mean(temp),by(pastoru)
drop temp

drop if church_obs<2

* now, we get residuals for each perf measure, and also derive one for each pastor's first church. this is his 'ability'
foreach meas in $outcomes {
	areg `meas' population_change i.year, absorb(dom_church_id)
	predict resid_`meas',resid
	g first_resid_`meas'=resid_`meas' if churchnumber==1 
	egen first_perf_`meas'=mean(first_resid_`meas'),by(pastoru)
	egen temp1=count(`meas') if churchnumber==1,by(pastoru)
	egen resid_obs_`meas'=mean(temp1),by(pastoru)
	drop temp1
}


* winnowing down the sample, put together measures for lagged perf & size
tsset dom_church_id year
g temp=l.ln_attendance if pastoru~=l.pastoru
egen start_size=mean(temp),by(pastoru churchnumber)
drop temp
foreach meas in attendance_change {
	foreach x in 1 2 {
		g perfl`x'_`meas'=l`x'.resid_`meas'
		}
	g temp=perfl1_`meas'+perfl2_`meas' if church_tenure==1
	egen pastperf_`meas'=mean(temp),by(dom_church_id churchnumber pastoru)
	drop temp
}


* GET RID OF OBS WHERE IT ISN'T 'REALLY' THE PASTOR'S FIRST CHURCH
g pre_arrival=minyear_pastor==1961 & when_admitted~=1961
drop if pre_arrival==1

* also these:
g late_arrival=when_admitted<minyear_pastor & when_admitted~=.
drop if late_arrival==1

* consider also dropping guys who entered the sample with huge churches
drop if att_firstchurch_start>500 & att_firstchurch_start~=.
drop if att_firstchurch_mean==.



xi: reg resid_attendance_change first_perf_attendance_change ln_time_in_sample i.year if churchnumber>1 , cluster(pastoru)
outreg2 first_perf_attendance_change ln_time_in_sample using table_persistence.xls, replace
* biggest relationship comes for the first year, paralleling Variance decomposition results
xi: reg resid_attendance_change first_perf_attendance_change ln_time_in_sample i.year if churchnumber>1 & church_tenure==1, cluster(pastoru)
outreg2 first_perf_attendance_change ln_time_in_sample using table_persistence.xls, append addtext(church tenure, "1")
xi: reg resid_attendance_change first_perf_attendance_change ln_time_in_sample i.year if churchnumber>1 & church_tenure>1, cluster(pastoru)
outreg2 first_perf_attendance_change ln_time_in_sample using table_persistence.xls, append addtext(church tenure, ">1")

* comfortingly, effect is stronger for those with more years at first church. presumably something like attenuation bias argument is most obvious explanation
xi: reg resid_attendance_change first_perf_attendance_change ln_time_in_sample i.year if churchnumber>1 & church_tenure==1 & time_at_firstchurch>1, cluster(pastoru)
outreg2 first_perf_attendance_change ln_time_in_sample using table_persistence.xls, append addtext(church tenure, "1",years at first church, ">1")
xi: reg resid_attendance_change first_perf_attendance_change ln_time_in_sample i.year if churchnumber>1 & church_tenure>1 & time_at_firstchurch>1, cluster(pastoru)
outreg2 first_perf_attendance_change ln_time_in_sample using table_persistence.xls, append addtext(church tenure, ">1",years at first church, ">1")


foreach meas in attendance_change {
   	g large_`meas'=large*first_perf_`meas'
 	g start_size_`meas'=start_size*first_perf_`meas'
}	
xi: reg resid_attendance_change first_perf_attendance_change ln_time_in_sample large_attendance_change large i.year if churchnumber>1 , cluster(pastoru)
outreg2 first_perf_attendance_change ln_time_in_sample large_attendance_change large using table_persistence.xls, append
xi: reg resid_attendance_change first_perf_attendance_change ln_time_in_sample large_attendance_change large i.year if churchnumber>1 & time_at_first>1 , cluster(pastoru)
outreg2 first_perf_attendance_change ln_time_in_sample large_attendance_change large using table_persistence.xls, append


*************************************************************
* Exit material
*************************************************************

* first, summary results, comparable to table 5 in prior paper
******************************************************************************
* TABLE 5 - EXIT PANEL
******************************************************************************

* go back to full sample; no obvious reason to winnow down the sample here
use temp,replace
drop if dom_church_id==. | pastorunique==.

egen pc_tenure = count(pastoru),by(dom_church_id pastoru churchnumber)
egen maxyear_pastor=max(year),by(pastoru)
g exit=maxyear==year

drop if year==2003

gen y_attendance_change_rank=.
foreach y of numlist 1962 1966/2002 {
	xtile temp = attendance_change if year==`y', nquantiles(4) 
	replace y_attendance_change_rank = temp if y_attendance_change_rank==.
	drop temp
}

* start by getting yearly ranks in attendance growth
egen rank=rank(attendance_change),by(year)
* now, since there's an unequal # of obs in each year, we'll normalize things
egen maxrank=max(rank),by(year)
replace rank=(rank-1)/(maxrank-1)

* take average across all years in a pastor's employment spell at a church

g tenured=year>=full_connection & full_connection~=.
g oil_high=oil>16.871
tabstat exit , by(y_attendance_change_rank) stat(mean)

tabstat exit if tenured==0, by(y_attendance_change_rank) stat(mean)
tabstat exit if tenured==1, by(y_attendance_change_rank) stat(mean)

tabstat exit if churchnumber==1, by(y_attendance_change_rank) stat(mean)
tabstat exit if churchnumber>1, by(y_attendance_change_rank) stat(mean)

tabstat exit if oil_high==0, by(y_attendance_change_rank) stat(mean)
tabstat exit if oil_high==1, by(y_attendance_change_rank) stat(mean)

* ROTATION PANEL
egen maxyear_pastor_church=max(year),by(pastoru dom_church_id)
g rotate=year==maxyear_pastor_church

replace rotate=. if exit==1
tabstat rotate , by(y_attendance_change_rank) stat(mean)

tabstat rotate if tenured==0, by(y_attendance_change_rank) stat(mean)
tabstat rotate if tenured==1, by(y_attendance_change_rank) stat(mean)

tabstat rotate if churchnumber==1, by(y_attendance_change_rank) stat(mean)
tabstat rotate if churchnumber>1, by(y_attendance_change_rank) stat(mean)


************************************************************************
* TABLE 6
************************************************************************
use temp,replace

sort dom_church_id year
tsset dom_church_id year

* generate measure for the size of the church at pastor arrival
g temp=l.ln_attendance if church_tenure==1
egen start_size=mean(temp),by(pastoru churchnumber dom_church_id)
drop temp
* regenerate some stuff again - we can slim down the do file on the next iteration.
egen time_at_church=count(attendance_change),by(churchnumber dom_church_id pastor)
egen temp=count(attendance_change) if firstchurch==1,by(pastoru churchnumber dom_church_id)
egen time_at_firstchurch=mean(temp),by(pastoru)
drop temp

* now, we get residuals for each perf measure 
foreach meas in attendance_change {
	areg `meas' population_change i.year, absorb(dom_church_id)
	predict resid_`meas',resid
	g first_resid_`meas'=resid_`meas' if churchnumber==1 
	egen first_perf_`meas'=mean(first_resid_`meas'),by(pastoru)
}

* stick to one measure of performance
g performance=resid_attendance_change
g ln_churchnumber=log(churchnumber)

g churchnumber_topcode=churchnumber
replace churchnumber_topcode=4 if churchnumber>3
tab churchnumber_topcode,gen(churchno_topcode)
drop churchno_topcode1

replace church_tenure=4 if church_tenure>4

egen pastor_church=group(pastoru dom_church_id churchnumber)
* the log spec seems to fit the data quite well
egen maxyear=max(year),by(pastoru)
g exit=year==maxyear
drop if year==2003 
egen maxyear_church=max(year),by(pastoru dom_church_id churchnumber)
g rotate=(year==maxyear_church) & exit==0

egen maxchurch=max(churchnumber),by(pastoru)
g lastchurch=maxchurch==churchnumber
g tenured=year>=full_connection & full_connection~=.
g oil_performance=oil*performance
g oil_ltenure=oil*ln_time_in_sample
g oil_tenured=oil*tenured
g performance_tenured=tenured*performance
g performance_time_in_sample=performance*ln_time_in_sample
g cohort=int(minyear_pastor/5)



* generate dummy variable for above median growth
egen med_att=median(attendance_change),by(year)
g attendance_change_high=attendance_change>med_att if attendance_change~=.

* set failure data
stset year , failure(exit) id(pastoru) origin(minyear_pastor)

stcox attendance_change, strata(dom_church_id) 
outreg2 attendance_change using Table_exit.xls, eform replace 
stcox attendance_change_high, strata(dom_church_id) r
outreg2 attendance_change_high using Table_exit.xls, eform append 
stcox attendance_change attendance_change_high, strata(dom_church_id) r
outreg2 attendance_change attendance_change_high using Table_exit.xls, eform append 

stset year , failure(rotate) exit(maxyear) id(pastoru) origin(minyear_pastor)
stcox attendance_change, strata(dom_church_id) r
outreg2 attendance_change using Table_exit.xls, eform append
stcox attendance_change_high, strata(dom_church_id) r
outreg2 attendance_change_high using Table_exit.xls, eform append 
stcox attendance_change attendance_change_high, strata(dom_church_id) r
outreg2 attendance_change attendance_change_high using Table_exit.xls, eform append 

*************************************************************
* TABLE 7
*************************************************************

* now, whether better performance in lagged church leads to placement at larger church

use temp,replace
drop _m
* regenerate some stuff again - we can slim down the do file on the next iteration.
sort dom_church_id year
tsset dom_church_id year

g start_size=l.ln_attendance if church_tenure==1

g pastgrowth1=l.attendance_change+l2.attendance_change if church_tenure==1
g pastgrowth2=l3.attendance_change+l2.attendance_change if church_tenure==1
g pastgrowth3=l4.attendance_change+l2.attendance_change + l3.attendance_change if church_tenure==1

* now, we get residuals for each perf measure 
foreach meas in attendance_change {
	areg `meas' population_change i.year, absorb(dom_church_id)
	predict resid_`meas',resid
	g first_resid_`meas'=resid_`meas' if churchnumber==1 
	egen first_perf_`meas'=mean(first_resid_`meas'),by(pastoru)
}

* stick to one measure of performance
g performance=resid_attendance_change
g ln_churchnumber=log(churchnumber)

egen pastor_church=group(pastoru dom_church_id)
* the log spec seems to fit the data quite well
egen maxyear=max(year),by(pastoru)
g exit=year==maxyear
egen maxyear_church=max(year),by(pastoru dom_church_id)
g rotate=year==maxyear_church

egen maxchurch=max(churchnumber),by(pastoru)
g lastchurch=maxchurch==churchnumber
drop if maxchurch<2
save temp1,replace
egen perf_avg=mean(performance),by(pastoru churchnumber)
collapse perf_avg start_size,by(pastoru churchnumber)
tsset pastoru churchnumber
g performance_lagged=l.perf_avg
sort pastoru churchnumber
save performance_lagged,replace

use temp1,replace
sort pastoru churchnumber
merge pastoru churchnumber using performance_lagged

xi: areg start_size performance_lagged i.year, absorb(pastoru) cluster(pastoru)
outreg2 performance_lagged using Table_laggedperformance.xls, replace addtext(churchno FE,"No", tenure FE, "No")
xi: areg start_size performance_lagged i.year i.churchnumber , absorb(pastoru) cluster(pastoru)
outreg2 performance_lagged using Table_laggedperformance.xls, append addtext(churchno FE,"Yes", tenure FE, "No")
xi: areg start_size performance_lagged ln_time_in_sample i.churchnumber i.time_in_sample i.year, absorb(pastoru) cluster(pastoru)
outreg2 performance_lagged ln_time_in_sample using Table_laggedperformance.xls, append addtext(churchno FE,"Yes")


*************************************************************
* TABLE A2 - performance over time
************************************************************
use temp,replace

* start by getting residuals once again for each perf measure
foreach meas in $outcomes {
	areg `meas' population_change i.year, absorb(dom_church_id)
	predict resid_`meas',resid
	g first_resid_`meas'=resid_`meas' if churchnumber==1 
	egen first_perf_`meas'=mean(first_resid_`meas'),by(pastoru)
}

* now get rid of people where it's unlikely we're catching them at their first church
g pre_arrival=minyear_pastor==1961 & when_admitted~=1961 & when_admitted~=.
drop if pre_arrival==1

* also these?
g late_arrival=when_admitted<minyear_pastor & when_admitted~=.
drop if late_arrival==1

* consider also dropping guys who entered the sample with huge churches
drop if att_firstchurch_start>500 & att_firstchurch_start~=.

egen time_at_church=count(attendance_change),by(pastoru churchnumber dom_church_id)
egen temp=count(attendance_change) if firstchurch==1,by(pastoru churchnumber dom_church_id)
egen time_at_firstchurch=mean(temp),by(pastoru)
drop temp


* stick to one measure of performance
g performance=resid_attendance_change

g ln_churchnumber=log(churchnumber)

g churchnumber_topcode=churchnumber
replace churchnumber_topcode=4 if churchnumber>3
tab churchnumber_topcode,gen(churchno_topcode)
drop churchno_topcode1

replace church_tenure=4 if church_tenure>4
egen max_churchnumber=max(churchnumber),by(pastoru)
egen pastor_church=group(pastoru dom_church_id)

drop if max_churchnumber==1
* these results are no longer at all significant; but this is in large part b/c
* the prior results were contingent on an implicit comparison to 1-church pastors.
* that is, it is really largely about selection, not improvement, in the 
* spirit of what is to follow
xi: areg attendance_change ln_churchnumber ln_time_in_sample i.year , absorb(pastoru) cluster(pastoru)
outreg2 ln_churchnumber using Table_churchnumber.xls, replace 
xi: areg attendance_change ln_church_tenure ln_time_in_sample i.year , absorb(pastor_church) cluster(pastoru)
outreg2 ln_church_tenure using Table_churchnumber.xls, append
xi: areg attendance_change ln_churchnumber ln_church_tenure ln_time_in_sample i.year , absorb(pastoru) cluster(pastoru)
outreg2 ln_churchnumber ln_church_tenure using Table_churchnumber.xls, append


* FIGURE 1 - SPEARMAN 
use temp,clear

* start by getting yearly ranks in attendance growth
egen rank=rank(attendance_change),by(year)
* now, since there's an unequal # of obs in each year, we'll normalize things
egen maxrank=max(rank),by(year)
replace rank=(rank-1)/(maxrank-1)

* take average across all years in a pastor's employment spell at a church
egen avrank=mean(rank),by(dom_church_id pastoru churchnumber)

* now collapse down to church-pastor match level
collapse year avrank,by(dom_church_id pastoru churchnumber)
ren avrank rank
tsset pastoru churchnumber
g lrank=l.rank

corr rank lrank
spearman rank lrank
*you can see it's a real mess if you leave things uncollapsed.
twoway scatter rank lrank


* so we collapse down to, say, those in 1% bins by lrank and see how that predicts rank
g lrank_1pct=int(lrank*100)
egen obs=count(lrank_1pct),by(lrank_1pct)
collapse obs rank,by(lrank_1pct)
replace obs=obs/10
label variable lrank "Lagged rank (averaged at 1% intervals)"
label variable rank "Average Current Rank"
replace rank=rank*100
scatter rank lrank [w=obs], msymbol(oh) 




* FIGURE 2: DOES PASTOR QUALITY PREDICT INITIAL PLACEMENT?

* does subsequent performance predict size of initial placement? 
use temp,replace

* time at first church
egen time_at_church=count(ln_attendance),by(pastoru churchnumber)
egen temp=count(ln_attendance) if firstchurch==1,by(pastoru churchnumber)
egen time_at_firstchurch=mean(temp),by(pastoru)
drop temp


* now, we get residuals for each perf measure, and also derive one for each pastor's first church. this is his 'ability'
foreach meas in attendance_change {
	areg `meas' population_change i.year, absorb(dom_church_id)
	predict resid_`meas',resid
	g first_resid_`meas'=resid_`meas' if churchnumber==1 
	g postfirst_`meas'=resid_`meas' if churchnumber~=1 
	egen first_perf_`meas'=mean(first_resid_`meas'),by(pastoru)
	egen temp1=count(`meas') if churchnumber==1,by(pastoru)
	egen resid_obs_`meas'=mean(temp1),by(pastoru)
	drop temp1
}

* before winnowing down the sample, put together measures for lagged perf & size
tsset dom_church_id year
g temp1=l.ln_attendance if pastoru~=l.pastoru
egen start_size=mean(temp1),by(pastoru churchnumber)
g temp2=l.ln_attendance-l4.ln_attendance if pastoru~=l.pastoru
egen start_growth_3yeardiff=mean(temp2),by(pastoru churchnumber)
drop temp*

* and assignment to high-growth areas?
g pastpopgrowth=l.population_change + l2.population_change + l3.population_change
g currentpopgrowth=population_change + f1.population_change + f2.population_change

egen postfirst_performance=mean(postfirst_attendance_change),by(pastoru)

* GET RID OF OBS WHERE IT ISN'T 'REALLY' THE PASTOR'S FIRST CHURCH
g pre_arrival=minyear_pastor==1961 & when_admitted~=1961
drop if pre_arrival==1

* also these:
g late_arrival=when_admitted<minyear_pastor & when_admitted~=.
drop if late_arrival==1

* also drop guys who entered the sample with huge churches
drop if att_firstchurch_start>500 & att_firstchurch_start~=.
drop if att_firstchurch_mean==.

keep if church_tenure==1 & firstchurch==1

* now cross-tabs for FIGURE @
drop if postfirst_performance==.
foreach meas in postfirst_performance {
	egen temp1=pctile(`meas'),p(33.33)
	egen temp2=pctile(`meas'),p(66.67)
}
g tercile=1 if postfirst_performance<temp1
replace tercile=3 if postfirst_performance>temp2
replace tercile=2 if tercile==.
	
foreach meas in start_growth_3yeardiff pastpopgrowth currentpopgrowth start_size {
	tab tercile,sum(`meas')
}


log close
log translate preachers_071912.smcl preachers_071912.txt,replace
