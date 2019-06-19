
*****************************************************************
*  Replicates Tables 2, 3, 4 and Figure 1 in the paper          * 
*  GOVERNMENT INVOLVEMENT IN THE CORPORATE GOVERNANCE OF BANKS  *
*  Linus Siming													*
*****************************************************************

use sectordata.dta, clear
set more off

* Combining data on returns with event day date into one file to be used for all 
* estimations of Cumulative abnormal returns (CAR) 
use po_eventdates_banks, clear
sort sector_id
by sector_id: gen eventcount=_N
by sector_id: keep if _n==1
sort sector_id
keep sector_id eventcount 
save eventcount, replace
use sectordata, clear
sort sector_id
merge sector_id using eventcount
keep if _merge==3
drop _merge
expand eventcount		 
drop eventcount
sort sector_id trading_date
by sector_id trading_date: gen set=_n
sort sector_id set
save sectordata2, replace
use po_eventdates_banks, clear
sort sector_id
by sector_id: gen set=_n
sort sector_id set
save eventdates2, replace
use sectordata2, clear
merge sector_id set using eventdates2
keep if _merge==3
drop _merge
egen group_id = group(sector_id set)	  
sort group_id trading_date
by group_id: gen datenum=_n
by group_id: gen target=datenum if trading_date==event_date
egen td=min(target), by(group_id)
drop target
gen dif=datenum-td

* Save file for repeated use with different window lengths
save basefile, replace

*****************************************************************
*** Table 2, CAR before the event day for various windows
* Window: -6 to -1
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=-1
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -5 to -1
use basefile, clear
by group_id: gen event_window=1 if dif>=-5 & dif<=-1
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -4 to -1
use basefile, clear
by group_id: gen event_window=1 if dif>=-4 & dif<=-1
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -3 to -1
use basefile, clear
by group_id: gen event_window=1 if dif>=-3 & dif<=-1
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -2 to -1
use basefile, clear
by group_id: gen event_window=1 if dif>=-2 & dif<=-1
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0


*****************************************************************
*** Table 3, CAR after the event day for various windows
use basefile, clear

* Window: 0 to +1
use basefile, clear
by group_id: gen event_window=1 if dif>=0 & dif<=1
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: 0 to +2
use basefile, clear
by group_id: gen event_window=1 if dif>=0 & dif<=2
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: 0 to +3
use basefile, clear
by group_id: gen event_window=1 if dif>=0 & dif<=3
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: 0 to +4
use basefile, clear
by group_id: gen event_window=1 if dif>=0 & dif<=4
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: 0 to +5
use basefile, clear
by group_id: gen event_window=1 if dif>=0 & dif<=5
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: 0 to +6
use basefile, clear
by group_id: gen event_window=1 if dif>=0 & dif<=6
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

*****************************************************************
*** Table 4, CAR around the event day for various windows
use basefile, clear

* Window: -1 to +1
use basefile, clear
by group_id: gen event_window=1 if dif>=-1 & dif<=1
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -2 to +2
use basefile, clear
by group_id: gen event_window=1 if dif>=-2 & dif<=2
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -3 to +3
use basefile, clear
by group_id: gen event_window=1 if dif>=-3 & dif<=3
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -4 to +4
use basefile, clear
by group_id: gen event_window=1 if dif>=-4 & dif<=4
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -5 to +5
use basefile, clear
by group_id: gen event_window=1 if dif>=-5 & dif<=5
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0

* Window: -6 to +6
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=6
egen windowlength=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
sort id trading_date
by id: egen sd_abnormal_return = sd(abnormal_return) 
gen test =car/(sqrt(windowlength)*sd_abnormal_return)
gen stcar=sqrt(windowlength)*sd_abnormal_return
list group_id car stcar test if dif==0


*****************************************************************
*** Figure 1
* Data points of Figure 1

* March 11
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=-6
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 12
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=-5
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 15
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=-4
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 16
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=-3
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 17
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=-2
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 18
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=-1
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 19
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=0
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 22
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=1
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 23
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=2
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 24
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=3
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 25
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=4
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 26
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=5
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

* March 29
use basefile, clear
by group_id: gen event_window=1 if dif>=-6 & dif<=6
egen count_event_obs=count(event_window), by(group_id)
by group_id: gen estimation_window=1 if dif<-15 & dif>=-252
egen count_est_obs=count(estimation_window), by(group_id)
gen predicted_return=.
egen id=group(group_id) 
sum id
forvalues i=1(1)1 {
	l id group_id if id==`i' & dif==0
	reg ln_return ln_market_return if id==`i' & estimation_window==1 
	predict p if id==`i'
	replace predicted_return = p if id==`i' & event_window==1 
	drop p
	}	
sort id trading_date
gen abnormal_return=ln_ret-predicted_return if event_window==1
by id: egen cumulative_abnormal_return = sum(abnormal_return) 
gen car=cumulative_abnormal_return 
list group_id car if dif==0

clear
*****************************************************************
