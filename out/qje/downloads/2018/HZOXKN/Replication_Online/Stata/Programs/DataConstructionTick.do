clear 
clear mata
set memory 700m
set more off, perm


local dirdata "../Data_Orig/"
local dirworking "../IntermediateFiles/"

************************read ff electronic and ED electro and floor data (OLD)************************************
foreach name in fedfund_e euro_e euro_r {
	*insheet using "`dirsas'`name'/`name'short.txt", clear
	insheet using "`dirdata'`name'/`name'short.txt", clear
	*Convert date variable into stata date;
	gen date_daily = date(string(date,"%8.0f"), "YMD")
	format date_daily %td
	sort date_daily
	save `dirworking'`name'_raw, replace
	
	sort date_daily
	keep date_daily
	gen dup=1 if date_daily==date_daily[_n-1]
	drop if dup==1
	drop dup
	gen NextDate=date_daily[_n+1]
	format NextDate %td
	sort date_daily
	
	save `dirworking'`name'_businessday, replace
	
	merge date_daily using `dirworking'`name'_raw
	drop _merge
	
	*Convert contract delivery date into stata date
	*Add leading zeros
	gen str4 temp = string(contract_delivery,"%04.0f")
	*Arbitrarily set the day for contract delivery as the 28th of the month- doesn't matter since we only use the month;
	gen temp2 = "28" 
	egen temp3 = concat(temp temp2)
	gen contract_deliveryb = date(temp3, "YMD", 2060)
	format contract_deliveryb %td
	
	*Drop inessential variables
	drop temp* _freq_ tradenum
	
	label variable t_date TradingDate
	label variable date CalendarDate
	*Generate number of months ahead of delivery date;
	gen monthahead = mofd(contract_deliveryb) - mofd(date_daily) + 1
	
	*Create Fed Funds Futures dataset
	if "`name'" == "fedfund_e" {
		*Account for changes in the way that the Fed Fund Futures prices are defined
		gen fedfutp = 100- t_price/10000 if t_price>=100000
		replace fedfutp = 100- t_price/10 if t_price>100 & t_price<=1000
		replace fedfutp = 100- t_price if t_price<100

		*Only need Fed Fund Futures prices up to 5 months in advance
		keep if monthahead <=5
		
		*Calculate changes over the 1:05 to 1:35 period
		
		*temp0 is the first observation of the day but not equal to temp1 if exists
		*temp1 is the last observation before 1:05 
		*temp2 is the last observation before 1:35 happened bt 1:05 and 1:35
		*temp3 is the first observation after 1:35 happened aft 1:35 but is not the last observation of the day
		*temp4 is the last observation of the day happened after 1:35
		sort date contract_deliveryb hour minute
		gen temp0 = fedfutp if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )
		gen temp0hr = hour if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )		
		gen temp0min = minute if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )		
		gen temp1 = fedfutp if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )
		gen temp1hr = hour if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )		
		gen temp1min = minute if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )	
		gen temp2 = fedfutp if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )
		gen temp2hr = hour if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )		
		gen temp2min = minute if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )				
		gen temp3 = fedfutp if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )
		gen temp3hr = hour if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )		
		gen temp3min = minute if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )		
		gen temp4 = fedfutp if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )
		gen temp4hr = hour if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )		
		gen temp4min = minute if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )		
		
		bysort date contract_deliveryb: egen fedfutpfirst = mean(temp0)
		bysort date contract_deliveryb: egen fedfutpfirsthr = mean(temp0hr)
		bysort date contract_deliveryb: egen fedfutpfirstmin = mean(temp0min)
		
		bysort date contract_deliveryb: egen fedfutp1 = mean(temp1)
		bysort date contract_deliveryb: egen fedfutp1hr = mean(temp1hr)
		bysort date contract_deliveryb: egen fedfutp1min = mean(temp1min)
		
		bysort date contract_deliveryb: egen fedfutp2 = mean(temp2)
		bysort date contract_deliveryb: egen fedfutp2hr = mean(temp2hr)
		bysort date contract_deliveryb: egen fedfutp2min = mean(temp2min)
		
		bysort date contract_deliveryb: egen fedfutp3 = mean(temp3)
		bysort date contract_deliveryb: egen fedfutp3hr = mean(temp3hr)
		bysort date contract_deliveryb: egen fedfutp3min = mean(temp3min)
		
		bysort date contract_deliveryb: egen fedfutp4 = mean(temp4)
		bysort date contract_deliveryb: egen fedfutp4hr = mean(temp4hr)
		bysort date contract_deliveryb: egen fedfutp4min = mean(temp4min)
		
		drop temp*
		
		*fedfutpfirst is the 1st obs of the day, if temp0 does not exist, fedfutpfirst=temp1, etc. 
		replace fedfutpfirsthr = fedfutp1hr if fedfutpfirst==. & fedfutp1~=.
		replace fedfutpfirstmin = fedfutp1min if fedfutpfirst==. & fedfutp1~=.
		replace fedfutpfirst = fedfutp1 if fedfutpfirst==. & fedfutp1~=.
		
		replace fedfutpfirsthr = fedfutp2hr if fedfutpfirst==. & fedfutp2~=.
		replace fedfutpfirstmin = fedfutp2min if fedfutpfirst==. & fedfutp2~=.
		replace fedfutpfirst = fedfutp2 if fedfutpfirst==. & fedfutp2~=.
		
		replace fedfutpfirsthr = fedfutp3hr if fedfutpfirst==. & fedfutp3~=.
		replace fedfutpfirstmin = fedfutp3min if fedfutpfirst==. & fedfutp3~=.
		replace fedfutpfirst = fedfutp3 if fedfutpfirst==. & fedfutp3~=.
		
		replace fedfutpfirsthr = fedfutp4hr if fedfutpfirst==. & fedfutp4~=.
		replace fedfutpfirstmin = fedfutp4min if fedfutpfirst==. & fedfutp4~=.
		replace fedfutpfirst = fedfutp4 if fedfutpfirst==. & fedfutp4~=.

		*keep one observation per-day per-asset
		sort date contract_deliveryb hour minute
		bysort date: gen daydup=1 if contract_deliveryb==contract_deliveryb[_n-1]
		drop if daydup==1
		drop daydup
		
		sort contract_deliveryb date
		
		****************************************
		*Narrow/standard tick construction
		****************************************
		
		*If there was no trading between 1:05 and 1:35 then set the difference as 0.
		gen No2=1 if fedfutp2==. 
		replace No2=0 if No2==.
		
		gen timegap=0 if No2==1
		replace timegap=(fedfutp2hr-fedfutp1hr)*60 + fedfutp2min + 60 - fedfutp1min if No2==0
		
		gen d`name'_tick= fedfutp2 - fedfutp1
		replace d`name'_tick=0 if No2==1
		
		*if there is observation between 1305-1335 and the last observation before 13:05 is more than 6 hours earlier than fomc hour, set as missing. 
		replace d`name'_tick=. if fedfutp1hr<hourfomc-6 & No2==0

		****************************************
		*wide tick construction
		****************************************
		
		*construct the first observation traded after 13:35. 
		gen fedfut2wide=fedfutp3
		gen fedfut2widehr=fedfutp3hr
		gen fedfut2widemin=fedfutp3min
		
		replace fedfut2widehr=fedfutp4hr if fedfut2wide==. & fedfutp4~=.
		replace fedfut2widemin=fedfutp4min if fedfut2wide==. & fedfutp4~=.
		replace fedfut2wide=fedfutp4 if fedfut2wide==. & fedfutp4~=.
				
		sort contract_deliveryb date		
		*if there is no trading after 13:35, use the first trading of the next day, if it is before noon.
		gen usenextday1st=1 if fedfut2wide==. & NextDate==date_daily[_n+1] & contract_deliveryb==contract_deliveryb[_n+1] & fedfutpfirsthr[_n+1]<12
		replace fedfut2widehr=fedfutpfirsthr[_n+1] if usenextday1st==1
		replace fedfut2widemin=fedfutpfirstmin[_n+1] if usenextday1st==1
		replace fedfut2wide=fedfutpfirst[_n+1] if usenextday1st==1
	
		gen fedfut1wide=fedfutp1
		gen fedfut1widehr=fedfutp1hr
		gen fedfut1widemin=fedfutp1min
		
		*if the last observation before 13:05 is earlier than 6 hours ago, then set as missing.
		replace fedfut1widehr=. if fedfut1widehr<hourfomc-6
		
		gen timegapwide=(fedfut2widehr-fedfut1widehr)*60 + fedfut2widemin + 60 - fedfut1widemin if usenextday1st~=1
		replace timegapwide=(24- (fedfut1widehr+1))*60 - fedfut1widemin + fedfut2widehr*60+ fedfut2widemin if usenextday1st==1
		
		gen d`name'_tick_wide= fedfut2wide - fedfut1wide
		
		save `dirworking'`name'_tick_timegap, replace
		
		*save tick
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick monthahead 
		collapse d`name'_tick, by(date_daily monthahead)
		
		*Reshape dataset
		reshape wide d`name'_tick, i(date_daily) j(monthahead)
		
		save `dirworking'`name'_tick, replace
	
		*save tick_wide
		use `dirworking'`name'_tick_timegap, clear
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick_wide monthahead 
		collapse d`name'_tick_wide, by(date_daily monthahead)
		
		*Reshape dataset
		reshape wide d`name'_tick_wide, i(date_daily) j(monthahead)
		
		save `dirworking'`name'_tick_wide, replace
		
		}
	
		
*Create EuroDollar dataset
	if "`name'" == "euro_e" | "`name'" == "euro_r" {
		gen europ = 100- t_price
		
		*non-quarterly expiration contracts are only traded for the next little while after a given date. 
		*delete these contracts.
		gen delivery_month=month(contract_deliveryb)
		keep if delivery_month==3 | delivery_month==6 | delivery_month==9 | delivery_month==12
		drop delivery_month
		*Create variables for second, third and fourth "beginning" ED futures (see Q&A for the definition)
		*Note, I am going to approximate the expiration dates as the 15th of the month
		*It should really be the second London business day before the third Wednesday of the expiration month
		gen quarterahead = qofd(contract_deliveryb) - qofd(date_daily) + 1
		gen afterexp = cond(mod(month(date_daily), 3)==0 & day(date_daily)>15, 1, 0)				
		gen begquarter = quarterahead - afterexp 
		*drop if begquarter<=1 | begquarter>8
		drop if begquarter<1 | begquarter>8
		
		/*
		split t_time, p(":")
		destring  t_time1 t_time2 t_time3, replace
		drop hour minute
		rename t_time1 hour
		rename t_time2 minute
		rename t_time3 seconds
		*/
		
		*Calculate changes over the 1:05 to 1:35 period
		*temp0 is the first observation of the day but not equal to temp1 if exists
		*temp1 is the last observation before 1:05 
		*temp2 is the last observation before 1:35 happened bt 1:05 and 1:35
		*temp3 is the first observation after 1:35 happened aft 1:35 but is not the last observation of the day
		*temp4 is the last observation of the day happened after 1:35
		sort date contract_deliveryb hour minute
		gen temp0 = europ if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )
		gen temp0hr = hour if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )		
		gen temp0min = minute if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )		
		gen temp1 = europ if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )
		gen temp1hr = hour if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )		
		gen temp1min = minute if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )		
		gen temp2 = europ if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )
		gen temp2hr = hour if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )		
		gen temp2min = minute if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )		
		gen temp3 = europ if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )
		gen temp3hr = hour if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )		
		gen temp3min = minute if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )		
		gen temp4 = europ if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )
		gen temp4hr = hour if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )		
		gen temp4min = minute if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )		
		
		bysort date contract_deliveryb: egen europfirst = mean(temp0)
		bysort date contract_deliveryb: egen europfirsthr = mean(temp0hr)
		bysort date contract_deliveryb: egen europfirstmin = mean(temp0min)
		
		bysort date contract_deliveryb: egen europ1 = mean(temp1)
		bysort date contract_deliveryb: egen europ1hr = mean(temp1hr)
		bysort date contract_deliveryb: egen europ1min = mean(temp1min)
		
		bysort date contract_deliveryb: egen europ2 = mean(temp2)
		bysort date contract_deliveryb: egen europ2hr = mean(temp2hr)
		bysort date contract_deliveryb: egen europ2min = mean(temp2min)
		
		bysort date contract_deliveryb: egen europ3 = mean(temp3)
		bysort date contract_deliveryb: egen europ3hr = mean(temp3hr)
		bysort date contract_deliveryb: egen europ3min = mean(temp3min)		
		
		bysort date contract_deliveryb: egen europ4 = mean(temp4)
		bysort date contract_deliveryb: egen europ4hr = mean(temp4hr)
		bysort date contract_deliveryb: egen europ4min = mean(temp4min)
		drop temp*
		
		*europfirst is the 1st obs of the day, if temp0 does not exist, europfirst=temp1, etc. 
		
		replace europfirsthr=europ1hr if europfirst==. & europ1~=.
		replace europfirstmin=europ1min if europfirst==. & europ1~=.
		replace europfirst = europ1 if europfirst==. & europ1~=.
		
		replace europfirsthr=europ2hr if europfirst==. & europ2~=.
		replace europfirstmin=europ2min if europfirst==. & europ2~=.
		replace europfirst = europ2 if europfirst==. & europ2~=.
		
		replace europfirsthr=europ3hr if europfirst==. & europ3~=.
		replace europfirstmin=europ3min if europfirst==. & europ3~=.
		replace europfirst = europ3 if europfirst==. & europ3~=.
		
		replace europfirsthr=europ4hr if europfirst==. & europ4~=.
		replace europfirstmin=europ4min if europfirst==. & europ4~=.
		replace europfirst = europ4 if europfirst==. & europ4~=.
		
		*keep one observation per-day per-asset
		sort date contract_deliveryb t_time
		bysort date: gen daydup=1 if contract_deliveryb==contract_deliveryb[_n-1]
		drop if daydup==1
		drop daydup
		
		sort contract_deliveryb date		
		
		****************************************
		*Narrow/standard tick construction
		****************************************
		*If there was no trading between 1:05 and 1:35 then set the difference as 0.
		gen No2=1 if europ2==.
		replace No2=0 if No2==.
		
		gen timegap=0 if No2==1
		replace timegap=(europ2hr-europ1hr)*60 + europ2min + 60 - europ1min if No2==0
		
		gen d`name'_tick= europ2 - europ1
		replace d`name'_tick=0 if No2==1
		
		*if there is observation between 1305-1335 and the last observation before 13:05 is more than 6 hours earlier than fomc hour, set as missing. 
		replace d`name'_tick=. if europ1hr<hourfomc-6 & No2==0
		
		****************************************
		*wide tick construction
		****************************************
		*construct the last observation traded before 13:35. 
		gen euro2wide=europ3
		gen euro2widehr=europ3hr
		gen euro2widemin=europ3min
		
		replace euro2widehr=europ4hr if euro2wide==. & europ4~=.
		replace euro2widemin=europ4min if euro2wide==. & europ4~=.
		replace euro2wide=europ4 if euro2wide==. & europ4~=.
		
		sort contract_deliveryb date
		*if there is no trading after 13:35, use the first trading of the next day, if it is before noon.
		gen usenextday1st=1 if  euro2wide==. & NextDate==date_daily[_n+1] & contract_deliveryb==contract_deliveryb[_n+1] & europfirsthr[_n+1]<12
		replace euro2widehr=europfirsthr[_n+1] if usenextday1st==1
		replace euro2widemin=europfirstmin[_n+1] if usenextday1st==1
		replace euro2wide=europfirst[_n+1] if usenextday1st==1
			
		gen euro1wide=europ1
		gen euro1widehr=europ1hr
		gen euro1widemin=europ1min
		
		*if the last observation before 13:05 is earlier than 6 hours ago, then set as missing.
		replace euro1widehr=. if euro1widehr<hourfomc-6
		
		gen timegapwide=(euro2widehr-euro1widehr)*60 + euro2widemin + 60 - euro1widemin if usenextday1st~=1
		replace timegapwide=(24- (euro1widehr+1))*60 - euro1widemin + euro2widehr*60+ euro2widemin if usenextday1st==1
		
		gen d`name'_tick_wide= euro2wide - euro1wide
				
		save `dirworking'`name'_tick_timegap, replace
		
		*save tick
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick begquarter 
		collapse d`name'_tick, by(date_daily begquarter)
		
		*Reshape dataset
		reshape wide d`name'_tick, i(date_daily) j(begquarter)
		save `dirworking'`name'_tick, replace
		
		*save tick_wide
		
		use `dirworking'`name'_tick_timegap, clear
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick_wide begquarter 
		collapse d`name'_tick_wide, by(date_daily begquarter)
		
		*Reshape dataset
		reshape wide d`name'_tick_wide, i(date_daily) j(begquarter)
		save `dirworking'`name'_tick_wide, replace
		
	}
}
		
*TICK: Append together Eurodollar floor and electronic datasets
*I am going to use the EuroDollar electronic prices from 2005 and after since that seems to be when there start to be more non-zero observations in the elctronic vs. floor dataset
use `dirworking'euro_r_tick, clear
keep if year(date_daily)<2004
foreach num of numlist 1(1)8 {
	rename deuro_r_tick`num' deuro_tick`num'
	}
save `dirworking'temp, replace

use `dirworking'euro_e_tick, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)8 {
	rename deuro_e_tick`num' deuro_tick`num'
	}		
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990
save `dirworking'euro_tick, replace


*TICK_WIDE: Append together Eurodollar floor and electronic datasets
*I am going to use the EuroDollar electronic prices from 2005 and after since that seems to be when there start to be more non-zero observations in the elctronic vs. floor dataset
use `dirworking'euro_r_tick_wide, clear
keep if year(date_daily)<2004
foreach num of numlist 1(1)8 {
	rename deuro_r_tick_wide`num' deuro_tick_wide`num'
	}
save `dirworking'temp, replace

use `dirworking'euro_e_tick_wide, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)8 {
	rename deuro_e_tick_wide`num' deuro_tick_wide`num'
	}		
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990
save `dirworking'euro_tick_wide, replace

		
*TICK: Clean up Fed Funds Futures dataset (later we will also append the floor dataset)
use `dirworking'fedfund_e_tick, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)5 {
	rename dfedfund_e_tick`num' dfedfund_tick`num'
	}
save `dirworking'fedfund_e_tick, replace	


*TICK_WIDE: Clean up Fed Funds Futures dataset (later we will also append the floor dataset)
use `dirworking'fedfund_e_tick_wide, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)5 {
	rename dfedfund_e_tick_wide`num' dfedfund_tick_wide`num'
	}
save `dirworking'fedfund_e_tick_wide, replace	


************************read ff electronic and floor NEW data************************************
foreach name in fedfund_e2 fedfund_o{
	*insheet using "`dirsas'`name'/`name'short.txt", clear
	insheet using "`dirdata'`name'/`name'short.txt", clear

	rename price t_price
	format date %td
	rename date date_daily
	sort date_daily
	save `dirworking'`name'_raw, replace
	
	sort date_daily
	keep date_daily
	gen dup=1 if date_daily==date_daily[_n-1]
	drop if dup==1
	drop dup
	gen NextDate=date_daily[_n+1]
	format NextDate %td
	sort date_daily
	save `dirworking'`name'_businessday, replace
	
	merge date_daily using `dirworking'`name'_raw
	drop _merge
		
	gen contract_delivery=string(delivery)
	*Arbitrarily set the day for contract delivery as the 28th of the month- doesn't matter since we only use the month;
	gen temp = "28"
	egen temp2 = concat(contract_delivery temp)
	destring temp2, replace
	gen contract_deliveryb = date(string(temp2,"%8.0f"), "YMD")
	format contract_deliveryb %td
	drop temp* _freq_ tradenum

	*Generate number of months ahead of delivery date;
	gen monthahead = mofd(contract_deliveryb) - mofd(date_daily)+1
	
	*Create Fed Funds Futures dataset
	if "`name'" == "fedfund_e2" {
		*Account for changes in the way that the Fed Fund Futures prices are defined
		*Note: Shaowen identified these by looking at the data-- some dates from 2004Oct1 to 2004oct18 has price e.g. 0.0098
		replace t_price=t_price*10000 if t_price<1
		gen fedfutp = 100- t_price 
	}
		
	if "`name'" == "fedfund_o" {
		*8 observations have strange t_price, e.g. 17jul2000 price=0.651, 24apr2003 p=0.005
		*list date_daily t_price if t_price<1
		drop if t_price<1
		gen fedfutp = 100- t_price
	}
	
	*Only need Fed Fund Futures prices up to 5 months in advance
	keep if monthahead <=5
		
	*Calculate changes over the 1:05 to 1:35 period
	
	*temp0 is the first observation of the day but not equal to temp1 if exists
	*temp1 is the last observation before 1:05 
	*temp2 is the last observation before 1:35 happened bt 1:05 and 1:35
	*temp3 is the first observation after 1:35 happened aft 1:35 but is not the last observation of the day
	*temp4 is the last observation of the day happened after 1:35
	sort date contract_deliveryb hour minute second
	gen temp0 = fedfutp if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )
	gen temp0hr = hour if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )		
	gen temp0min = minute if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==0 )
	gen temp1 = fedfutp if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )
	gen temp1hr = hour if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )		
	gen temp1min = minute if (indaft_pre10min == 0 & indaft_aft20min==0 & lastobswindow==1 )
	gen temp2 = fedfutp if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )
	gen temp2hr = hour if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )		
	gen temp2min = minute if (indaft_pre10min == 1 & indaft_aft20min==0 & lastobswindow==1 )
	gen temp3 = fedfutp if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )
	gen temp3hr = hour if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )		
	gen temp3min = minute if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==0 )		
	gen temp4 = fedfutp if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )
	gen temp4hr = hour if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )		
	gen temp4min = minute if (indaft_pre10min == 1 & indaft_aft20min==1 & lastobswindow==1 )
		
	bysort date contract_deliveryb: egen fedfutpfirst = mean(temp0)
	bysort date contract_deliveryb: egen fedfutpfirsthr = mean(temp0hr)
	bysort date contract_deliveryb: egen fedfutpfirstmin = mean(temp0min)
	
	bysort date contract_deliveryb: egen fedfutp1 = mean(temp1)
	bysort date contract_deliveryb: egen fedfutp1hr = mean(temp1hr)
	bysort date contract_deliveryb: egen fedfutp1min = mean(temp1min)
		
	bysort date contract_deliveryb: egen fedfutp2 = mean(temp2)
	bysort date contract_deliveryb: egen fedfutp2hr = mean(temp2hr)
	bysort date contract_deliveryb: egen fedfutp2min = mean(temp2min)
		
	bysort date contract_deliveryb: egen fedfutp3 = mean(temp3)
	bysort date contract_deliveryb: egen fedfutp3hr = mean(temp3hr)
	bysort date contract_deliveryb: egen fedfutp3min = mean(temp3min)
		
	bysort date contract_deliveryb: egen fedfutp4 = mean(temp4)
	bysort date contract_deliveryb: egen fedfutp4hr = mean(temp4hr)
	bysort date contract_deliveryb: egen fedfutp4min = mean(temp4min)
	
	drop temp*
		
	*fedfutpfirst is the 1st obs of the day, if temp0 does not exist, fedfutpfirst=temp1, etc. 
	replace fedfutpfirsthr = fedfutp1hr if fedfutpfirst==. & fedfutp1~=.
	replace fedfutpfirstmin = fedfutp1min if fedfutpfirst==. & fedfutp1~=.	
	replace fedfutpfirst = fedfutp1 if fedfutpfirst==. & fedfutp1~=.
	
	replace fedfutpfirsthr = fedfutp2hr if fedfutpfirst==. & fedfutp2~=.
	replace fedfutpfirstmin = fedfutp2min if fedfutpfirst==. & fedfutp2~=.	
	replace fedfutpfirst = fedfutp2 if fedfutpfirst==. & fedfutp2~=.
	
	replace fedfutpfirsthr = fedfutp3hr if fedfutpfirst==. & fedfutp3~=.
	replace fedfutpfirstmin = fedfutp3min if fedfutpfirst==. & fedfutp3~=.	
	replace fedfutpfirst = fedfutp3 if fedfutpfirst==. & fedfutp3~=.
	
	replace fedfutpfirsthr = fedfutp4hr if fedfutpfirst==. & fedfutp4~=.
	replace fedfutpfirstmin = fedfutp4min if fedfutpfirst==. & fedfutp4~=.	
	replace fedfutpfirst = fedfutp4 if fedfutpfirst==. & fedfutp4~=.
	
	*keep one observation per-day per-asset
	sort date contract_deliveryb hour minute
	bysort date: gen daydup=1 if contract_deliveryb==contract_deliveryb[_n-1]
	drop if daydup==1
	drop daydup	

	sort contract_deliveryb date
	****************************************
	*Narrow/standard tick construction
	****************************************
		
	*If there was no trading between 1:05 and 1:35 then set the difference as 0.
	gen No2=1 if fedfutp2==. 
	replace No2=0 if No2==.
		
	gen timegap=0 if No2==1
	replace timegap=(fedfutp2hr-fedfutp1hr)*60 + fedfutp2min + 60 - fedfutp1min if No2==0
		
	gen d`name'_tick= fedfutp2 - fedfutp1
	replace d`name'_tick=0 if No2==1
		
	*if there is observation between 1305-1335 and the last observation before 13:05 is more than 6 hours earlier than fomc hour, set as missing. 
	replace d`name'_tick=. if fedfutp1hr<hourfomc-6 & No2==0
		

	****************************************
	*wide tick construction
	****************************************
		
	*construct the first observation traded after 13:35. 
	gen fedfut2wide=fedfutp3
	gen fedfut2widehr=fedfutp3hr
	gen fedfut2widemin=fedfutp3min
		
	replace fedfut2widehr=fedfutp4hr if fedfut2wide==. & fedfutp4~=.
	replace fedfut2widemin=fedfutp4min if fedfut2wide==. & fedfutp4~=.
	replace fedfut2wide=fedfutp4 if fedfut2wide==. & fedfutp4~=.
				
	sort contract_deliveryb date		
	*if there is no trading after 13:35, use the first trading of the next day, if it is before noon.
	gen usenextday1st=1 if fedfut2wide==. & NextDate==date_daily[_n+1] & contract_deliveryb==contract_deliveryb[_n+1] & fedfutpfirsthr[_n+1]<12
	replace fedfut2widehr=fedfutpfirsthr[_n+1] if usenextday1st==1
	replace fedfut2widemin=fedfutpfirstmin[_n+1] if usenextday1st==1
	replace fedfut2wide=fedfutpfirst[_n+1] if usenextday1st==1
	
	gen fedfut1wide=fedfutp1
	gen fedfut1widehr=fedfutp1hr
	gen fedfut1widemin=fedfutp1min
		
	*if the last observation before 13:05 is earlier than 6 hours ago, then set as missing.
	replace fedfut1widehr=. if fedfut1widehr<hourfomc-6
		
	gen timegapwide=(fedfut2widehr-fedfut1widehr)*60 + fedfut2widemin + 60 - fedfut1widemin if usenextday1st~=1
	replace timegapwide=(24- (fedfut1widehr+1))*60 - fedfut1widemin + fedfut2widehr*60+ fedfut2widemin if usenextday1st==1
		
	gen d`name'_tick_wide= fedfut2wide - fedfut1wide
		
	save `dirworking'`name'_tick_timegap, replace
	
	
	*save tick
	*Keep one observation per day and contract delivery day
	keep date_daily d`name'_tick monthahead 
	collapse d`name'_tick, by(date_daily monthahead)
		
	*Reshape dataset
	reshape wide d`name'_tick, i(date_daily) j(monthahead)
		
	save `dirworking'`name'_tick, replace
		
	*save tick_wide
	use `dirworking'`name'_tick_timegap, clear
	*Keep one observation per day and contract delivery day
	keep date_daily d`name'_tick_wide monthahead 
	collapse d`name'_tick_wide, by(date_daily monthahead)
		
	*Reshape dataset
	reshape wide d`name'_tick_wide, i(date_daily) j(monthahead)
		
	save `dirworking'`name'_tick_wide, replace
}


**********************Merge fedfund e and o data**************************************
*Shaowen choose 2004 jul as the cut-off year, follow eurodollar. Emi choose 2005 for ED by trading volumn, but there is no vol for ff new data. 	

*merge ffr_tick
use `dirworking'fedfund_o_tick
drop if year(date_daily)>2004 
drop if year(date_daily)==2004 & month(date_daily)>=7
foreach num of numlist 1(1)5 {
	rename dfedfund_o_tick`num' dfedfund_tick`num'
	}		
save `dirworking'temp, replace

use `dirworking'fedfund_e_tick
drop if year(date_daily)<2004
drop if year(date_daily)==2004 & month(date_daily)<7
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990

save `dirworking'fedfund_tick, replace

*merge ffr_tick_wide
use `dirworking'fedfund_o_tick_wide
drop if year(date_daily)>2004 
drop if year(date_daily)==2004 & month(date_daily)>=7
foreach num of numlist 1(1)5 {
	rename dfedfund_o_tick_wide`num' dfedfund_tick_wide`num'
	}		
save `dirworking'temp, replace

use `dirworking'fedfund_e_tick_wide
drop if year(date_daily)<2004
drop if year(date_daily)==2004 & month(date_daily)<7
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990

save `dirworking'fedfund_tick_wide, replace







************************************************************************************************
*************Earlier Tick (12:05 + 12:35 window)**************
************************************************************************************************




foreach name in fedfund_e euro_e euro_r {
	*insheet using "`dirsas'`name'/`name'shorte.txt", clear
	insheet using "`dirdata'`name'/`name'shorte.txt", clear

	*Convert date variable into stata date;
	gen date_daily = date(string(date,"%8.0f"), "YMD")
	format date_daily %td
	sort date_daily
	save `dirworking'`name'_rawe, replace
	
	sort date_daily
	keep date_daily
	gen dup=1 if date_daily==date_daily[_n-1]
	drop if dup==1
	drop dup
	gen NextDate=date_daily[_n+1]
	format NextDate %td
	sort date_daily
	save `dirworking'`name'_businessday, replace
	
	merge date_daily using `dirworking'`name'_rawe
	drop _merge
	
	*Convert contract delivery date into stata date
	*Add leading zeros
	gen str4 temp = string(contract_delivery,"%04.0f")
	*Arbitrarily set the day for contract delivery as the 28th of the month- doesn't matter since we only use the month;
	gen temp2 = "28" 
	egen temp3 = concat(temp temp2)
	gen contract_deliveryb = date(temp3, "YMD", 2060)
	format contract_deliveryb %td
	
	*Drop inessential variables
	drop temp* _freq_ tradenum

	*Generate number of months ahead of delivery date;
	gen monthahead = mofd(contract_deliveryb) - mofd(date_daily) + 1
	
	*Create Fed Funds Futures dataset
	if "`name'" == "fedfund_e" {
		*Account for changes in the way that the Fed Fund Futures prices are defined
		gen fedfutp = 100- t_price/10000 if t_price>=100000
		replace fedfutp = 100- t_price/10 if t_price>100 & t_price<=1000
		replace fedfutp = 100- t_price if t_price<100

		*Only need Fed Fund Futures prices up to 5 months in advance
		keep if monthahead <=5
		
		*Calculate changes over the 1:05 to 1:35 period
		
		*temp0 is the first observation of the day but not equal to temp1 if exists
		*temp1 is the last observation before 1:05 
		*temp2 is the last observation before 1:35 happened bt 1:05 and 1:35
		*temp3 is the first observation after 1:35 happened aft 1:35 but is not the last observation of the day
		*temp4 is the last observation of the day happened after 1:35
		sort date contract_deliveryb hour minute
		gen temp0 = fedfutp if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )
		gen temp0hr = hour if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )		
		gen temp0min = minute if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )		
		gen temp1 = fedfutp if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )
		gen temp1hr = hour if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )		
		gen temp1min = minute if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )	
		gen temp2 = fedfutp if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )
		gen temp2hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )		
		gen temp2min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )				
		gen temp3 = fedfutp if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )
		gen temp3hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )		
		gen temp3min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )		
		gen temp4 = fedfutp if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )
		gen temp4hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )		
		gen temp4min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )		
		
		bysort date contract_deliveryb: egen fedfutpfirst = mean(temp0)
		bysort date contract_deliveryb: egen fedfutpfirsthr = mean(temp0hr)
		bysort date contract_deliveryb: egen fedfutpfirstmin = mean(temp0min)
		
		bysort date contract_deliveryb: egen fedfutp1 = mean(temp1)
		bysort date contract_deliveryb: egen fedfutp1hr = mean(temp1hr)
		bysort date contract_deliveryb: egen fedfutp1min = mean(temp1min)
		
		bysort date contract_deliveryb: egen fedfutp2 = mean(temp2)
		bysort date contract_deliveryb: egen fedfutp2hr = mean(temp2hr)
		bysort date contract_deliveryb: egen fedfutp2min = mean(temp2min)
		
		bysort date contract_deliveryb: egen fedfutp3 = mean(temp3)
		bysort date contract_deliveryb: egen fedfutp3hr = mean(temp3hr)
		bysort date contract_deliveryb: egen fedfutp3min = mean(temp3min)
		
		bysort date contract_deliveryb: egen fedfutp4 = mean(temp4)
		bysort date contract_deliveryb: egen fedfutp4hr = mean(temp4hr)
		bysort date contract_deliveryb: egen fedfutp4min = mean(temp4min)
		
		drop temp*
		
		*fedfutpfirst is the 1st obs of the day, if temp0 does not exist, fedfutpfirst=temp1, etc. 
		replace fedfutpfirsthr = fedfutp1hr if fedfutpfirst==. & fedfutp1~=.
		replace fedfutpfirstmin = fedfutp1min if fedfutpfirst==. & fedfutp1~=.
		replace fedfutpfirst = fedfutp1 if fedfutpfirst==. & fedfutp1~=.
		
		replace fedfutpfirsthr = fedfutp2hr if fedfutpfirst==. & fedfutp2~=.
		replace fedfutpfirstmin = fedfutp2min if fedfutpfirst==. & fedfutp2~=.
		replace fedfutpfirst = fedfutp2 if fedfutpfirst==. & fedfutp2~=.
		
		replace fedfutpfirsthr = fedfutp3hr if fedfutpfirst==. & fedfutp3~=.
		replace fedfutpfirstmin = fedfutp3min if fedfutpfirst==. & fedfutp3~=.
		replace fedfutpfirst = fedfutp3 if fedfutpfirst==. & fedfutp3~=.
		
		replace fedfutpfirsthr = fedfutp4hr if fedfutpfirst==. & fedfutp4~=.
		replace fedfutpfirstmin = fedfutp4min if fedfutpfirst==. & fedfutp4~=.
		replace fedfutpfirst = fedfutp4 if fedfutpfirst==. & fedfutp4~=.

		*keep one observation per-day per-asset
		sort date contract_deliveryb hour minute
		bysort date: gen daydup=1 if contract_deliveryb==contract_deliveryb[_n-1]
		drop if daydup==1
		drop daydup
		
		sort contract_deliveryb date
		
		****************************************
		*Narrow/standard tick construction
		****************************************
		
		*If there was no trading between 1:05 and 1:35 then set the difference as 0.
		gen No2=1 if fedfutp2==.
		replace No2=0 if No2==.
		
		gen timegap=0 if No2==1
		replace timegap=(fedfutp2hr-fedfutp1hr)*60 + fedfutp2min + 60 - fedfutp1min if No2==0
		
		gen d`name'_tick_early= fedfutp2 - fedfutp1
		replace d`name'_tick_early=0 if No2==1
		
		*if there is observation between 1305-1335 and the last observation before 13:05 is more than 6 hours earlier than fomc hour, set as missing. 
		replace d`name'_tick_early=. if fedfutp1hr<hourfomc-6 & No2==0
		

		****************************************
		*wide tick construction
		****************************************
		
		*construct the first observation traded after 13:35. 
		gen fedfut2wide=fedfutp3
		gen fedfut2widehr=fedfutp3hr
		gen fedfut2widemin=fedfutp3min
		
		replace fedfut2widehr=fedfutp4hr if fedfut2wide==. & fedfutp4~=.
		replace fedfut2widemin=fedfutp4min if fedfut2wide==. & fedfutp4~=.
		replace fedfut2wide=fedfutp4 if fedfut2wide==. & fedfutp4~=.
				
		sort contract_deliveryb date		
		*if there is no trading after 13:35, use the first trading of the next day, if it is before noon.
		gen usenextday1st=1 if fedfut2wide==. & NextDate==date_daily[_n+1] & contract_deliveryb==contract_deliveryb[_n+1] & fedfutpfirsthr[_n+1]<12
		replace fedfut2widehr=fedfutpfirsthr[_n+1] if usenextday1st==1
		replace fedfut2widemin=fedfutpfirstmin[_n+1] if usenextday1st==1
		replace fedfut2wide=fedfutpfirst[_n+1] if usenextday1st==1
	
		gen fedfut1wide=fedfutp1
		gen fedfut1widehr=fedfutp1hr
		gen fedfut1widemin=fedfutp1min
		
		*if the last observation before 13:05 is earlier than 6 hours ago, then set as missing.
		replace fedfut1widehr=. if fedfut1widehr<hourfomc-6
		
		gen timegapwide=(fedfut2widehr-fedfut1widehr)*60 + fedfut2widemin + 60 - fedfut1widemin if usenextday1st~=1
		replace timegapwide=(24- (fedfut1widehr+1))*60 - fedfut1widemin + fedfut2widehr*60+ fedfut2widemin if usenextday1st==1
		
		gen d`name'_tick_wide_early= fedfut2wide - fedfut1wide
		
		save `dirworking'`name'_tick_early_timegap, replace
		
		*save tick
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick_early monthahead 
		collapse d`name'_tick_early, by(date_daily monthahead)
		
		*Reshape dataset
		reshape wide d`name'_tick_early, i(date_daily) j(monthahead)
		
		save `dirworking'`name'_tick_early, replace
		
		*save tick_wide
		use `dirworking'`name'_tick_early_timegap, clear
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick_wide_early monthahead 
		collapse d`name'_tick_wide_early, by(date_daily monthahead)
		
		*Reshape dataset
		reshape wide d`name'_tick_wide_early, i(date_daily) j(monthahead)
		
		save `dirworking'`name'_tick_wide_early, replace		
		}
	
		
*Create EuroDollar dataset
	if "`name'" == "euro_e" | "`name'" == "euro_r" {
		gen europ = 100- t_price
		
		*non-quarterly expiration contracts are only traded for the next little while after a given date. 
		*delete these contracts.
		gen delivery_month=month(contract_deliveryb)
		keep if delivery_month==3 | delivery_month==6 | delivery_month==9 | delivery_month==12
		drop delivery_month
		
		*Create variables for second, third and fourth "beginning" ED futures (see Q&A for the definition)
		*Note, I am going to approximate the expiration dates as the 15th of the month
		*It should really be the second London business day before the third Wednesday of the expiration month
		gen quarterahead = qofd(contract_deliveryb) - qofd(date_daily) + 1
		gen afterexp = cond(mod(month(date_daily), 3)==0 & day(date_daily)>15, 1, 0)				
		gen begquarter = quarterahead - afterexp 
		*drop if begquarter<=1 | begquarter>8
		drop if begquarter<1 | begquarter>8
		
		/*
		split t_time, p(":")
		destring  t_time1 t_time2 t_time3, replace
		drop hour minute
		rename t_time1 hour
		rename t_time2 minute
		rename t_time3 seconds
		*/
		
		*Calculate changes over the 1:05 to 1:35 period
		*temp0 is the first observation of the day but not equal to temp1 if exists
		*temp1 is the last observation before 1:05 
		*temp2 is the last observation before 1:35 happened bt 1:05 and 1:35
		*temp3 is the first observation after 1:35 happened aft 1:35 but is not the last observation of the day
		*temp4 is the last observation of the day happened after 1:35
		sort date contract_deliveryb hour minute
		gen temp0 = europ if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )
		gen temp0hr = hour if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )		
		gen temp0min = minute if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )		
		gen temp1 = europ if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )
		gen temp1hr = hour if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )		
		gen temp1min = minute if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )		
		gen temp2 = europ if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )
		gen temp2hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )		
		gen temp2min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )		
		gen temp3 = europ if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )
		gen temp3hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )		
		gen temp3min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )		
		gen temp4 = europ if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )
		gen temp4hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )		
		gen temp4min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )		
		
		bysort date contract_deliveryb: egen europfirst = mean(temp0)
		bysort date contract_deliveryb: egen europfirsthr = mean(temp0hr)
		bysort date contract_deliveryb: egen europfirstmin = mean(temp0min)
		
		bysort date contract_deliveryb: egen europ1 = mean(temp1)
		bysort date contract_deliveryb: egen europ1hr = mean(temp1hr)
		bysort date contract_deliveryb: egen europ1min = mean(temp1min)
		
		bysort date contract_deliveryb: egen europ2 = mean(temp2)
		bysort date contract_deliveryb: egen europ2hr = mean(temp2hr)
		bysort date contract_deliveryb: egen europ2min = mean(temp2min)
		
		bysort date contract_deliveryb: egen europ3 = mean(temp3)
		bysort date contract_deliveryb: egen europ3hr = mean(temp3hr)
		bysort date contract_deliveryb: egen europ3min = mean(temp3min)		
		
		bysort date contract_deliveryb: egen europ4 = mean(temp4)
		bysort date contract_deliveryb: egen europ4hr = mean(temp4hr)
		bysort date contract_deliveryb: egen europ4min = mean(temp4min)
		drop temp*
		
		*europfirst is the 1st obs of the day, if temp0 does not exist, europfirst=temp1, etc. 
		
		replace europfirsthr=europ1hr if europfirst==. & europ1~=.
		replace europfirstmin=europ1min if europfirst==. & europ1~=.
		replace europfirst = europ1 if europfirst==. & europ1~=.
		
		replace europfirsthr=europ2hr if europfirst==. & europ2~=.
		replace europfirstmin=europ2min if europfirst==. & europ2~=.
		replace europfirst = europ2 if europfirst==. & europ2~=.
		
		replace europfirsthr=europ3hr if europfirst==. & europ3~=.
		replace europfirstmin=europ3min if europfirst==. & europ3~=.
		replace europfirst = europ3 if europfirst==. & europ3~=.
		
		replace europfirsthr=europ4hr if europfirst==. & europ4~=.
		replace europfirstmin=europ4min if europfirst==. & europ4~=.
		replace europfirst = europ4 if europfirst==. & europ4~=.
		
		*keep one observation per-day per-asset
		sort date contract_deliveryb t_time
		bysort date: gen daydup=1 if contract_deliveryb==contract_deliveryb[_n-1]
		drop if daydup==1
		drop daydup
		
		sort contract_deliveryb date		
		
		****************************************
		*Narrow/standard tick construction
		****************************************
		*If there was no trading between 1:05 and 1:35 then set the difference as 0.
		gen No2=1 if europ2==. 
		replace No2=0 if No2==.
		
		gen timegap=0 if No2==1
		replace timegap=(europ2hr-europ1hr)*60 + europ2min + 60 - europ1min if No2==0
		
		gen d`name'_tick_early= europ2 - europ1
		replace d`name'_tick_early=0 if No2==1
		
		*if there is observation between 1305-1335 and the last observation before 13:05 is more than 6 hours earlier than fomc hour, set as missing. 
		replace d`name'_tick_early=. if europ1hr<hourfomc-6 & No2==0
		
		****************************************
		*wide tick construction
		****************************************
		*construct the last observation traded before 13:35. 
		gen euro2wide=europ3
		gen euro2widehr=europ3hr
		gen euro2widemin=europ3min
		
		replace euro2widehr=europ4hr if euro2wide==. & europ4~=.
		replace euro2widemin=europ4min if euro2wide==. & europ4~=.
		replace euro2wide=europ4 if euro2wide==. & europ4~=.
		
		sort contract_deliveryb date
		*if there is no trading after 13:35, use the first trading of the next day, if it is before noon.
		gen usenextday1st=1 if  euro2wide==. & NextDate==date_daily[_n+1] & contract_deliveryb==contract_deliveryb[_n+1] & europfirsthr[_n+1]<12
		replace euro2widehr=europfirsthr[_n+1] if usenextday1st==1
		replace euro2widemin=europfirstmin[_n+1] if usenextday1st==1
		replace euro2wide=europfirst[_n+1] if usenextday1st==1
			
		gen euro1wide=europ1
		gen euro1widehr=europ1hr
		gen euro1widemin=europ1min
		
		*if the last observation before 13:05 is earlier than 6 hours ago, then set as missing.
		replace euro1widehr=. if euro1widehr<hourfomc-6
		
		gen timegapwide=(euro2widehr-euro1widehr)*60 + euro2widemin + 60 - euro1widemin if usenextday1st~=1
		replace timegapwide=(24- (euro1widehr+1))*60 - euro1widemin + euro2widehr*60+ euro2widemin if usenextday1st==1
		
		gen d`name'_tick_wide_early= euro2wide - euro1wide
				
		save `dirworking'`name'_tick_early_timegap, replace
		
		*save tick
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick_early begquarter 
		collapse d`name'_tick_early, by(date_daily begquarter)
		
		*Reshape dataset
		reshape wide d`name'_tick_early, i(date_daily) j(begquarter)
		save `dirworking'`name'_tick_early, replace
		
		*save tick_wide
		use `dirworking'`name'_tick_early_timegap, clear
		*Keep one observation per day and contract delivery day
		keep date_daily d`name'_tick_wide_early begquarter 
		collapse d`name'_tick_wide_early, by(date_daily begquarter)
		
		*Reshape dataset
		reshape wide d`name'_tick_wide_early, i(date_daily) j(begquarter)
		save `dirworking'`name'_tick_wide_early, replace
		
	}
}
		
*TICK: Append together Eurodollar floor and electronic datasets
*I am going to use the EuroDollar electronic prices from 2005 and after since that seems to be when there start to be more non-zero observations in the elctronic vs. floor dataset
use `dirworking'euro_r_tick_early, clear
keep if year(date_daily)<2004
foreach num of numlist 1(1)8 {
	rename deuro_r_tick_early`num' deuro_tick_early`num'
	}
save `dirworking'temp, replace

use `dirworking'euro_e_tick_early, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)8 {
	rename deuro_e_tick_early`num' deuro_tick_early`num'
	}		
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990
save `dirworking'euro_tick_early, replace


*TICK_WIDE: Append together Eurodollar floor and electronic datasets
*I am going to use the EuroDollar electronic prices from 2005 and after since that seems to be when there start to be more non-zero observations in the elctronic vs. floor dataset
use `dirworking'euro_r_tick_wide_early, clear
keep if year(date_daily)<2004
foreach num of numlist 1(1)8 {
	rename deuro_r_tick_wide_early`num' deuro_tick_wide_early`num'
	}
save `dirworking'temp, replace

use `dirworking'euro_e_tick_wide_early, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)8 {
	rename deuro_e_tick_wide_early`num' deuro_tick_wide_early`num'
	}		
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990
save `dirworking'euro_tick_wide_early, replace

		
*TICK: Clean up Fed Funds Futures dataset (later we will also append the floor dataset)
use `dirworking'fedfund_e_tick_early, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)5 {
	rename dfedfund_e_tick_early`num' dfedfund_tick_early`num'
	}
save `dirworking'fedfund_e_tick_early, replace	


*TICK_WIDE: Clean up Fed Funds Futures dataset (later we will also append the floor dataset)
use `dirworking'fedfund_e_tick_wide_early, clear
keep if year(date_daily)>=2004
foreach num of numlist 1(1)5 {
	rename dfedfund_e_tick_wide_early`num' dfedfund_tick_wide_early`num'
	}
save `dirworking'fedfund_e_tick_wide_early, replace	


************************read ff electronic and floor NEW data************************************
foreach name in fedfund_e2 fedfund_o{
	*insheet using "`dirsas'`name'/`name'shorte.txt", clear
	insheet using "`dirdata'`name'/`name'shorte.txt", clear

	rename price t_price
	format date %td
	rename date date_daily
	sort date_daily
	save `dirworking'`name'_rawe, replace
	
	sort date_daily
	keep date_daily
	gen dup=1 if date_daily==date_daily[_n-1]
	drop if dup==1
	drop dup
	gen NextDate=date_daily[_n+1]
	format NextDate %td
	sort date_daily
	save `dirworking'`name'_businessday, replace
	
	merge date_daily using `dirworking'`name'_rawe
	drop _merge
		
	gen contract_delivery=string(delivery)
	*Arbitrarily set the day for contract delivery as the 28th of the month- doesn't matter since we only use the month;
	gen temp = "28"
	egen temp2 = concat(contract_delivery temp)
	destring temp2, replace
	gen contract_deliveryb = date(string(temp2,"%8.0f"), "YMD")
	format contract_deliveryb %td
	
	drop temp* _freq_ tradenum

	*Generate number of months ahead of delivery date;
	gen monthahead = mofd(contract_deliveryb) - mofd(date_daily)+1
	
	*Create Fed Funds Futures dataset
	if "`name'" == "fedfund_e2" {
		*Account for changes in the way that the Fed Fund Futures prices are defined
		*Note: Shaowen identified these by looking at the data-- some dates from 2004Oct1 to 2004oct18 has price e.g. 0.0098
		replace t_price=t_price*10000 if t_price<1
		gen fedfutp = 100- t_price 
	}
		
	if "`name'" == "fedfund_o" {
		*8 observations have strange t_price, e.g. 17jul2000 price=0.651, 24apr2003 p=0.005
		*list date_daily t_price if t_price<1
		drop if t_price<1
		gen fedfutp = 100- t_price
	}
	
	*Only need Fed Fund Futures prices up to 5 months in advance
	keep if monthahead <=5
		
	*Calculate changes over the 1:05 to 1:35 period
	
	*temp0 is the first observation of the day but not equal to temp1 if exists
	*temp1 is the last observation before 1:05 
	*temp2 is the last observation before 1:35 happened bt 1:05 and 1:35
	*temp3 is the first observation after 1:35 happened aft 1:35 but is not the last observation of the day
	*temp4 is the last observation of the day happened after 1:35
	sort date contract_deliveryb hour minute second
	gen temp0 = fedfutp if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )
	gen temp0hr = hour if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )		
	gen temp0min = minute if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==0 )
	gen temp1 = fedfutp if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )
	gen temp1hr = hour if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )		
	gen temp1min = minute if (eindaft_pre10min == 0 & eindaft_aft20min==0 & lastobswindow==1 )
	gen temp2 = fedfutp if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )
	gen temp2hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )		
	gen temp2min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==0 & lastobswindow==1 )
	gen temp3 = fedfutp if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )
	gen temp3hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )		
	gen temp3min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==0 )		
	gen temp4 = fedfutp if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )
	gen temp4hr = hour if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )		
	gen temp4min = minute if (eindaft_pre10min == 1 & eindaft_aft20min==1 & lastobswindow==1 )
		
	bysort date contract_deliveryb: egen fedfutpfirst = mean(temp0)
	bysort date contract_deliveryb: egen fedfutpfirsthr = mean(temp0hr)
	bysort date contract_deliveryb: egen fedfutpfirstmin = mean(temp0min)
	
	bysort date contract_deliveryb: egen fedfutp1 = mean(temp1)
	bysort date contract_deliveryb: egen fedfutp1hr = mean(temp1hr)
	bysort date contract_deliveryb: egen fedfutp1min = mean(temp1min)
		
	bysort date contract_deliveryb: egen fedfutp2 = mean(temp2)
	bysort date contract_deliveryb: egen fedfutp2hr = mean(temp2hr)
	bysort date contract_deliveryb: egen fedfutp2min = mean(temp2min)
		
	bysort date contract_deliveryb: egen fedfutp3 = mean(temp3)
	bysort date contract_deliveryb: egen fedfutp3hr = mean(temp3hr)
	bysort date contract_deliveryb: egen fedfutp3min = mean(temp3min)
		
	bysort date contract_deliveryb: egen fedfutp4 = mean(temp4)
	bysort date contract_deliveryb: egen fedfutp4hr = mean(temp4hr)
	bysort date contract_deliveryb: egen fedfutp4min = mean(temp4min)
	
	drop temp*
		
	*fedfutpfirst is the 1st obs of the day, if temp0 does not exist, fedfutpfirst=temp1, etc. 
	replace fedfutpfirsthr = fedfutp1hr if fedfutpfirst==. & fedfutp1~=.
	replace fedfutpfirstmin = fedfutp1min if fedfutpfirst==. & fedfutp1~=.	
	replace fedfutpfirst = fedfutp1 if fedfutpfirst==. & fedfutp1~=.
	
	replace fedfutpfirsthr = fedfutp2hr if fedfutpfirst==. & fedfutp2~=.
	replace fedfutpfirstmin = fedfutp2min if fedfutpfirst==. & fedfutp2~=.	
	replace fedfutpfirst = fedfutp2 if fedfutpfirst==. & fedfutp2~=.
	
	replace fedfutpfirsthr = fedfutp3hr if fedfutpfirst==. & fedfutp3~=.
	replace fedfutpfirstmin = fedfutp3min if fedfutpfirst==. & fedfutp3~=.	
	replace fedfutpfirst = fedfutp3 if fedfutpfirst==. & fedfutp3~=.
	
	replace fedfutpfirsthr = fedfutp4hr if fedfutpfirst==. & fedfutp4~=.
	replace fedfutpfirstmin = fedfutp4min if fedfutpfirst==. & fedfutp4~=.	
	replace fedfutpfirst = fedfutp4 if fedfutpfirst==. & fedfutp4~=.
	
	*keep one observation per-day per-asset
	sort date contract_deliveryb hour minute
	bysort date: gen daydup=1 if contract_deliveryb==contract_deliveryb[_n-1]
	drop if daydup==1
	drop daydup	

	sort contract_deliveryb date
	****************************************
	*Narrow/standard tick construction
	****************************************
		
	*If there was no trading between 1:05 and 1:35 then set the difference as 0.
	gen No2=1 if fedfutp2==.
	replace No2=0 if No2==.
		
	gen timegap=0 if No2==1
	replace timegap=(fedfutp2hr-fedfutp1hr)*60 + fedfutp2min + 60 - fedfutp1min if No2==0
		
	gen d`name'_tick_early= fedfutp2 - fedfutp1
	replace d`name'_tick_early=0 if No2==1
		
	*if there is observation between 1305-1335 and the last observation before 13:05 is more than 6 hours earlier than fomc hour, set as missing. 
	replace d`name'_tick_early=. if fedfutp1hr<hourfomc-6 & No2==0
		

	****************************************
	*wide tick construction
	****************************************
		
	*construct the first observation traded after 13:35. 
	gen fedfut2wide=fedfutp3
	gen fedfut2widehr=fedfutp3hr
	gen fedfut2widemin=fedfutp3min
		
	replace fedfut2widehr=fedfutp4hr if fedfut2wide==. & fedfutp4~=.
	replace fedfut2widemin=fedfutp4min if fedfut2wide==. & fedfutp4~=.
	replace fedfut2wide=fedfutp4 if fedfut2wide==. & fedfutp4~=.
				
	sort contract_deliveryb date		
	*if there is no trading after 13:35, use the first trading of the next day, if it is before noon.
	gen usenextday1st=1 if fedfut2wide==. & NextDate==date_daily[_n+1] & contract_deliveryb==contract_deliveryb[_n+1] & fedfutpfirsthr[_n+1]<12
	replace fedfut2widehr=fedfutpfirsthr[_n+1] if usenextday1st==1
	replace fedfut2widemin=fedfutpfirstmin[_n+1] if usenextday1st==1
	replace fedfut2wide=fedfutpfirst[_n+1] if usenextday1st==1
	
	gen fedfut1wide=fedfutp1
	gen fedfut1widehr=fedfutp1hr
	gen fedfut1widemin=fedfutp1min
		
	*if the last observation before 13:05 is earlier than 6 hours ago, then set as missing.
	replace fedfut1widehr=. if fedfut1widehr<hourfomc-6
		
	gen timegapwide=(fedfut2widehr-fedfut1widehr)*60 + fedfut2widemin + 60 - fedfut1widemin if usenextday1st~=1
	replace timegapwide=(24- (fedfut1widehr+1))*60 - fedfut1widemin + fedfut2widehr*60+ fedfut2widemin if usenextday1st==1
		
	gen d`name'_tick_wide_early= fedfut2wide - fedfut1wide
		
	save `dirworking'`name'_tick_early_timegap, replace
	
	
	*save tick
	*Keep one observation per day and contract delivery day
	keep date_daily d`name'_tick_early monthahead 
	collapse d`name'_tick_early, by(date_daily monthahead)
		
	*Reshape dataset
	reshape wide d`name'_tick_early, i(date_daily) j(monthahead)
		
	save `dirworking'`name'_tick_early, replace
		
	*save tick_wide
	use `dirworking'`name'_tick_early_timegap, clear
	*Keep one observation per day and contract delivery day
	keep date_daily d`name'_tick_wide_early monthahead 
	collapse d`name'_tick_wide_early, by(date_daily monthahead)
		
	*Reshape dataset
	reshape wide d`name'_tick_wide_early, i(date_daily) j(monthahead)
		
	save `dirworking'`name'_tick_wide_early, replace
}


**********************Merge fedfund e and o data**************************************
*Shaowen choose 2004 jul as the cut-off year, follow eurodollar. Emi choose 2005 for ED by trading volumn, but there is no vol for ff new data. 	

*merge ffr_tick
use `dirworking'fedfund_o_tick_early
drop if year(date_daily)>2004 
drop if year(date_daily)==2004 & month(date_daily)>=7
foreach num of numlist 1(1)5 {
	rename dfedfund_o_tick_early`num' dfedfund_tick_early`num'
	}		
save `dirworking'temp, replace

use `dirworking'fedfund_e_tick_early
drop if year(date_daily)<2004
drop if year(date_daily)==2004 & month(date_daily)<7
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990

save `dirworking'fedfund_tick_early, replace

*merge ffr_tick_wide
use `dirworking'fedfund_o_tick_wide_early
drop if year(date_daily)>2004 
drop if year(date_daily)==2004 & month(date_daily)>=7
foreach num of numlist 1(1)5 {
	rename dfedfund_o_tick_wide_early`num' dfedfund_tick_wide_early`num'
	}		
save `dirworking'temp, replace

use `dirworking'fedfund_e_tick_wide_early
drop if year(date_daily)<2004
drop if year(date_daily)==2004 & month(date_daily)<7
append using `dirworking'temp
sort date_daily
keep if year(date_daily)>=1990

save `dirworking'fedfund_tick_wide_early, replace

