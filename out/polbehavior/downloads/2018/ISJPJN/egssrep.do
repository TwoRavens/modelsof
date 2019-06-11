#delimit;
set logtype text;
log using egssrep.out, replace;
set more off;
set matsize 100;
use "anes2010_2012egss2_dataset.dta";

/* Table 3--2010 ANES divided government measure */
tab c2_q1 [iweight=c2_weight];

clear;

use "anes2011_egss1_dataset.dta";

/* For Table 4: code divided government variables */

/* create government combination variables */

gen dd=c1_j1a if c1_j1a>0;
gen rr=c1_j1b if c1_j1b>0;
gen dr=c1_j1c if c1_j1c>0;
gen rd=c1_j1d if c1_j1d>0;

/* variables are DD,RR,DR,RD */
gen prefrank=1 if dd==4 & rr==1 & dr==3 & rd==2;
replace prefrank=2 if dd==4 & rr==1 & dr==2 & rd==3;
replace prefrank=3 if dd==1 & rr==4 & dr==2 & rd==3;
replace prefrank=4 if dd==1 & rr==4 & dr==3 & rd==2;
replace prefrank=5 if dd==3 & rr==2 & dr==4 & rd==1;
replace prefrank=6 if dd==2 & rr==3 & dr==4 & rd==1;
replace prefrank=7 if dd==2 & rr==3 & dr==1 & rd==4;
replace prefrank=8 if dd==3 & rr==2 & dr==1 & rd==4;
replace prefrank=9 if dd==2 & rr==1 & dr==4 & rd==3;
replace prefrank=10 if dd==1 & rr==2 & dr==3 & rd==4;
replace prefrank=11 if dd==2 & rr==1 & dr==3 & rd==4;
replace prefrank=12 if dd==1 & rr==2 & dr==4 & rd==3;
replace prefrank=13 if dd==4 & rr==3 & dr==2 & rd==1;
replace prefrank=14 if dd==3 & rr==4 & dr==1 & rd==2;
replace prefrank=15 if dd==3 & rr==4 & dr==2 & rd==1;
replace prefrank=16 if dd==4 & rr==3 & dr==1 & rd==2;
replace prefrank=17 if dd==3 & rr==1 & dr==2 & rd==4;
replace prefrank=18 if dd==1 & rr==3 & dr==4 & rd==2;
replace prefrank=19 if dd==3 & rr==1 & dr==4 & rd==2;
replace prefrank=20 if dd==1 & rr==3 & dr==2 & rd==4;
replace prefrank=21 if dd==2 & rr==4 & dr==3 & rd==1;
replace prefrank=22 if dd==4 & rr==2 & dr==1 & rd==3;
replace prefrank=23 if dd==4 & rr==2 & dr==3 & rd==1;
replace prefrank=24 if dd==2 & rr==4 & dr==1 & rd==3;

label define prefrankv 1 "Rep part (RP)" 2 "Rep part (RC)" 3 "Dem part
(DP)" 4 "Dem part (DC)" 5 "Sep DG (RP)" 6 "Sep DG (DC)" 7 "Sep DG
(DP)" 8 "Sep DG (RC)" 9 "Unifier (RR)" 10 "Unifier (DD)" 11 "Unifier
(RR)" 12 "Unifier (DD)" 13 "NSep DG (RD)" 14 "NSep DG (DR)" 15 "NSep
DG (RD)" 16 "NSep DG (DR)" 17 "PSep (RR>DR)" 18 "PSep (DD>RD)" 19
"PSep (RR>RD)" 20 "PSep (DD>DR)" 21 "PSep (RD>DD)" 22 "PSep (DR>RR)"
23 "PSep (RD>RR)" 24 "PSep (DR>DD)";
label values prefrank prefrankv;

/* comparison of approval/disapproval (page 15) */

tab c1_y1 if c1_y1>0 [iweight=c1_weight];
tab c1_y1 if prefrank>=13 & prefrank<=16 & c1_y1>0 [iweight=c1_weight];

/* Values for Table 4 */

tab prefrank [iweight=c1_weight];

/* For Table 5 */

/* check for order effects of 1,2,3,4 */

gen order1234=0;
replace order1234=1 if c1_xj1order==1 & dd==1 & rr==2 & dr==3 & rd==4;
replace order1234=1 if c1_xj1order==2 & dd==1 & rr==2 & dr==4 & rd==3;
replace order1234=1 if c1_xj1order==3 & dd==2 & rr==1 & dr==3 & rd==4;
replace order1234=1 if c1_xj1order==4 & dd==2 & rr==1 & dr==4 & rd==3;
replace order1234=1 if c1_xj1order==5 & dd==4 & rr==3 & dr==2 & rd==1;
replace order1234=1 if c1_xj1order==6 & dd==4 & rr==3 & dr==1 & rd==2;
replace order1234=1 if c1_xj1order==7 & dd==3 & rr==4 & dr==1 & rd==2;
replace order1234=1 if c1_xj1order==8 & dd==3 & rr==4 & dr==2 & rd==1;

gen strongdiv=(prefrank>=13 & prefrank<=16);
gen strongdiv_a=strongdiv*order1234;

gen unifier=(prefrank>=9 & prefrank<=12);
gen unifier_a=unifier*order1234;

gen Reppart=(prefrank==1 | prefrank==2);
gen Dempart=(prefrank==3 | prefrank==4);

/* create variables for House and Senate representation */

/* create Republican House incumbent variables */

gen repinch=(c1_state==63 & c1_xcd==1);
replace repinch=1 if c1_state==63 & c1_xcd==3;
replace repinch=1 if c1_state==63 & c1_xcd==4;
replace repinch=1 if c1_state==63 & c1_xcd==5;
replace repinch=1 if c1_state==63 & c1_xcd==6;
replace repinch=1 if c1_state==86 & c1_xcd==2;
replace repinch=1 if c1_state==86 & c1_xcd==6;
replace repinch=1 if c1_state==93 & c1_xcd==2;
replace repinch=1 if c1_state==93 & c1_xcd==3;
replace repinch=1 if c1_state==93 & c1_xcd==4;
replace repinch=1 if c1_state==93 & c1_xcd==21;
replace repinch=1 if c1_state==93 & c1_xcd==22;
replace repinch=1 if c1_state==93 & c1_xcd==24;
replace repinch=1 if c1_state==93 & c1_xcd==25;
replace repinch=1 if c1_state==93 & c1_xcd==26;
replace repinch=1 if c1_state==93 & c1_xcd==40;
replace repinch=1 if c1_state==93 & c1_xcd==41;
replace repinch=1 if c1_state==93 & c1_xcd==42;
replace repinch=1 if c1_state==93 & c1_xcd==44;
replace repinch=1 if c1_state==93 & c1_xcd==45;
replace repinch=1 if c1_state==93 & c1_xcd==46;
replace repinch=1 if c1_state==93 & c1_xcd==48;
replace repinch=1 if c1_state==93 & c1_xcd==49;
replace repinch=1 if c1_state==93 & c1_xcd==50;
replace repinch=1 if c1_state==93 & c1_xcd==52;
replace repinch=1 if c1_state==84 & c1_xcd==5;
replace repinch=1 if c1_state==84 & c1_xcd==6;
replace repinch=1 if c1_state==59 & c1_xcd==1;
replace repinch=1 if c1_state==59 & c1_xcd==4;
replace repinch=1 if c1_state==59 & c1_xcd==6;
replace repinch=1 if c1_state==59 & c1_xcd==7;
replace repinch=1 if c1_state==59 & c1_xcd==9;
replace repinch=1 if c1_state==59 & c1_xcd==10;
replace repinch=1 if c1_state==59 & c1_xcd==13;
replace repinch=1 if c1_state==59 & c1_xcd==14;
replace repinch=1 if c1_state==59 & c1_xcd==15;
replace repinch=1 if c1_state==59 & c1_xcd==16;
replace repinch=1 if c1_state==59 & c1_xcd==18;
replace repinch=1 if c1_state==58 & c1_xcd==1;
replace repinch=1 if c1_state==58 & c1_xcd==3;
replace repinch=1 if c1_state==58 & c1_xcd==6;
replace repinch=1 if c1_state==58 & c1_xcd==9;
replace repinch=1 if c1_state==58 & c1_xcd==10;
replace repinch=1 if c1_state==58 & c1_xcd==11;
replace repinch=1 if c1_state==95 & c1_xcd==1;
replace repinch=1 if c1_state==82 & c1_xcd==2;
replace repinch=1 if c1_state==33 & c1_xcd==6;
replace repinch=1 if c1_state==33 & c1_xcd==13;
replace repinch=1 if c1_state==33 & c1_xcd==15;
replace repinch=1 if c1_state==33 & c1_xcd==16;
replace repinch=1 if c1_state==33 & c1_xcd==18;
replace repinch=1 if c1_state==33 & c1_xcd==19;
replace repinch=1 if c1_state==32 & c1_xcd==3;
replace repinch=1 if c1_state==32 & c1_xcd==5;
replace repinch=1 if c1_state==32 & c1_xcd==6;
replace repinch=1 if c1_state==42 & c1_xcd==4;
replace repinch=1 if c1_state==42 & c1_xcd==5;
replace repinch=1 if c1_state==61 & c1_xcd==1;
replace repinch=1 if c1_state==61 & c1_xcd==2;
replace repinch=1 if c1_state==61 & c1_xcd==4;
replace repinch=1 if c1_state==61 & c1_xcd==5;
replace repinch=1 if c1_state==72 & c1_xcd==1;
replace repinch=1 if c1_state==72 & c1_xcd==2;
replace repinch=1 if c1_state==72 & c1_xcd==4;
replace repinch=1 if c1_state==72 & c1_xcd==5;
replace repinch=1 if c1_state==72 & c1_xcd==6;
replace repinch=1 if c1_state==72 & c1_xcd==7;
replace repinch=1 if c1_state==52 & c1_xcd==6;
replace repinch=1 if c1_state==34 & c1_xcd==1;
replace repinch=1 if c1_state==34 & c1_xcd==6;
replace repinch=1 if c1_state==34 & c1_xcd==8;
replace repinch=1 if c1_state==34 & c1_xcd==10;
replace repinch=1 if c1_state==34 & c1_xcd==11;
replace repinch=1 if c1_state==41 & c1_xcd==2;
replace repinch=1 if c1_state==41 & c1_xcd==3;
replace repinch=1 if c1_state==41 & c1_xcd==6;
replace repinch=1 if c1_state==64 & c1_xcd==3;
replace repinch=1 if c1_state==43 & c1_xcd==2;
replace repinch=1 if c1_state==43 & c1_xcd==6;
replace repinch=1 if c1_state==43 & c1_xcd==8;
replace repinch=1 if c1_state==43 & c1_xcd==9;
replace repinch=1 if c1_state==46 & c1_xcd==1;
replace repinch=1 if c1_state==46 & c1_xcd==2;
replace repinch=1 if c1_state==46 & c1_xcd==3;
replace repinch=1 if c1_state==88 & c1_xcd==2;
replace repinch=1 if c1_state==22 & c1_xcd==4;
replace repinch=1 if c1_state==22 & c1_xcd==5;
replace repinch=1 if c1_state==22 & c1_xcd==7;
replace repinch=1 if c1_state==22 & c1_xcd==11;
replace repinch=1 if c1_state==21 & c1_xcd==26;
replace repinch=1 if c1_state==56 & c1_xcd==3;
replace repinch=1 if c1_state==56 & c1_xcd==5;
replace repinch=1 if c1_state==56 & c1_xcd==6;
replace repinch=1 if c1_state==56 & c1_xcd==9;
replace repinch=1 if c1_state==56 & c1_xcd==10;
replace repinch=1 if c1_state==31 & c1_xcd==2;
replace repinch=1 if c1_state==31 & c1_xcd==3;
replace repinch=1 if c1_state==31 & c1_xcd==4;
replace repinch=1 if c1_state==31 & c1_xcd==5;
replace repinch=1 if c1_state==31 & c1_xcd==7;
replace repinch=1 if c1_state==31 & c1_xcd==8;
replace repinch=1 if c1_state==31 & c1_xcd==12;
replace repinch=1 if c1_state==31 & c1_xcd==14;
replace repinch=1 if c1_state==73 & c1_xcd==1;
replace repinch=1 if c1_state==73 & c1_xcd==3;
replace repinch=1 if c1_state==73 & c1_xcd==4;
replace repinch=1 if c1_state==92 & c1_xcd==2;
replace repinch=1 if c1_state==23 & c1_xcd==5;
replace repinch=1 if c1_state==23 & c1_xcd==6;
replace repinch=1 if c1_state==23 & c1_xcd==9;
replace repinch=1 if c1_state==23 & c1_xcd==15;
replace repinch=1 if c1_state==23 & c1_xcd==16;
replace repinch=1 if c1_state==23 & c1_xcd==18;
replace repinch=1 if c1_state==23 & c1_xcd==19;
replace repinch=1 if c1_state==57 & c1_xcd==2;
replace repinch=1 if c1_state==57 & c1_xcd==4;
replace repinch=1 if c1_state==62 & c1_xcd==7;
replace repinch=1 if c1_state==74 & (c1_xcd>=1 & c1_xcd<=8);
replace repinch=1 if c1_state==74 & (c1_xcd>=10 & c1_xcd<=14);
replace repinch=1 if c1_state==74 & c1_xcd==19;
replace repinch=1 if c1_state==74 & c1_xcd==21;
replace repinch=1 if c1_state==74 & c1_xcd==22;
replace repinch=1 if c1_state==74 & c1_xcd==24;
replace repinch=1 if c1_state==74 & c1_xcd==26;
replace repinch=1 if c1_state==74 & c1_xcd==31;
replace repinch=1 if c1_state==74 & c1_xcd==32;
replace repinch=1 if c1_state==87 & c1_xcd==1;
replace repinch=1 if c1_state==87 & c1_xcd==3;
replace repinch=1 if c1_state==54 & c1_xcd==1;
replace repinch=1 if c1_state==54 & c1_xcd==4;
replace repinch=1 if c1_state==54 & c1_xcd==6;
replace repinch=1 if c1_state==54 & c1_xcd==7;
replace repinch=1 if c1_state==54 & c1_xcd==10;
replace repinch=1 if c1_state==91 & c1_xcd==4;
replace repinch=1 if c1_state==91 & c1_xcd==5;
replace repinch=1 if c1_state==91 & c1_xcd==8;
replace repinch=1 if c1_state==55 & c1_xcd==2;
replace repinch=1 if c1_state==35 & c1_xcd==1;
replace repinch=1 if c1_state==35 & c1_xcd==5;
replace repinch=1 if c1_state==35 & c1_xcd==6;

/* create Democratic House incumbent variables */

gen deminch=(c1_state==63 & c1_xcd==2);
replace deminch=1 if c1_state==86 & c1_xcd==1;
replace deminch=1 if c1_state==86 & c1_xcd==4;
replace deminch=1 if c1_state==86 & c1_xcd==5;
replace deminch=1 if c1_state==86 & c1_xcd==7;
replace deminch=1 if c1_state==86 & c1_xcd==8;
replace deminch=1 if c1_state==71 & c1_xcd==4;
replace deminch=1 if c1_state==93 & c1_xcd==1;
replace deminch=1 if c1_state==93 & (c1_xcd>=5 & c1_xcd<=18);
replace deminch=1 if c1_state==93 & c1_xcd==20;
replace deminch=1 if c1_state==93 & c1_xcd==23;
replace deminch=1 if c1_state==93 & (c1_xcd>=27 & c1_xcd<=32);
replace deminch=1 if c1_state==93 & (c1_xcd>=34 & c1_xcd<=39);
replace deminch=1 if c1_state==93 & c1_xcd==43;
replace deminch=1 if c1_state==93 & c1_xcd==47;
replace deminch=1 if c1_state==93 & c1_xcd==51;
replace deminch=1 if c1_state==93 & c1_xcd==53;
replace deminch=1 if c1_state==84 & (c1_xcd>=1 & c1_xcd<=4);
replace deminch=1 if c1_state==84 & c1_xcd==7;
replace deminch=1 if c1_state==16 & (c1_xcd>=1 & c1_xcd<=5);
replace deminch=1 if c1_state==59 & c1_xcd==2;
replace deminch=1 if c1_state==59 & c1_xcd==3;
replace deminch=1 if c1_state==59 & c1_xcd==8;
replace deminch=1 if c1_state==59 & c1_xcd==11;
replace deminch=1 if c1_state==59 & c1_xcd==19;
replace deminch=1 if c1_state==59 & c1_xcd==20;
replace deminch=1 if c1_state==59 & c1_xcd==22;
replace deminch=1 if c1_state==59 & c1_xcd==23;
replace deminch=1 if c1_state==59 & c1_xcd==24;
replace deminch=1 if c1_state==58 & c1_xcd==2;
replace deminch=1 if c1_state==58 & c1_xcd==4;
replace deminch=1 if c1_state==58 & c1_xcd==5;
replace deminch=1 if c1_state==58 & c1_xcd==8;
replace deminch=1 if c1_state==58 & c1_xcd==12;
replace deminch=1 if c1_state==58 & c1_xcd==13;
replace deminch=1 if c1_state==95 & c1_xcd==2;
replace deminch=1 if c1_state==82 & c1_xcd==1;
replace deminch=1 if c1_state==33 & (c1_xcd>=1 & c1_xcd<=5);
replace deminch=1 if c1_state==33 & (c1_xcd>=7 & c1_xcd<=9);
replace deminch=1 if c1_state==33 & c1_xcd==11;
replace deminch=1 if c1_state==33 & c1_xcd==12;
replace deminch=1 if c1_state==33 & c1_xcd==14;
replace deminch=1 if c1_state==33 & c1_xcd==17;
replace deminch=1 if c1_state==32 & c1_xcd==1;
replace deminch=1 if c1_state==32 & c1_xcd==2;
replace deminch=1 if c1_state==32 & c1_xcd==7;
replace deminch=1 if c1_state==32 & c1_xcd==9;
replace deminch=1 if c1_state==42 & c1_xcd==1;
replace deminch=1 if c1_state==42 & c1_xcd==2;
replace deminch=1 if c1_state==42 & c1_xcd==3;
replace deminch=1 if c1_state==61 & c1_xcd==3;
replace deminch=1 if c1_state==61 & c1_xcd==6;
replace deminch=1 if c1_state==11 & c1_xcd==1;
replace deminch=1 if c1_state==11 & c1_xcd==2;
replace deminch=1 if c1_state==52 & (c1_xcd>=1 & c1_xcd<=5);
replace deminch=1 if c1_state==52 & c1_xcd==7;
replace deminch=1 if c1_state==14 & (c1_xcd>=1 & c1_xcd<=9);
replace deminch=1 if c1_state==34 & c1_xcd==5;
replace deminch=1 if c1_state==34 & c1_xcd==7;
replace deminch=1 if c1_state==34 & c1_xcd==9;
replace deminch=1 if c1_state==34 & c1_xcd==12;
replace deminch=1 if c1_state==34 & c1_xcd==13;
replace deminch=1 if c1_state==34 & c1_xcd==14;
replace deminch=1 if c1_state==34 & c1_xcd==15;
replace deminch=1 if c1_state==41 & c1_xcd==1;
replace deminch=1 if c1_state==41 & c1_xcd==4;
replace deminch=1 if c1_state==41 & c1_xcd==5;
replace deminch=1 if c1_state==41 & c1_xcd==7;
replace deminch=1 if c1_state==41 & c1_xcd==8;
replace deminch=1 if c1_state==64 & c1_xcd==1;
replace deminch=1 if c1_state==64 & c1_xcd==2;
replace deminch=1 if c1_state==64 & c1_xcd==4;
replace deminch=1 if c1_state==43 & c1_xcd==1;
replace deminch=1 if c1_state==43 & c1_xcd==3;
replace deminch=1 if c1_state==43 & c1_xcd==4;
replace deminch=1 if c1_state==43 & c1_xcd==5;
replace deminch=1 if c1_state==88 & c1_xcd==1;
replace deminch=1 if c1_state==88 & c1_xcd==3;
replace deminch=1 if c1_state==12 & c1_xcd==1;
replace deminch=1 if c1_state==22 & c1_xcd==1;
replace deminch=1 if c1_state==22 & c1_xcd==3;
replace deminch=1 if c1_state==22 & c1_xcd==6;
replace deminch=1 if c1_state==22 & c1_xcd==8;
replace deminch=1 if c1_state==22 & c1_xcd==9;
replace deminch=1 if c1_state==22 & c1_xcd==10;
replace deminch=1 if c1_state==22 & c1_xcd==12;
replace deminch=1 if c1_state==22 & c1_xcd==13;
replace deminch=1 if c1_state==85 & c1_xcd>=1 & c1_xcd<=3;
replace deminch=1 if c1_state==21 & c1_xcd>=1 & c1_xcd<=2;
replace deminch=1 if c1_state==21 & c1_xcd>=4 & c1_xcd<=25;
replace deminch=1 if c1_state==21 & c1_xcd>=27 & c1_xcd<=28;
replace deminch=1 if c1_state==56 & c1_xcd>=1 & c1_xcd<=2;
replace deminch=1 if c1_state==56 & c1_xcd==4;
replace deminch=1 if c1_state==56 & c1_xcd==7;
replace deminch=1 if c1_state==56 & c1_xcd==8;
replace deminch=1 if c1_state==56 & c1_xcd==11;
replace deminch=1 if c1_state==56 & c1_xcd==12;
replace deminch=1 if c1_state==56 & c1_xcd==13;
replace deminch=1 if c1_state==31 & c1_xcd==1;
replace deminch=1 if c1_state==31 & c1_xcd==6;
replace deminch=1 if c1_state==31 & c1_xcd==9;
replace deminch=1 if c1_state==31 & c1_xcd==10;
replace deminch=1 if c1_state==31 & c1_xcd==11;
replace deminch=1 if c1_state==31 & c1_xcd==13;
replace deminch=1 if c1_state==31 & c1_xcd==15;
replace deminch=1 if c1_state==31 & c1_xcd==16;
replace deminch=1 if c1_state==31 & c1_xcd==17;
replace deminch=1 if c1_state==31 & c1_xcd==18;
replace deminch=1 if c1_state==73 & c1_xcd==2;
replace deminch=1 if c1_state==92 & c1_xcd==1;
replace deminch=1 if c1_state==92 & c1_xcd==3;
replace deminch=1 if c1_state==92 & c1_xcd==4;
replace deminch=1 if c1_state==92 & c1_xcd==5;
replace deminch=1 if c1_state==23 & c1_xcd>=1 & c1_xcd<=4;
replace deminch=1 if c1_state==23 & c1_xcd==8;
replace deminch=1 if c1_state==23 & c1_xcd>=10 & c1_xcd<=14;
replace deminch=1 if c1_state==23 & c1_xcd>=17;
replace deminch=1 if c1_state==15 & c1_xcd==2;
replace deminch=1 if c1_state==57 & c1_xcd>=5 & c1_xcd<=6;
replace deminch=1 if c1_state==62 & c1_xcd>=4 & c1_xcd<=5;
replace deminch=1 if c1_state==62 & c1_xcd==9;
replace deminch=1 if c1_state==74 & c1_xcd==9;
replace deminch=1 if c1_state==74 & c1_xcd==16;
replace deminch=1 if c1_state==74 & c1_xcd==17;
replace deminch=1 if c1_state==74 & c1_xcd==18;
replace deminch=1 if c1_state==74 & c1_xcd==20;
replace deminch=1 if c1_state==74 & c1_xcd==23;
replace deminch=1 if c1_state==74 & c1_xcd==25;
replace deminch=1 if c1_state==74 & c1_xcd>=27 & c1_xcd<=30;
replace deminch=1 if c1_state==87 & c1_xcd==2;
replace deminch=1 if c1_state==54 & c1_xcd==2;
replace deminch=1 if c1_state==54 & c1_xcd==3;
replace deminch=1 if c1_state==54 & c1_xcd==5;
replace deminch=1 if c1_state==54 & c1_xcd==8;
replace deminch=1 if c1_state==54 & c1_xcd==9;
replace deminch=1 if c1_state==54 & c1_xcd==11;
replace deminch=1 if c1_state==91 & c1_xcd==1;
replace deminch=1 if c1_state==91 & c1_xcd==2;
replace deminch=1 if c1_state==91 & c1_xcd==6;
replace deminch=1 if c1_state==91 & c1_xcd==7;
replace deminch=1 if c1_state==91 & c1_xcd==9;
replace deminch=1 if c1_state==55 & c1_xcd==1;
replace deminch=1 if c1_state==55 & c1_xcd==3;
replace deminch=1 if c1_state==35 & c1_xcd==2;
replace deminch=1 if c1_state==35 & c1_xcd==3;
replace deminch=1 if c1_state==35 & c1_xcd==4;
replace deminch=1 if c1_state==35 & c1_xcd==8;

/* create Senate incumbent variables */

gen repincs=(c1_state==63);
replace repincs=1 if c1_state==42;
replace repincs=1 if c1_state==72;
replace repincs=1 if c1_state==56;
replace repincs=1 if c1_state==73;
replace repincs=1 if c1_state==57;
replace repincs=1 if c1_state==86;
replace repincs=1 if c1_state==58;
replace repincs=1 if c1_state==82;

gen demincs=(c1_state==84);
replace demincs=1 if c1_state==21;
replace demincs=1 if c1_state==93;
replace demincs=1 if c1_state==91;
replace demincs=1 if c1_state==95;
replace demincs=1 if c1_state==52;
replace demincs=1 if c1_state==88;
replace demincs=1 if c1_state==92;
replace demincs=1 if c1_state==71;
replace demincs=1 if c1_state==35;

gen repdel=(repincs==1 & repinch==1);
gen demdel=(demincs==1 & deminch==1);
gen splitdel=((repincs==1 & deminch==1) | (demincs==1 & repinch==1));

/* create variable for voting D Cong, R Cong, or split Cong */

/* create republican house vote variable */

gen rephouse=1 if dercandhouse==2;
replace rephouse=0 if dercandhouse==1;

/* create republican senate vote variable */

gen repsenate=1 if dercandsen==2;
replace repsenate=0 if dercandsen==1;

/* create congressional vote */

/* create variable for voting for a split Congress */

gen congsplit=1 if rephouse==1 & repsenate==0;
replace congsplit=1 if rephouse==0 & repsenate==1;
replace congsplit=0 if rephouse==1 & repsenate==1;
replace congsplit=0 if rephouse==0 & repsenate==0;

gen congvote=1 if rephouse==0 & repsenate==0;
replace congvote=2 if rephouse==1 & repsenate==1;
replace congvote=3 if congsplit==1;

label define congvotev 1 "H/S Dem" 2 "H/S Rep" 3 "H/S split"; 
label values congvote congvotev;

/* create party ID and ideology variables */

gen partyid=der08c1 if der08c1>=0;
gen strpid=abs(3-partyid);
gen ideology=c1_v1a if c1_v1a>=1 & c1_v1a<=7;
gen ideolstr=abs(4-ideology);

/* code retrospective economic evaluation */

gen natecon=5-derecon1 if derecon1>0;

/* Model for Table 5 */

mlogit congvote i.strongdiv strongdiv_a Reppart Dempart i.unifier
unifier_a partyid strpid ideology ideolstr natecon repdel demdel
splitdel [pweight=c1_weight], base(1); 

/* predicted probabilities for voting for split Cong (page 18) */

mtable, at(strongdiv=1 strongdiv_a=0 Reppart=0 Dempart=0
unifier=0 unifier_a=0);

mtable, at(strongdiv=0 strongdiv_a=0 Reppart=1 Dempart=0
unifier=0 unifier_a=0);

mtable, at(strongdiv=0 strongdiv_a=0 Reppart=0 Dempart=1
unifier=0 unifier_a=0);

margins r.strongdiv, at(strongdiv_a=0 Reppart=0 Dempart=0 unifier=0
unifier_a=0);

margins r.unifier, at(strongdiv=0 strongdiv_a=0 Reppart=0 Dempart=0 
unifier_a=0);

/* percentages of each type voting for unified/divided government
(page 19 and page 23) */

tab congvote [iweight=c1_weight];

tab congvote if strongdiv==1 & strongdiv_a==0 [iweight=c1_weight];
tab congvote if prefrank>=13 & prefrank<=16 [iweight=c1_weight];
tab congvote if prefrank>=21 & prefrank<=24 [iweight=c1_weight];
tab congvote if prefrank==1 | prefrank==2 [iweight=c1_weight];
tab congvote if prefrank==3 | prefrank==4 [iweight=c1_weight];

/* desire for split control of Congress (page 19) */

tab c1_bb1 if strongdiv==1 & strongdiv_a==0 & c1_bb1>0 [iweight=c1_weight];
tab c1_bb1 if prefrank>=13 & prefrank<=16 & c1_bb1>0 [iweight=c1_weight];

/* Results for Table A1 */

gen prankc=1 if prefrank>=1 & prefrank<=2;
replace prankc=2 if prefrank>=3 & prefrank<=4;
replace prankc=3 if prefrank>=5 & prefrank<=8;
replace prankc=4 if prefrank>=9 & prefrank<=12;
replace prankc=5 if prefrank>=13 & prefrank<=16;
replace prankc=6 if prefrank>=17 & prefrank<=20;
replace prankc=7 if prefrank>=21 & prefrank<=24;

gen unifirst=1 if c1_xj1order>=1 & c1_xj1order<=4;
replace unifirst=0 if c1_xj1order>=5 & c1_xj1order<=8;

tab prankc unifirst, col all;
tab prankc unifirst [iweight=c1_weight], col;

/* Model for Table A2 */

mlogit c1_bb1 i.strongdiv strongdiv_a i.Reppart i.Dempart
i.unifier unifier_a partyid strpid ideology ideolstr natecon repdel
demdel splitdel [pweight=c1_weight] if c1_bb1>0, base(3);

/* changes in probabilities for desire for split control (page 19) */ 

margins r.strongdiv, at(strongdiv_a=0 Reppart=0 Dempart=0 unifier=0
unifier_a=0);

margins r.unifier, at(strongdiv=0 strongdiv_a=0 Reppart=0 Dempart=0 
unifier_a=0);

margins r.Reppart, at(strongdiv=0 strongdiv_a=0 Dempart=0 unifier=0
unifier_a=0);

margins r.Dempart, at(strongdiv=0 strongdiv_a=0 Reppart=0 unifier=0
unifier_a=0);

log close;
