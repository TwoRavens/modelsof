***Analyze Beck and Webb data***
**Beck and Webb data "data-wber.xls" was provided by Thorsten Beck on June 23, 2012. 
**Thorsten Beck recommended SwissRe for the best data on life insurance, though this is not publicly available: http://www.swissre.com/sigma/Data_selling.html

clear
use "beck_webb1.dta"

kountry ccode1, from(cown) to(cowc)
rename _COWC_ abbrev

gen lnlifedeer=log(lifedeer1)
gen lngdppc=log(gdppc1)
corr lngdppc lnlifedeer

*r=0.86

****Examining DVs used by Mousseau 2013: mzongo and mzmid****

clear
cd "$filetree/Eugene"
** "dyad_year_origonly.out.do" is the do file provided by EUGene which generates a dataset of non-directed dyad years, counting originators only for MIDs
do "dyad_year_origonly.out.do"
tab mzongo mzmid, m

*This confirms that Maoz's onset (mzmid) and ongoing (mzongo) MIDs do not correspond to the recommendations of Bennett and Stam, and others. Dyad-years experiencing the onset of a MID are not coded as having a MID ongoing, similarly dyad-years that have an ongoing MID do not have a missing values for onset. One must therefore create such variables from Maoz's basic variables. See also page 40 of Eugene documentation
