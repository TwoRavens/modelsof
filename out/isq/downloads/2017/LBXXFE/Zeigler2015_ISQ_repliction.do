***** Doyle and Sambanis models for Zeigler ISQ 2015


***model 1

global time ttf
global event recur
global xlist allysum1_all allysum2_all
global group allysum2_all


stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  


***Model 2

global time ttf
global event recur
global xlist allysum1_all allysum2_all veto govvict rebvict numrebstrength newwartype major lnwardur polity2 lifes eh
global group allysum2_all

describe $time $event $xlist
summarize $time $event $xlist

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  



***Model 3

global time ttf
global event recur
global xlist allysum1 allysum2
global group allysum2

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  


***Model 4

global time ttf
global event recur
global xlist allysum1 allysum2 veto govvict rebvict numrebstrength newwartype major lnwardur polity2 lifes eh
global group allysum2


stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)   


*** Model 11

global time ttf
global event recur
global xlist veto
global group veto

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  


*** Model 12

global time ttf
global event recur
global xlist allysum1_all allysum2_all veto
global group veto

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  


*** Model 13

global time ttf
global event recur
global xlist allysum1 allysum2 veto
global group veto

stset $time, failure($event)


*sts graph, by($group) 

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID) 




** Model 17

global time ttf
global event recur
global xlist allysum1 allysum2 milcompallyb1 veto milout1 numrebstrength newwartype major lnwardur polity2 lifes eh
global group milcompallyb1

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  


*** Model 18

global time ttf
global event recur
global xlist allysum1 allysum2 vgovcompallyb1 veto govvict rebvict numrebstrength newwartype major lnwardur polity2 lifes eh
global group vgovcompallyb1

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  



***Model 19

global time ttf
global event recur
global xlist allysum1 allysum2 vrebcompallyb1 veto govvict rebvict numrebstrength newwartype major lnwardur polity2 lifes eh
global group vrebcompallyb1

stset $time, failure($event)


*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  


***now D&S half of figure 1 of predicted surviver functions

stcurve, survival at1(rebvict=0) at2(rebvict=1) at3(vrebcompallyb1=1) range(0 8500)

* alternatively: 
* stcurve, survival at1(rebvict=1 allysum2=0) at2(rebvict=1 allysum2=1) at3(rebvict=0 allysum2=1)





****for sup appendix 
**model 1 supp

global time ttf
global event recur
global xlist allysum1 allysum2 veto govvict rebvict newwartype interven unintrvn lnwardur gdpcap gini polity2 illit
global group allysum2


stset $time, failure($event)


sts graph, by($group) 

sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  



**model 2 supp

global time ttf
global event recur
global xlist allysum1 allysum2 veto govvict rebvict newwartype interven unintrvn costcap gdpcap gini polity2 illit
global group allysum2

*describe $time $event $xlist
*summarize $time $event $xlist

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster clustID)  



* (check results again with logcost instead and results hold) 
*global time ttf
*global event recur
*global xlist allysum1 allysum2 veto govvict rebvict newwartype interven unintrvn logcost gdpcap gini polity2 illit
*global group allysum2

*stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

*stcox $xlist, nohr 
*stcox $xlist, vce( cluster clustID)  




***** Now ACD modles models for Zeigler ISQ 2015

*** Model 5

global time time_any_rcr
global event recur_any
global xlist ally_a compally_a
global group compally_a

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id) 

**Model 6

global time time_any_rcr
global event recur_any
global xlist ally_a compally_a veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef
global group compally_a

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id) 


*** Model 7

global time time_any_rcr
global event recur_any
global xlist ally_b compally_b
global group compally_b

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)   


**Model 8

global time time_any_rcr
global event recur_any
global xlist ally_b compally_b veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef
global group compally_b

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)   


**Model 9

global time time_recur
global event recur
global xlist ally_a compally_a veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef
global group compally_a

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  


** Model 10

global time time_recur
global event recur
global xlist ally_b compally_b veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef
global group compally_b

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)


**Model 14 

global time time_recur
global event recur
global xlist veto 
global group veto

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id) 


**Model 15 

global time time_recur
global event recur
global xlist ally_a compally_a veto 
global group veto

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  


***Model 16

global time time_recur
global event recur
global xlist ally_b compally_b veto 
global group veto

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  



***Model 20 

global time time_recur
global event recur
global xlist ally_b compally_b milcompallyb veto mil1 lowother1 rebstrong wartype pko lndur polity ef
global group milcompallyb

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  


***Model 21 prime


global time time_recur
global event recur
global xlist ally_b compally_b vgovcompallyb veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef
global group vgovcompallyb

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  


***Model 22 prime

global time time_recur
global event recur
global xlist ally_b compally_b vrebcompallyb veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef
global group vrebcompallyb


stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  


*** switch omitted category to low/other for model 23
global time time_recur
global event recur
global xlist ally_b compally_b vrebcompallyb veto govwin1 rebwin1 agrcease1 rebstrong wartype pko lndur polity ef
global group vrebcompallyb

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  



**** ACD half of figure 1 of predicted surviver functions

stcurve, survival at3(rebwin1 =0) at4(rebwin1 =1) at5(vrebcompallyb=1) range (0 10000)


*** Sup appendix 


*model 3 supp
global time time_any_rcr
global event recur_any
global xlist ally_a compally_a veto newgovwin rebwin1 rebstrong wartype pko lndur polity ef
global group compally_a

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id) 
 


*model 4 supp

global time time_any_rcr
global event recur_any
global xlist ally_b compally_b veto newgovwin rebwin1 rebstrong wartype pko lndur polity ef
global group compally_b

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)   


*model 5 supp

global time time_recur
global event recur
global xlist ally_a compally_a veto newgovwin rebwin1 rebstrong wartype pko lndur polity ef
global group compally_a

stset $time, failure($event)

*sts graph, by($group) 

*sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)  



***model 6 sup

global time time_recur
global event recur
global xlist ally_b compally_b veto newgovwin rebwin1 rebstrong wartype pko lndur polity ef
global group compally_b

stset $time, failure($event)

sts graph, by($group) 

sts test $group

stcox $xlist, nohr 
stcox $xlist, vce( cluster id)


*** for post estimation log-likelihoot ratio tests in supp file



stcox ally_b compally_b milcompallyb veto mil1 lowother1 rebstrong wartype pko lndur polity ef, nohr

estimates store m7

stcox ally_b compally_b veto mil1 lowother1 rebstrong wartype pko lndur polity ef, nohr

lrtest . m7



stcox ally_b compally_b vgovcompallyb veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef, nohr

estimates store m10

stcox ally_b compally_b veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef, nohr

lrtest . m10



ally_b compally_b vrebcompallyb veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef

stcox ally_b compally_b veto govwin1 rebwin1 vrebcompallyb lowother1 rebstrong wartype pko lndur polity ef, nohr

estimates store m4

stcox ally_b compally_b veto govwin1 rebwin1 lowother1 rebstrong wartype pko lndur polity ef, nohr

lrtest . m4





