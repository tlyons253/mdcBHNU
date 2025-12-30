
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mdcBHNU

<!-- badges: start -->

<!-- badges: end -->

## Installation

You can install mdcBHNU from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("tlyons253/mdcBHNU") #or

devtools::install_github('tlyons253/mdcBHNU')
```

The plotting functions will only work with the MDC nuthatch project as
of now, but others should be general enough to work with other .motus
projects.

## Example workflow

You might do this to get and plot tag hits. You may need to change the
path to your copy of the .motus file or depending on how it is mapped on
your computer.

``` r
library(mdcBHNU)

Sys.setenv(TZ='UTC')  # Always set before opening connections or importing data....UTC avoids issues with time changes due to DST

open_motus('C:/Location/of/motus/database/project-123.motus')->bhnu.con

hit.resident(bhnu.con, project.id=c(123))->bhnu.list 
# are mike's towers still active? could add their ID's here if it's just ones local to MO.

close_motus(bhnu.con) # close the connection

bhnu.raw<-bhnu.list[[1]]

hit.cleanup(bhnu.raw)->bhnu.clean

# Simple plot

bhnu.clean%>%
  abacus.simple(plot.title="My simple plot",
                x.breaks='5 days',
                DT.limts=c("2025-09-26","2025-12-15"))


# Detailed plot, it uses a list so you can easily play around with how many
# individuals to include in any one plot

bhnu.clean%>%
  split(.$mfgID)->bhnu.list

bhnu.list[1:10]%>%
  abacus.detail(plot.title="First 10 plot",
                x.breaks='3 days',
                DT.limts=c("2025-09-26","2025-12-15"))

bhnu.list[11:20]%>%
  abacus.detail(plot.title="Plot 11:20",
                x.breaks='3 days',
                DT.limts=c("2025-09-26","2025-12-15"))
```
