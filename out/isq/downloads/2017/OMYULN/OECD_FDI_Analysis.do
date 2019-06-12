* Summary Stats and Correlations
reg lnoutflow d2_01 d2_92 d2_82 Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d i.ifs_d, cluster(ifs_d)

sum lnoutflow d2_01 d2_92 d2_82 Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d if e(sample) == 1

corr d2_01 d2_92 d2_82 Lcomlang_off Lcomcivrus Llmig_o2d Llmig_d2o



* Models 1, 2 and 3 in the Current Paper
foreach blah in 01 92 82 {
	qui {
	reg lnoutflow d2_`blah' Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d i.ifs_d, cluster(ifs_d)
	est store m`blah'
	}
}
esttab m01 m92 m82, b(a3) se(a3) star(* 0.100 † 0.050 ‡ 0.010) nogap compress drop(*ifs_d) order(d2*) wide



* Colonial legacy check
foreach blah in 01 92 82 {
	qui {
	reg lnoutflow d2_`blah' Lcolony Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lrpta Lcomcurr Latop i.ifs_d, cluster(ifs_d)
	est store mcol`blah'
	}
}
esttab mcol01 mcol92 mcol82, b(a3) se(a3) star(* 0.100 † 0.050 ‡ 0.010) nogap compress drop(*ifs_d) order(d2*)


* Restricting samples
*check comlang_off effect when d2 is zero

	reg lnoutflow Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d i.ifs_d if d2_01 == 0, cluster(ifs_d)

	reg lnoutflow Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d i.ifs_d if d2_92 == 0, cluster(ifs_d)

	reg lnoutflow Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d i.ifs_d if d2_82 == 0, cluster(ifs_d)

	reg lnoutflow Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomlang_off Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d i.ifs_d if d2_82 == 0 & d2_01 == 0 & d2_92 == 0, cluster(ifs_d)

*check d2 effect when comlang is zero

	reg lnoutflow d2_01 Lldist Lcontig Llgdptotal_o Llgdptotal_d Lltrade Lcomcivrus Lcomleg Llmig_o2d Llmig_d2o Lbothifgw Ldtt Lrpta Lcomcurr Latop Lpolity2_d i.ifs_d if Lcomlang_off == 0, cluster(ifs_d)
