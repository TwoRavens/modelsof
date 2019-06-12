*Table 2 
*territory
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox territory icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
* Interaction of territory and rivalry 
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox territory thomriva terival icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
*maritime*
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox maritime icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*

* Interaction of maritime and rivalry 
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox maritime thomriva marival icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
*river*
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox river icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*
	
* Interaction of river and rivalry 
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox river thomriva rivrival icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*
