************************************************************************************************************
*Name: SFGS Analysis File
*Date: October 2, 2013
*Project: This batch file is intended to read into STATA the response file and join it with the disposition
*file. It also creates some useful analysis variables including agency codes. It also includes commands for
*our Fall 2013 AJPS piece on patronage using the SFGS data.
*
*Description: The batch file includes a set of commands that read into STATA the original survey data along
*with details about the persons surveyed. It drops cases, creates variables and prepares the data for analysis
*It also includes commands that collapse this data in data where agencies are the units of analysis and 
*includes the commands for analyzing this "agency as unit of analysis" data. The collapsed (agency data) is 
*avaiable on the AJPS dataverse site. The original survey data must be obtained from the authors since its
*use is governed by human subjects protections.
************************************************************************************************************
set memory 64000
set l 72
set level 95
set matsize 800

**The following commands connect the disposition file to the response files. The first response file is 
*SFGS_FEB13.dta which is the completed surveys. The second response file is SFGS_FEB13_3.dta, which is
*the partially completed surveys. The file status4oetext.dta includes the responses to open ended questions.

use "/Users/lewisde/Dropbox/Lewis-Hollibaugh Appointments/SFGS Data/SFGS_AllCases.dta"

joinby respnum using "/Users/lewisde/Dropbox/Lewis-Hollibaugh Appointments/SFGS Data/finaldispos4_18v2.dta", unmatched(using)

drop _merge

*idealpoint is Josh's id estimate for each respondent.
*prompt is whether or not respondent got the randmomized prompt  giving them a reminder about confidentiality.
*SFGS_Weight.dta is Dave Nixon's survey response weight data.

joinby respnum using "/Users/lewisde/Dropbox/Lewis-Hollibaugh Appointments/SFGS Data/idealpoint12.dta", unmatched(master)

drop _merge

joinby respnum using "/Users/lewisde/Dropbox/Lewis-Hollibaugh Appointments/SFGS Data/sfgs_jobfunction.dta", unmatched(master)

drop _merge

*merge respnum using \\files\home\delewis\SFGSDATA\status4oetext.dta, unique sort
*generate merge2=_merge
*drop _merge

more

drop if respnum<20000
drop if respnum>29999


**I will now create agency labels that correct for the way that the Federal Yellow Book categorized people.
*I first give each agency that has more than 20 potential respondents a 3-4 letter abbreviation and then they
*can be combined in other ways. There are about 52 of these agencies with at least 20 potential respondents.

sort AGENCY
tab AGENCY, generate (a)

generate agcode="OTH"
replace agcode="HHS" if a7==1
replace agcode="EOP" if a14==1
replace agcode="EXIM" if a15==1
replace agcode="DOT" if a18==1
replace agcode="FCC" if a19==1
replace agcode="DHS" if a21==1
replace agcode="FTC" if a29==1
replace agcode="USDA" if a30==1
replace agcode="IMLS" if a33==1
replace agcode="COM" if a35==1
replace agcode="NASA" if a38==1
replace agcode="NASA" if a43==1
replace agcode="NFAH" if a47==1
replace agcode="HHS" if a49==1
replace agcode="NLRB" if a50==1
replace agcode="NSF" if a52==1
replace agcode="PCOR" if a59==1
replace agcode="SMTH" if a63==1
replace agcode="SSA" if a64==1
replace agcode="USAID" if a68==1
replace agcode="DHS" if a72==1
replace agcode="USDA" if a76==1
replace agcode="COM" if a77==1
replace agcode="DOD" if a78==1
replace agcode="DOED" if a79==1
replace agcode="DOE" if a80==1
replace agcode="HHS" if a81==1
replace agcode="DHS" if a82==1
replace agcode="HUD" if a83==1
replace agcode="DOJ" if a84==1
replace agcode="DOL" if a85==1
replace agcode="STAT" if a86==1
replace agcode="USAF" if a87==1
replace agcode="ARMY" if a88==1
replace agcode="INT" if a89==1
replace agcode="NAVY" if a90==1
replace agcode="DTRS" if a91==1
replace agcode="DOT" if a92==1
replace agcode="DVA" if a93==1
replace agcode="EPA" if a95==1
replace agcode="EEOC" if a96==1
replace agcode="GSA" if a98==1
replace agcode="USITC" if a102==1
replace agcode="NAVY" if a103==1
replace agcode="NARA" if a105==1
replace agcode="NRC" if a106==1
replace agcode="OPM" if a112==1
replace agcode="USPS" if a114==1
replace agcode="SEC" if a116==1
replace agcode="SBA" if a117==1
replace agcode="DVA" if a119==1|a120==1

*Now I will create a second more precise coding of all cabinet departments and independent agencies.
generate agcode2=agcode
*Now some smaller agencies
replace agcode2="CPSC" if AGENCY=="United States Consumer Product Safety Commission"
replace agcode2="FED" if AGENCY=="Federal Reserve System"
replace agcode2="FMC" if AGENCY=="Federal Maritime Commission"
replace agcode2="CFTC" if AGENCY=="Commodity Futures Trading Commission"
replace agcode2="FEC" if AGENCY=="United States Of America Federal Election Commission"

*Now some very small agencies
replace agcode2="ACHP" if AGENCY=="Advisory Council On Historic Preservation"
replace agcode2="ADF" if AGENCY=="African Development Foundation"
replace agcode2="AMTRAK" if AGENCY=="Amtrak [national Railroad Passenger Corporation]"
replace agcode2="ARC" if AGENCY=="Appalachian Regional Commission"
replace agcode2="BBG" if AGENCY=="Broadcasting Board Of Governors"
replace agcode2="CCJJDP" if AGENCY=="Coordinating Council On Juvenile Justice And Delinquency Prevention"
replace agcode2="CNCS"  if AGENCY=="Corporation For National And Community Service"
replace agcode2="FASAB" if AGENCY=="Federal Accounting Standards Advisory Board"
replace agcode2="FDIC" if AGENCY=="Federal Deposit Insurance Corporation"
replace agcode2="FHFB" if AGENCY=="Federal Housing Finance Board"
replace agcode2="FMSHRC" if AGENCY=="Federal Mine Safety And Health Review Commission"
replace agcode2="FRTIB" if AGENCY=="Federal Retirement Thrift Investment Board"
replace agcode2="HSTSF" if AGENCY=="Harry S. Truman Scholarship Foundation"
replace agcode2="JMMFF" if AGENCY=="James Madison Memorial Fellowship Foundation"
replace agcode2="MMC" if AGENCY=="Marine Mammal Commission"
replace agcode2="MKSF" if AGENCY=="Morris K. Udall Scholarship And Excellence In National Environmental Policy Foundation"
replace agcode2="NCPC" if AGENCY=="National Capital Planning Commission"
replace agcode2="NMB" if AGENCY=="National Mediation Board"
replace agcode2="NREC" if AGENCY=="Neighborhood Reinvestment Corporation (Neighborworks« America)"
replace agcode2="USARC" if AGENCY=="United States Arctic Research Commission"
replace agcode2="CSHIB" if AGENCY=="United States Chemical Safety And Hazard Investigation Board"
replace agcode2="USCFA" if AGENCY=="United States Commission Of Fine Arts"
replace agcode2="MSPB" if AGENCY=="United States Merit Systems Protection Board"
replace agcode2="OSHRC" if AGENCY=="United States Occupational Safety And Health Review Commission"
replace agcode2="DNFSB" if AGENCY=="United States Of America Defense Nuclear Facilities Safety Board"
replace agcode2="RRB" if AGENCY=="United States Railroad Retirement Board"

*Now with smaller subunits in the larger agencies. There are about 65 of these smaller subunits within the larger agencies
*that have at least 20 potential respondents.

sort OFFICE
tab OFFICE, generate (o)
generate smagcode="GEN"
replace smagcode="ATL" if o3==1&agcode~="ARMY"
replace smagcode="ACF" if o6==1
replace smagcode="AMS" if o14==1
replace smagcode="ARS" if o15==1
replace smagcode="ATO" if o18==1
replace smagcode="APHIS" if o28==1
replace smagcode="BLS" if o142==1
replace smagcode="BLM" if o143==1
replace smagcode="CEN" if o157==1
replace smagcode="CDC" if o168==1
replace smagcode="CMMS" if o169==1
replace smagcode="CIV" if o188==1
replace smagcode="CMPR" if o196==1
replace smagcode="CMPT" if o199==1
replace smagcode="DLA" if o224==1
replace smagcode="DICIN" if o285==1
replace smagcode="DIENG" if o287==1
replace smagcode="DIMP" if o291==1
replace smagcode="ESDIV" if o309==1
replace smagcode="ETA" if o318==1
replace smagcode="FAA" if o342==1
replace smagcode="BOP" if o344==1
replace smagcode="FEMA" if o345==1
replace smagcode="FERC" if o346==1
replace smagcode="FHWA" if o348==1
replace smagcode="FMCSA" if o350==1
replace smagcode="FTA" if o357==1
replace smagcode="FDA" if o372==1
replace smagcode="FNS" if o373==1
replace smagcode="USFS" if o377==1
replace smagcode="USACE" if o397==1
replace smagcode="HRSA" if o400==1
replace smagcode="IHS" if o409==1
replace smagcode="IRS" if o428==1
replace smagcode="JCS" if o445==1
replace smagcode="NHTSA" if o519==1
replace smagcode="NIST" if o525==1
replace smagcode="NIH" if o526==1
replace smagcode="NOAA" if o529==1
replace smagcode="NRCS" if o545==1
replace smagcode="NII" if o550==1
replace smagcode="OSHA" if o558==1
replace smagcode="OScD" if o559==1
replace smagcode="OMB" if o667==1
replace smagcode="AAG" if o749==1
replace smagcode="DAG" if o766==1
replace smagcode="OLA" if o778==1
replace smagcode="OPGCE" if o781==1
replace smagcode="NNSA" if o798==1
replace smagcode="DDPR" if o826==1
replace smagcode="AGRD" if o924==1
replace smagcode="USPTO" if o980==1
replace smagcode="STMA" if o989==1
replace smagcode="STPA" if o990==1
replace smagcode="USAR" if o993==1
replace smagcode="USNV" if o994==1
replace smagcode="UEDV" if o995==1
replace smagcode="CBP" if o999==1
replace smagcode="USMC" if o1006==1
replace smagcode="VBA" if o1019==1
replace smagcode="VHA" if o1020==1
replace smagcode="VCNO" if o1024==1
replace smagcode="VCAR" if o1025==1&agcode=="ARMY"
replace smagcode="VCAF" if o1025==1&agcode=="USAF"

more
*This command will create an agency code that includes sub-units as the most relevant unit and where a sub-unit has 
*less than 20 respondents the agency is the most relevant unit.

generate agcode4=smagcode
replace agcode4=agcode2 if smagcode=="GEN"


*It is worthwhile to verify these agency codes since they are dependent upon the ordering of the disposition file.
*If the disposition file is altered or ordered differently, these codes are meaningless. I would recommend running
*the following commands:

list smagcode agcode AGENCY OFFICE if o778==1
list smagcode agcode AGENCY OFFICE if o545==1
list smagcode agcode AGENCY OFFICE if o168==1

*Now I drop some agencies that are either private, multi-lateral or multi-state compacts.

drop if AGENCY =="Delaware River Basin Commission"
drop if AGENCY =="National Gallery Of Art"
drop if AGENCY =="Susquehanna River Basin Commission"
drop if AGENCY =="Japan - United States Friendship Commission"
more

*Disp is from the feb release of this data and I believe refers to partials where people got as far as refusing to take the survey?
generate respond=0
replace respond=1 if status==4
replace respond=1 if status==3
tab respond
generate status5=1 if status>2 & status~=.


*These next commands connect the survey data to outside OPM data on employment and appointees and also Clinton-Lewis Ideology
*scores.

joinby agcode2 using "/Users/lewisde/Dropbox/Lewis-Hollibaugh Appointments/SFGS Data/agcode2opmdatav4.dta", unmatched(master)

drop _merge

**STRUCTURAL VARIABLES**
*Generate appointment authority codes
generate appointee=0
replace appointee=1 if member==1|member==2|member==5
replace appointee=. if member==.

*To sort out the IG Offices
generate OIG=0
replace OIG =1 if o647==1
replace OIG=1 if o777==1

*To sort out the GC Offices. This includes the Solicitor's Office in the Labor and Interior Departments (o791)
generate OGC=0
replace OGC=1 if o626==1
replace OGC=1 if o776==1
replace OGC=1 if o791==1

*Now whether or not the agency is on the president's agenda
generate agenda1=0

replace agenda1=1 if a41==1|a57==1|a56==1|a64==1|a78==1|a79==1|a80==1|a81==1|a82==1|a86==1|a87==1|a88==1|a89==1|a90==1|a91==1|a92==1
replace agenda1=1 if a14==1&o667==1

*Now I will identify the Independent Commissions
*First with only major independent commissions.
generate com1=0
replace com1=1 if agcode2=="EEOC"|agcode2=="FCC"|agcode2=="FTC"|agcode2=="NLRB"|agcode2=="NRC"|agcode2=="SEC"
replace com1=1 if agcode2=="USITC"|agcode2=="EXIM"|agcode2=="CPSC"|agcode2=="FED"|agcode2=="FMC"|agcode2=="CFTC"
replace com1=1 if agcode2=="FEC"|agcode2=="NTSB"|agcode2=="NMB"|agcode2=="FDIC"|agcode2=="FHFB"
replace com1=1 if agcode2=="BBG"|agcode2=="CNCS"|agcode2=="MSPB"|agcode2=="RRB"|agcode2=="DNFSB"|agcode2=="OSHRC"

*Now including some minor Independent Commissions
generate com2=com1
replace com2=1 if agcode2=="FMSHRC"|agcode2=="ACHP"|agcode2=="FRTIB"|agcode2=="MMC"|agcode2=="FASAB"|agcode2=="HSTSF"
replace com2=1 if agcode2=="JMMFF"|agcode2=="MKSF"|agcode2=="CCJDP"|agcode2=="NCPC"|agcode2=="NREC"
replace com2=1 if agcode2=="ADF"|agcode2=="ARC"|agcode2=="USARC"|agcode2=="CSHIB"|agcode2=="USCFA"

*Now a third, more restrictive definition of commissions, using only IRCs.
generate com3=0
replace com3=1 if agcode2=="EEOC"|agcode2=="FCC"|agcode2=="FTC"|agcode2=="NLRB"|agcode2=="NRC"|agcode2=="SEC"
replace com3=1 if agcode2=="CPSC"|agcode2=="FED"|agcode2=="FMC"|agcode2=="CFTC"
replace com3=1 if agcode2=="FEC"

*I do not include IMLS, OPIC, TVA, or Smithsonian as commissions because boards are more 
*advisory or like boards of directors. PBGC headed by director who reports to secretaries 
*of labor, commerce, etc. It excludes US Interagency Council on Homeless as an interagency body.

*I also drop the NSF since it includes too many non-executives. The original population data incorrectly included 461
* potential respondents from the NSF because it labeled rotating program officers as executives.

drop if agcode2=="NSF"

*Now I create an indicator for advisory commissions
generate advisory=0
replace advisory=1 if agcode2=="ACHP"|agcode2=="FASAB"|agcode2=="MMC"|agcode2=="USCFA"|agcode2=="CCJDP"

*Now I create an indicator for very minor independent agencies
generate minor=0
replace minor=1 if agcode2=="ACHP"|agcode2=="MKSF"|agcode2=="CCJDP"|agcode2=="FASAB"|agcode2=="JMMFF"|agcode=="HSTSF"
replace minor=1 if agcode2=="JUSFC"|agcode2=="MMC"|agcode2=="NREC"|agcode2=="USARC"|agcode2=="USCFA"

generate minor2=0
replace minor2=1 if agcode2=="FMSHRC"|agcode2=="ACHP"|agcode2=="FRTIB"|agcode2=="MMC"|agcode2=="FASAB"|agcode2=="HSTSF"
replace minor2=1 if agcode2=="JMMFF"|agcode2=="MKSF"|agcode2=="CCJDP"|agcode2=="NCPC"|agcode2=="NREC"|agcode2=="DNFSB"|agcode2=="OSHRC"
replace minor2=1 if agcode2=="ADF"|agcode2=="ARC"|agcode2=="USARC"|agcode2=="CSHIB"|agcode2=="USCFA"|agcode2=="NMB"|agcode2=="IMLS"

*generate bushagenda2=bushagenda
*replace bushagenda2=0 if a11==1
*replace bushagenda2=0 if a91==1

generate bushagenda3=0
replace bushagenda3=1 if a41==1|a57==1|a56==1|a64==1|a78==1|a79==1|a80==1|a82==1|a86==1|a87==1|a88==1|a90==1|a91==1
replace bushagenda3=1 if a95==1|o169==1| o372==1| o143==1| o519==1|a103==1
replace bushagenda3=1 if a14==1&o667==1

*generate military agency indicator
generate milage=0
replace milage=1 if a78==1| a87==1| a88==1| a90==1| a103==1| a57==1

*generate military and intelligence agencies
generate milage1=0
replace milage1=1 if a78==1| a87==1| a88==1| a90==1| a103==1| a57==1| a56==1

*generate foreign affairs and defense
generate famil=0
replace famil=1 if a78==1| a87==1| a88==1| a90==1| a103==1| a57==1| a56==1|a118==1|a86==1|a68==1|a59==1|a41==1|a34==1|a37==1|a6==1|a2==1

**RESPONDENT VARIABLES**
*Now to identify partyid
generate democrat=0
replace democrat=. if polparty==.
replace democrat=1 if polparty==2
replace democrat=1 if polpartylean==2

*Generate variable for work in a regional office
generate regional=0
replace regional=1 if workplace==2

*Generate a variable for amount of contact with appointees.
generate appcontact=6-group2_6 if group2_6~=6

**VARIABLES SUMMARIZING RELEVANT QUESTIONS BY AGENCIES**
*Now I create some agency-specific variables. Each is a mean of responses. Some have to be multiplied by negative one to have
*higher values indicate what I want them to.

*This first set is just for appointees.
by agcode2, sort: egen apideomean=mean(polview) if polview~=8&appointee==1
by agcode2, sort: egen appideology=max(apideomean)
by agcode2, sort: egen apidpoint=mean(idealpoint) if appointee==1
by agcode2, sort: egen appidest=max(apidpoint)
generate appidest1=appidest*(-1)
by agcode2, sort: egen numrep=count(status5)

**DROP APPOINTEES SO THAT RESPONSES REMAINING ARE ONLY CAREERISTS**
*This next set is general, calculated using only the opinions of career professionals in the agency.

*drop if appointee==1

*These are partisan or ideological averages for the agencies.
by agcode2, sort: egen pctdem=mean(democrat) if appointee==0
by agcode2, sort: egen ideomean=mean(polview) if polview~=8&appointee==0
by agcode2, sort: egen idpoint=mean(idealpoint) if appointee==0
generate idpoint1=idpoint*(-1)
by agcode2, sort: egen idpointavg=mode(idpoint)

generate lnemp=ln(employment2007)
generate techpct=techemp2007/employment2007
generate pctprof=proemp/employment2007
generate pctblue=bluecollar/employment2007
generate pctclerical=clerical/employment2007
generate professional=ln(1+pctprof)-ln(1+(pctblue+pctclerical))
generate republican=0 if polparty~=.
replace republican=1 if polparty==1
generate democrat1=0 if polparty~=.
replace democrat1=1 if polparty==2

**Now the primary dependent variable
generate connections=jobset_8 if jobset_8~=5


more

***The following analysis is what appears in the appendix. All of the commands up to this point take the survey data and create a series of variables that were used in earlier iterations of the 
***paper. Persons interested in replicated can have the agency data below without question. Persons wanting to replicate the creation of the agency dataset will need to talk to the authors
***because use of the data is governed by protocols specified in human subjects review documents.

*Now with  an agency dataset
*collapse (mean) connections clinton idpointavg lnemp bushagenda3 professional numrep com1 pctdem pctprof regional yremp1 appcontact appointee (median) medcon=connections medappcon=appcontact medagenda=bushagenda, by(agcode2)
*generate bushln=bushagenda3*lnemp

*Main specifications
tobit connections professional bushagenda3 lnemp clinton [aweight=numrep], ul(4)
tobit connections professional bushagenda3 lnemp clinton appcontact yremp1 regional appointee [aweight=numrep], ul(4)
tobit connections professional bushagenda3 lnemp clinton bushln [aweight=numrep], ul(4)
tobit connections professional bushagenda3 lnemp clinton bushln appcontact yremp1 regional appointee [aweight=numrep], ul(4)
ologit medcon professional bushagenda3 lnemp clinton appcontact yremp1 regional appointee [aweight=numrep]
