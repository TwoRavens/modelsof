****************************
*Replication code for Box-Steffensmeier, Christenson, and Hitt:
*Quality Over Quantity: Amici Influence and Judicial Decision Making
*If you use these data, please cite the original paper found in Vol. 107, Issue 3 of the American Political Science Review
****************************

*Table 1

sum newmqscore
sum evcMaxLibALT
sum evcMaxConALT
sum sglibac
sum sgconac
sum libresource
sum consresource
sum lowerdir

*Table 3

	*Column 1
	
probit justdir2 evcMaxLibALTst evcMaxConALTst evcMaxLibALTstXideo evcMaxConALTstXideo newmqscore sglibac sgconac libresource consresource lowerdir if  bigCountAdvgL == 1, cluster(id)

	*Column 2

margins, at(evcMaxLibALTst = (0.07 2.33) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(evcMaxConALTst = (0.07 2.34) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(newmqscore = (6.27 10.57) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(sglibac = (1 2) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(sgconac = (1 2) sglibac = (1) lowerdir = (1) ) atmeans grand

margins, at(libresource = (5.18 7.95) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(consresource = (7.47 9.94) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(lowerdir = (1 2) sgconac = (1) sglibac = (1) ) atmeans grand


	*Column 3
	
probit justdir2 evcMaxLibALTst evcMaxConALTst evcMaxLibALTstXideo evcMaxConALTstXideo newmqscore sglibac sgconac libresource consresource lowerdir if  bigCountAdvgL == 0, cluster(id)

	*Column 4
	
margins, at(evcMaxLibALTst = (0.07 2.33) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(evcMaxConALTst = (0.07 2.34) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(newmqscore = (6.27 10.57) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(sglibac = (1 2) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(sgconac = (1 2) sglibac = (1) lowerdir = (1) ) atmeans grand

margins, at(libresource = (5.18 7.95) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(consresource = (7.47 9.94) sglibac = (1) sgconac = (1) lowerdir = (1) ) atmeans grand

margins, at(lowerdir = (1 2) sgconac = (1) sglibac = (1) ) atmeans grand


*Figure 2

hist libcon_disparity

*Figure 3

	*Panel (a), liberal interaction
graph twoway (rarea p2_noAD_libINT_libJ_lb p2_noAD_libINT_libJ_ub axis) (rarea p2_noAD_libINT_modJ_lb p2_noAD_libINT_modJ_ub axis) ///
(rarea p2_noAD_libINT_conJ_lb p2_noAD_libINT_conJ_ub axis) (line p2_noAD_libINT_libJp1 axis) /// 
(line  p_noAD_libINT_modJp1 axis) (line p2_noAD_libINT_conJp1 axis), xlabel(0(1)4) ylabel(.3(.1)1)

	*Panel (b), conservative interaction
graph twoway (rarea p2_noAD_conINT_libJ_lb p2_noAD_conINT_libJ_ub axis) (rarea p2_noAD_conINT_modJ_lb p2_noAD_conINT_modJ_ub axis) ///
(rarea p2_noAD_conINT_conJ_lb p2_noAD_conINT_conJ_ub axis) (line p2_noAD_conINT_libJp1 axis) /// 
(line  p_noAD_conINT_modJp1 axis) (line p2_noAD_conINT_conJp1 axis), xlabel(0(1)4) ylabel(.3(.1)1)


