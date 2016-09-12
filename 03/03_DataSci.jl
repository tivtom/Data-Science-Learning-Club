module DataSciClubThree

using DataFrames, Gadfly

### Read in data
WorkFlow = readtable("03\\Thomas-WorkFlow.csv")

### Map dates to DateTime type
WorkFlow[:DateTime] = map((w,x,y) ->
                  DateTime(string(x,w," ",y), "yyyyu-dd HH:MM"),
                  WorkFlow[:Date],
                  WorkFlow[:Year],
                  WorkFlow[:StartTime])

#### Clean-up columns
delete!(WorkFlow, [:Date, :Year, :Month, :Week, :StartTime, :EndTime, :x])

### Work Item Analysis
function WorkItemAnalysis(data::DataFrame)
  WorkItemsDF = DataFrame()
  Count = Int32[]
  TotalDuration = Float64[]
  MedianDuration = Float64[]
  MaxDuration = Float64[]
  AvgStartHour = Float64[]

  WorkItemsDF[:Item] = collect(Set(data[:Type]))

  for item in WorkItemsDF[:Item]
      itemDF = data[data[:,:Type].== item, :]
      push!(Count, size(itemDF)[1])
      push!(TotalDuration, sum(itemDF[:Duration]) )
      push!(MedianDuration, median(itemDF[:Duration]) )
      push!(MaxDuration, maximum(itemDF[:Duration]) )
      push!(AvgStartHour, mean(map((x)-> Dates.hour(x), itemDF[:DateTime])) )
  end
  WorkItemsDF[:Count] = Count
  WorkItemsDF[:TotaDur] = TotalDuration
  WorkItemsDF[:MedianDur] = MedianDuration
  WorkItemsDF[:MaxDur] = MaxDuration
  WorkItemsDF[:AvgStartHour] = AvgStartHour
  WorkItemsDF
end

### Work Day Analysis
function WorkDayAnalysis(data::DataFrame)

  data[:Day] = map((x)-> Dates.dayname(x), data[:DateTime])

  WorkDaysDF = DataFrame()
  AvgTaskCount = Int32[]
  TaskTypes = Any[]
  TotalDuration = Float64[]
  MedianDuration = Float64[]
  MaxDuration = Float64[]
  AvgStartHour = Float64[]

  WorkDaysDF[:Day] = ["Monday", "Tuesday", "Wednesday", "Thursday",
                      "Friday", "Saturday", "Sunday"]

  for day in WorkDaysDF[:Day]
      dayDF = data[data[:,:Day].== day, :]
      push!(TaskTypes, collect(Set(dayDF[:Type])))
      push!(TotalDuration, sum(dayDF[:Duration]) )
      push!(MedianDuration, median(dayDF[:Duration]) )
      push!(MaxDuration, maximum(dayDF[:Duration]) )
      push!(AvgStartHour, mean(map((x)-> Dates.hour(x), dayDF[:DateTime])) )
  end

  WorkDaysDF[:TaskTypes] = TaskTypes
  WorkDaysDF[:TotaDur] = TotalDuration
  WorkDaysDF[:MedianDur] = MedianDuration
  WorkDaysDF[:MaxDur] = MaxDuration
  WorkDaysDF[:AvgStartHour] = AvgStartHour
  WorkDaysDF
end

end
