# Example investigating smoothing splines
# September 20, 2013

# Simulate the Data For Training Sample 1
# Use the beta distribution, with parameters shape1 and shape2
x <-rbeta(100,0.3,0.5)
xs <-sort(x) # Sort the data
f <-sin(xs*10)+cos(xs) 
plot(xs,f) # Generate a test plot comparing sorted xs data with f
y <- f + rnorm(100,0,0.1)

# Generate a graph of the simulated data
png("c:/Users/Nate/Git/riemann/more_splines_training_set.png")
plot(xs,y,"p",
     pch=19,
     lwd=3,
     main="Training Sample 1 Generated From A Beta Distribution",
     xlab = "X Values",
     ylab = "Y values")
lines(xs,sin(xs*10)+cos(xs),"l", lwd=2, col=2) # Fit a line through the proposed plot
dev.off()

# -----------------------------------------------------------------
# Let us generate some base splines
library(splines) # Open the spline library
BS1<-bs(xs,degree=1,knots=c(0,0.25,0.5,0.6)) #Base Spline Degree 1
str(BS1) # Note that str() compactly display the internal structure of an R object

png("c:/Users/Nate/Git/riemann/base_spline_degree_1.png")
plot(xs,BS1[,1],"l", 
     main="Base Spline Degree 1 (Generated From A Beta Distribution)",
     xlab="X Values")
lines(xs,BS1[,2],col=2)
lines(xs,BS1[,3],col=3)
lines(xs,BS1[,4],col=4)
lines(xs,BS1[,5],col=5)
dev.off()

png("c:/Users/Nate/Git/riemann/base_spline_degree_3.png")
BS2<-bs(xs,degree=3,knots=c(0,0.25,0.5,0.6)) #Based Spline Degree 3
str(BS2) # Note that str() compactly display the internal structure of an R object
plot(xs,BS2[,1],"l", main="Base Spline Degree 3 (Generated From A Beta Distribution)")
lines(xs,BS2[,2],col=2)
lines(xs,BS2[,3],col=3)
lines(xs,BS2[,4],col=4)
lines(xs,BS2[,5],col=5)
lines(xs,BS2[,6],col=6)
lines(xs,BS2[,7],col=7)
dev.off()

# -----------------------------------------------------------------
# Let us generate some natural splines
NS1 <- ns(xs,knots=c(0.25,0.5))
str(NS1)

png("c:/Users/Nate/Git/riemann/natural_cubic_spline.png")
plot(xs,NS1[,3],"l", 
     main="Natural Cubic Spline (Generated From A Beta Distribution)",
     xlab="X Values")
lines(xs,NS1[,2],col=2)
lines(xs,NS1[,1],col=3)
dev.off()

# Let us now fit a base spline - Sample 1
BS1fit <- lm(y ~ BS1[,1]+BS1[,2]+BS1[,3]+BS1[,4]+BS1[,5]-1)
BS2fit <- lm(y ~ BS2[,1]+BS2[,2]+BS2[,3]+BS2[,4]+BS2[,5]+BS2[,6]+BS2[,7]-1)
summary(BS1fit)
summary(BS2fit)

# Let us plot the base spline in R
png("c:/Users/Nate/Git/riemann/base_spline_multiple.png")
plot(xs,y,"p",pch=19,lwd=3,ylim=c(-0.6,2.2),
     main="Base Spline (Generated From A Beta Distribution)",
     xlab="X Values")

lines(xs,fitted(BS1fit),col=3,lwd=2)
lines(xs,fitted(BS2fit),col=4,lwd=2)
dev.off()

# Let us now fit a natural cubic spline to the data
NSfit <- lm(y~NS1[,1]+NS1[,2]+NS1[,3]-1)
summary(NSfit)

png("c:/Users/Nate/Git/riemann/natural_cubic_spline_appended.png")
plot(xs,y,"p",pch=19,lwd=3,main="Natural Cubic Spline (Generated From A Beta Distribution)")
lines(xs,sin(xs*10)+cos(xs),"l",lwd=2, col=2)
lines(xs,fitted(NSfit),col=3,lwd=2)
legend("topright", # Place the legend in the top left
       c("True Data", "Natural Cubic"), 
       lwd=c(2.5, 2.5),
       lty=c(1, 1),
       col=c("red", "green"),
       cex=0.75) # This is the standard size for the legend
dev.off()

# Let us consider another choice of the knots for the natural spline
NS2<-ns(xs,knots=c(0.1,0.2,0.6,0.8,0.9))
str(NS2)
NS2fit<-lm(y~NS2[,1]+NS2[,2]+NS2[,3]+NS2[,4]+NS2[,5]+NS2[,6]-1)

png("c:/Users/Nate/Git/riemann/natural_cubic_spline_more_knots.png")
plot(xs,y,"p",pch=19,ylim=c(-0.2,2.5),lwd=3,
     main="Natural Cubic Spline (Generated From A Beta Distribution)",
     xlab="X Values",
     ylab="Y Values")
lines(xs,sin(xs*10)+cos(xs),"l",lwd=2, col=2)
lines(xs,fitted(NS2fit),col=3,lwd=2)
legend("topright", # Place the legend in the top left
       c("True Data", "Natural Cubic"), 
       lwd=c(2.5, 2.5),
       lty=c(1, 1),
       col=c("red", "green"),
       cex=0.75) # This is the standard size for the legend
dev.off()

# -----------------------------------------------------------------
# Let us consider smoothing splines
#help(smooth.spline)
ssfit1<-smooth.spline(xs,y,df=6)
ssfit2<-smooth.spline(xs,y)
ssfit3<-smooth.spline(xs,y,spar=2.6)
ssfit4<-smooth.spline(xs,y,cv=T)
xx<-seq(0,1,0.001)
length(xx)
p1<-predict(ssfit1,xx)
str(p1)

# Generate a plot of the smoothing spline
png("c:/Users/Nate/Git/riemann/smoothing_splines.png")
plot(xs,y,"p",
     pch=19,
     lwd=3,
     main="Smoothing Splines Model (Generated From A Beta Distribution)",
     ylim=c(-1,5),
     xlab="X Values",
     ylab="Y Values")
lines(xx,sin(xx*10)+cos(xx),"l", lwd=2, col=2)
lines(predict(ssfit1,xx),col=3,lwd=2)
lines(predict(ssfit2,xx),col=4, lwd=2)
lines(predict(ssfit3,xx),col=5,lwd=2)
lines(predict(ssfit4,xx),col=6,lwd=2)
legend("topright", # Place the legend in the top left
       c("True Data", 
         "df=6",
         "default",
         "spar=2.6",
         "cv"), 
       lwd=c(2.5, 2.5, 2.5, 2.5, 2.5, 2.5),
       lty=c(1, 1, 1, 1, 1, 1, 1),
       col=c(2:6),
       cex=0.75) # This is the standard size for the legend
dev.off()

# Finally, let us now consider the bias of a smoothing spline
str(predict(ssfit1))
bias1 <- (sin(xs*10)+cos(xs)-predict(ssfit1)$y)^2
bias2 <- (sin(xs*10)+cos(xs)-predict(ssfit3)$y)^2

png("c:/Users/Nate/Git/riemann/smoothing_splines_bias.png")
plot(xs,bias2,"l",
     main="Plot Demonstrating Bias Of A Smoothing Spline",
     ylab="Bias",xlab="X Values",
     lwd=2,
     col=3)
lines(xs,bias1,col=2,lwd=2)
legend("topright", # Place the legend in the top left
       c("df=6",
         "spar=2.6"), 
       lwd=c(2.5, 2.5),
       lty=c(1, 1),
       col=c(2:3),
       cex=0.75) # This is the standard size for the legend
dev.off()