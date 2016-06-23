library(ggplot2)
my_data <- read.csv("my_estimation_difference_table.txt")
qplot(real_size, est_default_difference, data = my_data, alpha = I(1/50), geom=c("point","smooth"), main="InnoDB Size Estimation Error: Default Page Sampling", xlab="Size of table",ylab="Error amount")
qplot(real_size, est_10pg_difference, data = my_data, alpha = I(1/50), geom=c("point","smooth"), main="InnoDB Size Estimation Error: 10 Page Samples", xlab="Size of table",ylab="Error amount")
qplot(real_size, est_100pg_difference, data = my_data, alpha = I(1/50), geom=c("point","smooth"), main="InnoDB Size Estimation Error: 100 Page Samples", xlab="Size of table",ylab="Error amount")
qplot(real_size, est_1000pg_difference, data = my_data, alpha = I(1/50), geom=c("point","smooth"), main="InnoDB Size Estimation Error: 1000 Page Samples", xlab="Size of table",ylab="Error amount")

qplot(data = my_data, real_size, log(abs(est_default_difference)), alpha = I(1/50), geom=c("point","smooth"), main="InnoDB Size Estimation Error: Default Page Sampling", xlab="Size of table",ylab="Error amount",colour=I("blue"))
qplot(data = my_data, real_size, log(abs(est_10pg_difference)), alpha = I(1/50), geom=c("point","smooth"), main="InnoDB Size Estimation Error: 10 Page Samples", xlab="Size of table",ylab="Error amount",colour=I("blue"))
qplot(data = my_data, real_size, log(abs(est_100pg_difference)), alpha = I(1/50), geom=c("point","smooth"), main="InnoDB Size Estimation Error: 100 Page Samples", xlab="Size of table",ylab="Error amount",colour=I("blue"))
