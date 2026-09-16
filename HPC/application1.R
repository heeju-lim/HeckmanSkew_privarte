.libPaths("~/rlibs")
if(!require(HeckmanEM))   install.packages("HeckmanEM");   library(HeckmanEM)
if(!require(mvtnorm))   install.packages("mvtnorm");   library(mvtnorm)
if(!require(loo))   install.packages("loo"); library("loo")
if(!require(rstan))   install.packages("rstan"); library(rstan, quietly = T)
if(!require(shinystan))   install.packages("shinystan"); library(shinystan)

source("UtilitariesHeckmanNew.R")
data1 <- read.csv("statadata2.csv")

x<- cbind(1, data1$age, data1$female, data1$educ, data1$blhisp,  data1$totchr, data1$ins)
w<- cbind(x, data1$income)
data1$lambexp[is.na(data1$lambexp)]<-0
cc<- data1$dambexp                                                                                                            
y<- data1$lnambx
n<-length(cc)

data = list(N = n, N_y = sum(cc==1), p = ncol(x), q = ncol(w), X = x[cc > 0, ], Z = w, D = cc, y = y[cc > 0])

fit.sn_stan <- stan(
  file = "HeckmanSkewNormallast.stan",
  data = data,
  thin = 5,
  chains = 1,
  iter = 10000,
  warmup = 1000
)

# --------------------------------------------------
# Results
# --------------------------------------------------

fit.sn_stan

print(
  fit.sn_stan,
  pars = c(
    "beta",
    "gamma",
    "sigma2",
    "rho",
    "lambda"
  )
)
