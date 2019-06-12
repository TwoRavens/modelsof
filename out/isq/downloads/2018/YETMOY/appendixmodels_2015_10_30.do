cd "C:\Dropbox\WTO Deter Local\"
use working_2014_07_11_ctrl_disp.dta, clear


global ctrl1 "resp_polity_it lnpc logged_resp crisistally"



*** Appendix TABLE 1: Baseline Results, with POST dispute variable ***
* Table 2 replicated with the disputePOST indicator
*		The dispute indicator indicates that a dispute has been concluded (status!=0,4)

* Full sample
xtreg logimports96 disputepost $ctrl1, fe robust cluster(st1)
	est2vec disputepostT1, vars(disputepost demean_disputepost $ctrl1) replace
xtreg demean_logimports96 demean_disputepost, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(wctrl)
* Exclude USA/EU
xtreg logimports96 disputepost $ctrl1 if st1!=2 & st1!=3, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(nouseuA)
xtreg demean_logimports96 demean_disputepost if st1!=2 & st1!=3, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(nouseuB)
* OECD Only, non-OECD only
xtreg logimports96 disputepost $ctrl1 if oecd==1, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(oecdA)
xtreg demean_logimports96 demean_disputepost if oecd==1, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(oecdB)
xtreg logimports96 disputepost $ctrl1 if oecd==0, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(nonoecdA)
xtreg demean_logimports96 demean_disputepost if oecd==0, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(nonoecdB)
* Exclude steel
xtreg logimports96 disputepost $ctrl1 if steel!=1, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(nosteelA)
xtreg demean_logimports96 demean_disputepost if steel!=1, fe robust cluster(st1)
	est2vec allvecb, addto(disputepostT1) name(nosteelB)

	est2tex disputepostT1, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace

	
*** Appendix TABLE 2: Lagged disputeposts ***
	* Replication of Table 3, using the dispute post variable
	xtset st1hs_num year
* Note: this generates the lagged disputePOST variables
	gen l1disputepost = l.disputepost
	gen l1demean_disputepost = l.demean_disputepost
	gen l2disputepost = l.l1disputepost
	gen l2demean_disputepost = l.l1demean_disputepost
	gen l3disputepost = l.l2disputepost
	gen l3demean_disputepost = l.l2demean_disputepost
	gen l4disputepost = l.l3disputepost
	gen l4demean_disputepost = l.l3demean_disputepost
	gen l5disputepost = l.l4disputepost
	gen l5demean_disputepost = l.l4demean_disputepost
	gen l6disputepost = l.l5disputepost
	gen l6demean_disputepost = l.l5demean_disputepost
*	
xtreg logimports96 l1disputepost $ctrl1, fe robust cluster(st1)
	est2vec lagdisputepost, vars(l1disputepost l1demean_disputepost l2disputepost l2demean_disputepost l3disputepost l3demean_disputepost l4disputepost l4demean_disputepost l5disputepost l5demean_disputepost l6disputepost l6demean_disputepost $ctrl1) replace
xtreg demean_logimports96 l1demean_disputepost, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagoneb)
xtreg logimports96 l2disputepost $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagtwoa)
xtreg demean_logimports96 l2demean_disputepost, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagtwob)
xtreg logimports96 l3disputepost $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagthreea)
xtreg demean_logimports96 l3demean_disputepost, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagthreeb)
xtreg logimports96 l4disputepost $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagfoura)
xtreg demean_logimports96 l4demean_disputepost, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagfourb)
xtreg logimports96 l5disputepost $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagfivea)
xtreg demean_logimports96 l5demean_disputepost, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagfiveb)
xtreg logimports96 l6disputepost $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagsixa)
xtreg demean_logimports96 l6demean_disputepost, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputepost) name(lagsixb)

	est2tex lagdisputepost, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace


*** Appendix table 3: Dispute Status ***	
	* Replication of Table 4, only using three dispute statuses
* 0 = pre
* 1 = ongoing
* 2 = post
gen status3_0 = 0
gen status3_1 = 0
gen status3_2 = 0
replace status3_0 = 1 if status==0
replace status3_1 = 1 if status==4
replace status3_2 = 1 if status==1 | status==2 | status==3
* Note, rather than demeaning these, I just used reg2hdfe

reg2hdfe logimports96 status3_1 status3_2, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec dis3cat2hdfe, vars(status3_1 status3_2) replace
reg2hdfe logimports96 status3_1 status3_2 if st1!=2 & st1!=3, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(dis3cat2hdfe) name(nouseu)
reg2hdfe logimports96 status3_1 status3_2 if oecd==1, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(dis3cat2hdfe) name(oecd)
reg2hdfe logimports96 status3_1 status3_2 if oecd==0, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(dis3cat2hdfe) name(nooecd)
reg2hdfe logimports96 status3_1 status3_2 if steel!=1, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(dis3cat2hdfe) name(nosteel)

	est2tex dis3cat2hdfe, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace


	
	
	
*** Appendix Tables 4,5, and 6: only disputes that concluded in or before 2000, 2002, and 2005
*	I picked these years because 44.4%, 84.01%, and 93.55% of the sample involves disputes that concluded during or before that year, respectively.
	* Replicates Table 2: Baseline Results ***
foreach i in 2000 2002 2005 {

* Full sample
xtreg logimports96 dispute $ctrl1 if minendyear<=`i', fe robust cluster(st1)
	est2vec disputeend`i', vars(dispute demean_dispute $ctrl1) replace
xtreg demean_logimports96 demean_dispute if minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(wctrl)
* Exclude USA/EU
xtreg logimports96 dispute $ctrl1 if st1!=2 & st1!=3 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(nouseuA)
xtreg demean_logimports96 demean_dispute if st1!=2 & st1!=3 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(nouseuB)
* OECD Only, non-OECD only
xtreg logimports96 dispute $ctrl1 if oecd==1 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(oecdA)
xtreg demean_logimports96 demean_dispute if oecd==1 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(oecdB)
xtreg logimports96 dispute $ctrl1 if oecd==0 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(nonoecdA)
xtreg demean_logimports96 demean_dispute if oecd==0 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(nonoecdB)
* Exclude steel
xtreg logimports96 dispute $ctrl1 if steel!=1 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(nosteelA)
xtreg demean_logimports96 demean_dispute if steel!=1 & minendyear<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeend`i') name(nosteelB)

	est2tex disputeend`i', preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace

	}
*


*** Appendix Tables 7,8, and 9
	* Replicating Table 2, but excluding disputes that name a ton of products
	* Excluding importer-products where the first dispute covered more than 26, 100, and 750 HS6 products.
	* The percentages of observations with disputes with less than 26,100,750 products are 9.79%, 25.23%, 82.72% respectively.
set more off
replace averageproducts=0 if averageproducts==.

foreach i in 26 100 750 {

*** TABLE 1: Baseline Results ***
* Full sample
xtreg logimports96 disputepost $ctrl1 if averageproducts<=`i', fe robust cluster(st1)
	est2vec disputeavprod`i', vars(disputepost demean_disputepost $ctrl1) replace
xtreg demean_logimports96 demean_disputepost if averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(wctrl)
* Exclude USA/EU
xtreg logimports96 disputepost $ctrl1 if st1!=2 & st1!=3 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(nouseuA)
xtreg demean_logimports96 demean_disputepost if st1!=2 & st1!=3 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(nouseuB)
* OECD Only, non-OECD only
xtreg logimports96 disputepost $ctrl1 if oecd==1 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(oecdA)
xtreg demean_logimports96 demean_disputepost if oecd==1 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(oecdB)
xtreg logimports96 disputepost $ctrl1 if oecd==0 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(nonoecdA)
xtreg demean_logimports96 demean_disputepost if oecd==0 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(nonoecdB)
* Exclude steel
xtreg logimports96 disputepost $ctrl1 if steel!=1 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(nosteelA)
xtreg demean_logimports96 demean_disputepost if steel!=1 & averageproducts<=`i', fe robust cluster(st1)
	est2vec allvecb, addto(disputeavprod`i') name(nosteelB)

	est2tex disputeavprod`i', preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace
	}
*



*** Appendix Tables 10 and 11
	* Replication of Tables 2 and 3, but excluding disputes that were export oriented
* Recoding the dispute variable so that it equals zero if the dispute is export-oriented
gen disputeNOXP = dispute
replace disputeNOXP = 0 if exportoriented==1
gen demean_disputeNOXP = demean_dispute
replace demean_disputeNOXP = 0 if exportoriented==1

*** TABLE 2: Baseline Results ***
* Full sample
xtreg logimports96 disputeNOXP $ctrl1, fe robust cluster(st1)
	est2vec disputeNOXPT1, vars(disputeNOXP demean_disputeNOXP $ctrl1) replace
xtreg demean_logimports96 demean_disputeNOXP, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(wctrl)
* Exclude USA/EU
xtreg logimports96 disputeNOXP $ctrl1 if st1!=2 & st1!=3, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(nouseua)
xtreg demean_logimports96 demean_disputeNOXP if st1!=2 & st1!=3, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(nouseub)
* OECD Only, non-OECD only
xtreg logimports96 disputeNOXP $ctrl1 if oecd==1, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(oecda)
xtreg demean_logimports96 demean_disputeNOXP if oecd==1, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(oecdb)
xtreg logimports96 disputeNOXP $ctrl1 if oecd==0, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(nooecda)
xtreg demean_logimports96 demean_disputeNOXP if oecd==0, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(nooecdb)
* Exclude steel
xtreg logimports96 disputeNOXP $ctrl1 if steel!=1, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(nosteela)
xtreg demean_logimports96 demean_disputeNOXP if steel!=1, fe robust cluster(st1)
	est2vec allvecb, addto(disputeNOXPT1) name(nosteelb)

	est2tex disputeNOXPT1, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace

set more off
*** TABLE 3: Lagged Disputes ***
	xtset st1hs_num year
* Note: this generates the lagged variables
	gen l1disputeNOXP = l.disputeNOXP
	gen l1demean_disputeNOXP = l.demean_disputeNOXP
	gen l2disputeNOXP = l.l1disputeNOXP
	gen l2demean_disputeNOXP = l.l1demean_disputeNOXP
	gen l3disputeNOXP = l.l2disputeNOXP
	gen l3demean_disputeNOXP = l.l2demean_disputeNOXP
	gen l4disputeNOXP = l.l3disputeNOXP
	gen l4demean_disputeNOXP = l.l3demean_disputeNOXP
	gen l5disputeNOXP = l.l4disputeNOXP
	gen l5demean_disputeNOXP = l.l4demean_disputeNOXP
	gen l6disputeNOXP = l.l5disputeNOXP
	gen l6demean_disputeNOXP = l.l5demean_disputeNOXP
*
	
xtreg logimports96 l1disputeNOXP $ctrl1, fe robust cluster(st1)
	est2vec lagdisputeNOXP, vars(l1disputeNOXP l1demean_disputeNOXP l2disputeNOXP l2demean_disputeNOXP l3disputeNOXP l3demean_disputeNOXP l4disputeNOXP l4demean_disputeNOXP l5disputeNOXP l5demean_disputeNOXP l6disputeNOXP l6demean_disputeNOXP $ctrl1) replace
xtreg demean_logimports96 l1demean_disputeNOXP, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagoneb)
xtreg logimports96 l2disputeNOXP $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagtwob)
xtreg demean_logimports96 l2demean_disputeNOXP, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagtwobb)
xtreg logimports96 l3disputeNOXP $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagthreeb)
xtreg demean_logimports96 l3demean_disputeNOXP, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagthreebb)
xtreg logimports96 l4disputeNOXP $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagfoura)
xtreg demean_logimports96 l4demean_disputeNOXP, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagfourb)
xtreg logimports96 l5disputeNOXP $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagfivea)
xtreg demean_logimports96 l5demean_disputeNOXP, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagfiveb)
xtreg logimports96 l6disputeNOXP $ctrl1, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagsixba)
xtreg demean_logimports96 l6demean_disputeNOXP, fe robust cluster(st1)
	est2vec allvecb, addto(lagdisputeNOXP) name(lagsixb)

	est2tex lagdisputeNOXP, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace


	
	
*** Appendix Tables 12, 13, and 14: Replications using 2,3,5 years before the dispute as the reference window
bysort st1hs_num: egen firstdisyear_xx = min(year) if dispute==1
bysort st1hs_num: egen firstdisyear = min(firstdisyear_xx)
drop*_xx

foreach i in 2 3 5 {

* Full sample
xtreg logimports96 dispute $ctrl1 if year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec preyears`i', vars(dispute demean_dispute $ctrl1) replace
xtreg demean_logimports96 demean_dispute if year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(wctrl)
* Exclude USA/EU
xtreg logimports96 dispute $ctrl1 if st1!=2 & st1!=3 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(nouseuA)
xtreg demean_logimports96 demean_dispute if st1!=2 & st1!=3 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(nouseuB)
* OECD Only, non-OECD only
xtreg logimports96 dispute $ctrl1 if oecd==1 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(oecdA)
xtreg demean_logimports96 demean_dispute if oecd==1 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(oecdB)
xtreg logimports96 dispute $ctrl1 if oecd==0 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(nonoecdA)
xtreg demean_logimports96 demean_dispute if oecd==0 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(nonoecdB)
* Exclude steel
xtreg logimports96 dispute $ctrl1 if steel!=1 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(nosteelA)
xtreg demean_logimports96 demean_dispute if steel!=1 & year>=firstdisyear - `i', fe robust cluster(st1)
	est2vec allvecb, addto(preyears`i') name(nosteelB)

	est2tex preyears`i', preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace

	}
*


*** Additional Tests that aren't in the paper or appendix
* These are things we did over the course of writing the paper
* Some are also things we did to show reviewers that didn't make the appendix
*	1) Replicating the main results using reg2hdfe, instead of manually demeaning, to make sure results are similar
*	2) Power tests, to make sure that null results weren't because of insufficient power
*	3) Models allowing across-product comparisons (no product FE)
*	4) Models with SE clustered at the country product level

*** Stephen Check: reg2hdfe
*	In the original paper, I manually within-transformed the variables to account for the importer-year FE's and let Stata handle the importer-product FEs.
*	I wanted to double check that what I did yields very similar results as the reg2hdfe command, which is specifically designed for two-way, high dimensional FEs.
*	Results are pretty similar.  Whew.

cd "C:\Dropbox\WTO Deter Local\"
use working_2014_07_11_ctrl_disp.dta, clear

*** TABLE 1: Baseline Results ***
reg2hdfe logimports96 dispute, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec disputehdfeT1, vars(dispute) replace
* Exclude USA/EU
reg2hdfe logimports96 dispute if st1!=2 & st1!=3, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT1) name(nouseu)
* OECD Only, non-OECD only
reg2hdfe logimports96 dispute  if oecd==1, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT1) name(oecd)
reg2hdfe logimports96 dispute  if oecd==0, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT1) name(nooecd)
* Exclude steel
reg2hdfe logimports96 dispute  if steel!=1, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT1) name(nosteel)

	est2tex disputehdfeT1, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace


*** TABLE 2: Lagged Disputes ***
	xtset st1hs_num year
* Note: this generates the lagged variables
	gen l1dispute = l.dispute
	gen l2dispute = l.l1dispute
	gen l3dispute = l.l2dispute
	gen l4dispute = l.l3dispute
	gen l5dispute = l.l4dispute
	gen l6dispute = l.l5dispute
*
	
reg2hdfe logimports96 l1dispute, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec disputehdfeT2, vars(l1dispute l2dispute l3dispute l4dispute l5dispute l6dispute) replace
reg2hdfe logimports96 l2dispute, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT2) name(lagtwo)
reg2hdfe logimports96 l3dispute, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT2) name(lagthree)
reg2hdfe logimports96 l4dispute, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT2) name(lagfour)
reg2hdfe logimports96 l5dispute, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT2) name(lagfive)
reg2hdfe logimports96 l6dispute, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT2) name(lagsix)

	est2tex disputehdfeT2, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace
	
*** TABLE 3: Dispute Status ***
reg2hdfe logimports96 status_1 status_2 status_3 status_4, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec disputehdfeT3, vars(status_1 status_2 status_3 status_4) replace
reg2hdfe logimports96 status_1 status_2 status_3 status_4 if st1!=2 & st1!=3, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT3) name(nouseu)
reg2hdfe logimports96 status_1 status_2 status_3 status_4 if oecd==1, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT3) name(oecd)
reg2hdfe logimports96 status_1 status_2 status_3 status_4 if oecd==0, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT3) name(nooecd)
reg2hdfe logimports96 status_1 status_2 status_3 status_4 if steel!=1, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec allvecb, addto(disputehdfeT3) name(nosteel)

	est2tex disputehdfeT3, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace


*** TABLE 4: Dispute Issues ***
reg2hdfe logimports96 dispute safeguards sps agriculture ad, id1(st1hs_num) id2(st1yr_num) cluster(st1)
	est2vec disputehdfeT4, vars(dispute safeguards sps agriculture ad) replace

	est2tex disputehdfeT4, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace
	

	

	
*** Power Tests
cd "C:\Dropbox\WTO Deter Local\"
use working_2014_07_11_ctrl_disp.dta, clear
global ctrl1 "resp_polity_it lnpc logged_resp crisistally"

* Power analysis without FE
reg logimports96 dispute $ctrl1, robust cluster(st1)
reg logimports96 $ctrl1, robust cluster(st1)
powerreg, r2f(0.1696) r2r(0.1688) nvar(5) ntest(1) power(0.7)
powerreg, r2f(0.1696) r2r(0.1688) nvar(5) ntest(1) power(0.99)
powerreg, r2f(0.1696) r2r(0.1688) nvar(5) ntest(5) power(0.99)

* Even conservatively, we can lower the R2 values by a factor of 10 and still be within our sample size
powerreg, r2f(0.01696) r2r(0.01688) nvar(5) ntest(1) power(0.99)

* Without FE, on the "effective sample"
bysort st1hs_num: egen maxdispute = max(disputed)
reg logimports96 dispute $ctrl1 if maxdispute==1, robust cluster(st1)
reg logimports96 $ctrl1 if maxdispute==1, robust cluster(st1)
powerreg, r2f(0.1679) r2r(0.1438) nvar(5) ntest(1) power(0.7)
powerreg, r2f(0.1679) r2r(0.1438) nvar(5) ntest(1) power(0.99)




*** Across-product comparison models
cd "C:\Dropbox\WTO Deter Local\"
use working_2014_07_11_ctrl_disp.dta, clear
global ctrl1 "resp_polity_it lnpc logged_resp crisistally"

rename year_num yearnum
reg logimports96 dispute $ctrl1 year_*, robust cluster(st1)
	est sto crossprod1
areg logimports96 dispute, absorb(st1yr_num) robust cluster(st1)
	est sto crossprod2
est table crossprod*, b(%3.2f) star(.1 .05 .01) stat(r2 N) 

esttab crossprod* using "C:\Dropbox\WTO Deter Local\Drafts_CKP\crossprod.tex", cells(b(star fmt(2)) se(par fmt(2))) ///
	starlevels(+ 0.10 * 0.05 ** 0.01) style(tex) r2(%3.2f) ///
	replace label ///
 	addnote(+ $ p < .10 $, * $ p < .05 $, ** $ p < .01 $) ///
	title("Across Products Comparisons \label{tab:crossprod}")


	
*** Reviewer 1: observations iid
* Table 1 replicated with clustering at the country-product level

*** TABLE 1: Baseline Results ***
* Full sample
xtreg logimports96 dispute $ctrl1, fe robust cluster(st1hs_num) nonest
	est2vec disputeT1clust, vars(dispute demean_dispute $ctrl1) replace
xtreg demean_logimports96 demean_dispute, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(wctrl)
* Exclude USA/EU
xtreg logimports96 dispute $ctrl1 if st1!=2 & st1!=3, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(nouseuA)
xtreg demean_logimports96 demean_dispute if st1!=2 & st1!=3, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(nouseuB)
* OECD Only, non-OECD only
xtreg logimports96 dispute $ctrl1 if oecd==1, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(oecdA)
xtreg demean_logimports96 demean_dispute if oecd==1, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(oecdB)
xtreg logimports96 dispute $ctrl1 if oecd==0, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(nonoecdA)
xtreg demean_logimports96 demean_dispute if oecd==0, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(nonoecdB)
* Exclude steel
xtreg logimports96 dispute $ctrl1 if steel!=1, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(nosteelA)
xtreg demean_logimports96 demean_dispute if steel!=1, fe robust cluster(st1hs_num) nonest
	est2vec allvecb, addto(disputeT1clust) name(nosteelB)

	est2tex disputeT1clust, preserve path("C:\Dropbox\WTO Deter Local\Drafts_CKP") mark(stars) fancy replace

