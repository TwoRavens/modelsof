
/* Statement in footnote: "Using quarterly FRBNY Consumer Credit Panel data, HELOC balances grew more in high
equity than low equity MSAs over 2008-2009, and differentially increased in high equity locations by roughly $4 billion after QE1." */

insheet using  CCP_helocs.csv, names clear
/* File was created based on the following SQL code in RADAR:
select qtr, zipcode, SUM(greatest(0,coalesce(crtr_attr173,0)-0.5*cust_attr318)) as crtr_attrj173, COUNT(1) as pop FROM concredit.view_join_static_dynamic_eqf WHERE primary_flag_e = 'P' GROUP BY qtr, zipcode
*/

g dateq = qofd(date(qtr, "YMD"))
format dateq %tq
drop qtr
sort zipcode dateq
replace crtr_attrj173 = crtr_attrj173 *20 // 5pct sample
tabstat crtr_attrj173 , stat(sum) by(dateq)  

rename zipcode prop_zip
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 

rename msano msa
replace msa=35840 if msa==14600|msa==42260 
replace msa=18880 if msa==23020
replace msa=44600 if msa==48260
replace msa=42044 if msa==11244
replace msa=14460 if msa==40484

merge m:1 msa using CRISMcleaning/output/msa_eq_2008m11.dta, nogen // saved in Fig3to5_App5_9.do

tab dateq group [aw=crtr_attrj173 ], m row 

collapse (sum) crtr_attrj173, by(dateq group) fast

replace crtr_attrj173 = crtr_attrj173/10^9

tsset group dateq

line crtr_attrj173 dateq if group ==1 || line crtr_attrj173 dateq if group ==4, tline(2008q4)

line s.crtr_attrj173 dateq if group ==1 || line s.crtr_attrj173 dateq if group ==4, tline(2008q4)

list group crtr_attr dateq if inlist(group,1,4)&dateq>=q(2007q4)&dateq<=q(2009q4), clean noobs
