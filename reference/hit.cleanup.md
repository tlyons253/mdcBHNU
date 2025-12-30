# Filters for Motus hits, or any table of time-stamped telemetry data with similarly named fields

Likely duplicates many internal fiters in the motusFilter field, but
gives some more control. Do not remove fields related to frequency,
signal, noise, burst interval and pulse length prior to this function.

## Usage

``` r
hit.cleanup(
  X,
  freqsd.limit = 0.1,
  SNR.limit = 10,
  pulse.limit = c(2.3, 2.7),
  burst.limit = c(19.5, 20.3),
  min.run = 2,
  max.run = 500
)
```

## Arguments

- X:

  A data.frame of "hits" like "alltags".

- freqsd.limit:

  the max sd of the frequency read during a hit. highly variable
  frequencies detected likely mean a false detection

- SNR.limit:

  The signal to noise ratio threshold. Values above this will be
  considered detection. Engineers generally consider an SNR of 10 to be
  the minimum to say a signal was detected

- pulse.limit:

  a vector of the minimum and maximum pulse length to consider. Pulse
  lengths outside of the tag design likely indicate false detections.

- burst.limit:

  a vector of the min an max burst interval. Values far from the
  expected burst interval may indicate interference or false signals

- min.run:

  minimum run length

- max.run:

  maximum run length. Used to filter tags that may be dropped, but not
  recovered.

## Value

a data frame similar to the input, but with filters added
