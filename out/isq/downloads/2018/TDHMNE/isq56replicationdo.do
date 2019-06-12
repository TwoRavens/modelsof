*Replication do for ISQ(2012)56,590-606

gen lskilled =ln(stkilled +1)
gen lmkilled =ln(mtkilled +1)
gen ltkilled =ln(tkilled +1)
gen labduct =ln(mabduct +1)

gen killabduct =tkilled+mabduct
gen lkillabduct =ln(killabduct+1)
gen lpopdensity =ln(popdensity+1)
gen lcostofwar =ln(costofwar+1)
gen eei =eei_01*100

gen snroad =cfughh*roadskm
gen avforest =forestarea/landsqkm

/***Table 1: Descriptive Statistics***
sum displaced eei costofwar cfughh roadskm popdensity tkilled stkilled mtkilled mabduct elevationmtr roaddensity openborder ngos_08

/***Table2: Comparison of Physical Infrastructure, Forest Area, and Community Forest User Groups across Topographical Regions of Nepal***
sum roadskm roaddensity elevationmtr landsqkm avforest cfughh if elev==3
sum roadskm roaddensity elevationmtr landsqkm avforest cfughh if elev==2 &dcode!=26&dcode!=27
sum roadskm roaddensity elevationmtr landsqkm avforest cfughh if elev==2
sum roadskm roaddensity elevationmtr landsqkm avforest cfughh if elev==1

/***Table 3: Negative Binomial Regression Results for Displacement ***
nbreg displaced  eei lcostofwar cfughh roadskm lpopdensity ltkilled, robust nolog
nbreg displaced eei lcostofwar cfughh roadskm lpopdensity labduct, robust nolog
nbreg displaced eei lcostofwar cfughh roadskm lpopdensity lkillabduct, robust nolog

nbreg displaced  eei lcostofwar cfughh roadskm lpopdensity ltkilled, robust nolog irr
nbreg displaced eei lcostofwar cfughh roadskm  lpopdensity labduct, robust nolog irr
nbreg displaced eei lcostofwar cfughh roadskm lpopdensity lkillabduct, robust nolog irr
