# A more detailed abacus plot

Simple plot has symbols for different towers overwriting each other.
This assumes you will split your data and plot a subset of individuals
at a time. It then offsets individual tower detections for the same bird
slightly, so detections by multiple towers at approximately the same
time are discernible.

## Usage

``` r
abacus.detail(
  X,
  plot.title = "Tag detections over time",
  x.breaks = "7 days",
  DT.limits,
  x.exp = c(0, 0),
  y.exp = c(0, 0)
)
```

## Arguments

- X:

  a list of "hit" data.frames, each element is a different individual.

- plot.title:

  Title

- x.breaks:

  Character string of "X days" to set tick marks/gridlines.

- DT.limits:

  min and max dates to plot, as a vector of character strings

- x.exp:

  x-axis expand() values for making plots pretty

- y.exp:

  y-axis expand() values for making plots pretty

## Value

A plot where the individual tower detections are now slightly offset.
