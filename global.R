# ---------------------------------------------------------
# This is the global file.
# Use it to store functions, library calls, source files etc.
# Moving these out of the server file and into here improves performance
# The global file is run only once when the app launches and stays consistent
# across users whereas the server and UI files are constantly interacting and
# responsive to user input.
#
# ---------------------------------------------------------


# Library calls ----------------------------------------------------------------
shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(shiny))
shhh(library(shinyjs))
shhh(library(tools))
shhh(library(testthat))
shhh(library(stringr))
shhh(library(shinydashboard))
shhh(library(shinyWidgets))
shhh(library(shinyGovstyle))
shhh(library(shinytitle))
shhh(library(dplyr))
shhh(library(ggplot2))
shhh(library(DT))
shhh(library(xfun))
shhh(library(metathis))
shhh(library(shinyalert))
shhh(library(shinytest2))
shhh(library(rstudioapi))
shhh(library(bslib))
shhh(library(dfeshiny))
shhh(library(ggiraph))

# Functions --------------------------------------------------------------------

# Here's an example function for simplifying the code needed to commas separate
# numbers:

# This line enables bookmarking such that input choices are shown in the url.
enableBookmarking("url")

# cs_num -----------------------------------------------------------------------
# Comma separating function



cs_num <- function(value) {
  format(value, big.mark = ",", trim = TRUE)
}

# Source scripts ---------------------------------------------------------------

# Source any scripts here. Scripts may be needed to process data before it gets
# to the server file.
# It's best to do this here instead of the server file, to improve performance.


# appLoadingCSS ----------------------------------------------------------------
# Set up loading screen

app_loading_css <- "
#loading-content {
  position: absolute;
  background: #000000;
  opacity: 0.9;
  z-index: 100;
  left: 0;
  right: 0;
  height: 100%;
  text-align: center;
  color: #FFFFFF;
}
"

site_title <- "DfE Shiny Template"
site_primary <- paste0(
  "https://department-for-education.shinyapps.io/",
  "dfe-shiny-template/"
)
site_overflow <- paste0(
  "https://department-for-education.shinyapps.io/",
  "dfe-shiny-template-overflow/"
)
# We can add further mirrors where necessary. Each one can generally handle
# about 2,500 users simultaneously
sites_list <- c(site_primary, site_overflow)
# Update this with your parent
# publication name (e.g. the EES publication)
ees_pub_name <- "Statistical publication"
# Update with parent publication link
ees_publication <- paste0(
  "https://explore-education-statistics.service",
  ".gov.uk/find-statistics/"
)
google_analytics_key <- "Z967JJVQQX"


source("R/read_data.R")

# Read in the data
dfrevbal <- read_revenue_data()
# Get geographical levels from data
dfareas <- dfrevbal %>%
  select(
    geographic_level, country_name, country_code,
    region_name, region_code,
    la_name, old_la_code, new_la_code
  ) %>%
  distinct()

choiceslas <- dfareas %>%
  filter(geographic_level == "Local authority") %>%
  select(geographic_level, area_name = la_name) %>%
  arrange(area_name)

choicesareas <- dfareas %>%
  filter(geographic_level == "National") %>%
  select(geographic_level, area_name = country_name) %>%
  rbind(
    dfareas %>%
      filter(geographic_level == "Regional") %>%
      select(geographic_level, area_name = region_name)
  ) %>%
  rbind(choiceslas)

choicesyears <- unique(dfrevbal$time_period)

choicesphase <- unique(dfrevbal$school_phase)

expandable <- function(input_id, label, contents) {
  govdetails <- shiny::tags$details(
    class = "govuk-details", id = input_id,
    shiny::tags$summary(
      class = "govuk-details__summary",
      shiny::tags$span(
        class = "govuk-details__summary-text",
        label
      )
    ),
    shiny::tags$div(contents)
  )
}
