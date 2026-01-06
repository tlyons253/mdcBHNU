#' Project N for one year to the nex
#'
#' @param phi.f
#' survival probability
#' @param p.breed
#' breeding probability
#' @param p.fledge
#' 2 parameter describing the number of fledglings produced as a binomial
#' @param p.success
#' the probability a nest survives to produce fledglings
#' @param N the intial abundance
#'
#'
#'
fxn.1year<-function(phi.f=0.5,
                    p.breed=1,
                    p.fledge=c(5,0.6),
                    p.success=0.65,
                    N=50){

  f<-rep(1,N)


  S.breed<-rbinom(f,1,phi.f)

  N.breed<-rbinom(S.breed,1,p.breed)*S.breed

  N.success<-rbinom(N.breed,1,p.success)*N.breed

  N.fledge<-rbinom(N.success,p.fledge[1],p.fledge[2])*N.success

  F.fledge<-rbinom(length(N.fledge),N.fledge,0.5)


  N.out<-sum(F.fledge)+sum(S.breed)

  return(N.out)
}



#' Stochastic simulation of female-only abundance. Single annual breeding
#' attempt
#'
#' @param N.sim Number of simulations
#' @param N.female Number of females initially
#' @param N.years Number of years to project
#' @param ext.thresh (Quasi) extinction threshold abundance
#' @param surv.params 1 value if no stochasticity in survival; 2 parameters
#'   mean/sd
#' @param breed.params 1 value if no stochasticity in breeding probability; 2
#'   parameters mean/sd
#' @param nest.params  1 value if no stochasticity in nest survival probability;
#'   2 parameters mean/sd
#' @param fledge.params 2 parameters to simulate the number of fledglings per
#'   successful nest. Generated via a binomial with the first parameter is the
#'   max number of fledglings that can be produced (N), and the second is the
#'   probability (p_. N*p analogus to lambda from Poisson distribution.
#'
#' @returns Two element list of the projection matrix Nsim x N.years, and the
#' probability of extinction.
#' @export
#'
#'
bhnu.pop.sim<-function(N.sim,N.female,N.years,ext.thresh=0,surv.params,breed.params,
                       nest.params, fledge.params){

  matrix(data=NA,N.sim,N.years)->bhnu.pop


  # Survival stochasiticity
  if(length(surv.params) ==1){
    phi.draws<-matrix(data=surv.params,
                      N.sim,(N.years-1))
  }


  else{
    beta.parms<-get_betadist(surv.params[1],surv.params[2])

    phi.draws<-matrix(data=rbeta(N.sim*(N.years-1),
                                 beta.parms[1],
                                 beta.parms[2]),
                      N.sim,(N.years-1))
  }

  # breeding prob stochasiticty

  if(length(breed.params) ==1){
    breed.draws<-matrix(data=breed.params,
                        N.sim,(N.years-1))
  }


  else{
    beta.parms<-get_betadist(breed.params[1],breed.params[2])

    breed.draws<-matrix(data=rbeta(N.sim*(N.years-1),
                                   beta.parms[1],
                                   beta.parms[2]),
                        N.sim,(N.years-1))
  }


  # Nest success stochasticity


  if(length(nest.params) ==1){
    nest.draws<-matrix(data=nest.params,
                       N.sim,(N.years-1))
  }


  else{
    beta.parms<-get_betadist(nest.params[1],nest.params[2])

    nest.draws<-matrix(data=rbeta(N.sim*(N.years-1),
                                  beta.parms[1],
                                  beta.parms[2]),
                       N.sim,(N.years-1))
  }






  bhnu.pop[,1]<-N.female



  for(i in 1:nrow(bhnu.pop)){
    for(t in 2:ncol(bhnu.pop)){

      bhnu.pop[i,t]<-fxn.1year(N=bhnu.pop[i,t-1],
                               phi.f=phi.draws[i,t-1],
                               p.breed=breed.draws[i,t-1],
                               p.success=nest.draws[i,t-1],
                               p.fledge=fledge.params
      )
    }
  }


  length(bhnu.pop[,ncol(bhnu.pop)]%>%.[.<=ext.thresh])->n.extinct # update to fxn extinct

  pct.extinct<-n.extinct/nrow(bhnu.pop)

  out.list<-list(sim.mat=bhnu.pop,
                 #phi.obs=phi.draws,
                 ext.risk=pct.extinct
  )
  return(out.list)
}
