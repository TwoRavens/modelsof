*Table 4 *

* Comparison Group =  demterival *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid) 
	stcox demternonrival demnonterival demnonternonriv mixterival mixnonterival mixternonrival ///
      mixnonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*

* Comparison Group =  demnonterival *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid)	
	stcox demterival demternonrival demnonternonriv mixterival mixnonterival mixternonrival ///
      mixnonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*
 
* Comparison Group =  demternonrival *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid)
	stcox demterival demnonterival demnonternonriv mixterival mixnonterival mixternonrival ///
      mixnonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*

* Comparison Group =  demnonternonriv *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid)
	stcox demterival demnonterival demternonrival mixterival mixnonterival mixternonrival ///
      mixnonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*

* Comparison Group =  mixterival *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid)
	stcox demterival demnonterival demternonrival demnonternonriv mixnonterival mixternonrival ///
      mixnonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*

* Comparison Group =  mixnonterival *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid)
	stcox demterival demnonterival demternonrival demnonternonriv mixterival mixternonrival ///
      mixnonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*

* Comparison Group =  mixternonrival *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid)
	stcox demterival demnonterival demternonrival demnonternonriv mixterival mixnonterival ///
      mixnonternonriv icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*

* Comparison Group =  mixnonternonriv *
	stset time, failure(midissyr) id(ddyadidclaim2) exit(time .) enter(time0tfpemid)
	stcox demterival demnonterival demternonrival demnonternonriv mixterival mixnonterival mixternonrival ///
      icowsal recno5 recmid5 contig150 lnrelcap allies if year>1900, shared(ddyadidclaim2) ///
	schoenfeld(sch*) scaledsch(sca*)
	stphtest, detail
	drop sch* sca*
