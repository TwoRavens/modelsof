
*****************************************************************************************
*This do-file generates all models used in the main text. 
*****************************************************************************************

*For each sub-sample of countries (e.g., countries with enoguh share observations; different
*thresholds for democracy; etc..) we generate the sample-specific average of Polity(t-4) in
*autocracy and democracy. This is then used to calculate deviations from the average for each
*country-year observation. In this way, the coefficients of PRa and PRd in the heterogeneous 
*model can be interpreted as the effect of a price shock for the country at the average level
*of autocracy or democracy for each specific sample of countries.

*************************************
use $Output_aux/aux2, clear
*************************************



********************************************************** 
*TABLE A5: FUTURES PRICES
********************************************************** 

*merge the price series of future contracts to the main database
local group aluminum_AL11_fut beef_LC7_fut cocoa_LIFFE_C4_fut coffee_KC6_fut copper_HG11_fut gas_NG13_fut gold_GC9_fut oil_fut orange_OJ7_fut rice_RR3_fut silver_SI8_fut soybean_BO9_fut sugar_SB6_fut wheat_W6_fut wood_LB2_fut maize_C6_fut swine_LN9_fut coal_fut
foreach c of local group{
qui merge m:1 princ_comm year using "$Futures/`c'"
drop if _m==2
drop _m
}

*generate future prices of 1-year time maturity for available commodities
egen fut_1y=rowtotal (aluminum_AL11 beef_LC7_fut cocoa_LIFFE_C4_fut coffee_KC6_fut copper_HG11_fut gas_NG13_fut gold_GC9_fut oil_fut orange_OJ7_fut rice_RR3_fut silver_SI8_fut soybean_BO9_fut sugar_SB6_fut wheat_W6_fut wood_LB2_fut maize_C6_fut swine_LN9_fut coal_fut)
replace fut_1y=. if fut_1y==0


*Interaction for baseline with futures
sort ccode year
tsset ccode year

gen fut_1y_gr=(fut_1y/l.fut_1y)-1
gen pr_fut_1y=(l.fut_1y_gr+l2.fut_1y_gr+l3.fut_1y_gr)/3
gen pra_fut_1y=pr_fut_1y*aut4
gen prd_fut_1y=pr_fut_1y*dem4
gen pl4a1pr_fut_1y=pl4a1*pr_fut_1y
gen pl4d1pr_fut_1y=pl4d1*pr_fut_1y


********************************************************** 
*TABLE A6: EXPORT SHARE OBSERVATIONS
********************************************************** 

*above 1st quartile of observations share
xtile quart_countshare=countshare, nq(4)
                                                                    
egen avg_pl4_aut15=mean(pl4) if pl4<=0 & quart_countshare!=1
gen pl4a15=pl4-avg_pl4_aut15 if pl4<=0  
replace pl4a15=0 if pl4a15==. & pl4!=.  
gen pl4a15pr=pr*aut4*pl4a15       
replace pl4a15pr=0 if pl4a15pr==. 

egen avg_pl4_dem15=mean(pl4) if pl4>0 & quart_countshare!=1
gen pl4d15=pl4-avg_pl4_dem15 if pl4>0 
replace pl4d15=0 if pl4d15==. & pl4!=.
gen pl4d15pr=pr*dem4*pl4d15       
replace pl4d15pr=0 if pl4d15pr==. & pl4!=.


*share before 1986                                  
egen avg_pl4_aut16=mean(pl4) if pl4<=0  & countshare_86!=0
gen pl4a16=pl4-avg_pl4_aut16 if pl4<=0 & countshare_86!=0
replace pl4a16=0 if pl4a16==. & pl4!=. 
gen pl4a16pr=pr*aut4*pl4a16       
replace pl4a16pr=0 if pl4a16pr==.  & pl4!=.

egen avg_pl4_dem16=mean(pl4) if pl4>0 & countshare_86!=0
gen pl4d16=pl4-avg_pl4_dem16 if pl4>0 & countshare_86!=0
replace pl4d16=0 if pl4d16==. & pl4!=.
gen pl4d16pr=pr*dem4*pl4d16
replace pl4d16pr=0 if pl4d16pr==. & pl4!=.


*share before 1986 or always ranked first afterwards
egen avg_pl4_aut17=mean(pl4) if pl4<=0  & e==0
gen pl4a17=pl4-avg_pl4_aut17 if pl4<=0 
replace pl4a17=0 if pl4a17==. & pl4!=. 
gen pl4a17pr=pr*aut4*pl4a17       
replace pl4a17pr=0 if pl4a17pr==. & pl4!=. 

egen avg_pl4_dem17=mean(pl4) if pl4>0 & e==0 
gen pl4d17=pl4-avg_pl4_dem17 if pl4>0 
replace pl4d17=0 if pl4d17==. & pl4!=.
gen pl4d17pr=pr*dem4*pl4d17      
replace pl4d17pr=0 if pl4d17pr==. & pl4!=. 




********************************************************** 
*TABLE A7: ALTERNATIVE TIME SPECIFICATIONS
********************************************************** 

*exclude transition years
gen polity2_18=polity2
replace polity2_18=. if polity==-88
sort country year
by country:gen polity2_18_l=polity2_18[_n-1]
gen d_pol2_18=polity2_18-polity2_18_l

by country:gen pl4_18=polity2_18[_n-4]
gen aut4_18=1 if pl4_18<=0
replace aut4_18=0 if pl4_18>0 & pl4_18!=.
gen dem4_18=1 if pl4_18>0
replace dem4_18=0 if pl4_18<=0 & pl4_18!=.

egen avg_pl4_aut18=mean(pl4_18) if pl4_18<=0 
gen pl4a18=pl4_18-avg_pl4_aut18 if pl4_18<=0 
replace pl4a18=0 if pl4a18==. & pl4_18!=. 
gen pl4a18pr=pr*aut4_18*pl4a18       
replace pl4a18pr=0 if pl4a18pr==. & pl4_18!=. 

egen avg_pl4_dem18=mean(pl4_18) if pl4_18>0 
gen pl4d18=pl4_18-avg_pl4_dem18 if pl4_18>0 
replace pl4d18=0 if pl4d18==. & pl4_18!=. 
gen pl4d18pr=pr*dem4_18*pl4d18       
replace pl4d18pr=0 if pl4d18pr==. & pl4_18!=.


*3-y non-overlap
sort code year
by code: gen polity2_rob_l3 = polity2_rob[_n-3] if year==year[_n-1]+1
gen d_pol2_rob3=polity2_rob-polity2_rob_l3
by code:gen price_l = price[_n-1] if year==year[_n-1]+1
by code:gen price_l4 = price[_n-4] if year==year[_n-1]+1
gen pr_g3=(price_l/price_l4)-1
gen d_pol2_rob3_no=d_pol2_rob3 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen pr_g3_no=pr_g3 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen pra_g3_no=pr_g3*aut4 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen prd_g3_no=pr_g3*dem4 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen pl4a1pr_g3_no=pl4a1*pr_g3 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen pl4d1pr_g3_no=pl4d1*pr_g3 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen pl4a1_no=pl4a1 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen pl4d1_no=pl4d1 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008
gen dem4_no=dem4 if year==1969|year==1972|year==1975|year==1978|year==1981|year==1984|year==1987|year==1990|year==1993|year==1996|year==1999|year==2002|year==2005|year==2008



********************************************************** 
*TABLE A8: ALTERNATIVE THRESHOLDS
********************************************************** 

forvalues i=0(1)5 {
gen dem4_alt`i'=1 if pl4>`i' & pl4!=.
replace dem4_alt`i'=0 if dem4_alt`i'==. & pl4!=.
 
gen aut4_alt`i'=1 if pl4<=`i' & pl4!=. 
replace aut4_alt`i'=0 if aut4_alt`i'==. & pl4!=. 

gen pra_alt`i'=pr*aut4_alt`i' 
gen prd_alt`i'=pr*dem4_alt`i'  
                                                         
egen avg_pl4_aut_alt`i'=mean(pl4) if pl4<=`i'
gen pl4a_alt`i'=pl4-avg_pl4_aut_alt`i' if pl4<=`i'
replace pl4a_alt`i'=0 if pl4a_alt`i'==. & pl4!=. 
gen pl4a_alt`i'pr=pr*aut4_alt`i'*pl4a_alt`i'       
replace pl4a_alt`i'pr=0 if pl4a_alt`i'pr==. 

egen avg_pl4_dem_alt`i'=mean(pl4) if pl4>`i' 
gen pl4d_alt`i'=pl4-avg_pl4_dem_alt`i' if pl4>`i' 
replace pl4d_alt`i'=0 if pl4d_alt`i'==. & pl4!=.
gen pl4d_alt`i'pr=pr*dem4_alt`i'*pl4d_alt`i'     
replace pl4d_alt`i'pr=0 if pl4d_alt`i'pr==.
summ avg_pl4_aut_alt`i' avg_pl4_dem_alt`i'
}


********************************************************** 
*TABLE A9: ALTERNATIVE MEASURES OF INSTITUTIONAL QUALITY
**********************************************************

sort code year
merge 1:1 code year using $Data/fh_pts_ciri
drop _m

format country %15s

*****************************************
save $Output_final/main_ct,replace
*****************************************
