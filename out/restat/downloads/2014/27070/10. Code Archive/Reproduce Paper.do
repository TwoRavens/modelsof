*Just change base directory as needed.
local base "C:\Research\Alcohol and Crime\10. Code Archive"

*Location of arrest data
local data "`base'\Data Files and Code That Produced Them\P01 Age Profile of Arrest Rates 1979-2006"
*Location of the alcohol consumption data
local data_CHIS "`base'\Data Files and Code That Produced Them\CHIS Tables 04 26 2009.csv"

*To create PDFs in older windows versions of Stata
  cap pr drop grexportpdf
  program define grexportpdf
    version  11
    args using
    loc using = subinstr("`using'",".pdf","",.)
    gr export "`using'.eps" , replace fontface(Times)
    !epstopdf "`using'.eps"
    erase "`using'.eps"
  end

*Create the four figures for the paper
include "`base'\Code for Figures and Tables in Paper\Figure 1 Arrests by Overall Crime Categories from the MACR.do"
include "`base'\Code for Figures and Tables in Paper\Figure 2 Arrests for Alcohol Related Crimes from MACR.do"
include "`base'\Code for Figures and Tables in Paper\Figure 3 Arrests for Violent Crimes from MACR.do"
include "`base'\Code for Figures and Tables in Paper\Figure 4 Arrests for Other Crimes that Show Increases from MACR.do"

*Create the two tables for the appendix
include "`base'\Code for Figures and Tables in Paper\Tables 1 and 2.do"
            	
				
*Create appendix figures and tables
*Appendix A is created by mapping the collapsed categories from P01 to their lables in the figures and tables
include "`base'\Code for Appendices\Appendix B Plot of Arrest Rates in Days Right Around 21 Birthday.do"
include "`base'\Code for Appendices\Appendix C Robustness to bandwidth of arrests by overall crime rates.do"
include "`base'\Code for Appendices\Appendix D Robustness to bandwidth Alcohol Related Crimes.do"
include "`base'\Code for Appendices\Appendix E Robustness to bandwidth Violent Crimes.do"
include "`base'\Code for Appendices\Appendix F Robustness to bandwidth Other Crimes.do"
include "`base'\Code for Appendices\Appendix G Arrests for Property Crimes.do"
include "`base'\Code for Appendices\Appendix H Arrests for Drug Possession or Sale.do"
include "`base'\Code for Appendices\Appendix I Change in Arrest Rates Property and Drug Crime.do"
*Appendix J is just the location of arrest for assault for 20 and 21 year olds from National Incident Based Reporting System 2000-2005
include "`base'\Code for Appendices\Appendix K Persistence of Effects for Crime.do"
*Appenedices L, M, O and P use means from the California Health Interview Survey
include "`base'\Code for Appendices\Appendix L Drinking and Binging Participation from CHIS.do"
include "`base'\Code for Appendices\Appendix M Drinking and Binging Frequency from CHIS.do"
*Appendix N was produced onsite at UCLA from the CHIS
include "`base'\Code for Appendices\Appendix O Robustness to Bandwidth for Drinking and Binging Participation.do"
include "`base'\Code for Appendices\Appendix P Robustness to Bandwidth for Drinking and Binging Frequency.do"
*Appendix Q was produced onsite at UCLA from the CHIS


 
