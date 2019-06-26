  
** Replication file for Lee and Mitchell "Energy resources and the risk of conflict in shared river basins"
** Main article

use "LeeMitchell_Replication.dta" 
   
* Table III. 
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit irccconflict_dumm jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & _irccmerge==3
logit rivertreaty jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0
logit tfddcondum jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >= 1950  & _tfddmerge==3
logit tfddcoopdum jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >= 1950  & _tfddmerge==3 

* Table IV
estsimp logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
setx jointenergy 1 upstreamenergy 0 noenergy 0 lowdem mean MajorPower 0 lncapratio mean year mean 
simqi, pr  /*Joint Energy*/
setx jointenergy 0 upstreamenergy 1 noenergy 0 lowdem mean MajorPower 0 lncapratio mean year mean 
simqi, pr  /*Upstream Energy*/
setx jointenergy 0 upstreamenergy 0 noenergy 1 lowdem mean MajorPower 0 lncapratio mean year mean 
simqi, pr  /*No Energy*/ 
setx jointenergy 0 upstreamenergy 0 noenergy 0 lowdem mean MajorPower 0 lncapratio mean year mean 
simqi, pr  /*Downstream Energy*/

* Table V
estsimp logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
setx jointenergy 0 upstreamenergy 0 noenergy 0 MajorPower 0 lncapratio mean year mean 
simqi, fd(pr) changex(lowdem -9.514896 4.806634) /*Low Democracy: -1SD to +1SD from mean */
setx jointenergy 0 upstreamenergy 0 noenergy 0 lowdem mean lncapratio mean year mean 
simqi, fd(pr) changex(MajorPower 0 1)  /*Major Power: No Major Power to Major Power*/ 
setx jointenergy 0 upstreamenergy 0 noenergy 0 lowdem mean MajorPower 0 year mean 
simqi, fd(pr) changex(lncapratio 0.774071  3.324625) /*Ln Capability Ratio: No Major Power to Major Power*/ 

* Table VI
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio expab year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio ccode1pec ccode2pec year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio up_numdam down_numdam year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio up_hydpwdam down_hydpwdam year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio up_hydpwdam_dumm down_hydpwdam_dumm year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio waterdeppoplow avgprecippoplow  year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002	  
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio landlock year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002 


** Replication file for Lee and Mitchell "Energy resources adn the risk of conflict in shared river basins"
** Online appendix

* Table A6
logit mid jointenergy upstreamenergy noenergy year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit irccconflict_dumm jointenergy upstreamenergy noenergy year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & _irccmerge==3
logit rivertreaty jointenergy upstreamenergy noenergy year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0
logit tfddcondum jointenergy upstreamenergy noenergy year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >= 1950 & _tfddmerge==3
logit tfddcoopdum jointenergy upstreamenergy noenergy year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >= 1950 & _tfddmerge==3 

* Table A7
logit fmid jointenergy upstreamenergy noenergy year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit fmid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002

* Table A8
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio impab year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio expab year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio flow1 year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio smoothtotrade year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 & year < 2002

* Table A9
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio treatany2 year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio tfddnav2 year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945 	
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio tfddqual2 year yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945  	
logit mid jointenergy upstreamenergy noenergy lowdem MajorPower lncapratio year igos2 yearsq if sharedbas == 1 & contiguity == 1 & mixed==0 & year >=1945  
