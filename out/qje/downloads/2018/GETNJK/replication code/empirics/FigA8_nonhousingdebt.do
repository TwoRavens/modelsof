
// Create panels of non-mortgage debt by MSA, based on the full 5% FRBNY CCP (available to users within Fed system)

use CCP/eqf_nonhousing.dta, clear

/* SQL query for RADAR users within Fed system:
select qtr, zipcode,SUM(greatest(0,coalesce(crtr_attr167,0)-0.5*cust_attr294)) as autofinance,
SUM(greatest(0,coalesce(crtr_attr168,0)-0.5*cust_attr298)) as autobank,
SUM(greatest( 0,coalesce(crtr_attr169,0)-0.5*cust_attr302)) as bankcards,
SUM(greatest(0,coalesce(crtr_attr170,0)-0.5*cust_attr306)) as consfinance,
SUM(greatest(0,coalesce(crtr_attr174,0)-0.5*cust_attr322)) as retail,
SUM(greatest(0,coalesce(crtr_attr176,0)-0.5*cust_attr338)) as other,
COUNT(1) as pop FROM concredit.view_join_static_dynamic_eqf WHERE primary_flag_e = 'P' GROUP BY qtr, zipcode 
*/

merge 1:1 qtr zipcode using CCP/eqf_student.dta
/* Student loans -- separate table:
select qtr, zipcode,SUM(CASE WHEN ecoacode='I' then balance else balance*0.5 end) as student FROM concredit.view_student_loan_valid WHERE primary_flag_e = 'P' GROUP BY qtr, zipcode
*/

replace student = 0 if student==.

g dateq = qofd(qtr)
format dateq %tq
drop qtr
sort zipcode dateq

egen debt_nonhousing = rowtotal(autofinance autobank bankcards consfinance retail student other) // main variable of interest

foreach x in autofinance autobank bankcards consfinance retail student other debt_nonhousing pop {
replace `x' = `x' *20
}

tabstat debt_nonhousing , stat(sum) by(dateq) // close to non-housing totals in Quarterly Report

g auto = autofinance + autobank

g other_hhdc = consfinance + retail + other

foreach x in auto bankcards student other_hhdc {
tabstat `x' if dateq==q(2017q4), stat(sum)
}

rename zipcode prop_zip
destring prop_zip, replace
merge m:1 prop_zip using ../CRISMcleaning/input/zipTOmsadiv.dta, keep(1 3) nogen

rename msano msa
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484
merge m:1 msa using ../output/msa_eq_2008m11.dta, nogen

collapse (sum) autofinance autobank bankcards consfinance retail student other debt_nonhousing pop, by(dateq group) fast

tsset group dateq

g auto = autofinance + autobank

foreach x in auto autofinance autobank bankcards consfinance retail student other debt_nonhousing {
cap gen `x'_pop = `x'/pop
}


preserve
	keep if dateq>=q(2007q1)&dateq<=q(2010q4)
		
	line debt_nonhousing_pop dateq if group ==1 || line debt_nonhousing_pop dateq if group ==4, lpattern(dash) tline(2008q4) ///
	legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(7))	xlabel(188(2)202, angle(45) nogrid) xtitle("") ///
	ytitle("Non-housing Debt per Person, in USD")
restore

preserve
	keep if dateq>=q(2006q4)&dateq<=q(2010q4)
	g DebtChange_perperson = d.debt_nonhousing_pop
	keep if dateq>=q(2007q1)&dateq<=q(2010q4)
	
	line DebtChange_perperson dateq if group ==1 || line DebtChange_perperson dateq if group ==4, lpattern(dash) tline(2008q4) ///
	legend(order(1 "Highest Equity Quartile" 2 "Lowest Equity Quartile") symx(7))	xlabel(188(2)202, angle(45) nogrid) xtitle("") ///
	ytitle("Quarterly Change in Non-housing Debt" "per Person, in USD")
restore
