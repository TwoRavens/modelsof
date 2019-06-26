


/* Tests for Bussmann JPR 2010 "Foreign Direct Investment and Militarized International Conflicts*/

version 10

*TABLE 1
use BussmanndyadicFDIconflictdata, clear

*COLUMN 1
probit fatal1  smlinflowsgdpim smldem lrgdem  smlrgdp96pcG demdev smldep dircont lncaprat py _spline* , cluster(dyadid) nolog

*COLUMN 2
probit fatal1  smloutflowsgdpim smldem lrgdem  smlrgdp96pcG demdev smldep dircont lncaprat py _spline* , cluster(dyadid) nolog

*COLUMN 3
probit fatal1  smlstockgdpim smldem lrgdem  smlrgdp96pcG demdev smldep dircont lncaprat py _spline* , cluster(dyadid) nolog



*TABLES 2 AND 3
use BussmannmonadicFDIconflictdata, clear


*FDI INFLOWS

*TABLE 2, COLUMN 2
ivprobit fatalonset demoprie lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3 (linflowsgdpim=L1linflowsgdpim lgdpG lrgdp96pcG growth democrat DURABLE lopenG), robust cluster(state)  

*TABLE 2, COLUMN 1
probit fatalonset capratio demoprie lrgdp96pcG py _spline1 _spline2 _spline3 lopenG  linflowsgdpim if e(sample), robust cluster(state)

*TABLE 3, COLUMN 1
xtreg  linflowsgdpim L1linflowsgdpim  lgdpG  lrgdp96pcG growth  democrat  DURABLE lopenG  fatalonset if e(sample), fe

*TABLE 3, COLUMN 2
xtivreg linflowsgdpim L1linflowsgdpim lgdpG  lrgdp96pcG growth democrat  DURABLE lopenG  (fatalonset=demoprie  lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3) if e(sample), fe 

*TABLE 3, COLUMN 3
cdsimeq (linflowsgdpim L1linflowsgdpim lgdpG  lrgdp96pcG growth democrat  DURABLE lopenG) (fatalonset demoprie  lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3) 



*FDI OUTFLOWS

*TABLE 2, COLUMN 4
ivprobit fatalonset demoprie lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3 (loutflowsgdpim=L1loutflowsgdpim lgdpG lrgdp96pcG growth democrat DURABLE lopenG), robust cluster(state)  

*TABLE 2, COLUMN 3
probit fatalonset capratio demoprie lrgdp96pcG py _spline1 _spline2 _spline3 lopenG  loutflowsgdpim if e(sample), robust cluster(state)

*TABLE 3, COLUMN 4
xtreg  loutflowsgdpim L1loutflowsgdpim  lgdpG  lrgdp96pcG growth  democrat  DURABLE lopenG  fatalonset if e(sample), fe

*TABLE 3, COLUMN 5
xtivreg loutflowsgdpim L1loutflowsgdpim lgdpG  lrgdp96pcG growth democrat  DURABLE lopenG  (fatalonset=demoprie  lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3) if e(sample), fe 

*TABLE 3, COLUMN 6
cdsimeq (loutflowsgdpim L1loutflowsgdpim lgdpG  lrgdp96pcG growth democrat  DURABLE lopenG)  (fatalonset  demoprie  lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3) 



*FDI STOCK

*TABLE 2, COLUMN 6
ivprobit fatalonset demoprie lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3 (lstockgdpim=L1lstockgdpim lgdpG lrgdp96pcG growth democrat DURABLE lopenG), robust cluster(state)  

*TABLE 2, COLUMN 5
probit fatalonset capratio demoprie lrgdp96pcG py _spline1 _spline2 _spline3 lopenG  lstockgdpim if e(sample), robust cluster(state)

*TABLE 3, COLUMN 7
xtreg  lstockgdpim L1lstockgdpim  lgdpG  lrgdp96pcG growth  democrat  DURABLE lopenG  fatalonset if e(sample), fe

*TABLE 2, COLUMN 8
xtivreg lstockgdpim L1lstockgdpim lgdpG  lrgdp96pcG growth democrat  DURABLE lopenG  (fatalonset=demoprie  lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3) if e(sample), fe 

*TABLE 3, COLUMN 9
cdsimeq (lstockgdpim L1lstockgdpim lgdpG  lrgdp96pcG growth democrat  DURABLE lopenG)  (fatalonset   demoprie  lopenG lrgdp96pcG capratio py _spline1 _spline2 _spline3) 

