{smcl}
{com}{sf}{ul off}{txt}{.-}
      name:  {res}<unnamed>
       {txt}log:  {res}C:\Users\carlamm\Dropbox\Working Papers\Transparency&Surprise\Data\LogFPABellMartinezMachain.do
  {txt}log type:  {res}smcl
 {txt}opened on:  {res}18 Sep 2017, 14:01:57

{com}. do "C:\Users\carlamm\AppData\Local\Temp\STD1cd8_000000.tmp"
{txt}
{com}.         eststo clear
{txt}
{com}.         
.         la var private "Private Mobilization"
{txt}
{com}.         la var spii "Retrospective Oversight"
{txt}
{com}.         la var foi "Freedom of Information Index"
{txt}
{com}.         la var lop "Legislative Oversight Index"
{txt}
{com}.         la var cl "Civil Liberties Index"
{txt}
{com}.         la var polity21 "Polity 2 Score, State A"
{txt}
{com}.         la var contigdummy "Contiguous Dyad"
{txt}
{com}.         la var alliance "Alliance"
{txt}
{com}.         la var powerratio "Power Ratio"
{txt}
{com}. 
. 
. 
.         eststo: probit private spii , cluster (ccode1)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-93.469915}  
Iteration 1:{space 3}log pseudolikelihood = {res:-93.259668}  
Iteration 2:{space 3}log pseudolikelihood = {res:-93.258684}  
Iteration 3:{space 3}log pseudolikelihood = {res:-93.258684}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       504
{txt}{col 49}Wald chi2({res}1{txt}){col 67}= {res}      0.45
{txt}{col 49}Prob > chi2{col 67}= {res}    0.5012
{txt}Log pseudolikelihood = {res}-93.258684{txt}{col 49}Pseudo R2{col 67}= {res}    0.0023

{txt}{ralign 78:(Std. Err. adjusted for {res:101} clusters in ccode1)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 8}spii {c |}{col 14}{res}{space 2} .2773586{col 26}{space 2} .4123741{col 37}{space 1}    0.67{col 46}{space 3}0.501{col 54}{space 4}-.5308798{col 67}{space 3} 1.085597
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-1.721168{col 26}{space 2} .1565042{col 37}{space 1}  -11.00{col 46}{space 3}0.000{col 54}{space 4} -2.02791{col 67}{space 3}-1.414425
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est1{txt} stored)

{com}.         
.         eststo: probit private spii polity21 contigdummy alliance powerratio, cluster (ccode1)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-93.187939}  
Iteration 1:{space 3}log pseudolikelihood = {res:-89.570206}  
Iteration 2:{space 3}log pseudolikelihood = {res:-89.476246}  
Iteration 3:{space 3}log pseudolikelihood = {res:-89.476058}  
Iteration 4:{space 3}log pseudolikelihood = {res:-89.476058}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       498
{txt}{col 49}Wald chi2({res}5{txt}){col 67}= {res}     17.44
{txt}{col 49}Prob > chi2{col 67}= {res}    0.0037
{txt}Log pseudolikelihood = {res}-89.476058{txt}{col 49}Pseudo R2{col 67}= {res}    0.0398

{txt}{ralign 78:(Std. Err. adjusted for {res:100} clusters in ccode1)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 8}spii {c |}{col 14}{res}{space 2} .8946319{col 26}{space 2} .4199841{col 37}{space 1}    2.13{col 46}{space 3}0.033{col 54}{space 4} .0714781{col 67}{space 3} 1.717786
{txt}{space 4}polity21 {c |}{col 14}{res}{space 2}-.0169334{col 26}{space 2} .0247185{col 37}{space 1}   -0.69{col 46}{space 3}0.493{col 54}{space 4}-.0653807{col 67}{space 3} .0315138
{txt}{space 1}contigdummy {c |}{col 14}{res}{space 2} .5512089{col 26}{space 2} .1628757{col 37}{space 1}    3.38{col 46}{space 3}0.001{col 54}{space 4} .2319784{col 67}{space 3} .8704394
{txt}{space 4}alliance {c |}{col 14}{res}{space 2} .0906769{col 26}{space 2} .0874576{col 37}{space 1}    1.04{col 46}{space 3}0.300{col 54}{space 4}-.0807368{col 67}{space 3} .2620906
{txt}{space 2}powerratio {c |}{col 14}{res}{space 2} .1735556{col 26}{space 2} .3053626{col 37}{space 1}    0.57{col 46}{space 3}0.570{col 54}{space 4} -.424944{col 67}{space 3} .7720552
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-2.587421{col 26}{space 2} .4689602{col 37}{space 1}   -5.52{col 46}{space 3}0.000{col 54}{space 4}-3.506566{col 67}{space 3}-1.668276
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est2{txt} stored)

{com}.         
.         eststo: probit private foi lop cl, cluster(ccode1)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-82.224159}  
Iteration 1:{space 3}log pseudolikelihood = {res: -81.12337}  
Iteration 2:{space 3}log pseudolikelihood = {res:-81.085043}  
Iteration 3:{space 3}log pseudolikelihood = {res:-81.085013}  
Iteration 4:{space 3}log pseudolikelihood = {res:-81.085013}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       459
{txt}{col 49}Wald chi2({res}3{txt}){col 67}= {res}      6.66
{txt}{col 49}Prob > chi2{col 67}= {res}    0.0834
{txt}Log pseudolikelihood = {res}-81.085013{txt}{col 49}Pseudo R2{col 67}= {res}    0.0139

{txt}{ralign 78:(Std. Err. adjusted for {res:101} clusters in ccode1)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 9}foi {c |}{col 14}{res}{space 2}-.7210244{col 26}{space 2} .8139022{col 37}{space 1}   -0.89{col 46}{space 3}0.376{col 54}{space 4}-2.316243{col 67}{space 3} .8741947
{txt}{space 9}lop {c |}{col 14}{res}{space 2} 1.035887{col 26}{space 2} .4896573{col 37}{space 1}    2.12{col 46}{space 3}0.034{col 54}{space 4} .0761766{col 67}{space 3} 1.995598
{txt}{space 10}cl {c |}{col 14}{res}{space 2}  .025793{col 26}{space 2} .0723979{col 37}{space 1}    0.36{col 46}{space 3}0.722{col 54}{space 4}-.1161042{col 67}{space 3} .1676902
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-1.910113{col 26}{space 2} .4136339{col 37}{space 1}   -4.62{col 46}{space 3}0.000{col 54}{space 4}-2.720821{col 67}{space 3}-1.099406
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est3{txt} stored)

{com}.         
.         eststo: probit private foi lop cl polity21 contigdummy alliance powerratio, cluster(ccode1)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-81.955051}  
Iteration 1:{space 3}log pseudolikelihood = {res:-77.378779}  
Iteration 2:{space 3}log pseudolikelihood = {res:-77.205776}  
Iteration 3:{space 3}log pseudolikelihood = {res:-77.205163}  
Iteration 4:{space 3}log pseudolikelihood = {res:-77.205163}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       453
{txt}{col 49}Wald chi2({res}7{txt}){col 67}= {res}     16.85
{txt}{col 49}Prob > chi2{col 67}= {res}    0.0184
{txt}Log pseudolikelihood = {res}-77.205163{txt}{col 49}Pseudo R2{col 67}= {res}    0.0580

{txt}{ralign 78:(Std. Err. adjusted for {res:100} clusters in ccode1)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 9}foi {c |}{col 14}{res}{space 2}-.5853703{col 26}{space 2} .7545945{col 37}{space 1}   -0.78{col 46}{space 3}0.438{col 54}{space 4}-2.064348{col 67}{space 3} .8936078
{txt}{space 9}lop {c |}{col 14}{res}{space 2}  1.15307{col 26}{space 2} .4667306{col 37}{space 1}    2.47{col 46}{space 3}0.013{col 54}{space 4} .2382947{col 67}{space 3} 2.067845
{txt}{space 10}cl {c |}{col 14}{res}{space 2} .0463067{col 26}{space 2} .1141373{col 37}{space 1}    0.41{col 46}{space 3}0.685{col 54}{space 4}-.1773983{col 67}{space 3} .2700117
{txt}{space 4}polity21 {c |}{col 14}{res}{space 2} .0048995{col 26}{space 2} .0315918{col 37}{space 1}    0.16{col 46}{space 3}0.877{col 54}{space 4}-.0570194{col 67}{space 3} .0668183
{txt}{space 1}contigdummy {c |}{col 14}{res}{space 2} .5584144{col 26}{space 2} .1824622{col 37}{space 1}    3.06{col 46}{space 3}0.002{col 54}{space 4} .2007951{col 67}{space 3} .9160338
{txt}{space 4}alliance {c |}{col 14}{res}{space 2} .1169906{col 26}{space 2} .0956196{col 37}{space 1}    1.22{col 46}{space 3}0.221{col 54}{space 4}-.0704204{col 67}{space 3} .3044016
{txt}{space 2}powerratio {c |}{col 14}{res}{space 2} .2797834{col 26}{space 2} .3210045{col 37}{space 1}    0.87{col 46}{space 3}0.383{col 54}{space 4} -.349374{col 67}{space 3} .9089407
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-2.946067{col 26}{space 2} .7225414{col 37}{space 1}   -4.08{col 46}{space 3}0.000{col 54}{space 4}-4.362222{col 67}{space 3}-1.529912
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est4{txt} stored)

{com}. 
.         
.         #delimit;
{txt}delimiter now ;
{com}.         esttab _all using Table1.rtf, se starlevels(* .10 ** .05 *** .01) label scalars(N pr2) nodepvars
>         title("Table 1: Probit Models: Retroactive Oversight in Democracies and Private Mobilization, 1970-1994")  replace;
{res}{txt}(output written to {browse  `"Table1.rtf"'})

{com}. 
{txt}end of do-file

{com}. do "C:\Users\carlamm\AppData\Local\Temp\STD1cd8_000000.tmp"
{txt}
{com}. //Figure 1      
.         
. probit private spii polity21 contigdummy alliance powerratio, cluster (ccode1)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-93.187939}  
Iteration 1:{space 3}log pseudolikelihood = {res:-89.570206}  
Iteration 2:{space 3}log pseudolikelihood = {res:-89.476246}  
Iteration 3:{space 3}log pseudolikelihood = {res:-89.476058}  
Iteration 4:{space 3}log pseudolikelihood = {res:-89.476058}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       498
{txt}{col 49}Wald chi2({res}5{txt}){col 67}= {res}     17.44
{txt}{col 49}Prob > chi2{col 67}= {res}    0.0037
{txt}Log pseudolikelihood = {res}-89.476058{txt}{col 49}Pseudo R2{col 67}= {res}    0.0398

{txt}{ralign 78:(Std. Err. adjusted for {res:100} clusters in ccode1)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 8}spii {c |}{col 14}{res}{space 2} .8946319{col 26}{space 2} .4199841{col 37}{space 1}    2.13{col 46}{space 3}0.033{col 54}{space 4} .0714781{col 67}{space 3} 1.717786
{txt}{space 4}polity21 {c |}{col 14}{res}{space 2}-.0169334{col 26}{space 2} .0247185{col 37}{space 1}   -0.69{col 46}{space 3}0.493{col 54}{space 4}-.0653807{col 67}{space 3} .0315138
{txt}{space 1}contigdummy {c |}{col 14}{res}{space 2} .5512089{col 26}{space 2} .1628757{col 37}{space 1}    3.38{col 46}{space 3}0.001{col 54}{space 4} .2319784{col 67}{space 3} .8704394
{txt}{space 4}alliance {c |}{col 14}{res}{space 2} .0906769{col 26}{space 2} .0874576{col 37}{space 1}    1.04{col 46}{space 3}0.300{col 54}{space 4}-.0807368{col 67}{space 3} .2620906
{txt}{space 2}powerratio {c |}{col 14}{res}{space 2} .1735556{col 26}{space 2} .3053626{col 37}{space 1}    0.57{col 46}{space 3}0.570{col 54}{space 4} -.424944{col 67}{space 3} .7720552
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-2.587421{col 26}{space 2} .4689602{col 37}{space 1}   -5.52{col 46}{space 3}0.000{col 54}{space 4}-3.506566{col 67}{space 3}-1.668276
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}

{com}. margins, at ((means) _all spii=(0(.1).75) contigdummy==1)  
{res}
{txt}Adjusted predictions{col 49}Number of obs{col 67}= {res}       498
{txt}Model VCE{col 14}: {res}Robust

{txt}{p2colset 1 14 16 2}{...}
{p2col:Expression}:{space 1}{res:Pr(private), predict()}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:1._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 10}0}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:2._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 9}.1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:3._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 9}.2}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:4._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 9}.3}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:5._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 9}.4}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:6._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 9}.5}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:7._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 9}.6}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:8._at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 9}.7}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{res}{txt}{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26} Delta-method
{col 14}{c |}     Margin{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 9}_at {c |}
{space 10}1  {c |}{col 14}{res}{space 2} .0536985{col 26}{space 2} .0156509{col 37}{space 1}    3.43{col 46}{space 3}0.001{col 54}{space 4} .0230234{col 67}{space 3} .0843737
{txt}{space 10}2  {c |}{col 14}{res}{space 2} .0641876{col 26}{space 2} .0163049{col 37}{space 1}    3.94{col 46}{space 3}0.000{col 54}{space 4} .0322305{col 67}{space 3} .0961447
{txt}{space 10}3  {c |}{col 14}{res}{space 2} .0762041{col 26}{space 2} .0185132{col 37}{space 1}    4.12{col 46}{space 3}0.000{col 54}{space 4} .0399189{col 67}{space 3} .1124892
{txt}{space 10}4  {c |}{col 14}{res}{space 2} .0898606{col 26}{space 2} .0229698{col 37}{space 1}    3.91{col 46}{space 3}0.000{col 54}{space 4} .0448406{col 67}{space 3} .1348807
{txt}{space 10}5  {c |}{col 14}{res}{space 2} .1052575{col 26}{space 2} .0298988{col 37}{space 1}    3.52{col 46}{space 3}0.000{col 54}{space 4} .0466568{col 67}{space 3} .1638581
{txt}{space 10}6  {c |}{col 14}{res}{space 2} .1224782{col 26}{space 2} .0392229{col 37}{space 1}    3.12{col 46}{space 3}0.002{col 54}{space 4} .0456027{col 67}{space 3} .1993536
{txt}{space 10}7  {c |}{col 14}{res}{space 2} .1415852{col 26}{space 2} .0507983{col 37}{space 1}    2.79{col 46}{space 3}0.005{col 54}{space 4} .0420224{col 67}{space 3} .2411481
{txt}{space 10}8  {c |}{col 14}{res}{space 2} .1626165{col 26}{space 2} .0644842{col 37}{space 1}    2.52{col 46}{space 3}0.012{col 54}{space 4} .0362298{col 67}{space 3} .2890031
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{res}{txt}
{com}. marginsplot, recast (line) recastci(rarea)

{text}{p 2 6 2}Variables that uniquely identify margins: spii{p_end}
{res}{txt}
{com}. 
.         //point predictions (referenced in text)
.         margins, at ((means) _all spii=.11 contigdummy==1)
{res}
{txt}Adjusted predictions{col 49}Number of obs{col 67}= {res}       498
{txt}Model VCE{col 14}: {res}Robust

{txt}{p2colset 1 14 16 2}{...}
{p2col:Expression}:{space 1}{res:Pr(private), predict()}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col:at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 8}.11}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{res}{txt}{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26} Delta-method
{col 14}{c |}     Margin{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 7}_cons {c |}{col 14}{res}{space 2} .0653186{col 26}{space 2} .0164413{col 37}{space 1}    3.97{col 46}{space 3}0.000{col 54}{space 4} .0330942{col 67}{space 3}  .097543
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{res}{txt}
{com}.         margins, at ((means) _all spii=.55 contigdummy==1)
{res}
{txt}Adjusted predictions{col 49}Number of obs{col 67}= {res}       498
{txt}Model VCE{col 14}: {res}Robust

{txt}{p2colset 1 14 16 2}{...}
{p2col:Expression}:{space 1}{res:Pr(private), predict()}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col:at}:{space 1}{res:{txt:spii}{space 12}{txt:=} {space 8}.55}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.070281 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.343373 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5069547 {txt:(mean)}}{p_end}
{p2colreset}{...}

{res}{txt}{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26} Delta-method
{col 14}{c |}     Margin{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 7}_cons {c |}{col 14}{res}{space 2} .1317929{col 26}{space 2}  .044738{col 37}{space 1}    2.95{col 46}{space 3}0.003{col 54}{space 4} .0441079{col 67}{space 3} .2194779
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{res}{txt}
{com}. 
. //Figure 2
. 
. probit private foi lop cl polity21 contigdummy alliance powerratio, cluster(ccode1)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-81.955051}  
Iteration 1:{space 3}log pseudolikelihood = {res:-77.378779}  
Iteration 2:{space 3}log pseudolikelihood = {res:-77.205776}  
Iteration 3:{space 3}log pseudolikelihood = {res:-77.205163}  
Iteration 4:{space 3}log pseudolikelihood = {res:-77.205163}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       453
{txt}{col 49}Wald chi2({res}7{txt}){col 67}= {res}     16.85
{txt}{col 49}Prob > chi2{col 67}= {res}    0.0184
{txt}Log pseudolikelihood = {res}-77.205163{txt}{col 49}Pseudo R2{col 67}= {res}    0.0580

{txt}{ralign 78:(Std. Err. adjusted for {res:100} clusters in ccode1)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 9}foi {c |}{col 14}{res}{space 2}-.5853703{col 26}{space 2} .7545945{col 37}{space 1}   -0.78{col 46}{space 3}0.438{col 54}{space 4}-2.064348{col 67}{space 3} .8936078
{txt}{space 9}lop {c |}{col 14}{res}{space 2}  1.15307{col 26}{space 2} .4667306{col 37}{space 1}    2.47{col 46}{space 3}0.013{col 54}{space 4} .2382947{col 67}{space 3} 2.067845
{txt}{space 10}cl {c |}{col 14}{res}{space 2} .0463067{col 26}{space 2} .1141373{col 37}{space 1}    0.41{col 46}{space 3}0.685{col 54}{space 4}-.1773983{col 67}{space 3} .2700117
{txt}{space 4}polity21 {c |}{col 14}{res}{space 2} .0048995{col 26}{space 2} .0315918{col 37}{space 1}    0.16{col 46}{space 3}0.877{col 54}{space 4}-.0570194{col 67}{space 3} .0668183
{txt}{space 1}contigdummy {c |}{col 14}{res}{space 2} .5584144{col 26}{space 2} .1824622{col 37}{space 1}    3.06{col 46}{space 3}0.002{col 54}{space 4} .2007951{col 67}{space 3} .9160338
{txt}{space 4}alliance {c |}{col 14}{res}{space 2} .1169906{col 26}{space 2} .0956196{col 37}{space 1}    1.22{col 46}{space 3}0.221{col 54}{space 4}-.0704204{col 67}{space 3} .3044016
{txt}{space 2}powerratio {c |}{col 14}{res}{space 2} .2797834{col 26}{space 2} .3210045{col 37}{space 1}    0.87{col 46}{space 3}0.383{col 54}{space 4} -.349374{col 67}{space 3} .9089407
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-2.946067{col 26}{space 2} .7225414{col 37}{space 1}   -4.08{col 46}{space 3}0.000{col 54}{space 4}-4.362222{col 67}{space 3}-1.529912
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}

{com}. margins, at ((means) _all lop=(0(.1).6) contigdummy==1)  
{res}
{txt}Adjusted predictions{col 49}Number of obs{col 67}= {res}       453
{txt}Model VCE{col 14}: {res}Robust

{txt}{p2colset 1 14 16 2}{...}
{p2col:Expression}:{space 1}{res:Pr(private), predict()}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:1._at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 10}0}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:2._at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 9}.1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:3._at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 9}.2}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:4._at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 9}.3}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:5._at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 9}.4}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:6._at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 9}.5}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{txt}{p2colset 1 14 16 2}{...}
{p2col:7._at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 9}.6}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{res}{txt}{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26} Delta-method
{col 14}{c |}     Margin{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 9}_at {c |}
{space 10}1  {c |}{col 14}{res}{space 2} .0474691{col 26}{space 2} .0126887{col 37}{space 1}    3.74{col 46}{space 3}0.000{col 54}{space 4} .0225997{col 67}{space 3} .0723386
{txt}{space 10}2  {c |}{col 14}{res}{space 2}  .060021{col 26}{space 2}  .013736{col 37}{space 1}    4.37{col 46}{space 3}0.000{col 54}{space 4} .0330988{col 67}{space 3} .0869431
{txt}{space 10}3  {c |}{col 14}{res}{space 2} .0750341{col 26}{space 2} .0170444{col 37}{space 1}    4.40{col 46}{space 3}0.000{col 54}{space 4} .0416277{col 67}{space 3} .1084405
{txt}{space 10}4  {c |}{col 14}{res}{space 2} .0927542{col 26}{space 2} .0235102{col 37}{space 1}    3.95{col 46}{space 3}0.000{col 54}{space 4} .0466752{col 67}{space 3} .1388333
{txt}{space 10}5  {c |}{col 14}{res}{space 2} .1133935{col 26}{space 2} .0332601{col 37}{space 1}    3.41{col 46}{space 3}0.001{col 54}{space 4} .0482049{col 67}{space 3} .1785822
{txt}{space 10}6  {c |}{col 14}{res}{space 2} .1371158{col 26}{space 2} .0461484{col 37}{space 1}    2.97{col 46}{space 3}0.003{col 54}{space 4} .0466666{col 67}{space 3} .2275649
{txt}{space 10}7  {c |}{col 14}{res}{space 2} .1640217{col 26}{space 2} .0619931{col 37}{space 1}    2.65{col 46}{space 3}0.008{col 54}{space 4} .0425173{col 67}{space 3}  .285526
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{res}{txt}
{com}. marginsplot, recast (line) recastci(rarea)

{text}{p 2 6 2}Variables that uniquely identify margins: lop{p_end}
{res}{txt}
{com}. 
.         //point predictions (referenced in text)
.         margins, at ((means) _all lop=.08 contigdummy==1)
{res}
{txt}Adjusted predictions{col 49}Number of obs{col 67}= {res}       453
{txt}Model VCE{col 14}: {res}Robust

{txt}{p2colset 1 14 16 2}{...}
{p2col:Expression}:{space 1}{res:Pr(private), predict()}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col:at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 8}.08}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{res}{txt}{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26} Delta-method
{col 14}{c |}     Margin{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 7}_cons {c |}{col 14}{res}{space 2}  .057322{col 26}{space 2} .0133891{col 37}{space 1}    4.28{col 46}{space 3}0.000{col 54}{space 4} .0310798{col 67}{space 3} .0835641
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{res}{txt}
{com}.         margins, at ((means) _all lop=.48 contigdummy==1)
{res}
{txt}Adjusted predictions{col 49}Number of obs{col 67}= {res}       453
{txt}Model VCE{col 14}: {res}Robust

{txt}{p2colset 1 14 16 2}{...}
{p2col:Expression}:{space 1}{res:Pr(private), predict()}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col:at}:{space 1}{res:{txt:foi}{space 13}{txt:=} {space 3}.0498413 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:lop}{space 13}{txt:=} {space 8}.48}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:cl}{space 14}{txt:=} {space 4}4.97351 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:polity21}{space 8}{txt:=} {space 2}-2.092715 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:contigdummy}{space 5}{txt:=} {space 10}1}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:alliance}{space 8}{txt:=} {space 3}3.291391 {txt:(mean)}}{p_end}
{p2colreset}{...}
{txt}{p2colset 1 14 16 2}{...}
{p2col: }{space 2}{res:{txt:powerratio}{space 6}{txt:=} {space 3}.5068491 {txt:(mean)}}{p_end}
{p2colreset}{...}

{res}{txt}{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26} Delta-method
{col 14}{c |}     Margin{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 7}_cons {c |}{col 14}{res}{space 2} .1321188{col 26}{space 2}  .043328{col 37}{space 1}    3.05{col 46}{space 3}0.002{col 54}{space 4} .0471976{col 67}{space 3} .2170401
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{res}{txt}
{com}. 
{txt}end of do-file

{com}. do "C:\Users\carlamm\AppData\Local\Temp\STD1cd8_000000.tmp"
{txt}
{com}. //Other tests referenced (as robustness checks) in text
. 
.         //standard errors clustered on dyad (referenced in footnote 10)
. 
. gen dyad=(ccode1*1000)+ccode2
{txt}
{com}. 
. eststo: probit private spii , cluster (dyad)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-93.469915}  
Iteration 1:{space 3}log pseudolikelihood = {res:-93.259668}  
Iteration 2:{space 3}log pseudolikelihood = {res:-93.258684}  
Iteration 3:{space 3}log pseudolikelihood = {res:-93.258684}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       504
{txt}{col 49}Wald chi2({res}1{txt}){col 67}= {res}      0.43
{txt}{col 49}Prob > chi2{col 67}= {res}    0.5119
{txt}Log pseudolikelihood = {res}-93.258684{txt}{col 49}Pseudo R2{col 67}= {res}    0.0023

{txt}{ralign 78:(Std. Err. adjusted for {res:280} clusters in dyad)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 8}spii {c |}{col 14}{res}{space 2} .2773586{col 26}{space 2} .4228479{col 37}{space 1}    0.66{col 46}{space 3}0.512{col 54}{space 4}-.5514081{col 67}{space 3} 1.106125
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-1.721168{col 26}{space 2} .1107873{col 37}{space 1}  -15.54{col 46}{space 3}0.000{col 54}{space 4}-1.938307{col 67}{space 3}-1.504029
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est5{txt} stored)

{com}.         
. eststo: probit private spii polity21 contigdummy alliance powerratio, cluster (dyad)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-93.187939}  
Iteration 1:{space 3}log pseudolikelihood = {res:-89.570206}  
Iteration 2:{space 3}log pseudolikelihood = {res:-89.476246}  
Iteration 3:{space 3}log pseudolikelihood = {res:-89.476058}  
Iteration 4:{space 3}log pseudolikelihood = {res:-89.476058}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       498
{txt}{col 49}Wald chi2({res}5{txt}){col 67}= {res}      7.08
{txt}{col 49}Prob > chi2{col 67}= {res}    0.2148
{txt}Log pseudolikelihood = {res}-89.476058{txt}{col 49}Pseudo R2{col 67}= {res}    0.0398

{txt}{ralign 78:(Std. Err. adjusted for {res:278} clusters in dyad)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 8}spii {c |}{col 14}{res}{space 2} .8946319{col 26}{space 2} .6574662{col 37}{space 1}    1.36{col 46}{space 3}0.174{col 54}{space 4}-.3939781{col 67}{space 3} 2.183242
{txt}{space 4}polity21 {c |}{col 14}{res}{space 2}-.0169334{col 26}{space 2} .0202152{col 37}{space 1}   -0.84{col 46}{space 3}0.402{col 54}{space 4}-.0565545{col 67}{space 3} .0226876
{txt}{space 1}contigdummy {c |}{col 14}{res}{space 2} .5512089{col 26}{space 2} .2355748{col 37}{space 1}    2.34{col 46}{space 3}0.019{col 54}{space 4} .0894908{col 67}{space 3} 1.012927
{txt}{space 4}alliance {c |}{col 14}{res}{space 2} .0906769{col 26}{space 2} .0879965{col 37}{space 1}    1.03{col 46}{space 3}0.303{col 54}{space 4} -.081793{col 67}{space 3} .2631468
{txt}{space 2}powerratio {c |}{col 14}{res}{space 2} .1735556{col 26}{space 2} .3694839{col 37}{space 1}    0.47{col 46}{space 3}0.639{col 54}{space 4}-.5506195{col 67}{space 3} .8977308
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-2.587421{col 26}{space 2} .4644198{col 37}{space 1}   -5.57{col 46}{space 3}0.000{col 54}{space 4}-3.497667{col 67}{space 3}-1.677175
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est6{txt} stored)

{com}.         
. eststo: probit private foi lop cl, cluster(dyad)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-82.224159}  
Iteration 1:{space 3}log pseudolikelihood = {res: -81.12337}  
Iteration 2:{space 3}log pseudolikelihood = {res:-81.085043}  
Iteration 3:{space 3}log pseudolikelihood = {res:-81.085013}  
Iteration 4:{space 3}log pseudolikelihood = {res:-81.085013}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       459
{txt}{col 49}Wald chi2({res}3{txt}){col 67}= {res}      6.16
{txt}{col 49}Prob > chi2{col 67}= {res}    0.1041
{txt}Log pseudolikelihood = {res}-81.085013{txt}{col 49}Pseudo R2{col 67}= {res}    0.0139

{txt}{ralign 78:(Std. Err. adjusted for {res:276} clusters in dyad)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 9}foi {c |}{col 14}{res}{space 2}-.7210244{col 26}{space 2} .6407507{col 37}{space 1}   -1.13{col 46}{space 3}0.260{col 54}{space 4}-1.976873{col 67}{space 3} .5348239
{txt}{space 9}lop {c |}{col 14}{res}{space 2} 1.035887{col 26}{space 2} .4496494{col 37}{space 1}    2.30{col 46}{space 3}0.021{col 54}{space 4} .1545906{col 67}{space 3} 1.917184
{txt}{space 10}cl {c |}{col 14}{res}{space 2}  .025793{col 26}{space 2} .0545294{col 37}{space 1}    0.47{col 46}{space 3}0.636{col 54}{space 4}-.0810827{col 67}{space 3} .1326687
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-1.910113{col 26}{space 2} .3085968{col 37}{space 1}   -6.19{col 46}{space 3}0.000{col 54}{space 4}-2.514952{col 67}{space 3}-1.305275
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est7{txt} stored)

{com}.         
. eststo: probit private foi lop cl polity21 contigdummy alliance powerratio, cluster(dyad)

{res}{txt}Iteration 0:{space 3}log pseudolikelihood = {res:-81.955051}  
Iteration 1:{space 3}log pseudolikelihood = {res:-77.378779}  
Iteration 2:{space 3}log pseudolikelihood = {res:-77.205776}  
Iteration 3:{space 3}log pseudolikelihood = {res:-77.205163}  
Iteration 4:{space 3}log pseudolikelihood = {res:-77.205163}  
{res}
{txt}Probit regression{col 49}Number of obs{col 67}= {res}       453
{txt}{col 49}Wald chi2({res}7{txt}){col 67}= {res}     12.67
{txt}{col 49}Prob > chi2{col 67}= {res}    0.0805
{txt}Log pseudolikelihood = {res}-77.205163{txt}{col 49}Pseudo R2{col 67}= {res}    0.0580

{txt}{ralign 78:(Std. Err. adjusted for {res:274} clusters in dyad)}
{hline 13}{c TT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{col 14}{c |}{col 26}    Robust
{col 1}     private{col 14}{c |}      Coef.{col 26}   Std. Err.{col 38}      z{col 46}   P>|z|{col 54}     [95% Con{col 67}f. Interval]
{hline 13}{c +}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
{space 9}foi {c |}{col 14}{res}{space 2}-.5853703{col 26}{space 2}  .619264{col 37}{space 1}   -0.95{col 46}{space 3}0.345{col 54}{space 4}-1.799105{col 67}{space 3} .6283648
{txt}{space 9}lop {c |}{col 14}{res}{space 2}  1.15307{col 26}{space 2} .4801429{col 37}{space 1}    2.40{col 46}{space 3}0.016{col 54}{space 4} .2120071{col 67}{space 3} 2.094133
{txt}{space 10}cl {c |}{col 14}{res}{space 2} .0463067{col 26}{space 2} .1015346{col 37}{space 1}    0.46{col 46}{space 3}0.648{col 54}{space 4}-.1526975{col 67}{space 3} .2453109
{txt}{space 4}polity21 {c |}{col 14}{res}{space 2} .0048995{col 26}{space 2} .0286042{col 37}{space 1}    0.17{col 46}{space 3}0.864{col 54}{space 4}-.0511637{col 67}{space 3} .0609627
{txt}{space 1}contigdummy {c |}{col 14}{res}{space 2} .5584144{col 26}{space 2} .2619783{col 37}{space 1}    2.13{col 46}{space 3}0.033{col 54}{space 4} .0449465{col 67}{space 3} 1.071882
{txt}{space 4}alliance {c |}{col 14}{res}{space 2} .1169906{col 26}{space 2} .0988887{col 37}{space 1}    1.18{col 46}{space 3}0.237{col 54}{space 4}-.0768276{col 67}{space 3} .3108089
{txt}{space 2}powerratio {c |}{col 14}{res}{space 2} .2797834{col 26}{space 2} .4106775{col 37}{space 1}    0.68{col 46}{space 3}0.496{col 54}{space 4}-.5251298{col 67}{space 3} 1.084697
{txt}{space 7}_cons {c |}{col 14}{res}{space 2}-2.946067{col 26}{space 2} .6734459{col 37}{space 1}   -4.37{col 46}{space 3}0.000{col 54}{space 4}-4.265996{col 67}{space 3}-1.626137
{txt}{hline 13}{c BT}{hline 11}{hline 11}{hline 9}{hline 8}{hline 13}{hline 12}
({res}est8{txt} stored)

{com}. 
. 
{txt}end of do-file

{com}. log close
      {txt}name:  {res}<unnamed>
       {txt}log:  {res}C:\Users\carlamm\Dropbox\Working Papers\Transparency&Surprise\Data\LogFPABellMartinezMachain.do
  {txt}log type:  {res}smcl
 {txt}closed on:  {res}18 Sep 2017, 14:03:39
{txt}{.-}
{smcl}
{txt}{sf}{ul off}