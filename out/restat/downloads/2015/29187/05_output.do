
set more off
clear all
set mem 600m
set seed 2038947

* make agents.csv

clear all

local sims=100
input sim
0
end
insob `sims' 1
replace sim=(_n-1)

save c:/research/denver/temp/sims.dta, replace

clear all
use c:/research/denver/temp/demographics.dta

* per capita household consumption
replace price=price/h_hsize

sort panid
egen agent=group(panid)

sort good_group
egen good=group(good_group)

egen obs=max(period)
egen goods=max(good)

* aggregate consumption
collapse (sum) sum_price=price, by(agent obs goods good period)

sort agent good period

save c:/research/denver/temp/exp_temp.dta, replace

clear
use c:/research/denver/temp/exp_temp.dta

collapse obs goods, by(agent)

cross using c:/research/denver/temp/sims.dta

sort agent sim
gen agent_sim=(agent*(`sims'+1))+sim
outsheet agent_sim obs goods using c:/output/datain/agents.csv, comma nonames replace

* make P and Q files

quietly {

sum agent, meanonly
forvalues n = 1/`r(max)' {

	clear
	use c:/research/denver/temp/prices_only.dta
	drop price_count
	gen column1=.
	gen agent=`n' 
	sort good_group
	egen good=group(good_group)
	
	sort agent good period
	merge agent good period using c:/research/denver/temp/exp_temp.dta, nokeep
	
	replace sum_price=0 if sum_price==.
	gen good_qty=sum_price/good_price
	replace good_qty=0 if good_qty==.
	drop _merge obs goods
	egen obs=max(period)
	egen goods=max(good)
	
	drop good_qty sum_price
	reshape wide good_price, i(column1 agent good obs goods) j(period)
	insob 1 1
	egen obs2=max(obs)
	egen goods2=max(goods)
	replace good=0 if good_price2==.
	replace column1=obs2 if good_price2==.
	replace good_price1=goods2 if good_price2==.
	sort good
	
	drop agent good obs goods obs2 goods2 good_group
	local n_out=`n'*(`sims'+1)

	outsheet using c:/output/PQ/`n_out'.p, nonames replace delimiter( " ")

	forvalues m = 1/`sims' {

		local n_out=`n'*(`sims'+1)+`m'
		outsheet using c:/output/PQ/`n_out'.p, nonames replace delimiter( " ")

	}

	clear
	use c:/research/denver/temp/prices_only.dta
	drop price_count
	gen column1=.
	gen agent=`n' 
	sort good_group
	egen good=group(good_group)
	
	sort agent good period
	merge agent good period using c:/research/denver/temp/exp_temp.dta, nokeep

	replace sum_price=0 if sum_price==.
	gen good_qty=sum_price/good_price
	replace good_qty=0 if good_qty==.
	drop _merge obs goods
	egen obs=max(period)
	egen goods=max(good)

	sort good_group	period
	save c:/research/denver/temp/qty_temp.dta, replace

	drop good_price sum_price 
	reshape wide good_qty, i(column1 agent good obs goods) j(period)
	insob 1 1
	egen obs2=max(obs)
	egen goods2=max(goods)
	replace good=0 if good_qty2==.
	replace column1=obs2 if good_qty2==.
	replace good_qty1=goods2 if good_qty2==.
	sort good
	
	drop agent good obs goods obs2 goods2 good_group 
	local n_out=`n'*(`sims'+1)

	outsheet using c:/output/PQ/`n_out'.q, nonames replace delimiter( " ")

	forvalues m = 1/`sims' {

* To get alternative benchmark, uncommment below

		* clear 
		* use c:/research/denver/temp/shares.dta
		
		* drop period panid
		* * duplicates drop
		
		* sample 24, count
		
		* gen period=_n
		* reshape long bshare, i(period) j(good_group)
		* gen balpha=.
		* gen period_balpha=.
		* sort good_group	period
		* merge good_group period using c:/research/denver/temp/qty_temp.dta
		* drop _merge
		
* To get alternative benchmark, uncommment above

* To get random benchmark, uncommment below
		
		clear
		use c:/research/denver/temp/qty_temp.dta		
		gen balpha=runiform()
		sort period balpha
		by period: gen order1=_n	
		sort period order1
		save c:/research/denver/temp/qty_temp1.dta, replace
		gen balpha_prior=balpha
		drop balpha good_group column1 agent good good_qty obs goods
		replace order1=order1+1
		* 3 categories
		drop if order1==4
		* * 38 categories
		* drop if order1==37
		sort period order1
		save c:/research/denver/temp/qty_temp2.dta, replace
		clear
		use c:/research/denver/temp/qty_temp1.dta	
		sort period order1
		merge period order1 using c:/research/denver/temp/qty_temp2.dta
		drop _merge
		gen bshare=0
		replace bshare=balpha if order1==1
		* 3 categories
		replace bshare=balpha-balpha_prior if order1>1 & order1<3
		replace bshare=1-balpha_prior if order1==3
		* * 38 categories
		* replace bshare=balpha-balpha_prior if order1>1 & order1<36
		* replace bshare=1-balpha_prior if order1==36
		sort good_group	period
		drop balpha order1 balpha_prior
	
* To get random benchmark, uncommment above
		
		egen period_sum_price=sum(sum_price), by(period)
		replace sum_price=bshare*period_sum_price
		replace good_qty=sum_price/good_price

		drop bshare period_sum_price
		
		drop good_price sum_price 
		reshape wide good_qty, i(column1 agent good obs goods) j(period)
		insob 1 1
		egen obs2=max(obs)
		egen goods2=max(goods)
		replace good=0 if good_qty2==.
		replace column1=obs2 if good_qty2==.
		replace good_qty1=goods2 if good_qty2==.
		sort good
	
		drop agent good obs goods obs2 goods2 good_group 
		
		local n_out=`n'*(`sims'+1)+`m'
		outsheet using c:/output/PQ/`n_out'.q, nonames replace delimiter( " ")

	}
}

}

* winexec "c:/output/run_dm.bat"

clear all
set more on

