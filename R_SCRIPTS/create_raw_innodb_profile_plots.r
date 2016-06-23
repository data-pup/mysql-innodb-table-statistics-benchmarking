#!/usr/local/bin/Rscript

# Check that the prerequisite libraries exist.
require(graphics)

# Import the estimations table.
fileLocation <- '/path/file.csv'
myInnodbProfile <- as.matrix(read.csv(fileLocation,header=TRUE))

# Declare variables for my graphical parameters and titles
my_xlim <- c(0,50000)
my_ylim <- c(0,50000)
my_xlab <- "Size of table (Number of Rows)"
my_ylab <- "Estimated size of table (Default Parameters)"
my_main <- "Innodb Table Size Estimations Using Default Page Samples"
my_sub <- "(This plot follows the behavior of an estimation process that uses default sampling settings)"

# Configure the x data, and each y column
# Here is the header row for the data file:
# "real_size","default_sample_estimate","sample_10_pages_estimate","sample_100_pages_estimate","sample_1000_pages_estimate"
x <- myInnodbProfile[,1]
y_real <- myInnodbProfile[,1]
y_def <- myInnodbProfile[,2]
y_10 <- myInnodbProfile[,3]
y_100 <- myInnodbProfile[,4]
y_1000 <- myInnodbProfile[,5]

# Open the image file we will export the plot to, and create a new plot.
png("innodb_profile_plot_raw.png", height=640, width=640)
plot.new()

# Configure the plot window
par(cex.main=1.6)
par(cex.sub=1)

# Use a smoothed scatter plot to show our results
smoothScatter(x, y = y_def, # Coordinates to plot go here
    # nbin = 2056,
    nbin = c(1000,30000), # bandwidth,
    colramp = colorRampPalette(c("white", blues9)),
    nrpoints = Inf, ret.selection = FALSE,
    pch = ".", cex = 1, col = "black",
    transformation = function(x) x^5,
    postPlotHook = box,
    xlab = my_xlab, ylab = my_ylab,
    xlim = my_xlim, ylim = my_ylim,
    xaxs = par("xaxs"), yaxs = par("yaxs"),
    main=my_main, sub=my_sub)

# Alternative call that was used to plot the data
#plot(x,y_10,bg='white',fg='black',type='l',xlim=c(0,50000),ylim=c(0,50000),xlab="Size of table (Number of Rows)",ylab="Estimated size of table (Default Parameters)",main="Innodb Table Size Estimation Behavior",sub="Comparing estimated size of table to real size as row count increases")
# Add a line representing the real table size

# Add an abline, to show the real size of the table.
abline(lm(x ~ y_real))

# Export the plot to the file before closing
dev.off()
