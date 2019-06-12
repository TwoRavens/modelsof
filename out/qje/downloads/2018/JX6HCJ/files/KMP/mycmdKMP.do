global cluster = "id"

use DatKMP, clear

global i = 1
global j = 1

*Table 2 
mycmd (money bottle pricetag choice origami) reg characters money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami) reg characters money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami) reg characters_correct money bottle pricetag choice origami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)
mycmd (money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami) reg characters_correct money bottle pricetag choice origami timemoney timebottle timepricetag timechoice timeorigami time wave2 age  male  room2 room3 room4 room5 weekday2-weekday5 afternoon, robust cluster(id)

