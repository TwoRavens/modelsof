****"Better Angels of Our Nature" (American Journal of Political Science) replication code**** 
 *****Study 2: The Islamic Schools experiment. Conducted using British Election Study Continuous Monitoring Survey data****
 *****Code for robustness checks presented in internet appendix
***Code compiled by Robert Ford (rob.ford@manchester.ac.uk)
***This version: 29th January 2013
****Run using "better angels study 2 cmsfinal.dta", which is in the "Better Angels of Our Nature" folder at dataverse****

*****Code runs models for white sample only, but effects robust to inclusion of minorities (this can be checked by removing the "if nonwhite==0" clause)

*******Demographic controls used in robustness checks


gen male = 0 
replace male=1 if q2==1

gen nonwhite = 0
replace nonwhite=1 if q120>2

gen ed21over = 0
replace ed21over=1 if q112==6

gen ed16under = 0
replace ed16under=1 if q112<4

gen ageover50 = 0
replace ageover50=1 if q3>50

gen conid = 0
replace conid =1 if q32==1

gen labid = 0
replace labid = 1 if q32==2

gen ldid = 0
replace ldid = 1 if q32==3

gen noid = 0
replace noid = 1 if q32==10
replace noid = 1 if q32==11





****I: Main effects

****1. MCP and messages only

xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 if nonwhite==0
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 if nonwhite==0

****2. MCP and message, control for anti-Muslim sentiment

xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 marrymus01 if nonwhite==0
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 marrymus01 if nonwhite==0

****3. Add demographics
#delimit ;
xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 marrymus01 
i.edulevel working i.agecat if nonwhite==0;
#delimit ;
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 marrymus01 
i.edulevel working i.agecat if nonwhite==0;


#delimit ; 
xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 marrymus01 
i.edulevel working i.agecat [pw=w8] if nonwhite==0;

****4. Add political controls

#delimit ;
xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 marrymus01 
i.edulevel working i.agecat conid labid ldid if nonwhite==0;
#delimit ;
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 marrymus01 
i.edulevel working i.agecat conid labid ldid if nonwhite==0;


#delimit ; 
xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav mcpscale01 idlose01 
i.edulevel working i.agecat conid labid ldid [pw=w8] if nonwhite==0;

****II: Interaction effects

****1. MCP and messages only

regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp if nonwhite==0
ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp if nonwhite==0

****2. MCP and message, control for anti-Muslim sentiment

regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp idlose01 if nonwhite==0
ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp idlose01 if nonwhite==0

****3. Add demographics
#delimit ;
xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp idlose01
i.edulevel working i.agecat if nonwhite==0;
#delimit ; 
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp idlose01
i.edulevel working i.agecat if nonwhite==0;

****4. Add political controls

#delimit ;
xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp idlose01
i.edulevel working i.agecat conid labid ldid if nonwhite==0;
#delimit ; 
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp idlose01 
i.edulevel working i.agecat conid labid ldid if nonwhite==0;

#delimit ; 
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum mcpmedsplit bnpmesmcp marrymus01 
i.edulevel working i.agecat conid labid ldid if nonwhite==0;

