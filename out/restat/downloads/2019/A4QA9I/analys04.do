
** Loading data - generated in dofile: data10
use  "$data\minwage_data10_payroll_disco_age1467_2013.dta", clear
drop p1* p99* n alder2013 foed_dag2013 brthmnth yr18 month18 senr es7604_dr_form_kod discotyp2013
keep if inrange(tline, -24, 563) // Note we include apprentices 

** Education indicator: 2013 was the most recent updated information.
merge m:1 pnr using "$data\uddany2013", nogen keep(match master) keepus(hffsp) // Newest available education data when we did the calculations
ge d_FS = hffsp < 20000000 & hffsp !=. // dummy for individuals having completed compulsory schooling (9th grade) or less

ge d1617 = inrange(tline, -24, -1) // Age dummy for 16 to 17 year olds
ge d1665 = inrange(tline, -24, 563) // Age dummy for 16 to 65 year olds
ge d1619 = inrange(tline, -24, 23) // Age dummy for 16 to 19 year olds
ge d1624 = inrange(tline, -24, 83) // Age dummy for 16 to 24 year olds
ge d18 = inrange(tline, 1, 12) // Age dummy for 18 year olds

** Finding top 10 disco codes for 16-17 year olds
ge disco4 = substr(discok2013, 1,4)
preserve
	keep if d1617 == 1 & disco4 != "" & disco4 != "9999"
	collapse (count) obs = pnr ///
		(mean) emplyd ///
		(sum) hours_sum = timeantF12_trim ///
		(sum) earnings_sum= felt_200_trim ///
		(mean) calc_hrly_wage, by(disco4)
		sort obs 
	*export excel using "$out\Table3_top10_disco_dofile_analys04.xls", firstrow(varlabels) sh(16-17_nonmis_disco) sheetmod 	
restore

** Top10 disco codes from Table A.2 in dofile descrp03
ge low_skilled = (disco4 == "5230" | disco4 == "9334" | disco4 == "5223" | disco4 == "9412" | ///
					   disco4 == "9112" | disco4 == "9621" | disco4 == "6130" | disco4 == "5246" | ///
					   disco4 == "7115" | disco4 == "5322")
** Supermarket dummy					   
ge supermrkt = (es7606_hov_br_nr == 471120 | es7606_hov_br_nr == 471900 | es7606_hov_br_nr == 471130)

** Dummy for Hourly wage < 95th percentile for 18 year olds					  
bysort month: egen p95_d18_help = pctile(calc_hrly_wage) if d18==1, p(95)
bysort month: egen p95_d18_calc_hrly_wage = min(p95_d18_help) 
ge d_calc_hrly_wage_blw_p95_d18 = calc_hrly_wage <= p95_d18_calc_hrly_wage
drop p95_d18_help

** Table 3: The Share of Younger Workers in the Low+Skilled Labor Market
putexcel set "$out\Table3_shareofyoungworkers_dofile_analys04.xls", sheet(Table 3) modify
putexcel B3=("Population")
putexcel D3=("Share age 16-17 (%)")
putexcel E3=("Lower bound elasticity")

	** Full population
	putexcel B4=("Full population")
	sum emplyd if d1617 == 1
	local tot_pop_1617 = (r(N)) 
	sum emplyd
	local tot_pop_1665 = (r(N)) 	
	local FP_population_pct = ((`tot_pop_1617' / `tot_pop_1665' )*100)
	putexcel D4=(`FP_population_pct')
	
	** Employment (persons)
	putexcel B5=("Employment (persons)")
	sum emplyd if d1617 == 1
	local avg_empl_1617 = (r(mean)) 
	sum emplyd 
	local avg_empl_1665 = (r(mean)) 	
	local FP_emply_pers_pct = (((`tot_pop_1617'*`avg_empl_1617') / (`tot_pop_1665'*`avg_empl_1665'))*100)
	putexcel D5=(`FP_emply_pers_pct')
	
	** Employment (hours)
	putexcel B6=("Employment (hours)")
	sum timeantF12_trim if d1617 == 1
	local avg_hrs_1617 = (r(mean)) 
	sum timeantF12_trim 
	local avg_hrs_1665 = (r(mean)) 	
	local FP_emply_hrs_pct = (((`tot_pop_1617'*`avg_empl_1617'*`avg_hrs_1617') / (`tot_pop_1665'*`avg_empl_1665'*`avg_hrs_1665'))*100)
	putexcel D6=(`FP_emply_hrs_pct')
	
	** Earnings
	putexcel B7=("Wage Income")
	sum felt_200_trim if d1617 == 1
	local tot_earn_1617 = (r(sum)) 
	sum felt_200_trim 
	local tot_earn_1665 = (r(sum)) 	
	local FP_earnings_pct = ((`tot_earn_1617' / `tot_earn_1665' )*100)
	putexcel D7=(`FP_earnings_pct')

		** Low-skilled occupations
		putexcel C8=("Low-skilled occupations")
		sum felt_200_trim if d1617 == 1 & low_skilled == 1
		local tot_earn_low_skill_1617 = (r(sum)) 
		sum felt_200_trim if low_skilled == 1
		local tot_earn_low_skill_1665 = (r(sum)) 	
		local Earnings_low_skill_pct = ((`tot_earn_low_skill_1617' / `tot_earn_low_skill_1665' )*100)
		putexcel D8=(`Earnings_low_skill_pct')
		
		** Supermarkets
		putexcel C9=("Supermarkets")
		sum felt_200_trim if d1617 == 1 & supermrkt == 1
		local earnings_supermrkt_1617 = (r(sum)) 
		sum felt_200_trim if supermrkt == 1
		local earnings_supermrkt_1665 = (r(sum)) 	
		local Earnings_supermrkt_pct = ((`earnings_supermrkt_1617' / `earnings_supermrkt_1665' )*100)
		putexcel D9=(`Earnings_supermrkt_pct')
		
		** Hourly wage < 95 9th percentile for 18 yr olds
		putexcel C10=("Hourly wage < 95 9th percentile for 18 yr olds")
		sum felt_200_trim if d_calc_hrly_wage_blw_p95_d18 ==1 
		local tot_earn_p95_hrly_wage_1665 = (r(sum)) 	
		local Earnings_p95_hrly_wage_pct = ((`tot_earn_1617' / `tot_earn_p95_hrly_wage_1665' )*100)
		putexcel D10=(`Earnings_p95_hrly_wage_pct')
	
		** Highest Education 9th grade or lower
		putexcel C11=("Highest Education 9th grade or lower")
		sum felt_200_trim if d_FS == 1 
		local tot_earn_9th_1665 = (r(sum)) 	
		local 9th_earnings_pct = ((`tot_earn_1617' / `tot_earn_9th_1665' )*100)
		putexcel D11=(`9th_earnings_pct')
		
		** Individuals age 16-24
		putexcel C12=("Individuals age 16-24")
		sum felt_200_trim if d1624 == 1
		local tot_earn_1624 = (r(sum))  	
		local Earnings_1624_pct = ((`tot_earn_1617' / `tot_earn_1624' )*100)
		putexcel D12=(`Earnings_1624_pct')
		
		** Individuals age 16-19
		putexcel C13=("Individuals age 16-19")
		sum felt_200_trim if d1619 == 1
		local tot_earn_1619 = (r(sum)) 
		local Earnings_1619_pct = ((`tot_earn_1617' / `tot_earn_1619' )*100)
		putexcel D13=(`Earnings_1619_pct')
		
