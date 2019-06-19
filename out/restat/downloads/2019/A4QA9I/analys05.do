
** Loading data - generated in dofile: data05
use "$data\minwage_data5_estimation_2012_2015.dta", clear
keep if inrange(tline,-24,24) & apprentice == 0 // 49 event-month oberservation window & excluding apprentices

** Generating flow variables: entry/exit
bysort pnr (month): ge flow_in = 1 if felt_200_trim[_n+1] !=. & felt_200_trim == . & pnr[_n+1] == pnr // flow in if no earnings this month and positive earnings next month
bysort pnr (month): ge flow_out = 1 if felt_200_trim[_n+1] ==. & felt_200_trim != . & pnr[_n+1] == pnr // flow out if positive earnings this month and no earnings next month

collapse (count) observations = pnr  (mean) felt_200_trim  ///
		 (count) flow_in (count) flow_out, by(tline)

** flow as percentage of total observations
ge flow_in_pct = flow_in / observations * 100
ge flow_out_pct = flow_out / observations * 100

** Figure 4: Employment Entry and Exit Rates around Workers' 18th Birthdays 			
two connected flow_in_pct tline if inrange(tline, -24, 23), mcolor(gs8) lcolor(gs8) msize(large) msymbol(T) || ///
    connected flow_out_pct tline if inrange(tline, -24, 23), mcolor(black) lcolor(black) msize(large) ///
graphregion(color(white)) ///
yti("Percent") ylabel(0(3)15) xline(-12, lcolor(grey)) xline(0, lcolor(grey)) xline(12, lcolor(grey)) ///
xti("Month relative to 18th birthday") xlabel(-24(2)24) ///
legend(label(1 "Entry") label(2 "Exit") region(lcolor(white))) scale(0.85) 
graph export "$out\Figure4_employment_flow_dofile_analys05.png", width(800) height(600) replace

		
