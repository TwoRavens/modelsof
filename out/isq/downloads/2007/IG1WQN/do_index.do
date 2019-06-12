
**ISQ 2006 index variable model


#delimit ;

use index.dta, clear;

reg system dem openc   war  rgdpl rgdplsq popdense  , robust  ;

reg system demdum openc   war  rgdpl rgdplsq popdense, robust  ;

reg system autdum openc   war  rgdpl rgdplsq popdense  , robust  ;

reg stress dem openc   war  rgdpl rgdplsq popdense  , robust  ;

reg stress demdum openc   war  rgdpl rgdplsq popdense , robust  ;

reg stress autdum openc   war  rgdpl rgdplsq popdense  , robust  ;

