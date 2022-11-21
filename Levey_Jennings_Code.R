library(ggplot2)
library(ggtext)
library(ggExtra)
library(gridExtra)
library(grid)

#Generate 40 records for example purposes only.
set.seed(123)
dataset <- data.frame(
  Month = c(rep("January",20),rep("February",20)),
  Day = c(seq(1,20), seq(1,20)),
  GLUC = rnorm(40, 108, 17),
  UREA = rnorm(40, 32.6, 7.2),
  CREA = rnorm(40, 1.19,0.6),
  UA = rnorm(40, 4.78, 0.67)
)
#Add a column containing an ID according to the data length 
dataset$ID <- c(1:length(dataset$Month))

#Subset data of interest
#"startID" contains the start of the analysis  
startID <- 1
#"endID" contains the end of the analysis 
endID <- 30
#Section of the data between "startID" and "endID"
dataset <- subset(dataset, ID >= startID & ID <= endID)

#Statics
#Create a data frame containing: Parameters, Mean and Standard Deviation
Statics <- data.frame(
  Parameters = c("GLUC", "UREA", "CREA", "UA"),
  Mean = c(round(mean(dataset$GLUC),1),
           round(mean(dataset$UREA),1),
           round(mean(dataset$CREA),1),
           round(mean(dataset$UA),1)
  ),
  sd = c(round(sd(dataset$GLUC),1),
         round(sd(dataset$UREA),1),
         round(sd(dataset$CREA),1),
         round(sd(dataset$UA),1)
  )
)

#Graphic parameters
#Obtaining upper and lower limits
Statics$U1s = round(Statics$Mean+(1*Statics$sd), digits = 1)
Statics$L1s = round(Statics$Mean-(1*Statics$sd), digits = 1)
Statics$U2s = round(Statics$Mean+(2*Statics$sd), digits = 1)
Statics$L2s = round(Statics$Mean-(2*Statics$sd), digits = 1)
Statics$U3s = round(Statics$Mean+(3*Statics$sd), digits = 1)
Statics$L3s = round(Statics$Mean-(3*Statics$sd), digits = 1)
#Obtaining y-axis values for each parameter
Statics$ymin = round(Statics$L3s, digits = 0)
Statics$ymax = round(Statics$U3s, digits = 0)

#Obtaining the data length 
xlabel <- length(dataset$ID)

#Levey-Jennings Charts
#Glucose plot
p1 <- ggplot(dataset, aes(x=ID, y=GLUC))+
  geom_line() +
  geom_point()+
  #Set two y-axis: 
  #Left y-axis range between ymin and ymax. 
  scale_y_continuous(breaks = seq(Statics[1,10], Statics[1,11], by = 10),
                     #Right y-axis corresponds to L3s, L2s, L1s, Mean, U1s, U2s, U3s.
                     sec.axis = sec_axis(~., breaks = 
                                           c(Statics[1,9], Statics[1,7],Statics[1,5], 
                                             Statics[1,2],
                                             Statics[1,4], Statics[1,6], Statics[1,8])))+
  #Set two y-axis:
  #The bottom x-axis corresponds to the section of the data between "startID" and "endID"
  scale_x_continuous(breaks = seq(startID,endID,by = 1),
                     #The upper x-axis indicates the record day
                     sec.axis = sec_axis(~.,
                                         breaks=c(startID:endID),
                                         labels = dataset$Day))+
  #Add horizontal lines for Mean, U1s, L1s, U2s, L2s, U3s, and L3s values. 
  geom_hline(aes(yintercept = Statics[1,2], color="Mean"))+
  geom_hline(aes(yintercept = Statics[1,4], color="+1 SD"))+
  geom_hline(aes(yintercept = Statics[1,5], color="-1 SD"))+
  geom_hline(aes(yintercept = Statics[1,6], color="+2 SD"))+
  geom_hline(aes(yintercept = Statics[1,7], color="-2 SD"))+
  geom_hline(aes(yintercept = Statics[1,8], color="+3 SD"))+
  geom_hline(aes(yintercept = Statics[1,9], color="-3 SD"))+
  #Set order and color of legend text 
  scale_colour_manual("", 
                      breaks = c("+3 SD", "+2 SD", "+1 SD", "Mean", 
                                 "-1 SD", "-2 SD", "-3 SD"),
                      values = c("darkred", "darkgoldenrod1", "darkgreen", "dodgerblue4",
                                 "darkgreen", "darkgoldenrod1", "darkred"))+
  #Set the plot text
  labs(x= element_blank(), y="Values*", title = "GLUCOSE")+
  theme(plot.title = element_textbox_simple(fill="gray", halign=0.5),
        axis.text.x.bottom = element_blank(),
        axis.text.x.top = element_text(angle = 90, hjust = 1,size=8))
#Add a density marginal plot
plot1 <- ggMarginal(p1, type = "density", margins = "y", colour="black",  size=4, fill="plum2")


#Urea plot
p2 <- ggplot(dataset, aes(x=ID, y=UREA))+
  geom_line() +
  geom_point()+
  #Set two y-axis: 
  #Left y-axis range between ymin and ymax. 
  scale_y_continuous(breaks = seq(Statics[2,10], Statics[2,11], by = 5),
                     #Right y-axis corresponds to L3s, L2s, L1s, Mean, U1s, U2s, U3s.
                     sec.axis = sec_axis(~., breaks = 
                                           c(Statics[2,9], Statics[2,7],Statics[2,5], 
                                             Statics[2,2],
                                             Statics[2,4], Statics[2,6], Statics[2,8])))+
  #Set two y-axis:
  #The bottom x-axis corresponds to the section of the data between "startID" and "endID"
  scale_x_continuous(breaks = seq(startID,endID,by = 1),
                     #The upper x-axis indicates the record day
                     sec.axis = sec_axis(~.,
                                         breaks=c(startID:endID),
                                         labels = dataset$Day))+
  #Add horizontal lines for Mean, U1s, L1s, U2s, L2s, U3s, and L3s values. 
  geom_hline(aes(yintercept = Statics[2,2], color="Mean"))+
  geom_hline(aes(yintercept = Statics[2,4], color="+1 SD"))+
  geom_hline(aes(yintercept = Statics[2,5], color="-1 SD"))+
  geom_hline(aes(yintercept = Statics[2,6], color="+2 SD"))+
  geom_hline(aes(yintercept = Statics[2,7], color="-2 SD"))+
  geom_hline(aes(yintercept = Statics[2,8], color="+3 SD"))+
  geom_hline(aes(yintercept = Statics[2,9], color="-3 SD"))+
  #Set order and color of legend text 
  scale_colour_manual("", 
                      breaks = c("+3 SD", "+2 SD", "+1 SD", "Mean", 
                                 "-1 SD", "-2 SD", "-3 SD"),
                      values = c("darkred", "darkgoldenrod1", "darkgreen", "dodgerblue4",
                                 "darkgreen", "darkgoldenrod1", "darkred"))+
  #Set the plot text
  labs(x= element_blank(), y="Values*", title = "UREA")+
  theme(plot.title = element_textbox_simple(fill="gray", halign=0.5),
        axis.text.x.bottom = element_blank(),
        axis.text.x.top = element_text(angle = 90, hjust = 1,size=8))
#Add a density marginal plot
plot2 <- ggMarginal(p2, type = "density", margins = "y", colour="black",  size=4, fill="plum2")


#Crea plot
p3 <- ggplot(dataset, aes(x=ID, y=CREA))+
  geom_line() +
  geom_point()+
  #Set two y-axis: 
  #Left y-axis range between ymin and ymax. 
  scale_y_continuous(breaks = seq(Statics[3,10], Statics[3,11]+0.25, by = 0.25),
                     #Right y-axis corresponds to L3s, L2s, L1s, Mean, U1s, U2s, U3s.
                     sec.axis = sec_axis(~., breaks = 
                                           c(Statics[3,9], Statics[3,7],Statics[3,5], 
                                             Statics[3,2],
                                             Statics[3,4], Statics[3,6], Statics[3,8])))+
  #Set two y-axis:
  #The bottom x-axis corresponds to the section of the data between "startID" and "endID"
  scale_x_continuous(breaks = seq(startID,endID,by = 1),
                     #The upper x-axis indicates the record day
                     sec.axis = sec_axis(~.,
                                         breaks=c(startID:endID),
                                         labels = dataset$Day))+
  #Add horizontal lines for Mean, U1s, L1s, U2s, L2s, U3s, and L3s values. 
  geom_hline(aes(yintercept = Statics[3,2], color="Mean"))+
  geom_hline(aes(yintercept = Statics[3,4], color="+1 SD"))+
  geom_hline(aes(yintercept = Statics[3,5], color="-1 SD"))+
  geom_hline(aes(yintercept = Statics[3,6], color="+2 SD"))+
  geom_hline(aes(yintercept = Statics[3,7], color="-2 SD"))+
  geom_hline(aes(yintercept = Statics[3,8], color="+3 SD"))+
  geom_hline(aes(yintercept = Statics[3,9], color="-3 SD"))+
  #Set order and color of legend text 
  scale_colour_manual("", 
                      breaks = c("+3 SD", "+2 SD", "+1 SD", "Mean", 
                                 "-1 SD", "-2 SD", "-3 SD"),
                      values = c("darkred", "darkgoldenrod1", "darkgreen", "dodgerblue4",
                                 "darkgreen", "darkgoldenrod1", "darkred"))+
  #Set the plot text
  labs(x = "Event number",y="Values*", title = "CREATININE")+
  theme(plot.title = element_textbox_simple(fill="gray", halign=0.5),
        axis.text.x.bottom = element_text(angle = 90, hjust = 1,size=8),
        axis.text.x.top = element_blank())
#Add a density marginal plot
plot3 <- ggMarginal(p3, type = "density", margins = "y", colour="black",  size=4, fill="plum2")


#UA plot
p4 <- ggplot(dataset, aes(x=ID, y=UA))+
  geom_line() +
  geom_point()+
  #Set two y-axis: 
  #Left y-axis range between ymin and ymax. 
  scale_y_continuous(breaks = seq(Statics[4,10], Statics[4,11], by = 0.5),
                     #Right y-axis corresponds to L3s, L2s, L1s, Mean, U1s, U2s, U3s.
                     sec.axis = sec_axis(~., breaks = 
                                           c(Statics[4,9], Statics[4,7],Statics[4,5], 
                                             Statics[4,2],
                                             Statics[4,4], Statics[4,6], Statics[4,8])))+
  #Set two y-axis:
  #The bottom x-axis corresponds to the section of the data between "startID" and "endID"
  scale_x_continuous(breaks = seq(startID,endID,by = 1),
                     #The upper x-axis indicates the record day
                     sec.axis = sec_axis(~.,
                                         breaks=c(startID:endID),
                                         labels = dataset$Day))+
  #Add horizontal lines for Mean, U1s, L1s, U2s, L2s, U3s, and L3s values. 
  geom_hline(aes(yintercept = Statics[4,2], color="Mean"))+
  geom_hline(aes(yintercept = Statics[4,4], color="+1 SD"))+
  geom_hline(aes(yintercept = Statics[4,5], color="-1 SD"))+
  geom_hline(aes(yintercept = Statics[4,6], color="+2 SD"))+
  geom_hline(aes(yintercept = Statics[4,7], color="-2 SD"))+
  geom_hline(aes(yintercept = Statics[4,8], color="+3 SD"))+
  geom_hline(aes(yintercept = Statics[4,9], color="-3 SD"))+
  #Set order and color of legend text 
  scale_colour_manual("", 
                      breaks = c("+3 SD", "+2 SD", "+1 SD", "Mean", 
                                 "-1 SD", "-2 SD", "-3 SD"),
                      values = c("darkred", "darkgoldenrod1", "darkgreen", "dodgerblue4",
                                 "darkgreen", "darkgoldenrod1", "darkred"))+
  #Set the plot text
  labs(x = "Event number",y="Values*", title = "URIC ACID")+
  theme(plot.title = element_textbox_simple(fill="gray", halign=0.5),
        axis.text.x.bottom = element_text(angle = 90, hjust = 1,size=8),
        axis.text.x.top = element_blank())
#Add a density marginal plot
plot4 <- ggMarginal(p4, type = "density", margins = "y", colour="black",  size=4, fill="plum2")


#All plots 
dataset$Date <- paste(dataset$Month, dataset$Day)
grid.arrange(plot1,plot2, plot3, plot4, nrow = 2, 
             top=textGrob(paste0("Period of ", xlabel," events between:", "\n ",
                                 dataset[1,8]," - ", dataset[xlabel,8],"\n ")),
             bottom=textGrob("*NORMALLY DISTRIBUTED DATA OBTAINED RANDOMLY",
                             gp = gpar(fontface = "bold")))