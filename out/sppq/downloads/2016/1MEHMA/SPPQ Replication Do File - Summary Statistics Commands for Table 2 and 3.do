***Command for Average Contribution by State: Table 2***


*Summary statistics command for contribution by state*

 
bysort state_2: sum amount_2012index, d


*Summary statistics command for contribution throughout the states*


sum amount_2012index, d



***Command for summary statistics of contributions by election format and candidate status: Table 3***



*Summary statistics command for contribution by election format and year*

bysort partisan_elect_rev2: sum amount_2012index if cycle_2000==1



bysort partisan_elect_rev2: sum amount_2012index if cycle_2002==1



bysort partisan_elect_rev2: sum amount_2012index if cycle_2004==1



bysort partisan_elect_rev2: sum amount_2012index if cycle_2006==1



bysort partisan_elect_rev2: sum amount_2012index if cycle_2008==1



bysort partisan_elect_rev2: sum amount_2012index if cycle_2010==1



bysort partisan_elect_rev2: sum amount_2012index if cycle_2012==1



*Summary statistics command for contribution by election format for all years*

bysort partisan_elect_rev2: sum amount_2012index 



***Summary statistics command for contribution by candidate status and year***


bysort incumbent: sum amount_2012index if cycle_2000==1



bysort incumbent: sum amount_2012index if cycle_2002==1



bysort incumbent: sum amount_2012index if cycle_2004==1



bysort incumbent: sum amount_2012index if cycle_2006==1



bysort incumbent: sum amount_2012index if cycle_2008==1



bysort incumbent: sum amount_2012index if cycle_2010==1



bysort incumbent: sum amount_2012index if cycle_2012==1



*Summary statistics command for contribution by candidate status for all years*


bysort incumbent: sum amount_2012index
