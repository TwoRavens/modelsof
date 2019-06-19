*This file allows you to replicate the short-term results in "The Power of the Pill for the Next Generation"

*Note from Hungerman to himself: the "master file" for this is RR_short_term_1trend_under21_6_09.do

**************************************************************************************************************************
*The variable treat_dum, tr_ab, ft2, abft2, agefake14 and abfake14 were constructed from data provided by Melani Guldi,  *
*Please contact her for the information needed to construct those variables. Or, with her permission, contact Hungerman. *
**************************************************************************************************************************

*The variables not included here are:
*treat_dum (not included) whether mom had access to pill in year of conception
*tr_ab (not included) whether mom had access to abortion
*agefake14 (not included) whether a 14 year old had pill access 
*abfake14 (not included) whether a 14 year old had aboriton access
*ft2 (not included) whether women will have access to pill in 2 years
*abft2 (not included) whether women will have abortion acces to pill in 2 years
*These variables are not included; their construction using Melani Guldi's data is described in the paper.


*The unit of analysis is all kids born in a given state and year, to mother's of a given age.

*The included variables are
* iur_gls -- unemployment as measured in GLS (Gruber, Levine, Staiger)'s QJE paper
* pcinc_gls  -- percapita income as measured in GLS
* crime_gls -- crime rage in GLS
* pctnonwh_gls -- perence of state population nonwhite, as in GLS
* T* -- state*year trends
* S* -- dummies for state of birth
* Y* -- year dummies
* A* -- dummies for mom's age
* astrend*  -- mom's age * state dummies.  ie, a "linear trend" not in time but in mom's age
* dm1l* -- moving averages of the dependent variables (construction described in the paper)
* good -- good is a dummy that = 1 if the year is greater than 1963 and if none of the key variables have missing values
* state -- state where cohort was born
* ys -- index for state and year
* year -- year born
* momage -- age of mother when cohort was born
* womenpop -- number of women in population (ie, number of possible moms--construction of this is described in paper)
* kidpop -- number of kids in population (ie, size of cohort)
* lfamwelf -- share of kids in a cohort in a household (HH) getting welfare, logged
* lonepar -- share of kids in a cohort in single-parent-household, logged
* lbelow -- share of kids in a cohort in HH below poverty, logged
* lbr -- birthrate (ie, kidpop/womenpop)
* lw -- log of womenpop variable (number of potential moms, logged)


use "MY DIRECTORY\replication_Power_Generation.dta"


*GLOBAL 
global gls "iur_gls pcinc_gls crime_gls pctnonwh_gls T* S* Y* A*"



*Table 1 Regressions
reg lbr treat_dum $gls astrend*  dm1lbr   [aweight = womenpop] if good==1, robust cluster(state)

reg lbr treat_dum lw $gls astrend*  dm1lbr  [aweight = womenpop] if good==1, robust cluster(state)

areg lbr treat_dum A* astrend*  dm1lbr  [aweight = womenpop] if good==1, robust cluster(state) absorb(ys)

areg lbr treat_dum lw A* astrend*  dm1lbr  [aweight = womenpop] if good==1, robust cluster(state) absorb(ys)



*Table 2 and Table 3 (panel A) regressions
foreach var in famwelf onepar below {

	reg  l`var' treat_dum $gls   dm1l`var'  astrend* [aweight = kidpop] if good==1 & year>1963, robust cluster(state)

	areg l`var' treat_dum A*   dm1l`var'  astrend* [aweight = kidpop] if good==1 & year>1963, robust cluster(state) absorb(ys)

	areg l`var' treat_dum tr_ab A*  dm1l`var'  astrend* [aweight = kidpop] if good==1 & year>1963, robust cluster(state) absorb(ys)

	}



*Panel B and C regressions from Table 3
reg lbr  agefake14 abfake14 $gls astrend*  dm1lbr   [aweight = womenpop] if momage>=21 & year>1963, robust cluster(state)

areg lbr treat_dum ft2 tr_ab abft2 A* astrend*  dm1lbr   [aweight = womenpop] if good==1 & year>1963, robust cluster(state) absorb(ys)


foreach var in famwelf onepar below {
	reg  l`var' agefake14 abfake14  $gls   dm1l`var'  astrend* [aweight = kidpop] if momage>=21 & year>1963, robust cluster(state)

	areg  l`var' treat_dum ft2 tr_ab abft2  A*  dm1l`var'  astrend* [aweight = kidpop] if  good==1  & year>1963, robust cluster(state) absorb(ys)
	}





*********Birthweight Regressions************
*These regressions are from a separate file

*This file is like the other file with a few trivial changes:
* the index for states and years is sy, instead of ys
* number of kids in a cohort is birthspop instead of kidpop
* llbw is the share of low birthweight birthsin a population, logged.


use MY DIRECTORY\replication_Power_Generation_bweight.dta

*Table 2
reg llbw treat_dum  $gls astrend* dm1llbw [aweight = birthspop] if good==1, robust cluster(state)

areg llbw treat_dum   A* astrend* dm1llbw [aweight = birthspop] if good==1, robust cluster(state) absorb(sy)

*Table 3
areg llbw treat_dum tr_ab   A* astrend* dm1llbw [aweight = birthspop] if good==1, robust cluster(state) absorb(sy)

reg llbw agefake14 abfake14   $gls astrend* dm1llbw [aweight = birthspop] if momage>=21 , robust cluster(state)

areg llbw treat_dum ft2 tr_ab abft2   A* astrend* dm1llbw [aweight = birthspop] if good==1, robust cluster(state) absorb(sy)







