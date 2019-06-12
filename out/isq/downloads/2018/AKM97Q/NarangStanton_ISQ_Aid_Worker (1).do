 *************************
 *Table 1 MAIN models 1-6*
 *************************
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devexp2, fe
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devexp2, fe
 
 
 **********************************************
 *Table 2 NATIONAL VS INTERNATIONAL models 1-6*
 **********************************************
 xtreg INSOeventAverage_National karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventAverage_National karzai0409_pct2 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventAverage_National karzai0409_pct2 witsincidents logpopulation opiumpct devexp2, fe
 xtreg INSOeventAverage_Interational karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventAverage_Interational karzai0409_pct2 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventAverage_Interational karzai0409_pct2 witsincidents logpopulation opiumpct devexp2, fe
  
  
 **********************************************
 *Table 3 NATIONAL VS INTERNATIONAL models 1-6*
 **********************************************
 xtreg INSOeventavg implied_moreprosperousunderGOV witsincidents logpopulation opiumpct logfoodaid,fe
 xtreg INSOeventavg gov_somewhatgoodjob witsincidents logpopulation opiumpct logfoodaid,fe
 
 
 
 ********************************************************
 *APPENDIX TABLE A2 Correlation Matrix Violence Measures*
 ********************************************************
pwcorr eventcountJOIIS eventcountCIDNE eventcountACLED witsincidents if year!=2010 & year!=2011 & year!=2012, st(95)

 
 
 **********************************************************
 *APPENDIX TABLE A3 ROBUSTNESS models USING karzai0409_pct*
 **********************************************************
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct devexp2, fe
 xtreg INSOeventavg_noRob karzai0409_pct witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg_noRob karzai0409_pct witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg_noRob karzai0409_pct witsincidents logpopulation opiumpct devexp2, fe
 
 
 *********************************************************************
 *APPENDIX TABLE A4 ROBUSTNESS MODELS USING AUDITED KARZAI VOTE SHARE*
 *********************************************************************
 
 xtreg INSOeventavg karzai0409_pct2_audited witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg karzai0409_pct2_audited witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg karzai0409_pct2_audited witsincidents logpopulation opiumpct devexp2, fe
 xtreg INSOeventavg_noRob karzai0409_pct2_audited witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg_noRob karzai0409_pct2_audited witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg_noRob karzai0409_pct2_audited witsincidents logpopulation opiumpct devexp2, fe
 

  
 ****************************************************************************************
 *APPENDIX TABLE A5 Dropping Paktika, Kandahar, and Nangarhar where voter fraud was high*
 ****************************************************************************************
 drop if province == "Paktika"
 drop if province == "Kandahar" 
 drop if province == "Nangarhar" 
 
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devexp2, fe
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devexp2, fe
 
 
 ****************************************************************************************
 *APPENDIX TABLE A6 ROBUSTNESS USING using ACLED data for Overall Violence, 2008 - 2009t*
 ****************************************************************************************
 xtreg INSOeventavg karzai0409_pct eventcountACLED logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg karzai0409_pct eventcountACLED logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg karzai0409_pct eventcountACLED logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct eventcountACLED logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct eventcountACLED logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg_noRob karzai0409_pct eventcountACLED logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 
 
 ****************************************************************************************
 *APPENDIX TABLE A7 ROBUSTNESS USING using JOIIS data for Overall Violence, 2008 - 2009t*
 ****************************************************************************************
 xtreg INSOeventavg karzai0409_pct eventcountJOIIS logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg karzai0409_pct eventcountJOIIS logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg karzai0409_pct eventcountJOIIS logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct eventcountJOIIS logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct eventcountJOIIS logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg_noRob karzai0409_pct eventcountJOIIS logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 
 
 ***************************************************************************************
 *APPENDIX TABLE A8 ROBUSTNESS USING using CIDNE data for Overall Violence, 2008 - 2009*
 ***************************************************************************************
 xtreg INSOeventavg karzai0409_pct eventcountCIDNE logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg karzai0409_pct eventcountCIDNE logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg karzai0409_pct eventcountCIDNE logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct eventcountCIDNE logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct eventcountCIDNE logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg_noRob karzai0409_pct eventcountCIDNE logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 

 **********************************************************************************************
 *APPENDIX TABLE A9 ROBUSTNESS USING using iCasualities data for Overall Violence, 2008 - 2009*
 **********************************************************************************************
 xtreg INSOeventavg karzai0409_pct icasualt_fatalitiesprovinceYear logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg karzai0409_pct icasualt_fatalitiesprovinceYear logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg karzai0409_pct icasualt_fatalitiesprovinceYear logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct icasualt_fatalitiesprovinceYear logpopulation opiumpct logfoodaid if year!=2010 & year!=2011 & year!=2012, fe
 xtreg INSOeventavg_noRob karzai0409_pct icasualt_fatalitiesprovinceYear logpopulation opiumpct devprojects if year!=2010 & year!=2011 & year!=2012, fe 
 xtreg INSOeventavg_noRob karzai0409_pct icasualt_fatalitiesprovinceYear logpopulation opiumpct devexp2 if year!=2010 & year!=2011 & year!=2012, fe
 
 
 ***************************************************************************
 *APPENDIX TABLE A10 ROBUSTNESS USING NEGATIVE BINOMIAL ESTIMATION ON COUNT*
 ***************************************************************************
 nbreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid if karzai0409_pct2<=.79, cluster(province) 
 nbreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devprojects if karzai0409_pct2<=.79, cluster(province)
 nbreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devexp2 if karzai0409_pct2<=.79, cluster(province)
 nbreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid if karzai0409_pct2<=.79, cluster(province)
 nbreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devprojects if karzai0409_pct2<=.79, cluster(province)
 nbreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devexp2 if karzai0409_pct2<=.79, cluster(province)
 *****************************************************************
 *APPENDIX TABLE A11 ROBUSTNESS USING POISSON ESTIMATION ON COUNT*
 *****************************************************************
 poisson INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid if karzai0409_pct2<=.79, cluster(province)
 poisson INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devprojects if karzai0409_pct2<=.79, cluster(province)
 poisson INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devexp2 if karzai0409_pct2<=.79, cluster(province)
 poisson INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid if karzai0409_pct2<=.79, cluster(province)
 poisson INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devprojects if karzai0409_pct2<=.79, cluster(province)
 poisson INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devexp2 if karzai0409_pct2<=.79, cluster(province)
 
 
 *************************************************************
 *APPENDIX TABLE A12: TWO STAGE RESIDUAL INCLUSION ESTIMATION*
 *************************************************************
 xtreg karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid Securityexcellentgoodsum, fe
 predict uhat
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid uhat, fe
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devprojects uhat, fe 
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devexp2 uhat, fe

 
 ********************************************************
 *APPENDIX TABLE 13 IV: PERCENT OF POPULATION THAT VOTED*
 ********************************************************
 xtreg INSOeventavg turnouttotal0409 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg turnouttotal0409 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg turnouttotal0409 witsincidents logpopulation opiumpct devexp2, fe 
 xtreg INSOeventavg_noRob turnouttotal0409 witsincidents logpopulation opiumpct logfoodaid, fe
 xtreg INSOeventavg_noRob turnouttotal0409 witsincidents logpopulation opiumpct devprojects, fe 
 xtreg INSOeventavg_noRob turnouttotal0409 witsincidents logpopulation opiumpct devexp2, fe
 
  
 *****************************************************
 *APPENDIX TABLE 14 CONTROLLING FOR ROADS AND BRIDGES*
 ***************************************************** 
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct logfoodaid roads_sqkm bridges_sqkm, fe
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct devprojects roads_sqkm bridges_sqkm, fe 
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct devexp2 roads_sqkm bridges_sqkm, fe
 xtreg INSOeventavg_noRob karzai0409_pct witsincidents logpopulation opiumpct logfoodaid roads_sqkm bridges_sqkm, fe
 xtreg INSOeventavg_noRob karzai0409_pct witsincidents logpopulation opiumpct devprojects roads_sqkm bridges_sqkm, fe 
 xtreg INSOeventavg_noRob karzai0409_pct witsincidents logpopulation opiumpct devexp2 roads_sqkm bridges_sqkm, fe
 
 
 **********************************************
 *APPENDIX TABLE 15 CONTROLLING FOR ISAF BASES*
 **********************************************
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid isafbasecount, fe
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devprojects isafbasecount, fe 
 xtreg INSOeventavg karzai0409_pct2 witsincidents logpopulation opiumpct devexp2 isafbasecount, fe
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct logfoodaid isafbasecount, fe
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devprojects isafbasecount, fe 
 xtreg INSOeventavg_noRob karzai0409_pct2 witsincidents logpopulation opiumpct devexp2 isafbasecount, fe
 
  
 ****************************************************************************
 *APPENDIX TABLE 16 CONTROLLING FOR ETHNIC COMPOSITION AS PERCENTAGE PASHTUN*
 ****************************************************************************
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct logfoodaid uv_pashtun, fe
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct devprojects uv_pashtun, fe 
 xtreg INSOeventavg karzai0409_pct witsincidents logpopulation opiumpct devexp2 uv_pashtun, fe
  
