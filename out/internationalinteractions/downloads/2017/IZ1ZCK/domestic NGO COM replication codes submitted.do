*Domestic NGO and COM replication DO FILE
use domestic NGO and COM replication.dta
log using domestic ngo and com replication.smcl, text replace

*DEFINE THE PANEL WITH I AS A COUNTRY CODE AND J AS THE YEAR CODE
tsset i j 
*CREATE TABLE 1	
summ popcom popacpl ngostr ngoadv ngofin ngopubim ngoleg eu nox gdpgrth fisdec ingo exppercgdp envcomm gwawar gwanth polity
*CREATE CORRELATION TABLE FOR APPENDIX
corr popcom popacpl ngostr ngoadv ngofin ngopubim ngoleg eu nox gdpgrth fisdec ingo exppercgdp envcomm gwawar gwanth polity

*CREATE TABLE 2 USING PANEL REGRESSION AND ROBUST STANDARD ERRORS
*MODEL 1
xtreg popcom ngostr eu, robust
*MODEL 2
xtreg popcom ngostr eu nox gdpgrth fisdec, robust
*MODEL 3
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp, robust

*CREATE TABLE 3 USING PANEL REGRESSION AND ROBUST STANDARD ERRORS
*MODEL 4
xtreg popcom ngoadv eu nox gdpgrth fisdec ingo exppercgdp, robust
*MODEL 5
xtreg popcom ngofin eu nox gdpgrth fisdec ingo exppercgdp, robust
*MODEL 6
xtreg popcom ngopubim eu nox gdpgrth fisdec ingo exppercgdp, robust
*MODEL 7
xtreg popcom ngoleg eu nox gdpgrth fisdec ingo exppercgdp, robust

*CREATE TABLE 4 USING PANEL REGRESSION AND ROBUST STANDARD ERRORS
*MODEL 8
xtreg popacpl ngostr eu,robust

*MODEL 9
xtreg popacpl ngostr eu nox gdpgrth fisdec ,robust

*MODEL 10
xtreg popacpl ngostr eu nox gdpgrth fisdec ingo exppercgdp ,rob

*SPECIFICATION CHECKS DISCUSSED ON PAGE 25
*FOREIGN DIRECT INVESTMENT (1) 
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp fdiinflowgdp , robust
*GDP PER CAPITA AND GDP PER CAPITA SQUARED (2)
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp gdpcap gdpcapsq , robust
*SHARE OF COAL IN TOTAL PRIMARY ENERGY PRODUCTION (3)
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp coaltpep, robust
*ENVIRONMENTAL AID INFLOW (4)
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp envaid, robust


*SPECIFICATION CHECKS DISCUSSED ON PAGE 26
*ENVIRONMENTAL PROTECTION SHOULD BE GIVEN PRIORITY OVER ECONOMIC DEVELOPMENT (5)
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp envcomm, robust

*GLOBAL WARMING AWARENESS (6) 
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp gwawar, robust
	
*GLOBAL WARMING IS ANTHROPOGENIC (7)
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp gwanth, robust
*LEVEL OF DEMOCRACY (8)
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp polity, robust

*EXCLUDING AUTOCRACIES (9)
use domestic NGO and COM replication no autocracy.dta
xtreg popcom ngostr eu nox gdpgrth fisdec ingo exppercgdp, robust

log close
