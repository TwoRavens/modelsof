cd "~/Dropbox/Broockman-Skovron/Elite perceptions 2/2000 Convention Delegate Study/DS0001"

//// 2000 ANES
use "/Users/dbroock/Google Drive/Broockman/Datasets/ANES/NES in STATA/nes2000_first_11.dta", clear

keep if  VAR001241 == 4 // voters only -- "the national electorate"

// abortion
/* 
1. BY LAW, ABORTION SHOULD NEVER BE PERMITTED.
2. THE LAW SHOULD PERMIT ABORTION ONLY IN CASE OF RAPE, INCEST,
          OR WHEN THE WOMAN'S LIFE IS IN DANGER.
http://www.electionstudies.org/studypages/2000prepost/anes2000prepost_var.txt 10/15/2009
Page 371 of 1027
3. THE LAW SHOULD PERMIT ABORTION FOR REASONS OTHER THAN RAPE, INCEST, OR DANGER TO THE WOMAN'S LIFE, BUT ONLY AFTER THE NEED FOR THE ABORTION HAS BEEN CLEARLY ESTABLISHED.
4. BY LAW, A WOMAN SHOULD ALWAYS BE ABLE TO OBTAIN AN ABORTION AS A MATTER OF PERSONAL CHOICE.
*/
// MEDIAN = 3
tab VAR000694 [aw=VAR000002] if inlist(VAR000694, 1, 2, 3, 4)

// helping blacks; remove 8 9 0 - 7 = blacks help selves
// MEDIAN = 3
tab VAR000645 [aw=VAR000002] if !inlist(VAR000645, 8, 9, 0)

// government insurance; remove 8 9 0
// MEDIAN = 4
tab VAR000608a [aw=VAR000002] if !inlist(VAR000608a, 8, 9, 0)

// Homosexual job protection scale from other items - not same as above
/* 1. Favor strongly
       2. Favor not strongly
       4. Disapprove not strongly
       5. Disapprove strongly */
// MEDIAN = favor not strongly (2)
tab VAR001481 [aw=VAR000002] if !inlist(VAR001481, 8, 9, 0)

// Ideological scale
// MEDIAN = 4 (moderate)
tab VAR000439 [aw=VAR000002] if !inlist(VAR000439, 8, 9, 0)



// CDS
use "31781-0001-Data.dta", clear

keep if V2492 == 3 // office holders

// Recode the variables such that -1 is overest cons, 1 is overest lib, 0 is median

// abortion in national electorate
tab V2111
tab V2111, nol
recode V2111 (1/2=-1) (3=0) (4=1)
tab V2111 PARTY, co nol

// helping blacks in national electorate
tab V2127
tab V2127, nol
recode V2127 (1=1) (2=2) (3/5=3) (6=4) (7=5) // ANES was a 5 point with 3/5 collapsed
recode V2127 (1/2=1) (3=0) (4/5=-1)
tab V2127 PARTY, co nol

// government insurance in national electorate
tab V2414
tab V2414, nol
recode V2414 (1/3=1) (4=0) (5/7=-1)
tab V2414 PARTY, co nol

// protection for homosexuals in national electorate
tab V2420
tab V2420, nol
recode V2420 (1/3=0) (4=.) (5/7=-1)
tab V2420 PARTY, co nol

// ideological scale - national electorate
tab V2103
tab V2103, nol
recode V2103 (1/3=1) (4=0) (5/7=-1)
tab V2103 PARTY, co nol




