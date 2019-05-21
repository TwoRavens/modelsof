** Replication Code for "Does Police Repression Spur Everyday Cooperation ** 
** Tariq Thachil, Vanderbilt University 
** May 2019

***********************
******* TABLE 1 *******
***********************

*Left Panel: Models 1-3
use "Thachil Police Laborers.dta", replace
regress Market_Entry ME_Police ME_Rival ME_NonCoethnic, robust cluster (chowk_name)
outreg2 using Table_1a.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 1: Police Repression and Migrant Cooperation (Labor Sample)")

regress Room_Entry Room_Police Room_Rival Room_NonCoethnic, robust cluster (chowk_name)
outreg2 using Table_1a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)

regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic, robust cluster (chowk_name)
outreg2 using Table_1a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)

*Right Panel: Models 4-6
use "Thachil Police Vendors.dta", replace

regress Market_Entry ME_Police ME_Rival ME_NonCoethnic, robust cluster (marketname)
outreg2 using Table_1b.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 1: Police Repression and Migrant Cooperation (Vendor Sample)")

regress Room_Entry Room_Police Room_Rival Room_NonCoethnic, robust cluster (marketname)
outreg2 using Table_1b.doc, append se dec(3) nocons nor2  alpha (.01, .05, .1) symbol (***, **, *)

regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic, robust cluster (marketname)
outreg2 using Table_1b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)

***********************
******* TABLE 2 *******
***********************

** ETHNIC RIVALS 
*Laborers
use "Thachil Police Laborers.dta", replace
regress Market_Entry ME_Police, robust cluster (chowk_name), if ME_NonCoethnic==1
outreg2 using Table_2a.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 2: Cooperation with Ethnic Rivals") ctitle ("Laborer")

regress Room_Entry Room_Police, robust cluster (chowk_name), if Room_NonCoethnic==1
outreg2 using Table_2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer")

regress Elect_Leader Leader_Police, robust cluster (chowk_name), if Leader_NonCoethnic==1
outreg2 using Table_2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer")

** VENDORS
use "Thachil Police Vendors.dta", replace
regress Market_Entry ME_Police, robust cluster (marketname), if ME_NonCoethnic==1
outreg2 using Table_2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor")

regress Room_Entry Room_Police, robust cluster (marketname), if Room_NonCoethnic==1
outreg2 using Table_2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor")

regress Elect_Leader Leader_Police, robust cluster (marketname), if Leader_NonCoethnic==1
outreg2 using Table_2a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor")


** ECONOMIC RIVALS
*Laborers
use "Thachil Police Laborers.dta", replace
regress Market_Entry ME_Police, robust cluster (chowk_name), if ME_Rival==1 
outreg2 using Table_2b.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 2: Cooperation with Economic Rivals") ctitle ("Laborer")

regress Room_Entry Room_Police, robust cluster (chowk_name), if Room_Rival==1 
outreg2 using Table_2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer")

regress Elect_Leader Leader_Police, robust cluster (chowk_name), if Leader_Rival==1 
outreg2 using Table_2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Laborer")

*Vendors
use "Thachil Police Vendors.dta", replace
regress Market_Entry ME_Police, robust cluster (marketname), if ME_Rival==1 
outreg2 using Table_2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor")

regress Room_Entry Room_Police, robust cluster (marketname), if Room_Rival==1 
outreg2 using Table_2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor")

regress Elect_Leader Leader_Police, robust cluster (marketname), if Leader_Rival==1 
outreg2 using Table_2b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Vendor")

***********************
******* TABLE 3 *******
***********************

**Observed Repression
*Labor sample
use "Thachil Police Laborers.dta", replace
xi: regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if High_Observed_Repression==1
outreg2 using Table_3a.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 3: Heterogeneous Treatment Effects and Experienced Repression (Labor)") ctitle ("High Repression") addtext(Market FE, YES) keep (ME_Police)
xi: regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if High_Observed_Repression==0
outreg2 using Table_3a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Low Repression") addtext(Market FE, YES) keep (ME_Police)

xi: regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if High_Observed_Repression==1
outreg2 using Table_3a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("High Repression") addtext(Market FE, YES) keep (Room_Police)
xi: regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if High_Observed_Repression==0
outreg2 using Table_3a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Low Repression") addtext(Market FE, YES) keep (Room_Police)

xi: regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic LongtimeMigrant Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name),if High_Observed_Repression==1
outreg2 using Table_3a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("High Repression") addtext(Market FE, YES) keep (Leader_Police)
xi: regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic LongtimeMigrant Age Education i.RespondentCasteAll Income i.chowk_name, robust cluster (chowk_name), if High_Observed_Repression==0
outreg2 using Table_3a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Low Repression") addtext(Market FE, YES) keep (Leader_Police)

*Vendor
use "Thachil Police Vendors.dta", replace
xi:regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if High_Observed_Repression==1
outreg2 using Table_3b.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 3a: Heterogeneous Treatment Effects and Experienced Repression (Vendor)") ctitle ("High Repression") addtext(Market FE, YES) keep (ME_Police)
xi:regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if High_Observed_Repression==0
outreg2 using Table_3b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Low Repression") addtext(Market FE, YES) keep (ME_Police)

xi:regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if High_Observed_Repression==1
outreg2 using Table_3b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("High Repression") addtext(Market FE, YES) keep (Room_Police)
xi:regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if High_Observed_Repression==0
outreg2 using Table_3b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Low Repression") addtext(Market FE, YES) keep (Room_Police)

xi:regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if High_Observed_Repression==1
outreg2 using Table_3b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("High Repression") addtext(Market FE, YES) keep (Leader_Police)
xi:regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if High_Observed_Repression==0 
outreg2 using Table_3b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Low Repression") addtext(Market FE, YES) keep (Leader_Police)


*bottom panel (Experienced Repression, Vendors)
xi:regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if ExperiencedRepression==1
outreg2 using Table_3c.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 3: Heterogeneous Treatment Effects and Experienced Repression (Vendor)") ctitle ("Experience") addtext(Market FE, YES) keep (ME_Police)
xi:regress Market_Entry ME_Police ME_Rival ME_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if ExperiencedRepression==0
outreg2 using Table_3c.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("No Experience") addtext(Market FE, YES) keep (ME_Police) 

xi:regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if ExperiencedRepression==1
outreg2 using Table_3c.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Experience") addtext(Market FE, YES) keep (Room_Police)
xi:regress Room_Entry Room_Police Room_Rival Room_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if ExperiencedRepression==0
outreg2 using Table_3c.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("No Experience") addtext(Market FE, YES) keep (Room_Police)

xi:regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if ExperiencedRepression==1
outreg2 using Table_3c.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Experience") addtext(Market FE, YES) keep (Leader_Police)
xi:regress Elect_Leader Leader_Police Leader_Rival Leader_NonCoethnic Years_In_City Age Education i.RespondentCasteAll Income i.marketname, robust cluster (marketname), if ExperiencedRepression==0
outreg2 using Table_3c.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("No Experience") addtext(Market FE, YES) keep (Leader_Police)


***********************
******* TABLE 4 *******
***********************

*Laborer (Observed Repression)
use "Thachil Police Laborers.dta", replace
regress Lent_Money High_Observed_Repression Years_In_City Age Education i.RespondentCasteAll Income  
outreg2 using Table_4a.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 4a: Observed Repression (Laborers)") ctitle ("Lent Money") keep (High_Observed_Repression) addtext(Controls, YES)
regress Close_Friends High_Observed_Repression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Close Friends") keep (High_Observed_Repression) addtext(Controls, YES)
regress Market_Unity High_Observed_Repression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4a.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)ctitle ("Market Unity") keep (High_Observed_Repression) addtext(Controls, YES)

**Vendor 
use "Thachil Police Vendors.dta", replace

*(Observed Repression)
regress Lent_Money High_Observed_Repression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 4b: Observed Repression (Vendors)") ctitle ("Lent Money") keep (High_Observed_Repression) addtext(Controls, YES)
regress Close_Friends High_Observed_Repression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Close Friends") keep (High_Observed_Repression) addtext(Controls, YES)
regress Market_Unity High_Observed_Repression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4b.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)ctitle ("Market Unity") keep (High_Observed_Repression) addtext(Controls, YES)

*(Experienced Repression)
regress Lent_Money ExperiencedRepression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4c.doc, replace se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) title ("Table 4c: Experienced Repression (Vendors)") ctitle ("Lent Money") keep (ExperiencedRepression) addtext(Controls, YES)
regress Close_Friends ExperiencedRepression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4c.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *) ctitle ("Close Friends") keep (ExperiencedRepression) addtext(Controls, YES)
regress Market_Unity ExperiencedRepression Years_In_City Age Education i.RespondentCasteAll Income 
outreg2 using Table_4c.doc, append se dec(3) nocons nor2 alpha (.01, .05, .1) symbol (***, **, *)ctitle ("Market Unity") keep (ExperiencedRepression) addtext(Controls, YES)




