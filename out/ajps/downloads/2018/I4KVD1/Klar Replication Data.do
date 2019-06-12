
** Commands for Analyses contained in Figure 1 **

mean feminist_describe_you if party_id==2

mean feminist_democratic_women if party_id==2

mean feminist_describe_republican if party_id==2

mean feminist_describe_you if party_id==1

mean feminist_democratic_women if party_id==1

mean feminist_describe_republican if party_id==1

** Commands for Analyses contained in Figures 2, 3, and 4**

mean trust if womancand==1 & gopcand==1 & gender==2 & pid>4 & womanissue==1

mean trust if womancand==0 & gopcand==1 & gender==2 & pid>4 & womanissue==1

mean trust if womancand==1 & gopcand==0 & gender==2 & pid>4 & womanissue==1

mean trust if womancand==0 & gopcand==0 & gender==2 & pid>4 & womanissue==1

regress trust i.womancand##i.gopcand if gender==2 & pid>4 & womanissue==1

** p=0.04, indicating a significant difference between the two slopes 

mean trust if womancand==1 & gopcand==1 & gender==2 & pid<4 & womanissue==1

mean trust if womancand==0 & gopcand==1 & gender==2 & pid<4 & womanissue==1

mean trust if womancand==1 & gopcand==0 & gender==2 & pid<4 & womanissue==1

mean trust if womancand==0 & gopcand==0 & gender==2 & pid<4 & womanissue==1

regress trust i.womancand##i.gopcand if gender==2 & pid<4 & womanissue==1

** p=0.02, indicating a significant difference between the two slopes 

mean trust if womancand==1 & gopcand==1 & gender==2 & pid>4 & womanissue==0

mean trust if womancand==0 & gopcand==1 & gender==2 & pid>4 & womanissue==0

mean trust if womancand==1 & gopcand==0 & gender==2 & pid>4 & womanissue==0

mean trust if womancand==0 & gopcand==0 & gender==2 & pid>4 & womanissue==0

regress trust i.womancand##i.gopcand if gender==2 & pid>4 & womanissue==0

** p=0.20, indicating no significant difference between the two slopes 

mean trust if womancand==1 & gopcand==1 & gender==2 & pid<4 & womanissue==0

mean trust if womancand==0 & gopcand==1 & gender==2 & pid<4 & womanissue==0

mean trust if womancand==1 & gopcand==0 & gender==2 & pid<4 & womanissue==0

mean trust if womancand==0 & gopcand==0 & gender==2 & pid<4 & womanissue==0

regress trust i.womancand##i.gopcand if gender==2 & pid<4 & womanissue==0

** p=0.41, indicating no significant difference between the two slopes 

** Commands for model depicted in Figure 5 **

regress trust i.womancand##i.diffparty##i.womanissue if gender==2

** Commands for model depicted in Figure 6 **

regress trust i.womancand##i.diffparty##i.womanissue if age>17 & gender==2



