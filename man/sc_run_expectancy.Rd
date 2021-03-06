% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sc_run_expectancy.R
\name{sc_run_expectancy}
\alias{sc_run_expectancy}
\title{Generate run expectancy and related measures and variables from Baseball Savant data}
\usage{
sc_run_expectancy(df, level)
}
\arguments{
\item{df}{A data frame generated from Baseball Savant.}

\item{level}{Whether you want run expectancy calculated at the plate appearance or pitch level. Defaults to plate appearance.}
}
\description{
These functions allow a user to generate run expectancy and related measures and variables from Baseball Savant data.
Measures and variables will be added to the data frame and a run expectancy table will be assigned to the Global Environment.
}
\examples{
\dontrun{sc_run_expectancy(df, level = "PA")}
}
