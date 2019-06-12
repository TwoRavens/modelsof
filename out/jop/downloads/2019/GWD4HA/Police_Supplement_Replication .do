
* Tariq Thachil
* "Does Police Repression Increase Cooperation Among the Urban Poor"
* Replication code for Online Supplement 
* April 2019

** Laborer dataset Thachil_Migrant_Labor.dta
** Vendor datasaet Thachil_Vendor_Labor.dta

* Table A2 (repeat for both Laborers and Vendors)
*Laborers
use "Thachil Police Laborers.dta", replace
tab ME_Police 
tab Room_Police 
tab Leader_Police

tab ME_Rival 
tab Room_Rival
tab Leader_Rival 
 
tab ME_NonCoethnic
tab Room_NonCoethnic
tab Leader_NonCoethnic

*Vendors
use "Thachil Police Vendors.dta", replace
tab ME_Police 
tab Room_Police 
tab Leader_Police

tab ME_Rival 
tab Room_Rival
tab Leader_Rival 
 
tab ME_NonCoethnic
tab Room_NonCoethnic
tab Leader_NonCoethnic


**Tables B1-B3 (Laborers)
use "Thachil Police Laborers.dta", replace
ttest Age, by(ME_Police)
ttest Education, by(ME_Police)
ttest Income, by(ME_Police)
ttest Years_In_City, by(ME_Police)
ttest UpperCaste, by(ME_Police)
ttest MiddleCaste, by(ME_Police)
ttest LowerCaste, by(ME_Police)
ttest Muslim, by(ME_Police)
regress ME_Police Age Education Income Years_In_City MiddleCaste LowerCaste Muslim

*Table B2 
ttest Age, by(Room_Police)
ttest Education, by(Room_Police)
ttest Income, by(Room_Police)
ttest Years_In_City, by(Room_Police)
ttest UpperCaste, by(Room_Police)
ttest MiddleCaste, by(Room_Police)
ttest LowerCaste, by(Room_Police)
ttest Muslim, by(Room_Police)
regress Room_Police Age Education Income Years_In_City MiddleCaste LowerCaste Muslim

*Table B3
ttest Age, by(Leader_Police)
ttest Education, by(Leader_Police)
ttest Income, by(Leader_Police)
ttest Years_In_City, by(Leader_Police)
ttest UpperCaste, by(Leader_Police)
ttest MiddleCaste, by(Leader_Police)
ttest LowerCaste, by(Leader_Police)
ttest Muslim, by(Leader_Police)
regress Leader_Police Age Education Income Years_In_City MiddleCaste LowerCaste Muslim


**Tables B4-B6 (Vendors)
use "Thachil Police Vendors.dta", replace

*Table B4
ttest Age, by(ME_Police)
ttest Education, by(ME_Police)
ttest Income, by(ME_Police)
ttest Years_In_City, by(ME_Police)
ttest UpperCaste, by(ME_Police)
ttest MiddleCaste, by(ME_Police)
ttest LowerCaste, by(ME_Police)
ttest Muslim, by(ME_Police)
regress ME_Police Age Education Income Years_In_City MiddleCaste LowerCaste Muslim

*Table B5 
ttest Age, by(Room_Police)
ttest Education, by(Room_Police)
ttest Income, by(Room_Police)
ttest Years_In_City, by(Room_Police)
ttest UpperCaste, by(Room_Police)
ttest MiddleCaste, by(Room_Police)
ttest LowerCaste, by(Room_Police)
ttest Muslim, by(Room_Police)
regress Room_Police Age Education Income Years_In_City MiddleCaste LowerCaste Muslim

*Table B6
ttest Age, by(Leader_Police)
ttest Education, by(Leader_Police)
ttest Income, by(Leader_Police)
ttest Years_In_City, by(Leader_Police)
ttest UpperCaste, by(Leader_Police)
ttest MiddleCaste, by(Leader_Police)
ttest LowerCaste, by(Leader_Police)
ttest Muslim, by(Leader_Police)

regress Leader_Police Age Education Income Years_In_City MiddleCaste LowerCaste Muslim


**Table B7 
*top panel(Laborers)
use "Thachil Police Laborers.dta", replace
summarize Market_Entry
summarize Room_Entry
summarize Elect_Leader
summarize Age
summarize Education
summarize Years_In_City
summarize Income

*bottom panel(Vendors)
use "Thachil Police Vendors.dta", replace
summarize Market_Entry
summarize Room_Entry
summarize Elect_Leader
summarize Age
summarize Education
summarize Years_In_City
summarize Income


**Table C1**
* Laborer
use "Thachil Police Laborers.dta", replace
xi: regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name)
outreg2 using Table_C1a.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C1: Main Models with Controls and Market FE (Labor)") ctitle ("Economic") addtext (Market FE, YES)  drop (_Ichowk_nam_*)
xi: regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name) 
outreg2 using Table_C1a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)  ctitle ("Social") addtext (Market FE, YES) drop (_Ichowk_nam_*)
xi: regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name) 
outreg2 using Table_C1a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)  ctitle ("Political") addtext (Market FE, YES) drop (_Ichowk_nam_*)

* Vendor
use "Thachil Police Vendors.dta", replace
xi:regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname)
outreg2 using Table_C1b.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C1: Main Models with Controls and Market FE (Vendor)") ctitle ("Economic") addtext (Market FE, YES)  drop (_Imarketnam_*)
xi:regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname)
outreg2 using Table_C1b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)  ctitle ("Social") addtext (Market FE, YES) drop (_Imarketnam*)
xi:regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname)
outreg2 using Table_C1b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)  ctitle ("Political") addtext (Market FE, YES) drop (_Imarketnam_*)

**Table C2**
**Left panel: Cooperation Ethnic Rivals
*Laborers
use "Thachil Police Laborers.dta", replace
xi: regress Market_Entry ME_Police Years_In_City Age Education i.RespondentCasteAll Income  i.chowk_name, robust cluster (chowk_name), if ME_NonCoethnic==1
outreg2 using Table_C2a.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C2a: Cooperation with Ethnic Rivals with Controls and Market FE (Labor)") ctitle ("Laborer") addtext (Market FE, "YES", Baseline Controls, "YES") keep (ME_Police)
xi: regress Room_Entry Room_Police Years_In_City Age Education i.RespondentCasteAll Income  i.chowk_name, robust cluster (chowk_name), if Room_NonCoethnic==1
outreg2 using Table_C2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Room_Police)
xi: regress Elect_Leader Leader_Police Years_In_City Age Education i.RespondentCasteAll Income  i.chowk_name, robust cluster (chowk_name), if Leader_NonCoethnic==1
outreg2 using Table_C2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Leader_Police)

*Vendors
use "Thachil Police Vendors.dta", replace
xi: regress Market_Entry ME_Police Years_In_City Age Education i.RespondentCasteAll Income  i.marketname, robust cluster (marketname), if ME_NonCoethnic==1
outreg2 using Table_C2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor") addtext (Market FE, "YES", Baseline Controls, "YES") keep (ME_Police)
xi: regress Room_Entry Room_Police Years_In_City Age Education i.RespondentCasteAll Income  i.marketname, robust cluster (marketname), if Room_NonCoethnic==1
outreg2 using Table_C2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Room_Police)
xi: regress Elect_Leader Leader_Police Years_In_City Age Education i.RespondentCasteAll Income  i.marketname, robust cluster (marketname), if Leader_NonCoethnic==1
outreg2 using Table_C2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Leader_Police)


**Right panel: Cooperation Economic Rivals
*Laborers
use "Thachil Police Laborers.dta", replace
xi: regress Market_Entry ME_Police Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if ME_Rival==1 
outreg2 using Table_C2b.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C2b: Cooperation with Economic Rivals with Controls and Market FE (Labor)") ctitle ("Laborer") addtext (Market FE, "YES", Baseline Controls, "YES") keep (ME_Police)
xi: regress Room_Entry Room_Police Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if Room_Rival==1 
outreg2 using Table_C2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Room_Police)
xi: regress Elect_Leader Leader_Police Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if Leader_Rival==1 
outreg2 using Table_C2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Leader_Police)

*Vendors
use "Thachil Police Vendors.dta", replace
xi: regress Market_Entry ME_Police Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if ME_Rival==1 
outreg2 using Table_C2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor") addtext (Market FE, "YES", Baseline Controls, "YES") keep (ME_Police)
xi: regress Room_Entry Room_Police Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if Room_Rival==1 
outreg2 using Table_C2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Room_Police)
xi: regress Elect_Leader Leader_Police Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if Leader_Rival==1 
outreg2 using Table_C2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Leader_Police)


** Table C3: Logit (Laborers)
use "Thachil Police Laborers.dta", replace
logit Market_Entry ME_Police ME_Rival ME_NonCoethnic, robust cluster (chowk_name)
outreg2 using Table_C3.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C3: Repression and Cooperation (Labor Markets, LOGIT)") ctitle ("Economic")
logit Room_Entry Room_Police Room_Rival Room_NonCoethnic, robust cluster (chowk_name)
outreg2 using Table_C3.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Social")
logit Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic, robust cluster (chowk_name)
outreg2 using Table_C3.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Political")

* with fixed effects
xi: logit Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name)
outreg2 using Table_C3.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Economic") addtext (Market FE, "YES", Baseline Controls, "YES") keep (ME_Police ME_Rival ME_NonCoethnic)
xi: logit Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name)
outreg2 using Table_C3.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Social") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Room_Police Room_Rival Room_NonCoethnic)
xi: logit Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name)
outreg2 using Table_C3.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Political") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Leader_Police Leader_Rival Leader_NonCoethnic)

** Table C.4: Logit (Vendors)**
use "Thachil Police Vendors.dta", replace
logit Market_Entry ME_Police ME_Rival ME_NonCoethnic, robust cluster (marketname)
outreg2 using Table_C4.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C4: Repression and Cooperation (Vendor Markets, LOGIT)") ctitle ("Economic")
logit Room_Entry Room_Police Room_Rival Room_NonCoethnic, robust cluster (marketname)
outreg2 using Table_C4.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Social")
logit Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic, robust cluster (marketname)
outreg2 using Table_C4.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Political")

* with fixed effects
xi: logit Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname)
outreg2 using Table_C4.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Economic") addtext (Market FE, "YES", Baseline Controls, "YES") keep (ME_Police ME_Rival ME_NonCoethnic)
xi: logit Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname)
outreg2 using Table_C4.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Social") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Room_Police Room_Rival Room_NonCoethnic)
xi: logit Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname)
outreg2 using Table_C4.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Political") addtext (Market FE, "YES", Baseline Controls, "YES") keep (Leader_Police Leader_Rival Leader_NonCoethnic)

**Table C.5**
*laborer
use "Thachil Police Laborers.dta", replace
xi: regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if LongtimeMigrant==1
outreg2 using Table_C5_a.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C5b: Time in the City (Labor Markets)") ctitle ("Veteran") keep (ME_Police)
xi: regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if LongtimeMigrant==0
outreg2 using Table_C5_a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Recent") keep (ME_Police)
xi: regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if LongtimeMigrant==1
outreg2 using Table_C5_a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Veteran") keep (Room_Police)
xi: regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if LongtimeMigrant==0
outreg2 using Table_C5_a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Recent") keep (Room_Police)
xi: regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic LongtimeMigrant Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name),if LongtimeMigrant==1
outreg2 using Table_C5_a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Veteran") keep (Leader_Police)
xi: regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic LongtimeMigrant Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if LongtimeMigrant==0
outreg2 using Table_C5_a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Recent") keep (Leader_Police)

*vendor
use "Thachil Police Vendors.dta", replace
xi: regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if LongtimeMigrant==1
outreg2 using Table_C5b.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table C5b: Time in the City (Vendor Markets)") ctitle ("Veteran") keep (ME_Police)
xi: regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if LongtimeMigrant==0
outreg2 using Table_C5b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Recent") keep (ME_Police)
xi: regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if LongtimeMigrant==1
outreg2 using Table_C5b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Veteran") keep (Room_Police)
xi: regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if LongtimeMigrant==0
outreg2 using Table_C5b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Recent") keep (Room_Police)
xi: regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic LongtimeMigrant Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname),if LongtimeMigrant==1
outreg2 using Table_C5b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Veteran") keep (Leader_Police)
xi: regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic LongtimeMigrant Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if LongtimeMigrant==0
outreg2 using Table_C5b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Recent") keep (Leader_Police)
