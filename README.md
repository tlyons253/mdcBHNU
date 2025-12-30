
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mdcBHNU

<!-- badges: start -->

<!-- badges: end -->

Before you can install this package, you will need to create a github
account. It’s free to do. Let Tim know once you do and he will invite
you as a collaborator. Otherwise you will not be able to install the
package as it is in a non-public repository

## Installation

You can install mdcBHNU from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("tlyons253/mdcBHNU") #or

devtools::install_github('tlyons253/mdcBHNU')
```

## Example wokflow

You might do this to get and plot tag hits. You may need to change the
path to your copy of the .motus file or depending on how it is mapped on
your computer.

``` r
library(mdcBHNU)

open.motus('C:/Location/of/motus/database/project-123.motus')->bhnu.con

hit.resident(bhnu.con, project.id=c(750))->bhnu.list 
# are mike's towers still active? could add their ID's here if it's just ones local to MO.

close.motus(bhnu.con) # close the connection

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
