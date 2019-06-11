*****************************************
*Name: Martin Vinæs Larsen, Derek Beach and Kasper Møller Hansen*
*Date: September 2016*
*Purpose: Replication do-file for analyses in "How campaigns enhance European issues voting during European Parliament elections"*
*Data: orignaldataset.dta, survey data*
*Machine: Work Desktop*
*Version 13*
******************************************

use "original_dataset", clear


********************
*Recoding variables*
********************

*Gender
recode V2 2=0, gen(male)
la var male "Male (ref: Female)"

*Respondents region
la var region "Geographical region"

*Respondent's education
la var ny_udd "Educational attainment"

*Wave (Boelge in Danish) variable. From counting wave number to measuring distance to election
gen wave=14-2*Boelge
la var wave "Weeks until election"

*Coding whether voters answered correctly (1)or not (0) about policy positions
*of the three largest Danish Parties Socialde (Social Democrats) DF (Dansish peoples party) Venstre (Liberal party)
gen patent_cor= (Socialde +DF_A +Venstre_)/3 *100
la var patent_cor "Knowledge: Patent court"

*Interest in EU politics and politics in ggeneral.
gen int_dk=(5-V5_1)/4 *100
gen int_eu=(5-V5_2)/4 *100
la var int_eu "Interest in EU politics"
la var int_dk "Interest in politics"


*Counting number of Don' knows on five issue attitudes, and the creating measure for fraction of not Dont know ansers answers.
gen dk=0
foreach x in V21_V21_ V21_V22_ V23 V27_V27_ V27_V28_ {
replace dk=dk+1 if `x'==6
}
replace dk=100-(dk/5)*100
la var dk "Informed"

*Checking for straight-lining on these five variables
gen dk_sl=0
replace dk_sl=dk_sl+2 if V21_V21_==V21_V22_==V23==V27_V27_==V27_V28_
ta dk_sl //only 14 respondents straight-lining
la var dk_sl "Straight lining for Don't Know Answers"

**Creating variable for government voters and pro-EU voters using variable measuring intent to vote (V30)
recode  V30 (5 6 8=0 "neg") (1 2 3 4 7= 1 "pro") (else=.), gen(party_pro)
recode  V30 ( 1 2=1 "gov") ( 3 4 6 7 8= 0 "non-gov") (else=.), gen(gov)
la var gov 	"Government voters"	
la var party_pro "Integrationist voters"


*From bith-year to age-
gen age=2014-V1
*Age groups for representativity analysis.
recode age (18/39=1) (40/59=2)( 60/100=3), gen(agegrp)
la var age "Age in years"

*Creating variable indicating how people reported voting in last nat election
rename V25 parlvote

* Also create variables measuring whether you vote for pro-eu / government party party at last election
gen lparty_pro=0
replace lparty_pro=1 if parlvote==1 | parlvote==2 | parlvote==3 | parlvote==4 | parlvote==7
gen lgov=0
replace lgov=1 if parlvote==1 | parlvote==2

la var lgov "Voted for government party at last national election"
la var lparty_pro "Voted for Pro-EU party at last national election"

*Creating variable measuring people's beliefs about government.
gen eval= 10*(5-V8)/4
la var eval "Pro-government attitudes"

*Creating index based of integration attitudes, svaing the constitutive items for further analysis
recode V19 V20 (6=.)
gen integration=(1-((V19+(6-V20))-2)/8)*10
ta integration
rename V19 int_advantage
rename V20 int_leaveorstay
la var int_leaveorstay  "Should Denmark leave or stay?"
la var int_advantage  "Has EU been advantage for DK?"

la var integration "Pro-integration attitudes"


*National economic perceptions
gen econ=(5-V12_V14_)/4 if V12_V14_ < 6
la var econ "National Economic Perceptions"

* Ideology
gen ideology=(V24_1_-1) if V24_1_ < 11
la var ideology "Ideology"

**Keeping recoded variables and saving replicationdataset
keep patent_cor wave integration male int_dk  int_leaveorstay int_advantage ny_udd parlvote age agegrp  int_eu dk gov party_pro eval econ ideology  lgov lparty_pro region dk_sl


**
saveold survey.dta, replace

