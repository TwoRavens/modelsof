/*GDP estimations*/
/*First difference in growth rates estimations*/
xi: reg d1cgdpg  l.d1cgdpg l.d1unemplg l.d1serateg i.year if  OECDold==1
xi: xtreg d1cgdpg  l.d1cgdpg l.d1unemplg l.d1serateg i.year if  OECDold==1, fe
xi: xtabond2 d1cgdpg l.d1cgdpg l.d1unemplg l.d1serateg i.year if OECDold==1, gmmstyle(L.(d1cgdpg d1unemplg d1serateg), collapse) ivstyle(i.year) robust small
/*HP6 filtered data*/
xi: reg  hp6cdpp l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if  OECDold==1
xi: xtreg  hp6cdpp l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if  OECDold==1, fe
xi: xtabond2  hp6cdpp l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if OECDold==1, gmmstyle(L.(hp6cdpp hp6unemcop hp6seratop), collapse) ivstyle(i.year) robust small
/*HP100 filtered data*/
xi: reg  hp100cdpp l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if  OECDold==1
xi: xtreg  hp100cdpp l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if  OECDold==1, fe
xi: xtabond2  hp100cdpp l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if OECDold==1, gmmstyle(L.(hp100cdpp hp100unemcop hp100seracop), collapse) ivstyle(i.year) robust small

/*Business ownership rate estimations*/
/*First difference in growth rates estimations*/
xi: reg d1serateg  l.d1cgdpg l.d1unemplg l.d1serateg i.year if  OECDold==1
xi: xtreg d1serateg  l.d1cgdpg l.d1unemplg l.d1serateg i.year if  OECDold==1, fe
xi: xtabond2 d1serateg l.d1cgdpg l.d1unemplg l.d1serateg i.year if OECDold==1, gmmstyle(L.(d1cgdpg d1unemplg d1serateg), collapse) ivstyle(i.year) robust small
/*HP6 filtered data*/
xi: reg hp6seratop l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if  OECDold==1
xi: xtreg hp6seratop l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if  OECDold==1, fe
xi: xtabond2 hp6seratop l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if OECDold==1, gmmstyle(L.(hp6cdpp hp6unemcop hp6seratop), collapse) ivstyle(i.year) robust small
/*HP100 filtered data*/
xi: reg hp100seracop l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if  OECDold==1
xi: xtreg hp100seracop l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if  OECDold==1, fe
xi: xtabond2 hp100seracop l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if OECDold==1, gmmstyle(L.(hp100cdpp hp100unemcop hp100seracop), collapse) ivstyle(i.year) robust small

/*Unemployment estimations*/
/*First difference in growth rates estimations*/
xi: reg d1unemplg l.d1cgdpg l.d1unemplg l.d1serateg i.year if  OECDold==1
xi: xtreg d1unemplg l.d1cgdpg l.d1unemplg l.d1serateg i.year if  OECDold==1, fe
xi: xtabond2 d1unemplg l.d1cgdpg l.d1unemplg l.d1serateg i.year if OECDold==1, gmmstyle(L.(d1cgdpg d1unemplg d1serateg), collapse) ivstyle(i.year) robust small
/*HP6 filtered data*/
xi: reg hp6unemcop l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if  OECDold==1
xi: xtreg hp6unemcop l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if  OECDold==1, fe
xi: xtabond2 hp6unemcop l(1/2).hp6cdpp l(1/2).hp6unemcop l(1/2).hp6seratop i.year if OECDold==1, gmmstyle(L.(hp6cdpp hp6unemcop hp6seratop), collapse) ivstyle(i.year) robust small
/*HP100 filtered data*/
xi: reg hp100unemcop l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if  OECDold==1
xi: xtreg hp100unemcop l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if  OECDold==1, fe
xi: xtabond2 hp100unemcop l(1/2).hp100cdpp l(1/2).hp100unemcop l(1/2).hp100seracop i.year if OECDold==1, gmmstyle(L.(hp100cdpp hp100unemcop hp100seracop), collapse) ivstyle(i.year) robust small
