#' Simple abacus plots for detection data
#'
#' Plot each tag one one line, different color/symbol. Set up for nuthatch data
#' only right now, based on tower names/ number
#'
#' @param X data.frame of hits
#' @param plot.title title
#' @param x.breaks Character string of "X days" to set tick marks/gridlines.
#' @param DT.limits min and max dates to plot, as a vector of character strings
#'
#' @returns a plot with each tag on one line, for all unique tags (mfgID field)
#' a different color and symbol for each tower
#' @export
#'
#' @examples
abacus.simple<-function(X,
                        plot.title='Tag detections over time',
                        x.breaks='7 days',
                        DT.limits){

  X%>%
    rename(tower=recvDeployName)%>%
    mutate(tower.lab=str_replace_all(tower,'_'," ")%>%
             str_trim(.,'right')%>%
             str_to_title()%>%
             str_replace(.,'Hwyj','HwyJ'))->plot.tmp



  ggplot(plot.tmp)+
    geom_point(aes(x=DT,
                   y=mfgID,fill=tower.lab,
                   shape=tower.lab),
               size=2)+
    theme_bw()+
    labs(y="Tag ID \n",
         x='\n Date',
         title = plot.title)+
    scale_shape_manual(values=c(22,21,23,24,25,22))+
    paletteer::scale_fill_paletteer_d("ggthemes::colorblind")+
    scale_x_datetime(date_breaks = x.breaks,
                     limits=c(
                       as.POSIXct(paste0(DT.limits[1], '00:00:00',sep=' ')),
                       as.POSIXct(paste0(DT.limits[2], '23:59:59',sep=' '))),
                     date_labels='%b %d',
                     guide=guide_axis(angle=45)
    )+
    guides(color=guide_legend('Tower name'),
           shape=guide_legend('Tower name'),
           fill=guide_legend('Tower name'))+
    theme(
      axis.title=element_text(face='bold',size=12,color='black'),
      axis.text=element_text(color='black'),
      legend.title = element_text(face='bold'),
      plot.title = element_text(hjust=0.5))
}



#' A more detailed abacus plot
#'
#' Simple plot has symbols for different towers overwriting each other. This
#' assumes you will split your data and plot a subset of individuals at a time.
#' It then offsets individual tower detections for the same bird slightly, so
#' detections by multiple towers at approximately the same time are discernible.
#'
#' @param X a list of "hit" data.frames, each element is a different individual.
#' @param plot.title Title
#' @param x.breaks Character string of "X days" to set tick marks/gridlines.
#' @param DT.limits min and max dates to plot, as a vector of character strings
#' @param x.exp x-axis expand() values for making plots pretty
#' @param y.exp y-axis expand() values for making plots pretty
#'
#' @returns
#'  A plot where the individual tower detections are now slightly offset.
#' @export
#'
#' @examples
abacus.detail<-function(X,
                        plot.title='Tag detections over time',
                        x.breaks='7 days',
                        DT.limits,
                        x.exp=c(0,0),
                        y.exp=c(0,0)){

  X%>%
    bind_rows()->plot.tmp

  plot.tmp%>%
    distinct(mfgID)%>%
    mutate(mfgID=as.numeric(mfgID))%>%
    arrange(mfgID)%>%
    mutate(rank.y=row_number()*2,
           mfgID=as.character(mfgID))->mfg.rank



  plot.tmp%>%
    left_join(.,mfg.rank)%>%
    rename(tower=recvDeployName)%>%
    mutate(tower.lab=str_replace_all(tower,'_'," ")%>%
             str_trim(.,'right')%>%
             str_to_title()%>%
             str_replace(.,'Hwyj','HwyJ'))%>%
    mutate(offset=case_when(str_detect(tower,'(?i)pineknot_E')~0.75,
                            str_detect(tower,'(?i)pineknot_W')~0.45,
                            str_detect(tower,'(?i)hwyJ_N')~0.15,
                            str_detect(tower,'(?i)polecat')~-0.15,
                            str_detect(tower,'(?i)Bennet')~-0.45,
                            str_detect(tower,'(?i)hwyj_S')~-0.75),
           new.y=rank.y+offset)->plot.me


  xlines<-seq.POSIXt(
    as.POSIXct(paste0(DT.limits[1], '00:00:00',sep=' ')),
    as.POSIXct(paste0(DT.limits[2], '00:00:00',sep=' ')),x.breaks)

  y.border<-plot.me%>%
    distinct(mfgID,rank.y)%>%
    mutate(yb=rank.y+1)%>%
    pull(yb)

  plot.tag.id<-distinct(plot.me,mfgID)%>%
    pull(mfgID)



  y.filler<-distinct(plot.me,new.y)

  ggplot(plot.me)+
    geom_point(aes(x=DT,
                   y=new.y,
                   fill=tower.lab,
                   shape=tower.lab),
               color='black',
               size=2)+
    theme_classic()+
    labs(y="Tag ID \n",
         x='\n Date',
         title = plot.title)+
    scale_shape_manual(values=c(22,21,23,24,25,22))+
    paletteer::scale_fill_paletteer_d("ggthemes::colorblind")+
    paletteer::scale_color_paletteer_d("ggthemes::colorblind")+
    scale_y_continuous(breaks=seq(min(y.filler),max(y.filler),by=2),
                       labels=plot.tag.id,
                       limits=c(min(y.filler)-1,max(y.filler)+1),
                       expand=y.exp
    )+
    geom_hline(yintercept=y.border,
               alpha=0.5)+
    geom_vline(xintercept=xlines,
               alpha=0.2)+
    scale_x_datetime(breaks = xlines,
                     expand=x.exp,
                     limits=c(
                       as.POSIXct(paste0(DT.limits[1], '00:00:00',sep=' ')),
                       as.POSIXct(paste0(DT.limits[2], '00:00:00',sep=' '))),
                     date_labels='%b %d',
                     guide=guide_axis(angle=45)
    )+
    guides(color=guide_legend('Tower name'),
           shape=guide_legend('Tower name'),
           fill=guide_legend('Tower name'))+
    theme(
      axis.title=element_text(face='bold',size=12,color='black'),
      axis.text=element_text(color='black'),
      legend.title = element_text(face='bold'),
      plot.title = element_text(hjust=0.5))
}
