# Welcome

Here you will find code samples for using the NRGStream API to access data from the platform.  These samples assume familiarity with the NRGStream service in general (such as the concepts of streams, data options, extracts) and mostly focus on the actual mechanics of authenticating and using the API to retrieve data.  

Code in this repository will be kept up to date with API releases. In the event that this code does NOT complete for some reason - raise a support ticket according to your subscription agreement and it will be brought into compliance in a reasonable time.


# Authentication and General Flow

The general flow for authenticating and using the API is as follows:

1. POST /api/security/token (with a form encoded body) - fetches a token that must be included in Authorization headers of future requests
1. ... use api methods like /api/GetStreamData/<streamId> with your token in authorization headers 
1. DELETE /api/ReleaseToken - to release the token

## Imporant notes on token management

It is important you release the token after using it because each user account can have one active token at a time.  Any attempt to acquire a token while another token is active will fail with status 400 and text "Another user is currently using the API".  In the event that you lose track of your token, you will have to wait for the existing token to expire before you can get a new one.  Token expiry is 5 minutes.

## Rate limiting on the API

Calls to GroupExtracts and StreamData are rate limited.  The default call rate is limited to 5 calls per second, but this limit can be increased based upon your subscription level.  The API may return status 429 (Too many requests) or 400 (Bad Request) with the text "Access Denied".  


Happy hacking!

