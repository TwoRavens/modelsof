****************************************************************
* Replication code for Online Supporting Information (SI)
* "How Clients Select Brokers"
* Adam Auerbach and Tariq Thachil
* May 2018
****************************************************************


** ONLINE SUPPORTING INFORMATION (SI) 

use "AuerbachThachilSlumResidents.dta"

********************************************************Table S.1: MAIN RESULTS******************************************************************************************************************************************************************
* column 1:Leader Experiment
regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta ib3.Neta_Caste_Rank Neta_Copartisan ib2.Neta_Party_Profile  ib3.Neta_Work  ib2.Neta_Education, robust cluster (RespondentID)

* column 2: Neighbor Experiment
regress Preferred_Neighbor_Profile CoEthnic_Jati_Neighbor Neighbor_CoEthnic_Religion CoEthnic_State_Neighbor ib3.Neighbor_Caste_Rank  Neighbor_Copartisan ib2.Neighbor_Party_Profile  ib3.Neighbor_Work ib2.Neighbor_Education, robust cluster (RespondentID), 

********************************************************Table S.2: Randomization Check******************************************************************************************************************************************************************

regress Gender CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College, robust cluster (RespondentID)
test CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary 

regress High_Income CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College, robust cluster (RespondentID)
test CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary 

regress Veteran CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College, robust cluster (RespondentID)
test CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary 

regress Above_Primary CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College, robust cluster (RespondentID)
test CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary 

******************************************************** Table S.3: Model with Baseline Controls************************************************************************************************************
regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College Gender Veteran Above_Primary High_Income, robust cluster (RespondentID)

******************************************************** Table S.4: Experiment Order Effects************************************************************************************************************
*Leader
regress Preferred_Profile CoEthnic_Jati_Neta##NetaQFirstInOrder CoEthnic_Religion_Neta##NetaQFirstInOrder CoEthnic_State_Neta##NetaQFirstInOrder Muslim_Neta##NetaQFirstInOrder Dalit_Neta##NetaQFirstInOrder Neta_Copartisan##NetaQFirstInOrder Neta_Incumbent##NetaQFirstInOrder Neta_Opposition##NetaQFirstInOrder Vertical_Connectivity##NetaQFirstInOrder Outside_Slum##NetaQFirstInOrder Neta_College##NetaQFirstInOrder Neta_Secondary##NetaQFirstInOrder, robust cluster (RespondentID)
test 1.CoEthnic_Jati_Neta#1.NetaQFirstInOrder 1.CoEthnic_Religion_Neta#1.NetaQFirstInOrder 1.CoEthnic_State_Neta#1.NetaQFirstInOrder 1.Muslim_Neta#1.NetaQFirstInOrder 1.Dalit_Neta#1.NetaQFirstInOrder 1.Neta_Copartisan#1.NetaQFirstInOrder 1.Neta_Incumbent#1.NetaQFirstInOrder 1.Neta_Opposition#1.NetaQFirstInOrder 1.Vertical_Connectivity#1.NetaQFirstInOrder 1.Outside_Slum#1.NetaQFirstInOrder 1.Neta_College#1.NetaQFirstInOrder 1.Neta_Secondary#1.NetaQFirstInOrder

*Neighbor
regress Preferred_Neighbor_Profile CoEthnic_Jati_Neighbor##NetaQFirstInOrder Neighbor_CoEthnic_Religion##NetaQFirstInOrder CoEthnic_State_Neighbor##NetaQFirstInOrder Neighbor_Dalit##NetaQFirstInOrder Neighbor_Muslim##NetaQFirstInOrder Neighbor_Copartisan##NetaQFirstInOrder Neighbor_Incumbent##NetaQFirstInOrder Neighbor_Opposition##NetaQFirstInOrder Vertical_Connectivity_Neighbor##NetaQFirstInOrder Neighbor_OutsideJob##NetaQFirstInOrder Neighbor_Secondary##NetaQFirstInOrder Neighbor_College##NetaQFirstInOrder, robust cluster (RespondentID) 
test 1.CoEthnic_Jati_Neighbor#1.NetaQFirstInOrder 1.Neighbor_CoEthnic_Religion#1.NetaQFirstInOrder 1.CoEthnic_State_Neighbor#1.NetaQFirstInOrder 1.Neighbor_Muslim#1.NetaQFirstInOrder 1.Neighbor_Dalit#1.NetaQFirstInOrder 1.Neighbor_Copartisan#1.NetaQFirstInOrder 1.Neighbor_Incumbent#1.NetaQFirstInOrder 1.Neighbor_Opposition#1.NetaQFirstInOrder 1.Vertical_Connectivity_Neighbor#1.NetaQFirstInOrder 1.Neighbor_OutsideJob#1.NetaQFirstInOrder 1.Neighbor_College#1.NetaQFirstInOrder 1.Neighbor_Secondary#1.NetaQFirstInOrder

********************************************************** Table S.5: PROFILE ORDER EFFECTS******************************************************************************************************************
regress Preferred_Profile CoEthnic_Jati_Neta##Neta_First_Profile CoEthnic_Religion_Neta##Neta_First_Profile CoEthnic_State_Neta##Neta_First_Profile Muslim_Neta##Neta_First_Profile Dalit_Neta##Neta_First_Profile Neta_Copartisan##Neta_First_Profile Neta_Incumbent##Neta_First_Profile Neta_Opposition##Neta_First_Profile Vertical_Connectivity##Neta_First_Profile Outside_Slum##Neta_First_Profile Neta_College##Neta_First_Profile Neta_Secondary##Neta_First_Profile, robust cluster (RespondentID)
test 1.CoEthnic_Jati_Neta#1.Neta_First_Profile 1.CoEthnic_Religion_Neta#1.Neta_First_Profile 1.CoEthnic_State_Neta#1.Neta_First_Profile 1.Muslim_Neta#1.Neta_First_Profile 1.Dalit_Neta#1.Neta_First_Profile 1.Neta_Copartisan#1.Neta_First_Profile 1.Neta_Incumbent#1.Neta_First_Profile 1.Neta_Opposition#1.Neta_First_Profile 1.Vertical_Connectivity#1.Neta_First_Profile 1.Outside_Slum#1.Neta_First_Profile 1.Neta_College#1.Neta_First_Profile 1.Neta_Secondary#1.Neta_First_Profile

************************************************* Table S.6: DROPPING ATYPICAL CANDIDATE PROFILES******************************************************************
**excluding Muslim BJP candidates
generate Muslim_BJP1=1 if Neta_Jati1>8&Neta_Party1==0
recode Muslim_BJP1 (.=0)
generate Muslim_BJP2=1 if Neta_Jati2>8&Neta_Party2==0
recode Muslim_BJP2 (.=0)

regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary, robust cluster (RespondentID), if Muslim_BJP1==0&Muslim_BJP2==0 

**********************************************************ATTRIBUTE ORDER************************************************************************************************************************************************************************
* Regress the choice outcome on the attribute values, dummies for the row position of the attributes (1-5), and the interactions between the two (attribute order 1 set as baseline). 
regress Preferred_Profile CoEthnic_Jati_Neta##NetaJatiOrder Dalit_Neta##NetaJatiOrder Muslim_Neta##NetaJatiOrder CoEthnic_Religion_Neta##NetaJatiOrder CoEthnic_State_Neta##NetaStateOrder Neta_Copartisan##NetaPartyOrder Neta_Incumbent##NetaPartyOrder Neta_Opposition##NetaPartyOrder Vertical_Connectivity##NetaWorkOrder Outside_Slum##NetaWorkOrder Neta_Secondary##NetaEducationOrder Neta_College##NetaEducationOrder

test 1.CoEthnic_Jati_Neta#2.NetaJatiOrder 1.CoEthnic_Jati_Neta#3.NetaJatiOrder 1.CoEthnic_Jati_Neta#4.NetaJatiOrder 1.CoEthnic_Jati_Neta#5.NetaJatiOrder 
test 1.CoEthnic_Religion_Neta#2.NetaJatiOrder 1.CoEthnic_Religion_Neta#3.NetaJatiOrder 1.CoEthnic_Religion_Neta#4.NetaJatiOrder 1.CoEthnic_Religion_Neta#5.NetaJatiOrder
test 1.CoEthnic_State_Neta#2.NetaStateOrder 1.CoEthnic_State_Neta#3.NetaStateOrder 1.CoEthnic_State_Neta#4.NetaStateOrder 1.CoEthnic_State_Neta#5.NetaStateOrder
test 1.Dalit_Neta#2.NetaJatiOrder 1.Dalit_Neta#3.NetaJatiOrder 1.Dalit_Neta#4.NetaJatiOrder 1.Dalit_Neta#5.NetaJatiOrder 
test 1.Muslim_Neta#2.NetaJatiOrder 1.Muslim_Neta#3.NetaJatiOrder 1.Muslim_Neta#4.NetaJatiOrder 1.Muslim_Neta#5.NetaJatiOrder 
test 1.Neta_Copartisan#2.NetaPartyOrder 1.Neta_Copartisan#3.NetaPartyOrder 1.Neta_Copartisan#4.NetaPartyOrder 1.Neta_Copartisan#5.NetaPartyOrder
test 1.Neta_Incumbent#2.NetaPartyOrder 1.Neta_Incumbent#3.NetaPartyOrder 1.Neta_Incumbent#4.NetaPartyOrder 1.Neta_Incumbent#5.NetaPartyOrder
test 1.Neta_Opposition#2.NetaPartyOrder 1.Neta_Opposition#3.NetaPartyOrder 1.Neta_Opposition#4.NetaPartyOrder 1.Neta_Opposition#5.NetaPartyOrder
test 1.Vertical_Connectivity#2.NetaWorkOrder 1.Vertical_Connectivity#3.NetaWorkOrder 1.Vertical_Connectivity#4.NetaWorkOrder 1.Vertical_Connectivity#5.NetaWorkOrder
test 1.Outside_Slum#2.NetaWorkOrder 1.Outside_Slum#3.NetaWorkOrder 1.Outside_Slum#4.NetaWorkOrder 1.Outside_Slum#5.NetaWorkOrder
test 1.Neta_Secondary#1.NetaEducationOrder 1.Neta_Secondary#2.NetaEducationOrder 1.Neta_Secondary#3.NetaEducationOrder 1.Neta_Secondary#4.NetaEducationOrder 1.Neta_Secondary#5.NetaEducationOrder
test 1.Neta_College#1.NetaEducationOrder 1.Neta_College#2.NetaEducationOrder 1.Neta_College#3.NetaEducationOrder 1.Neta_College#4.NetaEducationOrder 1.Neta_College#5.NetaEducationOrder

************************************************* Table S.7-S.8: HETEROGENEOUS TREATMENT EFFECTS BY TIME AND EDUCATION******************************************************************
** S.7 Time in Settlement 
* create variable identifying respondents who have lived in slum for over sample mean (22.5 years)
generate Veteran=1 if TimeinBasti>22.5
recode Veteran (.=0)

* results for Table S.7
regress Preferred_Profile CoEthnic_Jati_Neta##Veteran CoEthnic_Religion_Neta##Veteran CoEthnic_State_Neta##Veteran Muslim_Neta##Veteran Dalit_Neta##Veteran Neta_Copartisan##Veteran Neta_Incumbent##Veteran Neta_Opposition##Veteran Vertical_Connectivity##Veteran Outside_Slum##Veteran Neta_Secondary##Veteran Neta_College##Veteran Age, robust cluster (RespondentID)
test 1.CoEthnic_Jati_Neta#1.Veteran 1.CoEthnic_Religion_Neta#1.Veteran 1.CoEthnic_State_Neta#1.Veteran 1.Muslim_Neta#1.Veteran 1.Dalit_Neta#1.Veteran 1.Neta_Copartisan#1.Veteran 1.Neta_Incumbent#1.Veteran 1.Vertical_Connectivity#1.Veteran 1.Outside_Slum#1.Veteran 1.Neta_College#1.Veteran 1.Neta_Secondary#1.Veteran

** S.8 Respondent Education 
* create variable identifying respondents who have more education than sample mean (5 years)
generate Above_Primary=1 if Educ>5
recode Above_Primary (.=0)

*results for Table S.8
regress Preferred_Profile CoEthnic_Jati_Neta##Above_Primary CoEthnic_Religion_Neta##Above_Primary CoEthnic_State_Neta##Above_Primary Muslim_Neta##Above_Primary Dalit_Neta##Above_Primary Neta_Copartisan##Above_Primary Neta_Incumbent##Above_Primary Neta_Opposition##Above_Primary Vertical_Connectivity##Above_Primary Outside_Slum##Above_Primary Neta_College##Above_Primary Neta_Secondary##Above_Primary, robust cluster (RespondentID)
test 1.CoEthnic_Jati_Neta#1.Above_Primary 1.CoEthnic_Religion_Neta#1.Above_Primary 1.CoEthnic_State_Neta#1.Above_Primary 1.Muslim_Neta#1.Above_Primary 1.Dalit_Neta#1.Above_Primary 1.Neta_Copartisan#1.Above_Primary 1.Neta_Incumbent#1.Above_Primary 1.Neta_Opposition#1.Above_Primary 1.Vertical_Connectivity#1.Above_Primary 1.Outside_Slum#1.Above_Primary 1.Neta_College#1.Above_Primary 1.Neta_Secondary#1.Above_Primary

************************************************* TABLES S.9-S.15 SETTLEMENT LEVEL ANALYSIS******************************************************************
*Table S.9: Slum Fixed Effects
*Leader 
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta ib3.Neta_Caste_Rank Neta_Copartisan ib2.Neta_Party_Profile ib3.Neta_Work ib2.Neta_Education i.Settlement, robust cluster (Settlement)
*Neighbor
xi: regress Preferred_Neighbor_Profile CoEthnic_Jati_Neighbor Neighbor_CoEthnic_Religion CoEthnic_State_Neighbor ib3.Neighbor_Caste_Rank  Neighbor_Copartisan ib2.Neighbor_Party_Profile ib3.Neighbor_Work ib2.Neighbor_Education i.Settlement, robust cluster (Settlement), 

*Table S.10: Balance Statistics for Slums that have and have not held elections
ttest Original_Respondent, by(Held_Election), if ProfileID<2195
ttest Age, by(Held_Election), if ProfileID<2195
ttest Title, by(Held_Election), if ProfileID<2195
ttest Income, by(Held_Election), if ProfileID<2195
ttest Literate, by(Held_Election), if ProfileID<2195
ttest VoterID, by(Held_Election), if ProfileID<2195
ttest Muslim_Respondent, by(Held_Election), if ProfileID<2195
ttest Born_in_Basti, by(Held_Election), if ProfileID<2195
ttest Neta_Visited, by(Held_Election), if ProfileID<2195
ttest TimeinBasti, by(Held_Election), if ProfileID<2195

*Table S.11 Settlement Held Elections 
xi: regress Preferred_Profile CoEthnic_Jati_Neta##Held_Election CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta##Held_Election CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta##Held_Election Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta##Held_Election Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta##Held_Election Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan##Held_Election Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent##Held_Election Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition##Held_Election Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity##Held_Election Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum##Held_Election Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary##Held_Election Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College##Held_Election  i.Settlement, robust cluster (Settlement)

**Table S.12: SLUM AGE
*coding moderator identifying slums of above average age
generate Old_Slum=1 if settlement_age>=33.8
recode Old_Slum (.=0)

*testing moderating effect of slum age
xi: regress Preferred_Profile CoEthnic_Jati_Neta##Old_Slum CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta##Old_Slum CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta##Old_Slum Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta##Old_Slum Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta##Old_Slum Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan##Old_Slum Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent##Old_Slum Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition##Old_Slum Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity##Old_Slum Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum##Old_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary##Old_Slum Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College##Old_Slum i.Settlement, robust cluster (Settlement)

**Table S.13: SLUM DEVELOPMENT
*coding moderator identifying slums of above average development (indicator is % of households with water taps)
generate Developed_Slum=1 if household_tap>42.68 
recode Developed_Slum(.=0)

*testing moderating effect of slum development
xi: regress Preferred_Profile CoEthnic_Jati_Neta##Developed_Slum CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta##Developed_Slum CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta##Developed_Slum Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta##Developed_Slum Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta##Developed_Slum Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan##Developed_Slum Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent##Developed_Slum Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition##Developed_Slum Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity##Developed_Slum Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum##Developed_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary##Developed_Slum Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College##Developed_Slum i.Settlement, robust cluster (Settlement)

** Table S.14 SLUM DIVERSITY
*coding moderator identifying slums of above average diversity (indicator is caste-wise fractionalization index)
generate Diverse_Slum=1 if caste_diversity>.807 
recode Diverse_Slum(.=0)

xi: regress Preferred_Profile CoEthnic_Jati_Neta##Diverse_Slum CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta##Diverse_Slum CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta##Diverse_Slum Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta##Diverse_Slum Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta##Diverse_Slum Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan##Diverse_Slum Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent##Diverse_Slum Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition##Diverse_Slum Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity##Diverse_Slum Outside_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum##Diverse_Slum Neta_Secondary Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary##Diverse_Slum Neta_College i.Settlement, robust cluster (Settlement)
xi: regress Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_Secondary Neta_College##Diverse_Slum i.Settlement, robust cluster (Settlement)


************************************************* Table S.15: PRIVATE Vs. PUBLIC GOODS******************************************************************
*Column 1: Private Good
regress Preferred_Profile_VoterID CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary, robust cluster (RespondentID)
* Column 2: Public Good 
regress Preferred_Neta_PublicGood CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary, robust cluster (RespondentID)

*comparing coefficients in private and public goods models:
** Step 1: SUR of both regression equations
sureg (Preferred_Profile_VoterID CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary, robust cluster (RespondentID)) (Preferred_Neta_PublicGood CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta Muslim_Neta Dalit_Neta Neta_Copartisan Neta_Incumbent Neta_Opposition Vertical_Connectivity Outside_Slum Neta_College Neta_Secondary, robust cluster (RespondentID)) 

*Step 2: testing equality of coefficients 
test [Preferred_Profile_VoterID]CoEthnic_Jati_Neta=[Preferred_Neta_PublicGood]CoEthnic_Jati_Neta
test [Preferred_Profile_VoterID]CoEthnic_Religion_Neta=[Preferred_Neta_PublicGood]CoEthnic_Religion_Neta
test [Preferred_Profile_VoterID]CoEthnic_State_Neta=[Preferred_Neta_PublicGood]CoEthnic_State_Neta
test [Preferred_Profile_VoterID]Muslim_Neta =[Preferred_Neta_PublicGood]Muslim_Neta
test [Preferred_Profile_VoterID]Dalit_Neta =[Preferred_Neta_PublicGood]Dalit_Neta
test [Preferred_Profile_VoterID]Neta_Copartisan =[Preferred_Neta_PublicGood]Neta_Copartisan
test [Preferred_Profile_VoterID]Neta_Incumbent =[Preferred_Neta_PublicGood]Neta_Incumbent
test [Preferred_Profile_VoterID]Neta_Opposition =[Preferred_Neta_PublicGood]Neta_Opposition
test [Preferred_Profile_VoterID]Vertical_Connectivity =[Preferred_Neta_PublicGood]Vertical_Connectivity
test [Preferred_Profile_VoterID]Outside_Slum =[Preferred_Neta_PublicGood]Outside_Slum
test [Preferred_Profile_VoterID]Neta_Secondary =[Preferred_Neta_PublicGood]Neta_Secondary
test [Preferred_Profile_VoterID]Neta_College =[Preferred_Neta_PublicGood]Neta_College

