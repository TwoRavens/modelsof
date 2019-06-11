* Figure 5
use F5, clear
collapse (mean) nonmode entmax exitmax, by(day strikeswitch)
twoway(line nonmode day if strikes ==1, clwidth(thick))(line nonmode day if strikes ==0, clwidth(thick) legend(lab(1 "Treat") lab(2 "Control")) ytitle("Fraction on mode") xtitle("Day") title("Different station")), name(d, replace)

use F5, clear
collapse (mean) nonmode entmax exitmax, by(day entstrike)
twoway(line nonmode day if entstrike ==1, clwidth(thick))(line nonmode day if entstrike ==0, clwidth(thick) legend(lab(1 "Treat") lab(2 "Control")) ytitle("Fraction on mode") xtitle("Day") title("Entry station strike")), name(a, replace)

use F5, clear
collapse (mean) nonmode entmax exitmax, by(day exitstrike)
twoway(line nonmode day if exitstrike ==1, clwidth(thick))(line nonmode day if exitstrike ==0, clwidth(thick) legend(lab(1 "Treat") lab(2 "Control")) ytitle("Fraction on mode") xtitle("Day") title("Exit station strike")), name(b, replace)

use F5, clear
collapse (mean) nonmode entmax exitmax, by(day str_12)
twoway(line nonmode day if str_12 ==1, clwidth(thick))(line nonmode day if str_12 ==0, clwidth(thick) legend(lab(1 "Treat") lab(2 "Control")) ytitle("Fraction on mode") xtitle("Day") title("Time factor 1.2")), name(e, replace)

use F5, clear
collapse (mean) nonmode entmax exitmax, by(day str_15)
twoway(line nonmode day if str_15 ==1, clwidth(thick))(line nonmode day if str_15 ==0, clwidth(thick) legend(lab(1 "Treat") lab(2 "Control")) ytitle("Fraction on mode") xtitle("Day") title("Time factor 1.5")), name(f, replace)

use F5, clear
collapse (mean) nonmode entmax exitmax, by(day str_2)
twoway(line nonmode day if str_2 ==1, clwidth(thick))(line nonmode day if str_2 ==0, clwidth(thick) legend(lab(1 "Treat") lab(2 "Control")) ytitle("Fraction on mode") xtitle("Day") title("Time factor 2")), name(g, replace)

graph combine d a b e f g, iscale(0.6)
