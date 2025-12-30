# Simple abacus plots for detection data

Plot each tag one one line, different color/symbol. Set up for nuthatch
data only right now, based on tower names/ number

## Usage

``` r
abacus.simple(
  X,
  plot.title = "Tag detections over time",
  x.breaks = "7 days",
  DT.limits
)
```

## Arguments

- X:

  data.frame of hits

- plot.title:

  title

- x.breaks:

  Character string of "X days" to set tick marks/gridlines.

- DT.limits:

  min and max dates to plot, as a vector of character strings

## Value

a plot with each tag on one line, for all unique tags (mfgID field) a
different color and symbol for each tower
