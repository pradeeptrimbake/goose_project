
###################
Comp_scoring <- function(DLC_file, Sol_file ) {
library(tidyr)
library(dplyr)
library(miceadds)
library(MASS)
library(padr)
library(scales)
library(ggplot2)

#DLC_file = "bs6165_05downsampledcro_goose21.csv"
#Sol_file = "bs6165_05downsampled Goose31 .csv"
#setwd(path) 
DLC<-read.csv2(DLC_file, sep = ",", dec = ".",header = F)
DLC<-DLC[,1:15]
names(DLC) <- DLC[3,]
DLC <- DLC[-c(1:4),]
colnames(DLC) <- c("Frame", "Bill(x)", "Bill", "Eyeclosed","Cheek(x)", "Cheek","Head","Collar(X)",
                   "Collar(Y)","Collar","side_r","side_l","DLC_Presence","Right_eye", "Left_eye")
DLC <- DLC %>% mutate_all(na_if,"") 
DLC$Right_eye[is.na(DLC$Right_eye)] <- "Right Out of Sight"
DLC$Left_eye[is.na(DLC$Left_eye)] <- "Left Out of Sight"


SOL<-read.csv2(Sol_file, sep = ",", dec = ".")
#SOL <- SOL[-(length(SOL)-1),]

for (i in 1:length(SOL$Frame)){
  if (SOL[i,3]=="Right Out of Sight" & SOL[i,4]=="Left Out of Sight") {SOL[i,5]="Not visible"}
  else {SOL[i,5]="Visible"}
}


DLC_filename=filename_split(DLC_file)
SOL_filename=filename_split(Sol_file) 
GooseID=SOL_filename$stem
GooseID = string_extract_part(SOL_filename$stem, part=2, sep=" " )
filename = string_extract_part(SOL_filename$stem, part=1, sep=" " )

#filename=paste(path,filename$stem,sep = "\\")
DLC$Frame <- as.numeric(DLC$Frame) - 250
comp_dts <- cbind(SOL,DLC[,13:15][match(SOL$Frame, DLC$Frame), ])
#comp_dts <- bind_rows(SOL,DLC[,11:13])
#comp_dts<- cbind(SOL,DLC[,11:13])  
colnames(comp_dts) <- c("Time","Frame", "SOL_Right","SOL_Left","SOL_Presence","DLC_Presence",
                        "DLC_Left","DLC_Right")



for (i in 1:length(comp_dts$Frame)){
  if (comp_dts[i,3]=="Right Out of Sight") {comp_dts[i,3]=0}
  else if (comp_dts[i,3]=="Right Open"){comp_dts[i,3]=1}
  else if (comp_dts[i,3]=="Right Close"){comp_dts[i,3]=2}
  
}

for (i in 1:length(comp_dts$Frame)){
  if (comp_dts[i,4]=="Left Out of Sight") {comp_dts[i,4]=0}
  else if (comp_dts[i,4]=="Left Open"){comp_dts[i,4]=1}
  else if (comp_dts[i,4]=="Left Close"){comp_dts[i,4]=2}
  
}


for (i in 1:length(comp_dts$Frame)){
  if (comp_dts[i,5]=="Not visible") {comp_dts[i,5]=0}
  else if (comp_dts[i,5]=="Visible"){comp_dts[i,5]=1}
}

for (i in 1:length(comp_dts$Frame)){
  if (!is.na(comp_dts[i,6]) && comp_dts[i,6]=="Not Visible") {comp_dts[i,6]=0}
  else if (!is.na(comp_dts[i,6]) && comp_dts[i,6]=="Visible"){comp_dts[i,6]=1}
}

for (i in 1:length(comp_dts$Frame)){
  if (!is.na(comp_dts[i,7]) && comp_dts[i,7]=="Right Out of Sight" & comp_dts[i,6]==1) {comp_dts[i,7]=0}
  else if (!is.na(comp_dts[i,7]) && comp_dts[i,7]=="Right Open"){comp_dts[i,7]=1}
  else if (!is.na(comp_dts[i,7]) && comp_dts[i,7]=="Right Close"){comp_dts[i,7]=2}
  else if (!is.na(comp_dts[i,7]) && comp_dts[i,7]=="Not sure"){comp_dts[i,7]=""}
  else if (!is.na(comp_dts[i,7]) && comp_dts[i,7]=="Right Out of Sight" & comp_dts[i,6]==0){comp_dts[i,7]=""}   
  
}

for (i in 1:length(comp_dts$Frame)){
  if (!is.na(comp_dts[i,8]) && comp_dts[i,8]=="Left Out of Sight" & comp_dts[i,6]==1) {comp_dts[i,8]=0}
  else if (!is.na(comp_dts[i,8]) && comp_dts[i,8]=="Left Open"){comp_dts[i,8]=1}
  else if (!is.na(comp_dts[i,8]) && comp_dts[i,8]=="Left Close"){comp_dts[i,8]=2}
  else if (!is.na(comp_dts[i,8]) && comp_dts[i,8]=="Not sure"){comp_dts[i,8]=""}
  else if (!is.na(comp_dts[i,8]) && comp_dts[i,8]=="Left Out of Sight" & comp_dts[i,6]==0){comp_dts[i,8]=""}    
}


####### Right eye comparison #####
alpha_value <- 0.4
alpha_value2 <-0.2
adjusted_red <- alpha("firebrick1", alpha_value2)
adjusted_blue <- alpha("steelblue", alpha_value)
width <- 3000
height <- 1920
resolution <- 300

png(paste(filename,"_Right_",GooseID,".png"), res = resolution, height = height, width = width)
par(mar=c(4,8,2,1))

plot(comp_dts$Frame,comp_dts[,3],pch=16,col=adjusted_red,ylim = c(0,2),
     type = "b",yaxt="n",xlab="Frame",main = "Right eye",
     ylab="")
axis(2,at=c(0,1,2),labels=c("Out of sight","Eye Open","Eye Close"),lwd = 1.5,lwd.ticks=1.5,cex.axis=1.5,las=1)

points(comp_dts$Frame,comp_dts[,8], pch = 21,cex=1.2,col = adjusted_blue,bg=adjusted_blue)
lines(comp_dts[,8],comp_dts$Frame, type = "l",col = adjusted_blue)     
legend(24,1.9,legend=c("SOL","DLC"),col=c(adjusted_red,adjusted_blue),pch=16,pt.cex=1.5,cex=1.2)


dev.off() 


####### Left eye comparison#######
png(paste(filename,"_Left_",GooseID,".png"),  res = resolution,  height = height, width = width)
par(mar=c(4,8,2,1))

plot(comp_dts$Frame,comp_dts[,4],pch=16,col=adjusted_red,ylim = c(0,2),
     type = "b",yaxt="n",xlab="Frame",main = "Left eye",
     ylab="")
axis(2,at=c(0,1,2),labels=c("Out of sight","Eye Open","Eye Close"),lwd = 1.5,lwd.ticks=1.5,cex.axis=1.5,las=1)
points(comp_dts$Frame,comp_dts[,7], pch = 21,cex=1.2,col = adjusted_blue,bg=adjusted_blue)
lines(comp_dts$Frame,comp_dts[,7], type = "l",col = adjusted_blue)     
legend(24,1.9,legend=c("SOL","DLC"),col=c(adjusted_red,adjusted_blue),pch=16,pt.cex=1.5,cex=1.2)

dev.off() 

####### Presence comparison#######
png(paste(filename,"_Presence_", GooseID,".png"),  res = resolution, height = height, width = width)
par(mar=c(4,8,2,1))

plot(comp_dts$Frame,comp_dts[,5],pch=16,col=adjusted_red,ylim = c(0,1),
     type = "b",yaxt="n",xlab="Frame",main = "Left eye",
     ylab="")
axis(2,at=c(0,1,2),labels=c("Out of sight","Eye Open","Eye Close"),lwd = 1.5,lwd.ticks=1.5,cex.axis=1.5,las=1)
points(comp_dts$Frame,comp_dts[,6], pch = 21,cex=1.2,col = adjusted_blue,bg=adjusted_blue)
lines(comp_dts$Frame,comp_dts[,6], type = "l",col = adjusted_blue)     
legend(24,1.9,legend=c("SOL","DLC"),col=c(adjusted_red,adjusted_blue),pch=16,pt.cex=1.5,cex=1.2)

dev.off()


}


dipath <- "L:\\DLCValidation\\20220725_D\\csv_dlc\\38\\"
sipath <- "L:\\DLCValidation\\20220725_D\\csv_solomon\\"

arrs <- c()
arrd <- c()
files <- list.files(sipath)
for (file in files) {
  # Check if the file name ends with "Goose31 .csv" (Note the extra space after "Goose31")
  if (endsWith(file, "Goose38 .csv")) {
    arrs <- c(arrs, paste0(sipath,file))
  }
}

files <- list.files(dipath)
for (file in files) {
  # Check if the file name ends with "Goose31 .csv" (Note the extra space after "Goose31")
  if (endsWith(file, ".csv")) {
    arrd <- c(arrd, paste0(dipath,file))
  }
}

Map(Comp_scoring, arrd, arrs)

for (i in arrs)  {
  filepath <- paste0(dipath, i)
  dataframe <- read.csv(filepath)
