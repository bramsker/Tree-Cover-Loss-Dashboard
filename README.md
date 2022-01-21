# Project Name: Tree-Cover-Loss-Dashboard

# Objective
This project aims to develop an interactive dashboard which shows annual tree cover loss (2001 - 2020) inside specific region

# Data Type
There are two dataset used in this dashboard, one raster data and one polygon vector data. The tree cover loss is a raster which has a spatial resolution of 30 m x 30 m. For more information visit: https://storage.googleapis.com/earthenginepartners-hansen/GFC-2020-v1.8/download.html. While, the region (Dayun) is a vector data comprised of three polygons.

# Methodology
The algorithm will read raster and vector data. generate total loss inside specific region and display it in an interactive dashboard. User is able choose the map for every zone, see the trend, and download the raw data. The script will dramatically decrease time consumption and provide flexible overview compare to manual work using GIS software.  

# Challenges
1. The map pop-up very slow
2. The algorithm cannot detect a year/years when there is no tree cover loss automatically

# Expected outcomes
User is able to download, generate a map, and visualize a trend of how much tree loss per year for any region

# Benefits
This dashboard will dramatically speed up the process all the way from GIS data processing to layouting. If this script is done by using GIS manually, user needs to clip/mask the raster within the polygon  -> change raster to polygon -> dissolve area based on year -> add field of total area calculation in Ha -> calculate the area in Ha -> layout the map.

# Recommendation
The reason of using R Shiny is data confidentiality. It might be more practical using a cloud-based platform for spatial analysis such as google earth engine. However, user needs to upload some files required for analysis into the cloud. For a company which has strict IT Policies, such method would not be possible. Not to mention that R is a complete packaged software which can handle tabular and spatial data analysis. But also, it provides a customary dashboard R shiny (which feels like using a browser) in a localhost. 
