/*******************************************************
*Jordan Becker and Edmund Malesky
May 16, 2016
STATA Version 14
*******************************************************/



********************************
* Standard Stata Configuration *
********************************
clear all
set more off
set mem 999m
capture log close
set logtype text
cap cd "C:\Users\ejm5\Google Drive\2015_Research\ISQ_RnR\Final_Docs\replication\txt"
cap cd "C:\Users\Jordan.Becker\Desktop\GD\2015_Research\ISQ_RnR\txt"




#delimit;	
set more off;	
phrasefreq 2 Albania_2004.txt Albania_2005.txt Albania_2012.txt Austria_2001.txt Austria_2013.txt Belgium_2000.txt Bulgaria_2002.txt
Bulgaria_2010.txt Bulgaria_2011.txt Bulgaria_2014.txt Canada_1994.txt Canada_2004.txt Canada_2005.txt Canada_2008.txt Canada_2012.txt
Croatia_2005.txt Croatia_2013.txt Croatia_2015.txt Czech_Republic_2002.txt Czech_Republic_2004.txt Czech_Republic_2008.txt
Czech_Republic_2011.txt Czech_Republic_2012.txt Denmark_2004.txt Denmark_2008.txt Denmark_2010.txt Estonia_2004.txt Estonia_2009.txt
Estonia_2010.txt Finland_2001.txt Finland_2004.txt Finland_2006.txt Finland_2009.txt Finland_2012.txt Finland_2013.txt France_1959.txt 
France_1972.txt France_1994.txt France_2003.txt
France_2008.txt France_2013.txt Germany_1994.txt Germany_2006.txt Germany_2008_CDU.txt Germany_2011.txt Greece_1997.txt Greece_2014.txt 
Hungary_2004.txt
Hungary_2012.txt Ireland_2000.txt Ireland_2003.txt Ireland_2007.txt Ireland_2008.txt Ireland_2012.txt Ireland_2015.txt Italy_2004.txt Italy_2005.txt 
Italy_2015.txt
Latvia_2002.txt Latvia_2003.txt Latvia_2012.txt Lithuania_2002.txt Lithuania_2008.txt Lithuania_2011.txt Lithuania_2012.txt Netherlands_2000.txt
Netherlands_2005.txt Netherlands_2007.txt Netherlands_2010.txt Netherlands_2013.txt Norway_2003.txt Norway_2004.txt Norway_2005.txt Norway_2006.txt 
Norway_2008.txt
Norway_2012.txt Norway_2013.txt Poland_2001.txt Poland_2003.txt Poland_2007.txt Poland_2009.txt Poland_2013.txt
Romania_2004.txt Romania_2005.txt Romania_2007.txt Slovakia_2001.txt Slovakia_2003.txt Slovakia_2005.txt
Slovakia_2010_FP.txt Slovakia_2011_FP.txt Slovenia_2004.txt Slovenia_2006.txt Slovenia_2009.txt Spain_2000.txt
Spain_2003.txt Spain_2004.txt Spain_2008.txt Spain_2011.txt Spain_2012.txt Spain_2013.txt Sweden_2003.txt
Sweden_2005.txt Sweden_2015.txt Turkey_2000.txt Turkey_2007.txt United_Kingdom_1998.txt United_Kingdom_1999.txt
United_Kingdom_2002.txt United_Kingdom_2003.txt United_Kingdom_2004.txt United_Kingdom_2005.txt
United_Kingdom_2006.txt United_Kingdom_2010.txt
United_Kingdom_2015.txt United_States_1950.txt United_States_1953.txt United_States_1995.txt United_States_2002.txt
United_States_2004.txt United_States_2006.txt United_States_2008.txt United_States_2010.txt
United_States_2015.txt NATO_1949.txt NATO_1954_MC48.txt NATO_1957.txt NATO_1968.txt NATO_1991.txt NATO_1999.txt
NATO_2010.txt;
			   
			 

	 
			 
#delimit;		     
save wc_temp3.dta, replace;			  


/*Main Text Analysis*/
#delimit;		     
save wc_temp3.dta, replace;			  

#delimit;
set more off;
setref tFrance_2003 0 tUnited_Kingdom_2002  100;

#delimit;
wordscore culture2;

#delimit;
textscore culture2 tAlbania* tAustria* tBelgium* tBulgaria* tCanada* tCroatia* tCzech* tDenmark* tEstonia*
tFinland* tFrance* tGermany* tGreece* tHungary* tIreland* tItaly* tLatvia* tLithuania*
tNetherlands* tNorway* tPoland* tRomania*
tSlovakia* tSlovenia* tSpain* tSweden* tTurkey* tUnited_Kingdom*, mv;

#delimit;		     
save wc_temp3.dta, replace;		


/*Robust to Other Anchors*/
#delimit;
set more off;
setref tFrance_2003 0 tUnited_Kingdom_2003  100;

#delimit;
wordscore culture3;

#delimit;
textscore culture2 tAlbania* tAustria* tBelgium* tBulgaria* tCanada* tCroatia* tCzech* tDenmark* tEstonia*
tFinland* tFrance* tGermany* tGreece* tHungary* tIreland* tItaly* tLatvia* tLithuania*
tNetherlands* tNorway* tPoland* tRomania*
tSlovakia* tSlovenia* tSpain* tSweden* tTurkey* tUnited_Kingdom*, mv;

#delimit;		     
save wc_temp4.dta, replace;	
