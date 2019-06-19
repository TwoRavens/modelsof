set mem 9k
clear all
set more off
global ldir "C:\Users\russellthomson\Dropbox\REStat documents and data\Data"

use  "$ldir\oecd_ind_by_country_final", clear

* capture: ssc install xtlsdvc
* capture: ssc install xtabond2

reg d.lrdfind ld.lrdfind ld.livadollars ld.lf_b i.t  , vce(cluster i)
outreg2     using "$ldir\results_table_5.xls", rdec(3) ctitle("Col 2") keep(ld.lrdfind ld.livadollars ld.lf_b) replace excel
gen fdsample = e(sample)

xtreg lrdfind l.lrdfind l.livadollars l.lf_b i.t if fdsample, fe vce(cluster i)
outreg2     using "$ldir\results_table_5.xls", rdec(3) ctitle("Col 1") keep(l.lrdfind l.livadollars l.lf_b) append excel

sum rdfind l.ivadollars l.f_b if e(sample)

* xtlsdvc lrdfind l_lrdfind l_livadollars l_lf_b  timedum9-timedum27 if fdsample, initial(bb) vcov(100) 
* outreg2     using "$ldir\results_table_5.xls", rdec(3) ctitle("Col3") keep(l_lrdfind l_livadollars l_lf_b ) append excel

xtabond2 lrdfind l.lrdfind l.livadollars  l.lf_b i.t if fdsample, gmmstyle(l.lrdfind  l.livadollars l.lf_b , laglimit(. 3) collapse ) ivstyle( i.t) twostep orthog robust nodiffsargan
outreg2     using "$ldir\results_table_5.xls", rdec(3) ctitle("Col 4") keep( l.lrdfind l.livadollars  l.lf_b ) append excel

xtabond2 lrdfind l.lrdfind l.livadollars  l.lf_b i.t if fdsample & manuf == 1 , gmmstyle(l.lrdfind l.livadollars l.lf_b, laglimit(. 3) collapse) ivstyle(  i.t) twostep orthog robust nodiffsargan
outreg2     using "$ldir\results_table_5.xls", rdec(3) ctitle("Col 5")  keep( l.lrdfind l.livadollars  l.lf_b )  append excel

xtabond2 lrdfind l.lrdfind l.livadollars  l.lf_b i.t , gmmstyle(l.lrdfind l.livadollars l.lf_b , laglimit(. 3) collapse) ivstyle(i.t) twostep orthog robust nodiffsargan
outreg2     using "$ldir\results_table_5.xls", rdec(3) ctitle("Col 6") keep( l.lrdfind l.livadollars  l.lf_b ) append excel


/* robustness checks */
set more off
* dynamic structure test
xtabond2 lrdfind l(1/3).lrdfind l.livadollars  l.lf_b i.t if fdsample, gmmstyle(l.lrdfind  l.lf_b l.livadollars , laglimit(. 3) collapse) ivstyle( i.t) twostep orthog robust nodiffsargan
outreg2     using "$ldir\results_unreported.xls", rdec(3) ctitle("test  dynamics GMM")  keep( l(1/3).lrdfind l.livadollars  l.lf_b )  replace excel


*** additional controls simliar to Guellec and van Pottelsberge
xtreg d.lrdfind ld.lrdfind ld.livadollars ld.lf_b  ld.lrdfgov ld.lrdfgov ld.lherd ld.lgovrd i.t  , re cluster(i)
outreg2     using "$ldir\results_unreported.xls", rdec(3) ctitle("extra controls FD")  keep( ld.lrdfind ld.livadollars ld.lf_b  ld.lrdfgov ld.lrdfgov ld.lherd ld.lgovrd)  append excel
 
xtreg lrdfind l.lrdfind l.livadollars l.lf_b l.lrdfgov l.lherd l.lgovrd i.t if e(sample) , fe cluster(i) 
outreg2     using "$ldir\results_unreported.xls", rdec(3) ctitle("extra controls FE")  keep(  l.lrdfind l.livadollars l.lf_b l.lrdfgov l.lherd l.lgovrd)  append excel

xtabond2 lrdfind l.lrdfind l.livadollars  l.lf_b l.lrdfgov l.lherd l.lgovrd i.t if e(sample), gmmstyle(l.lrdfind l.lf_b l.livadollars l.lrdfgov , laglimit(. 3) collapse) ivstyle( l.lherd l.lgovrd i.t ) twostep orthog robust nodiffsargan
outreg2     using "$ldir\results_unreported.xls", rdec(3) ctitle("extra controls GMM")  keep(  l.lrdfind l.livadollars l.lf_b l.lrdfgov l.lherd l.lgovrd)  append excel

** ECM
xtreg d.lrdfind l.lrdfind ld.livadollars ld.lf_b   ld.lrdfgov ld.lherd ld.lgovrd   l2.lf_b   l2.livadollars  l2.lrdfgov l2.lherd l2.lgovrd   i.t  , fe  /* G & vp type specification */
outreg2     using "$ldir\results_unreported.xls", rdec(3) ctitle("ECM")  keep(l.lrdfind ld.livadollars ld.lf_b   ld.lrdfgov ld.lherd ld.lgovrd   l2.lf_b   l2.livadollars  l2.lrdfgov l2.lherd l2.lgovrd)  append excel

**exclude instances of large policy shifts
xtabond2 lrdfind l.lrdfind l.livadollars  l.lf_b l.lrdfgov l.lherd l.lgovrd i.t if e(sample) & abs(ld.lf_b)< 0.3 , gmmstyle(l.lrdfind l.lf_b l.livadollars l.lrdfgov , laglimit(. 3) collapse) ivstyle( l.lherd l.lgovrd i.t )  twostep orthog robust nodiffsargan
outreg2     using "$ldir\results_unreported.xls", rdec(3) ctitle("Exclude large policy shifts")  keep(  l.lrdfind l.livadollars l.lf_b l.lrdfgov l.lherd l.lgovrd)  append excel

**** drop one country at a time
set more off
local countries "at au be ca ch cz de dk es fr fi gb gr hu ie it jp kr mx nl no nz pl pt se us"
reg lrdfin l.lrdfind if fdsample
outreg2     using "$ldir\results_unreported_2.xls", rdec(3) ctitle("blank")  keep()  replace excel
foreach i of local countries {
xtabond2 lrdfind l.lrdfind l.livadollars  l.lf_b i.t if ccode != "`i'", gmmstyle(l.lrdfind  l.lf_b l.livadollars , laglimit(. 3) collapse) ivstyle( i.t ) twostep robust orthog nodiffsargan
outreg2     using "$ldir\results_unreported_2.xls", rdec(3) ctitle("drop `i'")  keep(l.lrdfind l.livadollars  l.lf_b)  append excel
}

** drop one industry at a time
set more off
local industries C10T14 C15T16 C17 C18 C19 C20 C21 C22 C23 C2423 C24X C25 C26 C27 C28 C29 C30 C31 C32 C33 C34 C35 C36 C37 C45 C60T64 C64 C70T74 C72 C73
reg lrdfin l.lrdfind if fdsample
outreg2     using "$ldir\results_unreported_3.xls", rdec(3) ctitle("blank")  keep()  replace excel
foreach i of local industries {
xtabond2 lrdfind l.lrdfind l_livadollars  l_lf_b i.t if indcode != "`i'", gmmstyle(l_lrdfind l_livadollars  l_lf_b , laglimit(. 3) collapse) ivstyle( i.t ) twostep robust orthog nodiffsargan
outreg2     using "$ldir\results_unreported_3.xls", rdec(3) ctitle("drop `i'")  keep(l.lrdfind l.livadollars  l.lf_b) append  excel
}
exit
