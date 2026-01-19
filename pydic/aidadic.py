#! python3
"""
Artificial Intelligence Data Assimilation Dictionary
Created on Wed Jan 14 19:45:25 2026
@author: gibies
https://github.com/Gibies
"""
CURR_PATH=os.path.dirname(os.path.abspath(__file__))
PKGHOME=os.path.dirname(CURR_PATH)
OBSLIB=os.environ.get('OBSLIB',PKGHOME+"/pylib")
sys.path.append(OBSLIB)
OBSDIC=os.environ.get('OBSDIC',PKGHOME+"/pydic")
sys.path.append(OBSDIC)
OBSNML=os.environ.get('OBSNML',PKGHOME+"/nml")
sys.path.append(OBSNML)

"""
aidadic.py
"""

jedi_anemoi_var_mapping = {
    'air_temperature': '2t',
    'eastward_wind': 'u10',
    'northward_wind': 'v10',
    'specific_humidity': 'q'
    'surface_pressure': 'sp',         # Added for Radiance/UFO
    'air_pressure': 'p'               # Added for vertical levels
  }

# 2. CRTM Standard 100-Level Pressure Grid (hPa)
# This represents the pressure at the center of the layers
crtm_standard_levels = [
    0.0050, 0.0161, 0.0384, 0.0769, 0.1370, 0.2244, 0.3454, 0.5064, 0.7140, 0.9753,
    1.2972, 1.6872, 2.1526, 2.7009, 3.3398, 4.0770, 4.9204, 5.8778, 6.9567, 8.1655,
    9.5119, 11.0038, 12.6492, 14.4559, 16.4318, 18.5847, 20.9224, 23.4526, 26.1829, 29.1210,
    32.2744, 35.6505, 39.2566, 43.1001, 47.1882, 51.5278, 56.1260, 60.9895, 66.1253, 71.5398,
    77.2396, 83.2310, 89.5204, 96.1138, 103.0172, 110.2374, 117.7802, 125.6514, 133.8568, 142.4021,
    151.2931, 160.5353, 170.1344, 180.0958, 190.4250, 201.1271, 212.2073, 223.6704, 235.5212, 247.7645,
    260.4047, 273.4462, 286.8932, 300.7496, 315.0191, 329.7052, 344.8113, 360.3404, 376.2952, 392.6784,
    409.4921, 426.7383, 444.4187, 462.5351, 481.0890, 500.0811, 519.5123, 539.3831, 559.6931, 580.4421,
    601.6293, 623.2532, 645.3121, 667.8038, 690.7259, 714.0754, 737.8491, 762.0431, 786.6534, 811.6754,
    837.1041, 862.9340, 889.1593, 915.7741, 942.7719, 970.1462, 997.8900, 1025.9961, 1054.4563, 1083.2625
]

# CRTM Standard 100 Levels for GeoVaLs
#crtm_standard_levels = numpy.linspace(0.005, 1013.25, 100).tolist()

# GraphCast Standard 37 Pressure Levels (hPa)
graphcast_levels = [
    1, 2, 3, 5, 7, 10, 20, 30, 50, 70, 100, 125, 150, 175, 200, 225, 250,
    300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 775, 800, 825, 850,
    875, 900, 925, 950, 975, 1000
]

# Variable Mapping for GraphCast
graphcast_jedi_var_mapping = {
    "air_temperature": "t",
    "specific_humidity": "q",
    "eastward_wind": "u",
    "northward_wind": "v",
    "geopotential": "z",
}

# FourCastNet standard 13 Pressure Levels (hPa)
fourcastnet_levels = [
    50, 100, 150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000
]

# Variable Mapping for FourCastNet (ERA5 naming style)
fourcastnet_jedi_var_mapping = {
    "air_temperature": "t",
    "specific_humidity": "q",
    "eastward_wind": "u",
    "northward_wind": "v",
    "geopotential": "z",
    "surface_pressure": "sp",
}


# Pangu-Weather standard 13 Pressure Levels (hPa)
pangu_levels = [
    50, 100, 150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000
]

# Variable Mapping for Pangu-Weather
# Pangu often outputs variables in a specific order (Z, Q, T, U, V)
pangu_jedi_var_mapping = {
    "air_temperature": "t",
    "specific_humidity": "q",
    "eastward_wind": "u",
    "northward_wind": "v",
    "geopotential": "z",
    "mean_sea_level_pressure": "msl",
}

# Prithvi WxC / MERRA-2 Standard Pressure Levels (hPa)
prithvi_levels = [
    1, 2, 3, 5, 7, 10, 20, 30, 50, 70, 100, 125, 150, 175, 200, 225, 250, 
    300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 775, 800, 825, 850, 
    875, 900, 925, 950, 975, 1000
]

# Variable Mapping for Prithvi WxC (MERRA-2 style)
prithvi_jedi_var_mapping = {
    "air_temperature": "T",
    "specific_humidity": "QV",
    "eastward_wind": "U",
    "northward_wind": "V",
    "geopotential_height": "H",
    "surface_pressure": "PS",
}

# Mithuna standard pressure levels (hPa) - Example configuration
mithuna_levels = [
    10, 20, 30, 50, 70, 100, 150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000
]

# Variable Mapping for Midhuna
mithuna_jedi_var_mapping = {
    "air_temperature": "temp",
    "specific_humidity": "q",
    "eastward_wind": "u",
    "northward_wind": "v",
    "geopotential_height": "gh",
    "surface_pressure": "pres_sfc",
}

# Bharat Forecast System Pressure Levels (hPa)
bharat_levels = [
    # Example high-res levels
    0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 30, 50, 70, 100, 
    150, 200, 250, 300, 400, 500, 600, 700, 850, 925, 1000
]

# Variable Mapping for Bharat Forecast System
bharat_jedi_var_mapping = {
    "air_temperature": "air_temp",
    "specific_humidity": "spfh",
    "eastward_wind": "u_wind",
    "northward_wind": "v_wind",
    "geopotential_height": "geo_ht",
    "surface_pressure": "sfc_pres",
}
