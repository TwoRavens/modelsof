/* Replication File for "Attitudes Toward Consent-Based and Non-Consent-Based International Law 
 in a Regional Power Context" by Evangeline Reynolds, Amâncio Jorge Oliveira, Janina Onuki, and
 Matthew S. Winters */

/* November 2017 */

/* The file ReynoldsEtAl_RawData.dta contains data collected by IBOPE as part of the 
 monthly IBOPEBus survey in October 2015.  The survey uses probability-proportional-to-size 
 sampling to choose cities from 25 of the 27 federal units that define Brazil (with a rotation 
 among the three smallest states in Brazil) followed by probability-proportional-to-size sampling 
 of census tracts within those cities.  Individual respondents are then recruited using a quota 
 sampling scheme that produces a sample representative of the overall Brazilian population. */
 
/* Description of Variables in Raw Data

SbjNum - unique respondent identifier
sexo - male (1) / female (2)
idade - age in years
inst - schooling (10 categories)
P1 - When you hear the news, how interested are you in Brazil’s relations with other countries: 
 very interested, relatively interested, only a little bit interested, or not interested?
P2 - With regard to strengthening commercial ties and business between Brazil and other countries, 
 do you think this is good for Brazil, bad for Brazil, or does it not have an effect on Brazil?
P301 - P304 - Do you believe that Brazil should honor {its international legal obligations in this area / 
  its obligations under the Nuclear Non-Proliferation Treaty / its obligations under this U.N. 
  Security Council Resolution} even if it is costly to do so?  Yes or no?
P4 - If Brazil stops the required monitoring of nuclear materials, do you think that its international 
 reputation will suffer?  Yes or no?
P5 - If Brazil stops the required monitoring of nuclear materials, do you think that other countries 
 will try to punish Brazil in some way, for example, by imposing trade sanctions?  Yes or no?
P6 - In your opinion, should Brazil pursue a permanent seat on the U.N. Security Council?  Yes or no?
P7 - Thinking back to earlier in the survey when I told you about Brazil’s international legal obligations 
 to monitor nuclear materials, do you remember where those international obligations came from?  Were 
 they from a treaty that Brazil signed; a U.N. Security Council Resolution that Brazil voted on; a 
 U.N. Security Council Resolution that Brazil did not vote on; or did I not say?
P8 - For which candidate or party did you vote in the second round of the last election?
 Dilma Rousseff (PT), Aecio Neves (PSDB), or Null/Blank
P9 - To which of the following political parties do you feel closest? 
 List of 27 parties
REND1 - personal income in number of minimum salaries
REND2 - household income in number of minimum salaries
cond - type of city: capital, periphery, interior
porte - size of city
porte - size of city
reg - region
uf - state
idadcr - age category
classe - social class
raca - race
reli - religion										*/

use "ReynoldsEtAl_RawData.dta"

/*************/
/* Recodings */
/*************/

* Treatment Conditions

gen generic = 1 if P301!=.
replace generic = 0 if generic==.
gen npt = 1 if P302!=.
replace npt = 0 if npt==.
gen unsc_no = 1 if P303!=.
replace unsc_no = 0 if unsc_no==.
gen unsc_yes = 1 if P304!=.
replace unsc_yes = 0 if unsc_yes==.

gen condition = 0 if generic==1
replace condition = 1 if npt==1
replace condition = 2 if unsc_no==1
replace condition = 3 if unsc_yes==1

* Comparisons

gen npt_vs_generic = 0 if generic==1
replace npt_vs_generic = 1 if npt==1
gen unsc_no_vs_generic = 0 if generic==1
replace unsc_no_vs_generic = 1 if unsc_no==1
gen unsc_yes_vs_generic = 0 if generic==1
replace unsc_yes_vs_generic = 1 if unsc_yes==1
gen unsc_no_vs_npt = 0 if npt==1
replace unsc_no_vs_npt = 1 if unsc_no==1
gen unsc_no_vs_unsc_yes = 0 if unsc_yes==1
replace unsc_no_vs_unsc_yes = 1 if unsc_no==1

gen any_vs_generic = 0 if generic==1
replace any_vs_generic = 1 if generic!=1

* Outcome Variables

gen comply = P301 
replace comply = P302 if P302!=.
replace comply = P303 if P303!=.
replace comply = P304 if P304!=.
replace comply = . if comply==9
recode comply (2=0)

recode P4 (2=0) (9=.), gen(reputation)
recode P5 (2=0) (9=.), gen(sanctions)

* Demographic and Background Variables

recode sexo (2=0), gen(male)

recode raca (1=0) (2/5=1) (9=.), gen(nonwhite)

gen catholic = 1 if reli==1
replace catholic = 0 if reli!=1 & reli < 99

gen other_rel = 1 if reli > 1 & reli < 19
replace other_rel = 0 if reli==1 | reli==19 | reli==20

recode P1 (1=4) (2=3) (3=2) (4=1) (5=.), gen(intl_interest)
recode P2 (1=3) (3=1) (4=.), gen(intl_good)

* Conditioning Variable

gen intlist = 0
replace intlist = 1 if intl_interest==4 | intl_good==3

/****************************************/
/* Appendix Table 1: Summary Statistics */
/****************************************/

sum male
sum idade
sum inst
sum classe
sum nonwhite
sum catholic
sum other_rel
sum intl_interest
sum intl_good

/******************************************************/
/* Balance Check Described in Research Design Section */
/******************************************************/

mlogit condition sexo idade inst classe nonwhite catholic other_rel intl_interest intl_good

/**********************************/
/* Table 2: Main Outcome Variable */
/**********************************/

prtest comply, by(npt_vs_generic)
prtest comply, by(unsc_no_vs_generic)
prtest comply, by(unsc_yes_vs_generic)

prtest comply, by(unsc_no_vs_npt)
prtest comply, by(unsc_no_vs_unsc_yes)

/*******************************************/
/* Appendix Table 2: Regression-Based Test */
/*******************************************/

reg comply npt unsc_no unsc_yes male idade inst classe nonwhite catholic other_rel intl_interest intl_good, robust

/********************************/
/* Table 3: Mechanism Variables */
/********************************/

prtest reputation, by(npt_vs_generic)
prtest reputation, by(unsc_no_vs_generic)
prtest reputation, by(unsc_yes_vs_generic)

prtest sanction, by(npt_vs_generic)
prtest sanction, by(unsc_no_vs_generic)
prtest sanction, by(unsc_yes_vs_generic)

prtest reputation, by(any_vs_generic)
prtest sanction, by(any_vs_generic)

/******************************/
/* Table 4: Subgroup Analyses */
/******************************/

/* High Education */
prtest comply if inst >=8, by(npt_vs_generic)
prtest comply if inst >=8, by(unsc_no_vs_generic)
prtest comply if inst >=8, by(unsc_yes_vs_generic)

/* Low Education (Not Reported in Table) */
prtest comply if inst <8, by(npt_vs_generic)
prtest comply if inst <8, by(unsc_no_vs_generic)
prtest comply if inst <8, by(unsc_yes_vs_generic)

/* Internationalists */
prtest comply if intlist==1, by(npt_vs_generic)
prtest comply if intlist==1, by(unsc_no_vs_generic)
prtest comply if intlist==1, by(unsc_yes_vs_generic)

/* Non-Internationalists (Not Reported in Table) */
prtest comply if intlist==0, by(npt_vs_generic)
prtest comply if intlist==0, by(unsc_no_vs_generic)
prtest comply if intlist==0, by(unsc_yes_vs_generic)




/* End of File */




