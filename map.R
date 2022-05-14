library(plotly)
map <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv")
# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)

# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)
# plot map
fig <- plot_geo(map)

# merge with cluster output
library(dplyr)
cluster_output <- read.csv("data/cluster_output.csv")
cluster_output <- inner_join(cluster_output, covid_no_ts_all[c("location","iso_code")], by='location')
map <- left_join(map, cluster_output,by = c('CODE'='iso_code'))
map$cluster[is.na(map$cluster)] <- 0

fig2 <- fig %>% add_trace(
  z = ~GDP..BILLIONS.,
  color = ~GDP..BILLIONS., 
  colors = 'Blues',
  text = ~COUNTRY, 
  locations = ~CODE, 
  marker = list(line = l)
)

fig <- fig2 %>% 
  colorbar(title = 'GDP Billions US$', 
           tickprefix = '$')
fig <- fig2 %>% 
  layout(
  title = '2014 Global GDP<br>Source:<a href="https://www.cia.gov/library/publications/the-world-factbook/fields/2195.html">CIA World Factbook</a>',
  geo = g
)

fig
