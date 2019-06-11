version 12.1

**********  Carryover diagnostics
**********  Joint test if attribute effects are identical across chioce tasks
estimates use m10_coeEDU.ster
*joint test
test 2.education#2.n_contest 2.education#3.n_contest 2.education#4.n_contest 2.education#5.n_contest 2.education#6.n_contest ///
	 2.education#7.n_contest 2.education#8.n_contest 2.education#9.n_contest 2.education#10.n_contest 2.education#11.n_contest ///
	 2.education#12.n_contest 2.education#13.n_contest 2.education#14.n_contest 2.education#15.n_contest 2.education#16.n_contest ///
	 2.education#17.n_contest 2.education#18.n_contest 2.education#19.n_contest 2.education#20.n_contest 2.education#21.n_contest ///
	 2.education#22.n_contest 2.education#23.n_contest 2.education#24.n_contest 2.education#25.n_contest 2.education#26.n_contest 2.education#27.n_contest
	 
test 3.education#2.n_contest 3.education#3.n_contest 3.education#4.n_contest 3.education#5.n_contest 3.education#6.n_contest ///
	 3.education#7.n_contest 3.education#8.n_contest 3.education#9.n_contest 3.education#10.n_contest 3.education#11.n_contest ///
	 3.education#12.n_contest 3.education#13.n_contest 3.education#14.n_contest 3.education#15.n_contest 3.education#16.n_contest ///
	 3.education#17.n_contest 3.education#18.n_contest 3.education#19.n_contest 3.education#20.n_contest 3.education#21.n_contest ///
	 3.education#22.n_contest 3.education#23.n_contest 3.education#24.n_contest 3.education#25.n_contest 3.education#26.n_contest 3.education#27.n_contest

estimates use m10_coeINC.ster
*joint test
test 2.income#2.n_contest 2.income#3.n_contest 2.income#4.n_contest 2.income#5.n_contest 2.income#6.n_contest ///
	 2.income#7.n_contest 2.income#8.n_contest 2.income#9.n_contest 2.income#10.n_contest 2.income#11.n_contest ///
	 2.income#12.n_contest 2.income#13.n_contest 2.income#14.n_contest 2.income#15.n_contest 2.income#16.n_contest ///
	 2.income#17.n_contest 2.income#18.n_contest 2.income#19.n_contest 2.income#20.n_contest 2.income#21.n_contest ///
	 2.income#22.n_contest 2.income#23.n_contest 2.income#24.n_contest 2.income#25.n_contest 2.income#26.n_contest 2.income#27.n_contest

test 3.income#2.n_contest 3.income#3.n_contest 3.income#4.n_contest 3.income#5.n_contest 3.income#6.n_contest ///
	 3.income#7.n_contest 3.income#8.n_contest 3.income#9.n_contest 3.income#10.n_contest 3.income#11.n_contest ///
	 3.income#12.n_contest 3.income#13.n_contest 3.income#14.n_contest 3.income#15.n_contest 3.income#16.n_contest ///
	 3.income#17.n_contest 3.income#18.n_contest 3.income#19.n_contest 3.income#20.n_contest 3.income#21.n_contest ///
	 3.income#22.n_contest 3.income#23.n_contest 3.income#24.n_contest 3.income#25.n_contest 3.income#26.n_contest 3.income#27.n_contest
	 
estimates use m10_coeCOR.ster
*joint test
test 2.corruption#2.n_contest 2.corruption#3.n_contest 2.corruption#4.n_contest 2.corruption#5.n_contest 2.corruption#6.n_contest ///
	 2.corruption#7.n_contest 2.corruption#8.n_contest 2.corruption#9.n_contest 2.corruption#10.n_contest 2.corruption#11.n_contest ///
	 2.corruption#12.n_contest 2.corruption#13.n_contest 2.corruption#14.n_contest 2.corruption#15.n_contest 2.corruption#16.n_contest ///
	 2.corruption#17.n_contest 2.corruption#18.n_contest 2.corruption#19.n_contest 2.corruption#20.n_contest 2.corruption#21.n_contest ///
	 2.corruption#22.n_contest 2.corruption#23.n_contest 2.corruption#24.n_contest 2.corruption#25.n_contest 2.corruption#26.n_contest 2.corruption#27.n_contest

test 3.corruption#2.n_contest 3.corruption#3.n_contest 3.corruption#4.n_contest 3.corruption#5.n_contest 3.corruption#6.n_contest ///
	 3.corruption#7.n_contest 3.corruption#8.n_contest 3.corruption#9.n_contest 3.corruption#10.n_contest 3.corruption#11.n_contest ///
	 3.corruption#12.n_contest 3.corruption#13.n_contest 3.corruption#14.n_contest 3.corruption#15.n_contest 3.corruption#16.n_contest ///
	 3.corruption#17.n_contest 3.corruption#18.n_contest 3.corruption#19.n_contest 3.corruption#20.n_contest 3.corruption#21.n_contest ///
	 3.corruption#22.n_contest 3.corruption#23.n_contest 3.corruption#24.n_contest 3.corruption#25.n_contest 3.corruption#26.n_contest 3.corruption#27.n_contest

foreach x of numlist 1(1)27 {
lincom 3.corruption + 3.corruption#`x'.n_contest
}
	 
estimates use m10_coeTAX.ster
*joint test
test 2.taxspend#2.n_contest 2.taxspend#3.n_contest 2.taxspend#4.n_contest 2.taxspend#5.n_contest 2.taxspend#6.n_contest ///
	 2.taxspend#7.n_contest 2.taxspend#8.n_contest 2.taxspend#9.n_contest 2.taxspend#10.n_contest 2.taxspend#11.n_contest ///
	 2.taxspend#12.n_contest 2.taxspend#13.n_contest 2.taxspend#14.n_contest 2.taxspend#15.n_contest 2.taxspend#16.n_contest ///
	 2.taxspend#17.n_contest 2.taxspend#18.n_contest 2.taxspend#19.n_contest 2.taxspend#20.n_contest 2.taxspend#21.n_contest ///
	 2.taxspend#22.n_contest 2.taxspend#23.n_contest 2.taxspend#24.n_contest 2.taxspend#25.n_contest 2.taxspend#26.n_contest 2.taxspend#27.n_contest	 

test 3.taxspend#2.n_contest 3.taxspend#3.n_contest 3.taxspend#4.n_contest 3.taxspend#5.n_contest 3.taxspend#6.n_contest ///
	 3.taxspend#7.n_contest 3.taxspend#8.n_contest 3.taxspend#9.n_contest 3.taxspend#10.n_contest 3.taxspend#11.n_contest ///
	 3.taxspend#12.n_contest 3.taxspend#13.n_contest 3.taxspend#14.n_contest 3.taxspend#15.n_contest 3.taxspend#16.n_contest ///
	 3.taxspend#17.n_contest 3.taxspend#18.n_contest 3.taxspend#19.n_contest 3.taxspend#20.n_contest 3.taxspend#21.n_contest ///
	 3.taxspend#22.n_contest 3.taxspend#23.n_contest 3.taxspend#24.n_contest 3.taxspend#25.n_contest 3.taxspend#26.n_contest 3.taxspend#27.n_contest	 

estimates use m10_coeSEX.ster
*joint test
test 2.samesex#2.n_contest 2.samesex#3.n_contest 2.samesex#4.n_contest 2.samesex#5.n_contest 2.samesex#6.n_contest ///
	 2.samesex#7.n_contest 2.samesex#8.n_contest 2.samesex#9.n_contest 2.samesex#10.n_contest 2.samesex#11.n_contest ///
	 2.samesex#12.n_contest 2.samesex#13.n_contest 2.samesex#14.n_contest 2.samesex#15.n_contest 2.samesex#16.n_contest ///
	 2.samesex#17.n_contest 2.samesex#18.n_contest 2.samesex#19.n_contest 2.samesex#20.n_contest 2.samesex#21.n_contest ///
	 2.samesex#22.n_contest 2.samesex#23.n_contest 2.samesex#24.n_contest 2.samesex#25.n_contest 2.samesex#26.n_contest 2.samesex#27.n_contest
	 
test 3.samesex#2.n_contest 3.samesex#3.n_contest 3.samesex#4.n_contest 3.samesex#5.n_contest 3.samesex#6.n_contest ///
	 3.samesex#7.n_contest 3.samesex#8.n_contest 3.samesex#9.n_contest 3.samesex#10.n_contest 3.samesex#11.n_contest ///
	 3.samesex#12.n_contest 3.samesex#13.n_contest 3.samesex#14.n_contest 3.samesex#15.n_contest 3.samesex#16.n_contest ///
	 3.samesex#17.n_contest 3.samesex#18.n_contest 3.samesex#19.n_contest 3.samesex#20.n_contest 3.samesex#21.n_contest ///
	 3.samesex#22.n_contest 3.samesex#23.n_contest 3.samesex#24.n_contest 3.samesex#25.n_contest 3.samesex#26.n_contest 3.samesex#27.n_contest
	 
