# Project Name: Tree-Cover-Loss-Dashboard

# Objective
This project aims to develop an interactive dashboard which shows annual tree cover loss (2001 - 2020) in specific region.

# Data Type
There are two dataset used in this dashboard, one raster data and one vector polygon data. The tree cover loss is a raster which has a spatial resolution of 30 m x 30 m. For more information visit: https://storage.googleapis.com/earthenginepartners-hansen/GFC-2020-v1.8/download.html. While, the region (Dayun) is a vector data comprised of three polygons.

# Methodology
The backend algorithm is written from line 69 to 144. Firstly, the algorithm will read raster and vector data in UTM format. It will crop the raster inside vector polygon (line 69). Then, it will crop the raster based on individual feature inside that vector. All features are stored in the R list data format and user has to define which column that will be used for list naming. To compile all of the raster, the cropped raster from first step is added into the list (line 94). The algorithm will transform all rasters (inside the list) into spatial pixel data frame calculating pixel area and map plotting inside each polygon. User needs to check whether there is no data (no tree loss) from the generated table and modify the table accordingly (line 128). If there is no missing value, which means tree cover loss exists every year, then user can skip this step. 

The other lines of script are for creating user interface and map plotting purpose.

# Challenges
1. The map will pop-up very slow if the polygons are huge
2. The algorithm still cannot detect a year/years when there is no tree cover loss automatically. If there is no data (or no tree loss) in one or several years, the algorithm will fail producing the dashboard.

# Expected outcomes
User is able to download, generate a map, and visualize a trend of how much tree loss per year for any region

# Benefits
This dashboard will dramatically speed up the process all the way from GIS data processing to layouting. The GIS steps covered by this script are; clip/mask the raster within the polygon (clipping) -> change raster to polygon (raster to polygon) -> dissolve area based on year (dissolved) -> add field of total area calculation in Ha (add field) -> calculate the area in Ha (calculate geometry) -> layout the map.

# Recommendation
The reason of using R Shiny is because of data confidentiality. It might be more practical using a cloud-based platform such as google earth engine. Google earth engine is able to handle front-end and backend processes for spatial data analysis, however, user needs to upload files required for analysis into the cloud. For a company which has strict IT Policies, such method would not be possible. In R Shiny, all the process done in your own computer and the dashboard is generated in a localhost.

  
