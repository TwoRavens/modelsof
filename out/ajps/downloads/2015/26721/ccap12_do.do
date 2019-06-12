recode pp_obamaapp (1=1) (2=.75)(3=.25)(4=0)(5=.5), into(approve5_11)

recode obamaapp  (1=1) (2=.75)(3=.25)(4=0)(5=.5)(8/9=.), into(approve5_12)

recode	pp_pid7	(1=0)	(2=.1667)(3=.333)(4=.5)(5=.667)(6=.8333)(7=1)(8=.5)(9=.),	into(pid11)

recode pp_ideo5 (1=0) (2=.25)(3=.5)(4=.75)(5=1)(6=.5), into(ideology11)

recode educ (1=0)(2=.25)(3/4=.5)(5=.75)(6=1), into(edu)

recode race (2=1) (1=0)(3/99=0), into (black)

recode gender (1=1)(2=0), into(male)

gen agerev = (birthyr-1994)

gen age = (agerev/77)*-1

recode pp_gays_t (997=50)(999=.), into (gaytherm)

gen gaytherm1 = gaytherm/100

recode period (10000/12032=0)(12033/12300=1)(12100/15000=2), into(announce3)

recode period (10000/12032=0)(12033/12300=1)(12100/15000=.), into(announce2)

recode pp_imiss_g (1=1)(2/4=0), into(gayimport2)

recode pp_imiss_g (1=1)(2/3=.5)(4=0), into(gayimport3)

recode pp_imiss_g (1=1)(2/3=0)(4=1), into(gayimport0_1)

recode pp_imiss_g (1=1)(2/3=0)(4=1), into(gayimport0_1)

gen announce_import = announce2*gayimport2

gen gaytherm_announce = gaytherm1*announce2

gen gaytherm_import = gaytherm1*gayimport2

gen gaytherm3int = gaytherm1*gayimport2*announce2

gen approve_announce = approve5_11*announce2

gen approve_import = approve5_11*gayimport2

gen approve3int = approve5_11*gayimport2*announce2

gen pid_announce = pid11*announce2

gen pid_import = pid11*gayimport2

gen pid3int = pid11*gayimport2*announce2

gen ideol_announce = ideology*announce2

gen ideol_import = ideology*gayimport2

gen ideol3int = ideology*gayimport2*announce2

gen edu_announce = edu*announce2

gen edu_import = edu*gayimport2

gen edu3int = edu*gayimport2*announce2

gen black_announce = black*announce2

gen black_import = black*gayimport2

gen black3int = black*gayimport2*announce2

gen male_announce = male*announce2

gen male_import = male*gayimport2

gen male3int = male*gayimport2*announce2


gen age_announce = age*announce2

gen age_import = age*gayimport2

gen age3int = age*gayimport2*announce2




################Table A5/Figure ##########################################

by announce3, sort: reg approve5_12 gaytherm1 approve5_11 pid11 ideology edu black male age [pweight=weight]

################Table 1####################

reg approve5_12 gaytherm1 gaytherm_announce gaytherm_import gaytherm3int approve5_11 approve_announce approve_import approve3int pid11 pid_announce pid_import pid3int ideology ideol_announce ideol_import ideol3int edu edu_announce edu_import edu3int black black_announce black_import black3int male male_announce male_import male3int age age_announce age_import age3int announce_import  announce2 gayimport2  if gayimport0_1  [pweight=weight]

reg approve5_12 gaytherm1 gaytherm_announce gaytherm_import gaytherm3int approve5_11 approve_announce approve_import approve3int pid11 pid_announce pid_import pid3int ideology ideol_announce ideol_import ideol3int edu edu_announce edu_import edu3int black black_announce black_import black3int male male_announce male_import male3int age age_announce age_import age3int announce_import announce2 gayimport2  if gayimport3>0  [pweight=weight]

by gayimport3, sort: reg approve5_12 gaytherm1 gaytherm_announce gaytherm_import gaytherm3int approve5_11 approve_announce approve_import approve3int pid11 pid_announce pid_import pid3int ideology ideol_announce ideol_import ideol3int edu edu_announce edu_import edu3int black black_announce black_import black3int male male_announce male_import male3int age age_announce age_import age3int announce_import announce2 gayimport2  [pweight=weight]
