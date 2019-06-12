
use "ncps2013.dta"

* key independent variable: contact

*personal
recode crime1 88/99=.
gen pers=crime1
*proximal
recode crime2 88/99=.

gen prox2=0
replace prox2=1 if crime2==1

* key dependent variable: participation

gen petition=0
replace petition=1 if polpar_1==1

gen voted=0
replace voted=1 if polpar_2==1

gen elect=0
replace elect=1 if polpar_3==1

gen community=0
replace community=1 if polpar_4==1

gen meeting=0
replace meeting=1 if polpar_5==1

gen org=0
replace org=1 if polpar_6==1

gen dem=0
replace dem=1 if polpar_7==1

gen letter=0
replace letter=1 if polpar_8==1

gen donate=0
replace donate=1 if polpar_9==1

gen act_item=petition+voted+elect+community+meeting+org+dem+letter+donate

* Injustice index

*comm police not valid
gen com_pol1 =crime4_1
recode com_pol1 88/99=. 1=4 4=1 2=3 3=2
*treat people fair and respect
gen com_pol2=crime4_2
recode com_pol2 88/99=. 
*violence
gen com_pol3=crime4_3
recode com_pol3 88/99=. 1=4 4=1 2=3 3=2

gen cpi1 = com_pol1+com_pol2+com_pol3
gen cpi=cpi1-3

* control vars

gen nonwhite=1
replace nonwhite=0 if race==1

gen white=0
replace white=1 if race==1

gen black=0
replace black=1 if race==2

gen asian=0
replace asian=1 if race==3

gen latino=0
replace latino=1 if race==4

gen oth_race=0
replace oth_race=1 if race==5 | race==6

gen edu4=educ2

gen inc20=0
replace inc20=1 if income==1

gen inc40=0
replace inc40=1 if income==2

gen inc60=0
replace inc60=1 if income==3

gen inc80=0
replace inc80=1 if income==4

gen inc100=0
replace inc100=1 if income==5

gen inc101=0
replace inc101=1 if income==6

gen incmis=0
replace incmis=1 if income==88|income==99

gen female=gender

gen church=0
replace church=1 if relatt==1 |relatt==2

gen republican=0
replace republican=1 if ptid1==1

gen independent=0
replace independent=1 if ptid1==3

gen young=0
replace young=1 if age==1
replace young=1 if age==2

gen old=0
replace old=1 if age==5

gen inteff=effbat_1
recode inteff 88/99=.

gen polint=.
replace polint=1 if interest==4
replace polint=2 if interest==3
replace polint=3 if interest==2
replace polint=4 if interest==1

save "ncps.dta", replace











