# delimit ; 
quietly{; g pcat = 1 if(fd<=-.3&fd!=.); replace pcat = 2 if(fd>-.3&fd<=-.2&fd!=.); 
replace pcat = 2 if(fd>-.2&fd<=-.1&fd!=.); replace pcat = 4 if(fd>-.1&fd<=0&fd!=.);  
replace pcat = 5 if(fd>0&fd<=.1&fd!=.); replace pcat = 6 if(fd>.1&fd<=.2&fd!=.); 
replace pcat = 7 if(fd>.2&fd<=.3&fd!=.); replace pcat = 8 if(fd>.3&fd!=.);
g zero = 35 if(c1==5); replace zero = 35 if(c1==20); }; 

gr tw 
(scatter c1 extv if(pcat==8&N<5), mlc(black) mfc(none) mlw(medthick) 
msiz(large) m(X))
(scatter c1 extv if(pcat==7&N<5), mlc(gs3) mfc(none) mlw(medthick) 
msiz(large) m(X))
(scatter c1 extv if(pcat==6&N<5), mlc(gs6) mfc(none) mlw(medthick) 
msiz(large) m(X))
(scatter c1 extv if(pcat==5&N<5), mlc(gs9) mfc(none) mlw(medthick) 
msiz(large) m(X))
(scatter c1 extv if(pcat==4&N<5), mc(gs9)  msiz(large))
(scatter c1 extv if(pcat==3&N<5), mc(gs6) msiz(large))
(scatter c1 extv if(pcat==2&N<5), mc(gs3) msiz(large))
(scatter c1 extv if(pcat==1&N<5), mc(black) msiz(large))

(scatter c1 extv if(pcat==8&N>=5&N<10), mlc(black) mfc(none) mlw(thick) 
msiz(huge) m(X))
(scatter c1 extv if(pcat==7&N>=5&N<10), mlc(gs3) mfc(none) mlw(thick) 
msiz(huge) m(X))
(scatter c1 extv if(pcat==6&N>=5&N<10), mlc(gs6) mfc(none) mlw(thick) 
msiz(huge) m(X))
(scatter c1 extv if(pcat==5&N>=5&N<10), mlc(gs9) mfc(none) mlw(thick) 
msiz(huge) m(X))
(scatter c1 extv if(pcat==4&N>=5&N<10), mc(gs9)  msiz(huge))
(scatter c1 extv if(pcat==3&N>=5&N<10), mc(gs6) msiz(huge))
(scatter c1 extv if(pcat==2&N>=5&N<10), mc(gs3) msiz(huge))
(scatter c1 extv if(pcat==1&N>=5&N<10), mc(black) msiz(huge))

(scatter c1 extv if(pcat==8&N>=10), mlc(black) mfc(none) mlw(vvthick) msiz(vhuge)
m(X))
(scatter c1 extv if(pcat==7&N>=10), mlc(gs3) mfc(none) mlw(vvthick) msiz(vhuge) 
m(X))
(scatter c1 extv if(pcat==6&N>=10), mlc(gs6) mfc(none) mlw(vvthick) msiz(vhuge) 
m(X))
(scatter c1 extv if(pcat==5&N>=10), mlc(gs9) mfc(none) mlw(vvthick) msiz(vhuge) 
m(X))
(scatter c1 extv if(pcat==4&N>=10), mc(gs9)  msiz(vhuge))
(scatter c1 extv if(pcat==3&N>=10), mc(gs6) msiz(vhuge))
(scatter c1 extv if(pcat==2&N>=10), mc(gs3) msiz(vhuge))
(scatter c1 extv if(pcat==1&N>=10), mc(black) msiz(vhuge))

(line c1 zero, lc(black) lp(dash) lw(thick)),
`graphr' leg(off) xti(type + noise, c(black) si(medium)) yti(choice 1, c(black)
si(medium)) xsc(range(5 65)) xlab(5(10)65) `set' name(plot0, replace);
