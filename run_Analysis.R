install.packages("reshape")
library(reshape)

Trainingdata<-read.table("train/X_train.txt",sep="",header=FALSE,fill=TRUE)
Testdata<-read.table("test/X_test.txt",sep="",header=FALSE,fill=TRUE)
Fulldata<-rbind(Trainingdata,Testdata)

TrainingActivities<-read.table("train/Y_train.txt",sep=" ",header=FALSE,fill=TRUE)
TestActivities<-read.table("test/Y_test.txt",sep=" ",header=FALSE,fill=TRUE)
ActivityIDs<-rbind(TrainingActivities,TestActivities)

TrainingSubjects<-read.table("train/subject_train.txt",sep=" ",header=FALSE,fill=TRUE)
TestSubjects<-read.table("test/subject_test.txt",sep=" ",header=FALSE,fill=TRUE)
SubjectIDs<-rbind(TrainingSubjects,TestSubjects)

TidyFrame<-cbind(ActivityIDs,SubjectIDs)

LabelsMeas<-read.table("features.txt",sep=" ",header=FALSE)

MeasureLabels<-vector()
for (i in 1:561)
{CheckLabel<-paste(LabelsMeas[i,2])
if((grepl("mean",CheckLabel)==1|grepl("std",CheckLabel)==1))
{Temp<-Fulldata[,i]
TidyFrame<-cbind(TidyFrame,Temp)
MeasureLabels<-append(MeasureLabels,CheckLabel)}
}

ColumnNames<-c("ActivityID","SubjectID")
ColumnNames<-append(ColumnNames,MeasureLabels)
names(TidyFrame)<-ColumnNames

SkinnyFrame<-melt.data.frame(TidyFrame,id.vars=c("ActivityID","SubjectID"))

AggregateFrame<-dcast(SkinnyFrame,ActivityID + SubjectID~variable,mean)

LabelsAct<-read.table("activity_labels.txt",sep=" ",header=FALSE)
names(LabelsAct)<-c("ActivityID","ActivityName")
FinalFrame<-merge(LabelsAct,AggregateFrame)
FinalFrame<-FinalFrame[,2:82]

write.table(FinalFrame,file="Tidydataset.txt",row.names=FALSE)
