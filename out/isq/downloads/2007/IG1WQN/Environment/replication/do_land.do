**ISQ 2006 land degradation model

#delimit ;

use land.dta, clear;
reg land2log dem openclog war  rgdplog rgdplogsq popdenselog   , robust ;

reg land2log demdum openclog war  rgdplog rgdplogsq popdenselog   , robust ;

reg land2log autdum openclog war  rgdplog rgdplogsq popdenselog   , robust ;
