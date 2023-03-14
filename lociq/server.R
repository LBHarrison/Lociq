# Define server logic for random distribution app ----
server <- function(input, output) {
  library(genoPlotR)

  output$plot <- renderPlot({
  
  geno.seg <- df.annotation[which(df.annotation$plasmid == input$dataset),]
  geno.seg1 <- dna_seg(geno.seg)
  geno.segs <- list(geno.seg1)
  text.skew <- rep(0, dim(geno.seg)[1])
  text.skew[which(geno.seg$variant != "fragment")] <- 90
  annot1 <- annotation(x1 = middle(geno.segs[[1]]), text = geno.segs[[1]]$name, rot = text.skew)
  
  geno.aseg <- df.annotation[which(df.annotation$plasmid == input$dataset1),]
  geno.aseg1 <- dna_seg(geno.aseg)
  geno.asegs <- list(geno.aseg1)
  text.askew <- rep(0, dim(geno.aseg)[1])
  text.askew[which(geno.aseg$variant != "fragment")] <- 90
  annot1a <- annotation(x1 = middle(geno.asegs[[1]]), text = geno.asegs[[1]]$name, rot = text.askew)
  
  geno.csegs <- list(geno.seg1, geno.aseg1)
  annot1c <- list(annot1, annot1a)
  names(geno.csegs) <- c(input$dataset, input$dataset1)
  plot_gene_map(geno.csegs, annotations = annot1c, annotation_height = 2, main = " ", gene_type = "side_blocks")
  
  
    
  })

  # Generate a summary of the data ----
  output$summary <- renderDataTable({
    cumulative.plasmid[which(cumulative.plasmid[,9] == input$dataset, arr.ind = TRUE),]
  })
  output$summary2 <- renderDataTable({
    cumulative.plasmid[which(cumulative.plasmid[,9] == input$dataset1, arr.ind = TRUE),]
  })

  output$table <- renderDataTable({
    cumulative.AMR[which(cumulative.AMR[,1] == input$dataset, arr.ind = TRUE),]
  })
  output$table2 <- renderDataTable({
    cumulative.AMR[which(cumulative.AMR[,1] == input$dataset1, arr.ind = TRUE),]
  })
  output$tableAMR <- renderDataTable({
    cumulative.AMR[-1,]
  })

}