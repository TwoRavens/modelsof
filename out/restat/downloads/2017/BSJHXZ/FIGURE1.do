/**************************************************************************
SOCIAL TIES IN ACADEMIA: SOCIAL TIES IN ACADEMIA
by Tommaso Colussi
do file: Figure 1(a) and Figure 1(b)
**************************************************************************/
cd ${Dir}
do MASTER.do
set more off
/***********************************************************************
Figure 1(a): Distribution of authors' institution of appointment 
************************************************************************/
use "${DirALL}ARTICLES.dta", clear
bys articletitle author: keep if _n==1
merge m:1 author year  using "${DirALL}AUTHORS.dta"
keep if _m==3 /*_m=1 unknwon, _m=2 missing years*/
drop _m

*Compute frequencies, by faculty and journal
bys faculty_a journal: gen Nauthors =_N
bys journal: gen Tauthors=_N
bys faculty_a journal: gen jfaculty_freq=Nauthors/ Tauthors
sort jfaculty_freq
bys faculty_a journal: keep if _n==1
keep  faculty_a journal jfaculty_freq
gsort journal -jfaculty_freq faculty_a
by journal: gen cum_freq=sum(jfaculty_freq)

*graph
#delimit ;
graph hbar (asis) jfaculty_freq  if cum_freq<0.50, 
nofill  over(faculty_a, axis(off) )
bar(1, color(gs5) lw(medthick)) 
blabel(group, size(tiny) color(cranberry) orientation(horizontal))
by(journal, caption("") note("") graphregion(fcolor(white))) 
subtitle(, size(small) color(cranberry) fcolor(white) lcolor(gs4))
yscale(range(0(.05)0.2))
ylabel(, labsize(small))
legend(off) ;
#delimit cr
graph export "${DirALL}figure_1a.pdf", replace


/***********************************************************************
Figure 1(b): Distribution of authors' institution of PhD 
************************************************************************/
use "${DirALL}ARTICLES.dta", clear
bys articletitle author: keep if _n==1
merge m:1 author year  using "${DirALL}AUTHORS.dta"
keep if _m==3 /*_m=1 unknwon, _m=2 missing years*/
drop _m

*Compute frequencies, by Phd Institutions and journal
bys phd_a journal: gen Nauthors = _N
bys journal: gen Tauthors=_N
bys phd_a journal: gen jfaculty_freq=Nauthors/ Tauthors
sort jfaculty_freq
bys phd_a journal: keep if _n==1
keep  phd_a journal jfaculty_freq
gsort journal -jfaculty_freq phd_a
by journal: gen cum_freq=sum(jfaculty_freq)

*graph
#delimit ;
graph hbar (asis) jfaculty_freq  if cum_freq<0.50, 
nofill  over(phd_a, axis(off) )
bar(1, color(gs5) lw(medthick)) 
blabel(group, size(tiny) color(cranberry) orientation(horizontal))
by(journal, caption("") note("") graphregion(fcolor(white))) 
subtitle(, size(small) color(cranberry) fcolor(white) lcolor(gs4))
yscale(range(0(.05)0.3))
ylabel(, labsize(small))
legend(off) ;
#delimit cr
graph export "${DirALL}figure_1b.pdf", replace

