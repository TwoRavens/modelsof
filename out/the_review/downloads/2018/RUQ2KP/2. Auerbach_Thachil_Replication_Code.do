****************************************************************
* Replication code for Main paper
* "How Clients Select Brokers"
* Adam Auerbach and Tariq Thachil
* May 2018
****************************************************************

** install special stata package 'coefplot' for generating Figures 1-3 
ssc install coefplot

*** MAIN TEXT TABLES AND FIGURES 

use "AuerbachThachilSlumResidents.dta"

*TABLE 1: 
summarize Age Gender Educ Literate HHIncome Born_in_Basti TimeinBasti, if ProfileID<2195

*FIGURE 1
regress Preferred_Profile CoEthnic_Jati_Neta NonCoEthnic_Jati_Neta CoEthnic_Religion_Neta NonCoEthnic_Religion_Neta CoEthnic_State_Neta NonCoEthnic_State_Neta ib3.Neta_Caste_Rank Neta_Copartisan Neta_NonCopartisan ib2.Neta_Party_Profile  ib3.Neta_Work  ib2.Neta_Education, robust cluster (RespondentID)
coefplot, drop(_cons) xline(0) omitted baselevels graphregion(color(white))  xtitle ("Effect on Pr(Being Selected as Council President") headings(CoEthnic_Jati_Neta="{bf:Broker Caste}" CoEthnic_Religion_Neta="{bf:Broker Religion}" CoEthnic_State_Neta="{bf:Broker State}" 1.Neta_Caste_Rank="{bf:Broker Ethnic Rank}" Neta_Copartisan="{bf:Broker Partisanship}" 0.Neta_Party_Profile="{bf:Broker Incumbent Status}" 1.Neta_Work="{bf:Broker Connectivity (Job)}" 0.Neta_Education="{bf:Broker Capability (Education)}") coeflabels (CoEthnic_Jati_Neta="Same as Resident" NonCoEthnic_Jati_Neta="Different from Resident" CoEthnic_Religion_Neta="Same as Resident" NonCoEthnic_Religion_Neta="Different from Resident" CoEthnic_State_Neta="Same as Resident" NonCoEthnic_State_Neta="Different from Resident" 1.Neta_Caste_Rank="Muslim Leader" 2.Neta_Caste_Rank="Lower Caste Leader" 3.Neta_Caste_Rank="Upper Caste Leader" Neta_Copartisan="Same as Resident" Neta_NonCopartisan="Different from Resident" 0.Neta_Party_Profile="Incumbent" 1.Neta_Party_Profile="Opposition" 2.Neta_Party_Profile="Independent" 1.Neta_Work="High (Municipal Job)" 2.Neta_Work="Medium(Outside Slum)" 3.Neta_Work="Low (Inside Slum)" 0.Neta_Education="High (College BA)" 1.Neta_Education="Medium (8th Grade)" 2.Neta_Education="Low (None)", labsize(vsmall))


* testing equality of coefficients between college education and other attributes
*college education v. caste
test 0.Neta_Education =  CoEthnic_Jati_Neta 
*college education v. religion
test 0.Neta_Education=CoEthnic_Religion_Neta
*college education v. state
test 0.Neta_Education=CoEthnic_State_Neta
*college education v. Muslim leader
test 0.Neta_Education = 1.Neta_Caste_Rank
*college education v. lower caste leader
test 0.Neta_Education=2.Neta_Caste_Rank
*college education v. co-partisan
test 0.Neta_Education =  Neta_Copartisan 
*college education v. incumbency 
test 0.Neta_Education =  0.Neta_Party_Profile
*college education v. opposition party 
test 0.Neta_Education =  1.Neta_Party_Profile
*college education v. 8th grade education 
test 0.Neta_Education =  1.Neta_Education
*college education vs. municipal job (high connectivity)
test 0.Neta_Education = 1.Neta_Work
* college education vs. outside job (medium connectivity)
test 0.Neta_Education = 2.Neta_Work

*FIGURE 2
* Candidate A: Coethnic, Connected, Capable Neta
mean Preferred_Profile if CoEthnic_Jati_Neta==1&Vertical_Connectivity==1&Neta_College==1
estimates store Candidate_A

* Candidate B: Capable, Connected, Not Coethnic
mean Preferred_Profile if CoEthnic_Jati_Neta==0&Vertical_Connectivity==1&Neta_College==1
estimates store Candidate_B

*Candidate C: CoEthnic, Not Capable, Not Connected
mean Preferred_Profile if CoEthnic_Jati_Neta==1&Inside_Slum==1&Neta_College==0&Neta_Secondary==0
estimates store Candidate_C

* Candidate D: None of the Above
mean Preferred_Profile if CoEthnic_Jati_Neta==0&Inside_Slum==1&Neta_College==0&Neta_Secondary==0
estimates store Candidate_D

*Generate figure
coefplot Candidate_A Candidate_B Candidate_C Candidate_D, nolabels xline(.5) graphregion(color(white))  xtitle ("Effect on Pr(Being Selected as Council President)")


*FIGURE 3 
*Top panel (Leader Results)
regress Preferred_Profile CoEthnic_Jati_Neta NonCoEthnic_Jati_Neta CoEthnic_Religion_Neta NonCoEthnic_Religion_Neta CoEthnic_State_Neta NonCoEthnic_State_Neta ib3.Neta_Caste_Rank Neta_Copartisan Neta_NonCopartisan ib2.Neta_Party_Profile  ib3.Neta_Work  ib2.Neta_Education, robust cluster (RespondentID)
coefplot, drop(_cons) xline(0) omitted baselevels graphregion(color(white))  xtitle ("Effect on Pr(Being Selected as Council President") headings(CoEthnic_Jati_Neta="{bf:Broker Caste}" CoEthnic_Religion_Neta="{bf:Broker Religion}" CoEthnic_State_Neta="{bf:Broker State}" 1.Neta_Caste_Rank="{bf:Broker Ethnic Rank}" Neta_Copartisan="{bf:Broker Partisanship}" 0.Neta_Party_Profile="{bf:Broker Incumbent Status}" 1.Neta_Work="{bf:Broker Connectivity (Job)}" 0.Neta_Education="{bf:Broker Capability (Education)}") coeflabels (CoEthnic_Jati_Neta="Same as Resident" NonCoEthnic_Jati_Neta="Different from Resident" CoEthnic_Religion_Neta="Same as Resident" NonCoEthnic_Religion_Neta="Different from Resident" CoEthnic_State_Neta="Same as Resident" NonCoEthnic_State_Neta="Different from Resident" 1.Neta_Caste_Rank="Muslim Leader" 2.Neta_Caste_Rank="Lower Caste Leader" 3.Neta_Caste_Rank="Upper Caste Leader" Neta_Copartisan="Same as Resident" Neta_NonCopartisan="Different from Resident" 0.Neta_Party_Profile="Incumbent" 1.Neta_Party_Profile="Opposition" 2.Neta_Party_Profile="Independent" 1.Neta_Work="High (Municipal Job)" 2.Neta_Work="Medium(Outside Slum)" 3.Neta_Work="Low (Inside Slum)" 0.Neta_Education="High (College BA)" 1.Neta_Education="Medium (8th Grade)" 2.Neta_Education="Low (None)", labsize(vsmall))

*Bottom panel (Neighbor Results)
regress Preferred_Neighbor_Profile CoEthnic_Jati_Neighbor NonCoEthnic_Jati_Neighbor Neighbor_CoEthnic_Religion  Neighbor_NonCoEthnic_Religion CoEthnic_State_Neighbor NonCoEthnic_State_Neighbor ib3.Neighbor_Caste_Rank  Neighbor_Copartisan Neighbor_NonCopartisan ib2.Neighbor_Party_Profile  ib3.Neighbor_Work ib2.Neighbor_Education, robust cluster (RespondentID), 
coefplot, drop(_cons) xline(0) omitted baselevels graphregion(color(white))  xtitle ("Effect on Pr(Being Selected as Slum Neighbor") headings(CoEthnic_Jati_Neighbor="{bf:Neighbor Caste}" Neighbor_CoEthnic_Religion="{bf:Neighbor Religion}" CoEthnic_State_Neighbor="{bf:Neighbor State}" 1.Neighbor_Caste_Rank="{bf:Neighbor Ethnic Rank}" Neighbor_Copartisan="{bf:Neighbor Partisanship}" 0.Neighbor_Party_Profile="{bf:Neighbor Incumbent Status}" 1.Neighbor_Work="{bf:Neighbor Connectivity (Job)}" 0.Neighbor_Education="{bf:Neighbor Capability (Education)}") coeflabels (CoEthnic_Jati_Neighbor="Same as Resident" NonCoEthnic_Jati_Neighbor="Different from Resident" Neighbor_CoEthnic_Religion="Same as Resident" Neighbor_NonCoEthnic_Religion="Different from Resident" CoEthnic_State_Neighbor="Same as Resident" NonCoEthnic_State_Neighbor="Different from Resident" 1.Neighbor_Caste_Rank="Muslim Neighbor" 2.Neighbor_Caste_Rank="Lower Caste Neighbor" 3.Neighbor_Caste_Rank="Upper Caste Neighbor" Neighbor_Copartisan="Same as Resident" Neighbor_NonCopartisan="Different from Resident" 0.Neighbor_Party_Profile="Incumbent" 1.Neighbor_Party_Profile="Opposition" 2.Neighbor_Party_Profile="Independent" 1.Neighbor_Work="High (Municipal Job)" 2.Neighbor_Work="Medium(Outside Slum)" 3.Neighbor_Work="Low (Inside Slum)" 0.Neighbor_Education="High (College BA)" 1.Neighbor_Education="Medium (8th Grade)" 2.Neighbor_Education="Low (None)", labsize(vsmall))

*testing equality of coefficients between leader and neighbor experiments
sureg (Preferred_Profile CoEthnic_Jati_Neta CoEthnic_Religion_Neta CoEthnic_State_Neta ib3.Neta_Caste_Rank Neta_Copartisan ib2.Neta_Party_Profile  ib3.Neta_Work  ib2.Neta_Education, robust cluster (RespondentID))( Preferred_Neighbor_Profile CoEthnic_Jati_Neighbor Neighbor_CoEthnic_Religion  CoEthnic_State_Neighbor ib3.Neighbor_Caste_Rank  Neighbor_Copartisan ib2.Neighbor_Party_Profile  ib3.Neighbor_Work ib2.Neighbor_Education, robust cluster (RespondentID)) 

*caste coethnics
test [Preferred_Profile]CoEthnic_Jati_Neta=[Preferred_Neighbor_Profile]CoEthnic_Jati_Neighbor
*religion coethnics
test [Preferred_Profile]CoEthnic_Religion_Neta=[Preferred_Neighbor_Profile]Neighbor_CoEthnic_Religion
*state/region coethnics
test [Preferred_Profile]CoEthnic_State_Neta=[Preferred_Neighbor_Profile]CoEthnic_State_Neighbor
*Muslim leader vs. Muslim Neighbor
test [Preferred_Profile]1.Neta_Caste_Rank =[Preferred_Neighbor_Profile]1.Neighbor_Caste_Rank
*Lower caste leader vs. lower caste neighbor
test [Preferred_Profile]2.Neta_Caste_Rank =[Preferred_Neighbor_Profile]2.Neighbor_Caste_Rank
*co-partisanship
test [Preferred_Profile]Neta_Copartisan =[Preferred_Neighbor_Profile]Neighbor_Copartisan
*incumbent party affiliation
test [Preferred_Profile]0.Neta_Party_Profile =[Preferred_Neighbor_Profile]0.Neighbor_Party_Profile
*opposition party affiliation 
test [Preferred_Profile]1.Neta_Party_Profile =[Preferred_Neighbor_Profile]1.Neighbor_Party_Profile
*municipal job (high connectivity)
test [Preferred_Profile]1.Neta_Work =[Preferred_Neighbor_Profile]1.Neighbor_Work
*outside slums job (medium connectivity)
test [Preferred_Profile]2.Neta_Work =[Preferred_Neighbor_Profile]2.Neighbor_Work
* college education
test [Preferred_Profile]0.Neta_Education =[Preferred_Neighbor_Profile]0.Neighbor_Education
*8th grade education
test [Preferred_Profile]1.Neta_Education =[Preferred_Neighbor_Profile]1.Neighbor_Education

*joint test of all 12 coefficients
test ([Preferred_Profile]CoEthnic_Jati_Neta=[Preferred_Neighbor_Profile]CoEthnic_Jati_Neighbor)([Preferred_Profile]CoEthnic_Religion_Neta=[Preferred_Neighbor_Profile]Neighbor_CoEthnic_Religion)([Preferred_Profile]CoEthnic_State_Neta=[Preferred_Neighbor_Profile]CoEthnic_State_Neighbor)([Preferred_Profile]1.Neta_Caste_Rank =[Preferred_Neighbor_Profile]1.Neighbor_Caste_Rank)([Preferred_Profile]2.Neta_Caste_Rank =[Preferred_Neighbor_Profile]2.Neighbor_Caste_Rank)([Preferred_Profile]Neta_Copartisan =[Preferred_Neighbor_Profile]Neighbor_Copartisan)([Preferred_Profile]0.Neta_Party_Profile =[Preferred_Neighbor_Profile]0.Neighbor_Party_Profile)([Preferred_Profile]1.Neta_Party_Profile =[Preferred_Neighbor_Profile]1.Neighbor_Party_Profile)([Preferred_Profile]1.Neta_Work =[Preferred_Neighbor_Profile]1.Neighbor_Work)([Preferred_Profile]2.Neta_Work =[Preferred_Neighbor_Profile]2.Neighbor_Work)([Preferred_Profile]0.Neta_Education =[Preferred_Neighbor_Profile]0.Neighbor_Education)([Preferred_Profile]1.Neta_Education =[Preferred_Neighbor_Profile]1.Neighbor_Education)



