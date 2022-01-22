# Project Name: Tree-Cover-Loss-Dashboard

# Objective
This project aims to develop an interactive dashboard which shows annual tree cover loss (2001 - 2020) in specific region.

# Data Type
There are two dataset used in this dashboard, one raster data and one polygon vector data. The tree cover loss is a raster which has a spatial resolution of 30 m x 30 m. For more information visit: https://storage.googleapis.com/earthenginepartners-hansen/GFC-2020-v1.8/download.html. While, the region (Dayun) is a vector data comprised of three polygons.

# Methodology
The algorithm will read raster and vector data in UTM format. Firstly, it will crop the raster inside the vector. Then, it will crop the raster based on polygons feature that user needs to define based on which column. Firstly, the algorithm will generate total loss inside polygons. However, user needs to check whether there is no data (no tree loss) from any year and modify the table accordingly.

# Challenges
1. The map will pop-up very slow if the polygons are huge
2. The algorithm still cannot detect a year/years when there is no tree cover loss automatically. If there is no data (or no tree loss) in one or several years, the algorithm will fail producing the dashboard.

# Expected outcomes
User is able to download, generate a map, and visualize a trend of how much tree loss per year for any region

# Benefits
This dashboard will dramatically speed up the process all the way from GIS data processing to layouting. The manual steps in GIS software are; clip/mask the raster within the polygon  -> change raster to polygon -> dissolve area based on year -> add field of total area calculation in Ha -> calculate the area in Ha -> layout the map.

# Recommendation
The reason of using R Shiny is data confidentiality. It might be more practical using a cloud-based platform for spatial analysis such as google earth engine. However, user needs to upload some files required for analysis into the cloud. For a company which has strict IT Policies, such method would not be possible. In R Shiny, all the process done in your own computer and the dashboard is generated in a localhost.

  
