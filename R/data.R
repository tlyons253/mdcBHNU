#' A  wrapper to connect to a motus database
#'
#' @param path
#' The full path to where the .motus RSQlite database is located
#' @returns
#' A database connection
#' @export
#'
#' @examples
open_motus<-function(path){
  DBI::dbConnect(RSQLite::SQLite(),
                 path)->con

  return(con)

  message("Don't forget to close the database connection when you are done")

}



#' Extract hits for resident birds
#'
#' @param connect a database connection returned by read.motus
#' @param project.id a numeric vector, c(), specifying the project ID(s) of
#'   towers that you wish to include detection. For resident birds, this filters
#'   out likely spurious detections. If omitted, all hits will be considered
#'   valid
#'
#' @returns A list of 3 elements, first is a data.frame from "alltags", second
#'   is the "recvDeps" table, and third is the "tagDeps" table , with the .motus
#'   recorded deploy date of the tag and the year it was releseas in a "cohort"
#'   field. The alltags table is automatically filtered to include detections
#'   only on those towers associated with a particular project, such as towers
#'   deployed within a resident bird study. A future version will take an
#'   sf::st_bbox() object and use detections on any tower within the bounding
#'   box
#' @export
#'
#' @examples
#'  read.motus('C:/.../proj.motus')->motus.con
#'
#'  hit.resident(motus.con, c(123))->tmp.list
#'  # hits only on towers associated with project 123
#'
#'  hit.resident(motus.con)->tmp.list2
#'  # hits from any tower
#'
#'  my.hits<-tmp.list[[1]] #get the hits table

hits.resident<-function(connect,project.id){

  tbl(connect,'alltags')%>%collect()->hits.tmp

  if(missing(project.id)){
    tbl(connect,'recvDeps')%>%
      collect()->deploy.dat}

  tbl(connect,'recvDeps')%>%
    filter(projectID %in% project.id)%>%
    collect()->deploy.dat

  tbl(connect,'tagDeps')%>%
    collect()->tagrelease


 #------------------------------
  deploy.dat%>%pull(deployID)->tower.id


  #---------------------------------------------

  tagrelease%>%
    mutate(r.date=as.Date(as.POSIXct(tsStart)),
           cohort=year(r.date))%>%
    select(tagID,r.date,cohort)->tag.dat



  filter(hits.tmp,
         recvDeployID %in% tower.id)%>%
    left_join(tag.dat,by=c('motusTagID'='tagID'))%>%
    select(hitID:burstSlop,motusTagID,ambigID,port,runLen:mfgID,
           tagLifespan:speciesID,recvDeployID,recvDeployName,r.date,
           cohort)->local.hits



  out<-list(local.hits,deploy.dat,tag.dat)

  return(out)

}



#' Close motus database connection
#'
#' @param my.conn
#' The connection object returned by open.motus.
#' @returns closes the database connection
#' @export
#'
#' @examples
close_motus<-function(my.conn){
  DBI::dbDisconnect(conn=my.conn)

}




