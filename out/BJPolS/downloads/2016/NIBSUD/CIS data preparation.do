* This code is for Study #2799 of the Centro de Investigaciones Sociologicas (CIS):

gen relsq=p2 if p2<11
gen relid=p3 if p3<11
gen relpsoe=p401 if p401<11
gen relpp=p402 if p402<11
gen reliu=p403 if p403<11

gen relsqcen=relsq-5
gen relidcen=relid-5
gen relpsoecen=relpsoe-5
gen relppcen=relpp-5
gen reliucen=reliu-5

gen reldirsqpsoe=(relid-relsq)*(relpsoe-relsq)
gen reldirsqpp=(relid-relsq)*(relpp-relsq)
gen reldirsqiu=(relid-relsq)*(reliu-relsq)

gen reldirsqpsoecen=(relidcen-relsqcen)*(relpsoecen-relsqcen)
gen reldirsqppcen=(relidcen-relsqcen)*(relppcen-relsqcen)
gen reldirsqiucen=(relidcen-relsqcen)*(reliucen-relsqcen)

gen reldirpsoecen=relidcen*relpsoecen
gen reldirppcen=relidcen*relppcen
gen reldiriucen=relidcen*reliucen

gen relproxpsoecen=abs(relidcen-relpsoecen)
gen relproxppcen=abs(relidcen-relppcen)
gen relproxiucen=abs(relidcen-reliucen)

gen samesiderelpsoe=0
replace samesiderelpsoe=1 if (relid>5 & relpsoe>5) | (relid<5 & relpsoe<5)
replace samesiderelpsoe=. if relid==. | relpsoe==.

gen samesiderelpp=0
replace samesiderelpp=1 if (relid>5 & relpp>5) | (relid<5 & relpp<5)
replace samesiderelpp=. if relid==. | relpp==.

gen samesidereliu=0
replace samesidereliu=1 if (relid>5 & reliu>5) | (relid<5 & reliu<5)
replace samesidereliu=. if relid==. | reliu==.

gen oppsiderelpsoe=0
replace oppsiderelpsoe=1 if (relid>5 & relpsoe<5) | (relid<5 & relpsoe>5)
replace oppsiderelpsoe=. if relid==. | relpsoe==.

gen oppsiderelpp=0
replace oppsiderelpp=1 if (relid>5 & relpp<5) | (relid<5 & relpp>5)
replace oppsiderelpp=. if relid==. | relpp==.

gen oppsidereliu=0
replace oppsidereliu=1 if (relid>5 & reliu<5) | (relid<5 & reliu>5)
replace oppsidereliu=. if relid==. | reliu==.

gen samesiderelpsoesq=0
replace samesiderelpsoesq=1 if (relid>relsq & relpsoe>relsq) | (relid<relsq & relpsoe<relsq)
replace samesiderelpsoesq=. if relid==. | relpsoe==.

gen samesiderelppsq=0
replace samesiderelppsq=1 if (relid>relsq & relpp>relsq) | (relid<relsq & relpp<relsq)
replace samesiderelppsq=. if relid==. | relpp==.

gen samesidereliusq=0
replace samesidereliusq=1 if (relid>relsq & reliu>relsq) | (relid<relsq & reliu<relsq)
replace samesidereliusq=. if relid==. | reliu==.

gen oppsiderelpsoesq=0
replace oppsiderelpsoesq=1 if (relid>relsq & relpsoe<relsq) | (relid<relsq & relpsoe>relsq)
replace oppsiderelpsoesq=. if relid==. | relpsoe==.

gen oppsiderelppsq=0
replace oppsiderelppsq=1 if (relid>relsq & relpp<relsq) | (relid<relsq & relpp>relsq)
replace oppsiderelppsq=. if relid==. | relpp==.

gen oppsidereliusq=0
replace oppsidereliusq=1 if (relid>relsq & reliu<relsq) | (relid<relsq & reliu>relsq)
replace oppsidereliusq=. if relid==. | reliu==.

gen inmsq=p15 if p15<11
gen inmid=p16 if p16<11
gen inmpsoe=p1701 if p1701<11
gen inmpp=p1702 if p1702<11
gen inmiu=p1703 if p1703<11

gen inmsqcen=inmsq-5
gen inmidcen=inmid-5
gen inmpsoecen=inmpsoe-5
gen inmppcen=inmpp-5
gen inmiucen=inmiu-5

gen inmdirsqpsoe=(inmid-inmsq)*(inmpsoe-inmsq)
gen inmdirsqpp=(inmid-inmsq)*(inmpp-inmsq)
gen inmdirsqiu=(inmid-inmsq)*(inmiu-inmsq)

gen inmdirsqpsoecen=(inmidcen-inmsqcen)*(inmpsoecen-inmsqcen)
gen inmdirsqppcen=(inmidcen-inmsqcen)*(inmppcen-inmsqcen)
gen inmdirsqiucen=(inmidcen-inmsqcen)*(inmiucen-inmsqcen)

gen inmdirpsoecen=inmidcen*inmpsoecen
gen inmdirppcen=inmidcen*inmppcen
gen inmdiriucen=inmidcen*inmiucen

gen inmproxpsoecen=abs(inmidcen-relpsoecen)
gen inmproxppcen=abs(inmidcen-relppcen)
gen inmproxiucen=abs(inmidcen-reliucen)

gen samesideinmpsoe=0
replace samesideinmpsoe=1 if (inmid>5 & inmpsoe>5) | (inmid<5 & inmpsoe<5)
replace samesideinmpsoe=. if inmid==. | inmpsoe==.

gen samesideinmpp=0
replace samesideinmpp=1 if (inmid>5 & inmpp>5) | (inmid<5 & inmpp<5)
replace samesideinmpp=. if inmid==. | inmpp==.

gen samesideinmiu=0
replace samesideinmiu=1 if (inmid>5 & inmiu>5) | (inmid<5 & inmiu<5)
replace samesideinmiu=. if inmid==. | inmiu==.

gen oppsideinmpsoe=0
replace oppsideinmpsoe=1 if (inmid>5 & inmpsoe<5) | (inmid<5 & inmpsoe>5)
replace oppsideinmpsoe=. if inmid==. | inmpsoe==.

gen oppsideinmpp=0
replace oppsideinmpp=1 if (inmid>5 & inmpp<5) | (inmid<5 & inmpp>5)
replace oppsideinmpp=. if inmid==. | inmpp==.

gen oppsideinmiu=0
replace oppsideinmiu=1 if (inmid>5 & inmiu<5) | (inmid<5 & inmiu>5)
replace oppsideinmiu=. if inmid==. | inmiu==.

gen samesideinmpsoesq=0
replace samesideinmpsoesq=1 if (inmid>inmsq & inmpsoe>inmsq) | (inmid<inmsq & inmpsoe<inmsq)
replace samesideinmpsoesq=. if inmid==. | inmpsoe==.

gen samesideinmppsq=0
replace samesideinmppsq=1 if (inmid>inmsq & inmpp>inmsq) | (inmid<inmsq & inmpp<inmsq)
replace samesideinmppsq=. if inmid==. | inmpp==.

gen samesideinmiusq=0
replace samesideinmiusq=1 if (inmid>inmsq & inmiu>inmsq) | (inmid<inmsq & inmiu<inmsq)
replace samesideinmiusq=. if inmid==. | inmiu==.

gen oppsideinmpsoesq=0
replace oppsideinmpsoesq=1 if (inmid>inmsq & inmpsoe<inmsq) | (inmid<inmsq & inmpsoe>inmsq)
replace oppsideinmpsoesq=. if inmid==. | inmpsoe==.

gen oppsideinmppsq=0
replace oppsideinmppsq=1 if (inmid>inmsq & inmpp<inmsq) | (inmid<inmsq & inmpp>inmsq)
replace oppsideinmppsq=. if inmid==. | inmpp==.

gen oppsideinmiusq=0
replace oppsideinmiusq=1 if (inmid>inmsq & inmiu<inmsq) | (inmid<inmsq & inmiu>inmsq)
replace oppsideinmiusq=. if inmid==. | inmiu==.

gen nacsq=p5 if p5<11
gen nacid=p6 if p6<11
gen nacpsoe=p701 if p701<11
gen nacpp=p702 if p702<11
gen naciu=p703 if p703<11

gen nacsqcen=nacsq-5
gen nacidcen=nacid-5
gen nacpsoecen=nacpsoe-5
gen nacppcen=nacpp-5
gen naciucen=naciu-5

gen nacdirsqpsoe=(nacid-nacsq)*(nacpsoe-nacsq)
gen nacdirsqpp=(nacid-nacsq)*(nacpp-nacsq)
gen nacdirsqiu=(nacid-nacsq)*(naciu-nacsq)

gen nacdirsqpsoecen=(nacidcen-nacsqcen)*(nacpsoecen-nacsqcen)
gen nacdirsqppcen=(nacidcen-nacsqcen)*(nacppcen-nacsqcen)
gen nacdirsqiucen=(nacidcen-nacsqcen)*(naciucen-nacsqcen)

gen nacdirpsoecen=nacidcen*nacpsoecen
gen nacdirppcen=nacidcen*nacppcen
gen nacdiriucen=nacidcen*naciucen

gen nacproxpsoecen=abs(nacidcen-nacpsoecen)
gen nacproxppcen=abs(nacidcen-nacppcen)
gen nacproxiucen=abs(nacidcen-naciucen)

gen samesidenacpsoe=0
replace samesidenacpsoe=1 if (nacid>5 & nacpsoe>5) | (nacid<5 & nacpsoe<5)
replace samesidenacpsoe=. if nacid==. | nacpsoe==.

gen samesidenacpp=0
replace samesidenacpp=1 if (nacid>5 & nacpp>5) | (nacid<5 & nacpp<5)
replace samesidenacpp=. if nacid==. | nacpp==.

gen samesidenaciu=0
replace samesidenaciu=1 if (nacid>5 & naciu>5) | (nacid<5 & naciu<5)
replace samesidenaciu=. if nacid==. | naciu==.

gen oppsidenacpsoe=0
replace oppsidenacpsoe=1 if (nacid>5 & nacpsoe<5) | (nacid<5 & nacpsoe>5)
replace oppsidenacpsoe=. if nacid==. | nacpsoe==.

gen oppsidenacpp=0
replace oppsidenacpp=1 if (nacid>5 & nacpp<5) | (nacid<5 & nacpp>5)
replace oppsidenacpp=. if nacid==. | nacpp==.

gen oppsidenaciu=0
replace oppsidenaciu=1 if (nacid>5 & naciu<5) | (nacid<5 & naciu>5)
replace oppsidenaciu=. if nacid==. | naciu==.

gen samesidenacpsoesq=0
replace samesidenacpsoesq=1 if (nacid>nacsq & nacpsoe>nacsq) | (nacid<nacsq & nacpsoe<nacsq)
replace samesidenacpsoesq=. if nacid==. | nacpsoe==.

gen samesidenacppsq=0
replace samesidenacppsq=1 if (nacid>nacsq & nacpp>nacsq) | (nacid<nacsq & nacpp<nacsq)
replace samesidenacppsq=. if nacid==. | nacpp==.

gen samesidenaciusq=0
replace samesidenaciusq=1 if (nacid>nacsq & naciu>nacsq) | (nacid<nacsq & naciu<nacsq)
replace samesidenaciusq=. if nacid==. | naciu==.

gen oppsidenacpsoesq=0
replace oppsidenacpsoesq=1 if (nacid>nacsq & nacpsoe<nacsq) | (nacid<nacsq & nacpsoe>nacsq)
replace oppsidenacpsoesq=. if nacid==. | nacpsoe==.

gen oppsidenacppsq=0
replace oppsidenacppsq=1 if (nacid>nacsq & nacpp<nacsq) | (nacid<nacsq & nacpp>nacsq)
replace oppsidenacppsq=. if nacid==. | nacpp==.

gen oppsidenaciusq=0
replace oppsidenaciusq=1 if (nacid>nacsq & naciu<nacsq) | (nacid<nacsq & naciu>nacsq)
replace oppsidenaciusq=. if nacid==. | naciu==.

gen ptvpsoe=p2201 if p2201<11
gen ptvpp=p2202 if p2202<11
gen ptviu=p2203 if p2203<11
gen id=_nexpand 3bysort id: gen stack=_n
gen ptv=ptvpsoe if stack==1
replace ptv=ptvpp if stack==2
replace ptv=ptviu if stack==3

gen samesiderel=samesiderelpsoe if stack==1
replace samesiderel=samesiderelpp if stack==2
replace samesiderel=samesidereliu if stack==3

gen oppsiderel=oppsiderelpsoe if stack==1
replace oppsiderel=oppsiderelpp if stack==2
replace oppsiderel=oppsidereliu if stack==3

gen samesiderelsq=samesiderelpsoesq if stack==1
replace samesiderelsq=samesiderelppsq if stack==2
replace samesiderelsq=samesidereliusq if stack==3

gen oppsiderelsq=oppsiderelpsoesq if stack==1
replace oppsiderelsq=oppsiderelppsq if stack==2
replace oppsiderelsq=oppsidereliusq if stack==3

gen reldirsqcen=reldirsqpsoecen if stack==1
replace reldirsqcen=reldirsqppcen if stack==2
replace reldirsqcen=reldirsqiucen if stack==3

gen reldircen=reldirpsoecen if stack==1
replace reldircen=reldirppcen if stack==2
replace reldircen=reldiriucen if stack==3

gen relproxcen=relproxpsoecen if stack==1
replace relproxcen=relproxppcen if stack==2
replace relproxcen=relproxiucen if stack==3

gen reldirsq=reldirsqpsoe if stack==1
replace reldirsq=reldirsqpp if stack==2
replace reldirsq=reldirsqiu if stack==3

gen samesidenac=samesidenacpsoe if stack==1
replace samesidenac=samesidenacpp if stack==2
replace samesidenac=samesidenaciu if stack==3

gen oppsidenac=oppsidenacpsoe if stack==1
replace oppsidenac=oppsidenacpp if stack==2
replace oppsidenac=oppsidenaciu if stack==3

gen samesidenacsq=samesidenacpsoesq if stack==1
replace samesidenacsq=samesidenacppsq if stack==2
replace samesidenacsq=samesidenaciusq if stack==3

gen oppsidenacsq=oppsidenacpsoesq if stack==1
replace oppsidenacsq=oppsidenacppsq if stack==2
replace oppsidenacsq=oppsidenaciusq if stack==3

gen nacdirsqcen=nacdirsqpsoecen if stack==1
replace nacdirsqcen=nacdirsqppcen if stack==2
replace nacdirsqcen=nacdirsqiucen if stack==3

gen nacdircen=nacdirpsoecen if stack==1
replace nacdircen=nacdirppcen if stack==2
replace nacdircen=nacdiriucen if stack==3

gen nacproxcen=nacproxpsoecen if stack==1
replace nacproxcen=nacproxppcen if stack==2
replace nacproxcen=nacproxiucen if stack==3

gen nacdirsq=nacdirsqpsoe if stack==1
replace nacdirsq=nacdirsqpp if stack==2
replace nacdirsq=nacdirsqiu if stack==3

gen samesideinm=samesideinmpsoe if stack==1
replace samesideinm=samesideinmpp if stack==2
replace samesideinm=samesideinmiu if stack==3

gen oppsideinm=oppsideinmpsoe if stack==1
replace oppsideinm=oppsideinmpp if stack==2
replace oppsideinm=oppsideinmiu if stack==3

gen samesideinmsq=samesideinmpsoesq   if stack==1
replace samesideinmsq=samesideinmppsq if stack==2
replace samesideinmsq=samesideinmiusq if stack==3

gen oppsideinmsq=oppsideinmpsoesq   if stack==1
replace oppsideinmsq=oppsideinmppsq if stack==2
replace oppsideinmsq=oppsideinmiusq if stack==3

gen inmdirsqcen=inmdirsqpsoecen if stack==1
replace inmdirsqcen=inmdirsqppcen if stack==2
replace inmdirsqcen=inmdirsqiucen if stack==3

gen inmdircen=inmdirpsoecen if stack==1
replace inmdircen=inmdirppcen if stack==2
replace inmdircen=inmdiriucen if stack==3

gen inmproxcen=inmproxpsoecen if stack==1
replace inmproxcen=inmproxppcen if stack==2
replace inmproxcen=inmproxiucen if stack==3

gen inmdirsq=inmdirsqpsoe if stack==1
replace inmdirsq=inmdirsqpp if stack==2
replace inmdirsq=inmdirsqiu if stack==3

gen cat=0
replace cat=1 if ccaa==9

gen pv=0
replace pv=1 if ccaa==16

gen esp=0
replace esp=1 if cat==0 & pv==0

ge reldirsame=reldirsqcen*samesiderel
ge reldiropp=reldirsqcen*oppsiderel

ge inmdirsame=inmdirsqcen*samesideinm
ge inmdiropp=inmdirsqcen*oppsideinm

ge nacdirsame=nacdirsqcen*samesidenac
ge nacdiropp=nacdirsqcen*oppsidenac

gen nacsqonopposite = 0 if nacsqcen * nacidcen < . 
replace nacsqonopposite = 1 if nacsqcen * nacidcen < 0
gen nacsqonsame = 0 if nacsqcen * nacidcen < . 
replace nacsqonsame = 1 if nacsqcen * nacidcen > 0

gen relsqonopposite = 0 if relsqcen * relidcen < .
replace relsqonopposite = 1 if relsqcen * relidcen < 0 
gen relsqonsame = 0 if relsqcen * relidcen < .
replace relsqonsame = 1 if relsqcen * relidcen > 0 

gen inmsqonopposite = 0 if inmsqcen * inmidcen < .
replace inmsqonopposite = 1 if inmsqcen * inmidcen < 0 
gen inmsqonsame = 0 if inmsqcen * inmidcen < .
replace inmsqonsame = 1 if inmsqcen * inmidcen > 0 

local vars reldircen reldirsq inmdircen inmdirsq nacdircen nacdirsq 
foreach var of local vars {
sum `var'
gen `var'_01sd = ((`var' - r(min)) / (r(sd)))
}

save "Spain ed.dta", replace
****************************************************************************************************************

