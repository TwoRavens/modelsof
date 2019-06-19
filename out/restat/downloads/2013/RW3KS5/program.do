* --------------------------------------------------------------------------------------------------------------
* This file contains code to create the tables and figures in the paper: 
* "DOES TEMPORARY AFFIRMATIVE ACTION PRODUCE PERSISTENT EFFECTS? A STUDY OF BLACK AND FEMALE EMPLOYMENT IN LAW ENFORCEMENT" 
* by Amalia Miller and Carmit Segal
* Published Novemeber 2012, Review of Economics and Statistics 
* Programs run using Stata version 12
* --------------------------------------------------------------------------------------------------------------

use data_miller_segal_2012 , clear
* NOTE: The data file is data_miller_segal_2012 is created by merging the data in the file public_data_miller_segal_2012 with confidential EEOC data on police employment
* NOTE: The variables dyear* are year dummies, dyrcenr* are year-by-census-region dummies and dyrst* are the year-by-state dummies.

* --------------------------------------------------------------------------------------------------------------
* Table 1 
* --------------------------------------------------------------------------------------------------------------

table aa_status if year==2005, c(n south mean south mean northeast mean midwest mean west)
table aa_status if year==2005, c(mean dur2005)

gen ind_year=0 if year==1973
replace ind_year=1 if year==2005
label def ind_year 0 "1973" 1 "2005"
label val ind_year ind_year

table aa_status ind_year if irepgapb_ft~=.,c(n year mean itot_ft)
table aa_status ind_year,c(mean ipop_share_black mean ishareb_ft mean irepgapb_ft mean irepgapb_prot mean irepgapb_prof)
table aa_status ind_year,c(mean isharew_ft mean isharew_prot mean isharew_prof)
table aa_status if year==2005, c(mean unemp_bm mean nilf_bm mean hsgrad_bm mean somecoll_bm)
table aa_status if year==2005, c(mean unemp_all mean nilf_all mean hsgrad_all mean somecoll_all)
table aa_status if year==2005, c(mean dism1970 mean isol1970)


* --------------------------------------------------------------------------------------------------------------
* Table 2 
* --------------------------------------------------------------------------------------------------------------

areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

* --------------------------------------------------------------------------------------------------------------
* Table 3 
* --------------------------------------------------------------------------------------------------------------

xtset cn
areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

xtreg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito dyrst1002-dyrst490033, fe cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

xtreg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito dyrst1002-dyrst490033, fe cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

xtreg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito dyrst1002-dyrst490033, fe cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

* --------------------------------------------------------------------------------------------------------------
* Table 4 
* --------------------------------------------------------------------------------------------------------------

preserve
gen yr3aflit_alt=yr3aflit
*We define the litigation year as including also the years immediatly before and after litigation. See text for details.
replace yr3aflit_alt=0 if yr3aflit==1
gen yr3blit_alt=yr3blit
replace yr3blit_alt=0 if yr3blit==-1
drop yr3aflit yr3blit
rename yr3aflit_alt yr3aflit
rename yr3blit_alt yr3blit
*keep depts that had litigation (either ending with AA or not)
keep if aa_status>=1 
label var yr3blit "Years Before Police Litigation (AA)"
label var yr3aflit "Years After Police Litigation (AA)"

areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito
restore

* --------------------------------------------------------------------------------------------------------------
* Table 5 
* --------------------------------------------------------------------------------------------------------------

* Columns 1-3
* --------------------------------------------------------------------------------------------------------------
preserve
gen aaon = (aa_status > 1 & year >= ilitdate)
replace aaon = 0 if year > iendyr
egen medaa_rgft = median(irepgapb_ft), by(year), if aaon
egen medaa_rgprot = median(irepgapb_prot), by(year), if aaon
egen medaa_rgprof = median(irepgapb_prof), by(year), if aaon
gen hiaa_rgft = irepgapb_ft > medaa_rgft 
gen hiaa_rgprot  = irepgapb_prot > medaa_rgprot
gen hiaa_rgprof = irepgapb_prof > medaa_rgprof 
replace hiaa_rgft = . if irepgapb_ft ==.
replace hiaa_rgprot = . if irepgapb_prot ==.
replace hiaa_rgprof  = . if irepgapb_prof ==.
foreach xx in rgft rgprot rgprof {
gen hiAEY`xx'_drop = hiaa_`xx' if year == iendyr
egen hiAEY`xx' = max(hiAEY`xx'_drop), by(cn)
recode hiAEY`xx' (.=0)
gen yaehAEY`xx' = yrafend*hiAEY`xx'
}
foreach depvar in ft prot prof {
areg irepgapb_`depvar' yr3blit yr3aflit yrafend yaehAEYrg`depvar' yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
}
restore

* Columns 4-6
* --------------------------------------------------------------------------------------------------------------
bys cn: gen tmpn=1 if _n==1 & aa_status>1
gen nend=sum(tmpn) if iendyr~=. & iendyr<=2005
gen naa=sum(tmpn) if aa_status>1
sort cn
foreach depvar in itot_prot itot_prof itot_ft {
gen growth`depvar'_afst=0
gen growth`depvar'_afend=0
forval i=1(1)117{
	reg `depvar' yr3aflit if yr3aflit>=0 & year<=iendyr & naa==`i'
	mat coeff=get(_b) 
	test yr3aflit=0
	replace growth`depvar'_afst=1 if coeff[1,1]>0 & r(p)<0.1 & naa==`i'
	replace growth`depvar'_afst=-1 if coeff[1,1]<0 & r(p)<0.1 & naa==`i'
}
forval i=1(1)67{
	reg `depvar' yr3aflit if year>=iendyr & nend==`i'
	mat coeff=get(_b) 
	test yr3aflit=0 
	replace growth`depvar'_afend=1 if coeff[1,1]>0 & r(p)<0.1 & nend==`i'
	replace growth`depvar'_afend=-1 if coeff[1,1]<0 & r(p)<0.1 & nend==`i'
}
}
foreach x in ft prot prof{
foreach depvar in irepgapb_`x' {
preserve 
gen yr3aflit_zg=0 
replace yr3aflit_zg=yr3aflit if growthitot_`x'_afst==0
gen yr3aflit_ng=0 
replace yr3aflit_ng=yr3aflit if growthitot_`x'_afst==-1
gen yrafend_zg=0 
replace yrafend_zg=yrafend if growthitot_`x'_afend==0
gen yrafend_ng=0 
replace yrafend_ng=yrafend if growthitot_`x'_afend==-1
areg `depvar' yr3blit yr3aflit yrafend yrafend_zg yrafend_ng yrblito yraflito dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
restore
}
}

* --------------------------------------------------------------------------------------------------------------
* Table 6 
* --------------------------------------------------------------------------------------------------------------

areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito yrbdseg yradseg yrbrseg yrarseg dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_ft yr3blit yr3aflit yrafend yrblito yraflito yrbdseg yradseg yrbrseg yrarseg dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito yrbdseg yradseg yrbrseg yrarseg dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prot yr3blit yr3aflit yrafend yrblito yraflito yrbdseg yradseg yrbrseg yrarseg dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito yrbdseg yradseg yrbrseg yrarseg dyear2-dyear33, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

areg irepgapb_prof yr3blit yr3aflit yrafend yrblito yraflito yrbdseg yradseg yrbrseg yrarseg dyrcenr12-dyrcenr933, absorb(cn) cl(cn) 
test yr3aflit=yr3blit
test yr3aflit+yrafend=0
test yr3aflit=yraflito

* --------------------------------------------------------------------------------------------------------------
* Figures 2 - 4
* --------------------------------------------------------------------------------------------------------------

*create dummies for the estimation (see text for details)
*years before/after end (divided by whether before/after plan started)
gen dyraendbst=year-iendyr if year<ilitdate & aa_status>1
gen dyraendafst=year-iendyr if year>=ilitdate & aa_status>1
recode dyraendafst (-37/-20=-20) (16/37=16)(.=0) 
recode dyraendbst (-37/-20=-20) (.=0) (-8/-4=-8)
quietly tab dyraendafst, gen(d1end)
quietly tab dyraendbs, gen(d1endbs)

*years before/after AA start
gen dyrast=year-ilitdate if aa_status>1
recode dyrast (-37/-10=-10) (31/37=30) (.=0)
quietly tab dyrast, gen(d3lit)

*create dummies for years before/after start in which for depts whose plan ended the years after start are replace with plan duration after the plan ended
gen dyrast5=year-ilitdate if aa_status>1
gen ddur=iendyr-ilitdate if aa_status>1
replace dyrast5=ddur if year>iendyr 
recode dyrast5 (-37/-10=-10) (31/37=30) (.=0)
quietly tab(dyrast5), gen(d5lit)

*years before/after litigation only
gen dyralito=year-ilitdate if aa_status==1
recode dyralito (-37/-10=-10) (31/37=30) (.=0)
quietly tab dyralito, gen(dlonly)

*Figure 2 + Left-Hand-Side figure 3
* --------------------------------------------------------------------------------------------------------------
*the coeffiecints for dlonly1-dlonly10 are for litigated only departments for years before the litigation date (which is dlonly11), with dlonly10=-1, dlonly9=-2, etc.
*the coefficients for dlonly12-dlonly41 are for litigated only departments for years after the litigation date, with dlonly12=1, dlonly13=2, etc.
*similarly, the coefficeints for d3lit1-d3lit10 are for dept with AA for the years before the litigation date (which is d3lit11), and 
*the coefficeints for d3lit12-d3lit41 are for dept with AA for the years after the litigation date.
*The coefficeints for d1end1-d1end20 are for dept with AA for the years before AA ended (which is dend21), and 
*the coefficeints for d1end22-d1end37 are for dept with AA for the years after AA ended. This is relative to dept in which AA continued.

areg irepgapb_ft dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 
areg irepgapb_prot dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 
areg irepgapb_prof dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 

*Right-Hand-Side Figure 3
* --------------------------------------------------------------------------------------------------------------
*The coefficeints for d1end1-d1end20 are for dept with AA for the years before AA ended (which is dend21), and 
*the coefficeints for d1end22-d1end37 are for dept with AA for the years after AA ended. In these regressions it is relative to dept with No AA. See text for details.

areg irepgapb_ft dlonly1-dlonly10 dlonly12-dlonly41 d5lit1-d5lit10 d5lit12-d5lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 
areg irepgapb_prot dlonly1-dlonly10 dlonly12-dlonly41 d5lit1-d5lit10 d5lit12-d5lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 
areg irepgapb_prof dlonly1-dlonly10 dlonly12-dlonly41 d5lit1-d5lit10 d5lit12-d5lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 

*Figure 4
* --------------------------------------------------------------------------------------------------------------
*For the blacks the coefficents are just those for d3lit* for the regression above (with year FE) and below (without year FE)
areg irepgapb_ft dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13, absorb(cn) cl(cn) 
areg irepgapb_prot dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13, absorb(cn) cl(cn) 
areg irepgapb_prof dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13, absorb(cn) cl(cn) 

*For females the coefficents are those for d3lit* (the same as explained above) for the regression below (with and without year FE)

areg isharew_ft dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13, absorb(cn) cl(cn) 
areg isharew_prot dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13, absorb(cn) cl(cn) 
areg isharew_prof dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13, absorb(cn) cl(cn) 

areg isharew_ft dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 
areg isharew_prot dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 
areg isharew_prof dlonly1-dlonly10 dlonly12-dlonly41 d3lit1-d3lit10 d3lit12-d3lit41 d1end1-d1end20 d1end22-d1end37 d1endbs1-d1endbs13 dyear2-dyear33, absorb(cn) cl(cn) 

