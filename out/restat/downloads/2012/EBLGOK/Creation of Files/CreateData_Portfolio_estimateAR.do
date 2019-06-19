/*	-This program generates files with abnormal returns that can then be used to compute statistics following standard event study methodology
	 or to compute rank and sign statistics.
	-It has the particularity that it computes them with the parameters being estimated for different windows, starting from -180 unti approximately -90
	-Results are stored in different files
	-This new version computes the abnormal returns for the data without dividends too and cleans up the mess
	-Now only one file is saved at the end with the name determined by the parameters
	-The file produced can be called by programs that compute the average and std of abnormal returns using portfolio approach or those that compute non-parametric
	 statistics
	
	-Claudio Raddatz, November 2009
*/

/* This version re-opened the line where observations way before the event date are dropped
*/

clear

set mem 200m
set more off


local estwindow 	= 180 /*Calender days*/
local evtwindow 	= 30 /*Calender days: this does not define the length of the window for the actual estimation, just for calling the file. I'm using a window of 10 in line 42*/
local eventwindow	= 10 /*This is the actual event window*/
local minevtwindow 	= 25
local minestwindow 	= 50
local EVENT  		"compevent" /*majorinitiative1, majorinitiative2, majorinitiative1summit, majorinitiative2alt, decevent, compevent, or debtreliefevent*/
local thintrade    	= 0 /*0: Do not deal with thin trading issues, 1 deal with  them using trade-to-trade returns*/
local controlevents	= 1  /*Whether to include dummies for the corporate events occuring during the relevant periods*/
local controlindustry 	= 1 /*Whether to include a industrial index in the baseline model (improves the fit significanlty*/


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


compress



//======================================================================================================
//HERE STARTS THE ACTUAL ESTIMATION
//======================================================================================================

/*Build the event window of [-10 10]*/
/*This takes care of differentials between trading and calendar days*/

replace estimation_window = 1 if event_time<-`eventwindow' & event_window==1
replace event_window = 0 if event_time<-`eventwindow' & event_window==1
drop if event_time>`eventwindow'



if `thintrade'== 0 {
        gen Rexpected = .
        gen Rexpectedd = .
}
else if `thintrade'== 1 {
        gen Rexpectedtt = .
        gen Rexpectedttd = .
}

local controls ""

if `controlevents' == 1 {
        xi i.corporate_action, noomit
        foreach v of varlist _I* {
            replace `v' = 0 if `v'==.
        }
        renpfix _Ic C
        local controls "Corporate*"
}



if `controlindustry'==1 {
        if `thintrade'==0 {
            local controls "`controls' R_group"
           }
        else if `thintrade'==1 {
            local controls "`controls' Rindtt"
           }
 }


di "`controls'"


/*these below are only while I check that the program is doing what it should*/
gen alpha = .
gen beta  = .
gen nobs  = .
gen R2    = .
gen dof = .

gen alphad = .
gen betad  = .
gen nobsd  = .
gen R2d    = .
gen dofd = .


gen tmp = year if event_trading_time==0
egen eventyear = min(tmp), by(panel_id)
drop tmp

/*For checking robustness of the length of window, vary the estimation window by 10 market active days*/
/*This is for the majorityevent1 and the majorityevent2 with the non-thin trade case only*/

*drop if event_time<=-122 | event_time==. /*To be comparable to the portfolio approach*/

levelsof ticker, local(parents)


if `thintrade'== 0  {

	foreach p of local parents { /*Going over each of the companies*/
	
		di "`p'"
	
		qui su Neffectiveevents if ticker=="`p'"
		local nevents = r(max)
		di "`nevents'"
	
		forv i==1/`nevents' {	/*Going over each of the events affecting a company*/

			*First perform the estimation over the close estimation window with at least `minestwindow' observations
			
			*di "`i'"
			local j = `i'
			capture reg Rd Rm `controls' if ticker=="`p'" & EffectiveEventNumber==`i' & estimation_window==1
			if `i'>1 {
				while _rc~=0 | e(N)< `minestwindow'{
					local j = `j' - 1
					di "`j'"
					capture reg Rd Rm `controls' if ticker=="`p'" & EffectiveEventNumber<=`i' & EffectiveEventNumber>=`j' & estimation_window==1
				}
			}

			*Now predict for the event window
			*Also save the main parameters in the meantime

			replace alphad 	= _b[_cons] 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace betad  	= _b[Rm] 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace nobsd 	= e(N) 		if ticker=="`p'" & EffectiveEventNumber==`i'
			replace R2d 	= e(r2) 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace dofd 	= e(df_r) 	if ticker=="`p'" & EffectiveEventNumber==`i'

			predict tmp if ticker=="`p'" & EffectiveEventNumber==`i' , xb
			replace Rexpectedd = tmp if ticker=="`p'" & EffectiveEventNumber==`i'
			drop tmp
			
			*Now estimating with normal returns
			local j = `i'
			capture reg R Rm `controls' if ticker=="`p'" & EffectiveEventNumber==`i' & estimation_window==1
			if `i'>1 {
				
				while _rc~=0 | e(N)< `minestwindow'{
				
					local j = `j' - 1
					di "`j'"
					capture reg R Rm `controls' if ticker=="`p'" & EffectiveEventNumber<=`i' & EffectiveEventNumber>=`j' & estimation_window==1
				}
			}

			*Now predict for the event window
			*Also save the main parameters in the meantime

			replace alpha	 = _b[_cons] if ticker=="`p'" & EffectiveEventNumber==`i'
			replace beta 	 = _b[Rm] if ticker=="`p'" & EffectiveEventNumber==`i'
			replace nobs	 = e(N) if ticker=="`p'" & EffectiveEventNumber==`i'
			replace R2	 = e(r2) if ticker=="`p'" & EffectiveEventNumber==`i'
			replace dof	 = e(df_r) if ticker=="`p'" & EffectiveEventNumber==`i'

			predict tmp if ticker=="`p'" & EffectiveEventNumber==`i' , xb
			replace Rexpected = tmp if ticker=="`p'" & EffectiveEventNumber==`i'
			drop tmp
		}
	}

	*Compute abnormal returns
	gen AbnormalReturns	= R - Rexpected
      	gen AbnormalReturnsd	= Rd - Rexpectedd
			
}



else if `thintrade'== 1 {
      replace Rdtt    = Rdtt/sqrt(ntt) /*I'm adding this couple of lines so now I estimate daily returns*/
      replace Rtt     = Rtt/sqrt(ntt)
      replace Rmtt    = Rmtt/sqrt(ntt)
      replace Rindtt   = Rindtt/sqrt(ntt)
      gen     sqrtntt = sqrt(ntt)

	foreach p of local parents {
	
		di "`p'"
	
		qui su Neffectiveevents if ticker=="`p'"
		local nevents = r(max)
		di "`nevents'"

		forv i==1/`nevents' {

			*First perform the estimation over the close estimation window with at least `minestwindow' observations
			di "`i'"
			local j = `i'

          	capture reg Rdtt sqrtntt Rmtt `controls' if ticker=="`p'" & EffectiveEventNumber==`i' & estimation_window==1, nocons

			if `i'>1 {
				while _rc~=0 | e(N)< `minestwindow'{
					local j = `j' - 1
					di "`j'"
					capture reg Rdtt ntt Rmtt `controls' if ticker=="`p'" & EffectiveEventNumber<=`i' & EffectiveEventNumber>=`j' & estimation_window==1 [aw=1/ntt], nocons
				}
			}

			*Now predict for the event window
			*Also save the main parameters in the meantime

			replace alphad 	= _b[sqrtntt] 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace betad  	= _b[Rmtt] 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace nobsd 	= e(N) 		if ticker=="`p'" & EffectiveEventNumber==`i'
			replace R2d 	= e(r2) 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace dofd 	= e(df_r) 	if ticker=="`p'" & EffectiveEventNumber==`i'

			predict tmp if ticker=="`p'" & EffectiveEventNumber==`i' , xb
			replace Rexpectedttd = tmp if ticker=="`p'" & EffectiveEventNumber==`i'
			drop tmp
			
			*Returns without dividents
			
			local j = `i'
			capture reg Rtt sqrtntt Rmtt `controls' if ticker=="`p'" & EffectiveEventNumber==`i' & estimation_window==1, nocons
			if `i'>1 {
				while _rc~=0 | e(N)< `minestwindow'{
					local j = `j' - 1
					di "`j'"
					capture reg Rtt ntt Rmtt `controls' if ticker=="`p'" & EffectiveEventNumber<=`i' & EffectiveEventNumber>=`j' & estimation_window==1 [aw=1/ntt], nocons
				}
			}

			*Now predict for the event window
			*Also save the main parameters in the meantime

			replace alpha 	= _b[sqrtntt] 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace beta  	= _b[Rmtt] 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace nobs 	= e(N) 		if ticker=="`p'" & EffectiveEventNumber==`i'
			replace R2 	= e(r2) 	if ticker=="`p'" & EffectiveEventNumber==`i'
			replace dof 	= e(df_r) 	if ticker=="`p'" & EffectiveEventNumber==`i'

			predict tmp if ticker=="`p'" & EffectiveEventNumber==`i' , xb
			replace Rexpectedtt = tmp if ticker=="`p'" & EffectiveEventNumber==`i'
			drop tmp

		}

	}

	***DROP SAMPLE MANUALLY TO BE COMPARABLE TO NON-THIN TRADE CASE***
	*FOR majorinitiative2, drop AEG in 1999
	if "`EVENT'"=="majorinitiative2" |"`EVENT'"=="majorinitiative2alt" {
	drop if ticker == "AEG" & eventyear==1999

	gen tmp = panel_id-1
	drop panel_id
	gen panel_id = tmp

	drop tmp
	}

	*Compute abnormal returns
	gen AbnormalReturnstt = Rtt - Rexpectedtt
	gen AbnormalReturnsttd = Rdtt - Rexpectedttd


}

keep ticker date panel_id estimation_window event_window event_time AbnormalReturns AbnormalReturnsd eventyear  R Rd

saveold Data_Event_Study_final_thin`thintrade'_est`estwindow'_evt`evtwindow'_control`controlevents'_ind`controlindustry'_`EVENT', replace
