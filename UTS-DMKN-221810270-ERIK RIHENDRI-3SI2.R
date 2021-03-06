data <- read.csv("C:/Users/ACER/Desktop/data.txt", header=FALSE)

library(dplyr)
library(caret)

data<-na_if(data,'?')
colSums((is.na(data)))

data$V1<-as.factor(data$V1)
data$V2<-as.numeric(data$V2)
data$V4<-as.factor(data$V4)
data$V5<-as.factor(data$V5)
data$V6<-as.factor(data$V6)
data$V7<-as.factor(data$V7)
data$V9<-as.factor(data$V9)
data$V10<-as.factor(data$V10)
data$V12<-as.factor(data$V12)
data$V13<-as.factor(data$V13)
data$V14<-as.numeric(data$V14)
data$V16<-as.factor(data$V16)
str(data)

library(visdat)
vis_miss(data)

data<-na.omit(data)

library(ggplot2)
library(psych)
library(dplyr)
library(randomForest)

set.seed(221810270)
sampel<-sample(2,nrow(data),replace=TRUE, prob=c(0.7,0.3))
training<-data[sampel==1,]
testing<-data[sampel==2,]

rf <- randomForest(V16~., data = training)
print(rf)

pred_rf <- predict(rf, newdata = testing)
confusionMatrix(pred_rf %>% as.factor(), testing$V16 %>% as.factor())

varImpPlot(rf)

myControl <- trainControl(
  method = "cv",
  number = 10,
  verboseIter = FALSE
)
rf_cv <- train(V16~., data=testing,method='rf',trControl=myControl)
confusionMatrix(predict(rf_cv, newdata=testing) %>% as.factor(),testing$V16 %>% as.factor())
