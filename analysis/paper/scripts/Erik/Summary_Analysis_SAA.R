#Intro and Summary Stats

articles <- readRDS(paste0(here::here(),"/Dropbox/SAA_2018/Quant_Session/saa2018_data_df_EG.rds"))
citations <- readRDS( paste0(here::here(), "/Dropbox/SAA_2018/Quant_Session/items_wth_refs_EG.rds"))
disciplines<-read.csv("~/Dropbox/SAA_2018/Quant_Session/Cat_Discipline.csv",header=T) #Key for associating subject categories with academic disciplines

citations$SC<-as.character(substring(citations$SC,1,72)) #reducing size of SC string name, 72 characters will still keep them all unique
articles$SC<-as.character(substring(articles$SC,1,72)) #reducing size of SC string name, 72 characters will still keep them all unique
disciplines$SC<-as.character(substring(disciplines$SC,1,72))

citations<-left_join(citations,disciplines,by="SC") #joining disiplines 
articles<-left_join(articles,disciplines,by="SC")

##Remove archaeology and anthro from published articles
Anthro<-articles[grep('^Anthropol',articles$SC),]
Archy<-articles[grep('^Archaeol',articles$SC),]
articles_AA<-rbind(Anthro,Archy)
articles_noAA <- articles[!articles$SC %in% articles_AA$SC,]

##Plot of articles in all journals, archy journals, non-archy journals
articles_through_time <- articles %>% group_by(year) %>% summarize(counts=n()) %>% filter(year<=2015 & year>=1975)
articles_through_time_AA <- articles_AA %>% group_by(year) %>% summarize(counts=n()) %>% filter(year<=2015 & year>=1975)
articles_through_time_noAA <- articles_noAA %>% group_by(year) %>% summarize(counts=n()) %>% filter(year<=2015 & year>=1975)

articles_through_time <- articles_through_time_AA %>% left_join(articles_through_time_noAA,by="year")
colnames(articles_through_time)<-c("year","AA","noAA")

colors<-c("wheat3","wheat1")

png("~/Dropbox/SAA_2018/Quant_Session/Articles_Barplot.png",res=300,units="in",height=7.7,width=11.5)  #To create a usable graphic for powerpoint
barplot(t(articles_through_time[2:3]),col=alpha(colors,0.8),names.arg = articles_through_time$year,ylim=c(0,1200),
        xlab="Year",ylab="Frequency")
rect(2,1150,3,1180,col=colors[1])
text(3,1160,"Publications in Archaeology/Anthropology Journals",pos=4)
rect(2,1100,3,1130,col=colors[2])
text(3,1115,"Publications in non-Archaeology/Anthropology Journals",pos=4)
dev.off()

avg_cite_per_year <- articles %>% filter(year>1975 & year<=2015) %>% group_by(year) %>% summarize(ave_per_year=mean(refs_n))

png("~/Dropbox/SAA_2018/Quant_Session/Avg_Citation_Line.png",res=300,units="in",height=7.7,width=11.5)  #To create a usable graphic for powerpoint
plot(avg_cite_per_year$year,avg_cite_per_year$ave_per_year,type="n",bty="n",xaxt="n",yaxt="n",
     xlab="Year",ylab="Average number of citations in a publication")
lines(avg_cite_per_year$year,avg_cite_per_year$ave_per_year,col="slategrey",lwd=3)
axis(2)
axis(1,at=seq(from=1975,to=2015,by=5),labels=seq(from=1975,to=2015,by=5))
dev.off()
