****Tables in Manuscript****

use HassellWylerPBTurk.dta, clear

**Table 1**

tab actcampvol
tab actwritten
tab actrally
tab pid3
tab ideology
tab collegeplus
tab age
tab income


**Table 2**
ttest writelette20, by (nnormact )
ttest writelette20 if activistre==0, by (nnormact)
ttest writelette20 if activistre==1, by (nnormact)

**Table 3**	
logit writelette20plus i.nnormact##activistre
logit writelette20plus i.nnormact##activistre efficacyre collegeplus income40to80K income80Kplus age

**Table 4**
ttest litanger, by (literposdescrpnorm )
ttest litenth, by (literposdescrpnorm )

**Table 5**
medeff (regress litanger nnormact) (logit writelette20plus litanger nnormact) if consistent==1, mediate (litanger) treat (nnormact ) sims(1000)
medeff (regress litanger nnormact) (logit writelette20plus litanger nnormact) if consistent==1 & activistre==0, mediate (litanger) treat (nnormact ) sims(1000)
medeff (regress litanger nnormact) (logit writelette20plus litanger nnormact) if consistent==1 & activistre==1, mediate (litanger) treat (nnormact ) sims(1000)

**Note: Figure 1 is generated from the values in Table 5**

**Table 6**
use InterestGroupFieldExperiment.dta, clear
ttest responded , by (negdescriptive )


****Tables in Appendix****

use HassellWylerPBTurk.dta, clear

**Table A.1**
hotelling ideology activistre pid7 efficacyre white age threeactivity, by (nnormact )

**Table A.2**
ttest writelette20 if actwritten==1, by (nnormact)
ttest writelette20 if actwritten==0, by (nnormact)
ttest writelette20 if actrally==1, by (nnormact)
ttest writelette20 if actrally==0, by (nnormact)
ttest writelette20 if actcampvol==1, by (nnormact)
ttest writelette20 if actcampvol==0, by (nnormact)

**Table A.3**
ttest writelette30, by (nnormact )
ttest writelette30 if activistre==1, by (nnormact )
ttest writelette30 if activistre==0, by (nnormact )
ttest writelette60, by (nnormact )
ttest writelette60 if activistre==1, by (nnormact )
ttest writelette60 if activistre==0, by (nnormact )
ttest writelette1 , by (nnormact )
ttest writelette1 if activistre==1, by (nnormact )
ttest writelette1 if activistre==0, by (nnormact )
ttest writelette20 if misscheck1==0 , by (nnormact )
ttest writelette20 if activistre==1 & misscheck1==0, by (nnormact )
ttest writelette20 if activistre==0 & misscheck1==0, by (nnormact )

