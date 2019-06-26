clear
*DeRouen, Bercovitch and Pospieszna, Journal of Peace Research , "Introducing the Civil Wars Mediation (CWM) Dataset"

*note that these models run with newest data with about 13 new cases of med since first submitted

*note the list of war episodes used here will be differnet from that in most recent UCDP conflcit termination data; this is because ///
those data are continually updated 

use "C:\Documents and Settings\kderouen\My Documents\FBA\CWM data and stata files\civil_war_episodes_+med_2-1-2011.dta", clear

* milfaction intensity milterm lowterm cfterm treatyterm lifee life2001 polity2_start ///
sfx_wood medyes_no multimed medrank initiated outcome durability pol2end gdpstartl_fl mtn_fl ///
ethfrac_fl wardur life03ave str

*recode medrank (1/4=0) (5/6=1) (7/12=0), 		gen (igo)
*recode medrank (3/4=1) (1/2=0) (5/12=0), 		gen (rgo )
*recode medrank (1/7=0) (8 10=1) (9 11 12=0), 		gen (largegov)
*recode initiated (1=0) (2=1)  (3/7=0), 			gen (both_init  )
*recode outcome (1/3=0) (4/6=1), 				gen (med_outcome)
*recode type_of_termination (1/3=1 )  (4/6=0  ) , 	gen (negsett) 
*recode type_of_termination (1/3 5 6 =0 )  (4=1  ) , 	gen (milvic)
*recode type_of_termination (1/3=1 )  (4/6=0  ) , 	gen (peaceag)
*recode str (1=0) (2/7=1), 					gen (repeat)

*stset wardur, fail( conflict_terminated )
recode incompatibility (1=1) (2=0), 			gen (terr)
*recode statpeace (1=0 ) (0=1 ), 				gen (exitsamp)
recode type (4=1) (3=0), 					gen (intlzed)
gen logwardur=log(wardur)
gen logbattdeathsum=log(battdeathsum)
gen logbattdeathavg =log(battdeathavg)
recode year (1946/1989= 0) (1990/2004=1) , 		gen (coldwar)
gen pol2end11= pol2end + 11
*gen pol2endsq=(pol2end11)^2

*recode victory_side (2=1) (1=0) (.=0), 			gen (rebelvic)
*recode victory_side (1=1) (2=0) (.=0), 			gen (govtvic)
*gen med_pko=pko*medyes_no
*gen med_un=medyes_no*unpko
*gen med_nonunpko= medyes_no*nonunpko
*gen newlifeexpsq=newlifeexp^2

*  adult_literacy_start adult_literacy_end ___youth_end

*corr milfaction intensity milterm lowterm cfterm treatyterm lifee life2001 polity2_start ///
sfx_wood medyes_no multimed medrank initiated outcome durability pol2end gdpstartl_fl mtn_fl ///
ethfrac_fl wardur life03ave globalpol globalcount

*sum wardur if terr==1
*sum wardur if terr==0

*sum durpeace if terr==1
*sum durpeace if terr==0

*list type_of_termination if terr==1
*list type_of_termination if terr==0
destring vonhanid_end vonhanid_start, replace

**********

*all wars

probit medyes_no pol2end11 terr intlzed str Newlifeexp logbattdeathavg logwardur globalcount , cluster(dyad) nolog
precalc
estimates store modelall1

probit medyes_no Polity2start terr intlzed str Newlifeexp logbattdeathsum  logwardur coldwar  , cluster(dyad) nolog
precalc
estimates store modelall2

probit medyes_no pol2end11  terr intlzed str  Newlifeexp logbattdeathavg logwardur globalpol, cluster(dyad) nolog
precalc
estimates store modelall3

probit medyes_no vonhanid_end terr intlzed str Newlifeexp logbattdeathavg logwardur  globalcount, cluster(dyad) nolog
precalc
estimates store modelall4

probit medyes_no   vonhanid_start terr  intlzed str Newlifeexp  logbattdeathsum   logwardur coldwar , cluster(dyad) nolog
precalc
estimates store modelall5

probit medyes_no vonhanid_end terr    intlzed str Newlifeexp logbattdeathavg logwardur globalpol  , cluster(dyad) nolog
precalc
estimates store modelall6

esttab modelall1 modelall2 modelall3 modelall4 modelall5 modelall6, se star (+ .1 * .05 ** .005   )  replace title (Full Sample)

***********************

