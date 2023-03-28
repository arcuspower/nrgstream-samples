const axios = require('axios')
const { formatToTimeZone } = require('date-fns-timezone')

let nrgBaseUrl = process.env.API_BASE_URL || 'https://api.nrgstream.com/'

let currentTokenData
let nrgstreamSession = axios.create({ baseURL: nrgBaseUrl })

function setNrgBaseUrl(baseUrl) {
    nrgBaseUrl = baseUrl
    nrgstreamSession = axios.create({ baseURL: nrgBaseUrl })
}

async function updateTokenData(tokenData) {
    currentTokenData = tokenData
    nrgstreamSession.defaults.headers.Authorization = currentTokenData && 'Bearer ' + currentTokenData.access_token
}

async function getToken(username, password) {
    const loginResponse = await nrgstreamSession.post('/api/security/token', `grant_type=password&username=${username}&password=${password}`)
    updateTokenData(loginResponse.data)
}

async function releaseToken() {
    await nrgstreamSession.delete('/api/ReleaseToken')
    console.log('released token')
}

async function getStreamList() {
    let response = await nrgstreamSession.get('/api/StreamList')
    return response.data
}

async function getLatestStreamData(streamId) {
    let response = await nrgstreamSession.get('/api/StreamData/'+streamId)
    return response.data
}
async function getStreamData(streamId,fromDate,toDate) {
    var response
    try{
        if(!fromDate || !toDate){
            response = await nrgstreamSession.get('/api/StreamData/'+streamId)
            return response.data.data
        } 
        if(fromDate && toDate){
            let fromDateString = formatToTimeZone(fromDate, 'MM/DD/YYYY', { timeZone: 'America/Chicago' })
            let toDateString = formatToTimeZone(toDate, 'MM/DD/YYYY', { timeZone: 'America/Chicago' })    
            response = await nrgstreamSession.get('/api/StreamData/'+streamId+"?fromDate="+fromDateString+"&toDate="+toDateString)
            return response.data.data
        } 
    }catch(err){
        console.log(err.message)
        console.log(" 'fromDate' OR 'toDate' is missing a value")
    }
}

module.exports = {
    setNrgBaseUrl,
    getToken,
    releaseToken,
    getStreamList,
    getLatestStreamData,
    getStreamData
}