*******************************************************************************
** Mendelberg, Karpowitz, and Goedert Replication Data  
** AJPS Article 
** "Does Descriptive Representation Facilitate Women's Distinctive Voice?"
*******************************************************************************

**Variable creation
**These variables are in the dataset, but the code below shows how they were created
gen maxfloor=0
replace maxfloor=1 if rankmax_1==1
gen noredist=0
replace noredist=1 if rankno_1==1
gen setfloor=0
replace setfloor=1 if rankfloor_1==1
gen setrange=0
replace setrange=1 if rankrange_1==1

**Create pre-deliberation group preference
sort group_id

by group_id: egen g_pre_max=total(rankmax_1==1)
by group_id: egen g_pre_floor=total(rankfloor_1==1)
by group_id: egen g_pre_range=total(rankrange_1==1)
by group_id: egen g_pre_no=total(rankno_1==1)

gen pre_princip_maj=.
replace pre_princip_maj=1 if g_pre_max>=3
replace pre_princip_maj=2 if g_pre_no>=3
replace pre_princip_maj=3 if g_pre_floor>=3
replace pre_princip_maj=4 if g_pre_range>=3

gen pre_princip_majmatch=0
replace pre_princip_majmatch=1 if rankmax_1==1&pre_princip_maj==1
replace pre_princip_majmatch=1 if rankno_1==1&pre_princip_maj==2
replace pre_princip_majmatch=1 if rankfloor_1==1&pre_princip_maj==3
replace pre_princip_majmatch=1 if rankrange_1==1&pre_princip_maj==4


gen enclave = (num_fem == 0 | num_fem == 5)
gen mixed_gender = !enclave

gen majlibs=0
replace majlibs=1 if numlibs>=3 & numlibs~=.

** Individual-level analysis
** Use dj_ajps_replication_individual.dta dataset

** Table 1
** Number of Groups and Individuals, No Analysis


** Table 2
// Women, mixed
// Liberal
// Model 1
regress CareFreq maj##c.num_fem liberal numlib princeton if female & mixed, cluster(group_id)

// Model 2
regress CareFreq maj##c.num_fem liberal i.maj##c.numlib princeton if female & mixed, cluster(group_id)

// Model 3
regress CareFreq maj##c.num_fem liberal i.maj##i.majlibs princeton if female & mixed, cluster(group_id)

// Model 4
regress CareFreq maj##c.num_fem rankfloor_1 pre_princip_majmatch princeton if female & mixed, cluster(group_id)

// Model 5
regress CareFreq maj##c.num_fem maxfloor noredist pre_princip_majmatch princeton if female & mixed, cluster(group_id)

**Supporting Information Tables
**Table A3
// Women Majority Rule
preserve

keep if female & ~unan

probit ChildrenMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress ChildrenFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib , cluster(group_id)

probit FamilyMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib  LogWordCount, cluster(group_id)
regress FamilyFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib , cluster(group_id)

probit PoorMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib  LogWordCount, cluster(group_id)
regress PoorFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib , cluster(group_id)

probit NeedyMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib  LogWordCount, cluster(group_id)
regress NeedyFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib , cluster(group_id)

probit RichMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib  LogWordCount, cluster(group_id)
regress RichFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib , cluster(group_id)

probit TaxMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib  LogWordCount, cluster(group_id)
regress TaxFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib , cluster(group_id)

probit SalaryMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib  LogWordCount, cluster(group_id)
regress SalaryFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib , cluster(group_id)

restore




// Women Unanimous Rule
preserve

keep if female & unan

probit ChildrenMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress ChildrenFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit FamilyMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress FamilyFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit PoorMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress PoorFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit NeedyMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress NeedyFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit RichMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress RichFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit TaxMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress TaxFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit SalaryMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress SalaryFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

restore







// Men Majority Rule
preserve

keep if ~female & ~unan

probit ChildrenMention fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib LogWordCount, cluster(group_id)
regress ChildrenFreq fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib, cluster(group_id)

probit FamilyMention fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib LogWordCount, cluster(group_id)
regress FamilyFreq fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib, cluster(group_id)

probit PoorMention fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib LogWordCount, cluster(group_id)
regress PoorFreq fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib, cluster(group_id)

probit NeedyMention fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib LogWordCount, cluster(group_id)
regress NeedyFreq fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib, cluster(group_id)

probit RichMention fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib LogWordCount, cluster(group_id)
regress RichFreq fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib, cluster(group_id)

probit TaxMention fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib LogWordCount, cluster(group_id)
regress TaxFreq fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib, cluster(group_id)

probit SalaryMention fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib LogWordCount, cluster(group_id)
regress SalaryFreq fem0 fem2 fem3 fem4 fem5 group504 princeton liberal numlib, cluster(group_id)

restore





// Men Unanimous Rule
preserve

keep if ~female & unan

probit ChildrenMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress ChildrenFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit FamilyMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress FamilyFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit PoorMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress PoorFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit NeedyMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress NeedyFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit RichMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress RichFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit TaxMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress TaxFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

probit SalaryMention fem0 fem2 fem3 fem4 fem5 princeton liberal numlib LogWordCount, cluster(group_id)
regress SalaryFreq fem0 fem2 fem3 fem4 fem5 princeton liberal numlib, cluster(group_id)

restore


**Checking statistical significance in Figures 3-5
gen ratio_femtomasc2=(CareFreq/4)/(FinancialFreq/2)

**Women Only
reg ratio_femtomasc2 i.maj##i.majfem liberal numlibs princeton if female==1&mixed==1, cluster(group_id)
margins maj#majfem, coeflegend post
test _b[1.maj#0bn.majfem]= _b[0bn.maj#1.majfem]
test _b[1.maj#0bn.majfem]=_b[1.maj#1.majfem]
test _b[1.maj#0bn.majfem]=_b[0bn.maj#1.majfem]
test _b[0bn.maj#0bn.majfem]=_b[1.maj#0bn.majfem]

**Men Only
reg ratio_femtomasc2 i.maj##i.majfem liberal numlibs princeton if female==0&mixed==1, cluster(group_id)
margins maj#majfem, coeflegend post
test _b[1.maj#0bn.majfem]= _b[0bn.maj#1.majfem]
test _b[1.maj#0bn.majfem]=_b[1.maj#1.majfem]
test _b[1.maj#0bn.majfem]=_b[0bn.maj#1.majfem]

**All Subjects
reg ratio_femtomasc2 i.maj##i.majfem liberal numlibs princeton if mixed==1, cluster(group_id)
margins maj#majfem, coeflegend post
test _b[1.maj#0bn.majfem]= _b[0bn.maj#1.majfem]
test _b[1.maj#0bn.majfem]=_b[1.maj#1.majfem]
test _b[1.maj#0bn.majfem]=_b[0bn.maj#1.majfem]


**Table A5
// Replication with TM data

regress CareFreqTM maj##c.num_fem liberal numlib princeton if female & mixed, cluster(group_id)
regress CareFreqTM maj##c.num_fem liberal maj##c.numlib princeton if female & mixed, cluster(group_id)

**Table A6
// Probability of First Mention
probit care_1st maj##c.num_fem CareFreq PercentTime liberal numlib princeton if female & mixed, cluster(group_id)



** Group-level analysis
** Use group-level dataset to replicate these tables
** dj_ajps_replication_groupdata.dta

**Table 3
// Group-level Data
gen ratio_fem_femtomasc=fem_CareFreq/fem_FinancialFreq


reg floor4 i.majfem##c.ratio_fem_femtomasc i.majlibs##c.ratio_fem_femtomasc princeton if mixed_gender==1&maj==1
reg floor4 i.majfem##c.ratio_fem_femtomasc i.majlibs##c.ratio_fem_femtomasc princeton if mixed_gender==1&maj==0


**Table A4
// Group-level Data
reg fem_CareFreq i.maj##c.num_fem numlibs princeton if mixed_gender==1
reg fem_CareFreq i.maj##c.num_fem i.maj##c.numlibs princeton if mixed_gender==1


**Table A7
// Group-level data
reg floor4 majfem majlibs princeton if maj==1&mixed==1
reg floor4 majfem majlibs princeton if maj==0&mixed==1








