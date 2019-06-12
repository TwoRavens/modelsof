clear 
 /// axis
	
	
input str40 varname rank mean lower95 upper95 lower99 upper99
    "Provence" 1 . . . . .
    "Île-de-France" 2 . . .  . .
    "Catalogna" 4 . . . . .
	"Madrid" 5 . . . . .
    "Lucerne" 7 . . . . .
    "Zurich" 8 . . . . .
	"Lower Saxony" 10 . . .  . .
    "Quebec" 12 . . . . .
	"Ontario" 13   . . . . .
        end

label def rank 1 "Provence" 2 "Île-de-France" 3"" 4 "Catalogna" 5 "Madrid" 6"" 7 "Lucerne" 8 "Zurich" 9"" 10 "Lower Saxony" 11"" 12 "Quebec" 13 "Ontario"
label val rank rank
 
  twoway(bar mean rank, horiz base(0) yaxis(2) yscale(range(0.5 13.5) reverse) ylabel(1(1)13, angle(0)) xscale(range(-27 6) ) xlabel(-20(10)0 ) ytitle("") xtitle("")) || rspike  lower99 upper99 rank, horizontal lw(medium) lc(black) || rspike  lower95 upper95 rank, horizontal lw(medthick) lc(black)    name(figurea,replace)


 
clear 
 /// Municipal
	
	
input str40 varname rank mean lower95 upper95 lower99 upper99
    "Provence" 1 -6.00	 -15.83136	3.83473 -18.92113    6.92449
    "Île-de-France" 2  -7.51	-13.82291	-1.20968 -15.80459    00.772
    "Catalogna" 4 . . . . .
	"Madrid" 5 . . . . .
    "Lucerne" 7 . . . . .
    "Zurich" 8 . . . . .
	"Lower Saxony" 10 . . . . .
    "Quebec" 12 . . . . .
	"Ontario" 13   . . . . .
    end

label def rank 1 "Provence" 2 "Île-de-France" 3"" 4 "Catalogna" 5 "Madrid" 6"" 7 "Lucerne" 8 "Zurich" 9"" 10 "Lower Saxony" 11"" 12 "Quebec" 13 "Ontario"
label val rank rank
 
  twoway(bar mean rank, horiz base(0) xline(0) yline(0.2)  yscale(range(0.5 13.5) reverse) ylabel(1(1)13, angle(0))  xscale(range(-27 6) )  xlabel(-20(10)0, grid glwidth(vthin) glcolor(gs14)  glpattern(shortdash)))  || rspike  lower99 upper99 rank, horizontal lw(medium) lc(black) || rspike  lower95 upper95 rank, horizontal lw(medthick) lc(black)  name(figureb,replace)


clear 



 /// Regional

input str40 varname rank mean lower95 upper95 lower99 upper99
    "Provence" 1 . . . . .
    "Île-de-France" 2  . . . . .
    "Catalogna" 4  -6.75	-10.78785	-2.71749 -12.0558   -1.44954
	"Madrid" 5 . . . . .
    "Lucerne" 7  -12.53	-18.67839	-6.37343 -20.61164   -4.44019
    "Zurich" 8  -8.24	-14.03373	-2.45593 -15.85274   -0.63692
	"Lower Saxony" 10 -5.68	-13.44322	2.08935 -15.88356     04.5297
    "Quebec" 12  -10.00	-15.10638	-4.88824 -16.71176   -03.28286
	"Ontario" 13   -0.02	-6.39773	6.00442 -08.34625    07.95294
        end

label def rank 1 "Provence" 2 "Île-de-France" 3"" 4 "Catalogna" 5 "Madrid" 6"" 7 "Lucerne" 8 "Zurich" 9"" 10 "Lower Saxony" 11"" 12 "Quebec" 13 "Ontario"
label val rank rank
 
  twoway(bar mean rank, horiz base(0) xline(0) yline(0.2) yscale(range(0.5 13.5) reverse) ylabel(1(1)13, angle(0)) xscale(range(-27 6) ) xlabel(-20(10)0, grid glwidth(vthin) glcolor(gs14)  glpattern(shortdash)))  || rspike  lower99 upper99 rank, horizontal lw(medium) lc(black) || rspike  lower95 upper95 rank, horizontal lw(medthick) lc(black)  name(figurec,replace)


clear 
  

clear 
 /// National   

input str40 varname rank mean lower95 upper95 lower99 upper99
    "Provence" 1 -1.00	 -9.49756	7.52037 -12.17127    10.19408
    "Île-de-France" 2  -0.07	-9.24974	7.85017 -11.93633    10.53676
    "Catalogna" 4  -2.41	-6.80617	1.99194 -8.18845    3.37423
	"Madrid" 5  -5.99	-9.98429	-2.00368 -11.23814   -0.74983
    "Lucerne" 7   -9.09	-15.01699	-3.1547 -16.88069     -1.291
    "Zurich" 8  -4.47	-10.21279	1.26175 -12.01557    3.06453
	"Lower Saxony" 10 . . . . .
    "Quebec" 12  . . . . .
	"Ontario" 13   . . . . .
     end

label def rank 1 "Provence" 2 "Île-de-France" 3"" 4 "Catalogna" 5 "Madrid" 6"" 7 "Lucerne" 8 "Zurich" 9"" 10 "Lower Saxony" 11"" 12 "Quebec" 13 "Ontario"
label val rank rank
 
  twoway(bar mean rank, horiz base(0) xline(0) yline(0.2) yscale(range(0.5 13.5) reverse) ylabel(1(1)13, angle(0)) xscale(range(-27 6) ) xlabel(-20(10)0, grid glwidth(vthin) glcolor(gs14)  glpattern(shortdash)))  || rspike  lower99 upper99 rank, horizontal lw(medium) lc(black) || rspike  lower95 upper95 rank, horizontal lw(medthick) lc(black)  name(figured,replace)


clear 
 /// European  
 

input str40 varname rank mean lower95 upper95 lower99 upper99
    "Provence" 1  -14.2	-21.5503	-6.92414 -23.84824   -4.62621
    "Île-de-France" 2   -18.00	-26.32857	-9.6234 -28.95314   -06.99883
    "Catalogna" 4   -12.23	-20.12794	-4.33962 -22.60846    -1.8591
	"Madrid" 5   -13.68	-21.63602	-5.71761 -24.13698   -03.21665
    "Lucerne" 7   . . . . .
    "Zurich" 8  . . . . .
	"Lower Saxony" 10 -5.92	-15.19755	3.34429 -18.11068    6.25742
    "Quebec" 12  . . . . .
	"Ontario" 13   . . . . .
    end

label def rank 1 "Provence" 2 "Île-de-France" 3"" 4 "Catalogna" 5 "Madrid" 6"" 7 "Lucerne" 8 "Zurich" 9"" 10 "Lower Saxony" 11"" 12 "Quebec" 13 "Ontario"
label val rank rank
 
  twoway(bar mean rank, horiz base(0) xline(0) yline(0.2) yscale(range(0.5 13.5) reverse) ylabel(1(1)13, angle(0)) xscale(range(-27 6) ) xlabel(-20(10)0, grid glwidth(vthin) glcolor(gs14)  glpattern(shortdash)))  || rspike  lower99 upper99 rank, horizontal lw(medium) lc(black) || rspike  lower95 upper95 rank, horizontal lw(medthick) lc(black)  name(figuree,replace)

	

  
  graph combine figurea figureb figurec figured figuree, cols(5)
  
  
