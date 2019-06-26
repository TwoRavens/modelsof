stcox  polity2  gdpconstpc  warinitiation90onsum  deathmag90onsum type2dummy90onsum  type3and4domesticdummy90onsum type4abroaddummy90onsum  , robust strata(wbregions) nohr
outreg using c:\table1, replace 3aster
stcox  polity2  gdpconstpc  warinitiation90onsum  deathmag90onsum type2dummy90onsum  type3and4domesticdummy90onsum miltroopsnumber  , robust strata(wbregions) nohr
outreg using c:\table1, append 3aster
stcox  polity2  gdpconstpc  warinitiation90onsum  deathmag90onsum type2dummy90onsum  type3and4domesticdummy90onsum type4abroaddummy90onsum  miltroopsnumber  , robust strata(wbregions) nohr
outreg using c:\table1, append 3aster

stcox  polity2  gdpconstpc  warinitiation90onsum  deathmag90onsum type2dummy90onsum  type3and4domesticdummy90onsum type4abroaddummy90onsum  if developed==1, robust strata(wbregions) nohr
outreg using c:\table3, replace 3aster
stcox  polity2  gdpconstpc  warinitiation90onsum  deathmag90onsum type2dummy90onsum  type3and4domesticdummy90onsum miltroopsnumber   if developed==1, robust strata(wbregions) nohr
outreg using c:\table3, append 3aster
stcox  polity2  gdpconstpc  warinitiation90onsum  deathmag90onsum type2dummy90onsum  type3and4domesticdummy90onsum type4abroaddummy90onsum  miltroopsnumber  if developed==1 , robust strata(wbregions) nohr
outreg using c:\table3, append 3aster
