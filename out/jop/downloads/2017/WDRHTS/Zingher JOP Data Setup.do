clear
set more off

/// Setting up the Analysis for 1972
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 1972 only
drop if VCF0004~=1972

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0  
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9


/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote

/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	  	 }
	}



/// Polychoric Factor Analysis for 1972

 polychoric Gov_Ins_Placement Gov_SL_Placement Federal_Gov_Wasteful Fair_jobs_blacks Rights_of_Accused Approve_Civil_Disob Abortion_Scale_Alt Womens_Role  Segregation_Scale Urban_Unrest_Scale Aid_Blacks [pweight= vcf0010x], pw

display r(sum_w)
matrix poly1972 = r(R)
matrix target = ( 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 )
factormat poly1972, n(1914) factors(2) blanks(.4) ml
rotate, target(target) 
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore Gov_Ins_Placement Gov_SL_Placement Federal_Gov_Wasteful Fair_jobs_blacks Rights_of_Accused Approve_Civil_Disob Abortion_Scale_Alt Womens_Role  Segregation_Scale Urban_Unrest_Scale Aid_Blacks

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Abortion_Scale_Alt*.11
gen F1_var3 = z_Womens_Role_Placement*-.032
gen F1_var5 = z_Gov_Ins_Placement*.1055
gen F1_var6 = z_Aid_Blacks_Placement*.2058
gen F1_var7 = z_Approve_Civil_D*-.033
gen F1_var8 = z_Urban_Unrest_Scale*.191
gen F1_var9 = z_Gov_SL_Placement*.191 
gen F1_var10 = z_Rights_of_Accused*.0574
gen F1_var12 = z_Segregation_Scale*.108
gen F1_var13 = z_Fair_jobs_blacks*.374
gen F1_var14 = z_Federal_Gov_Wasteful*.053


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max3=  max(F1_var3)
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max12= max(F1_var12)
egen F1_max13= max(F1_var13)
egen F1_max14= max(F1_var14)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var12_MI = 1 if F1_var12~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var14_MI = 1 if F1_var14~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var12 = F1_max12* F1_var12_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI



/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var14)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var14)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var14_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
drop if totalresp<8



/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension

gen F2_var1 = z_Abortion_Scale_Alt*-.394
gen F2_var3 = z_Womens_Role_Placement*.304
gen F2_var5 = z_Gov_Ins_Placement*-.119
gen F2_var6 = z_Aid_Blacks_Placement*.064
gen F2_var7 = z_Approve_Civil_D*-.105
gen F2_var8 = z_Urban_Unrest_Scale*.079
gen F2_var9 = z_Gov_SL_Placement*-.119
gen F2_var10 = z_Rights_of_Accused*.130 
gen F2_var12 = z_Segregation_Scale*.162
gen F2_var13 = z_Fair_jobs_blacks* -.111
gen F2_var14 = z_Federal_Gov_Wasteful*-.069


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max3=  max(F2_var3)
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max12=  max(F2_var12)
egen F2_max13=  max(F2_var13)
egen F2_max14=  max(F2_var14)

/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var12_MI = 1 if F2_var12~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var14_MI = 1 if F2_var14~=.




/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var12 = F2_max12* F2_var12_MI
gen F2_Ind_MAX_Var13 = F2_max12* F2_var13_MI
gen F2_Ind_MAX_Var14 = F2_max12* F2_var14_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var14)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var14)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)


egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2


replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2


rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7



save  "ANES_POST_FACTOR_1972.dta", replace


clear
/// Setting up the Analysis for 1976
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 1976 only
drop if VCF0004~=1976

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9


/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote

/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	  	 }
	}



/// Polychoric Factor Analysis for 1976

polychoric Fed_Gov_Too_Strong Abortion_Scale Womens_Role_Placement Gov_Ins_Placement Aid_Blacks_Placement  School_Busing_Scale Urban_Unrest_Scale Gov_SL_Placement Segregation_Scale  Federal_Gov_Wasteful Equal_Rgts_Amend Cut_Military_Spending [pweight= vcf0010x], pw

display r(sum_w)
matrix poly1976 = r(R)
matrix target = ( 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 )
factormat poly1976, n(2646) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore Fed_Gov_Too_Strong Abortion_Scale Womens_Role_Placement Gov_Ins_Placement Aid_Blacks_Placement  School_Busing_Scale Urban_Unrest_Scale Gov_SL_Placement Segregation_Scale  Federal_Gov_Wasteful Equal_Rgts_Amend Cut_Military_Spending

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Fed_Gov_Too_Strong*.152
gen F1_var2 = z_Abortion_Scale *.143
gen F1_var3 = z_Womens_Role_Placement*-.099
gen F1_var5 = z_Gov_Ins_Placement*.115
gen F1_var6 = z_Aid_Blacks_Placement*.295
gen F1_var7 = z_School_Busing_Scale*.202
gen F1_var8 = z_Urban_Unrest_Scale*.163
gen F1_var9 = z_Gov_SL_Placement*.220
gen F1_var10 = z_Segregation_Scale*.069 
gen F1_var11 = z_Federal_Gov_Wasteful*.126
gen F1_var12 = z_Equal_Rgts_Amend*-.093
gen F1_var14 = z_Cut_Military_Spending*.017


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max11= max(F1_var11)
egen F1_max12= max(F1_var12)
egen F1_max14= max(F1_var14)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var11_MI = 1 if F1_var11~=.
gen F1_var12_MI = 1 if F1_var12~=.
gen F1_var14_MI = 1 if F1_var14~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var11 = F1_max11* F1_var11_MI
gen F1_Ind_MAX_Var12 = F1_max12* F1_var12_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI



/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var14)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var14)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var14_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
drop if totalresp<9





/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension

gen F2_var1 = z_Fed_Gov_Too_Strong*-.085
gen F2_var2 = z_Abortion_Scale *-.24
gen F2_var3 = z_Womens_Role_Placement*.282
gen F2_var5 = z_Gov_Ins_Placement*-.022
gen F2_var6 = z_Aid_Blacks_Placement*.057
gen F2_var7 = z_School_Busing_Scale*.168
gen F2_var8 = z_Urban_Unrest_Scale*.145
gen F2_var9 = z_Gov_SL_Placement*-.085 
gen F2_var10 = z_Segregation_Scale*.189 
gen F2_var11 = z_Federal_Gov_Wasteful*-.073
gen F2_var12 = z_Equal_Rgts_Amend*.209
gen F2_var14 = z_Cut_Military_Spending*.114


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max11=  max(F2_var11)
egen F2_max12=  max(F2_var12)
egen F2_max14=  max(F2_var14)

/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var11_MI = 1 if F2_var11~=.
gen F2_var12_MI = 1 if F2_var12~=.
gen F2_var14_MI = 1 if F2_var14~=.




/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var11 = F2_max11* F2_var11_MI
gen F2_Ind_MAX_Var12 = F2_max12* F2_var12_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var14)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var14)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)

egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2



replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7

save  "ANES_POST_FACTOR_1976.dta", replace


clear
/// Setting up the Analysis for 1980
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 1980 only
drop if VCF0004~=1980


/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9

/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote



/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	  	 }
	}



/// Polychoric Factor Analysis for 1980

polychoric School_Prayer Bible_Scale_Alt Abortion_Scale  Womens_Role_Placement Equal_Rgts_Amend Aid_Blacks_Placement Fed_Gov_Too_Strong  School_Busing_Scale Urban_Unrest_Scale Gov_SL_Placement Federal_Gov_Wasteful [pweight= vcf0010x], pw
display r(sum_w)
matrix poly1980 = r(R)
matrix target = ( 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 1,0 \ 0,0 )
factormat poly1980, n(1159) factors(2) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore School_Prayer Bible_Scale_Alt Abortion_Scale  Womens_Role_Placement Equal_Rgts_Amend Aid_Blacks_Placement Fed_Gov_Too_Strong  School_Busing_Scale Urban_Unrest_Scale Gov_SL_Placement Federal_Gov_Wasteful

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_School_Prayer*.02
gen F1_var2 = z_Bible_Scale_Alt*.093
gen F1_var3 = z_Abortion_Scale*-.101
gen F1_var5 = z_Womens_Role_Placement*.02
gen F1_var6 = z_Equal_Rgts_Amend*.035
gen F1_var7 = z_Aid_Blacks_Placement*.288
gen F1_var8 = z_Fed_Gov_Too_Strong*.126
gen F1_var9 = z_School_Busing_Scale*.229
gen F1_var10 = z_Urban_Unrest_Scale*.186 
gen F1_var11 = z_Gov_SL_Placement*.289
gen F1_var12 = z_Federal_Gov_Wasteful*.124


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max11= max(F1_var11)
egen F1_max12= max(F1_var12)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var11_MI = 1 if F1_var11~=.
gen F1_var12_MI = 1 if F1_var12~=.


/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var11 = F1_max11* F1_var11_MI
gen F1_Ind_MAX_Var12 = F1_max12* F1_var12_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var12)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var12)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var12_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
drop if totalresp<9
drop if Pct_Max1<.8





/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension

gen F2_var1 = z_School_Prayer*-.328
gen F2_var2 = z_Bible_Scale_Alt*-.298
gen F2_var3 = z_Abortion_Scale*.275
gen F2_var5 = z_Womens_Role_Placement*.152
gen F2_var6 = z_Equal_Rgts_Amend*.108
gen F2_var7 = z_Aid_Blacks_Placement*.037
gen F2_var8 = z_Fed_Gov_Too_Strong*-.019
gen F2_var9 = z_School_Busing_Scale*.045
gen F2_var10 = z_Urban_Unrest_Scale*.0688
gen F2_var11 = z_Gov_SL_Placement*-.041
gen F2_var12 = z_Federal_Gov_Wasteful*-.0146


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max11=  max(F2_var11)
egen F2_max12=  max(F2_var12)

/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var11_MI = 1 if F2_var11~=.
gen F2_var12_MI = 1 if F2_var12~=.


/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var11 = F2_max11* F2_var11_MI
gen F2_Ind_MAX_Var12 = F2_max12* F2_var12_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var12)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var12)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)

egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2


replace Pres_Vote =. if Pres_Vote==0

replace Pres_Vote=. if Pres_Vote==3
replace Pres_Vote=0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7
rename VCF0218 Feeling_DemParty
rename VCF0224 Feeling_RepParty

save  "ANES_POST_FACTOR_1980.dta", replace


clear
/// Setting up the Analysis for 1984
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 1984 only
drop if VCF0004~=1984

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9
/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9


/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9096 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9095 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote


/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 1984

polychoric Envir_Spend_Scale Food_Stamps_Scale Gov_Spend_Placement Fed_Gov_Too_Strong Gov_Ins_Placement Gov_SL_Placement SS_Spending_Scale Urban_Unrest_Scale Aid_Blacks_Placement  School_Fund_Scale School_Busing_Scale Bible_Scale_Alt School_Prayer Womens_Role_Placement Abortion_Scale [pweight= vcf0010x], pw
display r(sum_w)
matrix poly1984 = r(R)
matrix target = ( 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0  )
factormat poly1984, n(1968) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2
zscore Envir_Spend_Scale Food_Stamps_Scale Gov_Spend_Placement Fed_Gov_Too_Strong Gov_Ins_Placement Gov_SL_Placement SS_Spending_Scale Urban_Unrest_Scale Aid_Blacks_Placement  School_Fund_Scale School_Busing_Scale Bible_Scale_Alt School_Prayer Womens_Role_Placement Abortion_Scale 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Envir_Spend_Scale*.059
gen F1_var2 = z_Food_Stamps_Scale*.239
gen F1_var3 = z_Gov_Spend_Placement*-.199
gen F1_var11 = z_Fed_Gov_Too_Strong*.062
gen F1_var13 = z_Gov_Ins_Placement*.111
gen F1_var14 = z_Gov_SL_Placement*.191
gen F1_var4 = z_SS_Spending_Scale*.1875
gen F1_var5 = z_Urban_Unrest_Scale*.0959
gen F1_var8 =  z_Aid_Blacks_Placement*.13
gen F1_var10 = z_School_Fund_Scale*.1388
gen F1_var15 = z_School_Busing_Scale*.0661
gen F1_var17 = z_School_Prayer*-.0007
gen F1_var18 = z_Bible_Scale_Alt*.07133
gen F1_var19 = z_Womens_Role_Placement*.03
gen F1_var20 = z_Abortion_Scale*-.0357


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max11= max(F1_var11)   
egen F1_max8=  max(F1_var8) 
egen F1_max10= max(F1_var10)
egen F1_max13= max(F1_var13)
egen F1_max14= max(F1_var14)
egen F1_max15= max(F1_var15)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var11_MI = 1 if F1_var11~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var14_MI = 1 if F1_var14~=.
gen F1_var15_MI = 1 if F1_var15~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var11 = F1_max11* F1_var11_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI
gen F1_Ind_MAX_Var15 = F1_max15* F1_var15_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var20)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var20)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var20_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
drop if totalresp<11
drop if Pct_Max1<.8






/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1 = z_Envir_Spend_Scale*-.062
gen F2_var2 = z_Food_Stamps_Scale*-.0059
gen F2_var3 = z_Gov_Spend_Placement*.003
gen F2_var11 = z_Fed_Gov_Too_Strong*.008
gen F2_var13 = z_Gov_Ins_Placement*-.01
gen F2_var14 = z_Gov_SL_Placement*.-.023
gen F2_var4 = z_SS_Spending_Scale*-.0847
gen F2_var5 = z_Urban_Unrest_Scale*.0743
gen F2_var8 =  z_Aid_Blacks_Placement*.051
gen F2_var10 = z_School_Fund_Scale*.012
gen F2_var15 = z_School_Busing_Scale*.036
gen F2_var18 = z_Bible_Scale_Alt*-.34
gen F2_var17 = z_School_Prayer*-.3613
gen F2_var19 = z_Womens_Role_Placement*.1457
gen F2_var20 = z_Abortion_Scale*-.223

/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max11=  max(F2_var11)   
egen F2_max8=  max(F2_var8) 
egen F2_max10=  max(F2_var10)
egen F2_max13=  max(F2_var13)
egen F2_max14=  max(F2_var14)
egen F2_max15=  max(F2_var15)
egen F2_max17=  max(F2_var17)
egen F2_max18=  max(F2_var18)
egen F2_max19=  max(F2_var19)
egen F2_max20=  max(F2_var20)
/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var11_MI = 1 if F2_var11~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var14_MI = 1 if F2_var14~=.
gen F2_var15_MI = 1 if F2_var15~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var11 = F2_max11* F2_var11_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var13 = F2_max13* F2_var13_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI
gen F2_Ind_MAX_Var15 = F2_max15* F2_var15_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max19* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max20* F2_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)
gen F2CO=0


egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2


replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2




rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7

save  "ANES_POST_FACTOR_1984.dta", replace


clear
/// Setting up the Analysis for 1988
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 1988 only
drop if VCF0004~=1988

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9

/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9096 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9095 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote




/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 1988

polychoric Envir_Spend_Scale Food_Stamps_Scale Gov_Spend_Placement Fed_Gov_Too_Strong Gov_Ins_Placement Gov_SL_Placement SS_Spending_Scale Fair_jobs_blacks Aid_Blacks_Placement  School_Fund_Scale   Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale [pweight= vcf0010x], pw
display r(sum_w)
matrix poly1988 = r(R)
matrix target = ( 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 )
factormat poly1988, n(1887) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore Envir_Spend_Scale Food_Stamps_Scale Gov_Spend_Placement Fed_Gov_Too_Strong Gov_Ins_Placement Gov_SL_Placement SS_Spending_Scale Fair_jobs_blacks Aid_Blacks_Placement  School_Fund_Scale   Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale 


/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Envir_Spend_Scale*.036
gen F1_var2 = z_Food_Stamps_Scale*.188
gen F1_var3 = z_Gov_Spend_Placement*-.174
gen F1_var11 = z_Fed_Gov_Too_Strong*.0267
gen F1_var13 = z_Gov_Ins_Placement*.1412
gen F1_var14 = z_Gov_SL_Placement*.236
gen F1_var4 = z_SS_Spending_Scale*.108
gen F1_var5 = z_Fair_jobs_blacks*.171
gen F1_var8 =  z_Aid_Blacks_Placement*.2084
gen F1_var10 = z_School_Fund_Scale*.10
gen F1_var15 = z_Gay_Discrimination*.0479
gen F1_var16 = z_Traditional_Values_Scale*.0121
gen F1_var17 = z_New_Lifestyles_Moraldecay*-.0073
gen F1_var18 = z_Bible_Scale*.071
gen F1_var19 = z_Womens_Role_Placement*-.0015
gen F1_var20 = z_Abortion_Scale*-.082


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max11= max(F1_var11)   
egen F1_max8=  max(F1_var8) 
egen F1_max10= max(F1_var10)
egen F1_max13= max(F1_var13)
egen F1_max14= max(F1_var14)
egen F1_max15= max(F1_var15)
egen F1_max16= max(F1_var16)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var11_MI = 1 if F1_var11~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var14_MI = 1 if F1_var14~=.
gen F1_var15_MI = 1 if F1_var15~=.
gen F1_var16_MI = 1 if F1_var16~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var11 = F1_max11* F1_var11_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI
gen F1_Ind_MAX_Var15 = F1_max15* F1_var15_MI
gen F1_Ind_MAX_Var16 = F1_max16* F1_var16_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var20)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var20)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var20_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
drop if totalresp<12
drop if Pct_Max1<.8




/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1 = z_Envir_Spend_Scale*.043
gen F2_var2 = z_Food_Stamps_Scale*-.02
gen F2_var3 = z_Gov_Spend_Placement*-.0037
gen F2_var11 = z_Fed_Gov_Too_Strong*.0239
gen F2_var13 = z_Gov_Ins_Placement*-.0293
gen F2_var14 = z_Gov_SL_Placement*-.0491
gen F2_var4 = z_SS_Spending_Scale*-.0396
gen F2_var5 = z_Fair_jobs_blacks*.0658
gen F2_var8 =  z_Aid_Blacks_Placement*.0096
gen F2_var10 = z_School_Fund_Scale*.019
gen F2_var15 = z_Gay_Discrimination*.175
gen F2_var16 = z_Traditional_Values_Scale*.1794
gen F2_var17 = z_New_Lifestyles_Moraldecay*-.262
gen F2_var18 = z_Bible_Scale*-.2255
gen F2_var19 = z_Womens_Role_Placement*.172
gen F2_var20 = z_Abortion_Scale*.263


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max11=  max(F2_var11)   
egen F2_max8=  max(F2_var8) 
egen F2_max10=  max(F2_var10)
egen F2_max13=  max(F2_var13)
egen F2_max14=  max(F2_var14)
egen F2_max15=  max(F2_var15)
egen F2_max16=  max(F2_var16)
egen F2_max17=  max(F2_var17)
egen F2_max18=  max(F2_var18)
egen F2_max19=  max(F2_var19)
egen F2_max20=  max(F2_var20)
/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var11_MI = 1 if F2_var11~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var14_MI = 1 if F2_var14~=.
gen F2_var15_MI = 1 if F2_var15~=.
gen F2_var16_MI = 1 if F2_var16~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var11 = F2_max11* F2_var11_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var13 = F2_max13* F2_var13_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI
gen F2_Ind_MAX_Var15 = F2_max15* F2_var15_MI
gen F2_Ind_MAX_Var16 = F2_max16* F2_var16_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max19* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max20* F2_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)

egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2


replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7



save  "ANES_POST_FACTOR_1988.dta", replace

clear
/// Setting up the Analysis for 1992
use "anes_cdfdta/anes_cdf.dta"
set more off

/// Condensing to 1992 only
drop if VCF0004~=1992
/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9

/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9

/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote


/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 1992

polychoric Gov_SL_Placement Gov_Ins_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  School_Integration_Scale School_Fund_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale [pweight= vcf0010x], pw

display r(sum_w)
matrix poly1992 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 )
factormat poly1992, n(926) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore Gov_SL_Placement Gov_Ins_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  School_Integration_Scale School_Fund_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale 


/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Gov_SL_Placement*.1497
gen F1_var2 = z_Gov_Ins_Placement*.09
gen F1_var3 = z_More_Less_Gov_Scale*.161
gen F1_var4 = z_SS_Spending_Scale*.104
gen F1_var5 = z_Fair_jobs_blacks*.152
gen F1_var6 =  z_Welfare_Scale*.134
gen F1_var7 =  z_Aid_to_poor_Scale*.203
gen F1_var8 =  z_Aid_Blacks_Placement*.11
gen F1_var9 =  z_School_Integration_Scale*.152
gen F1_var10 = z_School_Fund_Scale*.084
gen F1_var13 = z_Gay_Adoption*.032
gen F1_var14 = z_Gay_Military_Scale*.041
gen F1_var15 = z_Gay_Discrimination*.53
gen F1_var16 = z_Traditional_Values_Scale*.012
gen F1_var17 = z_New_Lifestyles_Moraldecay*-.012
gen F1_var18 = z_Bible_Scale*.098
gen F1_var19 = z_Womens_Role_Placement*-.0001
gen F1_var20 = z_Abortion_Scale*-.064


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max13= max(F1_var13)
egen F1_max14= max(F1_var14)
egen F1_max15= max(F1_var15)
egen F1_max16= max(F1_var16)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var14_MI = 1 if F1_var14~=.
gen F1_var15_MI = 1 if F1_var15~=.
gen F1_var16_MI = 1 if F1_var16~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI
gen F1_Ind_MAX_Var15 = F1_max15* F1_var15_MI
gen F1_Ind_MAX_Var16 = F1_max16* F1_var16_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var20)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var20)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var20_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)

drop if totalresp<14
drop if Pct_Max1<.8

/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1 = z_Gov_SL_Placement*-.0462
gen F2_var2 = z_Gov_Ins_Placement*-.016
gen F2_var3 = z_More_Less_Gov_Scale*-.041
gen F2_var4 = z_SS_Spending_Scale*-.06
gen F2_var5 = z_Fair_jobs_blacks*.003
gen F2_var6 =  z_Welfare_Scale*-.034
gen F2_var7 =  z_Aid_to_poor_Scale*-.076
gen F2_var8 =  z_Aid_Blacks_Placement*-.004
gen F2_var9 =  z_School_Integration_Scale*-.0166
gen F2_var10 = z_School_Fund_Scale*-.104
gen F2_var13 = z_Gay_Adoption*.32
gen F2_var14 = z_Gay_Military_Scale*.179
gen F2_var15 = z_Gay_Discrimination*.131
gen F2_var16 = z_Traditional_Values_Scale*.095
gen F2_var17 = z_New_Lifestyles_Moraldecay*-.126
gen F2_var18 = z_Bible_Scale*-.197
gen F2_var19 = z_Womens_Role_Placement*.0988
gen F2_var20 = z_Abortion_Scale*.171


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max13=  max(F2_var13)
egen F2_max14=  max(F2_var14)
egen F2_max15=  max(F2_var15)
egen F2_max16=  max(F2_var16)
egen F2_max17=  max(F2_var17)
egen F2_max18=  max(F2_var18)
egen F2_max19=  max(F2_var19)
egen F2_max20=  max(F2_var20)
/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var14_MI = 1 if F2_var14~=.
gen F2_var15_MI = 1 if F2_var15~=.
gen F2_var16_MI = 1 if F2_var16~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var13 = F2_max13* F2_var13_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI
gen F2_Ind_MAX_Var15 = F2_max15* F2_var15_MI
gen F2_Ind_MAX_Var16 = F2_max16* F2_var16_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max19* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max20* F2_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj

egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)

egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2



replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote=. if Pres_Vote==3
replace Pres_Vote=0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church

rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7

save  "ANES_POST_FACTOR_1992.dta", replace


clear
/// Setting up the Analysis for 1996
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 1996 only
drop if VCF0004~=1996

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9
/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote

/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 1996

polychoric Gov_Ins_Placement Gov_SL_Placement Federal_Gov_Wasteful SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Foreign_Aid_Scale Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale [pweight= vcf0010x], pw
display r(sum_w)
matrix poly1996 = r(R)
matrix target = ( 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 )
factormat poly1996, n(1616) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore Gov_Ins_Placement Gov_SL_Placement Federal_Gov_Wasteful SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Foreign_Aid_Scale Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale 


/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Gov_Ins_Placement*.084
gen F1_var2 = z_Gov_SL_Placement*.168
gen F1_var3 = z_Federal_Gov_Wasteful*.0354
gen F1_var4 = z_SS_Spending_Scale*.105
gen F1_var5 = z_Fair_jobs_blacks*.196
gen F1_var6 =  z_Welfare_Scale*.161
gen F1_var7 =  z_Aid_to_poor_Scale*.247
gen F1_var8 =  z_Aid_Blacks_Placement*.135
gen F1_var9 =  z_Immigrants_Scale*.0187
gen F1_var10 = z_School_Fund_Scale*.088
gen F1_var12 = z_Foreign_Aid_Scale*.0447
gen F1_var14 = z_Gay_Military_Scale*.044
gen F1_var15 = z_Gay_Discrimination*.099
gen F1_var16 = z_Traditional_Values_Scale*.008
gen F1_var17 = z_New_Lifestyles_Moraldecay*-.02
gen F1_var18 = z_Bible_Scale*.052
gen F1_var19 = z_Womens_Role_Placement*.0257
gen F1_var20 = z_Abortion_Scale*-.027


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max12= max(F1_var12)
egen F1_max14= max(F1_var14)
egen F1_max15= max(F1_var15)
egen F1_max16= max(F1_var16)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var12_MI = 1 if F1_var12~=.
gen F1_var14_MI = 1 if F1_var14~=.
gen F1_var15_MI = 1 if F1_var15~=.
gen F1_var16_MI = 1 if F1_var16~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var12 = F1_max12* F1_var12_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI
gen F1_Ind_MAX_Var15 = F1_max15* F1_var15_MI
gen F1_Ind_MAX_Var16 = F1_max16* F1_var16_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var20)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var20)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var20_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
drop if totalresp<14
drop if Pct_Max1<.8






/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1 = z_Gov_Ins_Placement*-.005
gen F2_var2 = z_Gov_SL_Placement*-.046
gen F2_var3 = z_Federal_Gov_Wasteful*-.003
gen F2_var4 = z_SS_Spending_Scale*-.111
gen F2_var5 = z_Fair_jobs_blacks*.0797
gen F2_var6 =  z_Welfare_Scale*-.071
gen F2_var7 =  z_Aid_to_poor_Scale*-.145
gen F2_var8 =  z_Aid_Blacks_Placement*-.006
gen F2_var9 =  z_Immigrants_Scale*.0277
gen F2_var10 = z_School_Fund_Scale*-.018
gen F2_var12 = z_Foreign_Aid_Scale*-.025
gen F2_var14 = z_Gay_Military_Scale*.147
gen F2_var15 = z_Gay_Discrimination*.163
gen F2_var16 = z_Traditional_Values_Scale*.189
gen F2_var17 = z_New_Lifestyles_Moraldecay*-.142
gen F2_var18 = z_Bible_Scale*-.265
gen F2_var19 = z_Womens_Role_Placement*.126
gen F2_var20 = z_Abortion_Scale*.228


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max12=  max(F2_var12)
egen F2_max14=  max(F2_var14)
egen F2_max15=  max(F2_var15)
egen F2_max16=  max(F2_var16)
egen F2_max17=  max(F2_var17)
egen F2_max18=  max(F2_var18)
egen F2_max19=  max(F2_var19)
egen F2_max20=  max(F2_var20)
/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var12_MI = 1 if F2_var12~=.
gen F2_var14_MI = 1 if F2_var14~=.
gen F2_var15_MI = 1 if F2_var15~=.
gen F2_var16_MI = 1 if F2_var16~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var12 = F2_max12* F2_var12_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI
gen F2_Ind_MAX_Var15 = F2_max15* F2_var15_MI
gen F2_Ind_MAX_Var16 = F2_max16* F2_var16_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max18* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max18* F2_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)


egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2


replace Pres_Vote =. if Pres_Vote==0
label drop VCF0704_

replace Pres_Vote=. if Pres_Vote==3
replace Pres_Vote=0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0130 weekly_church
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7

save  "ANES_POST_FACTOR_1996.dta", replace


clear
/// Setting up the Analysis for 2000
use "anes_cdfdta/anes_cdf.dta"
set more off

/// Condensing to 2000 only
drop if VCF0004~=2000

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9
/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9
/// recode SS_Spending 
replace VCF9049=. if VCF9049==4 | VCF9049==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote


/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 2000

polychoric Gov_SL_Placement Gov_Ins_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Foreign_Aid_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale [pweight= vcf0010x], pw
display r(sum_w)
matrix poly2000 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly2000, n(934) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore Gov_SL_Placement Gov_Ins_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Foreign_Aid_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Gov_SL_Placement*.129
gen F1_var2 = z_Gov_Ins_Placement*.071
gen F1_var3 = z_More_Less_Gov_Scale*.16
gen F1_var4 = z_SS_Spending_Scale*.107
gen F1_var5 = z_Fair_jobs_blacks*.164
gen F1_var6 =  z_Welfare_Scale*.164
gen F1_var7 =  z_Aid_to_poor_Scale*.268
gen F1_var8 =  z_Aid_Blacks_Placement*.125
gen F1_var9 =  z_Immigrants_Scale*.039
gen F1_var10 = z_School_Fund_Scale*.11
gen F1_var12 = z_Foreign_Aid_Scale*.063
gen F1_var13 = z_Gay_Adoption*-.0163
gen F1_var14 = z_Gay_Military_Scale*.007
gen F1_var15 = z_Gay_Discrimination*.067
gen F1_var16 = z_Traditional_Values_Scale*.0119
gen F1_var17 = z_New_Lifestyles_Moraldecay*-.003
gen F1_var18 = z_Bible_Scale*.07
gen F1_var19 = z_Womens_Role_Placement*-.00005
gen F1_var20 = z_Abortion_Scale*-.043


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max12= max(F1_var12)
egen F1_max13= max(F1_var13)
egen F1_max14= max(F1_var14)
egen F1_max15= max(F1_var15)
egen F1_max16= max(F1_var16)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var12_MI = 1 if F1_var12~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var14_MI = 1 if F1_var14~=.
gen F1_var15_MI = 1 if F1_var15~=.
gen F1_var16_MI = 1 if F1_var16~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var12 = F1_max12* F1_var12_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI
gen F1_Ind_MAX_Var15 = F1_max15* F1_var15_MI
gen F1_Ind_MAX_Var16 = F1_max16* F1_var16_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var20)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var20)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var20_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
gen F1CO=0
drop if totalresp<14
drop if Pct_Max1<.8






/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1 = z_Gov_SL_Placement*-.029
gen F2_var2 = z_Gov_Ins_Placement*-.005
gen F2_var3 = z_More_Less_Gov_Scale*.-.0185
gen F2_var4 = z_SS_Spending_Scale*-.0463
gen F2_var5 = z_Fair_jobs_blacks*-.0102
gen F2_var6 =  z_Welfare_Scale*-.0127
gen F2_var7 =  z_Aid_to_poor_Scale*-.0736
gen F2_var8 =  z_Aid_Blacks_Placement*-.0183
gen F2_var9 =  z_Immigrants_Scale*.0193
gen F2_var10 = z_School_Fund_Scale*.002
gen F2_var12 = z_Foreign_Aid_Scale*-.001
gen F2_var13 = z_Gay_Adoption*.409
gen F2_var14 = z_Gay_Military_Scale*.183
gen F2_var15 = z_Gay_Discrimination*.082
gen F2_var16 = z_Traditional_Values_Scale*.111
gen F2_var17 = z_New_Lifestyles_Moraldecay*-.103
gen F2_var18 = z_Bible_Scale*-.154
gen F2_var19 = z_Womens_Role_Placement*.09
gen F2_var20 = z_Abortion_Scale*.16


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max12=  max(F2_var12)
egen F2_max13=  max(F2_var13)
egen F2_max14=  max(F2_var14)
egen F2_max15=  max(F2_var15)
egen F2_max16=  max(F2_var16)
egen F2_max17=  max(F2_var17)
egen F2_max18=  max(F2_var18)
egen F2_max19=  max(F2_var19)
egen F2_max20=  max(F2_var20)
/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var12_MI = 1 if F2_var12~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var14_MI = 1 if F2_var14~=.
gen F2_var15_MI = 1 if F2_var15~=.
gen F2_var16_MI = 1 if F2_var16~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var12 = F2_max12* F2_var12_MI
gen F2_Ind_MAX_Var13 = F2_max13* F2_var13_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI
gen F2_Ind_MAX_Var15 = F2_max15* F2_var15_MI
gen F2_Ind_MAX_Var16 = F2_max16* F2_var16_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max19* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max20* F2_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)


egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2



replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7

save  "ANES_POST_FACTOR_2000.dta", replace




clear
/// Setting up the Analysis for 2004
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 2004 only
drop if VCF0004~=2004

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9
/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9
/// recode SS_Spending 
replace VCF9049=. if VCF9049==4 | VCF9049==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote

/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 2004

polychoric Gov_Ins_Placement Gov_SL_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Foreign_Aid_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale [pweight= vcf0010x], pw
display r(sum_w)
matrix poly2004 = r(R)
matrix target = ( 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 )
factormat poly2004, n(1002) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2

zscore Gov_Ins_Placement Gov_SL_Placement  More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Foreign_Aid_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Gov_Ins_Placement*.0785
gen F1_var2 = z_Gov_SL_Placement*.145
gen F1_var3 = z_More_Less_Gov_Scale*.137
gen F1_var4 = z_SS_Spending_Scale*.091
gen F1_var5 = z_Fair_jobs_blacks*.187
gen F1_var6 =  z_Welfare_Scale*.142
gen F1_var7 =  z_Aid_to_poor_Scale*.206
gen F1_var8 =  z_Aid_Blacks_Placement*.137
gen F1_var9 =  z_Immigrants_Scale*.012
gen F1_var10 = z_School_Fund_Scale*.125
gen F1_var12 = z_Foreign_Aid_Scale*.054
gen F1_var13 = z_Gay_Adoption*.034
gen F1_var14 = z_Gay_Military_Scale*.018
gen F1_var15 = z_Gay_Discrimination*.033
gen F1_var16 = z_Traditional_Values_Scale*.068
gen F1_var17 = z_New_Lifestyles_Moraldecay*-.042
gen F1_var18 = z_Bible_Scale*.04
gen F1_var19 = z_Womens_Role_Placement*.0172
gen F1_var20 = z_Abortion_Scale*-.0186


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max12= max(F1_var12)
egen F1_max13= max(F1_var13)
egen F1_max14= max(F1_var14)
egen F1_max15= max(F1_var15)
egen F1_max16= max(F1_var16)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var12_MI = 1 if F1_var12~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var14_MI = 1 if F1_var14~=.
gen F1_var15_MI = 1 if F1_var15~=.
gen F1_var16_MI = 1 if F1_var16~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var12 = F1_max12* F1_var12_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI
gen F1_Ind_MAX_Var15 = F1_max15* F1_var15_MI
gen F1_Ind_MAX_Var16 = F1_max16* F1_var16_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var20)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var20)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var20_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
gen F1CO=0
drop if totalresp<14
drop if Pct_Max1<.8




/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1 = z_Gov_Ins_Placement*-.007
gen F2_var2 = z_Gov_SL_Placement*-.039
gen F2_var3 = z_More_Less_Gov_Scale*-.049
gen F2_var4 = z_SS_Spending_Scale*-.063
gen F2_var5 = z_Fair_jobs_blacks*-.027
gen F2_var6 = z_Welfare_Scale*-.053
gen F2_var7 =  z_Aid_to_poor_Scale*-.115
gen F2_var8 =  z_Aid_Blacks_Placement*-.023
gen F2_var9 =  z_Immigrants_Scale*.04
gen F2_var10 = z_School_Fund_Scale*-.015
gen F2_var12 = z_Foreign_Aid_Scale*-.011
gen F2_var13 = z_Gay_Adoption*.343
gen F2_var14 = z_Gay_Military_Scale*.097
gen F2_var15 = z_Gay_Discrimination*.137
gen F2_var16 = z_Traditional_Values_Scale*.143
gen F2_var17 = z_New_Lifestyles_Moraldecay*-.121
gen F2_var18 = z_Bible_Scale*-.176
gen F2_var19 = z_Womens_Role_Placement*.074
gen F2_var20 = z_Abortion_Scale*.151


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max12=  max(F2_var12)
egen F2_max13=  max(F2_var13)
egen F2_max14=  max(F2_var14)
egen F2_max15=  max(F2_var15)
egen F2_max16=  max(F2_var16)
egen F2_max17=  max(F2_var17)
egen F2_max18=  max(F2_var18)
egen F2_max19=  max(F2_var19)
egen F2_max20=  max(F2_var20)
/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var12_MI = 1 if F2_var12~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var14_MI = 1 if F2_var14~=.
gen F2_var15_MI = 1 if F2_var15~=.
gen F2_var16_MI = 1 if F2_var16~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var12 = F2_max12* F2_var12_MI
gen F2_Ind_MAX_Var13 = F2_max13* F2_var13_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI
gen F2_Ind_MAX_Var15 = F2_max15* F2_var15_MI
gen F2_Ind_MAX_Var16 = F2_max16* F2_var16_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max19* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max20* F2_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)
gen F2CO=0

egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2


replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7

save  "ANES_POST_FACTOR_2004.dta", replace




clear
/// Setting up the Analysis for 2008
use "anes_cdfdta/anes_cdf.dta"


/// Condensing to 2000 only
drop if VCF0004~=2008

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8 | VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8 | VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8 | VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8 | VCF9049==9
replace VCF9049= 4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8 | VCF0890==9
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7 | VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8 | VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7 | VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0 | VCF0850==9 | VCF0850==7
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a==3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8| VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9 | VCF9037==0
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |  VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 | VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0836==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9
replace VCF0301=. if VCF0301==0 | VCF0301==9
/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9
/// recode SS_Spending 
replace VCF9049=. if VCF9049==4 | VCF9049==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wasteful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0833 Equal_Rgts_Amend
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote

/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 2008

polychoric Gov_SL_Placement Gov_Ins_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Envir_Spend_Scale Foreign_Aid_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale [pweight= vcf0010x], pw 
display r(sum_w)
matrix poly2008 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \0,0)
factormat poly2008, n(1022) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2
zscore Gov_SL_Placement Gov_Ins_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale Aid_to_poor_Scale Aid_Blacks_Placement  Immigrants_Scale School_Fund_Scale Envir_Spend_Scale Foreign_Aid_Scale Gay_Adoption Gay_Military_Scale Gay_Discrimination Traditional_Values_Scale New_Lifestyles_Moraldecay Bible_Scale Womens_Role_Placement Abortion_Scale 


/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Gov_SL_Placement*.179
gen F1_var2 = z_Gov_Ins_Placement*.081
gen F1_var3 = z_More_Less_Gov_Scale*.124
gen F1_var4 = z_SS_Spending_Scale*.08
gen F1_var5 = z_Fair_jobs_blacks*.136
gen F1_var6 =  z_Welfare_Scale*.153
gen F1_var7 =  z_Aid_to_poor_Scale*.23
gen F1_var8 =  z_Aid_Blacks_Placement*.126
gen F1_var9 =  z_Immigrants_Scale*.008
gen F1_var10 = z_School_Fund_Scale*.094
gen F1_var11 = z_Envir_Spend_Scale*.100
gen F1_var12 = z_Foreign_Aid_Scale*.077
gen F1_var13 = z_Gay_Adoption*-.018
gen F1_var14 = z_Gay_Military_Scale*.004
gen F1_var15 = z_Gay_Discrimination*.0003
gen F1_var16 = z_Traditional_Values_Scale*.008
gen F1_var17 = z_New_Lifestyles_Moraldecay*-.002
gen F1_var18 = z_Bible_Scale*.048
gen F1_var19 = z_Womens_Role_Placement*-.001
gen F1_var20 = z_Abortion_Scale*-.018


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max11= max(F1_var11)
egen F1_max12= max(F1_var12)
egen F1_max13= max(F1_var13)
egen F1_max14= max(F1_var14)
egen F1_max15= max(F1_var15)
egen F1_max16= max(F1_var16)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)

/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var11_MI = 1 if F1_var11~=.
gen F1_var12_MI = 1 if F1_var12~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var14_MI = 1 if F1_var14~=.
gen F1_var15_MI = 1 if F1_var15~=.
gen F1_var16_MI = 1 if F1_var16~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var11 = F1_max11* F1_var11_MI
gen F1_Ind_MAX_Var12 = F1_max12* F1_var12_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var14 = F1_max14* F1_var14_MI
gen F1_Ind_MAX_Var15 = F1_max15* F1_var15_MI
gen F1_Ind_MAX_Var16 = F1_max16* F1_var16_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI

/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var20)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max

/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var20)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var20_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)
drop if totalresp<15
drop if Pct_Max1<.8


/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1 = z_Gov_SL_Placement*-.056
gen F2_var2 = z_Gov_Ins_Placement*.007
gen F2_var3 = z_More_Less_Gov_Scale*-.035
gen F2_var4 = z_SS_Spending_Scale*-.04
gen F2_var5 = z_Fair_jobs_blacks*.0005
gen F2_var6 =  z_Welfare_Scale*-.038
gen F2_var7 =  z_Aid_to_poor_Scale*-.062
gen F2_var8 =  z_Aid_Blacks_Placement*.011
gen F2_var9 =  z_Immigrants_Scale*.038
gen F2_var10 = z_School_Fund_Scale*.011
gen F2_var11 = z_Envir_Spend_Scale*.0012
gen F2_var12 = z_Foreign_Aid_Scale*-.023
gen F2_var13 = z_Gay_Adoption*.363
gen F2_var14 = z_Gay_Military_Scale*.126
gen F2_var15 = z_Gay_Discrimination*.139
gen F2_var16 = z_Traditional_Values_Scale*.141
gen F2_var17 = z_New_Lifestyles_Moraldecay*-.128
gen F2_var18 = z_Bible_Scale*-.172
gen F2_var19 = z_Womens_Role_Placement*.076
gen F2_var20 = z_Abortion_Scale*.161


/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10=  max(F2_var10)
egen F2_max11=  max(F2_var11)
egen F2_max12=  max(F2_var12)
egen F2_max13=  max(F2_var13)
egen F2_max14=  max(F2_var14)
egen F2_max15=  max(F2_var15)
egen F2_max16=  max(F2_var16)
egen F2_max17=  max(F2_var17)
egen F2_max18=  max(F2_var18)
egen F2_max19=  max(F2_var19)
egen F2_max20=  max(F2_var20)
/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var11_MI = 1 if F2_var11~=.
gen F2_var12_MI = 1 if F2_var12~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var14_MI = 1 if F2_var14~=.
gen F2_var15_MI = 1 if F2_var15~=.
gen F2_var16_MI = 1 if F2_var16~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var11 = F2_max11* F2_var11_MI
gen F2_Ind_MAX_Var12 = F2_max12* F2_var12_MI
gen F2_Ind_MAX_Var13 = F2_max13* F2_var13_MI
gen F2_Ind_MAX_Var14 = F2_max14* F2_var14_MI
gen F2_Ind_MAX_Var15 = F2_max15* F2_var15_MI
gen F2_Ind_MAX_Var16 = F2_max16* F2_var16_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max19* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max20* F2_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)


egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2
replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0105 race_2cat
rename VCF0106 race_3cat
rename VCF0106a race_6cat
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7

save  "ANES_POST_FACTOR_2008.dta", replace


clear
set more off
use "anes_cdfdta/anes_cdf.dta"



/// Condensing to 2012 only
drop if VCF0004~=2012
drop if VCF0014==4

/// Recodes - Gay Adoption
replace VCF0878 = . if VCF0878==8|VCF0878==9
replace VCF0878 = 2 if VCF0878==5
/// Recodes - Aff. Action
replace VCF0867a=. if VCF0867a ==8|VCF0867a==9
/// Recodes - Welfare
replace VCF0894=. if  VCF0894==8|VCF0894==9
/// Recodes - Aid to Poor
replace  VCF0886=. if  VCF0886==8|VCF0886==9
/// Recodes - SS. Spending
replace VCF9049=. if VCF9049==8
replace VCF9049=4 if VCF9049==7
/// Recodes - Public Schools
replace VCF0890=. if VCF0890==8
/// Recodes - Abortion
replace VCF0838=. if VCF0838==9|VCF0838==0
/// Reversing Scale
replace VCF0838=(5-VCF0838) 
/// Recodes - Gays in Military
replace VCF0877a=3 if VCF0877a==4
replace VCF0877a=4 if VCF0877a==5
replace VCF0877a=. if VCF0877a==7|VCF0877a==9
/// Recodes - Environment Spending
replace VCF9047=. if VCF9047==8|VCF9047==9
replace VCF9047=4 if VCF9047==7
/// Recodes Gay Discrim
replace VCF0876a=. if VCF0876a==7|VCF0876a==9
replace VCF0876a=3 if VCF0876a==4
replace VCF0876a=4 if VCF0876a==5
/// Recodes - Federal Crime Spending
replace  VCF0888=. if  VCF0888==8
/// Recodes - Auth. of Bible
replace VCF0850=. if VCF0850==0|VCF0850==9
replace VCF0850=4-VCF0850
/// Recodes - Number of Immigrants
replace VCF0879a=. if VCF0879a== 8|VCF0879a== 9
replace VCF0879a=2 if VCF0879a== 3
replace VCF0879a=3 if VCF0879a==5
/// Recodes - Foreign Aid
replace VCF0892=. if VCF0892==8|VCF0892==9
/// Recodes - Gov or Free Market
replace VCF9132=. if VCF9132==8|VCF9132==9
/// Recodes - more or less gov
replace VCF9131=. if VCF9131==8|VCF9131==9
replace VCF9131=(3-VCF9131)
/// Recodes - Gay Discrimination
replace VCF0876=. if VCF0876==8|VCF0876==9
replace VCF0876=2 if VCF0876==5
/// Gov too involved
replace VCF9133 =. if VCF9133==8|VCF9133==9
replace VCF9133 =3-VCF9133
/// Traditional Values
replace VCF0853=. if VCF0853==8 | VCF0853==9
replace VCF0853= (6-VCF0853)
/// Aid to Blacks
replace VCF9050=. if VCF9050==8|VCF9050==9
replace VCF9050=4 if VCF9050==7
/// Food Stamps
replace VCF9046=. if  VCF9046==8 |  VCF9046==9
replace  VCF9046=4 if  VCF9046==7
/// New Lifestyles 
replace VCF0851=. if VCF0851==8 | VCF0851==9
/// Adjust Morals
replace VCF0852=. if VCF0852==8 | VCF0852==9
/// Self Reliance
replace VCF9134=. if VCF9134==8 | VCF9134==9
/// Child Care
replace VCF0887=. if VCF0887==8|VCF0887==9
/// School Prayer
replace VCF9051=. if VCF9051==8 | VCF9051==9
replace VCF9051=2 if VCF9051==5
/// Fed Gov. Ensures Fair Jobs for Blacks
replace VCF9037=. if VCF9037==9
replace VCF9037=2 if VCF9037==5
/// Authority of the Bible - Alternate
replace VCF0845=. if VCF0845==0 | VCF0845==9
/// Fed Gov Too Strong?
replace VCF0829=. if VCF0829==0 | VCF0829==9
/// Vietnam Scale
replace VCF0827=. if VCF0827==0 |  VCF0827==9
/// Vietnam Right Thing
replace VCF0826=. if VCF0826==0 | VCF0826==8 | VCF0826==9
/// AIDS scale
replace VCF0889=. if VCF0889==8
/// U.S. Foreign Involvement
replace VCF0823=. if VCF0823==0 | VCF0823==9
/// Reversing Scale
replace VCF0823=(3-VCF0823)
/// Open Housing
replace  VCF0819=. if  VCF0819==0 |   VCF0819==9
/// Reversing Scale
replace VCF0819 = (3-VCF0819)
/// School Intergration
replace  VCF0816=. if  VCF0816==0 |  VCF0816==9
/// Segregation
replace VCF0815=. if VCF0815==0 | VCF0815==9
/// Civil Rights Too Fast?
replace VCF0814=. if VCF0814==0 | VCF0814==9
/// Urban Unrest Scale
replace VCF0811=. if VCF0814==0 | VCF0814==9
/// Gov. Gar. Jobs
replace VCF0808=. if  VCF0808==0 |  VCF0808==9
/// Gov Medical Ass.
replace VCF0805=. if VCF0805==0 | VCF0805==9
/// Trust in Fed Gov
replace VCF0604=. if VCF0604==0 | VCF0604==9
replace VCF0604=(3-VCF0604)
/// Approve of Protests
replace VCF0601=. if VCF0601==0
/// Reversing Scale
replace VCF0601=(4-VCF0601)
/// Approve of Civil Disobedience 
replace VCF0602=. if VCF0602==0
///  Approve of Demonstrations
replace VCF0603=. if VCF0603==0
///Reversing Scale
replace VCF0603=(4-VCF0603)
/// Federal Gov for the Few or Many
replace VCF0605=. if  VCF0605==0 |  VCF0605==9
/// Reversing Scale
replace VCF0605=(3-VCF0605)
/// Federal Gov Wasteful
replace VCF0606=. if VCF0606==0 |  VCF0606==9
///Reversing Scale
replace VCF0606=(3-VCF0606)
/// Cut Military Spending
replace VCF0828=. if VCF0828==0 | VCF0828==9
/// Rights of Accused
replace VCF0832=. if  VCF0832==9 |  VCF0832==0
/// Vietnam Scale
replace VCF0827a=. if VCF0827a==8 | VCF0827a==9 | VCF0827a==0
/// Busing
replace VCF0817=. if VCF0817==0 | VCF0817==9
/// Abortion Scale Alt
replace VCF0837=. if  VCF0837==0 |  VCF0837==9
/// Women in Politics
replace  VCF0836=. if  VCF0836==0 |  VCF0832==9
/// Self Interested
replace  VCF0620=. if  VCF0620==0 |  VCF0620==9
/// Lib-Con Scale
replace VCF0803=. if VCF0803==0 
/// Fairness
replace VCF0621=. if VCF0621==0 | VCF0621==9

/// Alternate Scales 1/2 of Sample 
/// Recodes - Gov Spending Scale
replace VCF0839 =. if VCF0839==0|VCF0839==9
/// Recodes - Gov Insurance 
replace VCF0806 =. if VCF0806==0|VCF0806==9
/// Recodes - Gov Ensure Standard of Living 
replace VCF0809 =. if VCF0809==0|VCF0809==9
/// Recodes - Women's Role
replace VCF0834=. if VCF0834==0|VCF0834==9
/// Recodes - Aid To Blacks
 replace VCF0830=. if  VCF0830==0|VCF0830==9
 /// Recodes - Environmental Protection
replace VCF0842=. if VCF0842==0|VCF0842==9

/// recode -- Implicit Racism
replace VCF9042 =. if VCF9042 ==8 | VCF9042 ==9
replace VCF9041 =. if VCF9041 ==8 | VCF9041 ==9
replace VCF9040 =. if VCF9040 ==8 | VCF9040 ==9
replace VCF9039 =. if VCF9039 ==8 | VCF9039 ==9
/// recode SS_Spending 
replace VCF9049=. if VCF9049==4 | VCF9049==9


/// Renaming Variables
rename VCF0878 Gay_Adoption
rename VCF0867a AFF_Action_Scale
rename VCF0894 Welfare_Scale
rename VCF0886 Aid_to_poor_Scale
rename VCF9049 SS_Spending_Scale
rename VCF0890 School_Fund_Scale
rename VCF0838 Abortion_Scale
rename VCF0877a Gay_Military_Scale
rename VCF9047 Envir_Spend_Scale
rename VCF0888 Crime_Spend_Scale
rename VCF0850 Bible_Scale
rename VCF0845 Bible_Scale_Alt
rename VCF0879a Immigrants_Scale
rename VCF0892 Foreign_Aid_Scale
rename VCF9132 Free_Market_Scale
rename VCF9131 More_Less_Gov_Scale
rename VCF0876 Gay_Discrimination
rename VCF9133 Gov_too_involved
rename VCF0853 Traditional_Values_Scale
rename VCF9050 Aid_Blacks_Scale
rename VCF9046 Food_Stamps_Scale
rename VCF0851 New_Lifestyles_Moraldecay
rename VCF0852 Adjust_Morals
rename VCF9134 Self_Reliance
rename VCF0887 Child_Care
rename VCF0889 Fight_AIDS
rename VCF9051 School_Prayer
rename VCF9037 Fair_jobs_blacks
rename VCF0829 Fed_Gov_Too_Strong
rename VCF0827 Vietnam_Scale
rename VCF0826 Vietnam_Right_Thing
rename VCF0823 US_Better_Uninvolved
rename VCF0815 Segregation_Scale
rename VCF0816 School_Integration_Scale
rename VCF0819 Open_Housing_Scale
rename VCF0814 Urban_Unrest_Scale
rename VCF0808 Gov_Gar_Jobs_Scale
rename VCF0604 Fed_Gov_Trust_Scale
rename VCF0601 Approve_Protests
rename VCF0602 Approve_Civil_Disob
rename VCF0603 Approve_Demonstrations
rename VCF0805 Gov_Ins_Scale
rename VCF0811 Civil_Unrest_Scale
rename VCF0704 Pres_Vote
rename VCF0605 Federal_Gov_FeworMany
rename VCF0606 Federal_Gov_Wastful
rename VCF0828 Cut_Military_Spending
rename VCF0827a Vietnam_Scale_Alt
rename VCF0817 School_Busing_Scale
rename VCF0832 Rights_of_Accused 
rename VCF0836 Women_In_Politics
rename VCF0837 Abortion_Scale_Alt
rename VCF0620 Self_Interest
rename VCF0803 Lib_Con_Scale

rename VCF0839 Gov_Spend_Placement
rename VCF0806 Gov_Ins_Placement
rename VCF0809 Gov_SL_Placement
rename VCF0834 Womens_Role_Placement
rename VCF0830 Aid_Blacks_Placement
rename VCF0842 Environmental_Pro_Placement
rename VCF0621 People_Fairness
rename VCF0050a Polinfo_Pre
rename VCF0050b Polinfo_Post
rename VCF9036 Know_MP_Sen
rename VCF0729 Know_MP_Pre
rename VCF0730 Know_MP_Post
rename VCF9087 DemC_JobsScale
rename VCF9095 RepC_JobsScale
rename VCF9088 DemC_LibCon
rename VCF9096 RepC_LibCon
rename VCF0503 DemPty_LibCon
rename VCF0504 RepPty_LibCon
rename VCF0703 Reg_to_vote

/// Dropping Missing Var
foreach varname of varlist * {
	 quietly sum `varname'
	 if `r(N)'==0 {
	  drop `varname'
	 }
	}



/// Polychoric Factor Analysis for 2012


polychoric Gov_Ins_Placement Gov_SL_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale School_Fund_Scale Immigrants_Scale Envir_Spend_Scale New_Lifestyles_Moraldecay Bible_Scale Abortion_Scale   Aid_Blacks_Placement Aid_to_poor_Scale Gay_Discrimination Gay_Adoption Gay_Military_Scale [pweight= vcf0010z], pw 
display r(sum_w)
matrix poly2012 = r(R)
matrix target = ( 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly2012, n(890) factors(2) blanks(.4) ml
rotate, target(target)
*esttab e(r_L) using factor, append
*esttab e(r_Phi) using correlation, append
predict F1 F2
zscore Gov_Ins_Placement Gov_SL_Placement More_Less_Gov_Scale SS_Spending_Scale Fair_jobs_blacks Welfare_Scale School_Fund_Scale Immigrants_Scale Envir_Spend_Scale New_Lifestyles_Moraldecay Bible_Scale  Abortion_Scale  Aid_Blacks_Placement Aid_to_poor_Scale Gay_Discrimination Gay_Adoption Gay_Military_Scale 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1 = z_Gov_SL_Placement*.112
gen F1_var2 = z_Gov_Ins_Placement*.172
gen F1_var3 = z_More_Less_Gov_Scale*.222
gen F1_var4 = z_SS_Spending_Scale*.069
gen F1_var5 = z_Fair_jobs_blacks*.075
gen F1_var6 =  z_Welfare_Scale*.123
gen F1_var7 =  z_School_Fund_Scale*.107
gen F1_var8 =  z_Immigrants_Scale*.004
gen F1_var9 =  z_Envir_Spend_Scale*.122
gen F1_var10 = z_New_Lifestyles_Moraldecay*-.019
gen F1_var11 = z_Bible_Scale*-.042
gen F1_var13 = z_Abortion_Scale*.002
gen F1_var16 = z_Aid_Blacks_Placement*.109
gen F1_var17 = z_Aid_to_poor_Scale*.191
gen F1_var18 = z_Gay_Discrimination*.014
gen F1_var19 = z_Gay_Adoption*.041
gen F1_var20 = z_Gay_Military_Scale*.029


/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1)   
egen F1_max2=  max(F1_var2)    
egen F1_max3=  max(F1_var3)
egen F1_max4=  max(F1_var4)   
egen F1_max5=  max(F1_var5)   
egen F1_max6=  max(F1_var6)   
egen F1_max7=  max(F1_var7)   
egen F1_max8=  max(F1_var8) 
egen F1_max9=  max(F1_var9)
egen F1_max10= max(F1_var10)
egen F1_max11= max(F1_var11)
egen F1_max13= max(F1_var13)
egen F1_max16= max(F1_var16)
egen F1_max17= max(F1_var17)
egen F1_max18= max(F1_var18)
egen F1_max19= max(F1_var19)
egen F1_max20= max(F1_var20)


/// Generating Missing Responses 
gen F1_var1_MI = 1 if F1_var1~=.
gen F1_var2_MI = 1 if F1_var2~=.
gen F1_var3_MI = 1 if F1_var3~=.
gen F1_var4_MI = 1 if F1_var4~=.
gen F1_var5_MI = 1 if F1_var5~=.
gen F1_var6_MI = 1 if F1_var6~=.
gen F1_var7_MI = 1 if F1_var7~=.
gen F1_var8_MI = 1 if F1_var8~=.
gen F1_var9_MI = 1 if F1_var9~=.
gen F1_var10_MI = 1 if F1_var10~=.
gen F1_var11_MI = 1 if F1_var11~=.
gen F1_var13_MI = 1 if F1_var13~=.
gen F1_var16_MI = 1 if F1_var16~=.
gen F1_var17_MI = 1 if F1_var17~=.
gen F1_var18_MI = 1 if F1_var18~=.
gen F1_var19_MI = 1 if F1_var19~=.
gen F1_var20_MI = 1 if F1_var20~=.


/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1 = F1_max1* F1_var1_MI
gen F1_Ind_MAX_Var2 = F1_max2* F1_var2_MI
gen F1_Ind_MAX_Var3 = F1_max3* F1_var3_MI
gen F1_Ind_MAX_Var4 = F1_max4* F1_var4_MI
gen F1_Ind_MAX_Var5 = F1_max5* F1_var5_MI
gen F1_Ind_MAX_Var6 = F1_max6* F1_var6_MI
gen F1_Ind_MAX_Var7 = F1_max7* F1_var7_MI
gen F1_Ind_MAX_Var8 = F1_max8* F1_var8_MI
gen F1_Ind_MAX_Var9 = F1_max9* F1_var9_MI
gen F1_Ind_MAX_Var10 = F1_max10* F1_var10_MI
gen F1_Ind_MAX_Var11 = F1_max11* F1_var11_MI
gen F1_Ind_MAX_Var13 = F1_max13* F1_var13_MI
gen F1_Ind_MAX_Var16 = F1_max16* F1_var16_MI
gen F1_Ind_MAX_Var17 = F1_max17* F1_var17_MI
gen F1_Ind_MAX_Var18 = F1_max18* F1_var18_MI
gen F1_Ind_MAX_Var19 = F1_max19* F1_var19_MI
gen F1_Ind_MAX_Var20 = F1_max20* F1_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max = rowtotal(F1_Ind_MAX_Var1-F1_Ind_MAX_Var17)
egen Max = max(F1_Ind_Max)
gen Pct_Max1 = F1_Ind_Max/Max
drop if Pct_Max1<.8
/// Generating Individual Scores
egen F1_Score = rowtotal(F1_var1-F1_var17)
/// Generating Mean Score
egen totalresp = rowtotal (F1_var1_MI-F1_var17_MI)
rename F1_Score F1_Adj
/// 
egen F1_max = max(F1_Adj)
egen F1_min = min(F1_Adj)


/// Repeating the Process for the Second Dimension
/// Creating Individual Factor Coef. Scores for the First Dimension
gen F2_var1 = z_Gov_SL_Placement*.023
gen F2_var2 = z_Gov_Ins_Placement*-.034
gen F2_var3 = z_More_Less_Gov_Scale*-.079
gen F2_var4 = z_SS_Spending_Scale*-.059
gen F2_var5 = z_Fair_jobs_blacks*.018
gen F2_var6 =  z_Welfare_Scale*-.033
gen F2_var7 =  z_School_Fund_Scale*.008
gen F2_var8 =  z_Immigrants_Scale*.036
gen F2_var9 =  z_Envir_Spend_Scale*.001
gen F2_var10 = z_New_Lifestyles_Moraldecay*-.103
gen F2_var11 = z_Bible_Scale*.225
gen F2_var13 = z_Abortion_Scale*.115
gen F2_var16 = z_Aid_Blacks_Placement*-.005
gen F2_var17 = z_Aid_to_poor_Scale*-.078
gen F2_var18 = z_Gay_Discrimination*.147
gen F2_var19 = z_Gay_Adoption*.351
gen F2_var20 = z_Gay_Military_Scale*.212
/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1)   
egen F2_max2=  max(F2_var2)    
egen F2_max3=  max(F2_var3)
egen F2_max4=  max(F2_var4)   
egen F2_max5=  max(F2_var5)   
egen F2_max6=  max(F2_var6)   
egen F2_max7=  max(F2_var7)   
egen F2_max8=  max(F2_var8) 
egen F2_max9=  max(F2_var9)
egen F2_max10= max(F2_var10)
egen F2_max11= max(F2_var11)
egen F2_max13= max(F2_var13)
egen F2_max16= max(F2_var16)
egen F2_max17= max(F2_var17)
egen F2_max18= max(F2_var18)
egen F2_max19= max(F2_var19)
egen F2_max20= max(F2_var20)


/// Generating Missing Responses 
gen F2_var1_MI = 1 if F2_var1~=.
gen F2_var2_MI = 1 if F2_var2~=.
gen F2_var3_MI = 1 if F2_var3~=.
gen F2_var4_MI = 1 if F2_var4~=.
gen F2_var5_MI = 1 if F2_var5~=.
gen F2_var6_MI = 1 if F2_var6~=.
gen F2_var7_MI = 1 if F2_var7~=.
gen F2_var8_MI = 1 if F2_var8~=.
gen F2_var9_MI = 1 if F2_var9~=.
gen F2_var10_MI = 1 if F2_var10~=.
gen F2_var11_MI = 1 if F2_var11~=.
gen F2_var13_MI = 1 if F2_var13~=.
gen F2_var16_MI = 1 if F2_var16~=.
gen F2_var17_MI = 1 if F2_var17~=.
gen F2_var18_MI = 1 if F2_var18~=.
gen F2_var19_MI = 1 if F2_var19~=.
gen F2_var20_MI = 1 if F2_var20~=.


/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1 = F2_max1* F2_var1_MI
gen F2_Ind_MAX_Var2 = F2_max2* F2_var2_MI
gen F2_Ind_MAX_Var3 = F2_max3* F2_var3_MI
gen F2_Ind_MAX_Var4 = F2_max4* F2_var4_MI
gen F2_Ind_MAX_Var5 = F2_max5* F2_var5_MI
gen F2_Ind_MAX_Var6 = F2_max6* F2_var6_MI
gen F2_Ind_MAX_Var7 = F2_max7* F2_var7_MI
gen F2_Ind_MAX_Var8 = F2_max8* F2_var8_MI
gen F2_Ind_MAX_Var9 = F2_max9* F2_var9_MI
gen F2_Ind_MAX_Var10 = F2_max10* F2_var10_MI
gen F2_Ind_MAX_Var11 = F2_max11* F2_var11_MI
gen F2_Ind_MAX_Var13 = F2_max13* F2_var13_MI
gen F2_Ind_MAX_Var16 = F2_max16* F2_var16_MI
gen F2_Ind_MAX_Var17 = F2_max17* F2_var17_MI
gen F2_Ind_MAX_Var18 = F2_max18* F2_var18_MI
gen F2_Ind_MAX_Var19 = F2_max19* F2_var19_MI
gen F2_Ind_MAX_Var20 = F2_max20* F2_var20_MI


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max = rowtotal(F2_Ind_MAX_Var1-F2_Ind_MAX_Var20)
egen Max2 = max(F2_Ind_Max)
gen Pct_Max2 = F2_Ind_Max/Max2
drop if Pct_Max2<.8

/// Generating Individual Scores
egen F2_Score = rowtotal(F2_var1-F2_var20)
/// Generating Mean Score
rename F2_Score F2_Adj
/// 
egen F2_max = max(F2_Adj)
egen F2_min = min(F2_Adj)

egen SD_F1 = sd(F1_Adj)
egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
egen mean_F1 = mean(F1_Adj)
egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2
replace Pres_Vote =. if Pres_Vote==0
replace Pres_Vote =0 if Pres_Vote==2

rename VCF0004 year
rename VCF0101 age
rename VCF0102 age_group
rename VCF0103 age_cohort
rename VCF0104 gender
rename VCF0110 Education_4cat
rename VCF0130 weekly_church
rename VCF0112 Census_region
rename VCF0113 Political_South
rename VCF0114 Income
rename VCF0127 Union
rename VCF0128 religion
rename VCF0140 education_6cat
rename VCF0140a education_7cat
rename VCF0301 PID_7


save  "ANES_POST_FACTOR_2012.dta", replace

clear all
set more off

/// Combining Datasets

use  "ANES_POST_FACTOR_1972.dta"
append using  "ANES_POST_FACTOR_1976.dta"
append using  "ANES_POST_FACTOR_1980.dta"
append using  "ANES_POST_FACTOR_1984.dta"
append using  "ANES_POST_FACTOR_1988.dta"
append using  "ANES_POST_FACTOR_1992.dta"
append using  "ANES_POST_FACTOR_1996.dta"
append using  "ANES_POST_FACTOR_2000.dta"
append using  "ANES_POST_FACTOR_2004.dta"
append using  "ANES_POST_FACTOR_2008.dta"
append using  "ANES_POST_FACTOR_2012.dta"

save "ANES_POST_FACTOR_COMBINED.dta", replace

