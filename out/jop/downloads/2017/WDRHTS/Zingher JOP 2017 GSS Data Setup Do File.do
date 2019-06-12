clear all 
cd "Analysis Files"
use "GSS.dta"


drop  equal1-equal8 C_M OS_M IRS_M HISP


replace partyid =.n if partyid==7

gen Pres_Vote = .
replace Pres_Vote = 1 if year<=1976 & pres72==1
replace Pres_Vote = 0 if year<=1976 & pres72==2
replace Pres_Vote = 1 if year>=1977 & year<=1980 & pres76==1
replace Pres_Vote = 0 if year>=1977 & year<=1980 & pres76==2
replace Pres_Vote = 1 if year>=1981 & year<=1984 & pres80==1
replace Pres_Vote = 0 if year>=1981 & year<=1984 & pres80==2
replace Pres_Vote = 1 if year>=1985 & year<=1988 & pres84==1
replace Pres_Vote = 0 if year>=1985 & year<=1988 & pres84==2
replace Pres_Vote = 1 if year>=1989 & year<=1992 & pres88==1
replace Pres_Vote = 0 if year>=1989 & year<=1992 & pres88==2
replace Pres_Vote = 1 if year>=1993 & year<=1996 & pres92==1
replace Pres_Vote = 0 if year>=1993 & year<=1996 & pres92==2
replace Pres_Vote = 1 if year>=1997 & year<=2000 & pres96==1
replace Pres_Vote = 0 if year>=1997 & year<=2000 & pres96==2
replace Pres_Vote = 1 if year>=2001 & year<=2004 & pres00==1
replace Pres_Vote = 0 if year>=2001 & year<=2004 & pres00==2
replace Pres_Vote = 1 if year>=2005 & year<=2008 & pres04==1
replace Pres_Vote = 0 if year>=2005 & year<=2008 & pres04==2
replace Pres_Vote = 1 if year>=2009 & year<=2012 & pres08==1
replace Pres_Vote = 0 if year>=2009 & year<=2012 & pres08==2
replace Pres_Vote = 1 if year>=2013 & pres12==1
replace Pres_Vote = 0 if year>=2013 & pres12==2

gen white = 0 
replace white =1 if race==1
gen Catholic = 0
replace Catholic =1 if relig==2
gen Jew=0
replace Jew=1 if relig==3
gen Union=0
replace Union =1 if union==1 | union==2 | union==3
gen white_southerner = 0
replace white_southerner = 1 if white==1 & region==5 | white==1 & region==6 | white==1 & region==7
gen female = 0 
replace female = 1 if sex ==2
gen weeklychurch = 0
replace weeklychurch=1 if attend>=6
gen Latino=0
replace Latino=1 if hispanic>=2 & hispanic<=50
replace white=0 if Latino==1

sort year id

zscore abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun


/// Factor Analysis for 1984 Election

polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=1985 & year<=1988 [pw=wtssall], pw
display r(sum_w)
matrix poly1984 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly1984, n(3956) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_84 F2_84 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_84 = z_abany*-.011
gen F1_var2_84 = z_abrape*-.081
gen F1_var3_84 = z_grass*-.036
gen F1_var4_84 = z_bible*-.012
gen F1_var5_84 = z_premarsx*-.040
gen F1_var6_84 = z_fefam*-.030
gen F1_var7_84 = z_homosex*-.052
gen F1_var8_84 = z_prayer*.015
gen F1_var9_84 = z_letdie1*-.036
gen F1_var10_84 = z_helppoor*.239
gen F1_var11_84 = z_helpnot*.166
gen F1_var12_84 = z_helpsick*.145
gen F1_var13_84 = z_helpblk*.215
gen F1_var14_84 = z_natfare*.146
gen F1_var15_84 = z_natrace*.166
gen F1_var16_84 = z_eqwlth*.112
gen F1_var17_84 = z_cappun*-.121

/// Creating Maximum Possible Scores
egen F1_max1=  max(F1_var1_84)
egen F1_max2=  max(F1_var2_84)
egen F1_max3=  max(F1_var3_84)   
egen F1_max4=  max(F1_var4_84)
egen F1_max5=  max(F1_var5_84)   
egen F1_max6=  max(F1_var6_84)   
egen F1_max7=  max(F1_var7_84)   
egen F1_max8=  max(F1_var8_84) 
egen F1_max9=  max(F1_var9_84)
egen F1_max10= max(F1_var10_84)
egen F1_max11= max(F1_var11_84)
egen F1_max12= max(F1_var12_84)
egen F1_max13= max(F1_var13_84)
egen F1_max14= max(F1_var14_84)
egen F1_max15= max(F1_var15_84)
egen F1_max16= max(F1_var16_84)
egen F1_max17= max(F1_var17_84)

/// Generating Missing Responses 
gen F1_var1_MI_84 = 1 if F1_var1_84~=.
gen F1_var2_MI_84 = 1 if F1_var2_84~=.
gen F1_var3_MI_84 = 1 if F1_var3_84~=.
gen F1_var4_MI_84 = 1 if F1_var4_84~=.
gen F1_var5_MI_84 = 1 if F1_var5_84~=.
gen F1_var6_MI_84 = 1 if F1_var6_84~=.
gen F1_var7_MI_84 = 1 if F1_var7_84~=.
gen F1_var8_MI_84 = 1 if F1_var8_84~=.
gen F1_var9_MI_84 = 1 if F1_var9_84~=.
gen F1_var10_MI_84 = 1 if F1_var10_84~=.
gen F1_var11_MI_84 = 1 if F1_var11_84~=.
gen F1_var12_MI_84 = 1 if F1_var12_84~=.
gen F1_var13_MI_84 = 1 if F1_var13_84~=.
gen F1_var14_MI_84 = 1 if F1_var14_84~=.
gen F1_var15_MI_84 = 1 if F1_var15_84~=.
gen F1_var16_MI_84 = 1 if F1_var16_84~=.
gen F1_var17_MI_84 = 1 if F1_var17_84~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_84 = F1_max1* F1_var1_MI_84
gen F1_Ind_MAX_Var2_84 = F1_max2* F1_var2_MI_84
gen F1_Ind_MAX_Var3_84 = F1_max3* F1_var3_MI_84
gen F1_Ind_MAX_Var4_84 = F1_max4* F1_var4_MI_84
gen F1_Ind_MAX_Var5_84 = F1_max5* F1_var5_MI_84
gen F1_Ind_MAX_Var6_84 = F1_max6* F1_var6_MI_84
gen F1_Ind_MAX_Var7_84 = F1_max7* F1_var7_MI_84
gen F1_Ind_MAX_Var8_84 = F1_max8* F1_var8_MI_84
gen F1_Ind_MAX_Var9_84 = F1_max9* F1_var9_MI_84
gen F1_Ind_MAX_Var10_84 = F1_max10* F1_var10_MI_84
gen F1_Ind_MAX_Var11_84 = F1_max11* F1_var11_MI_84
gen F1_Ind_MAX_Var12_84 = F1_max12* F1_var12_MI_84
gen F1_Ind_MAX_Var13_84 = F1_max13* F1_var13_MI_84
gen F1_Ind_MAX_Var14_84 = F1_max14* F1_var14_MI_84
gen F1_Ind_MAX_Var15_84 = F1_max15* F1_var15_MI_84
gen F1_Ind_MAX_Var16_84 = F1_max16* F1_var16_MI_84
gen F1_Ind_MAX_Var17_84 = F1_max17* F1_var17_MI_84


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_84 = rowtotal(F1_Ind_MAX_Var1_84-F1_Ind_MAX_Var17_84)
egen Max_84 = max(F1_Ind_Max_84)
gen Pct_Max1_84 = F1_Ind_Max_84/Max_84

/// Generating Individual Scores
egen F1_Score_84 = rowtotal(F1_var1_84-F1_var17_84)

/// Dropping non-Respondents

egen totalresp_84 = rowtotal (F1_var1_MI_84-F1_var17_MI_84)
/// 
egen F1_max_84 = max(F1_Score_84)
egen F1_min_84 = min(F1_Score_84)


/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_84 = z_abany*.300
gen F2_var2_84 = z_abrape*.261
gen F2_var3_84 = z_grass*.092
gen F2_var4_84 = z_bible*-.090
gen F2_var5_84 = z_premarsx*-.154
gen F2_var6_84 = z_fefam*-.063
gen F2_var7_84 = z_homosex*-.148
gen F2_var8_84 = z_prayer*.051
gen F2_var9_84 = z_letdie1*.112
gen F2_var10_84 = z_helppoor*-.008
gen F2_var11_84 = z_helpnot*-.006
gen F2_var12_84 = z_helpsick*.007
gen F2_var13_84 = z_helpblk*.001
gen F2_var14_84 = z_natfare*.006
gen F2_var15_84 = z_natrace*.010
gen F2_var16_84 = z_eqwlth*-.016
gen F2_var17_84 = z_cappun*-.010

/// Creating Maximum Possible Scores
egen F2_max1=  max(F2_var1_84)
egen F2_max2=  max(F2_var2_84)
egen F2_max3=  max(F2_var3_84)   
egen F2_max4=  max(F2_var4_84)
egen F2_max5=  max(F2_var5_84)   
egen F2_max6=  max(F2_var6_84)   
egen F2_max7=  max(F2_var7_84)   
egen F2_max8=  max(F2_var8_84) 
egen F2_max9=  max(F2_var9_84)
egen F2_max10= max(F2_var10_84)
egen F2_max11= max(F2_var11_84)
egen F2_max12= max(F2_var12_84)
egen F2_max13= max(F2_var13_84)
egen F2_max14= max(F2_var14_84)
egen F2_max15= max(F2_var15_84)
egen F2_max16= max(F2_var16_84)
egen F2_max17= max(F2_var17_84)

/// Generating Missing Responses 
gen F2_var1_MI_84 = 1 if F2_var1_84~=.
gen F2_var2_MI_84 = 1 if F2_var2_84~=.
gen F2_var3_MI_84 = 1 if F2_var3_84~=.
gen F2_var4_MI_84 = 1 if F2_var4_84~=.
gen F2_var5_MI_84 = 1 if F2_var5_84~=.
gen F2_var6_MI_84 = 1 if F2_var6_84~=.
gen F2_var7_MI_84 = 1 if F2_var7_84~=.
gen F2_var8_MI_84 = 1 if F2_var8_84~=.
gen F2_var9_MI_84 = 1 if F2_var9_84~=.
gen F2_var10_MI_84 = 1 if F2_var10_84~=.
gen F2_var11_MI_84 = 1 if F2_var11_84~=.
gen F2_var12_MI_84 = 1 if F2_var12_84~=.
gen F2_var13_MI_84 = 1 if F2_var13_84~=.
gen F2_var14_MI_84 = 1 if F2_var14_84~=.
gen F2_var15_MI_84 = 1 if F2_var15_84~=.
gen F2_var16_MI_84 = 1 if F2_var16_84~=.
gen F2_var17_MI_84 = 1 if F2_var17_84~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_84 = F2_max1* F2_var1_MI_84
gen F2_Ind_MAX_Var2_84 = F2_max2* F2_var2_MI_84
gen F2_Ind_MAX_Var3_84 = F2_max3* F2_var3_MI_84
gen F2_Ind_MAX_Var4_84 = F2_max4* F2_var4_MI_84
gen F2_Ind_MAX_Var5_84 = F2_max5* F2_var5_MI_84
gen F2_Ind_MAX_Var6_84 = F2_max6* F2_var6_MI_84
gen F2_Ind_MAX_Var7_84 = F2_max7* F2_var7_MI_84
gen F2_Ind_MAX_Var8_84 = F2_max8* F2_var8_MI_84
gen F2_Ind_MAX_Var9_84 = F2_max9* F2_var9_MI_84
gen F2_Ind_MAX_Var10_84 = F2_max10* F2_var10_MI_84
gen F2_Ind_MAX_Var11_84 = F2_max11* F2_var11_MI_84
gen F2_Ind_MAX_Var12_84 = F2_max12* F2_var12_MI_84
gen F2_Ind_MAX_Var13_84 = F2_max13* F2_var13_MI_84
gen F2_Ind_MAX_Var14_84 = F2_max14* F2_var14_MI_84
gen F2_Ind_MAX_Var15_84 = F2_max15* F2_var15_MI_84
gen F2_Ind_MAX_Var16_84 = F2_max16* F2_var16_MI_84
gen F2_Ind_MAX_Var17_84 = F2_max17* F2_var17_MI_84


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_84 = rowtotal(F2_Ind_MAX_Var1_84-F2_Ind_MAX_Var17_84)
egen Max_F2_84 = max(F2_Ind_Max_84)
gen Pct_Max2_84 = F2_Ind_Max_84/Max_F2_84

drop if Pct_Max1_84 <.8 & year>=1985 & year<=1988

/// Generating Individual Scores--Second Dimension
egen F2_Score_84 = rowtotal(F2_var1_84-F2_var17_84)

*egen SD_F1_84 = sd(F1_Score_84)
*egen SD_F2_84 = sd(F2_Score_84)
*replace F1_Score_84 = F1_Score_84/SD_F1_84
*replace F2_Score_84 = F2_Score_84/SD_F2_84
*egen mean_F1_84 = mean(F1_Score_84)
*egen mean_F2_84 = mean(F2_Score_84)
*replace F1_Score_84 = F1_Score_84-mean_F1
*replace F2_Score_84 = F2_Score_84-mean_F2

*logit Pres_Vote F1_Score_84 F2_Score_84 if year>=1985 & year<=1988
*outreg2 using VoteChoice, replace dec(2) 
*regress partyid F1_Score_84 F2_Score_84 if year>=1985 & year<=1988
*outreg2 using partisanship, replace dec(2) 


/// Factor Analysis for 1980 Election


polychoric abany abrape grass prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=1981 & year<=1984 [pw=wtssall], pw
display r(sum_w)
matrix poly1980 = r(R)
matrix target = ( 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 )
factormat poly1980, n(2856) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_80 F2_80 

gen F1_var1_80 = z_abany*.005
gen F1_var2_80 = z_abrape*-.006
gen F1_var3_80 = z_grass*.043
gen F1_var8_80 = z_prayer*.007
gen F1_var9_80 = z_letdie1*-.032
gen F1_var10_80 = z_helppoor*.269
gen F1_var11_80 = z_helpnot*.188
gen F1_var12_80 = z_helpsick*.182
gen F1_var13_80 = z_helpblk*.174
gen F1_var14_80 = z_natfare*.168
gen F1_var15_80 = z_natrace*.156
gen F1_var16_80 = z_eqwlth*.126
gen F1_var17_80 = z_cappun*-.085


/// Generating Missing Responses 
gen F1_var1_MI_80 = 1 if F1_var1_80~=.
gen F1_var2_MI_80 = 1 if F1_var2_80~=.
gen F1_var3_MI_80 = 1 if F1_var3_80~=.
gen F1_var8_MI_80 = 1 if F1_var8_80~=.
gen F1_var9_MI_80 = 1 if F1_var9_80~=.
gen F1_var10_MI_80 = 1 if F1_var10_80~=.
gen F1_var11_MI_80 = 1 if F1_var11_80~=.
gen F1_var12_MI_80 = 1 if F1_var12_80~=.
gen F1_var13_MI_80 = 1 if F1_var13_80~=.
gen F1_var14_MI_80 = 1 if F1_var14_80~=.
gen F1_var15_MI_80 = 1 if F1_var15_80~=.
gen F1_var16_MI_80 = 1 if F1_var16_80~=.
gen F1_var17_MI_80 = 1 if F1_var17_80~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_80 = F1_max1* F1_var1_MI_80
gen F1_Ind_MAX_Var2_80 = F1_max2* F1_var2_MI_80
gen F1_Ind_MAX_Var3_80 = F1_max3* F1_var3_MI_80
gen F1_Ind_MAX_Var8_80 = F1_max8* F1_var8_MI_80
gen F1_Ind_MAX_Var9_80 = F1_max9* F1_var9_MI_80
gen F1_Ind_MAX_Var10_80 = F1_max10* F1_var10_MI_80
gen F1_Ind_MAX_Var11_80 = F1_max11* F1_var11_MI_80
gen F1_Ind_MAX_Var12_80 = F1_max12* F1_var12_MI_80
gen F1_Ind_MAX_Var13_80 = F1_max13* F1_var13_MI_80
gen F1_Ind_MAX_Var14_80 = F1_max14* F1_var14_MI_80
gen F1_Ind_MAX_Var15_80 = F1_max15* F1_var15_MI_80
gen F1_Ind_MAX_Var16_80 = F1_max16* F1_var16_MI_80
gen F1_Ind_MAX_Var17_80 = F1_max17* F1_var17_MI_80


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_80 = rowtotal(F1_Ind_MAX_Var1_80-F1_Ind_MAX_Var17_80)
egen Max_80 = max(F1_Ind_Max_80)
gen Pct_Max1_80 = F1_Ind_Max_80/Max_80

/// Generating Individual Scores
egen F1_Score_80 = rowtotal(F1_var1_80-F1_var17_80)

/// Dropping non-Respondents

egen totalresp_80 = rowtotal (F1_var1_MI_80-F1_var17_MI_80)
/// 
egen F1_max_80 = max(F1_Score_80)
egen F1_min_80 = min(F1_Score_80)



/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_80 = z_abany*.348
gen F2_var2_80 = z_abrape*.526
gen F2_var3_80 = z_grass*.068
gen F2_var8_80 = z_prayer*.040
gen F2_var9_80 = z_letdie1*.113
gen F2_var10_80 = z_helppoor*.013
gen F2_var11_80 = z_helpnot*.019
gen F2_var12_80 = z_helpsick*.027
gen F2_var13_80 = z_helpblk*.020
gen F2_var14_80 = z_natfare*-.009
gen F2_var15_80 = z_natrace*.001
gen F2_var16_80 = z_eqwlth*.007
gen F2_var17_80 = z_cappun*.028


/// Generating Missing Responses 
gen F2_var1_MI_80 = 1 if F2_var1_80~=.
gen F2_var2_MI_80 = 1 if F2_var2_80~=.
gen F2_var3_MI_80 = 1 if F2_var3_80~=.
gen F2_var8_MI_80 = 1 if F2_var8_80~=.
gen F2_var9_MI_80 = 1 if F2_var9_80~=.
gen F2_var10_MI_80 = 1 if F2_var10_80~=.
gen F2_var11_MI_80 = 1 if F2_var11_80~=.
gen F2_var12_MI_80 = 1 if F2_var12_80~=.
gen F2_var13_MI_80 = 1 if F2_var13_80~=.
gen F2_var14_MI_80 = 1 if F2_var14_80~=.
gen F2_var15_MI_80 = 1 if F2_var15_80~=.
gen F2_var16_MI_80 = 1 if F2_var16_80~=.
gen F2_var17_MI_80 = 1 if F2_var17_80~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_80 = F2_max1* F2_var1_MI_80
gen F2_Ind_MAX_Var2_80 = F2_max2* F2_var2_MI_80
gen F2_Ind_MAX_Var3_80 = F2_max3* F2_var3_MI_80
gen F2_Ind_MAX_Var8_80 = F2_max8* F2_var8_MI_80
gen F2_Ind_MAX_Var9_80 = F2_max9* F2_var9_MI_80
gen F2_Ind_MAX_Var10_80 = F2_max10* F2_var10_MI_80
gen F2_Ind_MAX_Var11_80 = F2_max11* F2_var11_MI_80
gen F2_Ind_MAX_Var12_80 = F2_max12* F2_var12_MI_80
gen F2_Ind_MAX_Var13_80 = F2_max13* F2_var13_MI_80
gen F2_Ind_MAX_Var14_80 = F2_max14* F2_var14_MI_80
gen F2_Ind_MAX_Var15_80 = F2_max15* F2_var15_MI_80
gen F2_Ind_MAX_Var16_80 = F2_max16* F2_var16_MI_80
gen F2_Ind_MAX_Var17_80 = F2_max17* F2_var17_MI_80


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_80 = rowtotal(F2_Ind_MAX_Var1_80-F2_Ind_MAX_Var17_80)
egen Max_F2_80 = max(F2_Ind_Max_80)
gen Pct_Max2_80 = F2_Ind_Max_80/Max_F2_80

/// Generating Individual Scores--Second Dimension
egen F2_Score_80 = rowtotal(F2_var1_80-F2_var17_80)

drop if Pct_Max1_80 <.8 & year>=1981 & year<=1984


*egen SD_F1_80 = sd(F1_Score_80)
*egen SD_F2_80 = sd(F2_Score_80)
*replace F1_Score_80 = F1_Score_80/SD_F1_80
*replace F2_Score_80 = F2_Score_80/SD_F2_80
*egen mean_F1_80 = mean(F1_Score_80)
*egen mean_F2_80 = mean(F2_Score_80)
*replace F1_Score_80 = F1_Score_80-mean_F1_80
*replace F2_Score_80 = F2_Score_80-mean_F2_80

*logit Pres_Vote F1_Score_80 F2_Score_80 if year>=1981 & year<=1984
*outreg2 using VoteChoice, replace dec(2) 
*regress partyid F1_Score_80 F2_Score_80 if year>=1981 & year<=1984
*outreg2 using partisanship, replace dec(2) 



/// Factor Analysis for 1988 Election

polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=1989 & year<=1992 [pw=wtssall], pw
display r(sum_w)
matrix poly1988 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly1988, n(1916) factors(2) blanks(.4) ml
rotate, target(target) 
predict F1_88 F2_88 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_88 = z_abany*-.046
gen F1_var2_88 = z_abrape*-.024
gen F1_var3_88 = z_grass*.015
gen F1_var4_88 = z_bible*.031
gen F1_var5_88 = z_premarsx*-.029
gen F1_var6_88 = z_fefam*-.033
gen F1_var7_88 = z_homosex*-.062
gen F1_var8_88 = z_prayer*.017
gen F1_var9_88 = z_letdie1*-.036
gen F1_var10_88 = z_helppoor*.27
gen F1_var11_88 = z_helpnot*.192
gen F1_var12_88 = z_helpsick*.146
gen F1_var13_88 = z_helpblk*.216
gen F1_var14_88 = z_natfare*.143
gen F1_var15_88 = z_natrace*.155
gen F1_var16_88 = z_eqwlth*.121
gen F1_var17_88 = z_cappun*-.08

/// Generating Missing Responses 
gen F1_var1_MI_88 = 1 if F1_var1_88~=.
gen F1_var2_MI_88 = 1 if F1_var2_88~=.
gen F1_var3_MI_88 = 1 if F1_var3_88~=.
gen F1_var4_MI_88 = 1 if F1_var4_88~=.
gen F1_var5_MI_88 = 1 if F1_var5_88~=.
gen F1_var6_MI_88 = 1 if F1_var6_88~=.
gen F1_var7_MI_88 = 1 if F1_var7_88~=.
gen F1_var8_MI_88 = 1 if F1_var8_88~=.
gen F1_var9_MI_88 = 1 if F1_var9_88~=.
gen F1_var10_MI_88 = 1 if F1_var10_88~=.
gen F1_var11_MI_88 = 1 if F1_var11_88~=.
gen F1_var12_MI_88 = 1 if F1_var12_88~=.
gen F1_var13_MI_88 = 1 if F1_var13_88~=.
gen F1_var14_MI_88 = 1 if F1_var14_88~=.
gen F1_var15_MI_88 = 1 if F1_var15_88~=.
gen F1_var16_MI_88 = 1 if F1_var16_88~=.
gen F1_var17_MI_88 = 1 if F1_var17_88~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_88 = F1_max1* F1_var1_MI_88
gen F1_Ind_MAX_Var2_88 = F1_max2* F1_var2_MI_88
gen F1_Ind_MAX_Var3_88 = F1_max3* F1_var3_MI_88
gen F1_Ind_MAX_Var4_88 = F1_max4* F1_var4_MI_88
gen F1_Ind_MAX_Var5_88 = F1_max5* F1_var5_MI_88
gen F1_Ind_MAX_Var6_88 = F1_max6* F1_var6_MI_88
gen F1_Ind_MAX_Var7_88 = F1_max7* F1_var7_MI_88
gen F1_Ind_MAX_Var8_88 = F1_max8* F1_var8_MI_88
gen F1_Ind_MAX_Var9_88 = F1_max9* F1_var9_MI_88
gen F1_Ind_MAX_Var10_88 = F1_max10* F1_var10_MI_88
gen F1_Ind_MAX_Var11_88 = F1_max11* F1_var11_MI_88
gen F1_Ind_MAX_Var12_88 = F1_max12* F1_var12_MI_88
gen F1_Ind_MAX_Var13_88 = F1_max13* F1_var13_MI_88
gen F1_Ind_MAX_Var14_88 = F1_max14* F1_var14_MI_88
gen F1_Ind_MAX_Var15_88 = F1_max15* F1_var15_MI_88
gen F1_Ind_MAX_Var16_88 = F1_max16* F1_var16_MI_88
gen F1_Ind_MAX_Var17_88 = F1_max17* F1_var17_MI_88


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_88 = rowtotal(F1_Ind_MAX_Var1_88-F1_Ind_MAX_Var17_88)
egen Max_88 = max(F1_Ind_Max_88)
gen Pct_Max1_88 = F1_Ind_Max_88/Max_88

/// Generating Individual Scores
egen F1_Score_88 = rowtotal(F1_var1_88-F1_var16_88)

/// Dropping non-Respondents

egen totalresp_88 = rowtotal (F1_var1_MI_88-F1_var17_MI_88)
/// 
egen F1_max_88 = max(F1_Score_88)
egen F1_min_88 = min(F1_Score_88)


/// Creating Individual Factor Coef. Scores for the First Dimension
gen F2_var1_88 = z_abany*.28
gen F2_var2_88 = z_abrape*.317
gen F2_var3_88 = z_grass*.049
gen F2_var4_88 = z_bible*-.079
gen F2_var5_88 = z_premarsx*-.119
gen F2_var6_88 = z_fefam*-.058
gen F2_var7_88 = z_homosex*-.127
gen F2_var8_88 = z_prayer*.054
gen F2_var9_88 = z_letdie1*.156
gen F2_var10_88 = z_helppoor*-.020
gen F2_var11_88 = z_helpnot*-.006
gen F2_var12_88 = z_helpsick*.006
gen F2_var13_88 = z_helpblk*-.005
gen F2_var14_88 = z_natfare*.004
gen F2_var15_88 = z_natrace*.007
gen F2_var16_88 = z_eqwlth*-.02
gen F2_var17_88 = z_cappun*.021


/// Generating Missing Responses 
gen F2_var1_MI_88 = 1 if F2_var1_88~=.
gen F2_var2_MI_88 = 1 if F2_var2_88~=.
gen F2_var3_MI_88 = 1 if F2_var3_88~=.
gen F2_var4_MI_88 = 1 if F2_var4_88~=.
gen F2_var5_MI_88 = 1 if F2_var5_88~=.
gen F2_var6_MI_88 = 1 if F2_var6_88~=.
gen F2_var7_MI_88 = 1 if F2_var7_88~=.
gen F2_var8_MI_88 = 1 if F2_var8_88~=.
gen F2_var9_MI_88 = 1 if F2_var9_88~=.
gen F2_var10_MI_88 = 1 if F2_var10_88~=.
gen F2_var11_MI_88 = 1 if F2_var11_88~=.
gen F2_var12_MI_88 = 1 if F2_var12_88~=.
gen F2_var13_MI_88 = 1 if F2_var13_88~=.
gen F2_var14_MI_88 = 1 if F2_var14_88~=.
gen F2_var15_MI_88 = 1 if F2_var15_88~=.
gen F2_var16_MI_88 = 1 if F2_var16_88~=.
gen F2_var17_MI_88 = 1 if F2_var17_88~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_88 = F2_max1* F2_var1_MI_88
gen F2_Ind_MAX_Var2_88 = F2_max2* F2_var2_MI_88
gen F2_Ind_MAX_Var3_88 = F2_max3* F2_var3_MI_88
gen F2_Ind_MAX_Var4_88 = F2_max4* F2_var4_MI_88
gen F2_Ind_MAX_Var5_88 = F2_max5* F2_var5_MI_88
gen F2_Ind_MAX_Var6_88 = F2_max6* F2_var6_MI_88
gen F2_Ind_MAX_Var7_88 = F2_max7* F2_var7_MI_88
gen F2_Ind_MAX_Var8_88 = F2_max8* F2_var8_MI_88
gen F2_Ind_MAX_Var9_88 = F2_max9* F2_var9_MI_88
gen F2_Ind_MAX_Var10_88 = F2_max10* F2_var10_MI_88
gen F2_Ind_MAX_Var11_88 = F2_max11* F2_var11_MI_88
gen F2_Ind_MAX_Var12_88 = F2_max12* F2_var12_MI_88
gen F2_Ind_MAX_Var13_88 = F2_max13* F2_var13_MI_88
gen F2_Ind_MAX_Var14_88 = F2_max14* F2_var14_MI_88
gen F2_Ind_MAX_Var15_88 = F2_max15* F2_var15_MI_88
gen F2_Ind_MAX_Var16_88 = F2_max16* F2_var16_MI_88
gen F2_Ind_MAX_Var17_88 = F2_max16* F2_var17_MI_88


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_88 = rowtotal(F2_Ind_MAX_Var1_88-F2_Ind_MAX_Var17_88)
egen Max_F2_88 = max(F2_Ind_Max_88)
gen Pct_Max2_88 = F2_Ind_Max_88/Max_F2_88

/// Generating Individual Scores
egen F2_Score_88 = rowtotal(F2_var1_88-F2_var17_88)

drop if Pct_Max1_88 <.8 & year>=1989 & year<=1992



*egen SD_F1_88 = sd(F1_Score_88)
*egen SD_F2_88 = sd(F2_Score_88)
*replace F1_Score_88 = F1_Score_88/SD_F1_88
*replace F2_Score_88 = F2_Score_88/SD_F2_88
*egen mean_F1_88 = mean(F1_Score_88)
*egen mean_F2_88 = mean(F2_Score_88)
*replace F1_Score_88 = F1_Score_88-mean_F1_88
*replace F2_Score_88 = F2_Score_88-mean_F2_88

*logit Pres_Vote F1_Score_88 F2_Score_88 if year>=1989 & year<=1992
*outreg2 using VoteChoice, append dec(2) 
*regress partyid F1_Score_88 F2_Score_88 if year>=1989 & year<=1992
*outreg2 using partisanship, append dec(2) 


/// Factor Analysis for 1992 Election

polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=1993 & year<=1996 [pw=wtssall], pw
display r(sum_w)
matrix poly1992 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly1992, n(2698) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_92 F2_92 


/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_92 = z_abany*-.046
gen F1_var2_92 = z_abrape*-.024
gen F1_var3_92 = z_grass*.015
gen F1_var4_92 = z_bible*.031
gen F1_var5_92 = z_premarsx*-.029
gen F1_var6_92 = z_fefam*-.033
gen F1_var7_92 = z_homosex*-.062
gen F1_var8_92 = z_prayer*.017
gen F1_var9_92 = z_letdie1*-.036
gen F1_var10_92 = z_helppoor*.27
gen F1_var11_92 = z_helpnot*.192
gen F1_var12_92 = z_helpsick*.146
gen F1_var13_92 = z_helpblk*.216
gen F1_var14_92 = z_natfare*.143
gen F1_var15_92 = z_natrace*.155
gen F1_var16_92 = z_eqwlth*.121
gen F1_var17_92 = z_cappun*-.08


/// Generating Missing Responses 
gen F1_var1_MI_92 = 1 if F1_var1_92~=.
gen F1_var2_MI_92 = 1 if F1_var2_92~=.
gen F1_var3_MI_92 = 1 if F1_var3_92~=.
gen F1_var4_MI_92 = 1 if F1_var4_92~=.
gen F1_var5_MI_92 = 1 if F1_var5_92~=.
gen F1_var6_MI_92 = 1 if F1_var6_92~=.
gen F1_var7_MI_92 = 1 if F1_var7_92~=.
gen F1_var8_MI_92 = 1 if F1_var8_92~=.
gen F1_var9_MI_92 = 1 if F1_var9_92~=.
gen F1_var10_MI_92 = 1 if F1_var10_92~=.
gen F1_var11_MI_92 = 1 if F1_var11_92~=.
gen F1_var12_MI_92 = 1 if F1_var12_92~=.
gen F1_var13_MI_92 = 1 if F1_var13_92~=.
gen F1_var14_MI_92 = 1 if F1_var14_92~=.
gen F1_var15_MI_92 = 1 if F1_var15_92~=.
gen F1_var16_MI_92 = 1 if F1_var16_92~=.
gen F1_var17_MI_92 = 1 if F1_var17_92~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_92 = F1_max1* F1_var1_MI_92
gen F1_Ind_MAX_Var2_92 = F1_max2* F1_var2_MI_92
gen F1_Ind_MAX_Var3_92 = F1_max3* F1_var3_MI_92
gen F1_Ind_MAX_Var4_92 = F1_max4* F1_var4_MI_92
gen F1_Ind_MAX_Var5_92 = F1_max5* F1_var5_MI_92
gen F1_Ind_MAX_Var6_92 = F1_max6* F1_var6_MI_92
gen F1_Ind_MAX_Var7_92 = F1_max7* F1_var7_MI_92
gen F1_Ind_MAX_Var8_92 = F1_max8* F1_var8_MI_92
gen F1_Ind_MAX_Var9_92 = F1_max9* F1_var9_MI_92
gen F1_Ind_MAX_Var10_92 = F1_max10* F1_var10_MI_92
gen F1_Ind_MAX_Var11_92 = F1_max10* F1_var11_MI_92
gen F1_Ind_MAX_Var12_92 = F1_max12* F1_var12_MI_92
gen F1_Ind_MAX_Var13_92 = F1_max13* F1_var13_MI_92
gen F1_Ind_MAX_Var14_92 = F1_max14* F1_var14_MI_92
gen F1_Ind_MAX_Var15_92 = F1_max15* F1_var15_MI_92
gen F1_Ind_MAX_Var16_92 = F1_max16* F1_var16_MI_92
gen F1_Ind_MAX_Var17_92 = F1_max17* F1_var17_MI_92


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_92 = rowtotal(F1_Ind_MAX_Var1_92-F1_Ind_MAX_Var17_92)
egen Max_92 = max(F1_Ind_Max_92)
gen Pct_Max1_92 = F1_Ind_Max_92/Max_92

/// Generating Individual Scores
egen F1_Score_92 = rowtotal(F1_var1_92-F1_var17_92)

/// Dropping non-Respondents

egen totalresp_92 = rowtotal (F1_var1_MI_92-F1_var16_MI_92)
/// 
egen F1_max_92 = max(F1_Score_92)
egen F1_min_92 = min(F1_Score_92)


/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_92 = z_abany*.28
gen F2_var2_92 = z_abrape*.317
gen F2_var3_92 = z_grass*.049
gen F2_var4_92 = z_bible*-.079
gen F2_var5_92 = z_premarsx*-.119
gen F2_var6_92 = z_fefam*-.058
gen F2_var7_92 = z_homosex*-.127
gen F2_var8_92 = z_prayer*.054
gen F2_var9_92 = z_letdie1*.156
gen F2_var10_92 = z_helppoor*-.020
gen F2_var11_92 = z_helpnot*-.006
gen F2_var12_92 = z_helpsick*.006
gen F2_var13_92 = z_helpblk*-.005
gen F2_var14_92 = z_natfare*.004
gen F2_var15_92 = z_natrace*.007
gen F2_var16_92 = z_eqwlth*-.02
gen F2_var17_92 = z_cappun*.021


/// Generating Missing Responses 
gen F2_var1_MI_92 = 1 if F2_var1_92~=.
gen F2_var2_MI_92 = 1 if F2_var2_92~=.
gen F2_var3_MI_92 = 1 if F2_var3_92~=.
gen F2_var4_MI_92 = 1 if F2_var4_92~=.
gen F2_var5_MI_92 = 1 if F2_var5_92~=.
gen F2_var6_MI_92 = 1 if F2_var6_92~=.
gen F2_var7_MI_92 = 1 if F2_var7_92~=.
gen F2_var8_MI_92 = 1 if F2_var8_92~=.
gen F2_var9_MI_92 = 1 if F2_var9_92~=.
gen F2_var10_MI_92 = 1 if F2_var10_92~=.
gen F2_var11_MI_92 = 1 if F2_var11_92~=.
gen F2_var12_MI_92 = 1 if F2_var12_92~=.
gen F2_var13_MI_92 = 1 if F2_var13_92~=.
gen F2_var14_MI_92 = 1 if F2_var14_92~=.
gen F2_var15_MI_92 = 1 if F2_var15_92~=.
gen F2_var16_MI_92 = 1 if F2_var16_92~=.
gen F2_var17_MI_92 = 1 if F2_var17_92~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_92 = F2_max1* F2_var1_MI_92
gen F2_Ind_MAX_Var2_92 = F2_max2* F2_var2_MI_92
gen F2_Ind_MAX_Var3_92 = F2_max3* F2_var3_MI_92
gen F2_Ind_MAX_Var4_92 = F2_max4* F2_var4_MI_92
gen F2_Ind_MAX_Var5_92 = F2_max5* F2_var5_MI_92
gen F2_Ind_MAX_Var6_92 = F2_max6* F2_var6_MI_92
gen F2_Ind_MAX_Var7_92 = F2_max7* F2_var7_MI_92
gen F2_Ind_MAX_Var8_92 = F2_max8* F2_var8_MI_92
gen F2_Ind_MAX_Var9_92 = F2_max9* F2_var9_MI_92
gen F2_Ind_MAX_Var10_92 = F2_max10* F2_var10_MI_92
gen F2_Ind_MAX_Var11_92 = F2_max11* F2_var11_MI_92
gen F2_Ind_MAX_Var12_92 = F2_max12* F2_var12_MI_92
gen F2_Ind_MAX_Var13_92 = F2_max13* F2_var13_MI_92
gen F2_Ind_MAX_Var14_92 = F2_max14* F2_var14_MI_92
gen F2_Ind_MAX_Var15_92 = F2_max15* F2_var15_MI_92
gen F2_Ind_MAX_Var16_92 = F2_max16* F2_var16_MI_92
gen F2_Ind_MAX_Var17_92 = F2_max17* F2_var17_MI_92


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_92 = rowtotal(F2_Ind_MAX_Var1_92-F2_Ind_MAX_Var17_92)
egen Max_F2_92 = max(F2_Ind_Max_92)
gen Pct_Max2_92 = F2_Ind_Max_92/Max_F2_92

drop if Pct_Max1_92 <.8 & year>=1993 & year<=1996

/// Generating Individual Scores
egen F2_Score_92 = rowtotal(F2_var1_92-F2_var17_92)

*egen SD_F1_92 = sd(F1_Score_92)
*egen SD_F2_92 = sd(F2_Score_92)
*replace F1_Score_92 = F1_Score_92/SD_F1_92
*replace F2_Score_92 = F2_Score_92/SD_F2_92
*egen mean_F1_92 = mean(F1_Score_92)
*egen mean_F2_92 = mean(F2_Score_92)
*replace F1_Score_92 = F1_Score_92-mean_F1_92
*replace F2_Score_92 = F2_Score_92-mean_F2_92

*logit Pres_Vote F1_Score_92 F2_Score_92 if year>=1993 & year<=1996
*outreg2 using VoteChoice, append dec(2) 
*regress partyid F1_Score_92 F2_Score_92 if year>=1993 & year<=1996
*outreg2 using partisanship, append dec(2) 


/// Factor Analysis for 1996 Election

polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=1997 & year<=2000 [pw=wtssall], pw
display r(sum_w)
matrix poly1996 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly1996, n(2749) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_96 F2_96 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_96 = z_abany*-.0237
gen F1_var2_96 = z_abrape*-.076
gen F1_var3_96 = z_grass*.008
gen F1_var4_96 = z_bible*.009
gen F1_var5_96 = z_premarsx*-.026
gen F1_var6_96 = z_fefam*-.048
gen F1_var7_96 = z_homosex*-.067
gen F1_var8_96 = z_prayer*.024
gen F1_var9_96 = z_letdie1*-.048
gen F1_var10_96 = z_helppoor*.231
gen F1_var11_96 = z_helpnot*.177
gen F1_var12_96 = z_helpsick*.161
gen F1_var13_96 = z_helpblk*.229
gen F1_var14_96 = z_natfare*.11
gen F1_var15_96 = z_natrace*.147
gen F1_var16_96 = z_eqwlth*.134
gen F1_var17_96 = z_cappun*-.101


/// Generating Missing Responses 
gen F1_var1_MI_96 = 1 if F1_var1_96~=.
gen F1_var2_MI_96 = 1 if F1_var2_96~=.
gen F1_var3_MI_96 = 1 if F1_var3_96~=.
gen F1_var4_MI_96 = 1 if F1_var4_96~=.
gen F1_var5_MI_96 = 1 if F1_var5_96~=.
gen F1_var6_MI_96 = 1 if F1_var6_96~=.
gen F1_var7_MI_96 = 1 if F1_var7_96~=.
gen F1_var8_MI_96 = 1 if F1_var8_96~=.
gen F1_var9_MI_96 = 1 if F1_var9_96~=.
gen F1_var10_MI_96 = 1 if F1_var10_96~=.
gen F1_var11_MI_96 = 1 if F1_var11_96~=.
gen F1_var12_MI_96 = 1 if F1_var12_96~=.
gen F1_var13_MI_96 = 1 if F1_var13_96~=.
gen F1_var14_MI_96 = 1 if F1_var14_96~=.
gen F1_var15_MI_96 = 1 if F1_var15_96~=.
gen F1_var16_MI_96 = 1 if F1_var16_96~=.
gen F1_var17_MI_96 = 1 if F1_var17_96~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_96 = F1_max1* F1_var1_MI_96
gen F1_Ind_MAX_Var2_96 = F1_max2* F1_var2_MI_96
gen F1_Ind_MAX_Var3_96 = F1_max3* F1_var3_MI_96
gen F1_Ind_MAX_Var4_96 = F1_max4* F1_var4_MI_96
gen F1_Ind_MAX_Var5_96 = F1_max5* F1_var5_MI_96
gen F1_Ind_MAX_Var6_96 = F1_max6* F1_var6_MI_96
gen F1_Ind_MAX_Var7_96 = F1_max7* F1_var7_MI_96
gen F1_Ind_MAX_Var8_96 = F1_max8* F1_var8_MI_96
gen F1_Ind_MAX_Var9_96 = F1_max9* F1_var9_MI_96
gen F1_Ind_MAX_Var10_96 = F1_max10* F1_var10_MI_96
gen F1_Ind_MAX_Var11_96 = F1_max10* F1_var11_MI_96
gen F1_Ind_MAX_Var12_96 = F1_max12* F1_var12_MI_96
gen F1_Ind_MAX_Var13_96 = F1_max13* F1_var13_MI_96
gen F1_Ind_MAX_Var14_96 = F1_max14* F1_var14_MI_96
gen F1_Ind_MAX_Var15_96 = F1_max15* F1_var15_MI_96
gen F1_Ind_MAX_Var16_96 = F1_max16* F1_var16_MI_96
gen F1_Ind_MAX_Var17_96 = F1_max17* F1_var17_MI_96


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_96 = rowtotal(F1_Ind_MAX_Var1_96-F1_Ind_MAX_Var17_96)
egen Max_96 = max(F1_Ind_Max_96)
gen Pct_Max1_96 = F1_Ind_Max_96/Max_96

/// Generating Individual Scores
egen F1_Score_96 = rowtotal(F1_var1_96-F1_var17_96)

/// Dropping non-Respondents

egen totalresp_96 = rowtotal (F1_var1_MI_96-F1_var16_MI_96)
/// 
egen F1_max_96 = max(F1_Score_96)
egen F1_min_96 = min(F1_Score_96)


/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_96 = z_abany*.23
gen F2_var2_96 = z_abrape*.252
gen F2_var3_96 = z_grass*.084
gen F2_var4_96 = z_bible*-.109
gen F2_var5_96 = z_premarsx*-.144
gen F2_var6_96 = z_fefam*-.054
gen F2_var7_96 = z_homosex*-.171
gen F2_var8_96 = z_prayer*.054
gen F2_var9_96 = z_letdie1*.156
gen F2_var10_96 = z_helppoor*-.011
gen F2_var11_96 = z_helpnot*-.008
gen F2_var12_96 = z_helpsick*.006
gen F2_var13_96 = z_helpblk*-.009
gen F2_var14_96 = z_natfare*.003
gen F2_var15_96 = z_natrace*.002
gen F2_var16_96 = z_eqwlth*-.012
gen F2_var17_96 = z_cappun*.018


/// Generating Missing Responses 
gen F2_var1_MI_96 = 1 if F2_var1_96~=.
gen F2_var2_MI_96 = 1 if F2_var2_96~=.
gen F2_var3_MI_96 = 1 if F2_var3_96~=.
gen F2_var4_MI_96 = 1 if F2_var4_96~=.
gen F2_var5_MI_96 = 1 if F2_var5_96~=.
gen F2_var6_MI_96 = 1 if F2_var6_96~=.
gen F2_var7_MI_96 = 1 if F2_var7_96~=.
gen F2_var8_MI_96 = 1 if F2_var8_96~=.
gen F2_var9_MI_96 = 1 if F2_var9_96~=.
gen F2_var10_MI_96 = 1 if F2_var10_96~=.
gen F2_var11_MI_96 = 1 if F2_var11_96~=.
gen F2_var12_MI_96 = 1 if F2_var12_96~=.
gen F2_var13_MI_96 = 1 if F2_var13_96~=.
gen F2_var14_MI_96 = 1 if F2_var14_96~=.
gen F2_var15_MI_96 = 1 if F2_var15_96~=.
gen F2_var16_MI_96 = 1 if F2_var16_96~=.
gen F2_var17_MI_96 = 1 if F2_var17_96~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_96 = F2_max1* F2_var1_MI_96
gen F2_Ind_MAX_Var2_96 = F2_max2* F2_var2_MI_96
gen F2_Ind_MAX_Var3_96 = F2_max3* F2_var3_MI_96
gen F2_Ind_MAX_Var4_96 = F2_max4* F2_var4_MI_96
gen F2_Ind_MAX_Var5_96 = F2_max5* F2_var5_MI_96
gen F2_Ind_MAX_Var6_96 = F2_max6* F2_var6_MI_96
gen F2_Ind_MAX_Var7_96 = F2_max7* F2_var7_MI_96
gen F2_Ind_MAX_Var8_96 = F2_max8* F2_var8_MI_96
gen F2_Ind_MAX_Var9_96 = F2_max9* F2_var9_MI_96
gen F2_Ind_MAX_Var10_96 = F2_max10* F2_var10_MI_96
gen F2_Ind_MAX_Var11_96 = F2_max11* F2_var11_MI_96
gen F2_Ind_MAX_Var12_96 = F2_max12* F2_var12_MI_96
gen F2_Ind_MAX_Var13_96 = F2_max13* F2_var13_MI_96
gen F2_Ind_MAX_Var14_96 = F2_max14* F2_var14_MI_96
gen F2_Ind_MAX_Var15_96 = F2_max15* F2_var15_MI_96
gen F2_Ind_MAX_Var16_96 = F2_max16* F2_var16_MI_96
gen F2_Ind_MAX_Var17_96 = F2_max17* F2_var17_MI_96


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_96 = rowtotal(F2_Ind_MAX_Var1_96-F2_Ind_MAX_Var17_96)
egen Max_F2_96 = max(F2_Ind_Max_96)
gen Pct_Max2_96 = F2_Ind_Max_96/Max_F2_96

/// Generating Individual Scores
egen F2_Score_96 = rowtotal(F2_var1_96-F2_var17_96)

drop if Pct_Max1_96 <.8 & year>=1997 & year<=2000


*egen SD_F1_96 = sd(F1_Score_96)
*egen SD_F2_96 = sd(F2_Score_96)
*replace F1_Score_96 = F1_Score_96/SD_F1_96
*replace F2_Score_96 = F2_Score_96/SD_F2_96
*egen mean_F1_96 = mean(F1_Score_96)
*egen mean_F2_96 = mean(F2_Score_96)
*replace F1_Score_96 = F1_Score_96-mean_F1_96
*replace F2_Score_96 = F2_Score_96-mean_F2_96

*logit Pres_Vote F1_Score_96 F2_Score_96 if year>=1997 & year<=2000
*outreg2 using VoteChoice, append dec(2) 
*regress partyid F1_Score_96 F2_Score_96 if year>=1997 & year<=2000
*outreg2 using partisanship, append dec(2) 


/// Factor Analysis for 2000 Election

polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=2001 & year<=2004 [pw=wtssall], pw
display r(sum_w)
matrix poly2000 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly2000, n(1653) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_00 F2_00 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_00 = z_abany*-.014
gen F1_var2_00 = z_abrape*-.050
gen F1_var3_00 = z_grass*.011
gen F1_var4_00 = z_bible*.013
gen F1_var5_00 = z_premarsx*-.009
gen F1_var6_00 = z_fefam*-.026
gen F1_var7_00 = z_homosex*-.023
gen F1_var8_00 = z_prayer*.005
gen F1_var9_00 = z_letdie1*-.023
gen F1_var10_00 = z_helppoor*.305
gen F1_var11_00 = z_helpnot*.190
gen F1_var12_00 = z_helpsick*.164
gen F1_var13_00 = z_helpblk*.172
gen F1_var14_00 = z_natfare*.118
gen F1_var15_00 = z_natrace*.115
gen F1_var16_00 = z_eqwlth*.187
gen F1_var17_00 = z_cappun*-.093


/// Generating Missing Responses 
gen F1_var1_MI_00 = 1 if F1_var1_00~=.
gen F1_var2_MI_00 = 1 if F1_var2_00~=.
gen F1_var3_MI_00 = 1 if F1_var3_00~=.
gen F1_var4_MI_00 = 1 if F1_var4_00~=.
gen F1_var5_MI_00 = 1 if F1_var5_00~=.
gen F1_var6_MI_00 = 1 if F1_var6_00~=.
gen F1_var7_MI_00 = 1 if F1_var7_00~=.
gen F1_var8_MI_00 = 1 if F1_var8_00~=.
gen F1_var9_MI_00 = 1 if F1_var9_00~=.
gen F1_var10_MI_00 = 1 if F1_var10_00~=.
gen F1_var11_MI_00 = 1 if F1_var11_00~=.
gen F1_var12_MI_00 = 1 if F1_var12_00~=.
gen F1_var13_MI_00 = 1 if F1_var13_00~=.
gen F1_var14_MI_00 = 1 if F1_var14_00~=.
gen F1_var15_MI_00 = 1 if F1_var15_00~=.
gen F1_var16_MI_00 = 1 if F1_var16_00~=.
gen F1_var17_MI_00 = 1 if F1_var17_00~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_00 = F1_max1* F1_var1_MI_00
gen F1_Ind_MAX_Var2_00 = F1_max2* F1_var2_MI_00
gen F1_Ind_MAX_Var3_00 = F1_max3* F1_var3_MI_00
gen F1_Ind_MAX_Var4_00 = F1_max4* F1_var4_MI_00
gen F1_Ind_MAX_Var5_00 = F1_max5* F1_var5_MI_00
gen F1_Ind_MAX_Var6_00 = F1_max6* F1_var6_MI_00
gen F1_Ind_MAX_Var7_00 = F1_max7* F1_var7_MI_00
gen F1_Ind_MAX_Var8_00 = F1_max8* F1_var8_MI_00
gen F1_Ind_MAX_Var9_00 = F1_max9* F1_var9_MI_00
gen F1_Ind_MAX_Var10_00 = F1_max10* F1_var10_MI_00
gen F1_Ind_MAX_Var11_00 = F1_max10* F1_var11_MI_00
gen F1_Ind_MAX_Var12_00 = F1_max12* F1_var12_MI_00
gen F1_Ind_MAX_Var13_00 = F1_max13* F1_var13_MI_00
gen F1_Ind_MAX_Var14_00 = F1_max14* F1_var14_MI_00
gen F1_Ind_MAX_Var15_00 = F1_max15* F1_var15_MI_00
gen F1_Ind_MAX_Var16_00 = F1_max16* F1_var16_MI_00
gen F1_Ind_MAX_Var17_00 = F1_max17* F1_var17_MI_00


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_00 = rowtotal(F1_Ind_MAX_Var1_00-F1_Ind_MAX_Var17_00)
egen Max_00 = max(F1_Ind_Max_00)
gen Pct_Max1_00 = F1_Ind_Max_00/Max_00

/// Generating Individual Scores
egen F1_Score_00 = rowtotal(F1_var1_00-F1_var17_00)

/// Dropping non-Respondents

egen totalresp_00 = rowtotal (F1_var1_MI_00-F1_var16_MI_00)
/// 
egen F1_max_00 = max(F1_Score_00)
egen F1_min_00 = min(F1_Score_00)


/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_00 = z_abany*.455
gen F2_var2_00 = z_abrape*.336
gen F2_var3_00 = z_grass*.046
gen F2_var4_00 = z_bible*-.065
gen F2_var5_00 = z_premarsx*-.057
gen F2_var6_00 = z_fefam*-.035
gen F2_var7_00 = z_homosex*-.080
gen F2_var8_00 = z_prayer*.044
gen F2_var9_00 = z_letdie1*.058
gen F2_var10_00 = z_helppoor*-.011
gen F2_var11_00 = z_helpnot*-.012
gen F2_var12_00 = z_helpsick*.002
gen F2_var13_00 = z_helpblk*-.005
gen F2_var14_00 = z_natfare*-.006
gen F2_var15_00 = z_natrace*.002
gen F2_var16_00 = z_eqwlth*-.006
gen F2_var17_00 = z_cappun*.009


/// Generating Missing Responses 
gen F2_var1_MI_00 = 1 if F2_var1_00~=.
gen F2_var2_MI_00 = 1 if F2_var2_00~=.
gen F2_var3_MI_00 = 1 if F2_var3_00~=.
gen F2_var4_MI_00 = 1 if F2_var4_00~=.
gen F2_var5_MI_00 = 1 if F2_var5_00~=.
gen F2_var6_MI_00 = 1 if F2_var6_00~=.
gen F2_var7_MI_00 = 1 if F2_var7_00~=.
gen F2_var8_MI_00 = 1 if F2_var8_00~=.
gen F2_var9_MI_00 = 1 if F2_var9_00~=.
gen F2_var10_MI_00 = 1 if F2_var10_00~=.
gen F2_var11_MI_00 = 1 if F2_var11_00~=.
gen F2_var12_MI_00 = 1 if F2_var12_00~=.
gen F2_var13_MI_00 = 1 if F2_var13_00~=.
gen F2_var14_MI_00 = 1 if F2_var14_00~=.
gen F2_var15_MI_00 = 1 if F2_var15_00~=.
gen F2_var16_MI_00 = 1 if F2_var16_00~=.
gen F2_var17_MI_00 = 1 if F2_var17_00~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_00 = F2_max1* F2_var1_MI_00
gen F2_Ind_MAX_Var2_00 = F2_max2* F2_var2_MI_00
gen F2_Ind_MAX_Var3_00 = F2_max3* F2_var3_MI_00
gen F2_Ind_MAX_Var4_00 = F2_max4* F2_var4_MI_00
gen F2_Ind_MAX_Var5_00 = F2_max5* F2_var5_MI_00
gen F2_Ind_MAX_Var6_00 = F2_max6* F2_var6_MI_00
gen F2_Ind_MAX_Var7_00 = F2_max7* F2_var7_MI_00
gen F2_Ind_MAX_Var8_00 = F2_max8* F2_var8_MI_00
gen F2_Ind_MAX_Var9_00 = F2_max9* F2_var9_MI_00
gen F2_Ind_MAX_Var10_00 = F2_max10* F2_var10_MI_00
gen F2_Ind_MAX_Var11_00 = F2_max11* F2_var11_MI_00
gen F2_Ind_MAX_Var12_00 = F2_max12* F2_var12_MI_00
gen F2_Ind_MAX_Var13_00 = F2_max13* F2_var13_MI_00
gen F2_Ind_MAX_Var14_00 = F2_max14* F2_var14_MI_00
gen F2_Ind_MAX_Var15_00 = F2_max15* F2_var15_MI_00
gen F2_Ind_MAX_Var16_00 = F2_max16* F2_var16_MI_00
gen F2_Ind_MAX_Var17_00 = F2_max17* F2_var17_MI_00


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_00 = rowtotal(F2_Ind_MAX_Var1_00-F2_Ind_MAX_Var17_00)
egen Max_F2_00 = max(F2_Ind_Max_00)
gen Pct_Max2_00 = F2_Ind_Max_00/Max_F2_00

/// Generating Individual Scores
egen F2_Score_00 = rowtotal(F2_var1_00-F2_var17_00)

drop if Pct_Max1_00 <.8 & year>=2001 & year<=2004


*egen SD_F1_00 = sd(F1_Score_00)
*egen SD_F2_00 = sd(F2_Score_00)
*replace F1_Score_00 = F1_Score_00/SD_F1_00
*replace F2_Score_00 = F2_Score_00/SD_F2_00
*egen mean_F1_00 = mean(F1_Score_00)
*egen mean_F2_00 = mean(F2_Score_00)
*replace F1_Score_00 = F1_Score_00-mean_F1_00
*replace F2_Score_00 = F2_Score_00-mean_F2_00

*logit Pres_Vote F1_Score_00 F2_Score_00 if year>=2001 & year<=2004
*outreg2 using VoteChoice, append dec(2) 
*regress partyid F1_Score_00 F2_Score_00 if year>=2001 & year<=2004
*outreg2 using partisanship, append dec(2) 

/// Factor Analysis for 2004 Election


polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=2005 & year<=2008 [pw=wtssall], pw
display r(sum_w)
matrix poly2004 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly2004, n(2864) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_04 F2_04 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_04 = z_abany*-.008
gen F1_var2_04 = z_abrape*-.053
gen F1_var3_04 = z_grass*.020
gen F1_var4_04 = z_bible*.038
gen F1_var5_04 = z_premarsx*-.009
gen F1_var6_04 = z_fefam*-.021
gen F1_var7_04 = z_homosex*-.037
gen F1_var8_04 = z_prayer*.008
gen F1_var9_04 = z_letdie1*-.005
gen F1_var10_04 = z_helppoor*.282
gen F1_var11_04 = z_helpnot*.168
gen F1_var12_04 = z_helpsick*.192
gen F1_var13_04 = z_helpblk*.195
gen F1_var14_04 = z_natfare*.117
gen F1_var15_04 = z_natrace*.112
gen F1_var16_04 = z_eqwlth*.152
gen F1_var17_04 = z_cappun*-.081


/// Generating Missing Responses 
gen F1_var1_MI_04 = 1 if F1_var1_04~=.
gen F1_var2_MI_04 = 1 if F1_var2_04~=.
gen F1_var3_MI_04 = 1 if F1_var3_04~=.
gen F1_var4_MI_04 = 1 if F1_var4_04~=.
gen F1_var5_MI_04 = 1 if F1_var5_04~=.
gen F1_var6_MI_04 = 1 if F1_var6_04~=.
gen F1_var7_MI_04 = 1 if F1_var7_04~=.
gen F1_var8_MI_04 = 1 if F1_var8_04~=.
gen F1_var9_MI_04 = 1 if F1_var9_04~=.
gen F1_var10_MI_04 = 1 if F1_var10_04~=.
gen F1_var11_MI_04 = 1 if F1_var11_04~=.
gen F1_var12_MI_04 = 1 if F1_var12_04~=.
gen F1_var13_MI_04 = 1 if F1_var13_04~=.
gen F1_var14_MI_04 = 1 if F1_var14_04~=.
gen F1_var15_MI_04 = 1 if F1_var15_04~=.
gen F1_var16_MI_04 = 1 if F1_var16_04~=.
gen F1_var17_MI_04 = 1 if F1_var17_04~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_04 = F1_max1* F1_var1_MI_04
gen F1_Ind_MAX_Var2_04 = F1_max2* F1_var2_MI_04
gen F1_Ind_MAX_Var3_04 = F1_max3* F1_var3_MI_04
gen F1_Ind_MAX_Var4_04 = F1_max4* F1_var4_MI_04
gen F1_Ind_MAX_Var5_04 = F1_max5* F1_var5_MI_04
gen F1_Ind_MAX_Var6_04 = F1_max6* F1_var6_MI_04
gen F1_Ind_MAX_Var7_04 = F1_max7* F1_var7_MI_04
gen F1_Ind_MAX_Var8_04 = F1_max8* F1_var8_MI_04
gen F1_Ind_MAX_Var9_04 = F1_max9* F1_var9_MI_04
gen F1_Ind_MAX_Var10_04 = F1_max10* F1_var10_MI_04
gen F1_Ind_MAX_Var11_04 = F1_max10* F1_var11_MI_04
gen F1_Ind_MAX_Var12_04 = F1_max12* F1_var12_MI_04
gen F1_Ind_MAX_Var13_04 = F1_max13* F1_var13_MI_04
gen F1_Ind_MAX_Var14_04 = F1_max14* F1_var14_MI_04
gen F1_Ind_MAX_Var15_04 = F1_max15* F1_var15_MI_04
gen F1_Ind_MAX_Var16_04 = F1_max16* F1_var16_MI_04
gen F1_Ind_MAX_Var17_04 = F1_max17* F1_var17_MI_04


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_04 = rowtotal(F1_Ind_MAX_Var1_04-F1_Ind_MAX_Var17_04)
egen Max_04 = max(F1_Ind_Max_04)
gen Pct_Max1_04 = F1_Ind_Max_04/Max_04

/// Generating Individual Scores
egen F1_Score_04 = rowtotal(F1_var1_04-F1_var17_04)

/// Dropping non-Respondents

egen totalresp_04 = rowtotal (F1_var1_MI_04-F1_var16_MI_04)
/// 
egen F1_max_04 = max(F1_Score_04)
egen F1_min_04 = min(F1_Score_04)


/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_04 = z_abany*.244
gen F2_var2_04 = z_abrape*.267
gen F2_var3_04 = z_grass*.066
gen F2_var4_04 = z_bible*-.11
gen F2_var5_04 = z_premarsx*-.131
gen F2_var6_04 = z_fefam*-.057
gen F2_var7_04 = z_homosex*-.172
gen F2_var8_04 = z_prayer*.068
gen F2_var9_04 = z_letdie1*.133
gen F2_var10_04 = z_helppoor*-.012
gen F2_var11_04 = z_helpnot*-.014
gen F2_var12_04 = z_helpsick*.004
gen F2_var13_04 = z_helpblk*-.008
gen F2_var14_04 = z_natfare*-.007
gen F2_var15_04 = z_natrace*.006
gen F2_var16_04 = z_eqwlth*-.010
gen F2_var17_04 = z_cappun*.012


/// Generating Missing Responses 
gen F2_var1_MI_04 = 1 if F2_var1_04~=.
gen F2_var2_MI_04 = 1 if F2_var2_04~=.
gen F2_var3_MI_04 = 1 if F2_var3_04~=.
gen F2_var4_MI_04 = 1 if F2_var4_04~=.
gen F2_var5_MI_04 = 1 if F2_var5_04~=.
gen F2_var6_MI_04 = 1 if F2_var6_04~=.
gen F2_var7_MI_04 = 1 if F2_var7_04~=.
gen F2_var8_MI_04 = 1 if F2_var8_04~=.
gen F2_var9_MI_04 = 1 if F2_var9_04~=.
gen F2_var10_MI_04 = 1 if F2_var10_04~=.
gen F2_var11_MI_04 = 1 if F2_var11_04~=.
gen F2_var12_MI_04 = 1 if F2_var12_04~=.
gen F2_var13_MI_04 = 1 if F2_var13_04~=.
gen F2_var14_MI_04 = 1 if F2_var14_04~=.
gen F2_var15_MI_04 = 1 if F2_var15_04~=.
gen F2_var16_MI_04 = 1 if F2_var16_04~=.
gen F2_var17_MI_04 = 1 if F2_var17_04~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_04 = F2_max1* F2_var1_MI_04
gen F2_Ind_MAX_Var2_04 = F2_max2* F2_var2_MI_04
gen F2_Ind_MAX_Var3_04 = F2_max3* F2_var3_MI_04
gen F2_Ind_MAX_Var4_04 = F2_max4* F2_var4_MI_04
gen F2_Ind_MAX_Var5_04 = F2_max5* F2_var5_MI_04
gen F2_Ind_MAX_Var6_04 = F2_max6* F2_var6_MI_04
gen F2_Ind_MAX_Var7_04 = F2_max7* F2_var7_MI_04
gen F2_Ind_MAX_Var8_04 = F2_max8* F2_var8_MI_04
gen F2_Ind_MAX_Var9_04 = F2_max9* F2_var9_MI_04
gen F2_Ind_MAX_Var10_04 = F2_max10* F2_var10_MI_04
gen F2_Ind_MAX_Var11_04 = F2_max11* F2_var11_MI_04
gen F2_Ind_MAX_Var12_04 = F2_max12* F2_var12_MI_04
gen F2_Ind_MAX_Var13_04 = F2_max13* F2_var13_MI_04
gen F2_Ind_MAX_Var14_04 = F2_max14* F2_var14_MI_04
gen F2_Ind_MAX_Var15_04 = F2_max15* F2_var15_MI_04
gen F2_Ind_MAX_Var16_04 = F2_max16* F2_var16_MI_04
gen F2_Ind_MAX_Var17_04 = F2_max17* F2_var17_MI_04


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_04 = rowtotal(F2_Ind_MAX_Var1_04-F2_Ind_MAX_Var17_04)
egen Max_F2_04 = max(F2_Ind_Max_04)
gen Pct_Max2_04 = F2_Ind_Max_04/Max_F2_04

/// Generating Individual Scores
egen F2_Score_04 = rowtotal(F2_var1_04-F2_var17_04)

drop if Pct_Max1_04 <.8 & year>=2005 & year<=2008


*egen SD_F1_04 = sd(F1_Score_04)
*egen SD_F2_04 = sd(F2_Score_04)
*replace F1_Score_04 = F1_Score_04/SD_F1_04
*replace F2_Score_04 = F2_Score_04/SD_F2_04
*egen mean_F1_04 = mean(F1_Score_04)
*egen mean_F2_04 = mean(F2_Score_04)
*replace F1_Score_04 = F1_Score_04-mean_F1_04
*replace F2_Score_04 = F2_Score_04-mean_F2_04

*logit Pres_Vote F1_Score_04 F2_Score_04 if year>=2005 & year<=2008
*outreg2 using VoteChoice, append dec(2) 
*regress partyid F1_Score_04 F2_Score_04 if year>=2005 & year<=2008
*outreg2 using partisanship, append dec(2) 

/// Factor Analysis for 2008 Election

polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=2009 & year<=2012 [pw=wtssall], pw
display r(sum_w)
matrix poly2008 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly2008, n(2332) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_08 F2_08 

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_08 = z_abany*-.007
gen F1_var2_08 = z_abrape*-.038
gen F1_var3_08 = z_grass*.015
gen F1_var4_08 = z_bible*.017
gen F1_var5_08 = z_premarsx*-.003
gen F1_var6_08 = z_fefam*-.014
gen F1_var7_08 = z_homosex*-.015
gen F1_var8_08 = z_prayer*.001
gen F1_var9_08 = z_letdie1*-.030
gen F1_var10_08 = z_helppoor*.254
gen F1_var11_08 = z_helpnot*.216
gen F1_var12_08 = z_helpsick*.211
gen F1_var13_08 = z_helpblk*.151
gen F1_var14_08 = z_natfare*.112
gen F1_var15_08 = z_natrace*.107
gen F1_var16_08 = z_eqwlth*.144
gen F1_var17_08 = z_cappun*-.068


/// Generating Missing Responses 
gen F1_var1_MI_08 = 1 if F1_var1_08~=.
gen F1_var2_MI_08 = 1 if F1_var2_08~=.
gen F1_var3_MI_08 = 1 if F1_var3_08~=.
gen F1_var4_MI_08 = 1 if F1_var4_08~=.
gen F1_var5_MI_08 = 1 if F1_var5_08~=.
gen F1_var6_MI_08 = 1 if F1_var6_08~=.
gen F1_var7_MI_08 = 1 if F1_var7_08~=.
gen F1_var8_MI_08 = 1 if F1_var8_08~=.
gen F1_var9_MI_08 = 1 if F1_var9_08~=.
gen F1_var10_MI_08 = 1 if F1_var10_08~=.
gen F1_var11_MI_08 = 1 if F1_var11_08~=.
gen F1_var12_MI_08 = 1 if F1_var12_08~=.
gen F1_var13_MI_08 = 1 if F1_var13_08~=.
gen F1_var14_MI_08 = 1 if F1_var14_08~=.
gen F1_var15_MI_08 = 1 if F1_var15_08~=.
gen F1_var16_MI_08 = 1 if F1_var16_08~=.
gen F1_var17_MI_08 = 1 if F1_var17_08~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_08 = F1_max1* F1_var1_MI_08
gen F1_Ind_MAX_Var2_08 = F1_max2* F1_var2_MI_08
gen F1_Ind_MAX_Var3_08 = F1_max3* F1_var3_MI_08
gen F1_Ind_MAX_Var4_08 = F1_max4* F1_var4_MI_08
gen F1_Ind_MAX_Var5_08 = F1_max5* F1_var5_MI_08
gen F1_Ind_MAX_Var6_08 = F1_max6* F1_var6_MI_08
gen F1_Ind_MAX_Var7_08 = F1_max7* F1_var7_MI_08
gen F1_Ind_MAX_Var8_08 = F1_max8* F1_var8_MI_08
gen F1_Ind_MAX_Var9_08 = F1_max9* F1_var9_MI_08
gen F1_Ind_MAX_Var10_08 = F1_max10* F1_var10_MI_08
gen F1_Ind_MAX_Var11_08 = F1_max10* F1_var11_MI_08
gen F1_Ind_MAX_Var12_08 = F1_max12* F1_var12_MI_08
gen F1_Ind_MAX_Var13_08 = F1_max13* F1_var13_MI_08
gen F1_Ind_MAX_Var14_08 = F1_max14* F1_var14_MI_08
gen F1_Ind_MAX_Var15_08 = F1_max15* F1_var15_MI_08
gen F1_Ind_MAX_Var16_08 = F1_max16* F1_var16_MI_08
gen F1_Ind_MAX_Var17_08 = F1_max17* F1_var17_MI_08


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_08 = rowtotal(F1_Ind_MAX_Var1_08-F1_Ind_MAX_Var17_08)
egen Max_08 = max(F1_Ind_Max_08)
gen Pct_Max1_08 = F1_Ind_Max_08/Max_08

/// Generating Individual Scores
egen F1_Score_08 = rowtotal(F1_var1_08-F1_var17_08)

/// Dropping non-Respondents

egen totalresp_08 = rowtotal (F1_var1_MI_08-F1_var16_MI_08)
/// 
egen F1_max_08 = max(F1_Score_08)
egen F1_min_08 = min(F1_Score_08)

/// creatining Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_08 = z_abany*.172
gen F2_var2_08 = z_abrape*.256
gen F2_var3_08 = z_grass*.087
gen F2_var4_08 = z_bible*-.088
gen F2_var5_08 = z_premarsx*-.189
gen F2_var6_08 = z_fefam*-.050
gen F2_var7_08 = z_homosex*-.170
gen F2_var8_08 = z_prayer*.060
gen F2_var9_08 = z_letdie1*.161
gen F2_var10_08 = z_helppoor*-.016
gen F2_var11_08 = z_helpnot*-.011
gen F2_var12_08 = z_helpsick*.002
gen F2_var13_08 = z_helpblk*-.014
gen F2_var14_08 = z_natfare*-.004
gen F2_var15_08 = z_natrace*-.008
gen F2_var16_08 = z_eqwlth*-.001
gen F2_var17_08 = z_cappun*.016


/// Generating Missing Responses 
gen F2_var1_MI_08 = 1 if F2_var1_08~=.
gen F2_var2_MI_08 = 1 if F2_var2_08~=.
gen F2_var3_MI_08 = 1 if F2_var3_08~=.
gen F2_var4_MI_08 = 1 if F2_var4_08~=.
gen F2_var5_MI_08 = 1 if F2_var5_08~=.
gen F2_var6_MI_08 = 1 if F2_var6_08~=.
gen F2_var7_MI_08 = 1 if F2_var7_08~=.
gen F2_var8_MI_08 = 1 if F2_var8_08~=.
gen F2_var9_MI_08 = 1 if F2_var9_08~=.
gen F2_var10_MI_08 = 1 if F2_var10_08~=.
gen F2_var11_MI_08 = 1 if F2_var11_08~=.
gen F2_var12_MI_08 = 1 if F2_var12_08~=.
gen F2_var13_MI_08 = 1 if F2_var13_08~=.
gen F2_var14_MI_08 = 1 if F2_var14_08~=.
gen F2_var15_MI_08 = 1 if F2_var15_08~=.
gen F2_var16_MI_08 = 1 if F2_var16_08~=.
gen F2_var17_MI_08 = 1 if F2_var17_08~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_08 = F2_max1* F2_var1_MI_08
gen F2_Ind_MAX_Var2_08 = F2_max2* F2_var2_MI_08
gen F2_Ind_MAX_Var3_08 = F2_max3* F2_var3_MI_08
gen F2_Ind_MAX_Var4_08 = F2_max4* F2_var4_MI_08
gen F2_Ind_MAX_Var5_08 = F2_max5* F2_var5_MI_08
gen F2_Ind_MAX_Var6_08 = F2_max6* F2_var6_MI_08
gen F2_Ind_MAX_Var7_08 = F2_max7* F2_var7_MI_08
gen F2_Ind_MAX_Var8_08 = F2_max8* F2_var8_MI_08
gen F2_Ind_MAX_Var9_08 = F2_max9* F2_var9_MI_08
gen F2_Ind_MAX_Var10_08 = F2_max10* F2_var10_MI_08
gen F2_Ind_MAX_Var11_08 = F2_max11* F2_var11_MI_08
gen F2_Ind_MAX_Var12_08 = F2_max12* F2_var12_MI_08
gen F2_Ind_MAX_Var13_08 = F2_max13* F2_var13_MI_08
gen F2_Ind_MAX_Var14_08 = F2_max14* F2_var14_MI_08
gen F2_Ind_MAX_Var15_08 = F2_max15* F2_var15_MI_08
gen F2_Ind_MAX_Var16_08 = F2_max16* F2_var16_MI_08
gen F2_Ind_MAX_Var17_08 = F2_max17* F2_var17_MI_08


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_08 = rowtotal(F2_Ind_MAX_Var1_08-F2_Ind_MAX_Var17_08)
egen Max_F2_08 = max(F2_Ind_Max_08)
gen Pct_Max2_08 = F2_Ind_Max_08/Max_F2_08

/// Generating Individual Scores
egen F2_Score_08 = rowtotal(F2_var1_08-F2_var17_08)

drop if Pct_Max1_08 <.8 & year>=2009 & year<=2012


*egen SD_F1_08 = sd(F1_Score_08)
*egen SD_F2_08 = sd(F2_Score_08)
*replace F1_Score_08 = F1_Score_08/SD_F1_08
*replace F2_Score_08 = F2_Score_08/SD_F2_08
*egen mean_F1_08 = mean(F1_Score_08)
*egen mean_F2_08 = mean(F2_Score_08)
*replace F1_Score_08 = F1_Score_08-mean_F1_08
*replace F2_Score_08 = F2_Score_08-mean_F2_08

*logit Pres_Vote F1_Score_08 F2_Score_08 if year>=2009 & year<=2012
*outreg2 using VoteChoice, append dec(2) 
*regress partyid F1_Score_08 F2_Score_08 if year>=2009 & year<=2012
*outreg2 using partisanship, append dec(2) 

/// Factor Analysis for 2012 Election

polychoric abany abrape grass bible premarsx fefam homosex prayer letdie1 helppoor-helpblk natfare natrace eqwlth cappun if year>=2013 [pw=wtssall], pw
display r(sum_w)
matrix poly2012 = r(R)
matrix target = ( 1,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,1 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0 \ 0,0)
factormat poly2012, n(1453) factors(2) blanks(.4) ml
rotate, target(target)
predict F1_12 F2_12

/// Creating Individual Factor Coef. Scores for the First Dimension
gen F1_var1_12 = z_abany*-.001
gen F1_var2_12 = z_abrape*-.046
gen F1_var3_12 = z_grass*.005
gen F1_var4_12 = z_bible*.018
gen F1_var5_12 = z_premarsx*-.011
gen F1_var6_12 = z_fefam*-.001
gen F1_var7_12 = z_homosex*.024
gen F1_var8_12 = z_prayer*.003
gen F1_var9_12 = z_letdie1*-.024
gen F1_var10_12 = z_helppoor*.239
gen F1_var11_12 = z_helpnot*.228
gen F1_var12_12 = z_helpsick*.201
gen F1_var13_12 = z_helpblk*.151
gen F1_var14_12 = z_natfare*.141
gen F1_var15_12 = z_natrace*.090
gen F1_var16_12 = z_eqwlth*.146
gen F1_var17_12 = z_cappun*-.075


/// Generating Missing Responses 
gen F1_var1_MI_12 = 1 if F1_var1_12~=.
gen F1_var2_MI_12 = 1 if F1_var2_12~=.
gen F1_var3_MI_12 = 1 if F1_var3_12~=.
gen F1_var4_MI_12 = 1 if F1_var4_12~=.
gen F1_var5_MI_12 = 1 if F1_var5_12~=.
gen F1_var6_MI_12 = 1 if F1_var6_12~=.
gen F1_var7_MI_12 = 1 if F1_var7_12~=.
gen F1_var8_MI_12 = 1 if F1_var8_12~=.
gen F1_var9_MI_12 = 1 if F1_var9_12~=.
gen F1_var10_MI_12 = 1 if F1_var10_12~=.
gen F1_var11_MI_12 = 1 if F1_var11_12~=.
gen F1_var12_MI_12 = 1 if F1_var12_12~=.
gen F1_var13_MI_12 = 1 if F1_var13_12~=.
gen F1_var14_MI_12 = 1 if F1_var14_12~=.
gen F1_var15_MI_12 = 1 if F1_var15_12~=.
gen F1_var16_MI_12 = 1 if F1_var16_12~=.
gen F1_var17_MI_12 = 1 if F1_var17_12~=.

/// Generating Individual Maximimum Possible 
gen F1_Ind_MAX_Var1_12 = F1_max1* F1_var1_MI_12
gen F1_Ind_MAX_Var2_12 = F1_max2* F1_var2_MI_12
gen F1_Ind_MAX_Var3_12 = F1_max3* F1_var3_MI_12
gen F1_Ind_MAX_Var4_12 = F1_max4* F1_var4_MI_12
gen F1_Ind_MAX_Var5_12 = F1_max5* F1_var5_MI_12
gen F1_Ind_MAX_Var6_12 = F1_max6* F1_var6_MI_12
gen F1_Ind_MAX_Var7_12 = F1_max7* F1_var7_MI_12
gen F1_Ind_MAX_Var8_12 = F1_max8* F1_var8_MI_12
gen F1_Ind_MAX_Var9_12 = F1_max9* F1_var9_MI_12
gen F1_Ind_MAX_Var10_12 = F1_max10* F1_var10_MI_12
gen F1_Ind_MAX_Var11_12 = F1_max10* F1_var11_MI_12
gen F1_Ind_MAX_Var12_12 = F1_max12* F1_var12_MI_12
gen F1_Ind_MAX_Var13_12 = F1_max13* F1_var13_MI_12
gen F1_Ind_MAX_Var14_12 = F1_max14* F1_var14_MI_12
gen F1_Ind_MAX_Var15_12 = F1_max15* F1_var15_MI_12
gen F1_Ind_MAX_Var16_12 = F1_max16* F1_var16_MI_12
gen F1_Ind_MAX_Var17_12 = F1_max17* F1_var17_MI_12


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F1_Ind_Max_12 = rowtotal(F1_Ind_MAX_Var1_12-F1_Ind_MAX_Var17_12)
egen Max_12 = max(F1_Ind_Max_12)
gen Pct_Max1_12 = F1_Ind_Max_12/Max_12

/// Generating Individual Scores
egen F1_Score_12 = rowtotal(F1_var1_12-F1_var17_12)

/// Dropping non-Respondents

egen totalresp_12 = rowtotal (F1_var1_MI_12-F1_var16_MI_12)
/// 
egen F1_max_12 = max(F1_Score_12)
egen F1_min_12 = min(F1_Score_12)


/// Creating Individual Factor Coef. Scores for the Second Dimension
gen F2_var1_12 = z_abany*.190
gen F2_var2_12 = z_abrape*.180
gen F2_var3_12 = z_grass*.099
gen F2_var4_12 = z_bible*-.131
gen F2_var5_12 = z_premarsx*-.174
gen F2_var6_12 = z_fefam*-.062
gen F2_var7_12 = z_homosex*-.258
gen F2_var8_12 = z_prayer*.069
gen F2_var9_12 = z_letdie1*.113
gen F2_var10_12 = z_helppoor*-.035
gen F2_var11_12 = z_helpnot*-.021
gen F2_var12_12 = z_helpsick*-.010
gen F2_var13_12 = z_helpblk*-.011
gen F2_var14_12 = z_natfare*-.007
gen F2_var15_12 = z_natrace*-.016
gen F2_var16_12 = z_eqwlth*-.018
gen F2_var17_12 = z_cappun*.022


/// Generating Missing Responses 
gen F2_var1_MI_12 = 1 if F2_var1_12~=.
gen F2_var2_MI_12 = 1 if F2_var2_12~=.
gen F2_var3_MI_12 = 1 if F2_var3_12~=.
gen F2_var4_MI_12 = 1 if F2_var4_12~=.
gen F2_var5_MI_12 = 1 if F2_var5_12~=.
gen F2_var6_MI_12 = 1 if F2_var6_12~=.
gen F2_var7_MI_12 = 1 if F2_var7_12~=.
gen F2_var8_MI_12 = 1 if F2_var8_12~=.
gen F2_var9_MI_12 = 1 if F2_var9_12~=.
gen F2_var10_MI_12 = 1 if F2_var10_12~=.
gen F2_var11_MI_12 = 1 if F2_var11_12~=.
gen F2_var12_MI_12 = 1 if F2_var12_12~=.
gen F2_var13_MI_12 = 1 if F2_var13_12~=.
gen F2_var14_MI_12 = 1 if F2_var14_12~=.
gen F2_var15_MI_12 = 1 if F2_var15_12~=.
gen F2_var16_MI_12 = 1 if F2_var16_12~=.
gen F2_var17_MI_12 = 1 if F2_var17_12~=.

/// Generating Individual Maximimum Possible 
gen F2_Ind_MAX_Var1_12 = F2_max1* F2_var1_MI_12
gen F2_Ind_MAX_Var2_12 = F2_max2* F2_var2_MI_12
gen F2_Ind_MAX_Var3_12 = F2_max3* F2_var3_MI_12
gen F2_Ind_MAX_Var4_12 = F2_max4* F2_var4_MI_12
gen F2_Ind_MAX_Var5_12 = F2_max5* F2_var5_MI_12
gen F2_Ind_MAX_Var6_12 = F2_max6* F2_var6_MI_12
gen F2_Ind_MAX_Var7_12 = F2_max7* F2_var7_MI_12
gen F2_Ind_MAX_Var8_12 = F2_max8* F2_var8_MI_12
gen F2_Ind_MAX_Var9_12 = F2_max9* F2_var9_MI_12
gen F2_Ind_MAX_Var10_12 = F2_max10* F2_var10_MI_12
gen F2_Ind_MAX_Var11_12 = F2_max11* F2_var11_MI_12
gen F2_Ind_MAX_Var12_12 = F2_max12* F2_var12_MI_12
gen F2_Ind_MAX_Var13_12 = F2_max13* F2_var13_MI_12
gen F2_Ind_MAX_Var14_12 = F2_max14* F2_var14_MI_12
gen F2_Ind_MAX_Var15_12 = F2_max15* F2_var15_MI_12
gen F2_Ind_MAX_Var16_12 = F2_max16* F2_var16_MI_12
gen F2_Ind_MAX_Var17_12 = F2_max17* F2_var17_MI_12


/// Generating Individual Maximum Possible -- Discounting Missing Responses
egen F2_Ind_Max_12 = rowtotal(F2_Ind_MAX_Var1_12-F2_Ind_MAX_Var17_12)
egen Max_F2_12 = max(F2_Ind_Max_12)
gen Pct_Max2_12 = F2_Ind_Max_12/Max_F2_12

/// Generating Individual Scores
egen F2_Score_12 = rowtotal(F2_var1_12-F2_var17_12)

drop if Pct_Max1_12 <.8 & year>=2013 


*egen SD_F1_12 = sd(F1_Score_12)
*egen SD_F2_12 = sd(F2_Score_12)
*replace F1_Score_12 = F1_Score_12/SD_F1_12
*replace F2_Score_12 = F2_Score_12/SD_F2_12
*egen mean_F1_12 = mean(F1_Score_12)
*egen mean_F2_12 = mean(F2_Score_12)
*replace F1_Score_12 = F1_Score_12-mean_F1_12
*replace F2_Score_12 = F2_Score_12-mean_F2_12

*logit Pres_Vote F1_Score_12 F2_Score_12 if year>=2013 
*outreg2 using VoteChoice, append dec(2) 
*regress partyid F1_Score_12 F2_Score_12 if year>=2013
*outreg2 using partisanship, append dec(2) 


gen F1_Adj = .
replace F1_Adj=F1_Score_80 if year>=1981 & year<=1984
replace F1_Adj=F1_Score_84 if year>=1985 & year<=1988
replace F1_Adj=F1_Score_88 if year>=1989 & year<=1992
replace F1_Adj=F1_Score_92 if year>=1993 & year<=1996
replace F1_Adj=F1_Score_96 if year>=1997 & year<=2000
replace F1_Adj=F1_Score_00 if year>=2001 & year<=2004
replace F1_Adj=F1_Score_04 if year>=2005 & year<=2008
replace F1_Adj=F1_Score_08 if year>=2009 & year<=2012
replace F1_Adj=F1_Score_12 if year>=2013 

gen F2_Adj = .
replace F2_Adj=F2_Score_80 if year>=1981 & year<=1984
replace F2_Adj=F2_Score_84 if year>=1985 & year<=1988
replace F2_Adj=F2_Score_88 if year>=1989 & year<=1992
replace F2_Adj=F2_Score_92 if year>=1993 & year<=1996
replace F2_Adj=F2_Score_96 if year>=1997 & year<=2000
replace F2_Adj=F2_Score_00 if year>=2001 & year<=2004
replace F2_Adj=F2_Score_04 if year>=2005 & year<=2008
replace F2_Adj=F2_Score_08 if year>=2009 & year<=2012
replace F2_Adj=F2_Score_12 if year>=2013 

by year: egen SD_F1 = sd(F1_Adj)
by year: egen SD_F2 = sd(F2_Adj)
replace F1_Adj = F1_Adj/SD_F1
replace F2_Adj = F2_Adj/SD_F2
by year: egen mean_F1 = mean(F1_Adj)
by year: egen mean_F2 = mean(F2_Adj)
replace F1_Adj = F1_Adj-mean_F1
replace F2_Adj = F2_Adj-mean_F2


regress partyid F1_Adj F2_Adj if year>=1981 & year<=1984
outreg2 using partyid, replace dec(2)
regress partyid F1_Adj F2_Adj if year>=1985 & year<=1988
outreg2 using partyid, append dec(2)
regress partyid F1_Adj  F2_Adj   if year>=1989 & year<=1992
outreg2 using partyid, append dec(2)
regress partyid F1_Adj  F2_Adj   if year>=1993 & year<=1996
outreg2 using partyid, append dec(2)
regress partyid F1_Adj  F2_Adj   if year>=1997 & year<=2000
outreg2 using partyid, append dec(2)
regress partyid F1_Adj  F2_Adj  if year>=2001 & year<=2004
outreg2 using partyid, append dec(2)
regress partyid F1_Adj  F2_Adj  if year>=2005 & year<=2008
outreg2 using partyid, append dec(2)
regress partyid F1_Adj  F2_Adj   if year>=2009 & year<=2012
outreg2 using partyid, append dec(2)
regress partyid F1_Adj F2_Adj   if year>=2013 
outreg2 using partyid, append dec(2)

logit Pres_Vote F1_Adj F2_Adj if year>=1981 & year<=1984
outreg2 using Pres_Vote, replace dec(2)
logit Pres_Vote F1_Adj F2_Adj if year>=1985 & year<=1988
outreg2 using Pres_Vote, append dec(2)
logit Pres_Vote F1_Adj  F2_Adj   if year>=1989 & year<=1992
outreg2 using Pres_Vote, append dec(2)
logit Pres_Vote F1_Adj  F2_Adj   if year>=1993 & year<=1996
outreg2 using Pres_Vote, append dec(2)
logit Pres_Vote F1_Adj  F2_Adj   if year>=1997 & year<=2000
outreg2 using Pres_Vote, append dec(2)
logit Pres_Vote F1_Adj  F2_Adj  if year>=2001 & year<=2004
outreg2 using Pres_Vote, append dec(2)
logit Pres_Vote F1_Adj  F2_Adj  if year>=2005 & year<=2008
outreg2 using Pres_Vote, append dec(2)
logit Pres_Vote F1_Adj  F2_Adj   if year>=2009 & year<=2012
outreg2 using Pres_Vote, append dec(2)
logit Pres_Vote F1_Adj F2_Adj   if year>=2013 
outreg2 using Pres_Vote, append dec(2)

save "GSS Post Factor.dta", replace

