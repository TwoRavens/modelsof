***TABLE 1***

use ii_powersharing_hhdata

*MODEL 1*
probit totalps logoppavg stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2

*MODEL 2*
probit totalps rebstronger parity stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2

*MODEL 3*
probit polps logoppavg stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2

*MODEL 4*
probit polps rebstronger parity  stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2

*MODEL 5*
probit terrps logoppavg stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2

*MODEL 6*
probit terrps atleastpar stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2

*MODEL 7*
probit milps logoppavg stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2

*MODEL 8*
probit milps rebstronger parity stake2 lwardur lintensity2 prevdem2 cahlifepostcon systruc2


***TABLE 2***

use ii_powersharing_sdata

*MODEL 9*
probit dwalpact rebstrengthUCDP biasgov biasreb dur war rgdp96pc000 terr dyadpactyrs*, cl(statenum)

*MODEL 10*
probit dwalpact rebstronger parity biasgov biasreb dur war rgdp96pc000 terr dyadpactyrs*, cl(statenum)

*MODEL 11*
probit dwalpolpact rebstrengthUCDP biasgov biasreb dur war rgdp96pc000 terr dyadpolpactyrs*, cl(statenum)

*MODEL 12*
probit dwalpolpact rebstronger parity biasgov biasreb dur war rgdp96pc000 terr dyadpolpactyrs*, cl(statenum)

*MODEL 13*
probit dwalterrpact rebstrengthUCDP biasgov biasreb dur war rgdp96pc000 terr dyadterrpactyrs*, cl(statenum)

*MODEL 14*
probit dwalterrpact atleastparity biasgov biasreb dur war rgdp96pc000 terr dyadterrpactyrs*, cl(statenum)

*MODEL 15*
probit dwalmilpact rebstrengthUCDP biasgov biasreb dur war rgdp96pc000 terr dyadmilpactyrs*, cl(statenum)

*MODEL 16*
probit dwalmilpact rebstronger parity biasgov biasreb dur war rgdp96pc000 terr dyadmilpactyrs*, cl(statenum)

