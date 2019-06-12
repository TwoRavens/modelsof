use ILPAdataset, clear

* declarations filed 1911-1923
keep if year_dec>1910&year_dec<1924

gen post=(year_decl>=1917)
gen inter=post*german
 

estimates clear
reg diffAMIdcI lAMIc i.year_decl i.ethnicity inter, cl(ethnicity)
eststo m1
reg diffAMIdc lAMIc  i.year_decl i.ethnicity inter, cl(ethnicity)
eststo m2
reg lAMId i.year_decl i.ethnicity  inter, cl(ethnicity)
eststo m3
reg diffAMIdcI_s lAMIc_s i.year_decl i.ethnicity inter, cl(ethnicity)
eststo m4
reg diffAMIdc_s lAMIc_s  i.year_decl i.ethnicity inter, cl(ethnicity)
eststo m5
reg lAMId_s i.year_decl i.ethnicity  inter, cl(ethnicity)
eststo m6

esttab m* using "Table4.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(inter)  
