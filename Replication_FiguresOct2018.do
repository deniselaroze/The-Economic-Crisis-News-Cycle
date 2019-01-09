

*cd "C:\Users\Profesor\Dropbox\CESS-Santiago\archive\OxfordProject"
cd "C:\Users\Denise Laroze P\Dropbox\CESS-Santiago\archive\OxfordProject"

//cd "C:\Users\Profesor\Dropbox\CESS-Santiago\archive\OxfordProject"




// Merge

use "all2018.dta", clear
keep if year>2006 & year <2011

*factor *_tone
*predict factor_tone
 
*factor *_volume
*predict factor_volume

*egen volumeAvg = rowmean(*_volume)
*egen toneAvg = rowmean(*_tone)

keep d n retnat_*
save "date_n.dta", replace

use "basic_data.dta", clear


gen d= ym(year, month) 
format d %tmMonYY

keep if year>2006 & year <2011
drop retnat_mean

merge 1:1 d using "date_n.dta"

drop _merge

save "econ_crisis_fig.dta", replace

///------------------------------------------

use "econ_crisis_fig.dta", clear
gen time = _n

tsset time

 
// Data management  
tssmooth ma tone_ma = toneavg, window(3)
tssmooth ma volume_ma = volumeavg, window(3) 
tssmooth ma gdp_ma = gdp, window(3) 

rename u unemp_rate

label var tone_ma "Tone (MA)  "
*label var emp "Employment"
label var inflation "Inflation (rate)"
label var volume_ma "Volume (MA)  "
label var time "Time"
label var retnat_mean "Ret. Perception Econ. (mean)"

label var gdp_ma "GDP (MA)"

label var unemp_rate "Unemployment"



/// Figure 1

twoway line unemp_rate d, yaxis(1) ytitle(Unemployment Rate, axis(1)) ylabel(,nogrid) lp(shortdash)  lc(gs0) /*
*/ || line inflation d, yaxis(2) ytitle(Inflation Rate, axis(2)) lc(gs0) || line gdp_ma d, yaxis(3) ytitle(GDP (MA), axis(3)) lp(longdash) lc(gs0) scheme(lean2) xtitle(Date) legend(pos(6) rows(1))  graphregion(color(white)) bgcolor(white)
graph export "graphs/new/realEcon.png", replace

/// Figure 3
twoway line gdp_ma d, yaxis(1) ytitle(GDP (MA), axis(1)) ylabel(,nogrid) lp(longdash) lc(gs4) || /*
*/ line unemp_rate d, yaxis(2) ytitle(Unemployment rate, axis(2)) ylabel(,nogrid) lp(shortdash)lc(gs8)||/*
*/ line tone_ma d, yaxis(3) ytitle(Tone of Economic News, axis(3)) lc(gs0) scheme(lean2) xtitle("") legend(pos(6) rows(1)) graphregion(color(white)) bgcolor(white)
graph export "graphs/new/tone2018.png", replace

twoway line gdp_ma d, yaxis(1) ytitle(GDP (MA), axis(1)) ylabel(,nogrid) lp(longdash) lc(gs4) || /*
*/ line unemp_rate d, yaxis(2) ytitle(Unemployment rate, axis(2)) ylabel(,nogrid) lp(shortdash)lc(gs8)|| /*
*/line volume_ma d, yaxis(3) ytitle(Volume of Economic News, axis(3)) lc(gs0) scheme(lean2) xtitle("") legend(pos(6) rows(1)) graphregion(color(white)) bgcolor(white)
graph export "graphs/new/volume2018.png", replace


/// Figure 4


generate hi_retnat = retnat_mean + invttail(n-1,0.025)*(retnat_sd / sqrt(n))
generate lo_retnat = retnat_mean - invttail(n-1,0.025)*(retnat_sd / sqrt(n))


twoway (rcap hi lo d,lcolor(gray)) (sc retnat_mean d, mcolor(black)) if retnat_mean!=., ///
ytitle(Mean Retrospective Nat'l Economy) ttitle(Month/Year) ///
ylabel(3 "S" 3.5 "3.5" 4 "W" 4.5 "4.5" 5 "MW") ///
legend(off) scheme(lean2) graphregion(color(white)) bgcolor(white)

graph export "graphs/new/Fig4right.png", replace


twoway (tsline retnat_1, lcolor(black) lpattern(tight_dot)) ///
(tsline retnat_2, lcolor(black) lpattern(dash_dot)) ///
(tsline retnat_3, lcolor(black) lpattern(dot)) ///
(tsline retnat_4, lcolor(black) lpattern(solid)) ///
(tsline retnat_5, lcolor(gray) lpattern(longdash)) if retnat_mean!=., ///
ytitle(Retrospective Nat'l Economy) ttitle(Month/Year) ///
legend(lab(1 "MB") lab(2 "B") lab(3 "S") lab(4 "W") lab(5 "MW") rows(1) pos(6)) scheme(lean2) graphregion(color(white)) bgcolor(white)
graph export "graphs/new/Fig4left.png", replace




/// Figures 5


twoway line retnat_mean d, yaxis(1) ytitle(Mean Retrospective National Evaluation, axis(1)) ylabel(,nogrid) lc(gs0) /*
*/  || line tone_ma d, yaxis(2) ytitle(Tone of Economic News, axis(2)) scheme(lean2) lp(shortdash) lc(gs4) xtitle("") legend(pos(6) rows(1)) graphregion(color(white)) bgcolor(white)
graph export "graphs/new/evalTone2018.png", replace

twoway line retnat_mean d, yaxis(1) ytitle(Mean Retrospective National Evaluation, axis(1)) ylabel(,nogrid) lc(gs0)/*
*/ || line volume_ma d, yaxis(2) ytitle(Volume of Economic News, axis(2)) scheme(lean2) lp(shortdash) lc(gs4) xtitle("") legend(pos(6) rows(1)) graphregion(color(white)) bgcolor(white)
graph export "graphs/new/evalVolume2018.png", replace


twoway line retnat_mean d, yaxis(1) ytitle(Mean Retrospective National Evaluation, axis(1)) ylabel(,nogrid) lc(gs0) /*
*/ || line gdp_ma d , yaxis(2) ytitle(GDP (MA), axis(2)) scheme(lean2) lp(shortdash) lc(gs4) xtitle("") legend(pos(6) rows(1)) graphregion(color(white)) bgcolor(white)
graph export "graphs/new/evalGDP2018.png", replace


twoway line retnat_mean d, yaxis(1) ytitle(Mean Retrospective National Evaluation, axis(1)) ylabel(,nogrid) lc(gs0) /*
*/ || line unemp_ d , yaxis(2)  scheme(lean2) xtitle("") lp(shortdash) lc(gs4) legend(pos(6) rows(1)) graphregion(color(white)) bgcolor(white)
graph export "graphs/new/evalUnemp2018.png", replace




/// Figure 2

clear


use  "daily_newsp_data.dta"

format date %td

tsset date

tsline Volume_MA , ytitle("Volume") scheme(lean2) xtitle("") graphregion(color(white)) bgcolor(white) lc(black)
graph export "graphs/new/volume2018Fig2.png", replace 

tsline Tone_MA , ytitle("Tone") scheme(lean2) xtitle("") ylabel(.4(.1).925) graphregion(color(white)) bgcolor(white) lc(black)
graph export "graphs/new/tone2018Fig2.png", replace 




