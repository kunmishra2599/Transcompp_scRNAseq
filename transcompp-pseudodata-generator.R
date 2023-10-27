# Code to generate pseudodata for Transcompp | Written by Kunal Mishra | Last Updated: 05-10-21 #####

# Setting working directory and loading in packages. Note, xlsx needs rJava ######
setwd(
  "~/Desktop/OneDrive - National University of Singapore/Duke-NUS/Rotation/Rotation 1 - Lisa TK/Transcompp_for_scRNAseq/"
)

library(data.table)
library(dplyr)
library(xlsx)

pseudodata_gen <-
  function(numCells = 10000,
           initialProportions = c(0.2, 0.8),
           transitionRates = list("A" = c(0.2, 0.8), "B" = c(0.4, 0.6)),
           numSamples = 500,
           timepoints = 5,
           numStates = 2,
           classificationError = 0.05) {
    output <- list()
    
    # Setting file name ######
    file_name <-
      paste0(
        "pseudodata_",
        numCells,
        "cells_",
        timepoints,
        "timepoints_",
        numStates,
        "states.xlsx"
      )
    
    for (timepoint in 1:timepoints) {
      message(paste0("Generating data for timepoint ", timepoint, "..."))
      
      # Creating starting data set based on initial proportions #######
      if (timepoint < 2) {
        timepoint_out <-
          sample(
            x = names(transitionRates),
            size = numCells,
            prob = initialProportions,
            replace = T
          )
        
        # Create sheet and sample select number of cells from whole dataset ##########
        sampled <- sample(
          x = timepoint_out,
          size = numSamples,
          replace = F
        )
        print(table(sampled))
        tryCatch(expr = {
          write.xlsx(
            data.table(
              "Experiment" = sampled
            ),
            file = file_name,
            sheetName = toString(timepoint - 1),
            append = T,
            col.names = T,
            row.names = F
          )
        }, error = {
          unlink(file_name)
        })
        message("Writing to file...")
        output[[toString(timepoint - 1)]] <- timepoint_out
      } else {
        
        # Creating subsequent data sets based on previous timepoints #######
        timepoint_out <- c()
        for (cell in output[[toString(timepoint - 2)]]) {
          # Generate random probability for classification error ########
          cell_prob <- runif(1) 

          if (cell_prob > classificationError) {
            # obtain transition rate vector for each cell type, use as weights to sample from vector of cell states (simulate transition rate)
            timepoint_out <- c(
              timepoint_out,
              sample(
                names(transitionRates),
                size = 1,
                prob = transitionRates[[cell]] 
              )
            )
          } else {
            # To create classification error, randomly assign a cell state #######
            timepoint_out <- c(
              timepoint_out,
              sample(names(transitionRates),
                size = 1,
              )
            )
          }
        }
        message("Writing to file...")
        
        # Create sheet and sample select number of cells from whole dataset ##########
        sampled <- sample(
          x = timepoint_out,
          size = numSamples,
          replace = F
        )
        print(table(sampled))
        write.xlsx(
          data.table(
            "Experiment" = sampled
          ),
          file = file_name,
          sheetName = toString(timepoint - 1),
          append = T,
          col.names = T,
          row.names = F
        )
        output[[toString(timepoint - 1)]] <- timepoint_out
      }
      message("Done")
      message(" ")
    }
    message(paste0("Data saved to ", file_name))
    return(output)
  }

testProportions <- c(0.3, 0.4, 0.3)
testTransitionRates <-
  list(
    "A" = c(0.7, 0.1, 0.2),
    "B" = c(0.6, 0.1, 0.3),
    "C" = c(0.7, 0.2, 0.1)
  )

cell_list <-
  pseudodata_gen(
    numCells = 20000,
    initialProportions = testProportions,
    transitionRates = testTransitionRates,
    timepoints = 5,
    numSamples = 5000,
    numStates = 3,
    classificationError = 0.1
  )

for (tp in names(cell_list)) {
  print(table(cell_list[[tp]]))
}
