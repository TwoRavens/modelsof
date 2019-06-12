*These variables are already included in the uploaded dataset.
*creation of legitimacy variable
gen legit1 = q11
gen legit2 = q12
gen legit3 = q13
recode legit3 1=5 2=4 4=2 5=1
gen legit4 = q14
recode legit4 1=5 2=4 4=2 5=1

gen legittot0 = legit1+legit2+legit3+legit4-4

*creation of court awareness variable

gen aware1 = q5
gen aware2 = q6

recode aware1 1=4 2=3 3=2 4=1
recode aware2 1=6 2=5 3=4 4=3 5=2 6=1

gen a101 = (aware1-1)/3
gen a201 = (aware2-1)/5

gen awaretot = a101+a201
gen aware01 = awaretot/2

*creation of perceived election fairness variable

gen elect1 = q1
gen elect2 = q2
recode elect1 1=5 2=4 4=2 5=1
gen electtot = elect1+elect2
gen elect01 = (electtot-2)/8

*creation of support for rule of law variable
gen rlaw1 = q3
gen rlaw2 = q4
gen rlawtot = rlaw1+rlaw2
gen rlaw01 = (rlawtot-2)/8

*ideological self-placement
gen ideo = ideo5
recode ideo 6=.
gen ideo01 = (ideo-1)/4

*perceived ideological disagreement

gen ideodiff = q20
*creates dichomtomous indicators for each level of perceived ideological disagreement  - id1 id2 id3 id4 id5
tab ideodiff, gen(id)

*political interest 

gen interest = newsint
recode interest 7=.
gen interest01 = abs(interest-4)/3

*demographic control variables
gen female = gender
recode female 2=1 1=0

gen black = race
recode black 1=0 2=1 3/max=0

gen hispanic = race
recode hispanic 1/2=0 3=1 4/max=0

gen age = 2012-birthyr
gen age10 = age/10

gen educ01 = (educ-1)/5

*dichomotmous variables representing when openumber above 75th percentile state or below 25th percentile state.

*state above 75th percentile
gen openhigh = abs(appointment-1)
recode openhigh 1=0 if opennumber<6.5

*state below 25th percentile
gen openlow = abs(appointment-1)
recode openlow 1=0 if opennumber>3.5

*all other states in middle
gen openmid = abs(appointment-1)
recode openmid 1=0 if opennumber<3.5
recode openmid 1=0 if opennumber>6.5

****creation of slightly different categorization of states
**variable combining partisan and non-partisan into one multi-candidate election category
gen compelect = partisan
recode compelect 0=1 if nonpartisan==1

**Creating variable indicating states with partisan primaries and non-partisan general
gen partisanprimary = 0
recode partisanprimary 0=1 if inputstate==26|inputstate==39

**Creating variable indicating states with initial partisan elections and retentions afterwards
gen retentionaftercomp = 0
recode retentionaftercomp 0=1 if inputstate==17|inputstate==35|inputstate==42

*coding state labels where states with partisan primaries and non-partisan general considered partisan election states
gen partisanwithMIOH = partisan
recode partisanwithMIOH 0=1 if partisanprimary==1
gen nonpartisannoMIOH = nonpartisan
recode nonpartisannoMIOH 1=0 if partisanprimary==1

*coding state labels where retention election after multi-candidate elections considered a retention election state
gen retentionplus = retention
recode retentionplus 0=1 if retentionaftercomp==1
gen partisanminus = partisan
recode partisanminus 1=0 if retentionaftercomp==1

**Creation of mean-centered variables that will be used to calculate the predicted values for Figures 2 and 3 as well as all predicted values discussed in the analysis.
*Means calculated using following command
mean  rlaw01 aware01  elect01 educ01 age10 interest01 ideo01 black hispanic female if aware1>1 [pweight=weight]
*creation of mean-centered variables
gen rlaw01mean = rlaw01-.6638728 
gen aware01mean = aware01 -  .5666329
gen elect01mean = elect01- .6412848 
gen educ01mean = educ01-.4763994
gen age10mean = age10-4.835063
gen interest01mean = interest01- .785836
gen ideo01mean = ideo01-.5374513
gen blackmean = black-.1079011
gen hispanicmean = hispanic- .0694131
gen femalemean = female- .5029413
