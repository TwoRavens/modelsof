set more off

use "NES1984 (raw).dta"

**********Dependent Variable: Vote Choice****************
gen vote = .
replace vote = 1 if V840788 == 1
replace vote = 0 if V840788 == 2
label def vote 1 "Reagan" 0 "Mondale"
label values vote vote 
label var vote "Vote Choice"


****Respondent Information Level****
*Interviewer Assessment of Information Level**
	recode V841112 (1=5) (2=4) (3=3) (4=2) (5=1) (9=.), gen(int_info)
	label var int_info "Interviewer Assessement of Respn. Info"
	label def inf 1 "Very Low" 2 "Fairly Low" 3 "Avg" 4 "Fairly High" 5 "Very High"
	label values int_info inf
	tab int_info


***Education***
	gen educ = . 
	replace educ = 1 if V840438 == 1
	replace educ = 1 if V840438 == 2
	replace educ = 1 if V840438 == 3
	replace educ = 1 if V840438 == 4
	replace educ = 2 if V840438 == 5
	replace educ = 2 if V840438 == 6
	replace educ = 3 if V840438 == 7
	replace educ = 3 if V840438 == 8
	replace educ = 4 if V840438 == 9
	replace educ = 4 if V840438 == 10
	label var educ "Education" 
	label def ed 1 "< HS" 2 "HS" 3 "Some College" 4 "College+" 
	label values educ ed

	summarize educ
	gen educ01 = (educ - `r(min)') / (`r(max)'-`r(min)')
	label var educ01 "Education"

	gen educ1 = educ
	recode educ1 (. = 5)
	label var educ1 "Education"
	label def ed1 1 "< HS" 2 "HS" 3 "Some College" 4 "College+" 5 "Missing Education"
	label values educ1 ed1
	
*General Interest
	recode V840988 (1=4) (2=3) (3=2) (4=1) (9=.) (8=.), gen(follow)
	label def fol 1 "Hardly" 2 "Only Now and then" 3 "Some of the Time" 4 "Most of the Time"
	label values follow fol
	label var follow "Follow Politics?"
	tab follow
	
*Pre-Election Campaign Interest
	recode V840075 (1=3) (3=2) (5=1) (8=.) (9=.), gen(intcamp_pre)
	label var intcamp_pre "Campaign Interest (Pre-Election)"
	label def cam 1 "Not Much" 2 "Somewhat" 3 "Very Much" 
	label values intcamp_pre cam
	tab intcamp_pre

*Inter-relationship
	pwcorr  int_info educ follow intcamp_pre, sig
	factor int_info educ follow intcamp_pre, pcf
	predict factor1 
	label var factor1 "Sophistication"
	histogram factor1
	summ factor1, detail


**********Main Ind. Variable: Policy Attitude, Importance, Proximity****************
******Services*

*own position, candidate positions*
label def spen 1 "No Reduction in Spending" 7 "Provide Many Fewer Services"

gen spend84 = . 
replace spend84 = 1 if V840375 == 7
replace spend84 = 2 if V840375 == 6
replace spend84 = 3 if V840375 == 5
replace spend84 = 4 if V840375 == 4
replace spend84 = 5 if V840375 == 3
replace spend84 = 6 if V840375 == 2
replace spend84 = 7 if V840375 == 1

gen reaganspend84 = . 
replace reaganspend84 = 1 if V840376 == 7
replace reaganspend84 = 2 if V840376 == 6
replace reaganspend84 = 3 if V840376 == 5
replace reaganspend84 = 4 if V840376 == 4
replace reaganspend84 = 5 if V840376 == 3
replace reaganspend84 = 6 if V840376 == 2
replace reaganspend84 = 7 if V840376 == 1

gen mondalespend84 = . 
replace mondalespend84 = 1 if V840377 == 7
replace mondalespend84 = 2 if V840377 == 6
replace mondalespend84 = 3 if V840377 == 5
replace mondalespend84 = 4 if V840377 == 4
replace mondalespend84 = 5 if V840377 == 3
replace mondalespend84 = 6 if V840377 == 2
replace mondalespend84 = 7 if V840377 == 1

label values spend84 spen
label values reaganspend84 spen
label values mondalespend84 spen

*****Proximity*

**Sample Mean
	summarize reaganspend84 mondalespend84
	*Reagan: 5.104997
	*Mondale: 3.0024


*City Block: Sample

	gen spend84prox = abs(spend84 - 3.0024) - abs(spend84 - 5.104997)
	label var spend84prox "Proximity: Spending & Services"

*City Block: Informed
	summarize reaganspend84 mondalespend84 if factor1 >=0.10 & factor1 <= 1.978768
		*reagan 5.31295
		*mondale: 2.77284
	gen spend84prox_info = abs(spend84 - 2.77284) - abs(spend84 - 5.31295)
	label var spend84prox_info "Proximity: Spending & Services (Informed)"


*City Block: Self
	gen spend84prox_self = abs(spend84 - mondalespend84) - abs(spend84 - reaganspend84)
	label var spend84prox_self "Proximity: Spending & Services (Self_Placement)"

*Euclidean
	gen spend84prox_euclid1 = [(spend84 - 3.0024)*(spend84 - 3.0024)] - [(spend84 - 5.104997)*(spend84 - 5.104997)]
	gen spend84prox_euclid2 = [(spend84 - 2.77284)*(spend84 - 2.77284)] - [(spend84 - 5.31295)*(spend84 - 5.31295)]
	gen spend84prox_euclid3 = [(spend84 - mondalespend84)*(spend84 - mondalespend84)] - [(spend84 - reaganspend84)*(spend84 - reaganspend84)]
	
summ spend84prox spend84prox_info spend84prox_self spend84prox_euclid1 spend84prox_euclid2 spend84prox_euclid3



*Attitude Strength: Extremity & Importance*

gen spend84ext = . 
replace spend84ext = 1 if spend84 == 4
replace spend84ext = 2 if spend84 == 3
replace spend84ext = 2 if spend84 == 5
replace spend84ext = 3 if spend84 == 2
replace spend84ext = 3 if spend84 == 6
replace spend84ext = 4 if spend84 == 1
replace spend84ext = 4 if spend84 == 7

gen spend84imp = . 
replace spend84imp = 1 if V840381 == 5
replace spend84imp = 2 if V840381 == 4
replace spend84imp = 3 if V840381 == 2
replace spend84imp = 4 if V840381 == 1
label var spend84imp "Importance of Services Issue to R"
label def import 1 "Not Important" 2 "Somewhat" 3 "Very" 4 "Extremely"


*0-1 scales and standardized versions*


foreach var in spend84prox spend84prox_info spend84prox_self spend84prox_euclid1 spend84prox_euclid2 spend84prox_euclid3 spend84ext spend84imp {
		qui sum `var'
		gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
	}
	

	label var spend84prox01 "Spend: Prox"
	label var spend84imp01 "Spend:Imp"



*******Jobs*
**own position & candidate placement*
rename V840414 jobs84
rename  V840415 reaganjobs84
rename V840416 mondalejobs84
mvdecode jobs84  reaganjobs84 mondalejobs84, mv(0 = . \ 8 = . \ 9 = .) 

**proximity*
	*sample
		summarize reaganjobs84 mondalejobs84
		*reagan: 5
		*mondale: 3.278542

	*city block: sample
		gen jobs84prox = abs(jobs84 - 3.278542) - abs(jobs84 - 5)
		label var jobs84prox "Jobs: Proximity"

	*city block: informed
		summarize reaganjobs84 mondalejobs84 if factor1 >=0.10 & factor1 <= 1.978768
		*reagan: 5.190184; modnale: 3.050891
		gen jobs84prox_info = abs(jobs84 - 3.050891) - abs(jobs84 - 5.190184)
		label var jobs84prox_info "Jobs: Proximity (Informed)"
		
	*city block: self
		gen jobs84prox_self = abs(jobs84 - mondalejobs84) - abs(jobs84 - reaganjobs84)
		label var jobs84prox_self "Jobs: Proximity (Self_Placement)"

	
	*eucli
		gen jobs84prox_euclid1 = [(jobs84 - 3.278542)*(jobs84 - 3.278542)] - [(jobs84 - 5)*(jobs84 - 5)]
		gen jobs84prox_euclid2 = [(jobs84 - 3.050891)*(jobs84 - 3.050891)] - [(jobs84 - 5.190184)*(jobs84 - 5.190184)]
		gen jobs84prox_euclid3 = [(jobs84 - mondalejobs84)*(jobs84 - mondalejobs84)] - [(jobs84 - reaganjobs84)*(jobs84 - reaganjobs84)]
	
	
summ jobs84prox jobs84prox_info jobs84prox_self jobs84prox_euclid1 jobs84prox_euclid2 jobs84prox_euclid3	

	

*attitude strength*
gen jobs84ext = . 
replace jobs84ext = 1 if jobs84 == 4
replace jobs84ext = 2 if jobs84 == 5
replace jobs84ext = 2 if jobs84 == 3
replace jobs84ext = 3 if jobs84 == 6
replace jobs84ext = 3 if jobs84 == 2
replace jobs84ext = 4 if jobs84 == 1
replace jobs84ext = 4 if jobs84 == 7


gen jobs84imp = . 
replace jobs84imp = 1 if V840420 == 5
replace jobs84imp = 2 if V840420 == 4
replace jobs84imp = 3 if V840420 == 2
replace jobs84imp = 4 if V840420 == 1
label var jobs84imp "Importance of Jobs to R"
label values jobs84imp import


*standardized*

foreach var in jobs84prox jobs84prox_info jobs84prox_self jobs84prox_euclid1 jobs84prox_euclid2 jobs84prox_euclid3 jobs84ext jobs84imp {
		qui sum `var'
		gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
	}
	
	
	label var jobs84prox01 "Jobs:Prox"
	label var jobs84imp01 "Jobs:Imp"
	

*******Central America*
gen central84 = . 
replace central84 = 1 if V840388 == 7
replace central84 = 2 if V840388 == 6
replace central84 = 3 if V840388 == 5
replace central84 = 4 if V840388 == 4
replace central84 = 5 if V840388 == 3
replace central84 = 6 if V840388 == 2
replace central84 = 7 if V840388 == 1

gen reagancentral84 = .
replace reagancentral84 = 1 if V840389 == 7
replace reagancentral84 = 2 if V840389 == 6
replace reagancentral84 = 3 if V840389 == 5
replace reagancentral84 = 4 if V840389 == 4
replace reagancentral84 = 5 if V840389 == 3
replace reagancentral84 = 6 if V840389 == 2
replace reagancentral84 = 7 if V840389 == 1

gen mondalecentral84 =  .
replace mondalecentral84 = 1 if V840390 == 7
replace mondalecentral84 = 2 if V840390 == 6
replace mondalecentral84 = 3 if V840390 == 5
replace mondalecentral84 = 4 if V840390 == 4
replace mondalecentral84 = 5 if V840390 == 3
replace mondalecentral84 = 6 if V840390 == 2
replace mondalecentral84 = 7 if V840390 == 1

label def cen 1 "US Less Involved" 7 "US More Involved" 
label values central84 cen
label values mondalecentral84 cen
label values reagancentral84 cen

*Proximity*
	*sample mean
		summarize mondalecentral84 reagancentral84
		*reagan: 5.155611
		*mondale: 3.52669
		
	*city block: sample
		gen central84prox = abs(central84 - 3.52669) - abs(central84 - 5.155611)
		label var central84prox "Central America: Proximity"
		
	*city block: informed
			summarize mondalecentral84 reagancentral84 if factor1 >=0.10 & factor1 <= 1.978768
			*mondale: 3.381368
			*reagan: 5.427822
		gen central84prox_info = abs(central84 - 3.381368) - abs(central84 - 5.427822)
		label var central84prox_info "Central America: Proximity (Informed)"
			
			
	*city block: self
		gen central84prox_self = abs(central84 - mondalecentral84) - abs(central84 - reagancentral84)
		label var central84prox_self "Central America: Proximity (Self-Placement)"
		
		
	*euclidean
		gen central84prox_euclid1 = [(central84 - 3.52669)*(central84 - 3.52669)] - [(central84 - 5.155611)*(central84 - 5.155611)]
		gen central84prox_euclid2 = [(central84 - 3.381368)*(central84 - 3.381368)] - [(central84 - 5.427822)*(central84 - 5.427822)]
		gen central84prox_euclid3 = [(central84 - mondalecentral84)*(central84 - mondalecentral84)] - [(central84 - reagancentral84)*(central84 - reagancentral84)]
		
		summ central84prox central84prox_info central84prox_self central84prox_euclid1 central84prox_euclid2 central84prox_euclid3
		
		
		
**attitude strength**
gen central84ext = . 
replace central84ext = 1 if central84 == 4
replace central84ext = 2 if central84 == 3
replace central84ext = 2 if central84 == 5
replace central84ext = 3 if central84 == 2
replace central84ext = 3 if central84 == 6
replace central84ext = 4 if central84 == 1
replace central84ext = 4 if central84 == 7

gen central84imp = . 
replace central84imp = 1 if V840394 == 5
replace central84imp = 2 if V840394 == 4
replace central84imp = 3 if V840394 == 2
replace central84imp = 4 if V840394 == 1
label var central84imp "Importance of Central America"
label values central84imp import

*Standardized*

foreach var in central84prox central84prox_info central84prox_self central84prox_euclid1 central84prox_euclid2 central84prox_euclid3 central84ext central84imp {
		qui sum `var'
		gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
	}
	
	
	label var central84prox01 "Central:Prox"
	label var central84imp01 "Central:Imp"
	


*******Women: Position*
*own position & candidates*
rename V840401 women84
rename V840402 reagan84women
rename V840403 mondale84women
mvdecode women84 reagan84women mondale84women , mv(0 = . \ 8 = . \ 9 = .) 


label def wom 1 "Gov't Should Help Women" 7 "Women Should Help Selves"
label values women84 wom
label values reagan84women wom
label values mondale84women wom

*proximity*
	*sample mean
	summarize reagan84women mondale84women
	*reagan: 4.606414
	*mondale: 3.14303

	*city block: sample
	gen women84prox = abs(women84 - 3.14303) - abs(women84 - 4.606414)
	label var women84prox "Women: Proximity"

	*city block: informed
		summarize reagan84women mondale84women if factor1 >=0.10 & factor1 <= 1.978768
		*reagan: 4.767588
		*mondal: 2.994805
	
		gen women84prox_info = abs(women84 - 2.994805) - abs(women84 - 4.767588)
		label var women84prox_info "Women: Proximity (Informed)"
	
	*city block: self
		gen women84prox_self = abs(women84 - mondale84women) - abs(women84 - reagan84women)
		label var women84prox_self "Women: Proximity (Self-Placement)"
	
	
	*euclidean
		gen women84prox_euclid1 = [(women84 - 3.14303)*(women84 - 3.14303)] - [(women84 - 4.606414)*(women84 - 4.606414)]
		gen women84prox_euclid2 = [(women84 - 2.994805)*(women84 - 2.994805)] - [(women84 - 4.767588)*(women84 - 4.767588)]
		gen women84prox_euclid3 = [(women84 - mondale84women)*(women84 - mondale84women)] - [(women84 - reagan84women)*(women84 - reagan84women)]
		
		summ women84prox women84prox_info women84prox_self women84prox_euclid1 women84prox_euclid2 women84prox_euclid3
	
	

*attitude strength*
gen women84ext = . 
replace women84ext = 1 if women84 == 4
replace women84ext = 2 if women84 == 3
replace women84ext = 2 if women84 == 5
replace women84ext = 3 if women84 == 2
replace women84ext = 3 if women84 == 6
replace women84ext = 4 if women84 == 1
replace women84ext = 4 if women84 == 7

gen women84imp = .
replace women84imp = 1 if V840407 == 5
replace women84imp = 2 if V840407 == 4
replace women84imp = 3 if V840407 == 2
replace women84imp = 4 if V840407 == 1
label var women84imp "Importance of Women's Status"
label values women84imp import


*Standardized*


foreach var in women84prox women84prox_info women84prox_self women84prox_euclid1 women84prox_euclid2 women84prox_euclid3   women84ext women84imp {
		qui sum `var'
		gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
	}
	
	
	label var women84prox01 "Women:Prox"
	label var women84imp01 "Women:Imp"

**********Control Variables****************
*PID*
rename V840318 pid
mvdecode pid, mv(8 = . \ 9 = . )
summarize pid
gen pid01 = (pid - `r(min)') / (`r(max)'-`r(min)')
label var pid01 "PID"


*Ideology*
gen ideology = V840369
mvdecode ideology, mv(0 = . \ 8 = . \ 9 = .)
label var ideology "Ideology"
summarize ideology
gen ideology01 = (ideology - `r(min)') / (`r(max)'-`r(min)')
label var ideology01 "Ideology"

gen ideology2 = V840369
recode ideology2 (0 = 8) (9 = 8)
label var ideology2 "Ideology (Full)"
label def ideo1 8 "Haven't Thought Much/DK/NA" 1 "Ext. Liberal"  7 "Ext. Conservative" 4 "Moderate"
label values ideology2 ideo1

recode V840369 (1=1) (2=1) (3=1) (4=2) (5=3) (6=3) (7=3) ///
	(0=4) (8=4) (9=4), gen(ideol)
	
	label var ideol "Ideology"
	label def id 1 "Liberal" 2 "Moderate" 3 "Conservative" 4 "Haven't Thought/DK/NA"
	label values ideol id



*Race*
gen race = . 
replace race = 1 if V840708 >=2 & V840708 <= 7
replace race = 0 if V840708 == 1
label def nonwh1 1 "Non-White" 0 "White" 
label values race nonwh1
label var race "Race" 

gen hispanic = .
replace hispanic = 1 if V840709 >=1 & V840709 <= 3
replace hispanic = 0 if V840709 == 5
label var hispanic "Hispanic" 
label def his 1 "Hispanic" 0 "Non-Hispanic"
label values hispanic his




***Gender***
gen gender = .
replace gender = 1 if V840707 == 2
replace gender = 0 if V840707 == 1
label var gender "Gender"
label def gend 0 "Male" 1 "Female"
label values gender gend



***Age***
rename V840429 age
recode age (0 = . )
label var age "Age"
summarize age
gen age01 = (age - `r(min)') / (`r(max)'-`r(min)')
label var age01 "Age"




*Income*
rename V840681 income
rename V840680 famincome
mvdecode income famincome , mv(0 = . \ 88 = . \ 98 = . \ 99 = .) 

foreach var in income famincome {
		qui sum `var'
		gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')

	}

label var income "Own Income" 
label var famincome "Family Income"
label var income01 "Own Income"
label var famincome01 "Family Income"

egen income_pct = cut(income), group(10) label
gen income_miss = . 
replace income_miss = 1 if income == .
gen income_pct1 = income_pct 
replace income_pct1 = 10 if income_miss == 1 & income_pct1 == . 
label def inc_mis1 10 "Missing Income"
label values income_pct1 inc_mis1


egen famincome_pct = cut(famincome), group(10) label
gen famincome_miss = .
replace famincome_miss = 1 if famincome == . 
replace famincome_miss = 0 if famincome !=.

gen famincome_pct1 = famincome_pct 
replace famincome_pct1 = 11 if famincome_miss == 1 & famincome_pct1 == .
label def inc_mis2 10 "Missing Income" 
label values famincome_pct1 inc_mis



*Retrospective*
gen econ = .
replace econ = 1 if V840228 == 5
replace econ = 2 if V840228 == 4
replace econ = 3 if V840228 == 3
replace econ = 4 if V840228 == 2
replace econ = 5 if V840228 == 1
label var econ "Economy Gotten Better/Worse?"
label def econ1 5 "Much Better" 4 "Somewhat Better" 3 "Same" 2 "Somewhat Worse" 1 "Much Worse"
label values econ econ1
summarize econ
gen econ01 = (econ - `r(min)') / (`r(max)'-`r(min)')
label var econ01 "Economic Eval"

*Traits*
label def trai 1 "Not Well at All" 4 "Extremely Well"
gen reagan84moral = .
replace reagan84moral = 1 if V840324 == 4
replace reagan84moral = 2 if V840324 == 3
replace reagan84moral = 3 if V840324 == 2
replace reagan84moral = 4 if V840324 == 1
gen reagan84knowl = . 
replace reagan84knowl = 1 if V840327 == 4
replace reagan84knowl = 2 if V840327 == 3
replace reagan84knowl = 3 if V840327 == 2
replace reagan84knowl = 4 if V840327 == 1
gen reagan84leader = . 
replace reagan84leader = 1 if V840330 == 4
replace reagan84leader = 2 if V840330 == 3
replace reagan84leader = 3 if V840330 == 2
replace reagan84leader = 4 if V840330 == 1
label values reagan84moral trai
label values reagan84knowl trai
label values reagan84leader trai

*Mondale*
gen mondale84moral = .
replace mondale84moral = 1 if V840340 == 4
replace mondale84moral = 2 if V840340 == 3
replace mondale84moral = 3 if V840340 == 2
replace mondale84moral = 4 if V840340 == 1
gen mondale84knowl = .
replace mondale84knowl = 1 if V840343 == 4
replace mondale84knowl = 2 if V840343 == 3
replace mondale84knowl = 3 if V840343 == 2
replace mondale84knowl = 4 if V840343 == 1
gen mondale84leader = . 
replace mondale84leader = 1 if V840346 == 4
replace mondale84leader = 2 if V840346 == 3
replace mondale84leader = 3 if V840346 == 2
replace mondale84leader = 4 if V840346 == 1
label values mondale84knowl trai
label values mondale84leader trai
label values mondale84moral trai


*Comparative Traits*
gen moral84 = reagan84moral - mondale84moral
gen knowl84 = reagan84knowl - mondale84knowl
gen leader84 = reagan84leader - mondale84leader

foreach var in  reagan84moral reagan84knowl reagan84leader moral84 knowl84 leader84 {
		qui sum `var'
		gen `var'01 = (`var' - `r(min)') / (`r(max)'-`r(min)')
	}

