
#' Filters for Motus hits, or any table of time-stamped telemetry data with
#' similarly named fields
#'
#' Likely duplicates many internal fiters in the motusFilter field, but gives
#' some more control. Do not remove fields related to frequency, signal, noise,
#' burst interval and pulse length prior to this function.
#'
#' @param X A data.frame of "hits" like "alltags".
#' @param freqsd.limit the max sd of the frequency read during a hit. highly
#'   variable frequencies detected likely mean a false detection
#' @param SNR.limit The signal to noise ratio threshold. Values above this will
#'   be considered detection. Engineers generally consider an SNR of 10 to be
#'   the minimum to say a signal was detected
#' @param pulse.limit a vector of the minimum and maximum pulse length to
#'   consider. Pulse lengths outside of the tag design likely indicate false
#'   detections.
#' @param burst.limit a vector of the min an max burst interval. Values far from
#'   the expected burst interval may indicate interference or false signals
#' @param min.run minimum run length
#' @param max.run maximum run length. Used to filter tags that may be dropped, but not recovered.
#'
#' @returns a data frame similar to the input, but with filters added
#' @export
#'
#' @examples
hit.cleanup<-function(X,
                      freqsd.limit=0.1,
                      SNR.limit=10,
                      pulse.limit=c(2.3,2.7),
                      burst.limit=c(19.5,20.3),
                      min.run=2,
                      max.run=500
){

  mutate(X, SNR=sig-noise)%>%
    filter(freqsd< freqsd.limit,
           SNR>SNR.limit,
           between(pulseLen,pulse.limit[1],pulse.limit[2]),
           between(tagBI,burst.limit[1],burst.limit[2]),
           runLen>min.run,
           runLen< max.run #should be any day with this long?
    )%>%
    mutate(DT=as.POSIXct(tsCorrected))%>%
    select(mfgID,hitID,DT,recvDeployName,sig,sigsd,noise,freq,freqsd,runLen,
           SNR,motusTagID,r.date,cohort)%>%
    arrange(DT)%>%
    mutate(CDST=format(DT,tz='America/Chicago'),
           C.Date=as.Date(CDST))
}

