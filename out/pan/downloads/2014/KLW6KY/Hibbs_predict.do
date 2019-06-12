clear
cd  F:\Predict_Hibbs\
use Hibbs.dta

* definitions and sources of variables:
describe, full

sort qdates
tsset qdates, quarterly

sort qdates
*generate real income growth rate variable used in the model
gen r = dpi_pc/(cpi_sa_8284/100)
gen lnr = log(r)
gen dlnr = (lnr-L1.lnr)*400

********1976****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<1973,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat1976= predict(),ci(low_95_1976 high_95_1976)
predictnl yhat1976a= predict(),ci(low_90_1976 high_90_1976) level(90)
predictnl yhat1976b= predict(),ci(low_67_1976 high_67_1976) level(66.66)


********1980****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<1977,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat1980= predict(),ci(low_95_1980 high_95_1980)
predictnl yhat1980a= predict(),ci(low_90_1980 high_90_1980) level(90)
predictnl yhat1980b= predict(),ci(low_67_1980 high_67_1980) level(66.66)


********1984****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<1981,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat1984= predict(),ci(low_95_1984 high_95_1984)
predictnl yhat1984a= predict(),ci(low_90_1984 high_90_1984) level(90)
predictnl yhat1984b= predict(),ci(low_67_1984 high_67_1984) level(66.66)

********1988****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<1985,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat1988= predict(),ci(low_95_1988 high_95_1988)
predictnl yhat1988a= predict(),ci(low_90_1988 high_90_1988) level(90)
predictnl yhat1988b= predict(),ci(low_67_1988 high_67_1988) level(66.66)

********1992****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<1989,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat1992= predict(),ci(low_95_1992 high_95_1992)
predictnl yhat1992a= predict(),ci(low_90_1992 high_90_1992) level(90)
predictnl yhat1992b= predict(),ci(low_67_1992 high_67_1992) level(66.66)

********1996****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<1993,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat1996= predict(),ci(low_95_1996 high_95_1996)
predictnl yhat1996a= predict(),ci(low_90_1996 high_90_1996) level(90)
predictnl yhat1996b= predict(),ci(low_67_1996 high_67_1996) level(66.66)

********2000****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<1997,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat2000= predict(),ci(low_95_2000 high_95_2000)
predictnl yhat2000a= predict(),ci(low_90_2000 high_90_2000) level(90)
predictnl yhat2000b= predict(),ci(low_67_2000 high_67_2000) level(66.66)

********2004****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<2001,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat2004= predict(),ci(low_95_2004 high_95_2004)
predictnl yhat2004a= predict(),ci(low_90_2004 high_90_2004) level(90)
predictnl yhat2004b= predict(),ci(low_67_2004 high_67_2004) level(66.66)

********2008****
nl ( presvote = {b0} + {bdlnr}*((1.0*wtq16*dlnr+{g}*L1.dlnr ///
+{g}^2*L2.dlnr+{g}^3*L3.dlnr+{g}^4*L4.dlnr+{g}^5*L5.dlnr ///
+{g}^6*L6.dlnr +{g}^7*L7.dlnr+{g}^8*L8.dlnr+{g}^9*L9.dlnr ///
+{g}^10*L10.dlnr+{g}^11*L11.dlnr ///
+{g}^12*L12.dlnr+{g}^13*L13.dlnr+{g}^14*L14.dlnr) / (1.0*wtq16+{g} ///
+{g}^2+{g}^3+{g}^4+{g}^5+{g}^6+{g}^7+{g}^8+{g}^9+{g}^10+{g}^11 ///
+{g}^12+{g}^13+{g}^14)) + {bkia}*Fatalities ) ///
if year>1948 & year<2005,variables(presvote dlnr wtq16 Fatalities) ///
initial(b0 45 g 0.95 bdlnr 4 bkia -0.1) iterate(500) nolog


predictnl yhat2008= predict(),ci(low_95_2008 high_95_2008)
predictnl yhat2008a= predict(),ci(low_90_2008 high_90_2008) level(90)
predictnl yhat2008b= predict(),ci(low_67_2008 high_67_2008) level(66.66)