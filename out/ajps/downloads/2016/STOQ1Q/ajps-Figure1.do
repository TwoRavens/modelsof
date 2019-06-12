// Do file that contains the code to construct Figure 1 in the main text.

	use "\\micro.intra\projekt\P0559$\P0559_gem\Data_AJPS\AJPSData", clear
	set matsize 10000
	
	replace Kon=-1*(Kon-2)
	gen InvBakgrund=Utl!=22 if Utl<.
	
	keep if cID==1
	bysort LopNr: gen occ=_n
	bysort LopNr: egen mNom=max(maxNom)
	bysort LopNr: egen mVald=max(maxVald)
	bysort LopNr: egen AntNom=total(maxNom)
	bysort LopNr: egen AntVald=total(maxVald)
	
	keep mNom mVald AntNom AntVald RefStatus13ar Kon FodelseAr* ReformAr InvBakgrund Kommun Ar Klass* occ firstcohort_13 UtbAr
	keep if inrange(FodelseAr, 1938, 1958)
	keep if occ==1
	
	bysort FodelseAr Kommun: gen kID=_n
	gen KomRef=RefStatus
	replace KomRef=. if kID>1
	
	bysort FodelseAr: egen mKohortRef=mean(RefStatus)
	bysort FodelseAr: egen mKomRef=mean(KomRef) 
	
	twoway (line mKohortRef FodelseAr if kID==1, yaxis(1) lcolor(black)) || ///
			(line mKomRef FodelseAr if kID==1, yaxis(2))
			
			
	
