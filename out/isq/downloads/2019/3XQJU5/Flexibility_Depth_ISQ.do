
###### Do file to replicate "The Politics of Trade Agreement Design: Revisiting the Depth-Flexibility Nexus" (by Baccini, Dür, and Elsig)

##### Use the file "Flexibility_Depth_ISQ.dta"
####### To run this dofile you need STATA 13 and the following package in STATA:
####### 1) clarify from 'http://gking.harvard.edu/clarify'

* cd ""
* use Flexibility_Depth_ISQ, clear
* log using XXX.log
set more off

###### Preparing control variables (already run) ########

*gen gdp_minln=ln(gdp_min)
*gen gdppc_minln=ln(gdppc_min)
*gen transp_min=transp_min^2
*gen trade=m_min+x_min
*gen tradeln=ln(trade+1)
*gen Regime_di1 = 1
*replace Regime_di1 = 0 if Regime <6
*replace Regime_di1 = . if Regime == .
*destring flexescape, gen(flexescape_new) force
*destring  flexrigid, gen(flexrigid_new) force
*drop if missing(year)


############################################################################
############################## Empirical Analysis ##########################
############################################################################

################################ Table 2 -- descriptive statistics #############

sum EscapeFlexibility FlexibilityStrings Depth GDP GDPpc Trade Regime Regime_di1  GATTWTO NoMembers Democratization  
sum TransitionalFlex if AddOn!=1


########################################## Table 3 -- Main Results ################

############ Model (1) ####

oprobit EscapeFlexibility Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization
*outreg2 using table1, tex(frag) dec(2) onecol 

############ Model (2) ####

zinb TransitionalFlex Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if AddOn!=1, inflate(Depth GDP GDPpc Trade) vuong zip
*outreg2 using table1, tex(frag) dec(2) onecol append

############ Model (3) ####

oprobit EscapeFlexibility c.Depth##i.Regime_di1 GDP GDPpc Trade GATTWTO NoMembers Democratization
*outreg2 using table1, tex(frag) dec(2) onecol append
margins , over(Regime_di1) at(Depth=(0(10)40)) predict(outcome(0)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(neast) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))
margins , over(Regime_di) at(Depth=(0(10)40)) predict(outcome(4)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(nwest) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

############ Model (4) ####

oprobit FlexibilityStrings EscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Depth Democratization
*outreg2 using table1, tex(frag) dec(2) onecol append

############ Model (5) ####

oprobit FlexibilityStrings EscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Depth Democratization if EscapeFlexibility!=0
*outreg2 using table1, tex(frag) dec(2) onecol append


################################# Table 4 -- Effects ########################

estsimp oprobit EscapeFlexibility Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization
setx mean
simqi, fd(pr) changex(Depth min max)
drop b1-b12

zinb TransitionalFlex Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if AddOn!=1, inflate(Depth GDP GDPpc Trade)
margins, at(Depth=0)
margins, at(Depth=40)

zinb TransitionalFlex Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if AddOn!=1, inflate(Depth GDP GDPpc Trade)
margins, at(Depth=0)
margins, at(Depth=18)

estsimp oprobit FlexibilityStrings EscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Democratization Depth
setx mean
simqi, fd(pr) changex(EscapeFlexibility min max)
drop b1-b13



################################################### 
############## Robustness checks #################
####################################################

######################### Table A1 - Other operationalization of depth and flexibility ################

######## Model A1 ################

reg EscapeFlexibilityFA DepthFA GDP GDPpc Trade Regime GATTWTO NoMembers Democratization
*outreg2 using tableA1.xls, dec(2)  

########## Model A2 ################

zinb TransitionalFlex DepthFA GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if AddOn!=1, inflate(DepthFA GDP GDPpc Trade) vuong zip
*outreg2 using tableA1.xls, dec(2) append

############ Model A3 ################

reg EscapeFlexibilityFA c.DepthFA##i.Regime_di GDP GDPpc Trade GATTWTO NoMembers Democratization
*outreg2 using tableA1.xls, dec(2) append
margins , over(Regime_di) at(DepthFA=(-1(.5)2.5)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(n) textfirst) addplot(histogram DepthFA,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

############## Model A4 ################

zinb TransitionalFlex c.DepthFA##i.Regime_di GDP GDPpc Trade GATTWTO NoMembers Democratization if AddOn!=1, inflate(DepthFA GDP GDPpc Trade) vuong zip
*outreg2 using tableA1.xls, dec(2) append
margins , over(Regime_di) at(DepthFA=(-1(.5)2.5)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(nwest) textfirst) addplot(histogram DepthFA,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

################## Model A5 ################

reg FlexibilityStringsFA EscapeFlexibilityFA GDP GDPpc Trade Regime DepthFA GATTWTO NoMembers Democratization
*outreg2 using tableA1.xls, dec(2) append


########################################## Table A2 non-linearity ################

####### Model A6 ####

*gen Depth1=0
*replace Depth1=1 if Depth<6
*replace Depth1=2 if Depth>5 
*replace Depth1=3 if Depth>10
*replace Depth1=4 if Depth>15
*replace Depth1=5 if Depth>20
*replace Depth1=6 if Depth>25
*replace Depth1=7 if Depth>30
*replace Depth1=8 if Depth>35
*replace Depth1=0 if Depth==0

oprobit EscapeFlexibility i.Depth1 GDP GDPpc Trade Regime GATTWTO NoMembers Democratization, collinear
*outreg2 using tableA2.xls, dec(2)  

############ Model A7 ####

oprobit FlexibilityStrings i.EscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Democratization Depth
*outreg2 using tableA2.xls, dec(2) append

############## Model A8 ####

oprobit EscapeFlexibility Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if Depth!=0
*outreg2 using tableA2.xls, dec(2) append

################# Model A9 ####

oprobit EscapeFlexibility c.Depth##i.Regime_di GDP GDPpc Trade GATTWTO NoMembers Democratization if Depth!=0
*outreg2 using tableA2.xls, dec(2) append
margins , over(Regime_di) at(Depth=(0(10)40)) level(90) atmeans predict(outcome(0))
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(neast) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))
margins , over(Regime_di) at(Depth=(0(10)40)) level(90) atmeans predict(outcome(4))
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(nwest) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

#################### Model A10 ####

zinb TransitionalFlex Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if Depth!=0 & AddOn!=1 , inflate(Depth GDP GDPpc Trade) vuong zip
*outreg2 using tableA2.xls, dec(2) append


########################################## Table A3 North-South PTAs ################

gen NS=0 if  northsouth!=.
replace NS=1 if northsouth==2

#################### Model A11 ####

oprobit EscapeFlexibility Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if NS==0
*outreg2 using tableA3.xls, dec(2)  

#################### Model A12 ####

oprobit EscapeFlexibility Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if NS==1
*outreg2 using tableA3.xls, dec(2) append

#################### Model A13 ####

oprobit EscapeFlexibility c.Depth##i.Regime_di GDP GDPpc Trade GATTWTO NoMembers Democratization if NS==0
*outreg2 using tableA3.xls, dec(2) append
margins , over(Regime_di) at(Depth=(0(10)40)) level(90) atmeans predict(outcome(0))
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(neast) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))
margins , over(Regime_di) at(Depth=(0(10)40)) level(90) atmeans predict(outcome(4))
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(seast) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

#################### Model A14 ####

oprobit EscapeFlexibility c.Depth##i.Regime_di GDP GDPpc Trade GATTWTO NoMembers Democratization if NS==1
*outreg2 using tableA3.xls, dec(2) append
margins , over(Regime_di) at(Depth=(0(10)40)) level(90) atmeans predict(outcome(0))
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(neast) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))
margins , over(Regime_di) at(Depth=(0(10)40)) level(90) atmeans predict(outcome(4))
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(nwest) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

#################### Model A15 ####

zinb TransitionalFlex Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if NS==0, inflate(Depth GDP GDPpc Trade) vuong zip
*outreg2 using tableA3.xls, dec(2) append

#################### Model A16 ####

zip TransitionalFlex Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization if NS==1, inflate(Depth GDP GDPpc Trade) vuong 
*outreg2 using tableA3.xls, dec(2) append

#################### Model A17 ####

oprobit FlexibilityStrings EscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Democratization Depth if NS==0
*outreg2 using tableA3.xls, dec(2) append

#################### Model A18 ####

oprobit FlexibilityStrings EscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Democratization Depth if NS==1
*outreg2 using tableA3.xls, dec(2) append


######################### Table A4 -- Data from Kucik ##########################

########## Model A19 ####

oprobit KucikEscapeFlexibility Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization
*outreg2 using tableA4.xls, dec(2) onecol 

########## Model A20 ####

oprobit KucikEscapeFlexibility c.Depth##i.Regime_di1 GDP GDPpc Trade GATTWTO NoMembers Democratization
*outreg2 using tableA4.xls, dec(2) onecol append
margins , over(Regime_di) at(Depth=(0(10)40)) predict(outcome(0)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(neast) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))
margins , over(Regime_di) at(Depth=(0(10)40)) predict(outcome(4)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(nwest) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

########## Model A21 ####

*oprobit KucikRigidity KucikEscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Depth Democratization
*outreg2 using tableA4.xls, dec(2) onecol append
reg KucikRigidity KucikEscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Depth Democratization
*outreg2 using tableA4.xls, dec(2) onecol append

########## Model A22 ####

*oprobit KucikRigidity KucikEscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Depth Democratization if KucikEscapeFlexibility!=0
*outreg2 using tableA4.xls, dec(2) onecol append
reg KucikRigidity KucikEscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Depth Democratization if KucikEscapeFlexibility!=0
*outreg2 using tableA4.xls, dec(2) onecol append


########################### Table A5 -- Time trend ###############

gen t=year-1948
gen t2=t^2
gen t3=t^3

########## Model A23 ####

oprobit EscapeFlexibility Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization t
*outreg2 using tableA5.xls, dec(2) onecol 

########## Model A24 ####

zinb TransitionalFlex Depth GDP GDPpc Trade Regime GATTWTO NoMembers Democratization t if AddOn!=1, inflate(Depth GDP GDPpc Trade) vuong zip
*outreg2 using tableA5.xls, dec(2) onecol append

########## Model A25 ####

oprobit EscapeFlexibility c.Depth##i.Regime_di1 GDP GDPpc Trade GATTWTO NoMembers Democratization t 
*outreg2 using tableA5.xls, dec(2) onecol append
margins , over(Regime_di1) at(Depth=(0(10)40)) predict(outcome(0)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(neast) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))
margins , over(Regime_di) at(Depth=(0(10)40)) predict(outcome(4)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(nwest) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

########## Model A26 ####

zinb TransitionalFlex c.Depth##i.Regime_di GDP GDPpc Trade Regime GATTWTO NoMembers Democratization t if AddOn!=1, inflate(Depth GDP GDPpc Trade) vuong zip
*outreg2 using tableA5.xls, dec(2) onecol append
margins , over(Regime_di) at(Depth=(0(10)40)) level(90) atmeans 
marginsplot, title ("") graphregion(fcolor("gs16")) legend(region(lwidth(none)) cols(1) ring(0) bplacement(nwest) textfirst) addplot(histogram Depth,  percent fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)))

########## Model A27 ####

oprobit FlexibilityStrings EscapeFlexibility GDP GDPpc Trade Regime GATTWTO NoMembers Depth Democratization t if EscapeFlexibility!=0
*outreg2 using tableA5.xls, dec(2) onecol append
