***LOAD DATA***

clear

*Insert local file location at [XXXXX]
import excel "[XXXXX]\AfricanPrivatization_JPP dataverse.xlsx", sheet("Data") firstrow


***TWO-STAGE ANALYSIS w/PROPSNSITY SCORING***
     *Using Hirano & Imbens (2004) approach, as described in Guo & Fraser (2015)
		 
 **STAGE 1: CALCULATING GENERALIZED PROPENSITY SCORE**
 
	**Creating independence scores = zero for country-years with no agency, new variable 'indieX'
	gen indieX=0
	replace indieX=indepX if indepX!=.
	**Creating cut points ('indieCUT') using new zero-based independence scores
	centile indieX, centile(10(10)90)
	quietly gen indieCUT = 0 if indieX<.14
	quietly replace indieCUT=1 if indieX>.14 & indieX<=.43
	quietly replace indieCUT=2 if indieX>.43

    **Analyzing propensity score using generalized method to estimate relative independence of privatization agency as a function of other variables
	gpscore2 polity4 IMF_SBA lnpop lnGDPpercap pctKformGDP pctgovGDP GDPgrow , t(indieX) gpscore(indepSCORE) predict(p_indep) sigma(sigma_indep) cutpoints(indieCUT) index(mean) ///
	nq_gps(10) family(binomial) link(logit) test(Bayes_factor)
	estat ic
	   
      *generates propensity score 'indepSCORE'. Converts to weights with inverse function:
	  gen indepWEIGHT=1/indepSCORE
	  
  **STAGE 2: POOLED OLS ESTIMATOR*
  *Estimates cumulative percent of SOEs privatized, adjusting for independence propensity by weighting using inverse of 'indepSCORE', 'indepWEIGHT' (see Guo & Fraser 2015, p.314).

  *Generating standardized PolityIV and agendcy independence scores.
  gen Zpolity4=(polity4-.998)/5.622
  gen ZindieX=(indieX-.316)/.240
    
  
    *Analysis 1--Direct effects only
reg priv_cumpct Zpolity4 ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag ALG BEN BF BOT CAM CDI ///
	ETH GHA KEN LES MAD MLI MLW MOR MOZ MRS NBA NGA NGR RWA SAF SEN SIL /// 
	TAN TOG TUN UGA ZAM y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004 y2005 y2006 [pweight=indepWEIGHT], vce(r)	  
	fitstat
	
	
	*Analysis 2--Democracy x independence interaction
  
reg priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag ALG BEN BF BOT CAM CDI ///
	ETH GHA KEN LES MAD MLI MLW MOR MOZ MRS NBA NGA NGR RWA SAF SEN SIL ///
	TAN TOG TUN UGA ZAM y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004 y2005 y2006 [pweight=indepWEIGHT], vce(r)	  
	fitstat
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot


***ROBUSTNESS CHECKS***

***Model D1: ENDOGENOUS TREATMENT EFFECTS REGRESSION***
etregress priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag ///
ALG BEN BF BOT CAM CDI ETH GHA KEN LES MAD ///
 MLI MLW MOR MOZ MRS NBA NGA NGR RWA SAF SEN SIL ///
 TAN TOG TUN UGA ZAM ///
 y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004 y2005 y2006, ///
 treat(agency = Zpolity4 IMF_SBA lnpop lnGDPpercap pctKformGDP pctgovGDP GDPgrow) 
quietly margins, dydx(Zindie) at(Zpolity4=(-2(.5)2))
marginsplot	   

***Model D2: FIXED EFFECTS MODEL w/o WEIGHTS***
xtset codeno Year, yearly
xtreg priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag, fe
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot

***Model D3: TIME SERIES MODEL w/DRISCOLL-KRAAY STANDARD ERRORS***
gen demXindieX=Zpolity4*ZindieX
xtscc priv_cumpct Zpolity4 ZindieX demXindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag if YearNo>1, fe

***Model D4: JACKKNIFED STANDARD ERRORS
jackknife: xtreg priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag, fe cluster(codeno)
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.5)2))
marginsplot 

***Model D5: MLE RANDOM EFFECTS MODEL w/o WEIGHTS***
xtreg priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag, mle
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot

***Model D6: PANEL-CORRECTED STANDARD ERRORS***
xtpcse priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag if YearNo>1 [iweight=indepWEIGHT]
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot

***Model D7: Number of privatizations as DV***
reg priv_no Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear ALG BEN BF BOT CAM CDI ///
	ETH GHA KEN LES MAD MLI MLW MOR MOZ MRS NBA NGA NGR RWA SAF SEN SIL ///
	TAN TOG TUN UGA ZAM y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004 y2005 y2006 if YearNo>1 [pweight=indepWEIGHT], vce(r)	  
fitstat
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot

***Model D8: MAURITIUS EXCLUDED
	*Mauritius is a stable democracy with no privatization agency
reg priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag ALG BEN BF BOT CAM CDI ETH GHA KEN LES MAD MLI MLW MOR MOZ NBA NGA NGR RWA SAF SEN SIL TAN TOG TUN UGA ZAM y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 y1999 y2000 y2001 y2002 y2003 y2004 y2005 y2006 [pweight=indepWEIGHT] if MRS!=1, vce(r)
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot 

***Model D9: FIXED EFFECTS MODEL w/NO "Zero Cases" AND w/o WEIGHTS***
	*Cases with no privatization agency excluded form the model.
xtreg priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag if agency==1, fe
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot

***Model D10: 1990-1999 CASES ONLY***
reg priv_cumpct Zpolity4 ZindieX c.Zpolity4#c.ZindieX lnpop lnGDPpercap pctgovGDP electyear priv_cumpct_lag ALG BEN BF BOT CAM CDI ///
	ETH GHA KEN LES MAD MLI MLW MOR MOZ MRS NBA NGA NGR RWA SAF SEN SIL ///
	TAN TOG TUN UGA ZAM y1991 y1992 y1993 y1994 y1995 y1996 y1997 y1998 if Year<2000 [pweight=indepWEIGHT], vce(r)	  
	fitstat
quietly margins, dydx(ZindieX) at(Zpolity4=(-2(.25)2))
marginsplot

***END OF FILE***
