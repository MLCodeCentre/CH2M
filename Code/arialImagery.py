import georasters as gr

# Load data
raster = './data/slope.tif'
data = gr.from_file(raster)

# Plot data
data.plot()

# Get some stats
data.mean()
data.sum()
data.std()

# Convert to Pandas DataFrame
df = data.to_pandas()

# Save transformed data to GeoTiff
data2 = data**2
data2.to_tiff('./data2')

# Algebra with rasters
data3 = np.sin(data.raster) / data2
data3.plot()

# Notice that by using the data.raster object,
# you can do any mathematical operation that handles
# Numpy Masked Arrays

# Find value at point (x,y) or at vectors (X,Y)
value = data.map_pixel(x,y)
Value = data.map_pixel(X,Y)