*Table 3 - with mids and territory compared to (river and maritime) as the base
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox territory icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900 & thomriva==0, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox territory icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900 & thomriva==1, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
*Table 3 - with mids and maritime compared to (river and territory) as the base
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox maritime icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900 & thomriva==0, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*

	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox maritime icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900 & thomriva==1, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
*Table 3 - with mids and river compared to (territory and maritime) as the base
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox river icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900 & thomriva==0, ///
	shared(ddyadidclaim2)  schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*
	
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox river icowsal recno5 recmid5 contig150 lnrelcap allies jntd6 if year>1900 & thomriva==1, ///
	shared(ddyadidclaim2) schoenfeld(sch*) scaledsch(sca*) 
	stphtest, detail
	drop sch* sca*


