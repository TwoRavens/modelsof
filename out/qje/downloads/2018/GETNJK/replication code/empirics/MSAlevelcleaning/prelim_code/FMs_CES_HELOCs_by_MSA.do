
// This file creates panels of FM, CES, and HELOC balances and numbers by MSA, based on the full 5% CCP (pulled via RADAR)

// First mortgages

/* Run this query:
select qtr, zipcode, SUM(greatest(0,coalesce(crtr_attr171,0)-0.5*cust_attr310)) as crtr_attrj171, SUM(greatest(0,coalesce(crtr_attr6,0))) as crtr_attrj6, COUNT(1) as pop FROM conc redit.view_join_static_dynamic_eqf WHERE primary_flag_e = 'P' GROUP BY qtr, zipcode

and use the resulting file
*/

g dateq = qofd(qtr)
format dateq %tq
drop qtr
sort zipcode dateq
foreach x of varlist crtr_attrj171 crtr_attrj6 pop {
replace `x' = `x' *20
}

tabstat crtr_attrj171 , stat(sum) by(dateq) 
rename zipcode prop_zip
destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 

rename msano msa
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

collapse (sum) crtr_attrj* pop, by(dateq msa) fast

rename crtr_attrj171 fm_bal_fullccp
rename crtr_attrj6   fm_num_fullccp
rename pop	     pop_fm_fullccp

save temp/fm_bal_fullccp.dta, replace



// Closed-end seconds

/* Run this query:
select qtr, zipcode, SUM(greatest(0,coalesce(crtr_attr172,0)-0.5*cust_attr314)) as crtr_attrj172, COUNT(1) as pop FROM concredit.view_join_static_dynamic_eqf WHERE primary_flag_e = 'P' GROUP BY qtr, zipcode

and use the resulting file
*/

g dateq = qofd(qtr)
format dateq %tq
drop qtr
sort zipcode dateq
foreach x of varlist crtr_attrj172 pop {
replace `x' = `x' *20
}

tabstat crtr_attrj172 , stat(sum) by(dateq) 

rename zipcode prop_zip
destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 

rename msano msa
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

collapse (sum) crtr_attrj172 pop, by(dateq msa) fast

rename crtr_attrj172 ces_bal_fullccp
rename pop	     pop_ces_fullccp

save temp/ces_bal_fullccp.dta, replace


// HELOCs:

/* Run this query:
select qtr, zipcode, SUM(greatest(0,coalesce(crtr_attr173,0)-0.5*cust_attr318)) as crtr_attrj173, COUNT(1) as pop FROM concredit.view_join_static_dynamic_eqf WHERE primary_flag_e = 'P' GROUP BY qtr, zipcode

and use the resulting file
*/

g dateq = qofd(date(qtr, "YMD"))
format dateq %tq
drop qtr
sort zipcode dateq
foreach x of varlist crtr_attrj173 pop {
replace `x' = `x' *20
}
tabstat crtr_attrj173 , stat(sum) by(dateq) 

rename zipcode prop_zip
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 

rename msano msa
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

collapse (sum) crtr_attrj173 pop, by(dateq msa) fast

rename crtr_attrj173 heloc_bal_fullccp
rename pop	     pop_heloc_fullccp

save temp/heloc_bal_fullccp.dta, replace
