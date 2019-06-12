***ISQ 2006 NOX model

#delimit ;

use nox.dta, clear;
reg noxpcleadlog dem openc   war  rgdpl rgdplsq popdense  , robust  ;

reg noxpcleadlog demdum openc   war  rgdpl rgdplsq popdense  , robust  ;

reg noxpcleadlog autdum openc   war  rgdpl rgdplsq popdense  , robust  ;

