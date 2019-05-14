

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROYJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	**
	**		DETAILS: 	This code prepares Figure C.1: Spatial 
	**					Correlation of Errors: Spatial Correlograms
	**					
	**					This code runs in R, and uses the Stata'
	** 					package 'rsource,' available through ssc.
	**
	**				
	**		Version: 	Stata MP 12.1; R 3.3.2 (2016-10-31)
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Call R from Stata
*-------------------------------------------------------------------------------

local directory $dir
local datadir $data
local figuresdir $figures
rsource, terminator(END_OF_R) 												///
roptions(`" --vanilla --args "`directory'" "`datadir'" "`figuresdir'" "') 	///
	rpath($Rterm_path)


#------------------------------------------------------------------------------;
# Prepare data;
#------------------------------------------------------------------------------;

rm(list = ls());
pkgs <- c("data.table", "dplyr", "foreign", "ncf", 
          "ape", "RODBC", "ggplot2");
suppressMessages(sapply(pkgs, install.packages));
suppressMessages(sapply(pkgs, require, character.only = TRUE));

invisible(sapply(pkgs, require, character.only = TRUE));

top_dir = commandArgs(trailingOnly=TRUE);
setwd(top_dir[1]);
.env <- new.env();
.env$analysis_dir <- paste0(top_dir, top_dir[2]);
.env$figs_dir <- paste0(top_dir, top_dir[3]);
attach(.env);

setwd(analysis_dir);
pnl <- read.dta("DPanel_Mun1940_wCoords.dta");
res1 <- na.omit(data.frame(pnl$lon, pnl$lat, pnl$res_apper1000));
res2 <- na.omit(data.frame(pnl$lon, pnl$lat, pnl$res_repartoriego));


#------------------------------------------------------------------------------;
# Moran's I for residuals of column 2 of Tables 1 and 2;
#------------------------------------------------------------------------------;

inf.dists.1 <- as.matrix(dist(cbind(lon=res1$pnl.lon, res1$pnl.lat)));
inf.dists.inv.1 <- 1/inf.dists.1;
diag(inf.dists.inv.1) <- 0;

inf.dists.2 <- as.matrix(dist(cbind(lon=res2$pnl.lon, res2$pnl.lat)));
inf.dists.inv.2 <- 1/inf.dists.2;
diag(inf.dists.inv.2) <- 0;

Moran.I(res1$pnl.res_apper1000, inf.dists.inv.1);
Moran.I(res2$pnl.res_repartoriego, inf.dists.inv.2);


#------------------------------------------------------------------------------;
# Figure C.1: Spatial Correlation of Errors: Spatial Correlograms;
#------------------------------------------------------------------------------;

# Spatial correlograms;
#---------------------;

cor_apper1000 <- ncf::correlog(x=res1$pnl.lon, y=res1$pnl.lat, 
                               z=res1$pnl.res_apper1000,
                               increment=200, resamp=1500, 
                               latlon = TRUE, na.rm=TRUE, quiet=1);

cor_repartoriego <- ncf::correlog(x=res2$pnl.lon, y=res2$pnl.lat, 
                                  z=res2$pnl.res_repartoriego,
                               increment=200, resamp=1500, 
                               latlon = TRUE, na.rm=TRUE, quiet=1);


# Panel a;
#--------;

df_cor_apper1000 <- data.table(data.frame(cor_apper1000[1],
                                          cor_apper1000[2],
                                          cor_apper1000[3],
                                          cor_apper1000[5]));
df_cor_apper1000[,sig:=0];
df_cor_apper1000[p<.01,sig:=1];

labs <- c("No","Yes");
f.apper1000 <- ggplot() +
  geom_bar(data = df_cor_apper1000, 
           aes(x = mean.of.class, weight = as.numeric(n/(15*max(n)))), 
           alpha = .75) +
  geom_line(data = df_cor_apper1000, 
            aes(mean.of.class, correlation), lwd = 1) +
  geom_point(data = df_cor_apper1000, 
             aes(x = mean.of.class, y=correlation, colour = factor(sig)), 
             size=4) + 
  geom_point(data = df_cor_apper1000, 
             aes(x = mean.of.class, y=correlation),
                 shape = 1, size = 4, colour = "black") +
  scale_x_continuous('Great Circle Distance (km)',limits=c(0,3200)) + 
  scale_y_continuous('Autocorrelation',limits=c(-0.08,0.08)) +
  scale_colour_grey("Significant 1%", labels=labs, start=1, end=0) +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_blank(),
        axis.text=element_text(size=20),
        axis.title=element_text(size=25,face="bold"),
        legend.text=element_text(size=20),
        legend.title=element_text(size=20)) +
  geom_hline(yintercept=0) + xlab("");


# Panel b;
#--------;

df_cor_repartoriego <- data.table(data.frame(cor_repartoriego[1],
                                             cor_repartoriego[2],
                                             cor_repartoriego[3],
                                             cor_repartoriego[5]));
df_cor_repartoriego[,sig:=0];
df_cor_repartoriego[p<.01,sig:=1];

labs <- c("No","Yes");
f.repartoriego <- ggplot() +
  geom_bar(data = df_cor_repartoriego, 
           aes(x = mean.of.class, weight = as.numeric(n/(15*max(n)))), 
           alpha = .75) +
  geom_line(data = df_cor_repartoriego, 
            aes(mean.of.class, correlation), lwd = 1) +
  geom_point(data = df_cor_repartoriego, 
             aes(x = mean.of.class, y=correlation, colour = factor(sig)), 
             size=4) + 
  geom_point(data = df_cor_repartoriego, 
             aes(x = mean.of.class, y=correlation),
             shape = 1, size = 4, colour = "black") +
  scale_x_continuous('Great Circle Distance (km)',limits=c(0,3300)) + 
  scale_y_continuous('Autocorrelation', limits=c(-.08,.08)) +
  scale_colour_grey("Significant 1%", labels=labs, start=1, end=0) +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_blank(), 
        axis.text=element_text(size=20),
        axis.title=element_text(size=25,face="bold"),
        legend.text=element_text(size=20),
        legend.title=element_text(size=20)) +
  geom_hline(yintercept=0) + xlab("");


# Print figures;
#--------------;

setwd(figs_dir)
pdf(file = "24_FigureC1_a.pdf", width = 15, height = 10);
print(f.apper1000);
dev.off();

pdf(file = "24_FigureC1_b.pdf", width = 15, height = 10);
print(f.repartoriego);
dev.off();


# End of R script;
#----------------;

END_OF_R


