Table 3

set more off
probit killdum structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol structad kill_spline1 kill_spline2 kill_spline3, robust 

set more off
probit torturedum structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol structad torture_spline1 torture_spline2 torture_spline3, robust 

set more off
probit polprisdum structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol structad polpris_spline1 polpris_spline2 polpris_spline3, robust

set more off
probit disappdum structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol structad disapp_spline1 disapp_spline2 disapp_spline3, robust 


Table 4, 5, & 6

set more off
set matsize 250
biprobit (killdum = structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol killdumpeaceyrs kill_spline1 kill_spline2 kill_spline3)(structad gdpchng resrvs ofxchg gdppc trdgdp hrspect newunion allncdm democautoc mldm logpop coldwar francecol UKcol USAcol japcol  riots interstate structadpeaceyrs structadpeaceyearsdqd struct_spline1 struct_spline2 struct_spline3), robust 
predict killpred, equation(killdum)
replace killpred=0 if killpred<=.5
replace killpred=1 if killpred>.5
tab killpred killdum, col row

set more off
set matsize 250
biprobit (torturedum = structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol  torturedumpeaceyrs torture_spline1 torture_spline2 torture_spline3)(structad gdpchng resrvs ofxchg gdppc trdgdp hrspect newunion allncdm democautoc mldm logpop coldwar francecol UKcol USAcol japcol  riots interstate structadpeaceyrs  structadpeaceyearsdqd struct_spline1 struct_spline2 struct_spline3), robust 
predict torturepred, equation(torturedum)
replace torturepred=0 if torturepred<=.5
replace torturepred=1 if torturepred>.5
tab torturepred torturedum, col row

set more off
set matsize 250
biprobit (polprisdum = structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol polprisdumpeaceyrs polpris_spline1 polpris_spline2 polpris_spline3)(structad gdpchng resrvs ofxchg gdppc trdgdp hrspect newunion allncdm democautoc mldm logpop coldwar francecol UKcol USAcol japcol  riots interstate  structadpeaceyrs  structadpeaceyearsdqd struct_spline1 struct_spline2 struct_spline3), robust 
predict polprispred, equation(polprisdum)
replace polprispred=0 if polprispred<=.5
replace polprispred=1 if polprispred>.5
tab polprispred polprisdum, col row

set more off
set matsize 250
biprobit (disappdum = structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol disappdumpeaceyrs disapp_spline1 disapp_spline2 disapp_spline3)(structad gdpchng resrvs ofxchg gdppc trdgdp hrspect newunion allncdm democautoc mldm logpop coldwar francecol UKcol USAcol japcol  riots interstate structadpeaceyrs structadpeaceyearsdqd struct_spline1 struct_spline2 struct_spline3), robust 
predict disappdumpred, equation(disappdum)
replace disappdumpred=0 if disappdumpred<=.5
replace disappdumpred=1 if disappdumpred>.5
tab disappdumpred disappdum, col row

set more off
set matsize 250
biprobit (killdum = structadimpl2 structad gdppc gdpchng democautoc  mldm logpop poppercntchng interstate internal UKcol killdumpeaceyrs kill_spline1 kill_spline2 kill_spline3)(structad gdpchng resrvs ofxchg gdppc trdgdp hrspect newunion allncdm democautoc mldm logpop coldwar francecol UKcol USAcol japcol  riots interstate structadpeaceyrs structadpeaceyearsdqd struct_spline1 struct_spline2 struct_spline3), robust 
predict structadpred, equation(structad)
replace structadpred=0 if structadpred<=.5
replace structadpred=1 if structadpred>.5
tab structadpred structad, col row

