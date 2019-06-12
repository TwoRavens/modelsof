**************************************************************************
****The following analyses were carried out using Stata version 14.0 for Windows******
**************************************************************************
******User needs spreg.pkg and the xi3.ado file to run the code***

****Replication Analysis for Pacheco SPPQ Article****

clear
use "filepathname.dta, replace


**Preparing data for time series analyses to get lagged variables
xtset state session

************************************************************
***Table 1-spatial lag model, types of policies-introduced; total legislative activity
**Control bills
xi3: spreg code100 i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg code100 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

**Environment bills
xi3: spreg code200 i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg code200 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state  , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

**Litigation bills
xi3: spreg code600 i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg code600 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

**Finance Bills
xi3: spreg code800 i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg code800 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state  , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

***********************************************************
***Table 2--Spatial lag model, types of policies--enacted
***Control Bills
xi3: spreg enact100 i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg enact100 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

**Environment Bills
xi3: spreg enact200 i.session i.state  , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg enact200 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state  , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

**Litigation Bills
xi3: spreg enact600 i.session i.state , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg enact600 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

**Finance Bills
xi3: spreg enact800 i.session i.state  , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg enact800 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state  , spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)

**********************************************************
***Table 3-Spatial Lag model predicting bill introductions with policy adoptions across tobacco categories
xi3: spreg code100 neighcount_code100 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg code200 neighcount_code200 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg code600 neighcount_code600 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
xi3: spreg code800 neighcount_code800 dem2st lib2st pctsmk2 governor_tob demstrst healthcapst i.session i.state, spa(W) id(state2) rowid(stid) colid(wtst) t(session) spat(spattime)
*********************************************************

************
***Table S3
***Percentages reported in Table S3
collapse(sum) counts_tobacco code*, by(state)
gen pctcode100=(code100/counts_tobacco)*100
gen pctcode200=(code200/counts_tobacco)*100
gen pctcode300=(code300/counts_tobacco)*100
gen pctcode400=(code400/counts_tobacco)*100
gen pctcode500=(code500/counts_tobacco)*100
gen pctcode600=(code600/counts_tobacco)*100
gen pctcode800=(code800/counts_tobacco)*100
gen pctcode900=(code900/counts_tobacco)*100


***********
***Data for Figure S1
clear
use "E:\RWJ-Postdoc\Graeme_Project\Shambaugh\SPPQ\Replication Files\SPPQ_Replication.dta"
collapse (sum) counts_tobacco code*, by(session)
gen pctcode100=(code100/counts_tobacco)*100
gen pctcode200=(code200/counts_tobacco)*100
gen pctcode300=(code300/counts_tobacco)*100
gen pctcode400=(code400/counts_tobacco)*100
gen pctcode500=(code500/counts_tobacco)*100
gen pctcode600=(code600/counts_tobacco)*100
gen pctcode800=(code800/counts_tobacco)*100
gen pctcode900=(code900/counts_tobacco)*100








