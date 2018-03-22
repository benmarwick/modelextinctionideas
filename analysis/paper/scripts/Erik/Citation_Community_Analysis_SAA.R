library(dplyr)

cl_raw<-read.delim("~/Dropbox/SAA_2018/Quant_Session/lineage_pyrate_data_clusters.txt")
cl_life <- cl_raw %>% mutate(lifespan=ts-te) 
cl <- cl_raw %>% group_by(ts) %>% summarize(total_ts=n_distinct(species)) 
cl_time<-data.frame(year=seq(from=1975,to=2017,by=1),ts=rev(seq(from=0,to=42,by=1)))
cl<-left_join(cl_time,cl,by="ts") %>% replace(is.na(.), 0)
cl<-cl %>%arrange(desc(ts)) %>% mutate(cumsum = cumsum(total_ts)) %>% mutate(log_cumsum=log(cumsum))

##Cumutlative Richness
png("~/Dropbox/SAA_2018/Quant_Session/CumRich.png",res=300,units="in",height=2,width=3)
plot(cl$year,cl$cumsum,type="n",xaxt="n",bty="n",xlab="Year",ylim=c(0,40),yaxt="n",ylab="Cumulative Richness of Citation Communities")
axis(1,at=seq(from=1975,to=2015,by=5),labels=seq(from=1975,to=2015,by=5))
axis(2,at=seq(from=0,to=40,by=5),labels=seq(from=0,to=40,by=5))
dot.line<-seq(from=0,to=38,by=38/42)
polygon(x=c(cl$year[1:3],cl$year[3:1]),y=c(cl$cumsum[1:3],dot.line[3:1]),col=alpha("dodgerblue",0.3),border = NA)
polygon(x=c(cl$year[3:7],cl$year[7:3]),y=c(cl$cumsum[3:7],dot.line[7:3]),col=alpha("firebrick",0.3),border = NA)
polygon(x=c(cl$year[7:9],cl$year[9:7]),y=c(cl$cumsum[7:9],dot.line[9:7]),col=alpha("dodgerblue",0.3),border = NA)
polygon(x=c(cl$year[9:12],cl$year[12:9]),y=c(cl$cumsum[9:12],dot.line[12:9]),col=alpha("firebrick",0.3),border = NA)
polygon(x=c(cl$year[12:43],cl$year[43:12]),y=c(cl$cumsum[12:43],dot.line[43:12]),col=alpha("dodgerblue",0.3),border = NA)
lines(cl$year,cl$cumsum,col="purple4",lwd=4)
lines(cl$year,dot.line,lty=2,lwd=2)
dev.off()

##Cumulative Richness Log
png("~/Dropbox/SAA_2018/Quant_Session/CumRich_Log.png",res=300,units="in",height=7,width=9)
plot(cl$year,cl$log_cumsum,type="n",xaxt="n",bty="n",xlab="Year",ylim=c(0,4),yaxt="n",ylab="Cumulative Richness (Log) of Citation Communities")
axis(1,at=seq(from=1975,to=2015,by=5),labels=seq(from=1975,to=2015,by=5))
axis(2,at=seq(from=0,to=4,by=1),labels=seq(from=0,to=4,by=1))
dot.line<-seq(from=0,to=max(cl$log_cumsum),by=3.6/42)
polygon(x=c(cl$year[1:43],cl$year[43:1]),y=c(cl$log_cumsum[1:43],dot.line[43:1]),col=alpha("dodgerblue",0.3),border = NA)
lines(cl$year,cl$log_cumsum,col="purple4",lwd=4)
lines(cl$year,dot.line,lty=2,lwd=2)
dev.off()

#Histogram of Lifespans
png("~/Dropbox/SAA_2018/Quant_Session/Life_hist.png",res=300,units="in",height=7,width=10)
col_func<-colorRampPalette(c("firebrick","dodgerblue"))
hist_colors<-col_func(10)
hist(cl_life$lifespan,breaks=10,xlim = c(1,45),main="",xlab="Lifespans of Citation Communities",col=alpha(hist_colors,0.7))
dev.off()

######PyRate Analysis

#python PyRate.py -A 4 python2.7 PyRate.py -d lineage_pyrate_data_clusters.txt -A 4 -n 1000000 -mBDI 0
#RJMCMC instead of BDMCMC, assumes Birth-Death model

#Unable to read in mcmc log file for RJ-MCMC so the raw values are copied and pasted from aggregated log file

time=c(-0.5, -1.5,-2.5,-3.5,-4.5,-5.5,-6.5,-7.5,-8.5,-9.5,-10.5,-11.5,-12.5,-13.5,-14.5,-15.5,-16.5,-17.5,-18.5,-19.5,-20.5,-21.5,-22.5,-23.5,-24.5,-25.5,-26.5,-27.5,-28.5,-29.5,-30.5,-31.5,-32.5,-33.5,-34.5,-35.5,-36.5,-37.5,-38.5,-39.5,-40.5,-41.5)
time_year=2017+time #adjusted for real years
rate_orig=c(0.023824723272, 0.023824723272,0.023824723272,0.023824723272,0.023824723272,0.0238851649427,0.0238851649427,0.024008915473,0.0241972731593,0.0245222046961,0.0245492238759,0.0245657917773,0.024593385248,0.02460986905,0.0246893720344,0.0246893720344,0.0247045233732,0.0248051573758,0.0250021850874,0.0255517479465,0.0318226417338,0.0969689313877,0.0993543674295,0.10167741895,0.101952267082,0.103653414969,0.105946007501,0.107051496006,0.10736213473,0.107656187864,0.112648538336,0.113475794366,0.113063352534,0.113896633454,0.115131145601,0.119788977837,0.129620407926,0.130804558114,0.131404394135,0.132187505904,0.132769317834,0.134500831402)
minHPD_orig=c(0.00982189731663, 0.00982189731663,0.00982189731663,0.00982189731663,0.00982189731663,0.00955051155822,0.00955051155822,0.0113486443739,0.0113486443739,0.0115849886284,0.0113486443739,0.0115849886284,0.0113486443739,0.010752244474,0.00982189731663,0.00982189731663,0.010752244474,0.00982189731663,0.00955051155822,0.00982189731663,0.0116308946937,0.0213543099167,0.0213543099167,0.0215962719821,0.0226593583166,0.0258823940168,0.0258823940168,0.0227573585372,0.0227573585372,0.0227573585372,0.0272734306431,0.0291293617703,0.0291293617703,0.0266858277184,0.0272734306431,0.0305437109684,0.0591583117023,0.0591583117023,0.050801367549,0.0603968575445,0.0603968575445,0.047847988412)
maxHPD_orig=c(0.0405725689478, 0.0405725689478,0.0405725689478,0.0405725689478,0.0405725689478,0.0405725689478,0.0405725689478,0.0427555881549,0.0427555881549,0.0452179958163,0.0453883557101,0.045820676023,0.0459272008371,0.0459272008371,0.045820676023,0.045820676023,0.047847988412,0.047847988412,0.0537620298149,0.0756865832826,0.127081204658,0.153031391168,0.153031391168,0.153031391168,0.153635887959,0.155969361536,0.158493900244,0.158188628229,0.1613875942,0.163779725393,0.202759588227,0.20717319844,0.20717319844,0.20717319844,0.222996879788,0.33044457987,0.493529667994,0.493529667994,0.49105854348,0.501835340427,0.521462494482,0.572447905905)
rate_ex=c(0.00349963126822, 0.00349963126822,0.00313077406068,0.00308889673969,0.00301149712091,0.00300951934862,0.0030007538068,0.00296511159122,0.00296511159122,0.002956276147,0.00295025045816,0.00295025045816,0.00295025045816,0.00295025045816,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00294069177251,0.00295025045816,0.002956276147,0.002956276147,0.002956276147,0.00296511159122,0.00296511159122,0.00296511159122,0.00296511159122,0.00298074540372,0.00298839683706,0.0030007538068)
minHPD_ex=c(9.66928666149e-05, 9.66928666149e-05,9.66928666149e-05,9.66928666149e-05,9.66928666149e-05,9.66928666149e-05,6.25993538063e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,6.25993538063e-05,3.32789876429e-05,3.32789876429e-05,3.32789876429e-05,6.25993538063e-05,6.25993538063e-05,3.32789876429e-05,3.32789876429e-05,9.66928666149e-05,9.66928666149e-05,3.32789876429e-05)
maxHPD_ex=c(0.0266370246971, 0.0266370246971,0.00816982088032,0.00772744338626,0.0074069699279,0.00738500675058,0.00713161446733,0.00698715044674,0.00698715044674,0.00692204241402,0.00687467952642,0.00687467952642,0.00687467952642,0.00687467952642,0.00681300891885,0.00681300891885,0.00681300891885,0.00681300891885,0.00681300891885,0.00681300891885,0.00681300891885,0.00681300891885,0.00681300891885,0.00681300891885,0.00687467952642,0.00687467952642,0.00687467952642,0.00687467952642,0.00687467952642,0.00687467952642,0.00687467952642,0.00698715044674,0.00698715044674,0.00698715044674,0.00698715044674,0.00713161446733,0.00713161446733,0.00713161446733,0.00713161446733,0.0074069699279,0.00751435311835,0.00762985093044)
rate_net_div=rate_orig-rate_ex
minHPD_net_div=minHPD_orig-minHPD_ex
maxHPD_net_div=maxHPD_orig-maxHPD_ex

png("~/Dropbox/SAA_2018/Quant_Session/Orig_Ex_rates.png",res=300,units="in",height=7,width=10)
plot(time_year,time_year,type = 'n', ylim = c(0, 0.629692696496), xlim = c(1975,2017), 
     ylab = 'Rate of event per lineage per time unit', xlab = 'Year',main="",bty="n",xaxt="n")
axis(1,at=seq(from=1975,to=2015,by=5),labels=seq(from=1975,to=2015,by=5))
polygon(c(time_year, rev(time_year)), c(maxHPD_orig, rev(minHPD_orig)), col = alpha('dodgerblue3',0.3), border = NA)
lines(time_year[42:21],rate_orig[42:21], col = 'dodgerblue2', lwd=2)
lines(time_year[21:1],rate_orig[21:1], col = 'dodgerblue4', lwd=2)
points(time_year[21],rate_orig[21],pch=16,col="dodgerblue3",cex=1.5)
#add in time shift color 
polygon(c(time_year, rev(time_year)), c(maxHPD_ex, rev(minHPD_ex)), col = alpha('firebrick',0.3), border = NA)
lines(time_year,rate_ex, col = 'firebrick', lwd=2)
segments(2005,0.5,2006,0.5,"dodgerblue2",lwd=2)
segments(2006,0.5,2007,0.5,"dodgerblue4",lwd=2)
text(2007,0.5,"Origination Rate",pos=4)
segments(2005,0.47,2007,0.47,"firebrick",lwd=2)
text(2007,0.47,"Extinction Rate",pos=4)
points(2006,0.44,pch=16,col="dodgerblue3",cex=1.5)
text(2007,0.44,"Estimated Shift Point",pos=4)
dev.off()

###Shift Points
BD_22<-read.delim("~/Dropbox/SAA_2018/Quant_Session/pyrate_mcmc_logs/lineage_pyrate_data_clusters_0_BD21BD2-1_TI_mcmc.log",row.names=1) #This one was chosen as it was the best fitting model
BD_22<-BD_22[1:1000,] #removal of the rest of the TI as we are not interested in it

shift.points.func<-function(x,y){
  shift.data<-hist(x,breaks=(max(round(x))-min(round(x))),plot=FALSE)
  shift.data<-data.frame(breaks=shift.data$mids,counts=shift.data$counts)
  summary<-data.frame(max_age=(y-shift.data$breaks),
                      min_age=(y-shift.data$breaks),
                      counts=shift.data$counts,
                      proportion=(shift.data$counts/sum(shift.data$counts)))
  summary<-arrange(summary,desc(counts))
  summary_top_3<-head(summary,3)
  print(summary_top_3)
}

sp.1<-shift.points.func(BD_22$shift_sp_1, 2017.5) #The year is the most recent year in the dataset plus 0.5
#ex.1<-shift.points.func(BD_22$shift_ex_1, 2017.5) #The year is the most recent year in the dataset plus 0.5
sp.1 
#ex.1


png("~/Dropbox/SAA_2018/Quant_Session/Orig_Ex_rates.png",res=300,units="in",height=7,width=10)
plot(time_year,time_year,type = 'n', ylim = c(0, 0.56481), xlim = c(1975,2015), 
     ylab = 'Rate of event per lineage per time unit', xlab = 'Year',main="",bty="n",xaxt="n")
axis(1,at=seq(from=1975,to=2015,by=5),labels=seq(from=1975,to=2015,by=5))
polygon(c(time_year, rev(time_year)), c(maxHPD_net_div, rev(minHPD_net_div)), col = alpha('purple4',0.3), border = NA)
lines(time_year,rate_net_div, col = 'purple4', lwd=2)
segments(2005,0.5,2007,0.5,"dodgerblue4",lwd=2)
text(2007,0.5,"Origination Rate",pos=4)

dev.off()






