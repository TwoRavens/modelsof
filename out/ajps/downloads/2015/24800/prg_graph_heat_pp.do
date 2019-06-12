# delimit ; 

quietly{; g pcat = 1 if(p<=.1&p!=.); forval k = 2/10 {; 
replace pcat = `k' if(p>(`k'-1)/10&p<=(`k')/10&p!=.); };
g zero = 35 if(c1==5); replace zero = 35 if(c1==20); };

gr tw 
(scatter c1 extv if(pcat==10), mc(gs0) msiz(vhuge) m(S)) 
(scatter c1 extv if(pcat==9), mc(gs2) msiz(vhuge) m(S))
(scatter c1 extv if(pcat==8), mc(gs4) msiz(vhuge) m(S))
(scatter c1 extv if(pcat==7), mc(gs6) msiz(vhuge) m(S))
(scatter c1 extv if(pcat==6), mc(gs8) msiz(vhuge) m(S))
(scatter c1 extv if(pcat==5), mc(gs10) msiz(vhuge) m(S))
(scatter c1 extv if(pcat==4), mc(gs11) msiz(vhuge) m(S)) 
(scatter c1 extv if(pcat==3), mc(gs12) msiz(vhuge) m(S))
(scatter c1 extv if(pcat==2), mc(gs13) msiz(vhuge) m(S))
(scatter c1 extv if(pcat==1), mc(gs14) msiz(vhuge) m(S))

(scatter c1 extv if(pcat==10&N>10&N<20), mfc(none) mc(white) msiz(medium)) 
(scatter c1 extv if(pcat==9&N>10&N<20), mfc(none) mc(white) msiz(medium)) 
(scatter c1 extv if(pcat==8&N>10&N<20), mfc(none) mc(white) msiz(medium)) 
(scatter c1 extv if(pcat==7&N>10&N<20), mfc(none) mc(white) msiz(medium)) 
(scatter c1 extv if(pcat==6&N>10&N<20), mfc(none) mc(black) msiz(medium)) 
(scatter c1 extv if(pcat==5&N>10&N<20), mfc(none) mc(black) msiz(medium)) 
(scatter c1 extv if(pcat==4&N>10&N<20), mfc(none) mc(black) msiz(medium)) 
(scatter c1 extv if(pcat==3&N>10&N<20), mfc(none) mc(black) msiz(medium)) 
(scatter c1 extv if(pcat==2&N>10&N<20), mfc(none) mc(black) msiz(medium)) 
(scatter c1 extv if(pcat==1&N>10&N<20), mfc(none) mc(black) msiz(medium))

(scatter c1 extv if(pcat==10&N>=20), mfc(none) mc(white) msiz(large)) 
(scatter c1 extv if(pcat==9&N>=20), mfc(none) mc(white) msiz(large)) 
(scatter c1 extv if(pcat==8&N>=20), mfc(none) mc(white) msiz(large)) 
(scatter c1 extv if(pcat==7&N>=20), mfc(none) mc(white) msiz(large)) 
(scatter c1 extv if(pcat==6&N>=20), mfc(none) mc(black) msiz(large)) 
(scatter c1 extv if(pcat==5&N>=20), mfc(none) mc(black) msiz(large)) 
(scatter c1 extv if(pcat==4&N>=20), mfc(none) mc(black) msiz(large)) 
(scatter c1 extv if(pcat==3&N>=20), mfc(none) mc(black) msiz(large)) 
(scatter c1 extv if(pcat==2&N>=20), mfc(none) mc(black) msiz(large)) 
(scatter c1 extv if(pcat==1&N>=20), mfc(none) mc(black) msiz(large)) 

(lowess c1 extv if(p>.45&p<.55), lc(black) lw(thick) lp(solid))
(line c1 zero, lc(black) lp(dash) lw(thick)),
`graphr' leg(off) xti("") yti("") `set' xsc(range(5 65)) xlab(5(10)65) 
name(plot`j', replace); 