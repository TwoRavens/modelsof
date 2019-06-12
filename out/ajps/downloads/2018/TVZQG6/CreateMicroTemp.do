
global dir = "C:\Users\jgw12\Dropbox\Research\Migration\Remit Protest\EMW-AJPS-Verification-Files"
cd "$dir"

use merged_r4_v2_data, clear

set more off
set scheme lean2

***Merge Africa_short_2008, change directory if needed.
sort ccodewb
merge m:1 ccodewb using  Africa_short_2008 


*************
***Recodes***
*************
	***Remittances
	tab Q87
	recode Q87 9 998 -1=.,gen(remit)
	tab remit, missing
	recode Q87 (1 2 3 4 5=1) (9 998 -1=. ), gen(remit01)
	tab remit01, missing

	***Discuss Politics
	tab Q14
	recode Q14  1/2=1 9 998 -1=., gen(discussion)
	tab discussion, missing

	***Political Participation Association
	tab Q22B
	recode Q22B 0/1=0 2/3=1 9 998 -1=., gen(association)
	tab association, missing

	***Attend Community Meeting--Att value 1
	tab Q23A
	recode Q23A 9 998 -1=., gen(community)
	tab community, missing
	recode Q23A (2 3 4=2) (9 998 -1=.), gen(o_community)
	tab o_community, missing

	***Join Others --Att value 1
	tab Q23B
	recode Q23B 9 998 -1=., gen(joinothers)
	tab joinothers, missing
	recode Q23B (2 3 4=2) (9 998 -1=.), gen(o_joinothers)
	tab o_joinothers, missing

	***Protest
	tab Q23C
	recode Q23C 9 998 -1=., gen(protest)
	tab protest, missing
	recode Q23C (2 3 4=2) (9 998 -1=.), gen(o_protest)
	tab o_protest, missing
	recode Q23C (0 1=0) (2 3 4=1) (9 998 -1=.), gen(protest01)
	tab protest01, missing
	
	***Voted
	tab Q23D
	recode Q23D (2 3 4 5 6=0)  (0 9 300 77 88 -1=.), gen(voted01)
	tab voted01, missing

	***Contacting Officials
	tab Q25A
	recode Q25A (1 2 3=1) (9 998 -1=.), gen(contact_local)
	tab contact_local, missing
	tab Q25B
	recode Q25B (1 2 3=1) (9 998 -1=.), gen(contact_mp)
	tab contact_mp, missing
	tab Q25C
	recode Q25C (1 2 3=1) (9 998 -1=.), gen(contact_gov)
	tab contact_gov, missing
	gen contact= contact_local+contact_mp+contact_gov
	recode contact (1 2 3=1)
	tab contact, missing

	***Participation, Local level, val 7?
	tab Q62B
	tab Q62C
	tab Q62D
	tab Q62E
	recode Q62B  (0 7 =0) (1=0.33) (2=0.67) (3=1) (9 998 -1=.), gen(local_join)
	recode Q62C  (0 7 =0) (1=0.33) (2=0.67) (3=1) (9 998 -1=.), gen(local_discuss)
	recode Q62D  (0 7 =0) (1=0.33) (2=0.67) (3=1) (9 998 -1=.), gen(local_write)
	recode Q62E  (0 7 =0) (1=0.33) (2=0.67) (3=1) (9 998 -1=.), gen(local_complain)
	alpha local_*, item case gen(local_part)
	sum local_part
	 
	***Partisan
	tab Q85
	recode Q85 8 9 -1=., gen(partisan)
	tab partisan, missing 

	***Sociodemographics
	tab URBRUR
	recode URBRUR (2=0), gen(urban)
	tab urban
	tab Q1
	recode Q1 -1 998 999=., gen(age)
	egen mn_age=mean(age), by(COUNTRY)
	gen c_age=age-mn_age

	*Educaction
	tab Q89
	recode Q89 99 998 -1=., gen(education)
	tab education

	*Wealth
	tab Q92A 
	recode Q92A 9 998 -1=., gen(radio)
	tab Q92B
	recode Q92B 9 998 -1=., gen(television)
	tab Q92C
	recode Q92C 9 998 -1=., gen(motor)
	gen wealth=(radio+television+motor)/ 3
	tab wealth

	*Male
	tab Q101
	recode Q101 2=0, gen(male) 
	tab male

	*Employment Status
	tab Q94
	recode Q94 0/1=0 2/3=1 4/5=2 9 998 -1=., gen(employment)
	tab employment, missing

	*Deprivation
	tab Q8A
	recode Q8A  (1 2 3 4=1) (-1 9=.) , gen(nofood)
	tab nofood
	tab Q8B
	recode Q8B  (1 2 3 4=1) (-1 9=.) , gen(nowater)
	tab nowater
	tab Q8C
	recode Q8C  (1 2 3 4=1) (-1 9=.) , gen(nomedicine)
	tab nomedicine
	gen deprivation=(nofood+nowater+nomedicine)/ 3 
	tab deprivation

	*Negative evaluations of government, higher values: worse evaluations
	tab Q57G
	recode Q57G 1/2=3 9=2 3/4=1 -1=., gen(health) 
	label value health 
	label define health 3 "Bad" 2 "Don't Know" 1 "Good"
	label values health health
	tab health
	 
	tab Q57I
	recode Q57I 1/2=3 9=2 3/4=1 -1=., gen(sanitation) 
	label value sanitation 
	label define sanitation 3 "Bad" 2 "Don't Know" 1 "Good"
	label values sanitation sanitation
	tab sanitation

	tab Q57N
	recode Q57N 1/2=3 9=2 3/4=1 -1=., gen(electricity) 
	label value electricity 
	label define electricity 3 "Bad" 2 "Don't Know" 1 "Good"
	label values electricity electricity
	tab electricity

 
 *******************************
 *** Keep only dictatorships ***
 *******************************
	keep if GWF_regime==1
	tab COUNTRY
	
*******************************************
*** Region and District numerical codes ***
*******************************************
	egen region = concat(REGION URBRUR)  if GWF_regime==1   	/* Region fixed effect based on sample strata by region and urban/rural */
	egen rregion = group(region)         if GWF_regime==1   	/* destring the string variable */
	drop region
	gen region = rregion
	drop rregion
	egen dcode = group(DISTRICT)        if GWF_regime==1 
 
*******************************************************
*** District and region level progovernment support ***
*******************************************************
	gen progov_trustparty = Q49E==3| Q49E==4  
	gen progov_trustpres= Q49A==3| Q49A==4
	gen progov_presperform= Q70A==3| Q70A==4
	tab Q49E  	/* less than 5% non-response */
	tab Q49A 	/* less than 5% non-response */
	tab Q70A 	/* less than 5% non-response */
	tab Q97   	/* Just under 25% of respondents: would not vote, refused to answer, do not know */
	alpha progov_*, item detail  gen(progov)
	egen mean_progov = mean(progov),by(dcode)
	hist mean_progov 
	egen dtag = tag(dcode)        if GWF_regime==1 & mean_progov~=.
	egen rmean_progov = mean(progov),by(region)
	hist rmean_progov
	egen rtag = tag(region)        if GWF_regime==1 & mean_progov~=.

*************************
*** Control variables ***
*************************
	gen remitXincreg = remit*rmean_progov  			/* note that remit has 5 ordinal values */
	gen remit01Xincreg = remit01*rmean_progov   		/* note that remit01 is binary */
	gen remitXpro  = remit*mean_progov
	gen remit01Xpro = remit01*mean_progov
	gen lage = ln(age)
	gen cellphone = Q88A==2| Q88A==3 | Q88A==4
	gen travel = Q88D==3 | Q88D==4
	
	*** Refusal and close to party variables ***
	gen close = Q85==1 if Q85~=-1  /* close to a political party */
	gen refused_vote = Q97==997 | Q97==998 | Q97==999 | Q97==-1   	/* vote for which party: would not vote, refused to answer, don't know  */
	gen refused_party = Q86==997 | Q86==998 | Q86==999 | Q86==-1     /* close to which party: not applicable, refused to answer, don't know  */
	tab refused_vote if COUNTRY==20
	tab refused_*,col row
	gen closref = close==1 & refused_vote==1 if close~=. & refused_vote~=.
	
	*** 2008 Freedom House Scores ***
	 gen FH = .
	 replace FH=4 if COUNTRY==2
	 replace FH=8 if COUNTRY==3
	 replace FH=6 if COUNTRY==12
	 replace FH=4 if COUNTRY==13
	 replace FH=7 if COUNTRY==17
	 replace FH=9 if COUNTRY==18
	 replace FH=7 if COUNTRY==19
	 replace FH=13 if COUNTRY==20
	 
	 *** Refuse recodes ***
	gen cellphone_refuse = Q88A==-1 |  Q88A==9  /* cell phone use */
	gen discuss_refuse =  Q14==-1 |  Q14==9  /* discuss politics */
	gen protest_refuse = Q23C==-1 | Q23C==9  /* protest */
	gen remit_refuse  = Q87==-1 | Q87==9 /* remittances */
	
	gen free = Q15C==3 | Q15C==4 | Q15C==3 if  Q15C~=-1 & Q15C~=9
 	
	keep COUNTRY REGION URBRUR DISTRICT GWF* region dcode rtag dtag ///
	progov* mean* rmean* remit* protest* vote* lage cellphone travel education wealth male employment urban ///
	close refuse* closref deprivation FH cellphone_refuse discuss_refuse protest_refuse remit_refuse free Q79 Q46 Q47 Q48* Q51*
		
save temp-micro,replace
 
