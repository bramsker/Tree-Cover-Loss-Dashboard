# Tree-Cover-Loss-Dashboard

A script for creating a dashboard from raster and vector data

This project aims to develop a dashboard which shows Hansen's tree cover loss data from 2001 to 2020 inside a specific region. The tree cover loss is a raster which has a spatial resolution of 30 m x 30 m (visit: https://storage.googleapis.com/earthenginepartners-hansen/GFC-2020-v1.8/download.html). While, the region (Dayun) is a vector data comprised of polygons. The vector is divided arbitrary into some polygons (zone 1, zone 2, zone 3) just for the purpose of this project.

The dashboard will generate total loss inside specific region per year for each region. User can also view the map for each zone, see the trend, and download the raw data. The script will dramatically decrease time consumption compare to manual work using GIS software. 

It might be more practical using a cloud-based platform for spatial analysis such as google earth engine. However, user needs to upload the file into the cloud. For the company which has strict IT Policies, such method would be not possible.

Not to mention that R is a complete packaged software which can handle tabular and spatial data analysis. But also, it provides a customary dashboard R shiny (which feels like using a browser) in a localhost. 
