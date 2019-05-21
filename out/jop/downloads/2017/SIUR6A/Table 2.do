*TOP PORTION OF TABLE 2: ARE SUPPORTERS MORE LIKELY TO VOTE ON IMMIGRATION AS AN ISSUE?
local X likelyvote i.w2 i.w3
local demog female c.age c.age2 i.educat inc4 i.hisp c.perc_hispanic c.perc_hispanic2
local econ i.econ_country i.econ_house
local feeling c.ft_hisp c.ft_as
local pol i.pid3 i.ideo3

*TOP PORTION OF TABLE 2: ARE SUPPORTERS MORE LIKELY TO VOTE ON IMMIGRATION AS AN ISSUE?
logit `X' `demog' `econ' `feeling' `pol' if whiteevan==1 & reform_support5>50 & reform_support5<=100, cluster(wustlid)
margins w2, at(w3=0)
margins w3, at(w2=0)
margins, at(w2=0 w3=0)


*BOTTOM PORTION OF TABLE 2: ARE OPPONENTS LESS LIKELY TO VOTE ON IMMIGRATION AS AN ISSUE?
logit `X'  `demog' `econ' `feeling' `pol'  if whiteevan==1 & reform_support5<50 & reform_support5>=0, cluster(wustlid)
margins w2, at(w3=0)
margins w3, at(w2=0)
margins, at(w2=0 w3=0)

