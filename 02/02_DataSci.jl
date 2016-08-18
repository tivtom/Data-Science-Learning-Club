#= testing with GadFly plotting
plot(x=1:10, y=2.^rand(10),
     Scale.y_sqrt, Geom.point, Geom.smooth,
     Guide.xlabel("Stimulus"), Guide.ylabel("Response"), Guide.title("Dog Training"))

myplot = plot(x=1:10, y=2.^rand(10),
     Scale.y_sqrt, Geom.point, Geom.smooth,
     Guide.xlabel("Stimulus"), Guide.ylabel("ResponseTest"), Guide.title("Dog Training"))

draw(PNG("myplot.png", 4inch, 3inch), myplot)

using RDatasets

plot(dataset("datasets", "iris"), x="SepalLength", y="SepalWidth", Geom.point)
=#

using Gadfly
using DataFrames

f = open("cstmc-CSV-en.csv", "r")
museumItemsRaw = readdlm(f, '|', Any, quotes=false, header = true)

museumItemsDF = DataFrame()
for i in 1:size(museumItemsRaw[1])[2]
  museumItemsDF[symbol(museumItemsRaw[2][i])] = museumItemsRaw[1][:,i]
end

museumItemsDFCleaned = DataFrame()
cleanCount = 1
for i in 1:size(museumItemsDF)[1]
   count = 0
   rowAsArray = Array(museumItemsDF[i,:])
   for item in rowAsArray
     count += item == ""
   end
   if (count < 25)
     if (length(museumItemsDFCleaned) == 0)
       museumItemsDFCleaned = DataFrame(rowAsArray)
     else
       push!(museumItemsDFCleaned, rowAsArray)
     end
     cleanCount += 1
   end
end

# Histogram on Group1 -> seems to be industry/field
myplot = plot(museumItemsDFCleaned, x=19, Geom.histogram, Guide.xlabel("Industry"), Guide.ylabel("Frequency"), Guide.title("Canadian Museum Items - Frequency of Category"))
draw(PNG("02_DataSci_CNDmuseumhist.png", 4inch, 6inch), myplot)
