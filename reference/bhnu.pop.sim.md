# Stochastic simulation of female-only abundance. Single annual breeding attempt

Stochastic simulation of female-only abundance. Single annual breeding
attempt

## Usage

``` r
bhnu.pop.sim(
  N.sim,
  N.female,
  N.years,
  ext.thresh = 0,
  surv.params,
  breed.params,
  nest.params,
  fledge.params
)
```

## Arguments

- N.sim:

  Number of simulations

- N.female:

  Number of females initially

- N.years:

  Number of years to project

- ext.thresh:

  (Quasi) extinction threshold abundance

- surv.params:

  1 value if no stochasticity in survival; 2 parameters mean/sd

- breed.params:

  1 value if no stochasticity in breeding probability; 2 parameters
  mean/sd

- nest.params:

  1 value if no stochasticity in nest survival probability; 2 parameters
  mean/sd

- fledge.params:

  2 parameters to simulate the number of fledglings per successful nest.
  Generated via a binomial with the first parameter is the max number of
  fledglings that can be produced (N), and the second is the probability
  (p\_. N\*p analogus to lambda from Poisson distribution.

## Value

Two element list of the projection matrix Nsim x N.years, and the
probability of extinction.
