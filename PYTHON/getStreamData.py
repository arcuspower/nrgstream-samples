from nrgstreamApi import NRGStreamApi

nrgApi = NRGStreamApi(username='myUsername', password='myPassword')
csvData = nrgApi.GetStreamDataByStreamIds([2], '2023-03-26 15:00:00', '2023-03-27 15:00:00')
print(csvData)
