#**********************************************************************************
#* Comvis pipeline Stage 1: Quality Filter
#* Thsi script read in manual scores of the test images to 5 quality classes from
#* "clearly un-usable" to "Clearly usable" and the results of an algorithm
#* automatically processing the images using a Laplace filter. It then compares
#* the manual scores over observers, and the correlation between observer's scores
#* and the scores from the algorithm using an ordinal regression model over all 5 categories.
#* As the purpose of a quality filter will often be to get rid just of the 
#* "clearly unusable" images, we further investigate a simple logistic regression model which 
#* attempt to discriminate just the worst quality class from the rest.
#* 
#* Code by: Jane Uhd Jepsen and Benjamin Cretois
#* Last modified: Sept 13th 2023
#*
#**********************************************************************************

# Libraries
library(tidyverse)
library(ordinal)
library(ggplot2)
library(ggeffects) #for prediction
library(polycor) #for correlations in nominal values
library(lme4)

# Setup
setwd("P:/823001_17_metodesats_analyse_23_04_jepsen/Stage_1_manual_annotation")

#################################
# Open the dataframe and modify #
#################################
#Manual scores
results_people <- read_csv("results_manualann.csv") %>% 
  select(!Time) %>% 
  pivot_longer(., !Participant, names_to = "path", values_to = "score") %>% 
  mutate(path_fixed = str_split_fixed(path, pattern = " | ", n=5)[,5],
         score_factor = factor(score, levels=c(1,2,3,4,5))) %>% 
  select(!path)

#Algorithm using images standardized to same resolution
results_algo_same <- read_tsv("results_algorithm_sameresolution.tsv") %>% 
  mutate(path_fixed = str_split_fixed(path, pattern = "/", n=2)[,2])  %>% 
  select(!path)

#########################################
# Some explorative plots of the votes
#########################################
voting_summary <- results_people %>% 
  group_by(path_fixed, score_factor) %>% 
  summarise(n=n())

# Produce heatmap
# Result showing the number of participant voting for a specific score for a given image
voting_summary %>% 
  ggplot(aes(x=score_factor, y=path_fixed, fill=n)) + 
  geom_tile() + 
  geom_text(aes(label=n)) + 
  scale_fill_viridis_c() 
# -> It looks like we all agree more or less, but let's see better -->

# Summary of the number of people's agreement --
################################################
unique(voting_summary$path_fixed) # There are 130 images

voting_summary %>% 
  filter(n > 6)
# -> For 105 out of 130 (80%) images more than 6 people agreed on the scoring (majority)

####################################################################
# Ordinal regression between algorithm score and people's' score #
####################################################################

#The quality score (1-5) is an ordinal categorical scale, so we cannot take the mean/weighted mean of the score 
#and calculate a pearson correlation coefficient as if it was a continuous scale. 
#Polychoric correlation could be used, but not on mean values

#Join dataframes and look at correlation ignoring observers for now
scores <- full_join(results_algo_same, results_people, by = "path_fixed") %>% drop_na()

scores$Participant_num<-as.factor(as.numeric(as.factor(scores$Participant))) #anonymize Participants in plots
scores$sizemb<-scores$size/1000000
scores$sizekb<-scores$size/1000
polychor(scores$score_factor, scores$sizekb) 
polychor(scores$score_factor, scores$var_k1) 
polychor(scores$score_factor, scores$max_k1) 
polychor(scores$score_factor, scores$var_k3) 
polychor(scores$score_factor, scores$max_k3) 
polychor(scores$score_factor, scores$var_k5) 
polychor(scores$score_factor, scores$max_k3) 

#However, a ordinal model which can take observer effects into account is probably more informative
#Here we may ask: Can we approach the observers' allocation to class based on image size alone?
#Where are the cutoff points (in size) between classes?

#plot the data
ggplot(scores, aes(x=sizekb,y=score_factor)) + geom_boxplot()  + ggtitle("Image data")
# -> there is clearly a relationship between image size and score factor and score factor 1 (unusable) stands out from the rest)
ggplot(scores, aes(x=sizekb,y=score_factor)) + geom_boxplot(aes(fill=Participant_num))  + ggtitle("Image data")
# -> It also looks like there are observer effects, with some observers consistently higher than others.
#This suggest that we should include observer effects in the model

#We therefore formulate ordinal regression with score factor as response, image size as predictor and observer as random effect
#null model, only random effects
model0 <- clmm(score_factor ~ 1 + (1|Participant_num), data = scores) 
summary(model0)
#Size as predictor of manual score with random effect
model1 <- clmm(score_factor ~ sizekb  +(1|Participant_num), data = scores, Hess=TRUE)
summary(model1)
odds<-exp(coef(model1))
#Size as predictor of manual score without random effect
model2 <- clm(score_factor ~ sizekb , data = scores, Hess=TRUE)
#compare model 1 and 2
anova(model2,model1)
# -> Image size is highly significant and positive -> higher image size=higher score_factor (model1). 
# -> The observer effect is highly significant (anova(model2, model1)

#Explore models which include the other variables. These suggests that an improvement (AIC) can be gained from including var_k1, but none of the others
model4 <- clmm(score_factor ~ sizekb + var_k1   +(1|Participant_num), data = scores, Hess=TRUE)
summary(model4)
anova (model4,model1)

#Plot random effects (=Participant).
par(mfrow = c(2,2))

model<-model1 #Switch here btw model 1 and model4

ci <- model$ranef + qnorm(0.975) * sqrt(model$condVar) %o% c(-1, 1)
ord.re <- order(model$ranef)
ci <- ci[order(model$ranef),]
n<-length(model$ranef)
plot(1:n, model$ranef[ord.re], axes=FALSE, ylim=range(ci),
       xlab="Observer", ylab="Effect",main="Effect of individual observers")
axis(1, at=1:n, labels = ord.re)
axis(2)
for(i in 1:n) segments(i, ci[i,1], i, ci[i, 2])
abline(h = 0, lty=2)
# -> We see that observer no. 9 and 10 tend to score lowest and no. 12 highest

#PLot the probability that an average, a strict and a not strict observer place an image in a given category depending on image size
new_dat <- expand.grid(Participant_num = qnorm(0.95) * c(-1, 0, 1) * 0.327, sizekb = model$beta*10)
plot.probabilities(new_dat, model, c("5th %-tile observer","avg. observer","95th %-tile observer"),col=c(1,1,1), main="Effects of observer type, image size=10 kb")

new_dat <- expand.grid(Participant_num = qnorm(0.95) * c(-1, 0, 1) * 0.327, sizekb = model$beta*50)
plot.probabilities(new_dat, model, c("5th %-tile observer","avg. observer","95th %-tile observer"),col=c(1,1,1), main="Effects of observer type, image size=50 kb")

new_dat <- expand.grid(Participant_num = qnorm(0.95) * c(-1, 0, 1) * 0.327, sizekb = model$beta*150)
plot.probabilities(new_dat, model, c("5th %-tile observer","avg. observer","95th %-tile observer"),col=c(1,1,1), main="Effects of observer type, image size=150 kb")

#Predict the probability of each score class over the whole range of image sizes
#Average observer and image sizes from 5 to 300 kb (observed range=20-300)
#Model1
new_dat_all<-expand.grid(Participant_num = 0, sizekb = seq(5,300,1)*model1$beta)
pred_all = as.data.frame (pred(eta = rowSums(new_dat_all),theta = model1$Theta))
colnames(pred_all) = c("C1","C2","C3","C4","C5")
DBs = as.data.frame(seq(from= 5, to= 300,by=1))
colnames(DBs)="LAEQ"
pred_all2 = cbind(pred_all,DBs)
pred_allm = reshape:: melt(pred_all)
DBsm = rbind(DBs,DBs,DBs,DBs,DBs)
pred_all2m = cbind(pred_allm,DBsm)

ggplot(pred_all2m, aes(LAEQ,value,color=variable))+
  geom_line(size=2)+
  ylab("Probability for score") + xlab("Scaled image size (kb)")+
  theme_bw()+
  scale_color_viridis_d()

#Model4 , though marginally better based on AIC, produce the same pattern
new_dat_all<-expand.grid(Participant_num = 0, sizekb = seq(5,300,1)*model4$beta[1],var_k1=100*model4$beta[2] )
pred_all = as.data.frame (pred(eta = rowSums(new_dat_all),theta = model4$Theta))
colnames(pred_all) = c("C1","C2","C3","C4","C5")
DBs = as.data.frame(seq(from= 5, to= 300,by=1))
colnames(DBs)="LAEQ"
pred_all2 = cbind(pred_all,DBs)
pred_allm = reshape:: melt(pred_all)
DBsm = rbind(DBs,DBs,DBs,DBs,DBs)
pred_all2m = cbind(pred_allm,DBsm)

ggplot(pred_all2m, aes(LAEQ,value,color=variable))+
  geom_line(size=2)+
  ylab("Probability for score") + xlab("Scaled image size (kb)")+
  theme_bw()+
  scale_color_viridis_d()

#****** END ordinal regression *****

################################################################################
#   Logistic regression to distinguish the worst quality class from the rest
################################################################################
#A few images with much larger image size than the rest (different camera brand) are causing a substantially lower model fit.
#Try running also without these
#scores<-scores[scores$sizekb<200,]
#bin the score factor into a binary variable with 0 if score factor is the worst class, else 1
scores$isC1<-ifelse(scores$score_factor==1,1,0)

#Randomly split the data into test and training data
index <- sample(nrow(scores),nrow(scores)*0.80)
scores_train = scores[index,]
scores_test = scores[-index,]

model5<-glm(isC1 ~ sizekb, data = scores_train, family = "binomial") #simple, no observer random effect
model6<-glmer(isC1 ~ sizekb +(1|Participant_num), data = scores_train, family="binomial")

#odds ratios and 95% CI - the two models produce very similar results. For a model
#including only size as a predictor: for every unit increase in image size the odds of being in class 2 or better increase by ~1.12
#when just trying to distinguish the worst class from the rest there is not really an observer effect either
odd.glm<-exp(cbind(OR = coef(model5), confint(model5)))

se <- sqrt(diag(vcov(model6)))
odd.glmer<-exp(cbind(Est = fixef(model6), LL = fixef(model6) - 1.96 * se, UL = fixef(model6) + 1.96 *
                       se))

#try also models which include var_k1 (suggested by the ordinal model to be the best additional predictor)
model7<-glm(isC1 ~ sizekb+ var_k1 , data = scores_train, family = "binomial") #simple, no observer random effect
model8<-glmer(isC1 ~ sizekb+ var_k1  +(1|Participant_num), data = scores_train, family="binomial")

#odds ratios and 95% CI - the two models produce very similar results. For a model
#including size and var_k1 as predictors: var_k1 improves the models but nothing dramatic. Odds on size is still ~1.12-1.13
odd.glm<-exp(cbind(OR = coef(model7), confint(model7)))

se <- sqrt(diag(vcov(model8)))
odd.glmer<-exp(cbind(Est = fixef(model8), LL = fixef(model8) - 1.96 * se, UL = fixef(model8) + 1.96 *
                       se))


#Do the ROC curves for illustration. Just the models with size as a predictor since there is very little gained in including var_k1
#install.packages("ROCR")
library(ROCR)

#Prediction out-of-sample on the 20% of scores not used to develop the model
pred5_OOS <- predict(model5, newdata=scores_test,type = "response")
pred6_OOS <- predict(model6, newdata=scores_test,type = "response")

prediction5_OSS <- ROCR::prediction(pred5_OOS,scores_test$isC1)
prediction6_OSS <- ROCR::prediction(pred6_OOS,scores_test$isC1)
perf5_OSS<-performance(prediction5_OSS,"tpr","fpr")
perf6_OSS<-performance(prediction6_OSS,"tpr","fpr")

par(mfrow=c(2,1))
plot(perf5_OSS,colorize=TRUE,main=paste("out-of-sample, glm(notC1~size).\nAUC = ",round(unlist(slot(performance(prediction5_OSS, "auc"), "y.values")),3)))
plot(perf6_OSS,colorize=TRUE,main=paste("out-of-sample,glmer(notC1~size+(1|Observer)).\nAUC = ",round(unlist(slot(performance(prediction6_OSS, "auc"), "y.values")),3)))

#**** END logistic regression *********

#****** HELPER FUNCTIONS FOR ORDINAL REGRESSION ********************************************************************************
#to convert the effect to probability:
pred <- function(eta, theta, cat = 1:(length(theta) + 1), inv.link = plogis) {
    Theta <- c(-1000, theta, 1000)
    sapply(cat, function(j) inv.link(Theta[j + 1] - eta) - inv.link(Theta[j] - eta))}

#to plot effects 
plot.probabilities<-function(grid, model, leg, draw.these=NULL, main="", xlab="", legend.pos="topleft", ylim=NULL, col=NULL, lty=NULL) {
  co <- model$coefficients[1:length(model$y.levels)-1]
  pre.mat <- pred(eta=rowSums(grid), theta=co)
  n.total<-length(pre.mat)
  n.rows<-length(pre.mat[1,])
  n <- n.total/n.rows
  ylim <- if(is.null(ylim)) c(0,1)
  else ylim
  draw.these <- if(is.null(draw.these)) 1:n
  else draw.these
  mycols<-topo.colors(max(draw.these))
  
  plot(model$y.levels, pre.mat[draw.these[1],], lty=1, type="l", ylim=ylim, xlab=xlab, axes=FALSE, ylab="Probability", las=1, main=main)
  axis(1)
  axis(2)
  i <- 1
  for(k in draw.these) {
    #draw_color <- if(is.null(col)) "black"
    draw_color <- if(is.null(col)) mycols[i]
    else col[i]
    curr_lty <- if(is.null(lty)) i
    else lty[i]
    lines(model$y.levels, pre.mat[k,], lty=curr_lty, col=draw_color)
    i <- i + 1 
  }
  if(is.null(lty)) { 
    legend(legend.pos, leg, lty=1:i, bty="n")
    #legend(legend.pos, leg, col=mycols[1:i], bty="n")
  }
  else {
    legend(legend.pos, leg, lty=lty, bty="n")
    #legend(legend.pos, leg, col=col, bty="n")
  
  }
}
#************************************************************************************************


