clear *
args tlog flog tloga floga

* Flag screencaps  for online appendix
#delimit ;
local imgList 
	Flag1-SC-ClementsHarmfulVision.pdf
	Flag3-NY-AyotteLiberal.pdf
	Flag2-NV-ReidGarlandWelch.pdf
	Flag5-ToomeyGenerationsRev.pdf
	Flag4-PADPDrNo.pdf
	;
local titleList `"
	`"“Clements Harmful Vision” (Tom Clements for US Senate, SC)"'
	`"“Ayotte Liberal” (Kelly Ayotte for US Senate, NH)"'
	`"“Reid Garland Welch” (Harry Reid for US Senate, NV)"'
	`"“Toomey Generations (Revised)” (Pat Toomey for US Senate, PA)"'
	`"“Dr. No” (Dan Connolly for Congress, PA-08)"'
	"';
#delimit cr

dumptotex, log("`floga'") append line("\clearpage ")
forval i=1/`: word count `imgList'' {
	local img : word `i' of `imgList'
	copy rawLatexAndImages/`img' latexOutput/plots/`img' , replace
	local title : word `i' of `titleList'
	latexfigure plots/`img', log(`floga') width(0.5\textwidth) nocenter caption(`"`title'"') append
}

