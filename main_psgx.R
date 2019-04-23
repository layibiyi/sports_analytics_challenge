#libraries
library(caret)
library(XML)
library(reshape)
library(plyr)

#load models
load(file="mainmodel1-rf.rds") #loads as model1
load(file = "mainmodel2-cart.rda") #loads as model2
load(file = "mainmodel3-glm.rda") #loads as model3
load(file = "mainmodel4-glm.rda") #loads as model4

#result function
Result <- function(x){
  grabAll <- function(XML.parsed, field){
  parse.field <- xpathSApply(XML.parsed, paste("//", field, "[@*]", sep=""))
  results <- t(sapply(parse.field, function(x) xmlAttrs(x)))
  if(typeof(results)=="list"){
    do.call(rbind.fill, lapply(lapply(results, t), data.frame, stringsAsFactors=F))
  } else {
    as.data.frame(results, stringsAsFactors=F)
  }
  }
  #AllParse <- xmlInternalTreeParse(x)
  EventInf <- grabAll(x, "Event")
  EventParse <- xpathSApply(x, "//Event")
  No_of_Q <- sapply(EventParse, function(x) sum(names(xmlChildren(x)) == "Q"))
  EventsMultiples <- as.data.frame(lapply(EventInf[,c(1,2,8)], function(x) rep(x, No_of_Q)), stringsAsFactors=F)
  Qualifiers <- cbind(EventsMultiples, grabAll(x, "Q"))
  Qualifiers$qualifier_id <- ifelse(Qualifiers$qualifier_id=="","NotUsed",Qualifiers$qualifier_id)
  Qualifiers <- cast(Qualifiers, event_id+team_id~ qualifier_id,fun.aggregate = max)
  # All Game Events
  Events <- merge(EventInf, Qualifiers, all.x=T, suffixes=c("", "Q"))
  #Events <- Events[ ,!names(Events) %in% c("id","timestamp","last_modified","version","NotUsed")]
  Events <- Events[ ,names(Events) %in% c("event_id","team_id","min","sec","player_id","type_id", "outcome","x","y","212","213","56")]
  colnames(Events)[ grep("212",names(Events))]<- "X212"
  colnames(Events)[ grep("213",names(Events))]<- "X213"
  colnames(Events)[ grep("56",names(Events))]<- "X56"
  # Other Feature Manipulation
  Events$x <- as.double(Events$x)
  Events$y <- as.double(Events$y)
  Events$min <- as.numeric(Events$min)
  Events$sec <- as.numeric(Events$sec)
  Events$event_id<-as.numeric(Events$event_id)
  Events$type_id<-as.factor(Events$type_id)
  Events$outcome<-as.factor(Events$outcome)
  Events$X212<-as.numeric(sub("," , ".", Events$X212))
  Events$X213<-as.numeric(sub("," , ".", Events$X213))
  Events$team_id<-as.factor(Events$team_id)
  Events$player_id<-as.factor(Events$player_id)
  new <- which(!(Events$type_id %in% c("1", "12", "43")))
  Events$type_id[new]<-1
  # Sort by minute and seconds
  Events <- Events[order(Events$min,Events$sec),]
  # prediction
  pred1_1 <- predict(model1,Events)
  player_id <- names(sort(-table(pred1_1[grep("1",Events$player_id)])))[1]
  pred2_1 <- predict(model2,Events,na.action = na.pass)
  next_team <-pred2_1[length(pred2_1)] #1 for no, #0 for yes
  if(next_team=="1") next_team<-Events$team_id[length(pred2_1)]
  if(next_team=="0"&Events$team_id[length(pred2_1)]=="1") next_team<-"0"
  if(next_team=="0"&Events$team_id[length(pred2_1)]=="0") next_team<-"1"
  pred3_1 <- predict(model3,Events,na.action = na.pass)
  next_y <-pred3_1[length(pred3_1)]
  next_y <- format(round(next_y, 1), nsmall = 1)
  pred4_1 <- predict(model4,Events,na.action = na.pass)
  next_x<-pred4_1[length(pred4_1)]
  next_x <- format(round(next_x, 1), nsmall = 1)
  result_values <- data.frame(player_id,next_team,next_y,next_x)
  write.table(result_values,"res_psgx.csv",sep = ",", row.names = F,col.names = F)
}


xml_1 <- xmlParse(path)
Result(xml_1)
