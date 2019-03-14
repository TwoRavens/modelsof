********** Clearvoice Analysis **********

*** Note: these data were part of a larger data collection effort for an unrelated project. You will notice that the total
* # of respondents in the spreadsheet is larger than the effective # of respondents participating in this particular 
* portion of the study. These extra respondents are list-wise deleted automatically in the analyses to follow

*** Individual Issues ***

mlogit timm cue, b(0)
mlogit timm cue, b(-1)

estsimp mlogit timm cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit tcuts cue, b(0)
mlogit tcuts cue, b(-1)

estsimp mlogit tcuts cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit tchina cue, b(0)
mlogit tchina cue, b(-1)

estsimp mlogit tchina cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit ttax cue, b(0)
mlogit ttax cue, b(-1)

estsimp mlogit ttax cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


mlogit tgold cue, b(0)
mlogit tgold cue, b(-1)

estsimp mlogit tgold cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4


*** Averaging over issues ***

gen subj=_n

rename timm iss1
rename tcuts iss2
rename tchina iss3
rename ttax iss4
rename tgold iss5

reshape long iss, i(subj) j(issue)


mlogit iss cue, b(0)
mlogit iss cue, b(-1)

estsimp mlogit iss cue, b(-1)
setx mean
simqi, fd(pr) changex(cue 0 1)
simqi, fd(pr) changex(cue 0 1) level(68)
drop b1-b4














































