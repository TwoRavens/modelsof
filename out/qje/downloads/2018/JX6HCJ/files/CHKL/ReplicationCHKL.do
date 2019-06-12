
****************************************************************************

*Table 7 - All okay

*File provided by Yan Chen which identifies those who were not randomized - otherwise identical, simply lets me identify non-randomized participants
use 20071512R2-w17SpecialSs, clear
	
gen dumcontr = (expcondition == "control") 
gen dumconf = (expcondition == "conformity")
gen dumnetb = (expcondition == "netben")

tobit post_rating dumconf dumnetb pre_rating, ll 
tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

save DatCHKL, replace




*************************************************************************










