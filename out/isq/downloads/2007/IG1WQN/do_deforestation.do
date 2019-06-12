**ISQ 2006 deforestation model

clear
#delimit ;

use forest.dta, clear;

***deforest to be reported models;
reg deforest dem openc wardum  rgdpl rgdplsq popdense    , robust cluster(cow);

reg deforest demdum openc wardum  rgdpl rgdplsq popdense    , robust cluster(cow);

reg deforest autdum openc wardum  rgdpl rgdplsq popdense    , robust cluster(cow);


***logged forest area ratio;
reg forestlog dem openc wardum  rgdpl rgdplsq popdense    , robust cluster(cow);

reg forestlog demdum openc wardum  rgdpl rgdplsq popdense    , robust cluster(cow);

reg forestlog autdum openc wardum  rgdpl rgdplsq popdense    , robust cluster(cow);
