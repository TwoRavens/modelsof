
* Voting left

xtmelogit vleft redpref1 c.incomedif age i.gender education i.religion i.union i.euroesec ///
forpop socgdp i.year if (brncntr==1) || country:
xtmelogit, or

xtmelogit vleft redpref1 i.year if (brncntr==1) || country:
xtmelogit, or

* Voting populist right

xtmelogit vpopright redpref1 c.incomedif age i.gender education i.religion i.union i.euroesec ///
forpop socgdp i.year if (brncntr==1) || country:
xtmelogit, or

xtmelogit vpopright redpref1 i.year if (brncntr==1) || country:
xtmelogit, or




