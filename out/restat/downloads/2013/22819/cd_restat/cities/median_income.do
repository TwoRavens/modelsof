**************************************************************************************
*			Do-file to extract median income     at city level           *
*                                 from census 1970-1990                              *
**************************************************************************************

clear
cap log close
set mem 500m

use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\1990\median_income"
     
append using "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\1980\DA8038.REV\median_income1980"

save "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\cities\median income\median_income_cities", replace
