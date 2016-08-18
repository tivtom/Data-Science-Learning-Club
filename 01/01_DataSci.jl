using DataArrays, DataFrames # DataFrames is a data table with each column being a DataArray
using RDatasets  # Familiar datasets for R-Users

irisDataFrame = dataset("datasets", "iris")

# Basic Commands
head(irisDataFrame)
tail(irisDataFrame)
describe(irisDataFrame)

# Selecting by column
irisDataFrame[1]
irisDataFrame[1:3]
irisDataFrame[:SepalWidth]

# Selecting by row
irisDataFrame[1,:]
irisDataFrame[1:25,:]

# Selecting by row and column
irisDataFrame[5:10,[:SepalWidth, :PetalWidth]]

# museumItems = readtable("cstmc-CSV-en.csv", separator='|')

f = open("cstmc-CSV-en.csv", "r")
museumItemsRaw = readdlm(f, '|', Any, quotes=false, header = true)

museumItemsDF = DataFrame()
for i in 1:size(museumItemsRaw[1])[2]
  museumItemsDF[symbol(museumItemsRaw[2][i])] = museumItemsRaw[1][:,i]
end
