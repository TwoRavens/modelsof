* William Kerr, TGG; 
* Point Analaysis for Tables 5 and 6;

#delimit;
cd C:\kerr\docs-ces\agglom\kominers\data\restat-data\final;
cap n log close; log using kk-point1.log, replace;
clear all; set matsize 1000; set more off;

*********************************;
** Calculate point densities   **;
*********************************;

/*** Append raw counts;
use ../data/do-scat-zip-1, clear;
drop if scat==11; levelsof scat, local(ind2);
use ../data/do-scat-zip-2-11, clear;
foreach Q2 of local ind2 {;
append using ../data/do-scat-zip-2-`Q2';
}; compress; save ./data/kk-point1.dta, replace; */

use ./data/kk-point1.dta, replace;

*** collapse on basic distance bands;
drop if dist>250;
gen dist2=0; for any 20 40 60 80 100 120 140 160 180 200 220 240: replace dist2=X if dist>=X;
collapse (sum) ct, by(dist2 scat) fast;
egen temp1=sum(ct), by(scat); gen ctp=ct/temp1; drop temp1;

*** Add measures;
log off;
gen raduk=.;	gen raduk2=.;	gen radus1=.;	gen radus2=.;	gen radus3=.;	gen dens=.;	gen dens25=.;	gen dens5=.;	gen wt=.;
replace raduk=-0.0198379 if scat==11;	replace raduk2=0.0277897 if scat==11;	replace radus1=-0.0332971 if scat==11;	replace radus2=0.3645043 if scat==11;	replace radus3=13 if scat==11;	replace dens=0.3696547 if scat==11;	replace dens25=0.1946536 if scat==11;	replace dens5=0.0454887204730774 if scat==11;	replace wt=3538 if scat==11;
replace raduk=-0.1159519 if scat==12;	replace raduk2=0.2517019 if scat==12;	replace radus1=-0.0785103 if scat==12;	replace radus2=0.7565737 if scat==12;	replace radus3=5 if scat==12;	replace dens=0.3886623 if scat==12;	replace dens25=0.2132654 if scat==12;	replace dens5=0.0507818802172653 if scat==12;	replace wt=9815 if scat==12;
replace raduk=-0.0166115 if scat==13;	replace raduk2=0.1003343 if scat==13;	replace radus1=-0.0276331 if scat==13;	replace radus2=0.287975 if scat==13;	replace radus3=1 if scat==13;	replace dens=0.3618885 if scat==13;	replace dens25=0.1885018 if scat==13;	replace dens5=0.0438671560450275 if scat==13;	replace wt=2811 if scat==13;
replace raduk=-0.0593522 if scat==14;	replace raduk2=0.0654085 if scat==14;	replace radus1=-0.0278857 if scat==14;	replace radus2=0.2584549 if scat==14;	replace radus3=7 if scat==14;	replace dens=0.4234643 if scat==14;	replace dens25=0.2280165 if scat==14;	replace dens5=0.0536261919954765 if scat==14;	replace wt=14874 if scat==14;
replace raduk=-0.0633798 if scat==15;	replace raduk2=0.0604217 if scat==15;	replace radus1=-0.1618362 if scat==15;	replace radus2=0.7311743 if scat==15;	replace radus3=19 if scat==15;	replace dens=0.383683 if scat==15;	replace dens25=0.2157006 if scat==15;	replace dens5=0.0525435565138767 if scat==15;	replace wt=20334 if scat==15;
replace raduk=-0.1009116 if scat==19;	replace raduk2=0.1213181 if scat==19;	replace radus1=-0.1765426 if scat==19;	replace radus2=0.6590498 if scat==19;	replace radus3=5 if scat==19;	replace dens=0.4093788 if scat==19;	replace dens25=0.2261125 if scat==19;	replace dens5=0.0533867547487237 if scat==19;	replace wt=58819 if scat==19;
replace raduk=-0.1294203 if scat==21;	replace raduk2=0.1068486 if scat==21;	replace radus1=-0.1883979 if scat==21;	replace radus2=1.127412 if scat==21;	replace radus3=5 if scat==21;	replace dens=0.5830225 if scat==21;	replace dens25=0.3581223 if scat==21;	replace dens5=0.0884082710179898 if scat==21;	replace wt=49044 if scat==21;
replace raduk=-0.1860441 if scat==22;	replace raduk2=0.131689 if scat==22;	replace radus1=-0.1987305 if scat==22;	replace radus2=1.78406 if scat==22;	replace radus3=3 if scat==22;	replace dens=0.7036251 if scat==22;	replace dens25=0.498306 if scat==22;	replace dens5=0.13474623867754 if scat==22;	replace wt=66253 if scat==22;
replace raduk=-0.1614425 if scat==23;	replace raduk2=0.0816009 if scat==23;	replace radus1=-0.1943118 if scat==23;	replace radus2=1.419619 if scat==23;	replace radus3=3 if scat==23;	replace dens=0.6578254 if scat==23;	replace dens25=0.3976775 if scat==23;	replace dens5=0.0979000037768882 if scat==23;	replace wt=9553 if scat==23;
replace raduk=-0.0969733 if scat==24;	replace raduk2=0.0878555 if scat==24;	replace radus1=-0.1515071 if scat==24;	replace radus2=3.446713 if scat==24;	replace radus3=3 if scat==24;	replace dens=0.7667291 if scat==24;	replace dens25=0.520526 if scat==24;	replace dens5=0.135248441292056 if scat==24;	replace wt=15077 if scat==24;
replace raduk=-0.1955293 if scat==31;	replace raduk2=0.2434118 if scat==31;	replace radus1=-0.114233 if scat==31;	replace radus2=0.3867036 if scat==31;	replace radus3=15 if scat==31;	replace dens=0.4397548 if scat==31;	replace dens25=0.2407241 if scat==31;	replace dens5=0.0559351802740515 if scat==31;	replace wt=32437 if scat==31;
replace raduk=-0.2385246 if scat==32;	replace raduk2=0.1209807 if scat==32;	replace radus1=-0.2237123 if scat==32;	replace radus2=1.385455 if scat==32;	replace radus3=3 if scat==32;	replace dens=0.5555738 if scat==32;	replace dens25=0.3374379 if scat==32;	replace dens5=0.0832545047511762 if scat==32;	replace wt=37698 if scat==32;
replace raduk=-0.2498023 if scat==33;	replace raduk2=0.1170401 if scat==33;	replace radus1=-0.1334017 if scat==33;	replace radus2=0.470399 if scat==33;	replace radus3=3 if scat==33;	replace dens=0.5195239 if scat==33;	replace dens25=0.3117965 if scat==33;	replace dens5=0.0768380967720596 if scat==33;	replace wt=20855 if scat==33;
replace raduk=-0.0801338 if scat==39;	replace raduk2=0.0790038 if scat==39;	replace radus1=-0.0805078 if scat==39;	replace radus2=0.4313131 if scat==39;	replace radus3=5 if scat==39;	replace dens=0.4578665 if scat==39;	replace dens25=0.2480639 if scat==39;	replace dens5=0.0584926368216313 if scat==39;	replace wt=6529 if scat==39;
replace raduk=-0.0483683 if scat==41;	replace raduk2=0.032029 if scat==41;	replace radus1=-0.2438111 if scat==41;	replace radus2=1.271911 if scat==41;	replace radus3=3 if scat==41;	replace dens=0.4612692 if scat==41;	replace dens25=0.2771738 if scat==41;	replace dens5=0.068738073323491 if scat==41;	replace wt=20329 if scat==41;
replace raduk=-0.0366161 if scat==42;	replace raduk2=0.1285575 if scat==42;	replace radus1=-0.0969815 if scat==42;	replace radus2=0.7310153 if scat==42;	replace radus3=3 if scat==42;	replace dens=0.4527923 if scat==42;	replace dens25=0.2530301 if scat==42;	replace dens5=0.060429455368926 if scat==42;	replace wt=10499 if scat==42;
replace raduk=-0.1339971 if scat==43;	replace raduk2=0.1130004 if scat==43;	replace radus1=-0.1459338 if scat==43;	replace radus2=0.9357345 if scat==43;	replace radus3=15 if scat==43;	replace dens=0.4287362 if scat==43;	replace dens25=0.2455219 if scat==43;	replace dens5=0.059257604929654 if scat==43;	replace wt=19661 if scat==43;
replace raduk=-0.086623 if scat==44;	replace raduk2=0.1598728 if scat==44;	replace radus1=-0.1359979 if scat==44;	replace radus2=0.876117 if scat==44;	replace radus3=5 if scat==44;	replace dens=0.4670553 if scat==44;	replace dens25=0.2633328 if scat==44;	replace dens5=0.0631993369935072 if scat==44;	replace wt=9150 if scat==44;
replace raduk=-0.0368177 if scat==45;	replace raduk2=0.0767307 if scat==45;	replace radus1=-0.1286675 if scat==45;	replace radus2=0.7976367 if scat==45;	replace radus3=3 if scat==45;	replace dens=0.3995998 if scat==45;	replace dens25=0.2293806 if scat==45;	replace dens5=0.0556854991548141 if scat==45;	replace wt=21416 if scat==45;
replace raduk=-0.2099774 if scat==46;	replace raduk2=0.2303549 if scat==46;	replace radus1=-0.3041276 if scat==46;	replace radus2=2.261585 if scat==46;	replace radus3=3 if scat==46;	replace dens=0.8140604 if scat==46;	replace dens25=0.5748547 if scat==46;	replace dens5=0.152861440768237 if scat==46;	replace wt=22103 if scat==46;
replace raduk=-0.1280787 if scat==49;	replace raduk2=0.0963799 if scat==49;	replace radus1=-0.1110394 if scat==49;	replace radus2=0.6880151 if scat==49;	replace radus3=9 if scat==49;	replace dens=0.492695 if scat==49;	replace dens25=0.2858597 if scat==49;	replace dens5=0.0693543119736873 if scat==49;	replace wt=13921 if scat==49;
replace raduk=-0.0913388 if scat==51;	replace raduk2=0.0723951 if scat==51;	replace radus1=-0.0912054 if scat==51;	replace radus2=0.3716125 if scat==51;	replace radus3=3 if scat==51;	replace dens=0.3225465 if scat==51;	replace dens25=0.1679469 if scat==51;	replace dens5=0.0387149427465373 if scat==51;	replace wt=26759 if scat==51;
replace raduk=-0.046956 if scat==52;	replace raduk2=0.0534927 if scat==52;	replace radus1=-0.0642317 if scat==52;	replace radus2=0.2123378 if scat==52;	replace radus3=5 if scat==52;	replace dens=0.3209611 if scat==52;	replace dens25=0.1721329 if scat==52;	replace dens5=0.0404100563851761 if scat==52;	replace wt=14914 if scat==52;
replace raduk=-0.0984193 if scat==53;	replace raduk2=0.1580099 if scat==53;	replace radus1=-0.1760297 if scat==53;	replace radus2=0.5900409 if scat==53;	replace radus3=7 if scat==53;	replace dens=0.3918793 if scat==53;	replace dens25=0.2181685 if scat==53;	replace dens5=0.0503599506098181 if scat==53;	replace wt=15497 if scat==53;
replace raduk=-0.1119742 if scat==54;	replace raduk2=0.1683527 if scat==54;	replace radus1=-0.2235945 if scat==54;	replace radus2=1.455234 if scat==54;	replace radus3=5 if scat==54;	replace dens=0.7428123 if scat==54;	replace dens25=0.4905455 if scat==54;	replace dens5=0.126268381075256 if scat==54;	replace wt=11097 if scat==54;
replace raduk=-0.0917172 if scat==55;	replace raduk2=0.1450525 if scat==55;	replace radus1=-0.1880434 if scat==55;	replace radus2=0.5703141 if scat==55;	replace radus3=11 if scat==55;	replace dens=0.4017121 if scat==55;	replace dens25=0.2216017 if scat==55;	replace dens5=0.0519787512132144 if scat==55;	replace wt=19225 if scat==55;
replace raduk=-0.0729579 if scat==59;	replace raduk2=0.12927 if scat==59;	replace radus1=-0.0575639 if scat==59;	replace radus2=0.2036966 if scat==59;	replace radus3=3 if scat==59;	replace dens=0.341494 if scat==59;	replace dens25=0.1725804 if scat==59;	replace dens5=0.0384012958887019 if scat==59;	replace wt=30723 if scat==59;
replace raduk=-0.128743 if scat==61;	replace raduk2=0.2320901 if scat==61;	replace radus1=-0.043844 if scat==61;	replace radus2=0.1975858 if scat==61;	replace radus3=1 if scat==61;	replace dens=0.3311808 if scat==61;	replace dens25=0.1697864 if scat==61;	replace dens5=0.0388751529183601 if scat==61;	replace wt=15100 if scat==61;
replace raduk=-0.2624613 if scat==62;	replace raduk2=0.1158527 if scat==62;	replace radus1=-0.0676221 if scat==62;	replace radus2=0.5023518 if scat==62;	replace radus3=3 if scat==62;	replace dens=0.4060197 if scat==62;	replace dens25=0.2156382 if scat==62;	replace dens5=0.0504911372025768 if scat==62;	replace wt=10395 if scat==62;
replace raduk=-0.0739522 if scat==63;	replace raduk2=0.0814891 if scat==63;	replace radus1=-0.0266137 if scat==63;	replace radus2=0.1475536 if scat==63;	replace radus3=7 if scat==63;	replace dens=0.3676322 if scat==63;	replace dens25=0.1944775 if scat==63;	replace dens5=0.0454996190670126 if scat==63;	replace wt=8577 if scat==63;
replace raduk=-0.2624613 if scat==64;	replace raduk2=0.2517019 if scat==64;	replace radus1=-0.1794326 if scat==64;	replace radus2=1.000599 if scat==64;	replace radus3=1 if scat==64;	replace dens=0.6986929 if scat==64;	replace dens25=0.4479016 if scat==64;	replace dens5=0.112824149860423 if scat==64;	replace wt=9555 if scat==64;
replace raduk=-0.1669329 if scat==65;	replace raduk2=0.0825835 if scat==65;	replace radus1=-0.0346445 if scat==65;	replace radus2=0.0610867 if scat==65;	replace radus3=9 if scat==65;	replace dens=0.3653105 if scat==65;	replace dens25=0.1907342 if scat==65;	replace dens5=0.0439391254652457 if scat==65;	replace wt=16548 if scat==65;
replace raduk=-0.0204822 if scat==66;	replace raduk2=0.0306365 if scat==66;	replace radus1=-0.0163145 if scat==66;	replace radus2=0.1247864 if scat==66;	replace radus3=1 if scat==66;	replace dens=0.3210442 if scat==66;	replace dens25=0.1656418 if scat==66;	replace dens5=0.0384323994064764 if scat==66;	replace wt=5629 if scat==66;
replace raduk=-0.0835194 if scat==67;	replace raduk2=0.1934609 if scat==67;	replace radus1=-0.0525796 if scat==67;	replace radus2=0.5152119 if scat==67;	replace radus3=21 if scat==67;	replace dens=0.3572051 if scat==67;	replace dens25=0.1898535 if scat==67;	replace dens5=0.0445449968058036 if scat==67;	replace wt=4941 if scat==67;
replace raduk=-0.1367601 if scat==68;	replace raduk2=0.1250822 if scat==68;	replace radus1=-0.0356198 if scat==68;	replace radus2=0.1388805 if scat==68;	replace radus3=31 if scat==68;	replace dens=0.3848589 if scat==68;	replace dens25=0.2005491 if scat==68;	replace dens5=0.0459860858035576 if scat==68;	replace wt=15958 if scat==68;
replace raduk=-0.1090132 if scat==69;	replace raduk2=0.0519507 if scat==69;	replace radus1=-0.0731158 if scat==69;	replace radus2=0.2345563 if scat==69;	replace radus3=5 if scat==69;	replace dens=0.3531545 if scat==69;	replace dens25=0.1829572 if scat==69;	replace dens5=0.0399598329140995 if scat==69;	replace wt=59072 if scat==69;
log on;

*** Transform to (0,1);
for any radus2 raduk2: replace X=-X; gen ctp0=ctp;
for var ctp rad* wt: egen ZX=std(X);

*** Regressions;
for any 0 20 40 60 80 100 120:
\ sum ctp0 if dist2==X
\ regress ctp0 Zradus1 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus2 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus3 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk2 Zwt [aw=wt] if dist2==X, vce(robust);

*********************************;
** Version 2                   **;
*********************************;

*** Append raw counts;
use ./data/kk-point1.dta, clear;

*** collapse on basic distance bands;
drop if dist>250;
gen dist2=0; for any 5 10 15 20 40 60 140: replace dist2=X if dist>=X;
collapse (sum) ct, by(dist2 scat) fast;
egen temp1=sum(ct), by(scat); gen ctp=ct/temp1; drop temp1;

*** Add measures;
log off;
gen raduk=.;	gen raduk2=.;	gen radus1=.;	gen radus2=.;	gen radus3=.;	gen dens=.;	gen dens25=.;	gen dens5=.;	gen wt=.;
replace raduk=-0.0198379 if scat==11;	replace raduk2=0.0277897 if scat==11;	replace radus1=-0.0332971 if scat==11;	replace radus2=0.3645043 if scat==11;	replace radus3=13 if scat==11;	replace dens=0.3696547 if scat==11;	replace dens25=0.1946536 if scat==11;	replace dens5=0.0454887204730774 if scat==11;	replace wt=3538 if scat==11;
replace raduk=-0.1159519 if scat==12;	replace raduk2=0.2517019 if scat==12;	replace radus1=-0.0785103 if scat==12;	replace radus2=0.7565737 if scat==12;	replace radus3=5 if scat==12;	replace dens=0.3886623 if scat==12;	replace dens25=0.2132654 if scat==12;	replace dens5=0.0507818802172653 if scat==12;	replace wt=9815 if scat==12;
replace raduk=-0.0166115 if scat==13;	replace raduk2=0.1003343 if scat==13;	replace radus1=-0.0276331 if scat==13;	replace radus2=0.287975 if scat==13;	replace radus3=1 if scat==13;	replace dens=0.3618885 if scat==13;	replace dens25=0.1885018 if scat==13;	replace dens5=0.0438671560450275 if scat==13;	replace wt=2811 if scat==13;
replace raduk=-0.0593522 if scat==14;	replace raduk2=0.0654085 if scat==14;	replace radus1=-0.0278857 if scat==14;	replace radus2=0.2584549 if scat==14;	replace radus3=7 if scat==14;	replace dens=0.4234643 if scat==14;	replace dens25=0.2280165 if scat==14;	replace dens5=0.0536261919954765 if scat==14;	replace wt=14874 if scat==14;
replace raduk=-0.0633798 if scat==15;	replace raduk2=0.0604217 if scat==15;	replace radus1=-0.1618362 if scat==15;	replace radus2=0.7311743 if scat==15;	replace radus3=19 if scat==15;	replace dens=0.383683 if scat==15;	replace dens25=0.2157006 if scat==15;	replace dens5=0.0525435565138767 if scat==15;	replace wt=20334 if scat==15;
replace raduk=-0.1009116 if scat==19;	replace raduk2=0.1213181 if scat==19;	replace radus1=-0.1765426 if scat==19;	replace radus2=0.6590498 if scat==19;	replace radus3=5 if scat==19;	replace dens=0.4093788 if scat==19;	replace dens25=0.2261125 if scat==19;	replace dens5=0.0533867547487237 if scat==19;	replace wt=58819 if scat==19;
replace raduk=-0.1294203 if scat==21;	replace raduk2=0.1068486 if scat==21;	replace radus1=-0.1883979 if scat==21;	replace radus2=1.127412 if scat==21;	replace radus3=5 if scat==21;	replace dens=0.5830225 if scat==21;	replace dens25=0.3581223 if scat==21;	replace dens5=0.0884082710179898 if scat==21;	replace wt=49044 if scat==21;
replace raduk=-0.1860441 if scat==22;	replace raduk2=0.131689 if scat==22;	replace radus1=-0.1987305 if scat==22;	replace radus2=1.78406 if scat==22;	replace radus3=3 if scat==22;	replace dens=0.7036251 if scat==22;	replace dens25=0.498306 if scat==22;	replace dens5=0.13474623867754 if scat==22;	replace wt=66253 if scat==22;
replace raduk=-0.1614425 if scat==23;	replace raduk2=0.0816009 if scat==23;	replace radus1=-0.1943118 if scat==23;	replace radus2=1.419619 if scat==23;	replace radus3=3 if scat==23;	replace dens=0.6578254 if scat==23;	replace dens25=0.3976775 if scat==23;	replace dens5=0.0979000037768882 if scat==23;	replace wt=9553 if scat==23;
replace raduk=-0.0969733 if scat==24;	replace raduk2=0.0878555 if scat==24;	replace radus1=-0.1515071 if scat==24;	replace radus2=3.446713 if scat==24;	replace radus3=3 if scat==24;	replace dens=0.7667291 if scat==24;	replace dens25=0.520526 if scat==24;	replace dens5=0.135248441292056 if scat==24;	replace wt=15077 if scat==24;
replace raduk=-0.1955293 if scat==31;	replace raduk2=0.2434118 if scat==31;	replace radus1=-0.114233 if scat==31;	replace radus2=0.3867036 if scat==31;	replace radus3=15 if scat==31;	replace dens=0.4397548 if scat==31;	replace dens25=0.2407241 if scat==31;	replace dens5=0.0559351802740515 if scat==31;	replace wt=32437 if scat==31;
replace raduk=-0.2385246 if scat==32;	replace raduk2=0.1209807 if scat==32;	replace radus1=-0.2237123 if scat==32;	replace radus2=1.385455 if scat==32;	replace radus3=3 if scat==32;	replace dens=0.5555738 if scat==32;	replace dens25=0.3374379 if scat==32;	replace dens5=0.0832545047511762 if scat==32;	replace wt=37698 if scat==32;
replace raduk=-0.2498023 if scat==33;	replace raduk2=0.1170401 if scat==33;	replace radus1=-0.1334017 if scat==33;	replace radus2=0.470399 if scat==33;	replace radus3=3 if scat==33;	replace dens=0.5195239 if scat==33;	replace dens25=0.3117965 if scat==33;	replace dens5=0.0768380967720596 if scat==33;	replace wt=20855 if scat==33;
replace raduk=-0.0801338 if scat==39;	replace raduk2=0.0790038 if scat==39;	replace radus1=-0.0805078 if scat==39;	replace radus2=0.4313131 if scat==39;	replace radus3=5 if scat==39;	replace dens=0.4578665 if scat==39;	replace dens25=0.2480639 if scat==39;	replace dens5=0.0584926368216313 if scat==39;	replace wt=6529 if scat==39;
replace raduk=-0.0483683 if scat==41;	replace raduk2=0.032029 if scat==41;	replace radus1=-0.2438111 if scat==41;	replace radus2=1.271911 if scat==41;	replace radus3=3 if scat==41;	replace dens=0.4612692 if scat==41;	replace dens25=0.2771738 if scat==41;	replace dens5=0.068738073323491 if scat==41;	replace wt=20329 if scat==41;
replace raduk=-0.0366161 if scat==42;	replace raduk2=0.1285575 if scat==42;	replace radus1=-0.0969815 if scat==42;	replace radus2=0.7310153 if scat==42;	replace radus3=3 if scat==42;	replace dens=0.4527923 if scat==42;	replace dens25=0.2530301 if scat==42;	replace dens5=0.060429455368926 if scat==42;	replace wt=10499 if scat==42;
replace raduk=-0.1339971 if scat==43;	replace raduk2=0.1130004 if scat==43;	replace radus1=-0.1459338 if scat==43;	replace radus2=0.9357345 if scat==43;	replace radus3=15 if scat==43;	replace dens=0.4287362 if scat==43;	replace dens25=0.2455219 if scat==43;	replace dens5=0.059257604929654 if scat==43;	replace wt=19661 if scat==43;
replace raduk=-0.086623 if scat==44;	replace raduk2=0.1598728 if scat==44;	replace radus1=-0.1359979 if scat==44;	replace radus2=0.876117 if scat==44;	replace radus3=5 if scat==44;	replace dens=0.4670553 if scat==44;	replace dens25=0.2633328 if scat==44;	replace dens5=0.0631993369935072 if scat==44;	replace wt=9150 if scat==44;
replace raduk=-0.0368177 if scat==45;	replace raduk2=0.0767307 if scat==45;	replace radus1=-0.1286675 if scat==45;	replace radus2=0.7976367 if scat==45;	replace radus3=3 if scat==45;	replace dens=0.3995998 if scat==45;	replace dens25=0.2293806 if scat==45;	replace dens5=0.0556854991548141 if scat==45;	replace wt=21416 if scat==45;
replace raduk=-0.2099774 if scat==46;	replace raduk2=0.2303549 if scat==46;	replace radus1=-0.3041276 if scat==46;	replace radus2=2.261585 if scat==46;	replace radus3=3 if scat==46;	replace dens=0.8140604 if scat==46;	replace dens25=0.5748547 if scat==46;	replace dens5=0.152861440768237 if scat==46;	replace wt=22103 if scat==46;
replace raduk=-0.1280787 if scat==49;	replace raduk2=0.0963799 if scat==49;	replace radus1=-0.1110394 if scat==49;	replace radus2=0.6880151 if scat==49;	replace radus3=9 if scat==49;	replace dens=0.492695 if scat==49;	replace dens25=0.2858597 if scat==49;	replace dens5=0.0693543119736873 if scat==49;	replace wt=13921 if scat==49;
replace raduk=-0.0913388 if scat==51;	replace raduk2=0.0723951 if scat==51;	replace radus1=-0.0912054 if scat==51;	replace radus2=0.3716125 if scat==51;	replace radus3=3 if scat==51;	replace dens=0.3225465 if scat==51;	replace dens25=0.1679469 if scat==51;	replace dens5=0.0387149427465373 if scat==51;	replace wt=26759 if scat==51;
replace raduk=-0.046956 if scat==52;	replace raduk2=0.0534927 if scat==52;	replace radus1=-0.0642317 if scat==52;	replace radus2=0.2123378 if scat==52;	replace radus3=5 if scat==52;	replace dens=0.3209611 if scat==52;	replace dens25=0.1721329 if scat==52;	replace dens5=0.0404100563851761 if scat==52;	replace wt=14914 if scat==52;
replace raduk=-0.0984193 if scat==53;	replace raduk2=0.1580099 if scat==53;	replace radus1=-0.1760297 if scat==53;	replace radus2=0.5900409 if scat==53;	replace radus3=7 if scat==53;	replace dens=0.3918793 if scat==53;	replace dens25=0.2181685 if scat==53;	replace dens5=0.0503599506098181 if scat==53;	replace wt=15497 if scat==53;
replace raduk=-0.1119742 if scat==54;	replace raduk2=0.1683527 if scat==54;	replace radus1=-0.2235945 if scat==54;	replace radus2=1.455234 if scat==54;	replace radus3=5 if scat==54;	replace dens=0.7428123 if scat==54;	replace dens25=0.4905455 if scat==54;	replace dens5=0.126268381075256 if scat==54;	replace wt=11097 if scat==54;
replace raduk=-0.0917172 if scat==55;	replace raduk2=0.1450525 if scat==55;	replace radus1=-0.1880434 if scat==55;	replace radus2=0.5703141 if scat==55;	replace radus3=11 if scat==55;	replace dens=0.4017121 if scat==55;	replace dens25=0.2216017 if scat==55;	replace dens5=0.0519787512132144 if scat==55;	replace wt=19225 if scat==55;
replace raduk=-0.0729579 if scat==59;	replace raduk2=0.12927 if scat==59;	replace radus1=-0.0575639 if scat==59;	replace radus2=0.2036966 if scat==59;	replace radus3=3 if scat==59;	replace dens=0.341494 if scat==59;	replace dens25=0.1725804 if scat==59;	replace dens5=0.0384012958887019 if scat==59;	replace wt=30723 if scat==59;
replace raduk=-0.128743 if scat==61;	replace raduk2=0.2320901 if scat==61;	replace radus1=-0.043844 if scat==61;	replace radus2=0.1975858 if scat==61;	replace radus3=1 if scat==61;	replace dens=0.3311808 if scat==61;	replace dens25=0.1697864 if scat==61;	replace dens5=0.0388751529183601 if scat==61;	replace wt=15100 if scat==61;
replace raduk=-0.2624613 if scat==62;	replace raduk2=0.1158527 if scat==62;	replace radus1=-0.0676221 if scat==62;	replace radus2=0.5023518 if scat==62;	replace radus3=3 if scat==62;	replace dens=0.4060197 if scat==62;	replace dens25=0.2156382 if scat==62;	replace dens5=0.0504911372025768 if scat==62;	replace wt=10395 if scat==62;
replace raduk=-0.0739522 if scat==63;	replace raduk2=0.0814891 if scat==63;	replace radus1=-0.0266137 if scat==63;	replace radus2=0.1475536 if scat==63;	replace radus3=7 if scat==63;	replace dens=0.3676322 if scat==63;	replace dens25=0.1944775 if scat==63;	replace dens5=0.0454996190670126 if scat==63;	replace wt=8577 if scat==63;
replace raduk=-0.2624613 if scat==64;	replace raduk2=0.2517019 if scat==64;	replace radus1=-0.1794326 if scat==64;	replace radus2=1.000599 if scat==64;	replace radus3=1 if scat==64;	replace dens=0.6986929 if scat==64;	replace dens25=0.4479016 if scat==64;	replace dens5=0.112824149860423 if scat==64;	replace wt=9555 if scat==64;
replace raduk=-0.1669329 if scat==65;	replace raduk2=0.0825835 if scat==65;	replace radus1=-0.0346445 if scat==65;	replace radus2=0.0610867 if scat==65;	replace radus3=9 if scat==65;	replace dens=0.3653105 if scat==65;	replace dens25=0.1907342 if scat==65;	replace dens5=0.0439391254652457 if scat==65;	replace wt=16548 if scat==65;
replace raduk=-0.0204822 if scat==66;	replace raduk2=0.0306365 if scat==66;	replace radus1=-0.0163145 if scat==66;	replace radus2=0.1247864 if scat==66;	replace radus3=1 if scat==66;	replace dens=0.3210442 if scat==66;	replace dens25=0.1656418 if scat==66;	replace dens5=0.0384323994064764 if scat==66;	replace wt=5629 if scat==66;
replace raduk=-0.0835194 if scat==67;	replace raduk2=0.1934609 if scat==67;	replace radus1=-0.0525796 if scat==67;	replace radus2=0.5152119 if scat==67;	replace radus3=21 if scat==67;	replace dens=0.3572051 if scat==67;	replace dens25=0.1898535 if scat==67;	replace dens5=0.0445449968058036 if scat==67;	replace wt=4941 if scat==67;
replace raduk=-0.1367601 if scat==68;	replace raduk2=0.1250822 if scat==68;	replace radus1=-0.0356198 if scat==68;	replace radus2=0.1388805 if scat==68;	replace radus3=31 if scat==68;	replace dens=0.3848589 if scat==68;	replace dens25=0.2005491 if scat==68;	replace dens5=0.0459860858035576 if scat==68;	replace wt=15958 if scat==68;
replace raduk=-0.1090132 if scat==69;	replace raduk2=0.0519507 if scat==69;	replace radus1=-0.0731158 if scat==69;	replace radus2=0.2345563 if scat==69;	replace radus3=5 if scat==69;	replace dens=0.3531545 if scat==69;	replace dens25=0.1829572 if scat==69;	replace dens5=0.0399598329140995 if scat==69;	replace wt=59072 if scat==69;
log on;

*** Transform to (0,1);
for any radus2 raduk2: replace X=-X; gen ctp0=ctp;
for var ctp rad* wt: egen ZX=std(X);

*** Regressions;
for any 0 5 10 15 140:
\ sum ctp0 if dist2==X
\ regress ctp0 Zradus1 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus2 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus3 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk2 Zwt [aw=wt] if dist2==X, vce(robust);

*********************************;
** Version 1 Firm              **;
*********************************;

/*** Append raw counts;
use ../data/do-scat-zip-firm-1, clear;
drop if scat==11; levelsof scat, local(ind2);
use ../data/do-scat-zip-firm-2-11, clear;
foreach Q2 of local ind2 {;
append using ../data/do-scat-zip-firm-2-`Q2';
}; compress; save ./data/kk-point1-firm.dta, replace; */

*** Append raw counts;
use ./data/kk-point1-firm.dta, clear;

*** collapse on basic distance bands;
drop if dist>250;
gen dist2=0; for any 20 40 60 80 100 120 140 160 180 200 220 240: replace dist2=X if dist>=X;
collapse (sum) ct, by(dist2 scat) fast;
egen temp1=sum(ct), by(scat); gen ctp=ct/temp1; drop temp1;

*** Add measures;
log off;
gen raduk=.;	gen raduk2=.;	gen radus1=.;	gen radus2=.;	gen radus3=.;	gen dens=.;	gen dens25=.;	gen dens5=.;	gen wt=.;
replace raduk=-0.0198379 if scat==11;	replace raduk2=0.0277897 if scat==11;	replace radus1=-0.0332971 if scat==11;	replace radus2=0.3645043 if scat==11;	replace radus3=13 if scat==11;	replace dens=0.3696547 if scat==11;	replace dens25=0.1946536 if scat==11;	replace dens5=0.0454887204730774 if scat==11;	replace wt=3538 if scat==11;
replace raduk=-0.1159519 if scat==12;	replace raduk2=0.2517019 if scat==12;	replace radus1=-0.0785103 if scat==12;	replace radus2=0.7565737 if scat==12;	replace radus3=5 if scat==12;	replace dens=0.3886623 if scat==12;	replace dens25=0.2132654 if scat==12;	replace dens5=0.0507818802172653 if scat==12;	replace wt=9815 if scat==12;
replace raduk=-0.0166115 if scat==13;	replace raduk2=0.1003343 if scat==13;	replace radus1=-0.0276331 if scat==13;	replace radus2=0.287975 if scat==13;	replace radus3=1 if scat==13;	replace dens=0.3618885 if scat==13;	replace dens25=0.1885018 if scat==13;	replace dens5=0.0438671560450275 if scat==13;	replace wt=2811 if scat==13;
replace raduk=-0.0593522 if scat==14;	replace raduk2=0.0654085 if scat==14;	replace radus1=-0.0278857 if scat==14;	replace radus2=0.2584549 if scat==14;	replace radus3=7 if scat==14;	replace dens=0.4234643 if scat==14;	replace dens25=0.2280165 if scat==14;	replace dens5=0.0536261919954765 if scat==14;	replace wt=14874 if scat==14;
replace raduk=-0.0633798 if scat==15;	replace raduk2=0.0604217 if scat==15;	replace radus1=-0.1618362 if scat==15;	replace radus2=0.7311743 if scat==15;	replace radus3=19 if scat==15;	replace dens=0.383683 if scat==15;	replace dens25=0.2157006 if scat==15;	replace dens5=0.0525435565138767 if scat==15;	replace wt=20334 if scat==15;
replace raduk=-0.1009116 if scat==19;	replace raduk2=0.1213181 if scat==19;	replace radus1=-0.1765426 if scat==19;	replace radus2=0.6590498 if scat==19;	replace radus3=5 if scat==19;	replace dens=0.4093788 if scat==19;	replace dens25=0.2261125 if scat==19;	replace dens5=0.0533867547487237 if scat==19;	replace wt=58819 if scat==19;
replace raduk=-0.1294203 if scat==21;	replace raduk2=0.1068486 if scat==21;	replace radus1=-0.1883979 if scat==21;	replace radus2=1.127412 if scat==21;	replace radus3=5 if scat==21;	replace dens=0.5830225 if scat==21;	replace dens25=0.3581223 if scat==21;	replace dens5=0.0884082710179898 if scat==21;	replace wt=49044 if scat==21;
replace raduk=-0.1860441 if scat==22;	replace raduk2=0.131689 if scat==22;	replace radus1=-0.1987305 if scat==22;	replace radus2=1.78406 if scat==22;	replace radus3=3 if scat==22;	replace dens=0.7036251 if scat==22;	replace dens25=0.498306 if scat==22;	replace dens5=0.13474623867754 if scat==22;	replace wt=66253 if scat==22;
replace raduk=-0.1614425 if scat==23;	replace raduk2=0.0816009 if scat==23;	replace radus1=-0.1943118 if scat==23;	replace radus2=1.419619 if scat==23;	replace radus3=3 if scat==23;	replace dens=0.6578254 if scat==23;	replace dens25=0.3976775 if scat==23;	replace dens5=0.0979000037768882 if scat==23;	replace wt=9553 if scat==23;
replace raduk=-0.0969733 if scat==24;	replace raduk2=0.0878555 if scat==24;	replace radus1=-0.1515071 if scat==24;	replace radus2=3.446713 if scat==24;	replace radus3=3 if scat==24;	replace dens=0.7667291 if scat==24;	replace dens25=0.520526 if scat==24;	replace dens5=0.135248441292056 if scat==24;	replace wt=15077 if scat==24;
replace raduk=-0.1955293 if scat==31;	replace raduk2=0.2434118 if scat==31;	replace radus1=-0.114233 if scat==31;	replace radus2=0.3867036 if scat==31;	replace radus3=15 if scat==31;	replace dens=0.4397548 if scat==31;	replace dens25=0.2407241 if scat==31;	replace dens5=0.0559351802740515 if scat==31;	replace wt=32437 if scat==31;
replace raduk=-0.2385246 if scat==32;	replace raduk2=0.1209807 if scat==32;	replace radus1=-0.2237123 if scat==32;	replace radus2=1.385455 if scat==32;	replace radus3=3 if scat==32;	replace dens=0.5555738 if scat==32;	replace dens25=0.3374379 if scat==32;	replace dens5=0.0832545047511762 if scat==32;	replace wt=37698 if scat==32;
replace raduk=-0.2498023 if scat==33;	replace raduk2=0.1170401 if scat==33;	replace radus1=-0.1334017 if scat==33;	replace radus2=0.470399 if scat==33;	replace radus3=3 if scat==33;	replace dens=0.5195239 if scat==33;	replace dens25=0.3117965 if scat==33;	replace dens5=0.0768380967720596 if scat==33;	replace wt=20855 if scat==33;
replace raduk=-0.0801338 if scat==39;	replace raduk2=0.0790038 if scat==39;	replace radus1=-0.0805078 if scat==39;	replace radus2=0.4313131 if scat==39;	replace radus3=5 if scat==39;	replace dens=0.4578665 if scat==39;	replace dens25=0.2480639 if scat==39;	replace dens5=0.0584926368216313 if scat==39;	replace wt=6529 if scat==39;
replace raduk=-0.0483683 if scat==41;	replace raduk2=0.032029 if scat==41;	replace radus1=-0.2438111 if scat==41;	replace radus2=1.271911 if scat==41;	replace radus3=3 if scat==41;	replace dens=0.4612692 if scat==41;	replace dens25=0.2771738 if scat==41;	replace dens5=0.068738073323491 if scat==41;	replace wt=20329 if scat==41;
replace raduk=-0.0366161 if scat==42;	replace raduk2=0.1285575 if scat==42;	replace radus1=-0.0969815 if scat==42;	replace radus2=0.7310153 if scat==42;	replace radus3=3 if scat==42;	replace dens=0.4527923 if scat==42;	replace dens25=0.2530301 if scat==42;	replace dens5=0.060429455368926 if scat==42;	replace wt=10499 if scat==42;
replace raduk=-0.1339971 if scat==43;	replace raduk2=0.1130004 if scat==43;	replace radus1=-0.1459338 if scat==43;	replace radus2=0.9357345 if scat==43;	replace radus3=15 if scat==43;	replace dens=0.4287362 if scat==43;	replace dens25=0.2455219 if scat==43;	replace dens5=0.059257604929654 if scat==43;	replace wt=19661 if scat==43;
replace raduk=-0.086623 if scat==44;	replace raduk2=0.1598728 if scat==44;	replace radus1=-0.1359979 if scat==44;	replace radus2=0.876117 if scat==44;	replace radus3=5 if scat==44;	replace dens=0.4670553 if scat==44;	replace dens25=0.2633328 if scat==44;	replace dens5=0.0631993369935072 if scat==44;	replace wt=9150 if scat==44;
replace raduk=-0.0368177 if scat==45;	replace raduk2=0.0767307 if scat==45;	replace radus1=-0.1286675 if scat==45;	replace radus2=0.7976367 if scat==45;	replace radus3=3 if scat==45;	replace dens=0.3995998 if scat==45;	replace dens25=0.2293806 if scat==45;	replace dens5=0.0556854991548141 if scat==45;	replace wt=21416 if scat==45;
replace raduk=-0.2099774 if scat==46;	replace raduk2=0.2303549 if scat==46;	replace radus1=-0.3041276 if scat==46;	replace radus2=2.261585 if scat==46;	replace radus3=3 if scat==46;	replace dens=0.8140604 if scat==46;	replace dens25=0.5748547 if scat==46;	replace dens5=0.152861440768237 if scat==46;	replace wt=22103 if scat==46;
replace raduk=-0.1280787 if scat==49;	replace raduk2=0.0963799 if scat==49;	replace radus1=-0.1110394 if scat==49;	replace radus2=0.6880151 if scat==49;	replace radus3=9 if scat==49;	replace dens=0.492695 if scat==49;	replace dens25=0.2858597 if scat==49;	replace dens5=0.0693543119736873 if scat==49;	replace wt=13921 if scat==49;
replace raduk=-0.0913388 if scat==51;	replace raduk2=0.0723951 if scat==51;	replace radus1=-0.0912054 if scat==51;	replace radus2=0.3716125 if scat==51;	replace radus3=3 if scat==51;	replace dens=0.3225465 if scat==51;	replace dens25=0.1679469 if scat==51;	replace dens5=0.0387149427465373 if scat==51;	replace wt=26759 if scat==51;
replace raduk=-0.046956 if scat==52;	replace raduk2=0.0534927 if scat==52;	replace radus1=-0.0642317 if scat==52;	replace radus2=0.2123378 if scat==52;	replace radus3=5 if scat==52;	replace dens=0.3209611 if scat==52;	replace dens25=0.1721329 if scat==52;	replace dens5=0.0404100563851761 if scat==52;	replace wt=14914 if scat==52;
replace raduk=-0.0984193 if scat==53;	replace raduk2=0.1580099 if scat==53;	replace radus1=-0.1760297 if scat==53;	replace radus2=0.5900409 if scat==53;	replace radus3=7 if scat==53;	replace dens=0.3918793 if scat==53;	replace dens25=0.2181685 if scat==53;	replace dens5=0.0503599506098181 if scat==53;	replace wt=15497 if scat==53;
replace raduk=-0.1119742 if scat==54;	replace raduk2=0.1683527 if scat==54;	replace radus1=-0.2235945 if scat==54;	replace radus2=1.455234 if scat==54;	replace radus3=5 if scat==54;	replace dens=0.7428123 if scat==54;	replace dens25=0.4905455 if scat==54;	replace dens5=0.126268381075256 if scat==54;	replace wt=11097 if scat==54;
replace raduk=-0.0917172 if scat==55;	replace raduk2=0.1450525 if scat==55;	replace radus1=-0.1880434 if scat==55;	replace radus2=0.5703141 if scat==55;	replace radus3=11 if scat==55;	replace dens=0.4017121 if scat==55;	replace dens25=0.2216017 if scat==55;	replace dens5=0.0519787512132144 if scat==55;	replace wt=19225 if scat==55;
replace raduk=-0.0729579 if scat==59;	replace raduk2=0.12927 if scat==59;	replace radus1=-0.0575639 if scat==59;	replace radus2=0.2036966 if scat==59;	replace radus3=3 if scat==59;	replace dens=0.341494 if scat==59;	replace dens25=0.1725804 if scat==59;	replace dens5=0.0384012958887019 if scat==59;	replace wt=30723 if scat==59;
replace raduk=-0.128743 if scat==61;	replace raduk2=0.2320901 if scat==61;	replace radus1=-0.043844 if scat==61;	replace radus2=0.1975858 if scat==61;	replace radus3=1 if scat==61;	replace dens=0.3311808 if scat==61;	replace dens25=0.1697864 if scat==61;	replace dens5=0.0388751529183601 if scat==61;	replace wt=15100 if scat==61;
replace raduk=-0.2624613 if scat==62;	replace raduk2=0.1158527 if scat==62;	replace radus1=-0.0676221 if scat==62;	replace radus2=0.5023518 if scat==62;	replace radus3=3 if scat==62;	replace dens=0.4060197 if scat==62;	replace dens25=0.2156382 if scat==62;	replace dens5=0.0504911372025768 if scat==62;	replace wt=10395 if scat==62;
replace raduk=-0.0739522 if scat==63;	replace raduk2=0.0814891 if scat==63;	replace radus1=-0.0266137 if scat==63;	replace radus2=0.1475536 if scat==63;	replace radus3=7 if scat==63;	replace dens=0.3676322 if scat==63;	replace dens25=0.1944775 if scat==63;	replace dens5=0.0454996190670126 if scat==63;	replace wt=8577 if scat==63;
replace raduk=-0.2624613 if scat==64;	replace raduk2=0.2517019 if scat==64;	replace radus1=-0.1794326 if scat==64;	replace radus2=1.000599 if scat==64;	replace radus3=1 if scat==64;	replace dens=0.6986929 if scat==64;	replace dens25=0.4479016 if scat==64;	replace dens5=0.112824149860423 if scat==64;	replace wt=9555 if scat==64;
replace raduk=-0.1669329 if scat==65;	replace raduk2=0.0825835 if scat==65;	replace radus1=-0.0346445 if scat==65;	replace radus2=0.0610867 if scat==65;	replace radus3=9 if scat==65;	replace dens=0.3653105 if scat==65;	replace dens25=0.1907342 if scat==65;	replace dens5=0.0439391254652457 if scat==65;	replace wt=16548 if scat==65;
replace raduk=-0.0204822 if scat==66;	replace raduk2=0.0306365 if scat==66;	replace radus1=-0.0163145 if scat==66;	replace radus2=0.1247864 if scat==66;	replace radus3=1 if scat==66;	replace dens=0.3210442 if scat==66;	replace dens25=0.1656418 if scat==66;	replace dens5=0.0384323994064764 if scat==66;	replace wt=5629 if scat==66;
replace raduk=-0.0835194 if scat==67;	replace raduk2=0.1934609 if scat==67;	replace radus1=-0.0525796 if scat==67;	replace radus2=0.5152119 if scat==67;	replace radus3=21 if scat==67;	replace dens=0.3572051 if scat==67;	replace dens25=0.1898535 if scat==67;	replace dens5=0.0445449968058036 if scat==67;	replace wt=4941 if scat==67;
replace raduk=-0.1367601 if scat==68;	replace raduk2=0.1250822 if scat==68;	replace radus1=-0.0356198 if scat==68;	replace radus2=0.1388805 if scat==68;	replace radus3=31 if scat==68;	replace dens=0.3848589 if scat==68;	replace dens25=0.2005491 if scat==68;	replace dens5=0.0459860858035576 if scat==68;	replace wt=15958 if scat==68;
replace raduk=-0.1090132 if scat==69;	replace raduk2=0.0519507 if scat==69;	replace radus1=-0.0731158 if scat==69;	replace radus2=0.2345563 if scat==69;	replace radus3=5 if scat==69;	replace dens=0.3531545 if scat==69;	replace dens25=0.1829572 if scat==69;	replace dens5=0.0399598329140995 if scat==69;	replace wt=59072 if scat==69;
log on;

*** Transform to (0,1);
for any radus2 raduk2: replace X=-X; gen ctp0=ctp;
for var ctp rad* wt: egen ZX=std(X);

*** Regressions;
for any 0 20 40 60 80 100 120:
\ sum ctp0 if dist2==X
\ regress ctp0 Zradus1 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus2 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus3 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk2 Zwt [aw=wt] if dist2==X, vce(robust);

*********************************;
** Version 2 Firm              **;
*********************************;

*** Append raw counts;
use ./data/kk-point1-firm.dta, clear;

*** collapse on basic distance bands;
drop if dist>250;
gen dist2=0; for any 5 10 15 20 40 60 140: replace dist2=X if dist>=X;
collapse (sum) ct, by(dist2 scat) fast;
egen temp1=sum(ct), by(scat); gen ctp=ct/temp1; drop temp1;

*** Add measures;
log off;
gen raduk=.;	gen raduk2=.;	gen radus1=.;	gen radus2=.;	gen radus3=.;	gen dens=.;	gen dens25=.;	gen dens5=.;	gen wt=.;
replace raduk=-0.0198379 if scat==11;	replace raduk2=0.0277897 if scat==11;	replace radus1=-0.0332971 if scat==11;	replace radus2=0.3645043 if scat==11;	replace radus3=13 if scat==11;	replace dens=0.3696547 if scat==11;	replace dens25=0.1946536 if scat==11;	replace dens5=0.0454887204730774 if scat==11;	replace wt=3538 if scat==11;
replace raduk=-0.1159519 if scat==12;	replace raduk2=0.2517019 if scat==12;	replace radus1=-0.0785103 if scat==12;	replace radus2=0.7565737 if scat==12;	replace radus3=5 if scat==12;	replace dens=0.3886623 if scat==12;	replace dens25=0.2132654 if scat==12;	replace dens5=0.0507818802172653 if scat==12;	replace wt=9815 if scat==12;
replace raduk=-0.0166115 if scat==13;	replace raduk2=0.1003343 if scat==13;	replace radus1=-0.0276331 if scat==13;	replace radus2=0.287975 if scat==13;	replace radus3=1 if scat==13;	replace dens=0.3618885 if scat==13;	replace dens25=0.1885018 if scat==13;	replace dens5=0.0438671560450275 if scat==13;	replace wt=2811 if scat==13;
replace raduk=-0.0593522 if scat==14;	replace raduk2=0.0654085 if scat==14;	replace radus1=-0.0278857 if scat==14;	replace radus2=0.2584549 if scat==14;	replace radus3=7 if scat==14;	replace dens=0.4234643 if scat==14;	replace dens25=0.2280165 if scat==14;	replace dens5=0.0536261919954765 if scat==14;	replace wt=14874 if scat==14;
replace raduk=-0.0633798 if scat==15;	replace raduk2=0.0604217 if scat==15;	replace radus1=-0.1618362 if scat==15;	replace radus2=0.7311743 if scat==15;	replace radus3=19 if scat==15;	replace dens=0.383683 if scat==15;	replace dens25=0.2157006 if scat==15;	replace dens5=0.0525435565138767 if scat==15;	replace wt=20334 if scat==15;
replace raduk=-0.1009116 if scat==19;	replace raduk2=0.1213181 if scat==19;	replace radus1=-0.1765426 if scat==19;	replace radus2=0.6590498 if scat==19;	replace radus3=5 if scat==19;	replace dens=0.4093788 if scat==19;	replace dens25=0.2261125 if scat==19;	replace dens5=0.0533867547487237 if scat==19;	replace wt=58819 if scat==19;
replace raduk=-0.1294203 if scat==21;	replace raduk2=0.1068486 if scat==21;	replace radus1=-0.1883979 if scat==21;	replace radus2=1.127412 if scat==21;	replace radus3=5 if scat==21;	replace dens=0.5830225 if scat==21;	replace dens25=0.3581223 if scat==21;	replace dens5=0.0884082710179898 if scat==21;	replace wt=49044 if scat==21;
replace raduk=-0.1860441 if scat==22;	replace raduk2=0.131689 if scat==22;	replace radus1=-0.1987305 if scat==22;	replace radus2=1.78406 if scat==22;	replace radus3=3 if scat==22;	replace dens=0.7036251 if scat==22;	replace dens25=0.498306 if scat==22;	replace dens5=0.13474623867754 if scat==22;	replace wt=66253 if scat==22;
replace raduk=-0.1614425 if scat==23;	replace raduk2=0.0816009 if scat==23;	replace radus1=-0.1943118 if scat==23;	replace radus2=1.419619 if scat==23;	replace radus3=3 if scat==23;	replace dens=0.6578254 if scat==23;	replace dens25=0.3976775 if scat==23;	replace dens5=0.0979000037768882 if scat==23;	replace wt=9553 if scat==23;
replace raduk=-0.0969733 if scat==24;	replace raduk2=0.0878555 if scat==24;	replace radus1=-0.1515071 if scat==24;	replace radus2=3.446713 if scat==24;	replace radus3=3 if scat==24;	replace dens=0.7667291 if scat==24;	replace dens25=0.520526 if scat==24;	replace dens5=0.135248441292056 if scat==24;	replace wt=15077 if scat==24;
replace raduk=-0.1955293 if scat==31;	replace raduk2=0.2434118 if scat==31;	replace radus1=-0.114233 if scat==31;	replace radus2=0.3867036 if scat==31;	replace radus3=15 if scat==31;	replace dens=0.4397548 if scat==31;	replace dens25=0.2407241 if scat==31;	replace dens5=0.0559351802740515 if scat==31;	replace wt=32437 if scat==31;
replace raduk=-0.2385246 if scat==32;	replace raduk2=0.1209807 if scat==32;	replace radus1=-0.2237123 if scat==32;	replace radus2=1.385455 if scat==32;	replace radus3=3 if scat==32;	replace dens=0.5555738 if scat==32;	replace dens25=0.3374379 if scat==32;	replace dens5=0.0832545047511762 if scat==32;	replace wt=37698 if scat==32;
replace raduk=-0.2498023 if scat==33;	replace raduk2=0.1170401 if scat==33;	replace radus1=-0.1334017 if scat==33;	replace radus2=0.470399 if scat==33;	replace radus3=3 if scat==33;	replace dens=0.5195239 if scat==33;	replace dens25=0.3117965 if scat==33;	replace dens5=0.0768380967720596 if scat==33;	replace wt=20855 if scat==33;
replace raduk=-0.0801338 if scat==39;	replace raduk2=0.0790038 if scat==39;	replace radus1=-0.0805078 if scat==39;	replace radus2=0.4313131 if scat==39;	replace radus3=5 if scat==39;	replace dens=0.4578665 if scat==39;	replace dens25=0.2480639 if scat==39;	replace dens5=0.0584926368216313 if scat==39;	replace wt=6529 if scat==39;
replace raduk=-0.0483683 if scat==41;	replace raduk2=0.032029 if scat==41;	replace radus1=-0.2438111 if scat==41;	replace radus2=1.271911 if scat==41;	replace radus3=3 if scat==41;	replace dens=0.4612692 if scat==41;	replace dens25=0.2771738 if scat==41;	replace dens5=0.068738073323491 if scat==41;	replace wt=20329 if scat==41;
replace raduk=-0.0366161 if scat==42;	replace raduk2=0.1285575 if scat==42;	replace radus1=-0.0969815 if scat==42;	replace radus2=0.7310153 if scat==42;	replace radus3=3 if scat==42;	replace dens=0.4527923 if scat==42;	replace dens25=0.2530301 if scat==42;	replace dens5=0.060429455368926 if scat==42;	replace wt=10499 if scat==42;
replace raduk=-0.1339971 if scat==43;	replace raduk2=0.1130004 if scat==43;	replace radus1=-0.1459338 if scat==43;	replace radus2=0.9357345 if scat==43;	replace radus3=15 if scat==43;	replace dens=0.4287362 if scat==43;	replace dens25=0.2455219 if scat==43;	replace dens5=0.059257604929654 if scat==43;	replace wt=19661 if scat==43;
replace raduk=-0.086623 if scat==44;	replace raduk2=0.1598728 if scat==44;	replace radus1=-0.1359979 if scat==44;	replace radus2=0.876117 if scat==44;	replace radus3=5 if scat==44;	replace dens=0.4670553 if scat==44;	replace dens25=0.2633328 if scat==44;	replace dens5=0.0631993369935072 if scat==44;	replace wt=9150 if scat==44;
replace raduk=-0.0368177 if scat==45;	replace raduk2=0.0767307 if scat==45;	replace radus1=-0.1286675 if scat==45;	replace radus2=0.7976367 if scat==45;	replace radus3=3 if scat==45;	replace dens=0.3995998 if scat==45;	replace dens25=0.2293806 if scat==45;	replace dens5=0.0556854991548141 if scat==45;	replace wt=21416 if scat==45;
replace raduk=-0.2099774 if scat==46;	replace raduk2=0.2303549 if scat==46;	replace radus1=-0.3041276 if scat==46;	replace radus2=2.261585 if scat==46;	replace radus3=3 if scat==46;	replace dens=0.8140604 if scat==46;	replace dens25=0.5748547 if scat==46;	replace dens5=0.152861440768237 if scat==46;	replace wt=22103 if scat==46;
replace raduk=-0.1280787 if scat==49;	replace raduk2=0.0963799 if scat==49;	replace radus1=-0.1110394 if scat==49;	replace radus2=0.6880151 if scat==49;	replace radus3=9 if scat==49;	replace dens=0.492695 if scat==49;	replace dens25=0.2858597 if scat==49;	replace dens5=0.0693543119736873 if scat==49;	replace wt=13921 if scat==49;
replace raduk=-0.0913388 if scat==51;	replace raduk2=0.0723951 if scat==51;	replace radus1=-0.0912054 if scat==51;	replace radus2=0.3716125 if scat==51;	replace radus3=3 if scat==51;	replace dens=0.3225465 if scat==51;	replace dens25=0.1679469 if scat==51;	replace dens5=0.0387149427465373 if scat==51;	replace wt=26759 if scat==51;
replace raduk=-0.046956 if scat==52;	replace raduk2=0.0534927 if scat==52;	replace radus1=-0.0642317 if scat==52;	replace radus2=0.2123378 if scat==52;	replace radus3=5 if scat==52;	replace dens=0.3209611 if scat==52;	replace dens25=0.1721329 if scat==52;	replace dens5=0.0404100563851761 if scat==52;	replace wt=14914 if scat==52;
replace raduk=-0.0984193 if scat==53;	replace raduk2=0.1580099 if scat==53;	replace radus1=-0.1760297 if scat==53;	replace radus2=0.5900409 if scat==53;	replace radus3=7 if scat==53;	replace dens=0.3918793 if scat==53;	replace dens25=0.2181685 if scat==53;	replace dens5=0.0503599506098181 if scat==53;	replace wt=15497 if scat==53;
replace raduk=-0.1119742 if scat==54;	replace raduk2=0.1683527 if scat==54;	replace radus1=-0.2235945 if scat==54;	replace radus2=1.455234 if scat==54;	replace radus3=5 if scat==54;	replace dens=0.7428123 if scat==54;	replace dens25=0.4905455 if scat==54;	replace dens5=0.126268381075256 if scat==54;	replace wt=11097 if scat==54;
replace raduk=-0.0917172 if scat==55;	replace raduk2=0.1450525 if scat==55;	replace radus1=-0.1880434 if scat==55;	replace radus2=0.5703141 if scat==55;	replace radus3=11 if scat==55;	replace dens=0.4017121 if scat==55;	replace dens25=0.2216017 if scat==55;	replace dens5=0.0519787512132144 if scat==55;	replace wt=19225 if scat==55;
replace raduk=-0.0729579 if scat==59;	replace raduk2=0.12927 if scat==59;	replace radus1=-0.0575639 if scat==59;	replace radus2=0.2036966 if scat==59;	replace radus3=3 if scat==59;	replace dens=0.341494 if scat==59;	replace dens25=0.1725804 if scat==59;	replace dens5=0.0384012958887019 if scat==59;	replace wt=30723 if scat==59;
replace raduk=-0.128743 if scat==61;	replace raduk2=0.2320901 if scat==61;	replace radus1=-0.043844 if scat==61;	replace radus2=0.1975858 if scat==61;	replace radus3=1 if scat==61;	replace dens=0.3311808 if scat==61;	replace dens25=0.1697864 if scat==61;	replace dens5=0.0388751529183601 if scat==61;	replace wt=15100 if scat==61;
replace raduk=-0.2624613 if scat==62;	replace raduk2=0.1158527 if scat==62;	replace radus1=-0.0676221 if scat==62;	replace radus2=0.5023518 if scat==62;	replace radus3=3 if scat==62;	replace dens=0.4060197 if scat==62;	replace dens25=0.2156382 if scat==62;	replace dens5=0.0504911372025768 if scat==62;	replace wt=10395 if scat==62;
replace raduk=-0.0739522 if scat==63;	replace raduk2=0.0814891 if scat==63;	replace radus1=-0.0266137 if scat==63;	replace radus2=0.1475536 if scat==63;	replace radus3=7 if scat==63;	replace dens=0.3676322 if scat==63;	replace dens25=0.1944775 if scat==63;	replace dens5=0.0454996190670126 if scat==63;	replace wt=8577 if scat==63;
replace raduk=-0.2624613 if scat==64;	replace raduk2=0.2517019 if scat==64;	replace radus1=-0.1794326 if scat==64;	replace radus2=1.000599 if scat==64;	replace radus3=1 if scat==64;	replace dens=0.6986929 if scat==64;	replace dens25=0.4479016 if scat==64;	replace dens5=0.112824149860423 if scat==64;	replace wt=9555 if scat==64;
replace raduk=-0.1669329 if scat==65;	replace raduk2=0.0825835 if scat==65;	replace radus1=-0.0346445 if scat==65;	replace radus2=0.0610867 if scat==65;	replace radus3=9 if scat==65;	replace dens=0.3653105 if scat==65;	replace dens25=0.1907342 if scat==65;	replace dens5=0.0439391254652457 if scat==65;	replace wt=16548 if scat==65;
replace raduk=-0.0204822 if scat==66;	replace raduk2=0.0306365 if scat==66;	replace radus1=-0.0163145 if scat==66;	replace radus2=0.1247864 if scat==66;	replace radus3=1 if scat==66;	replace dens=0.3210442 if scat==66;	replace dens25=0.1656418 if scat==66;	replace dens5=0.0384323994064764 if scat==66;	replace wt=5629 if scat==66;
replace raduk=-0.0835194 if scat==67;	replace raduk2=0.1934609 if scat==67;	replace radus1=-0.0525796 if scat==67;	replace radus2=0.5152119 if scat==67;	replace radus3=21 if scat==67;	replace dens=0.3572051 if scat==67;	replace dens25=0.1898535 if scat==67;	replace dens5=0.0445449968058036 if scat==67;	replace wt=4941 if scat==67;
replace raduk=-0.1367601 if scat==68;	replace raduk2=0.1250822 if scat==68;	replace radus1=-0.0356198 if scat==68;	replace radus2=0.1388805 if scat==68;	replace radus3=31 if scat==68;	replace dens=0.3848589 if scat==68;	replace dens25=0.2005491 if scat==68;	replace dens5=0.0459860858035576 if scat==68;	replace wt=15958 if scat==68;
replace raduk=-0.1090132 if scat==69;	replace raduk2=0.0519507 if scat==69;	replace radus1=-0.0731158 if scat==69;	replace radus2=0.2345563 if scat==69;	replace radus3=5 if scat==69;	replace dens=0.3531545 if scat==69;	replace dens25=0.1829572 if scat==69;	replace dens5=0.0399598329140995 if scat==69;	replace wt=59072 if scat==69;
log on;

*** Transform to (0,1);
for any radus2 raduk2: replace X=-X; gen ctp0=ctp;
for var ctp rad* wt: egen ZX=std(X);

*** Regressions;
for any 0 5 10 15 40:
\ sum ctp0 if dist2==X
\ regress ctp0 Zradus1 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus2 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zradus3 Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk Zwt [aw=wt] if dist2==X, vce(robust)
\ regress ctp0 Zraduk2 Zwt [aw=wt] if dist2==X, vce(robust);

*** End of program;
log close; 