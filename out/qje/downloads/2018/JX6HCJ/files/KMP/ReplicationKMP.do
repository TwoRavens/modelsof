
*Table 1 is Wilcoxon with Fisher exact inference

use "20100161_dataset.dta", clear

*Table 2 - Constants are all wrong, but all other coef & se correct (must have reversed some dummies)

reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)

save DatKMP, replace


