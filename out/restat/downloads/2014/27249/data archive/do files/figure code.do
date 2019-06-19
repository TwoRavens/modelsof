

*use "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\rain for graphs by month.dta", clear

use "C:\Users\USER\Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\rain actual.dta", clear

drop if id==20
drop if id==57
drop if id==67
drop if id==68

*1-4
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id<5, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph1-4.gph"

*5-8
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>4 & id<9, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph5-8.gph"

*9-12
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>8 & id<13, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph9-12.gph"

*13-16
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>12 & id<17, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph13-16.gph"

*17-21 (no id==20)
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>16 & id<22, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph17-21.gph"

*22-25
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>21 & id<26, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph22-25.gph"

*26-29
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>25 & id<30, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph26-29.gph"

*30-33
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>29 & id<34, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph30-33.gph"

*34-37
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>33 & id<38, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph34-37.gph"

*38-41
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>37 & id<42, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph38-41.gph"

*42-45
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>41 & id<46, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph42-45.gph"

*46-49
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>45 & id<50, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph46-49.gph"

*50-53
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>49 & id<54, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph50-53.gph"

*54-58 (drop if id==57)
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>53 & id<59, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph54-58.gph"

*59-62
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>58 & id<63, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph59-62.gph"

*63-66 
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>62 & id<69, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph63-66.gph"

*69-72 (drop if id==67, 68)
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>66 & id<73, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph69-72.gph"

*73-76 
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>72 & id<77, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph73-76.gph"

*77-80 
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>76 & id<81, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph77-80.gph"

*81-84 
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>80 & id<85, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph81-84.gph"

*85-88
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>84 & id<89, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(off)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph85-88.gph"

*89-90 
graph bar (asis) janvier fevrier mars avril mai juin juillet aout septembre octobre novembre decembre if id>88, over(year, gap(*3.5) label(labsize(vsmall))) ylabel(, labsize(vsmall)) by(, legend(on)) by(id)
graph save Graph "C:\Documents and Settings\Administrator\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\figures\Graph89-90.gph"




















