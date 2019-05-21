
use database_parties, clear
do variables_parties

********************************************************************************

* Do graph

set scheme s1color

DCdensity running, breakpoint(0) h(0.25) generate(X1j Y1j r10 f1hat s1e_fhat) graphname(mccrary_bwdefault.eps)  
drop X1j Y1j r10 f1hat s1e_fhat
