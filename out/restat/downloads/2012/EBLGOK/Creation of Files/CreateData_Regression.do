clear

set mem 200m
set more off

*Define a bunch of macros

local estwindow = 180 /*Calender days*/
local evtwindow = 30 /*Calender days*/
local minevtwindow = 50
local minestwindow = 60
local EVENT	  "majorinitiative1summit" /*anyevent1 anyevent2 debtreliefevent compevent decevent majorinitiative1 majorinitiative2 majorinitiative1summit majorinitiative2alt*/
local thintrade    = 0 /*0: Do not deal with thin trading issues, 1 deal with  them using trade-to-trade returns*/
local controlevents = 1  /*Whether to include dummies for the corporate events occuring during the relevant periods*/
local controlindustry = 1 /*Whether to include a industrial index in the baseline model (improves the fit significanlty*/


use financial_data_ZAF_parents, clear/*Fill here the correct name for the database*/


capture gen year = year(date) /*Make sure the data has only a stata formatted date*/

capture egen parent_id = group(ticker)


*At this point I should drop the observations with no data so that the number of events, etc reflects those with data only

*There must be a command here merging with the event data

egen paso = min(date) if p_close~=., by(ticker)

egen firstobs = min(paso), by(ticker)

drop paso

drop if date<firstobs

drop if date<=12963 /*No market nor any other data before that*/

drop if date>=17491 /*Database only partial after that*/


sort ticker date


*********************************************************************************

if "`EVENT'"=="decevent" {
	merge ticker date using event_dates_zaf_parents.dta, nok keep(`EVENT' dec_hipc dec_ehipc size_intense size_employ)
}
if "`EVENT'"=="compevent" {
	merge ticker date using event_dates_zaf_parents.dta, nok keep(`EVENT' comp_hipc comp_ehipc size_intense size_employ)
}
if "`EVENT'"=="debtreliefevent" {
	merge ticker date using event_dates_zaf_parents.dta, nok keep(`EVENT' debtrelief_hipc debtrelief_ehipc size_intense size_employ)
}
else if "`EVENT'"=="majorinitiative1" |"`EVENT'"=="majorinitiative2" | "`EVENT'"=="majorinitiative1summit" |"`EVENT'"=="majorinitiative2alt" |"`EVENT'"=="anyevent1" |"`EVENT'"=="anyevent2" {
	merge ticker date using event_dates_zaf_parents.dta, nok keep(`EVENT' size_intense size_employ)
}
*********************************************************************************
drop _merge

gen day = dow(date)

egen nevents= sum(`EVENT'), by(ticker)

drop if nevents == 0

*Now comes the process of creating the set of event dates and distances
*This may be done in the other database?

preserve

keep  if `EVENT'==1

keep ticker date `EVENT'

sort ticker date

by ticker: gen no = _n

reshape wide date, i(ticker) j(no)

renpfix date dateevent

sort ticker

saveold event_dates_T, replace

restore

sort ticker

merge ticker using event_dates_T, nok

drop _merge


foreach v of varlist dateevent* {
	gen no`v' = date - `v'
}


*I re-start now with the imputation of event windows

*Event indicators

local i = 1

gen eventnumber = .

foreach v of varlist nodateevent* {
	replace eventnumber = `i' if `v'>=-`estwindow' & `v'<=`evtwindow' & eventnumber==.
	local i = `i'+1
 }


*I will define event and estimation windows

gen estimation_window = .

local i = 1

gen event_window=.


foreach v of varlist nodateevent* {
	replace event_window=1 if `v'>=-`evtwindow' & `v'<=`evtwindow' & event_window==.
}


egen evt_wdw_length = sum(event_window), by(ticker eventnumber)


replace event_window = . if evt_wdw_length<`minevtwindow'


*Now I have to create the estimation windows

foreach v of varlist nodateevent* {
	replace estimation_window=1 if `v'>=-`estwindow' & `v'<-`evtwindow' & estimation_window==. & event_window==.
}


*Creating event time counter

gen event_real_time = .

local i = 1
foreach v of varlist nodateevent* {
	replace event_real_time=`v' if eventnumber == `i' & event_real_time==.
	local i = `i' + 1
}


*Now I need a way of teaching what estimation window to use in the cases where it is too short

*In the normal world I would be running regressions by ticker nevent on the estimation window and predicting on the event window

*What I have to do is to saveold the old estimates and if there is no regression on the estimation window predict using the old estimation,
*if there are too few observations I should run the regression using the contemporaneous and lagged estimation windows

*First I should create something as "relevant" number of events to count the regressions


*I will do it counting event windows

gen paso = event_window if `EVENT'==1


sort ticker eventnumber date


by ticker eventnumber: gen paso2 = sum(paso)

sort ticker date

gen paso3 = paso if paso==paso2


*This becomes an effective event indicator

gen EffectiveEvent = paso3

*Now I can take the cummulative sum of this guy to construct the number of effective events

sort ticker date

by ticker: gen paso4 = sum(paso3)

egen EffectiveEventNumber = max(paso4) if eventnumber~=., by(ticker eventnumber)

drop paso* dateevent* nodateevent*

*fine tunning

replace EffectiveEventNumber = . if event_window==. & estimation_window==.


egen Neffectiveevents = max(EffectiveEventNumber), by (ticker)


*Now put event_time to missing when events were dropped

replace event_real_time = . if EffectiveEventNumber == .


sort ticker date

*Add corporate actions

sort ticker date

merge ticker date using Corporate_Actions_Unique, nok keep(action ActionType)

rename action corporate_action

drop _merge


*saveold Financial_data_zaf_parents_with_events_T_`EVENT', replace

*==============================================================================================
*==============================================================================================


//
//local estwindow = 180
//local evtwindow = 30
//local minevtwindow = 50
//local minestwindow = 60
//local EVENT	  "majorinitiative1"
//local thintrade    = 1 /*0: Do not deal with thin trading issues, 1 deal with  them using trade-to-trade returns*/
//
//set more off
//
//use Financial_data_zaf_parents_with_events_T

capture rename return R
capture rename returnm Rm
capture rename returnd Rd


*Assign event date to the closest trading date if event on non-trading date



*gen  tmp1 = day if EffectiveEvent==1
*egen tmp2 = min(tmp1) if EffectiveEventNumber~=., by(ticker EffectiveEventNumber)


egen tmp3 = min(event_real_time) if event_real_time>=0 & pm_close~=. & EffectiveEventNumber~=., by(ticker EffectiveEventNumber)
egen tmp4 = min(tmp3) if EffectiveEventNumber~=., by(ticker EffectiveEventNumber)

gen EffectiveEventTradingDate = .
replace EffectiveEventTradingDate = 1 if event_real_time==tmp4 & event_real_time~=.

drop tmp*

***************************************************************
*YAGI ADDED THE FOLLOWING PART FOR THE SAKE OF ESTIMATION FOR
*DECISION AND COMPLETIION EVENTS BY THE REGRESSION APPROACH

if "`EVENT'"=="decevent" {
	gen dechipc = .
	gen decehipc = .
	egen tmp1 = max(dec_hipc), by(ticker EffectiveEventNumber)
	egen tmp2 = max(dec_ehipc), by(ticker EffectiveEventNumber)
	replace dechipc = tmp1
	replace decehipc = tmp2
	drop tmp*
}
if "`EVENT'"=="compevent" {
	gen comphipc = .
	gen compehipc = .
	egen tmp1 = max(comp_hipc), by(ticker EffectiveEventNumber)
	egen tmp2 = max(comp_ehipc), by(ticker EffectiveEventNumber)
	replace comphipc = tmp1
	replace compehipc = tmp2
	drop tmp*
}
if "`EVENT'"=="debtreliefevent" {
	gen debtreliefhipc = .
	gen debtreliefehipc = .
	egen tmp1 = max(debtrelief_hipc), by(ticker EffectiveEventNumber)
	egen tmp2 = max(debtrelief_ehipc), by(ticker EffectiveEventNumber)
	replace debtreliefhipc = tmp1
	replace debtreliefehipc = tmp2
	drop tmp*
}
***************************************************************


*Drop inactive dates

drop if pm_close==.


sort ticker date

by ticker: gen fpclose = p_close[_n+1]
by ticker: gen lpclose = p_close[_n-1]



*Put everything in event time

egen panel_id = group(ticker EffectiveEventNumber)

sort panel_id date
by panel_id: gen tmp = _n if EffectiveEventNumber~=.

*Pick event date

gen tmp2  = tmp if EffectiveEventTradingDate==1
egen tmp3 = min(tmp2), by(panel_id)

*Compute event time

gen event_time = tmp - tmp3


*Fill event time for intermediate periods

sort ticker date

forv i=1/100 {
	by ticker: replace event_time = event_time[_n+1]-1 if event_time==.
	}

drop tmp*

//Dealing with thin trading issue. I do this before restricting the sample of event windows so that I don't lose the initial obs

sort ticker date

if `thintrade'==1 {
	
	*Need to mark episodes of no trading that will be collapsed so that the dividends and other events can be properly assigned

	gen tmp = 1 if p_close==lpclose | p_close==.
	sort ticker date
	by ticker: gen date1 = date if tmp!=.
	by ticker: replace date1 = date1[_n-1] if tmp==tmp[_n-1]
	egen tmp4 = group(ticker date1)

	egen tmp5 = sum(dividend) if tmp4~=., by(ticker tmp4) /*Sum dividends over episodes*/
	by ticker: gen tmp6 = tmp5[_n-1] if tmp5==.		/*Assign them to the first trading date*/
	
	replace dividend = dividend + tmp6 if dividend~=. & tmp6~=. /*Assigning the sum to the dividend variable taking care of not putting missings*/
	replace dividend = tmp6 if dividend==. & tmp6~=.
	
	
	*Need to cummulate the returns of the companies that do not invest in hipc
	*Cannot just build the index because I would need a baseline, easier this way
	
	gen tmp8 = log(1+R_nohipc)
	
    	egen tmp9 = sum(tmp8) if tmp4~=., by(ticker tmp4) /*Sum dividends over episodes*/
	by ticker: gen tmp10 = tmp9[_n-1] if tmp9==.		/*Assign them to the first trading date*/
	
	gen R_nohipc_tt = exp(R_nohipc)-1 if tmp10==.
	replace R_nohipc_tt = exp(tmp10)-1 if tmp10~=.	
	
	*Assign corporate events that occur in no-trading dates to the next trading date
	*I'm keeping them as strings because I will use i. function to create dummies by action type (probably)
	
	egen tmp11 = mode(corporate_action) if tmp4~=., by(ticker tmp4) /*Sum dividends over episodes*/
	by ticker: gen tmp12 = tmp11[_n-1] if tmp9==.		/*Assign them to the first trading date*/
	
	replace corporate_action = tmp12 if corporate_action=="" & tmp12~="" /*Assigning the sum to the dividend variable taking care of not putting missings*/
	
	
	
	*--------Obs: Other variables that need to be somehow aggregated over non-trading periods can be treated in a similar manner
	
	drop if p_close == lpclose | p_close==.
	
	sort ticker date
	
	drop if p_close == p_close[_n+1]
	by ticker: gen rtt = ln(p_close/p_close[_n-1])
	by ticker: gen Rtt = (p_close/p_close[_n-1]-1)
	
	by ticker: gen tmp7 = ln((p_close+dividend)/p_close[_n-1])
	by ticker: gen tmp13 = ((p_close+dividend)/p_close[_n-1]-1)
	
	gen rdtt = rtt
	replace rdtt = tmp7 if tmp7~=.

	gen Rdtt = rtt
	replace Rdtt = tmp13 if tmp13~=.
	
    /*Computing trade to trade return of market index*/

	by ticker: gen rmtt = ln(pm_close/pm_close[_n-1])
	by ticker: gen Rmtt = (pm_close/pm_close[_n-1]-1)
	
	/*Computing trade to trade return of industry and size*/
	
    by ticker: gen rindtt = ln(p_group/p_group[_n-1])
	by ticker: gen Rindtt = (p_group/p_group[_n-1]-1)

    by ticker: gen rsizett = ln(p_size/p_size[_n-1])
	by ticker: gen Rsizett = (p_size/p_size[_n-1]-1)
	
	drop tmp*

	}

by ticker: gen ntt = event_time - event_time[_n-1]

*Defining the firm specific timing in trading days to the event

egen tmp  = min(event_time) if event_time>=0, by(panel_id)
egen tmp2 = min(tmp), by(panel_id)

sort panel_id event_time

by panel_id: gen tmp3 = _n if event_time==tmp2

egen tmp4 = min(tmp3), by(panel_id)

by panel_id: gen event_trading_time = _n - tmp4 if EffectiveEventNumber~=.

egen tmp5 = max(event_trading_time) if estimation_window==1, by(panel_id)

egen begin_trading_time = min(tmp5), by(panel_id)


sort parent_id date

forv i=1/100 {
	qui replace event_trading_time = event_trading_time[_n+1]-1 if event_window==. & estimation_window==. & event_trading_time==. & ticker==ticker[_n+1]
	qui replace begin_trading_time = begin_trading_time[_n+1] if event_window==. & estimation_window==. & begin_trading_time==. & ticker==ticker[_n+1]
}


drop tmp*

replace estimation_window = 1 if estimation_window==. & event_window==. & event_trading_time>=begin_trading_time-`minestwindow' & event_trading_time~=.


*Fictitious assignment of event time when required

sort parent_id date

forv i=1/100 {
	qui replace EffectiveEventNumber = EffectiveEventNumber[_n+1] if estimation_window==1 & EffectiveEventNumber==. & ticker==ticker[_n+1]
}

*Drop days that are neither estimation nor event windows

drop panel_id

egen panel_id = group(ticker EffectiveEventNumber)


drop if event_window==. & estimation_window==.


tsset panel_id event_time

*Clean and keep only variables that will be used in the final analysis

keep R Rm R_group ticker panel_id  estimation_window event_time date corporate_action year event_trading_time day event_window

compress

saveold data_event_study_before_estimation_T_`estwindow'_`evtwindow'_thin`thintrade'_`EVENT', replace
