* This file conducts the analyses reported in Kinder and Ryan, "Prejudice and Politics Re-examined"
* Analysis was conducted on State/SE 13.1 for Mac (64-bit Intel) 

* Text description of AMP
use "xs_working.dta", clear
svyset [pw=postweight]
svy: mean propwpleas if white==1
svy: mean propbpleas if white==1
ttest propwpleas==propbpleas if white==1

* Text description of IAT
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: mean iat_d if white==1

* Text description of RR
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: mean resentx if white==1

* AMP / RR correlation in XS
use "xs_working.dta", clear
corr wbdif rresent if white==1 // .28
alpha ampitem2 ampitem3 ampitem4 ampitem5 ampitem6 ampitem7 ///
	ampitem8 ampitem9 ampitem10 ampitem11 ampitem12 ampitem13 ///
	ampitem14 ampitem15 ampitem16 ampitem17 ampitem18 ampitem19 ///
	ampitem20 ampitem21 ampitem22 ampitem23 ampitem24 if white==1, asis // AMP reliability = .85 
alpha V085143 V085144 V085145 V085146 if white==1, c // Resentment reliability .77
di .28 / sqrt(.85 * .77) // Correction for attenuation. .35

* IAT / RR correlation in Panel
use "panel_working.dta", clear
corr iat_d resentx if white==1 // .15
alpha iat_d12 iat_d34 // IAT reliability. .47
alpha rr1 rr2 rr3 rr4 if white==1 // Resentment reliability .80
di .15 / sqrt(.47*.80) // Correction for attenuation. .24

* Correlation between Racial resentment and all positive responses
* (Mentioned in footnote)
use "xs_working.dta", clear
pwcorr allpos rresent if white==1, sig
pwcorr allneg rresent if white==1, sig

* Table 1 - Sample characteristics (XS)
use "xs_working.dta", clear
svyset [pw=postweight]
svy: mean white
svy: mean black
svy: mean hispanic
svy: mean other

svy: prop educ // Education
svy: prop region // Region
svy: prop female // Gender
svy: prop agebin // Age

* Table 1 - Sample characteristics (Panel) 
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: prop der04 // Racial categories
svy: prop educ2 // Education
svy: prop region // Region
svy: prop female // Gender
svy: prop agebin2 // Age

* Figure 1 - AMP distribution (XS)
use "xs_working.dta", clear
set scheme sj
hist wbdif if white==1, percent ysc(r(0 30)) bin(17) yline(5 10 15 20 25 30) ylab(0(5)30) xtitle(AMP) xscale(r(-1 1)) xlab(-1(.5)1) xtitle(AMP)

* Figure 1 - IAT and Resentment distributions (Panel)
use "panel_working.dta", clear
set scheme sj
hist iat_d if white==1, percent ysc(r(0 30)) bin(17) yline(5 10 15 20 25 30) ylab(0(5)30) xtitle(IAT) xscale(r(-2 2)) xlab(-2(1)2) xtitle(IAT)
hist resentx if white==1, percent ysc(r(0 30)) bin(17) start(-1) yline(5 10 15 20 25 30) ylab(0(5)30) xscale(r(-1 1)) xlab(-1(.5)1) xtitle(Racial resentment)

* Table 2 - General election (XS)
use "xs_working.dta", clear
svyset [pw=postweight]
svy: probit mcvote wbdif2 pidr female age i.region i.educ if white==1
svy: probit mcvote rresent pidr female age i.region i.educ if white==1
svy: probit mcvote wbdif2 rresent pidr female age i.region i.educ if white==1

* Table 2 - General election (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: probit mcvote iat_d pidr2 female age i.region i.educ2 if white==1
svy: probit mcvote resentx pidr2 female age i.region i.educ2 if white==1
svy: probit mcvote iat_d resentx pidr2 female age i.region i.educ2 if white==1

* Table  3 - Primary election (XS)
use "xs_working.dta", clear
svyset [pw=preweight]
drop if V083098x==4 | V083098x==5 | V083098x==6 
svy: probit primvote wbdif2 pidstr female age i.region i.educ if white==1
svy: probit primvote rresent pidstr female age i.region i.educ if white==1
svy: probit primvote wbdif2 rresent pidstr female age i.region i.educ if white==1

* Table  3 - Primary election (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
drop if pidr==3 | pidr==4 // Drop Republicans
svy: probit primvote iat_d pidstr female age i.region i.educ2 if white==1
svy: probit primvote resentx pidstr female age i.region i.educ2 if white==1
svy: probit primvote iat_d resentx pidstr female age i.region i.educ2 if white==1

* Table 4 - Race policies (XS)
use "xs_working.dta", clear
svyset [pw=postweight]
svy: reg govassist wbdif2 pidr female age i.region i.educ  if white==1
svy: reg govassist rresent pidr female age i.region i.educ if white==1
svy: reg govassist wbdif2 rresent pidr female age i.region i.educ if white==1

svy: reg hireblacks wbdif2 pidr female age i.region i.educ if white==1
svy: reg hireblacks rresent pidr female age i.region i.educ if white==1
svy: reg hireblacks wbdif2 rresent pidr female age i.region i.educ if white==1

* Table 4 - Race policies (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: reg fairjobw11 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg fairjobw11 resentx pidr2 female age i.region i.educ2 if white==1
svy: reg fairjobw11 resentx iat_d pidr2 female age i.region i.educ2 if white==1

svy: reg hiringw11 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg hiringw11 resentx pidr2 female age i.region i.educ2 if white==1
svy: reg hiringw11 resentx iat_d pidr2 female age i.region i.educ2 if white==1

* Table 5 - Opposition to health reform (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: reg medcarew1 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew1 resentx pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew1 iat_d resentx pidr2 female age i.region i.educ2 if white==1

svy: reg medcarew10 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew10 resentx pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew10 iat_d resentx pidr2 female age i.region i.educ2 if white==1

* Table 6 - Approval of Obama (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: reg obdisapw19 iat_d obsupsum pidr2 female age i.region i.educ2 if white==1
svy: reg obdisapw19 resentx obsupsum pidr2 female age i.region i.educ2 if white==1
svy: reg obdisapw19 iat_d resentx obsupsum pidr2 female age i.region i.educ2 if white==1

* Table 7 - Obama as Muslim (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: probit obmuslimw11 iat_d knowlsum pidr2 female age i.region i.educ2 if white==1
svy: probit obmuslimw11 resentx knowlsum pidr2 female age i.region i.educ2 if white==1
svy: probit obmuslimw11 iat_d resentx knowlsum pidr2 female age i.region i.educ2 if white==1

* Table 2S (XS)
use "xs_working.dta", clear
svyset [pw=postweight]
svy: probit mcvote wbdif2 pidr  female age i.region i.educ if white==1
svy: probit mcvote stereo2 pidr female age i.region i.educ if white==1
svy: probit mcvote wbdif2 stereo2 pidr  female age i.region i.educ if white==1

* Table 2S (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: probit mcvote iat_d pidr2 female age i.region i.educ2 if white==1
svy: probit mcvote stereodif pidr2 female age i.region i.educ2 if white==1
svy: probit mcvote iat_d stereodif pidr2 female age i.region i.educ2 if white==1

* Table 3S (XS)
use "xs_working.dta", clear
svyset [pw=preweight]
drop if V083098x==4 | V083098x==5 | V083098x==6 
svy: probit primvote wbdif2 pidstr female age i.region i.educ  if white==1
svy: probit primvote stereo2 pidstr female age i.region i.educ if white==1
svy: probit primvote wbdif2 stereo2 pidstr female age i.region i.educ  if white==1

* Table 3S (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
drop if pidr==3 | pidr==4
svy: probit primvote iat_d pidstr female age i.region i.educ2 if white==1
svy: probit primvote stereodif pidstr female age i.region i.educ2 if white==1
svy: probit primvote iat_d stereodif pidstr female age i.region i.educ2 if white==1

* Table 4S (XS)
use "xs_working.dta", clear
svyset [pw=postweight]
svy: reg govassist wbdif2 pidr female age i.region i.educ  if white==1
svy: reg govassist stereo2 pidr female age i.region i.educ if white==1
svy: reg govassist wbdif2 stereo2 pidr female age i.region i.educ if white==1

svy: reg hireblacks wbdif2 pidr female age i.region i.educ  if white==1
svy: reg hireblacks stereo2 pidr female age i.region i.educ if white==1
svy: reg hireblacks wbdif2 stereo2 pidr female age i.region i.educ if white==1

* Table 4S (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: reg fairjobw11 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg fairjobw11 stereodif pidr2 female age i.region i.educ2 if white==1
svy: reg fairjobw11 stereodif iat_d pidr2 female age i.region i.educ2 if white==1

svy: reg hiringw11 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg hiringw11 stereodif pidr2 female age i.region i.educ2 if white==1
svy: reg hiringw11 stereodif iat_d pidr2 female age i.region i.educ2 if white==1

* Table 5S (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]
svy: reg medcarew1 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew1 stereodif pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew1 iat_d stereodif pidr2 female age i.region i.educ2 if white==1

svy: reg medcarew10 iat_d pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew10 stereodif pidr2 female age i.region i.educ2 if white==1
svy: reg medcarew10 iat_d stereodif pidr2 female age i.region i.educ2 if white==1

* Table 6S (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]

svy: reg obdisapw19 iat_d obsupsum pidr2 female age i.region i.educ2 if white==1
svy: reg obdisapw19 stereodif obsupsum pidr2 female age i.region i.educ2 if white==1
svy: reg obdisapw19 iat_d stereodif obsupsum pidr2 female age i.region i.educ2 if white==1


* Table 7S (Panel)
use "panel_working.dta", clear
svyset [pw=wgtpp20]

svy: probit obmuslimw11 iat_d knowlsum pidr2 female age i.region i.educ2 if white==1
svy: probit obmuslimw11 stereodif knowlsum pidr2 female age i.region i.educ2 if white==1
svy: probit obmuslimw11 iat_d stereodif knowlsum pidr2 female age i.region i.educ2 if white==1


