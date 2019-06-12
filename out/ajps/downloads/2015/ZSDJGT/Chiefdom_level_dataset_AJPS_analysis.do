**CONNECTIONS ANALYSIS**

use Zambian_chiefdom_dataset.dta

***************************

**MAIN ARTICLE**

*TABLE 1*

ologit tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief if missingchief08==0, cluster(constcode)
ologit tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief MMD06 voteMP06 diffvoteconst06 if missingchief08==0, cluster(constcode)
ologit tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief univMP cabinetMP localMP agechief secondaryedchief politicalexpchief if missingchief08==0, cluster(constcode)

*TABLE 2*

reg incumbvote06 diffconnectionsincumbopp incumbvote01 incumbcand MMD01 UPND01 numcand experienceincumbent if yearinstalledchief<2006, cluster(constcode)
reg incumbvote06 diffconnectionsincumbopp incumbvote01 incumbcand MMD01 UPND01 numcand experienceincumbent localincumbent localoppcandidate if yearinstalledchief<2006, cluster(constcode)

****************************

**SUPPLEMENTARY INFORMATION**

*TABLE 1*

summarize connectionsMPchief tempclass08 tempclass07 pop1000 experienceMP experiencechief MMD06 voteMP06 diffvoteconst univMP cabinetMP localMP secondaryedchief politicalexpchief agechief if missingchief08==0
summarize incumbvote06 diffconnectionsincumbopp incumbvote01 incumbcand MMD01 UPND01 numcand experienceincumbent localincumbent localoppcandidate if yearinstalledchief <2006
summarize connectionsMPchief tempclass08 tempclass07 pop1000 experienceMP experiencechief MMD06 voteMP06 diffvoteconst univMP cabinetMP localMP secondaryedchief politicalexpchief agechief if missingchief08==0, detail
summarize incumbvote06 diffconnectionsincumbopp incumbvote01 incumbcand MMD01 UPND01 numcand experienceincumbent localincumbent localoppcandidate if yearinstalledchief <2006, detail


*TABLE 2*

ologit tempclass08 connectionsMPchief tempclass07 pop1000 classneedper100 experienceMP experiencechief if missingchief08==0, cluster(constcode)
ologit tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief schoolsoutsidechpp changeclasspp0206 if missingchief08==0, cluster(constcode)
ologit tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief MMD06 voteMP06 diffvoteconst percturnout if missingchief08==0, cluster(constcode)

*TABLE 3*

reg tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief if missingchief08==0, cluster(constcode)
reg tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief MMD06 voteMP06 diffvoteconst06 if missingchief08==0, cluster(constcode)
reg tempclass08 connectionsMPchief tempclass07 pop1000 experienceMP experiencechief univMP cabinetMP localMP agechief secondaryedchief politicalexpchief if missingchief08==0, cluster(constcode)

*TABLE 4*
**NOTE: P-VALUES IN TABLE WERE CALCULATED USING WILD-BOOTSTRAP METHOD AND DO NOT MATCH THE NUMBERS CALCULATED VIA BASIC OLS**

reg percgoodroads connectionsoldMPchief pop1000 MMD01 percpriorityroads if yearinstalledchief<2006 & incumbcand==1, cluster(constcode)

*TABLE 5*

logit MPresponsetochief connectionsMPchief pop1000 MMD06 experienceMP localMP experiencechief if yearinstalledchief!=2007, cluster(constcode)
logit landconversionbychief connectionsMPchief pop1000 MMD06 experienceMP experiencechief if yearinstalledchief!=2007, cluster(constcode)
logit landconversionbychief connectionsMPchief pop1000 MMD06 experienceMP localMP experiencechief if yearinstalledchief!=2007, cluster(constcode)

*TABLE 6*

reg incumbvote06 diffconnectionsincumbopp incumbvote01 MMD01 UPND01 numcand if yearinstalledchief<2006 & experienceincumbent==0, cluster(constcode)
reg incumbvote06 diffconnectionsincumbopp incumbvote01 incumbcand MMD01 UPND01 numcand if yearinstalledchief<2006 & metinoffice!=1, cluster(constcode)

