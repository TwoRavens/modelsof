*** Replication file 

** The Resistance as Role Model: Disillusionment and Protest Among American Adolescents After 2016
** David E. Campbell and Christina Wolbrecht 
** Political Behavior, full citation info TBD

** this file uses dataset Resistance_RoleModel.dta


**TABLE 2 AND FIGURE 1 ** 

** Table 2, column 1 (2016)**
ologit  revteen_system_3cat revparent_system  female_teen  teen_dem2 teen_ind2 teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

** 2016 results, Figure 1**
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

**Table 2, column2 (2017)**
ologit revteenW2_system_3cat revteen_system_3cat revparent_system  female_teen  teen_dem2 teen_ind2 teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

**2017 results, Figure 1**
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

***Table 2 column 3 (2071), with parental change variable (not shown in figure) **
ologit revteenW2_system_3cat revteen_system_3cat parent_revsystem_ch_12  female_teen  teen_dem2 teen_ind2 teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

** TABLE 3 AND FIGURE 2 **
** Table 3, column 1 (2016) **
ologit teen_vote3 parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

** 2016 results, Figure 2A **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 2 (2017)**
ologit teenW2_vote teen_vote3  parent_polidx_ch_12   female_teen  teen_dem2 teen_ind2  teen_femXdem2    parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

** 2017 results, Figure 2A **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 3 (2016)**
ologit teen_campaign parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

** 2016 results, Figure 2B **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 4 (2017)**
ologit teenW2_campaign teen_campaign parent_polidx_ch_12    female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen    [aweight=weight_teen]

**2017 results, Figure 2B **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 5 (2016)**
ologit teen_givepol parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

** 2016 results, Figure 2C**
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 6 (2017)**
ologit teenW2_givepol teen_givepol parent_polidx_ch_12    female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen      [aweight=weight_teen]

** 2017 results, Figure 2C **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 7 (2016)**
ologit teen_write parent_polidx female_teen teen_dem2 teen_ind2 teen_femXdem2  parented_max_4cat black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]     

** 2016 results, Figure 2D **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 8 (2017) **
ologit teenW2_write teen_write parent_polidx_ch_12    female_teen  teen_dem2 teen_ind2  teen_femXdem2   parented_max_4cat  black_teen hispanic_teen age_teen grades_teen  [aweight=weight_teen]     

** 2017 results, Figure 2D**
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 9 (2016) **
ologit teen_protest parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]

** 2016 results, Figure 2E**
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 10 (2017) **
ologit teenW2_protest teen_protest parent_polidx_ch_12    female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen     [aweight=weight_teen]

** 2017 results, Figure 2E**
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 3, column 11 (2017), with change in parental protest, not shown in paper **
ologit teenW2_protest teen_protest parent_polidx2_ch_12_noprotest parent_protest_ch_12 female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen     [aweight=weight_teen]


** model of disillusionment, controlling for parental change, not shown in paper **
ologit revteenW2_system_3cat revteen_system_3cat parent_revsystem_ch_12 female_teen  teen_dem2 teen_ind2 teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** TABLE 4 AND FIGURE 3 **

**Table 4, column 1 (2016) **
ologit  teen_protest parent_polidx   female_teen  teen_dem2 teen_ind2  revteen_system femXrevsys demXrevsys teen_femXdem2 demXfemXrevsys parented_max_4cat  black_teen hispanic_teen age_teen grades_teen  [aweight=weight_teen]

**2016 results, Figure 3 **
**Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 revteen_system=5 femXrevsys=0 demXrevsys=0 teen_femXdem2= 0 demXfemXrevsys=0)
**Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 revteen_system=5 femXrevsys=5 demXrevsys=0 teen_femXdem2= 0 demXfemXrevsys=0)
**Democratic males **
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 revteen_system=5 femXrevsys=0 demXrevsys=5 teen_femXdem2= 1 demXfemXrevsys=0)
**Democratic females **
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 revteen_system=5 femXrevsys=5 demXrevsys=5 teen_femXdem2= 1 demXfemXrevsys=5)


** Table 4, column 2 (2017) ** 
ologit  teenW2_protest teen_protest parent_polidx_ch_12   female_teen teen_dem2 teen_ind2 teen_revsystem_ch_12 demXrevsys_ch femXrevsys_ch teen_femXdem2 demXfemXrevsys_ch  parented_max_4cat  black_teen hispanic_teen age_teen grades_teen  [aweight=weight_teen] 

** 2017 results, Figure 3 **
**Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_revsystem_ch_12=-4 demXrevsys_ch=0 femXrevsys_ch= 0 teen_femXdem2=0 demXfemXrevsys_ch =0)
**Republican females**
margins, asobserved at(female_teen=1 teen_dem2=0 teen_revsystem_ch_12=-4 demXrevsys_ch=0 femXrevsys_ch= -4 teen_femXdem2=0 demXfemXrevsys_ch =0)
**Democratic males **
margins, asobserved at(female_teen=0 teen_dem2=1 teen_revsystem_ch_12=-4 demXrevsys_ch=-4 femXrevsys_ch= 0 teen_femXdem2=1 demXfemXrevsys_ch =0)
**Democratic females **
margins, asobserved at(female_teen=1 teen_dem2=1 teen_revsystem_ch_12=-4 demXrevsys_ch=-4 femXrevsys_ch= -4 teen_femXdem2=1 demXfemXrevsys_ch =-4)


** Table 4, column 3 (2017) **
**protest, either no change or less disillusionment**
ologit teenW2_protest teen_protest parent_polidx_ch_12    female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen] if teen_revsystem_ch_12 > -1


** No change, increase results, Figure 4 **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)

** Table 4, column 4 (2017)**
** protest, more disillusioned**
ologit teenW2_protest teen_protest parent_polidx_ch_12    female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen] if teen_revsystem_ch_12 < 0


** Decrease results, Figure 4 **
** Republican males**
margins, asobserved at(female_teen=0 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
** Republican females **
margins, asobserved at(female_teen=1 teen_dem2=0 teen_ind2=0 teen_femXdem2=0)
**Democratic males**
margins, asobserved at(female_teen=0 teen_dem2=1 teen_ind2=0 teen_femXdem2=0)
**Democratic females**
margins, asobserved at(female_teen=1 teen_dem2=1 teen_ind2=0 teen_femXdem2=1)




** parental protest, not shown in paper **
** 2016 model **
logit protest_parent   parented_max_4cat age_parent  parent_female black_parent hispanic_parent age_parent parent_pid3_21 parent_pid3_22 parent_femXdem2 [pweight=weight_parent]

** Republican males**
margins, asobserved at(parent_female=0 parent_pid3_21=0 parent_pid3_22=0 parent_femXdem2=0)
** Republican females **
margins, asobserved at(parent_female=1 parent_pid3_21=0 parent_pid3_22=0 parent_femXdem2=0)
**Democratic males**
margins, asobserved at(parent_female=0 parent_pid3_21=1 parent_pid3_22=0 parent_femXdem2=0)
**Democratic females**
margins, asobserved at(parent_female=1 parent_pid3_21=1 parent_pid3_22=0 parent_femXdem2=1)

** 2017 model

logit parentW2_protest protest_parent  age_parent parented_max_4cat   parent_female black_parent hispanic_parent age_parent parent_pid3_21 parent_pid3_22 parent_femXdem2 [pweight=weight_parent]
 
 ** Republican males**
margins, asobserved at(parent_female=0 parent_pid3_21=0 parent_pid3_22=0 parent_femXdem2=0)
** Republican females **
margins, asobserved at(parent_female=1 parent_pid3_21=0 parent_pid3_22=0 parent_femXdem2=0)
**Democratic males**
margins, asobserved at(parent_female=0 parent_pid3_21=1 parent_pid3_22=0 parent_femXdem2=0)
**Democratic females**
margins, asobserved at(parent_female=1 parent_pid3_21=1 parent_pid3_22=0 parent_femXdem2=1)

** THE FOLLOWING CODE IS FOR THE APPENDIX **
** Perceived Political Responsiveness, 2016, with wave 2 cases only **
** Matches Table 1 **
ologit  revteen_system_3cat revparent_system  female_teen  teen_dem2 teen_ind2 teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen] if teenW2_weight ~=.


** Anticipated Political Engagement, 2016, with wave 2 cases only **
** Matches Table 2 **
ologit teen_vote3 parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen] if teenW2_weight ~=.

ologit teen_campaign parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen] if teenW2_weight ~=.

ologit teen_givepol parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat  black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen] if teenW2_weight ~=.

ologit teen_write parent_polidx female_teen teen_dem2 teen_ind2 teen_femXdem2  parented_max_4cat black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen]   if teenW2_weight ~=.  

ologit teen_protest parent_polidx female_teen  teen_dem2 teen_ind2  teen_femXdem2 parented_max_4cat black_teen hispanic_teen age_teen grades_teen [aweight=weight_teen] if teenW2_weight ~=.


** Anticipated Participation in Demonstration, with Responsiveness Interaction, 2016, with wave 2 cases only **
** Matches Table 3 **
ologit  teen_protest parent_polidx   female_teen  teen_dem2 teen_ind2  revteen_system femXrevsys demXrevsys teen_femXdem2 demXfemXrevsys parented_max_4cat  black_teen hispanic_teen age_teen grades_teen  [aweight=weight_teen] if teenW2_weight ~=.

** Parent's Perceived Political Responsiveness **
ologit  revparentW2_system revparent_system  parent_female parent_pid3_21 parent_pid3_22 parent_femXdem2 parented_max_4cat  black_parent hispanic_parent age_parent  [aweight=weight_parent]

