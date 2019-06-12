global cluster = ""

use DatCHKL, clear

global i = 1
global j = 1

*Table 7 
mycmd (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
mycmd (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
mycmd (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

