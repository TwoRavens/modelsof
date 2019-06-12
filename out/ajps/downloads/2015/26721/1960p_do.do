##########Variable recoding#############

recode v560270 (1=1)(3=.5)(5=0) (9=.), into(catholictrust56)

recode v600735  (1=1)(3=.5)(5=0) (9=.), into(catholictrust60)

recode v560088 (1=.1667) (2=.333)(3=.5)(8=.5) (4=.667) (5=.833)(6=1)(7/9=.), into(pid56)

recode v560190 (1/12=1)(13/99=0), into(lowincome56)

recode v560190 (1/22=0)(23/96=1)(97/99=0), into(highincome56)

recode v560171  (1=1)(2/9=0), into (male)

recode v560172  (1=0)(2=1)(3/9=0), into(black)

recode v560181 (0=0)(1=.125)(2=.25)(3=.375)(4=.5)(5=.625)(6=.75)(7=.875)(8=1)(9/99=.), into(edu)

recode v560175 (0=0)(1=.1667)(2=.333)(3=.5)(4=.667)(5=.833)(6=1)(9=.), into(agegroup)

recode v560203 (11=1)(12=0)(13/99=.), into(demvote56)

recode v560203 (11=1)(12=0)(21=.75)(22=.25)(28=.5)(13/14=.)(23/24=.)(29/99=.), into(demvote5_56)

recode v600767 (10=1)(20=0)(21/99=.), into(demvote60)

recode v600767 (10=1)(20=0)(70=.75)(80=.25)(30/60=.)(98=.5)(90/97=.)(99=.), into(demvote5_60)

gen voted_5660 = demvote56*demvote60

gen ch_demsupport = demvote5_60-demvote5_56

gen ch_cathtrust = catholictrust60-catholictrust56

############Table A1##################

logit demvote56 catholictrust56 pid56 edu highincome56 lowincome56 male black agegroup if voted_5660<=1

logit demvote60 catholictrust56 pid56 edu highincome56 lowincome56 male black agegroup if voted_5660<=1

############Table A2##################

reg ch_demsupport  catholictrust56 demvote5_56  pid56 edu highincome lowincome male black agegroup

reg ch_cathtrust  catholictrust56 demvote5_56  pid56 edu highincome lowincome male black agegroup

############Figure 1A##################

logit demvote56 catholictrust56 pid56 edu highincome56 lowincome56 male black agegroup if voted_5660<=1

adjust pid56 edu highincome56 lowincome56 male black agegroup, by(catholictrust56) pr ci 


logit demvote60 catholictrust56 pid56 edu highincome56 lowincome56 male black agegroup if voted_5660<=1

adjust pid56 edu highincome56 lowincome56 male black agegroup, by(catholictrust56) pr ci 

############Figure 1B##################

reg ch_demsupport  catholictrust56 demvote5_56  pid56 edu highincome lowincome male black agegroup

adjust demvote5_56  pid56 edu highincome lowincome male black agegroup, by(catholictrust56) ci

############Figure 1C##################
reg ch_cathtrust  catholictrust56 demvote5_56  pid56 edu highincome lowincome male black agegroup

adjust catholictrust56  pid56 edu highincome lowincome male black agegroup, by(demvote5_56) ci

