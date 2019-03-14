
use "anes_timeseries_2016.dta"
* recode some variables

* key independent variable: contact

gen prox=0
replace prox=1 if V162297==1

gen pers=0
replace pers=1 if V162298==1

* key dependent variables
** in the last 12 months

gen protest=0 
replace protest =1 if V162018a==1

gen petition=0
replace petition=1 if V162018b==1

gen don_rel=0
replace don_rel=1 if V162018c==1

gen don_soc=0
replace don_soc=1 if V162018d==1

gen community = 0
replace community = 1 if V162195==1

gen meet = 0
replace meet =1 if V162196==1

gen volunteer= 0
replace volunteer=1 if V162197 ==1

gen contact_fed=0
replace contact_fed=1 if V162198==1 
replace contact_fed=1 if V162200==1

gen contact_local=0
replace contact_local=1 if V162202==1
replace contact_local=1 if V162204==1

gen official=0
replace official=1 if contact_fed==1
replace official=1 if contact_local==1

gen voted=0
replace voted=1 if V162031==4

gen ai=protest+petition+don_rel+don_soc+voted+community+meet+volunteer+official

alpha protest petition don_rel don_soc voted community meet volunteer official


* control variables

gen nonwhite=0
replace nonwhite=1 if V161310x > 1

gen black=0 
replace black=1 if V161310x ==2

gen latino=0
replace latino=1 if V161310x ==5

gen oth_race=0
replace oth_race=1 if V161310x ==3 | V161310x ==4 |V161310x ==6

gen incmis=0
replace incmis=1 if V161361x == -9 | V161361x== -5

gen inc20=0
replace inc20=1 if V161361x > 0 & V161361x < 7  

gen inc40=0
replace inc40=1 if V161361x > 6 & V161361x < 13 

gen inc60=0
replace inc60=1 if V161361x > 12 & V161361x < 17 

gen inc80=0
replace inc80=1 if V161361x > 16 & V161361x < 21

gen inc100=0
replace inc100=1 if V161361x > 20 & V161361x < 23

gen inc101=0
replace inc101=1 if V161361x > 22

gen edu4=0
replace edu4=1 if V161270 < 9
replace edu4=2 if V161270 > 8 & V161270 <10
replace edu4=3 if V161270 >9 & V161270 <13
replace edu4=4 if V161270 > 12

gen fem=0
replace fem=1 if V161342==2

gen age=2016-V161267c
replace age=. if age >90
gen young=0 
replace young=1 if age < 36
gen old=0
replace old=1 if age >64


gen rep=0
replace rep=1 if V161155==2

gen dem=0
replace dem=1 if V161155==1

gen ind=0
replace ind=1 if V161155==3

gen inteff=V162217
replace inteff=. if inteff<0

gen polint=V161009
replace polint=. if polint <0
recode polint 1= 5 5=1 2=4 4=2

gen church=0
replace church=1 if V161245 == 1 |V161245==2

* how much have you personally faced? V162367

gen disc=0
replace disc=1 if V162367==4
replace disc=2 if V162367==3
replace disc=3 if V162367==2
replace disc=4 if V162367==1
replace disc=. if V162367 < 1


gen weight=V160102w

ren prox prox2
ren fem female
ren rep republican
ren ind independent
recode disc 3/4=3


drop V160101-V168132

save "anes.dta", replace

