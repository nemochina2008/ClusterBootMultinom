% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/multi_plot_ors.R
\name{multi.plot.ors}
\alias{multi.plot.ors}
\title{Calculate and plot odds ratios, 95% CIs and Wald p-values for bootstrapped multinomial
models}
\usage{
multi.plot.ors(coef.list, label.data = NULL, remove.vars = NULL,
  round.vars = NULL, round.digits = NULL, out.strings.list,
  delete.row = "none", yval.offset = 0.25)
}
\arguments{
\item{coef.list}{List of matrices including coefficients from bootstrapped
models (columns = coefficients).}

\item{label.data}{If desired, data frame with two columns, variable and var.label,
containing variable names and strings to use in plot labels, respectively. Default is NULL.}

\item{remove.vars}{Character vector of variable names to **not** include in calculations/plots.
Defaults to NULL (show all variables). Passed to \code{get.or.results}.}

\item{round.vars}{Character vector of variable names whose results should be rounded to something
other than two decimal places. Useful for variables with very small changes in odds for one-unit
change in variable. Defaults to NULL. Passed to \code{get.or.results}.}

\item{round.digits}{Integer; number of digits to round [round.vars] to.
Passed to \code{get.or.results}.}

\item{out.strings.list}{List of character vectors to label outcome comparisons.}

\item{delete.row}{Row to delete from plots and calculations. Used in situations where
models are run twice with different reference levels; in this case, one comparison is
redundant (eg, 'B vs. A' is reciprocal of 'A vs. B').}

\item{yval.offset}{Numeric; amount to offset lines for each outcome level in final plot.}
}
\value{
List of 1) \code{or.data}, a data frame containing odds ratios, confidence
  limits, p-values and accompanying information; 2) \code{or.plot}, a ggplot2 object
  which plots ORs and CIs for all variables and outcome comparisons included, adding
  p-values to axis labels.
}
\description{
From a matrix of bootstrapped coefficients, calculate and plot odds ratios, 95% CIs,
and Wald p-values for all coefficients, then plot.
}
\examples{
df <- data.frame(id = sample(1:20, size = 100, replace = TRUE),
                 x1 = rnorm(n = 100),
                 x2 = rbinom(p = 0.75, n = 100, size = 1),
                 y = sample(LETTERS[1:3], size = 100, replace = TRUE))
df <- df[order(df$id),]
df$time <- unlist(lapply(1:length(unique(df$id)),
                         FUN = function(idnum){ 1:nrow(df[df$id == unique(df$id)[idnum],]) }))

## Using create.sampdata(), generate list of cluster bootstrapped data sets
bootdata.list <- create.sampdata(org.data = df,
                                 id.var = 'id',
                                 n.sets = 25)

## Fit model to original and bootstrapped data frame,
##   saving errors and warnings to .txt file
boot.fits.a <- multi.bootstrap(org.data = df,
                               data.sets = bootdata.list,
                               ref.outcome = grep('A', levels(df$y)),
                               multi.form = as.formula('y ~ x1 + x2'))

## Create matrices of coefficients for all bootstrap fits
boot.matrix.a <- do.call(rbind,
                         lapply(boot.fits.a$boot.models,
                                FUN = function(x){ x@coefficients }))

## Calculate and plot odds ratios and CIs, Wald p-values for x2
covariate.ors <- multi.plot.ors(coef.list = list(boot.matrix.a),
                                out.strings = list(c('B vs A', 'C vs A')),
                                remove.vars = 'x1')
}
\seealso{
ggplot2.
}

