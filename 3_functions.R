## @knitr func2
library(ggplot2)
library(plyr)


# filtering functions

summary_stats <- function(data.set) {
    ddply(data.set, c("Probeset.ID", "gene", "time", "type"), 
          summarise, 
          mean_expression = mean(expression), 
          sd = sd(expression), 
          n = length(expression), 
          se = sd/sqrt(n))
}

perform_t_test <- function(data.set) {
    ddply(data.set, c("Probeset.ID", "gene"),
          summarise,
          pvalue = t.test(expression ~ time)$p.value)
}

# table function
make_t_table <- function(data.set) {
    # drop contig names
    data.set$Probeset.ID <- NULL
    # remove rrnL
    data.set <- subset(data.set, gene != "rrnL")
    # sort by gene name
    data.set <- data.set[order(data.set$gene),]
    return(data.set)
}


# graph functions for microarray analysis

BaseBarGraph <- function(data.set) {
    ggplot(data.set, 
           aes(x=gene, fill=gene)) + 
        geom_bar() + 
        theme_bw() +
        guides(fill=FALSE) + 
        theme(panel.grid.major.x=element_blank(), 
              panel.grid.minor.x=element_blank(), 
              axis.title.x=element_blank(), 
              plot.title=element_text(face = "bold"))
}

BaseLineGraph <- function(data.set) {
    ggplot(data.set, aes(x=time, 
                              y=mean_expression, 
                              color = gene, 
                              group=Probeset.ID))  + 
        geom_line() + 
        theme_bw() + 
        theme(axis.title.x=element_blank(), 
              plot.title=element_text(face = "bold"))
}