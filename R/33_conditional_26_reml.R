# Reproduce conditional 26-cohort sensitivity analysis in R (NOT final study approvals).
# Run from the extracted project folder:
# source("R/33_conditional_26_reml.R")
if (!requireNamespace("metafor", quietly=TRUE)) stop("Install package once: install.packages('metafor')")
source_path <- "data/analysis_26_cohorts_CONDITIONAL.csv"
stopifnot(file.exists(source_path))
d <- read.csv(source_path, stringsAsFactors=FALSE, check.names=FALSE)
stopifnot(nrow(d)==26, length(unique(d$study_id))==26, all(is.finite(d$g)), all(is.finite(d$vi)), all(d$vi>0))
dir.create("outputs/conditional26", recursive=TRUE, showWarnings=FALSE)
m <- metafor::rma(yi=d$g, vi=d$vi, method="REML", test="knha")
print(summary(m))
cat("Conditional k:", m$k, "\n")
main <- data.frame(k=m$k, N_cohort_enrolments=sum(d$N_study), g=as.numeric(m$b[1]), SE=m$se,
 CI95_low=m$ci.lb, CI95_high=m$ci.ub, Q=m$QE, Q_df=m$k-1, Q_p=m$QEp,
 tau2=m$tau2, I2=m$I2, scope="CONDITIONAL_IMPUTATION_NOT_FINAL")
write.csv(main, "outputs/conditional26/main_model.csv", row.names=FALSE)
forest <- data.frame(study_id=d$study_id, study=d$author_year, N=d$N_study,
 g=d$g, vi=d$vi, lwr=d$g-1.96*sqrt(d$vi), upr=d$g+1.96*sqrt(d$vi),
 random_effect_weight=as.numeric(stats::weights(m)))
write.csv(forest,"outputs/conditional26/forest_weights.csv",row.names=FALSE)
png("outputs/conditional26/forest_metafor.png", width=1400,height=1900,res=150)
metafor::forest(m, slab=paste(d$author_year,d$study_id), xlab="Hedges g (conditional)")
dev.off()
png("outputs/conditional26/funnel_metafor.png", width=1100,height=850,res=140)
metafor::funnel(m);dev.off()
loo <- metafor::leave1out(m);write.csv(as.data.frame(loo), "outputs/conditional26/leave_one_out.csv")
# Classic Egger regression on SND (using sampling standard errors)
eg <- metafor::regtest(m, model="lm", predictor="sei")
writeLines(capture.output(print(eg)),"outputs/conditional26/egger.txt")
fsn <- tryCatch(metafor::fsn(yi=d$g, vi=d$vi, type="Rosenthal"),error=function(e)e)
writeLines(capture.output(print(fsn)),"outputs/conditional26/fail_safe_N.txt")
tf <- tryCatch(metafor::trimfill(m), error=function(e)e)
writeLines(capture.output(print(tf)),"outputs/conditional26/trimfill.txt")
if(inherits(tf,"rma")) {
 write.csv(data.frame(g=as.numeric(tf$b[1]),ci_low=tf$ci.lb,ci_high=tf$ci.ub,k0=tf$k0),
  "outputs/conditional26/trimfill_numeric.csv",row.names=FALSE)
}
mods <- c("Modality","Expertise_group","Rubric","Domain")
for (v in mods) {
 x <- factor(d[[v]])
 if(nlevels(x)>1) {
  fm <- as.formula(paste("~",v))
  mm <- tryCatch(metafor::rma(yi=g,vi=vi,mods=fm,data=d,method="REML",test="knha"), error=function(e)e)
  writeLines(capture.output(print(mm)),paste0("outputs/conditional26/mod_",v,".txt"))
 }
}
writeLines(capture.output(sessionInfo()), "outputs/conditional26/sessionInfo.txt")
cat("Finished model and figures. No source approval flags changed.\n")
