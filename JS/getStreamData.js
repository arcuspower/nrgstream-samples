
const nrgApi = require('./nrgApi')

const getStreamData = async (streamId, fromDate, toDate) => {
    await nrgApi.getToken('myUsername','myPassword')
    const csvText = await nrgApi.getStreamData(streamId, fromDate, toDate)
    await nrgApi.releaseToken()
    return csvText
}

getStreamData(2, new Date('2023-03-24T07:00:00.000Z'), new Date('2023-03-26T07:00:00.000Z'))
  .then(csvText => console.log(csvText))
  .catch(error => console.error(error))


