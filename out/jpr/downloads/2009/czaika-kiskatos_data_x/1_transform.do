version 10

capture log close

/* Redefine as home the library where you put the data */
global home "D:\"
cd $home

log using 1_transform.log, replace

use podes_raw, clear
save podes_proc, replace


/* Regional variables/geography	*/
label define kab 	1 "Simeulue" 2 "Aceh Singkil" 3 "Aceh Selatan (S)" 4 "Aceh Tenggara (SE)" 5 "Aceh Timur (E)" 
label define kab 	6 "Aceh Tengah (M)" 7 "Aceh Barat (W)" 8 "Aceh Besar (L)" 9 "Pidie" 10 "Bireuen" 11 "Aceh Utara (N)", add
label define kab 	12 "Aceh Barat Daya (SW)" 13 "Gayo Lues" 14 "Aceh Tamiang" 15 "Nagan Raya" 16 "Aceh Jaya", add
label define kab 	71 "Banda Aceh" 72 "Sabang" 73 "Langsa" 74 "Lhokseumawe", add
label values kab kab

cap drop kab_*
gen kab_Selatan	= kab == 3
gen kab_Timur	= kab == 5
gen kab_Tengah	= kab == 6
gen kab_Barat	= kab == 7
gen kab_Utara	= kab == 11
gen kab_BaratDaya= kab == 12
gen kab_Tamiang = kab == 14
gen kab_NaganRaya= kab == 15
gen kab_BandaAceh = kab == 71
gen kab_Langsa	= kab == 73
gen kab_Lhokseumawe = kab ==74
gen largetown = inlist(kab,71,72,73,74)
lab var largetown 	"Part of a large city (district status)"

local dist "Selatan Timur Tengah Barat Utara BaratDaya Tamiang NaganRaya BandaAceh Langsa Lhokseumawe"
foreach x of local dist{
	lab var kab_`x' "District (kabupaten) of `x' "
}

rename drh urban
lab var urban "Urban 2003"
gen altitude = b3r310/1000
label var altitude "Altitude (in .000 m)"
replace altitude = . if altitude>6 

rename B3R13 remote
replace remote = remote/100
replace remote = 0.1 if remote >0.1 & largetown==1
lab var remote "Distance to own district office (.00 km, adjusted for centers)"


/* Generating population variables */

rename B4AR2A pop00
rename B4AR4 couples00
replace couples = couples/100
gen pop03 = b4r402a + b4r402b

drop if pop00==.
drop if pop03==.

replace pop00 = pop00/1000
gen popsq00 = pop00^2
gen pop3_00 = pop00^3
gen pop4_00 = pop00^4

replace pop03 = pop03/1000

lab var pop00 "Pop. in thousands in 2000"
lab var pop03 "Pop. in thousands in 2003"
lab var couples00 "Nr. of fertile couples in 2000 (in hundreds)" 
lab var popsq00 "Pop. in thds squared"
lab var pop3_00 "Pop. in thds to the third power"
lab var pop4_00 "Pop. in thds to the fourth power"


/* Wealth */
gen poor00 =  (B4AR3/B4AR2B)
lab var poor00 "Share of pre-welfare poor families 2000 (0-1)"

/* Health */
ren b7r706q3 deadep03

/* Transport */
ren b10r1005 station03
replace station03 = 1 if largetown==1

/* Police presence */
gen police00 = inrange(B12R3B4,3,4)==0
lab var police00 "Police post is not difficult to reach"

/*   Conflict */
rename b17r1703 conflict
lab var conflict "Presence of conflict in previous year"
replace conflict = 0 if conflict == .
replace conflict = 1 if (conflict~=1 & (inrange(b17r1704c1,1,100) | inrange(b17r1704c2,1,100) ) )
gen high_cshare = inrange(cshare,0.2,1)==1
lab var high_cshare "Conflict share (kec) 0.2 or larger"

/* Population change */
gen dpop  = (pop03*1000 - pop00*1000 + deadep03 + b17r1704c1)/100
lab var dpop "Net change in population in hundreds"


/* Impute share of Jawanese for 13 subdistricts (kecamatans) as district (kabupaten) averages */
cap drop temp*
by prop kab, sort: egen temp = mean(share_Jawa)
replace share_Jawa = temp if share_Jawa==. 

/* Impute share of Jawanese for 23 subdistricts (kecamatans) as the average of the surrounding districts */
egen temp2 = mean(share_Jawa) if inlist(kab,6,7,8,10,16)
egen temp3 = mean(temp2)
replace share_Jawa = temp3 if share_Jawa ==. & kab==9
cap drop temp*
drop b* B*

compress
save podes_proc, replace

log close

log using codebook_proc.log, replace
codebook
log close

/*E.o.F*/




