
# data <- read.csv2("boat_session_6167.csv", sep = ",", dec = ".")
#path <- "bs6165_20220919_chunks.csv"
Extract.table<- function(data, path) {
  
  Subset<- subset(data, data$VID_LDW=="14")
  Frame2=data.frame(Subset$Frame[-1])
  Empty <- 1
  Frame2= rbind(Frame2, Empty)
  Dataset = data.frame(Subset$Frame,Frame2,Subset$VID_LDW,Subset$VID_LDW_Confidence)
  colnames(Dataset)<- c("Frame", "Frame_shift", "VID_LDW","VID_LDW_Confidence")
  
  Dataset$Frame_shift=as.numeric(Dataset$Frame_shift)
  Dataset$Frame=as.numeric(Dataset$Frame)
  Dataset$Frame_diff= Dataset$Frame_shift-Dataset$Frame
  
  End=data.frame(Dataset$Frame,Dataset$Frame_diff)
  colnames(End)<- c("End_Frame", "Frame_diff")
  
  
  shift <- 501
  Frame_diff= t(Dataset$Frame_diff)
  Frame_diff= t(Frame_diff)
  new_frame_shift= rbind(shift, Frame_diff)
  new_frame_shift= data.frame(new_frame_shift[-length(new_frame_shift)])
  Start=data.frame(Dataset$Frame,new_frame_shift)
  colnames(Start)<- c("Start_Frame", "New_Frame_diff")
  
  
  End_tab<- subset(End, End$Frame_diff>=500)
  Start_tab<- subset(Start, Start$New_Frame_diff>=500)
  Start_tab <- head(Start_tab, - 1)
  
  
  
  Final_Table=data.frame(Start_tab$Start_Frame,End_tab$End_Frame,(Start_tab$Start_Frame-500)/25,(End_tab$End_Frame+500)/25)
  colnames(Final_Table)<- c("Start_Frame","End_Frame","Start_Time","End_Time")
  Final_Table$diff= (Final_Table$End_Time-Final_Table$Start_Time)+0.04
  x = write.csv(Final_Table, path, row.names=FALSE)

  return(x)


}

