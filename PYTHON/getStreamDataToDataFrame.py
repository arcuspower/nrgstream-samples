
from nrgstreamApi import NRGStreamApi
import pandas as pd

# one appraoch to load a dataframe directly from the API csv result.
def csvStreamToPandas(streamData):
    # split lines of return string from api
    streamData = streamData.split("\n")
    
    # remove empty elements from list
    streamData = [x for x in streamData if len(x) > 0] 
    
    # remove header data
    streamData = [x for x in streamData if x[0] != '#'] 
                    
    # split elements into lists of lists                     
    streamData = [x.split(",") for x in streamData] 
    
    # create dataframe
    df = pd.DataFrame(streamData[1:], columns=streamData[0]) 
    
    return df

nrgApi = NRGStreamApi(username='myUsername', password='myPassword')
csvData = nrgApi.GetStreamDataByStreamIds([2], '2023-03-26 15:00:00', '2023-03-27 15:00:00')
df = csvStreamToPandas(csvData)

print(df)
