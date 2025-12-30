# Extract hits for resident birds

Extract hits for resident birds

## Usage

``` r
hits.resident(connect, project.id)
```

## Arguments

- connect:

  a database connection returned by read.motus

- project.id:

  a numeric vector, c(), specifying the project ID(s) of towers that you
  wish to include detection. For resident birds, this filters out likely
  spurious detections. If omitted, all hits will be considered valid

## Value

A list of 3 elements, first is a data.frame from "alltags", second is
the "recvDeps" table, and third is the "tagDeps" table , with the .motus
recorded deploy date of the tag and the year it was releseas in a
"cohort" field. The alltags table is automatically filtered to include
detections only on those towers associated with a particular project,
such as towers deployed within a resident bird study. A future version
will take an sf::st_bbox() object and use detections on any tower within
the bounding box

## Examples

``` r
 read.motus('C:/.../proj.motus')->motus.con
#> Error in read.motus("C:/.../proj.motus"): could not find function "read.motus"

 hit.resident(motus.con, c(123))->tmp.list
#> Error in hit.resident(motus.con, c(123)): could not find function "hit.resident"
 # hits only on towers associated with project 123

 hit.resident(motus.con)->tmp.list2
#> Error in hit.resident(motus.con): could not find function "hit.resident"
 # hits from any tower

 my.hits<-tmp.list[[1]] #get the hits table
#> Error: object 'tmp.list' not found
```
