
****************************************
****************************************

use DatKMP, clear

*Table 2 

global i = 1

reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1
reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4, cluster(id)
test money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami
matrix F = (r(p), r(drop), r(df), r(chi2), 2)

drop _all
svmat double F
save results/SuestKMP, replace


