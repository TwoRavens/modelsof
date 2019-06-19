* portall_exp.do FILE

* This do-file constructs portfolios from SCF2004

* Alessandro Bucciol (alessandro.bucciol@univr.it)
* University of Verona
* March 2010

********************************************************************



clear
set mem 10m

* Export the dataset
local m 1
while `m'< 6 {
	use SCF04, clear /* The SCF dataset with portfolios */
	keep if imp == `m'

	order id imp x42001 x5702 x5704 x5706 x5708 x5710 x5712 x5714 x5716 x5718 x5720 x5722 x5724 x5729 x101 x8021 x8022 ///
	x8023 x5901 x6809 x6030 x4100 x4106 x7402 x7401 x4112 x4113 x5306 x5307 x103 x104 x105 x6101 x6810 x6124 x4700 ///
	x4706 x7412 x7411 x4712 x4713 x5311 x5312 x301 x3014 x3008 x7112 x3504 x7111 x7100 x6497 x8300 x7132 ///
	x5801 x5802 x5819 x5821 x5824 x5825 ///
	finwth flagfin wftran wfbond wfstok totwth flagtot wttran wtbond wtstok wthcap wtrest wthous

	outfile using SCF04_`m'.txt, comma wide replace
	local m = `m'+1
}
