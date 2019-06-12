**These commands reproduce the results presented in Table 1

probit timelimit hetplus meanplus logfatyear ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 

probit timelimit hetplus meanplus logdeploy ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 


** These commands reproduce the results presented in Table 2 

probit more hetplus meanplus logfatyear ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 

probit more hetplus meanplus logdeploy ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 

** These commands reproduce the results presented in Table 3

probit few hetplus meanplus logfatyear ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 

probit few hetplus meanplus logdeploy ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 


** These commands reproduce the results presented in Table 4

oprobit morespec hetplus meanplus logfatyear ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 

oprobit morespec hetplus meanplus logdeploy ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 


** These commands reproduce Figure 1
oprobit morespec hetplus meanplus logfatyear ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 

predict sd d a sa sb
lab var sd "Pr(morespec==0)"
lab var d "Pr(morespec==1)"
lab var a "Pr(morespec==2)"
lab var sa "Pr(morespec==3)"
lab var sb "Pr(morespec==4)"

quietly oprobit morespec hetplus meanplus logfatyear ch7 repeat contraband lnbatdead loggarm victory resolutions counter, cluster(ccode) robust nolog 

prgen meanplus, from(0) to (2) x(ch7=0 repeat=0 victory=0 contraband=0) generate(w89)

twoway(line w89s0 w89x)(line w89s1 w89x)(line w89s2 w89x)(line w89s3 w89x)(line w89s4 w89x) xtitle("Affinity")
	ytitle("Cumulative Probability") ylabel(0(.25)1)) 
	
**I'll confess that we did the region labelling in the graphing editor rather than from the command line.	
