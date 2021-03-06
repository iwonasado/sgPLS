\name{tuning.sPLS.X}
\alias{tuning.sPLS.X}
\alias{tuning.sPLS.X}

\title{Choice of the tuning parameter (number of variables) related to  predictor matrix for sPLS model (regression mode)}

\description{
For a grid of tuning parameter, this function computes by leave-one-out or M-fold cross-validation the MSEP (Mean Square Error of Prediction) of a sPLS model. }

\usage{
tuning.sPLS.X(X, Y, folds = 10, validation = c("Mfold", "loo"), ncomp,
		keepX = NULL, grid.X, setseed, progressBar = FALSE)
}

\arguments{
\item{X}{Numeric matrix or data frame \eqn{(n \times p)}, the observations on the \eqn{X} variables.}
\item{Y}{Numeric matrix or data frame \eqn{(n \times q)}, the observations on the \eqn{Y} variables.}
\item{folds}{Positive integer. Number of folds to use if \code{validation="Mfold"}. Defaults to
\code{folds=10}.}
\item{validation}{Character string. What kind of (internal) cross-validation method to use, (partially) matching one of \code{"Mfolds"} (M-folds) or \code{"loo"} (leave-one-out).}
\item{ncomp}{Number of component for investigating the choice of the tuning parameter.}
\item{keepX}{Vector of integer indicating the number of variables to keep in each component. See Details for more information.}
\item{grid.X}{Vector of integers defining the values of the tuning parameter (corresponding to the number of variables to select) at which cross-validation score should be computed. }
\item{setseed}{Integer indicating the random number generation state.}	
\item{progressBar}{By default set to \code{FALSE} to output the progress bar of the computation.}	

}

\details{
If \code{validation="Mfolds"}, M-fold cross-validation is performed by calling 
\code{Mfold}. The folds are generated. The number of cross-validation 
folds is specified with the argument \code{folds}. 

If \code{validation="loo"}, 
leave-one-out cross-validation is performed by calling the 
\code{loo} function. In this case the arguments \code{folds} are ignored.

if \code{keepX} is specified (by default is NULL), each element of \code{keepX} indicates the value of the tuning parameter for the corresponding component. Only the choice of the tuning parameters corresponding to the remaining components are investigating by evaluating the cross-validation score at different values defining by \code{grid.X}.

}

\value{
The returned value is a list with components: 
  \item{MSEP}{Vector containing the cross-validation score computed on the grid}
  \item{keepX}{Value of the tuning parameter on which
    the cross-validation method reached it minimum.}
}

\author{Benoit Liquet and Pierre Lafaye de Micheaux}


\examples{
\dontrun{	
## Simulation of Datasets X (with group variables) and Y a multivariate response variable 
n <- 200
sigma.e <- 0.5
p <- 400
q <- 10
theta.x1 <- c(rep(1, 15), rep(0, 5), rep(-1, 15), rep(0, 5), rep(1.5, 15),
			rep(0, 5), rep(-1.5, 15), rep(0, 325))
theta.x2 <- c(rep(0, 320), rep(1, 15), rep(0, 5), rep(-1, 15), rep(0, 5),
			rep(1.5, 15), rep(0, 5), rep(-1.5, 15), rep(0, 5))

set.seed(125)
theta.y1 <- runif(10, 0.5, 2)
theta.y2 <- runif(10, 0.5, 2)
  
temp <-  matrix(c(theta.y1, theta.y2), nrow = 2, byrow = TRUE)

Sigmax <- matrix(0, nrow = p, ncol = p)
diag(Sigmax) <- sigma.e ^ 2
Sigmay <- matrix(0, nrow = q, ncol = q)
diag(Sigmay) <- sigma.e ^ 2

gam1 <- rnorm(n)
gam2 <- rnorm(n)

X <- matrix(c(gam1, gam2), ncol = 2, byrow = FALSE) \%*\% matrix(c(theta.x1, theta.x2),
     nrow = 2, byrow = TRUE) + rmvnorm(n, mean = rep(0, p), sigma =
     Sigmax, method = "svd")
Y <- matrix(c(gam1, gam2), ncol = 2, byrow = FALSE) \%*\% t(svd(temp)$v)
     + rmvnorm(n, mean = rep(0, q), sigma = Sigmay, method = "svd")


grid.X <- c(20, 30, 40, 50, 60, 70, 80, 90, 100, 120, 150, 200, 250, 300)

## Strategy with same value for both components
tun.sPLS <- tuning.sPLS.X(X, Y, folds = 10, validation = c("Mfold", "loo"), 
		ncomp = 2, keepX = NULL, grid.X = grid.X, setseed = 1)
tun.sPLS$keepX # for each component

##For a sequential strategy
tun.sPLS.1 <- tuning.sPLS.X(X, Y, folds = 10, validation = c("Mfold", "loo"), 
		ncomp = 1, keepX = NULL, grid.X = grid.X, setseed = 1)

tun.sPLS.1$keepX # for the first component

tun.sPLS.2 <- tuning.sPLS.X(X, Y, folds = 10, validation = c("Mfold", "loo"),
		 ncomp = 2, keepX = tun.sPLS.1$keepX , grid.X = grid.X, setseed = 1)
tun.sPLS.2$keepX # for the second component

}
}

