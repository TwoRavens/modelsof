*do-file for "Enemies with benefits? Violent rivalry and terrorist group longevity," JPR, Brian J. Phillips.

*table 1 primary models
logit failure violentrival ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3, robust cluster(groupid) 
logit failure rivalinter rivalintra ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3, robust cluster(groupid) 

*table 2 robustness checks
*rival=1 only if group "born" with rival
logit failure rival1styr ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3, robust cluster(groupid) 
logit failure rivalinter1styr rivalintra1styr ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3, robust cluster(groupid) 
*only groups founded in 1987 or later
logit failure violentrival ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3 if leftcensor==0, robust cluster(groupid) 
logit failure rivalinter rivalintra ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3 if leftcensor==0, robust cluster(groupid) 

*online appendix models
*"victory" groups excluded
logit failure violentrival ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3 if victory!=1, robust cluster(groupid) 
logit failure rivalinter rivalintra ally ethnic religious statesponsored drugs size transnational logpop loggdppc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3 if victory!=1, robust cluster(groupid) 
*military spending per capita instead of GDPPC as measure of state capacity
logit failure violentrival ally ethnic religious statesponsored drugs size transnational logpop milex_pc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3, robust cluster(groupid) 
logit failure rivalinter rivalintra ally ethnic religious statesponsored drugs size transnational logpop milex_pc regimetype repression namerica samerica europe ssafrica asia spline1 spline2 spline3, robust cluster(groupid) 
