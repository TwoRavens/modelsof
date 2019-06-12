/*-----------------------------------------------------------------
Replication do-file for article entitled "Speaking Truth to Power: Political Advisers’ and Civil Servants’ Responses to Perceived Harmful Policy Proposal"

Authors: Birgitta Niklasson, University of Gothenburg, Peter Munk Christiansen, Aarhus Universithy and Patrik Öhberg, University of Gothenburg.  
-----------------------------------------------------------------*/

use "ReplicationData.JOPP.dta", clear

**** Some of the background variables, age and seniority, are excluded for our sample as respondents were promised full anonymity and combining background characteristics would make it possible to identify respondents.
*** For similar reason are the political advisers excluded from the sample.  


**** Figure 1 

***Civil servants, Denmark

tab talk_leadership if country==1&managers==1
tab talk_minister if country==1&managers==1
tab talk_department if country==1&managers==1

tab talk_media if country==1&managers==1
tab stay_loyal if country==1&managers==1
tab salient_resistence if country==1&managers==1

*** Civil servants, Sweden  

tab talk_leadership if country==0&managers==1
tab talk_minister if country==0&managers==1
tab talk_department if country==0&managers==1

tab talk_media if country==0&managers==1
tab stay_loyal if country==0&managers==1
tab salient_resistence if country==0&managers==1


***Table 1 

gologit2 talk_minister sex  management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma

gologit2 talk_leadership sex  management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma

gologit2 talk_department sex  management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma


***Table 2 

ologit talk_leadership country  sex  department_size if managers==1, cluster(departments) 

ologit talk_minister country  sex department_size if managers==1, cluster(departments)

ologit talk_department country  sex department_size if managers==1, cluster(departments)

ologit talk_media country  sex department_size if managers==1, cluster(departments)

ologit stay_loyal country  sex department_size if managers==1, cluster(departments)

ologit salient_resistence country sex  department_size if managers==1, cluster(departments)


*** Table A1

ologit stay_loyal country sex department_size if managers==1, cluster(departments)

mtable, at( country= (0 1))

margins, dydx(country) predict(outcome(1)) atmeans
		 margins, dydx(country) predict(outcome(2)) atmeans
		 margins, dydx(country) predict(outcome(3)) atmeans
		 margins, dydx(country) predict(outcome(4)) atmeans
		 
******

gologit2 stay_loyal country sex  department_size if managers==1, cluster(departments) autofit lrforce gamma

mtable, at( country= (0 1))

margins, dydx(country) predict(outcome(1)) atmeans
		 margins, dydx(country) predict(outcome(2)) atmeans
		 margins, dydx(country) predict(outcome(3)) atmeans
		 margins, dydx(country) predict(outcome(4)) atmeans
		 
****** Table A2 

***Pooled sample
summarize talk_minister talk_leadership talk_department talk_media stay_loyal salient_resistence sex  department_size if managers==1

***Danish sample 
summarize talk_minister talk_leadership talk_department talk_media stay_loyal salient_resistence sex department_size if managers==1&country==1

***Swedish sample 
summarize talk_minister talk_leadership talk_department talk_media stay_loyal salient_resistence sex department_size deviation_from_leadership management_position if country==0

***** Table A3

quietly gologit2 talk_minister pol_advisers if country==0&!missing(sex, management_position, department_size, deviation_from_leadership), cluster(departments) autofit lrforce gamma
quietly fitstat, save
quietly gologit2 talk_minister pol_advisers sex management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma
fitstat, diff 
 
quietly gologit2 talk_leadership pol_advisers if country==0&!missing(sex, management_position, department_size, deviation_from_leadership), cluster(departments) autofit lrforce gamma
quietly fitstat, save
quietly gologit2 talk_leadership pol_advisers sex management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma
fitstat, diff  
 
quietly gologit2 talk_department pol_advisers if country==0&!missing(sex, management_position, department_size, deviation_from_leadership), cluster(departments) autofit lrforce gamma
quietly fitstat, save
quietly gologit2 talk_department pol_advisers sex management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma
fitstat, diff 

**** Table A4

quietly ologit talk_leadership country if managers==1&!missing(sex, department_size), cluster(departments) 
quietly fitstat, save
quietly ologit talk_leadership country sex department_size if managers==1, cluster(departments) 
fitstat, diff 

quietly ologit talk_minister country if managers==1&!missing(sex, department_size), cluster(departments) 
quietly fitstat, save
quietly ologit talk_minister country sex department_size if managers==1, cluster(departments) 
fitstat, diff 

quietly ologit talk_department country if managers==1&!missing(sex, department_size), cluster(departments) 
quietly fitstat, save
quietly ologit talk_department country sex department_size if managers==1, cluster(departments) 
fitstat, diff 

quietly ologit talk_media country if managers==1&!missing(sex, department_size), cluster(departments) 
quietly fitstat, save
quietly ologit talk_media country sex department_size if managers==1, cluster(departments) 
fitstat, diff 

quietly ologit stay_loyal country if managers==1&!missing(sex, department_size), cluster(departments) 
quietly fitstat, save
quietly ologit stay_loyal country sex department_size if managers==1, cluster(departments) 
fitstat, diff 

quietly ologit salient_resistence country if managers==1&!missing(sex, department_size), cluster(departments) 
quietly fitstat, save
quietly ologit salient_resistence country sex department_size if managers==1, cluster(departments) 
fitstat, diff 

**** Table 5 
quietly gologit2 talk_leadership sex management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma
mtable, at( department_size= (0 1))

margins, dydx(department_size) predict(outcome(1)) atmeans
		 margins, dydx(department_size) predict(outcome(2)) atmeans
		 margins, dydx(department_size) predict(outcome(3)) atmeans
		 margins, dydx(department_size) predict(outcome(4)) atmeans
		 		 
***

quietly gologit2 talk_minister sex management_position department_size deviation_from_leadership if country==0, cluster(departments) autofit lrforce gamma
mtable, at( management_position= (0 1))

margins, dydx(management_position) predict(outcome(1)) atmeans
		 margins, dydx(management_position) predict(outcome(2)) atmeans
		 margins, dydx(management_position) predict(outcome(3)) atmeans
		 margins, dydx(management_position) predict(outcome(4)) atmeans
		 
***

		 
		 
		 
		 
