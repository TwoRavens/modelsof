
/*globalization & repression*/
clear
set more off
set matsize 800
set mem 80m
use invrep-replicate
sort ccode year
tsset ccode year

/*lags and logs*/
gen lpop=ln(pop)
gen polity2l=L.polity2
replace polity2l=polity2 if cmark==1
gen lfdi=.
replace lfdi=ln(fdiinflow+1) if fdiinflow>0
replace lfdi=-ln(-fdiinflow+1) if fdiinflow<0
replace lfdi=0 if fdiinflow==0
gen lfdil=L.lfdi
replace lfdil=lfdi if cmark==1
gen lfdi2=.
replace lfdi2=ln(fdiinflow2+1) if fdiinflow2>0
replace lfdi2=-ln(-fdiinflow2+1) if fdiinflow2<0
replace lfdi2=0 if fdiinflow2==0
gen lfdi2l=L.lfdi2
replace lfdi2l=lfdi2 if cmark==1
gen lfpi=.
replace lfpi=ln(fpi+1) if fpi>0
replace lfpi=-ln(-fpi+1) if fpi<0
replace lfpi=0 if fpi==0
gen lfpil=L.lfpi
replace lfpil=lfpi if cmark==1
gen linternet=ln(internet+1)
gen linternetl=L.linternet
replace linternetl=linternet if cmark==1
gen kaopenl=L.kaopen
replace kaopenl=kaopen if cmark==1
gen lfdiinward=ln(fdiinward+1)
gen lfpistock=ln(fpistock+1)
gen lfdistockl=L.lfdiinward
replace lfdistockl=lfdiinward if cmark==1
gen lfdiinward2=ln(fdiinward2+1)
gen lfdistock2l=L.lfdiinward2
replace lfdistock2l=lfdiinward2 if cmark==1
gen lfpistockl=L.lfpistock
replace lfpistockl=lfpistock if cmark==1
gen rgdpchl=L.rgdpch
replace rgdpchl=rgdpch if cmark==1
gen lrgdpch=ln(rgdpch)
gen lrgdpchl=L.lrgdpch
replace lrgdpchl=lrgdpch if cmark==1
gen lpopl=L.lpop
replace lpopl=lpop if cmark==1
gen dopen=kaopen-kaopenl
gen dopenl=L.dopen
gen yearl=L.year
replace yearl=year-1 if cmark==1
gen extconfl=L.extconf
replace extconfl=extconf if cmark==1
gen avgrepl=L.avgrep
gen physintl=L.physint
gen lresources=ln(resources+1)
gen lresourcesl=L.lresources
replace lresourcesl=lresources if cmark==1
gen grgdpchl=L.grgdpch
replace grgdpchl=grgdpch if cmark==1
gen lgrowthl=.
replace lgrowthl=ln(grgdpchl) if grgdpchl>0
replace lgrowthl=-ln(-grgdpchl) if grgdpchl<0
gen openkl=L.openk
replace openkl=openk if cmark==1
gen lopenk=ln(openk)
gen lopenkl=L.lopenk
replace lopenkl=lopenk if cmark==1
gen flel=L.fle
replace flel=fle if cmark==1
gen oil2l=L.oil2
replace oil2l=oil2 if cmark==1
gen macl=L.mac
replace macl=mac if cmark==1
gen interrel=L.interreg
replace interrel=interreg if cmark==1

log using invrep-replicate.txt, t replace

/*Table 1 Models*/

xi: tobit avgrep i.avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl , ll(1) ul(5)
xi: tobit physint i.physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl, ll(0) ul(8) 

/*grabbing imputed data*/
clear
use outisq1
sort ccode year
save, replace
use bronset6
sort ccode year
merge ccode year using outisq1, unique update
drop _merge
tsset ccode year

gen polity2l=L.polity2
replace polity2l=polity2 if cmark==1
gen lfdi=.
replace lfdi=ln(fdiinflow+1) if fdiinflow>0
replace lfdi=-ln(-fdiinflow+1) if fdiinflow<0
replace lfdi=0 if fdiinflow==0
gen lfdil=L.lfdi
replace lfdil=lfdi if cmark==1
gen lfdi2=.
replace lfdi2=ln(fdiinflow2+1) if fdiinflow2>0
replace lfdi2=-ln(-fdiinflow2+1) if fdiinflow2<0
replace lfdi2=0 if fdiinflow2==0
gen lfdi2l=L.lfdi2
replace lfdi2l=lfdi2 if cmark==1
gen lfpi=.
replace lfpi=ln(fpi+1) if fpi>0
replace lfpi=-ln(-fpi+1) if fpi<0
replace lfpi=0 if fpi==0
gen lfpil=L.lfpi
replace lfpil=lfpi if cmark==1
gen linternet=ln(internet+1)
gen linternetl=L.linternet
replace linternetl=linternet if cmark==1
gen kaopenl=L.kaopen
replace kaopenl=kaopen if cmark==1
gen lfdiinward=ln(fdiinward+1)
gen lfpistock=ln(fpistock+1)
gen lfdistockl=L.lfdiinward
replace lfdistockl=lfdiinward if cmark==1
gen lfdiinward2=ln(fdiinward2+1)
gen lfdistock2l=L.lfdiinward2
replace lfdistock2l=lfdiinward2 if cmark==1
gen lfpistockl=L.lfpistock
replace lfpistockl=lfpistock if cmark==1
gen rgdpchl=L.rgdpch
replace rgdpchl=rgdpch if cmark==1
gen lrgdpch=ln(rgdpch)
gen lrgdpchl=L.lrgdpch
replace lrgdpchl=lrgdpch if cmark==1
gen lpopl=L.lpop
replace lpopl=lpop if cmark==1
gen dopen=kaopen-kaopenl
gen dopenl=L.dopen
gen yearl=L.year
replace yearl=year-1 if cmark==1
gen extconfl=L.extconf
replace extconfl=extconf if cmark==1
gen avgrepl=L.avgrep
gen physintl=L.physint
gen lresources=ln(resources+1)
gen lresourcesl=L.lresources
replace lresourcesl=lresources if cmark==1
gen grgdpchl=L.grgdpch
replace grgdpchl=grgdpch if cmark==1
gen lgrowthl=.
replace lgrowthl=ln(grgdpchl) if grgdpchl>0
replace lgrowthl=-ln(-grgdpchl) if grgdpchl<0
gen openkl=L.openk
replace openkl=openk if cmark==1
gen lopenk=ln(openk)
gen lopenkl=L.lopenk
replace lopenkl=lopenk if cmark==1
gen flel=L.fle
replace flel=fle if cmark==1
gen oil2l=L.oil2
replace oil2l=oil2 if cmark==1
gen macl=L.mac
replace macl=mac if cmark==1
gen interrel=L.interreg
replace interrel=interreg if cmark==1
summarize avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl kaopenl linternetl lresourcesl physint physintl lfpistockl lfpil lfdi2l if occupied~=1 & year>1980

/*Table 1 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1 & year>1980, pairwise

/*Table 2 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1 & year>1980, pairwise

/*Tables 3 & 4 Models*/
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1
predict fdihat, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat if occupied~=1, pairwise
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & rgdpchl<7430
predict fdihat2, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat2 if occupied~=1 & rgdpchl<7430, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980
predict fdihat3 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat3 if occupied~=1 & year>1980, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980 & rgdpchl<7430
predict fdihat4 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat4 if occupied~=1 & year>1980 & rgdpchl<7430, pairwise

clear
use outisq2
sort ccode year
save, replace
use bronset6
sort ccode year
merge ccode year using outisq2, unique update
drop _merge
tsset ccode year

gen polity2l=L.polity2
replace polity2l=polity2 if cmark==1
gen lfdi=.
replace lfdi=ln(fdiinflow+1) if fdiinflow>0
replace lfdi=-ln(-fdiinflow+1) if fdiinflow<0
replace lfdi=0 if fdiinflow==0
gen lfdil=L.lfdi
replace lfdil=lfdi if cmark==1
gen lfdi2=.
replace lfdi2=ln(fdiinflow2+1) if fdiinflow2>0
replace lfdi2=-ln(-fdiinflow2+1) if fdiinflow2<0
replace lfdi2=0 if fdiinflow2==0
gen lfdi2l=L.lfdi2
replace lfdi2l=lfdi2 if cmark==1
gen lfpi=.
replace lfpi=ln(fpi+1) if fpi>0
replace lfpi=-ln(-fpi+1) if fpi<0
replace lfpi=0 if fpi==0
gen lfpil=L.lfpi
replace lfpil=lfpi if cmark==1
gen linternet=ln(internet+1)
gen linternetl=L.linternet
replace linternetl=linternet if cmark==1
gen kaopenl=L.kaopen
replace kaopenl=kaopen if cmark==1
gen lfdiinward=ln(fdiinward+1)
gen lfpistock=ln(fpistock+1)
gen lfdistockl=L.lfdiinward
replace lfdistockl=lfdiinward if cmark==1
gen lfdiinward2=ln(fdiinward2+1)
gen lfdistock2l=L.lfdiinward2
replace lfdistock2l=lfdiinward2 if cmark==1
gen lfpistockl=L.lfpistock
replace lfpistockl=lfpistock if cmark==1
gen rgdpchl=L.rgdpch
replace rgdpchl=rgdpch if cmark==1
gen lrgdpch=ln(rgdpch)
gen lrgdpchl=L.lrgdpch
replace lrgdpchl=lrgdpch if cmark==1
gen lpopl=L.lpop
replace lpopl=lpop if cmark==1
gen dopen=kaopen-kaopenl
gen dopenl=L.dopen
gen yearl=L.year
replace yearl=year-1 if cmark==1
gen extconfl=L.extconf
replace extconfl=extconf if cmark==1
gen avgrepl=L.avgrep
gen physintl=L.physint
gen lresources=ln(resources+1)
gen lresourcesl=L.lresources
replace lresourcesl=lresources if cmark==1
gen grgdpchl=L.grgdpch
replace grgdpchl=grgdpch if cmark==1
gen lgrowthl=.
replace lgrowthl=ln(grgdpchl) if grgdpchl>0
replace lgrowthl=-ln(-grgdpchl) if grgdpchl<0
gen openkl=L.openk
replace openkl=openk if cmark==1
gen lopenk=ln(openk)
gen lopenkl=L.lopenk
replace lopenkl=lopenk if cmark==1
gen flel=L.fle
replace flel=fle if cmark==1
gen oil2l=L.oil2
replace oil2l=oil2 if cmark==1
gen macl=L.mac
replace macl=mac if cmark==1
gen interrel=L.interreg
replace interrel=interreg if cmark==1
summarize avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl kaopenl linternetl lresourcesl physint physintl lfpistockl lfpil lfdi2l if occupied~=1 & year>1980

/*Table 1 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1 & year>1980, pairwise

/*Table 2 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1 & year>1980, pairwise

/*Tables 3 & 4 Models*/
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1
predict fdihat, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat if occupied~=1, pairwise
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & rgdpchl<7430
predict fdihat2, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat2 if occupied~=1 & rgdpchl<7430, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980
predict fdihat3 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat3 if occupied~=1 & year>1980, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980 & rgdpchl<7430
predict fdihat4 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat4 if occupied~=1 & year>1980 & rgdpchl<7430, pairwise


clear
use outisq3
sort ccode year
save, replace
use bronset6
sort ccode year
merge ccode year using outisq3, unique update
drop _merge
tsset ccode year

gen polity2l=L.polity2
replace polity2l=polity2 if cmark==1
gen lfdi=.
replace lfdi=ln(fdiinflow+1) if fdiinflow>0
replace lfdi=-ln(-fdiinflow+1) if fdiinflow<0
replace lfdi=0 if fdiinflow==0
gen lfdil=L.lfdi
replace lfdil=lfdi if cmark==1
gen lfdi2=.
replace lfdi2=ln(fdiinflow2+1) if fdiinflow2>0
replace lfdi2=-ln(-fdiinflow2+1) if fdiinflow2<0
replace lfdi2=0 if fdiinflow2==0
gen lfdi2l=L.lfdi2
replace lfdi2l=lfdi2 if cmark==1
gen lfpi=.
replace lfpi=ln(fpi+1) if fpi>0
replace lfpi=-ln(-fpi+1) if fpi<0
replace lfpi=0 if fpi==0
gen lfpil=L.lfpi
replace lfpil=lfpi if cmark==1
gen linternet=ln(internet+1)
gen linternetl=L.linternet
replace linternetl=linternet if cmark==1
gen kaopenl=L.kaopen
replace kaopenl=kaopen if cmark==1
gen lfdiinward=ln(fdiinward+1)
gen lfpistock=ln(fpistock+1)
gen lfdistockl=L.lfdiinward
replace lfdistockl=lfdiinward if cmark==1
gen lfdiinward2=ln(fdiinward2+1)
gen lfdistock2l=L.lfdiinward2
replace lfdistock2l=lfdiinward2 if cmark==1
gen lfpistockl=L.lfpistock
replace lfpistockl=lfpistock if cmark==1
gen rgdpchl=L.rgdpch
replace rgdpchl=rgdpch if cmark==1
gen lrgdpch=ln(rgdpch)
gen lrgdpchl=L.lrgdpch
replace lrgdpchl=lrgdpch if cmark==1
gen lpopl=L.lpop
replace lpopl=lpop if cmark==1
gen dopen=kaopen-kaopenl
gen dopenl=L.dopen
gen yearl=L.year
replace yearl=year-1 if cmark==1
gen extconfl=L.extconf
replace extconfl=extconf if cmark==1
gen avgrepl=L.avgrep
gen physintl=L.physint
gen lresources=ln(resources+1)
gen lresourcesl=L.lresources
replace lresourcesl=lresources if cmark==1
gen grgdpchl=L.grgdpch
replace grgdpchl=grgdpch if cmark==1
gen lgrowthl=.
replace lgrowthl=ln(grgdpchl) if grgdpchl>0
replace lgrowthl=-ln(-grgdpchl) if grgdpchl<0
gen openkl=L.openk
replace openkl=openk if cmark==1
gen lopenk=ln(openk)
gen lopenkl=L.lopenk
replace lopenkl=lopenk if cmark==1
gen flel=L.fle
replace flel=fle if cmark==1
gen oil2l=L.oil2
replace oil2l=oil2 if cmark==1
gen macl=L.mac
replace macl=mac if cmark==1
gen interrel=L.interreg
replace interrel=interreg if cmark==1
summarize avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl kaopenl linternetl lresourcesl physint physintl lfpistockl lfpil lfdi2l if occupied~=1 & year>1980

/*Table 1 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1 & year>1980, pairwise

/*Table 2 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1 & year>1980, pairwise

/*Tables 3 & 4 Models*/
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1
predict fdihat, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat if occupied~=1, pairwise
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & rgdpchl<7430
predict fdihat2, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat2 if occupied~=1 & rgdpchl<7430, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980
predict fdihat3 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat3 if occupied~=1 & year>1980, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980 & rgdpchl<7430
predict fdihat4 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat4 if occupied~=1 & year>1980 & rgdpchl<7430, pairwise

clear
use outisq4
sort ccode year
save, replace
use bronset6
sort ccode year
merge ccode year using outisq4, unique update
drop _merge
tsset ccode year

gen polity2l=L.polity2
replace polity2l=polity2 if cmark==1
gen lfdi=.
replace lfdi=ln(fdiinflow+1) if fdiinflow>0
replace lfdi=-ln(-fdiinflow+1) if fdiinflow<0
replace lfdi=0 if fdiinflow==0
gen lfdil=L.lfdi
replace lfdil=lfdi if cmark==1
gen lfdi2=.
replace lfdi2=ln(fdiinflow2+1) if fdiinflow2>0
replace lfdi2=-ln(-fdiinflow2+1) if fdiinflow2<0
replace lfdi2=0 if fdiinflow2==0
gen lfdi2l=L.lfdi2
replace lfdi2l=lfdi2 if cmark==1
gen lfpi=.
replace lfpi=ln(fpi+1) if fpi>0
replace lfpi=-ln(-fpi+1) if fpi<0
replace lfpi=0 if fpi==0
gen lfpil=L.lfpi
replace lfpil=lfpi if cmark==1
gen linternet=ln(internet+1)
gen linternetl=L.linternet
replace linternetl=linternet if cmark==1
gen kaopenl=L.kaopen
replace kaopenl=kaopen if cmark==1
gen lfdiinward=ln(fdiinward+1)
gen lfpistock=ln(fpistock+1)
gen lfdistockl=L.lfdiinward
replace lfdistockl=lfdiinward if cmark==1
gen lfdiinward2=ln(fdiinward2+1)
gen lfdistock2l=L.lfdiinward2
replace lfdistock2l=lfdiinward2 if cmark==1
gen lfpistockl=L.lfpistock
replace lfpistockl=lfpistock if cmark==1
gen rgdpchl=L.rgdpch
replace rgdpchl=rgdpch if cmark==1
gen lrgdpch=ln(rgdpch)
gen lrgdpchl=L.lrgdpch
replace lrgdpchl=lrgdpch if cmark==1
gen lpopl=L.lpop
replace lpopl=lpop if cmark==1
gen dopen=kaopen-kaopenl
gen dopenl=L.dopen
gen yearl=L.year
replace yearl=year-1 if cmark==1
gen extconfl=L.extconf
replace extconfl=extconf if cmark==1
gen avgrepl=L.avgrep
gen physintl=L.physint
gen lresources=ln(resources+1)
gen lresourcesl=L.lresources
replace lresourcesl=lresources if cmark==1
gen grgdpchl=L.grgdpch
replace grgdpchl=grgdpch if cmark==1
gen lgrowthl=.
replace lgrowthl=ln(grgdpchl) if grgdpchl>0
replace lgrowthl=-ln(-grgdpchl) if grgdpchl<0
gen openkl=L.openk
replace openkl=openk if cmark==1
gen lopenk=ln(openk)
gen lopenkl=L.lopenk
replace lopenkl=lopenk if cmark==1
gen flel=L.fle
replace flel=fle if cmark==1
gen oil2l=L.oil2
replace oil2l=oil2 if cmark==1
gen macl=L.mac
replace macl=mac if cmark==1
gen interrel=L.interreg
replace interrel=interreg if cmark==1
summarize avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl kaopenl linternetl lresourcesl physint physintl lfpistockl lfpil lfdi2l if occupied~=1 & year>1980

/*Table 1 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1 & year>1980, pairwise

/*Table 2 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1 & year>1980, pairwise

/*Tables 3 & 4 Models*/
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1
predict fdihat, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat if occupied~=1, pairwise
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & rgdpchl<7430
predict fdihat2, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat2 if occupied~=1 & rgdpchl<7430, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980
predict fdihat3 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat3 if occupied~=1 & year>1980, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980 & rgdpchl<7430
predict fdihat4 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat4 if occupied~=1 & year>1980 & rgdpchl<7430, pairwise

clear
use outisq5
sort ccode year
save, replace
use bronset6
sort ccode year
merge ccode year using outisq5, unique update
drop _merge
tsset ccode year

gen polity2l=L.polity2
replace polity2l=polity2 if cmark==1
gen lfdi=.
replace lfdi=ln(fdiinflow+1) if fdiinflow>0
replace lfdi=-ln(-fdiinflow+1) if fdiinflow<0
replace lfdi=0 if fdiinflow==0
gen lfdil=L.lfdi
replace lfdil=lfdi if cmark==1
gen lfdi2=.
replace lfdi2=ln(fdiinflow2+1) if fdiinflow2>0
replace lfdi2=-ln(-fdiinflow2+1) if fdiinflow2<0
replace lfdi2=0 if fdiinflow2==0
gen lfdi2l=L.lfdi2
replace lfdi2l=lfdi2 if cmark==1
gen lfpi=.
replace lfpi=ln(fpi+1) if fpi>0
replace lfpi=-ln(-fpi+1) if fpi<0
replace lfpi=0 if fpi==0
gen lfpil=L.lfpi
replace lfpil=lfpi if cmark==1
gen linternet=ln(internet+1)
gen linternetl=L.linternet
replace linternetl=linternet if cmark==1
gen kaopenl=L.kaopen
replace kaopenl=kaopen if cmark==1
gen lfdiinward=ln(fdiinward+1)
gen lfpistock=ln(fpistock+1)
gen lfdistockl=L.lfdiinward
replace lfdistockl=lfdiinward if cmark==1
gen lfdiinward2=ln(fdiinward2+1)
gen lfdistock2l=L.lfdiinward2
replace lfdistock2l=lfdiinward2 if cmark==1
gen lfpistockl=L.lfpistock
replace lfpistockl=lfpistock if cmark==1
gen rgdpchl=L.rgdpch
replace rgdpchl=rgdpch if cmark==1
gen lrgdpch=ln(rgdpch)
gen lrgdpchl=L.lrgdpch
replace lrgdpchl=lrgdpch if cmark==1
gen lpopl=L.lpop
replace lpopl=lpop if cmark==1
gen dopen=kaopen-kaopenl
gen dopenl=L.dopen
gen yearl=L.year
replace yearl=year-1 if cmark==1
gen extconfl=L.extconf
replace extconfl=extconf if cmark==1
gen avgrepl=L.avgrep
gen physintl=L.physint
gen lresources=ln(resources+1)
gen lresourcesl=L.lresources
replace lresourcesl=lresources if cmark==1
gen grgdpchl=L.grgdpch
replace grgdpchl=grgdpch if cmark==1
gen lgrowthl=.
replace lgrowthl=ln(grgdpchl) if grgdpchl>0
replace lgrowthl=-ln(-grgdpchl) if grgdpchl<0
gen openkl=L.openk
replace openkl=openk if cmark==1
gen lopenk=ln(openk)
gen lopenkl=L.lopenk
replace lopenkl=lopenk if cmark==1
gen flel=L.fle
replace flel=fle if cmark==1
gen oil2l=L.oil2
replace oil2l=oil2 if cmark==1
gen macl=L.mac
replace macl=mac if cmark==1
gen interrel=L.interreg
replace interrel=interreg if cmark==1
summarize avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl kaopenl linternetl lresourcesl physint physintl lfpistockl lfpil lfdi2l if occupied~=1 & year>1980

/*Table 1 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if occupied~=1 & year>1980, pairwise

/*Table 2 Models*/
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1, pairwise
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdistock2l lfpistockl yearl if rgdpchl<7430 & occupied~=1 & year>1980, pairwise
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel lfdi2l lfpil yearl if occupied~=1 & year>1980, pairwise

/*Tables 3 & 4 Models*/
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1
predict fdihat, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat if occupied~=1, pairwise
regress lfdistock2l avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & rgdpchl<7430
predict fdihat2, xb
xtpcse avgrep avgrepl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat2 if occupied~=1 & rgdpchl<7430, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980
predict fdihat3 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat3 if occupied~=1 & year>1980, pairwise
regress lfdistock2l physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl linternetl kaopenl lresourcesl flel if occupied~=1 & year>1980 & rgdpchl<7430
predict fdihat4 if e(sample), xb
xtpcse physint physintl lrgdpchl lopenkl polity2l lpopl extconfl macl warl interrel yearl fdihat4 if occupied~=1 & year>1980 & rgdpchl<7430, pairwise

log close

