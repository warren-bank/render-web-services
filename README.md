### [HLS-Proxy](https://github.com/warren-bank/render-web-services/tree/hls-proxy)

- - - -

<pre>
https://render.com/
https://render.com/docs/free

free tier includes:
* 750 hours of web service uptime
  - web service is spun down after 15 minutes of inactivity
  - web service is spun up as needed, and 1st request can experience a delay of up to 30 seconds
* 1 Redis instance
  - ephemeral.. not backed by a disk
* 1 PostgreSQL
  - automatically expires 90 days after creation

--------------------------------------------------------------------------------

https://dashboard.render.com/register
  - no credit card required
  - only need to provide:
    * email address
    * password

https://dashboard.render.com/
https://dashboard.render.com/billing#free-usage

--------------------------------------------------------------------------------

https://dashboard.render.com/create?type=web

Public Git Repository = https://github.com/warren-bank/HLS-Proxy
Name                  = warren-bank-hls-proxy
Region                = Oregon (US West)
Branch                = v03
Root Directory        = [empty]
Runtime               = Node
Build Command         = npm install
Start Command         = npm start -- --port 8080 --host warren-bank-hls-proxy.onrender.com:443 --req-insecure -v -1 --acl-pass 12345
Instance Type         = Free (512 MB RAM, 0.1 CPU)

</pre>

- - - -

#### Usage

1. [example Javascript]: construction of URL to _HLS Proxy_ for video stream
   ```javascript
     {
       const proxy_url      = 'https://warren-bank-hls-proxy.onrender.com:443'
       const video_url      = 'https://www.cbsnews.com/common/video/cbsn_header_prod.m3u8'
       const file_extension = '.m3u8'
       const password       = '12345'

       const hls_proxy_url  = `${proxy_url}/${ btoa(video_url) }${file_extension}?password=${encodeURIComponent(password)}`

       // https://warren-bank-hls-proxy.onrender.com:443/aHR0cHM6Ly93d3cuY2JzbmV3cy5jb20vY29tbW9uL3ZpZGVvL2Nic25faGVhZGVyX3Byb2QubTN1OA==.m3u8?password=12345
     }
   ```
2. [example Javascript]: construction of URL to watch proxied stream in HTML5 video player
   ```javascript
     {
       const hls_proxy_url  = 'https://warren-bank-hls-proxy.onrender.com:443/aHR0cHM6Ly93d3cuY2JzbmV3cy5jb20vY29tbW9uL3ZpZGVvL2Nic25faGVhZGVyX3Byb2QubTN1OA==.m3u8?password=12345'
       const vid_player_url = 'https://warren-bank.github.io/crx-webcast-reloaded/external_website/4-clappr/index.html'
                            + `#/watch/${ btoa(hls_proxy_url) }`

       // https://warren-bank.github.io/crx-webcast-reloaded/external_website/4-clappr/index.html#/watch/aHR0cHM6Ly93YXJyZW4tYmFuay1obHMtcHJveHkub25yZW5kZXIuY29tOjQ0My9hSFIwY0hNNkx5OTNkM2N1WTJKemJtVjNjeTVqYjIwdlkyOXRiVzl1TDNacFpHVnZMMk5pYzI1ZmFHVmhaR1Z5WDNCeWIyUXViVE4xT0E9PS5tM3U4P3Bhc3N3b3JkPTEyMzQ1
     }
   ```

- - - -

#### Customization

* _Name_ of the web service:
  - must be universally unique
  - choose your own
    * ex: `warren-bank-hls-proxy`
* _Start Command_ option values:
  - `--host`
    * its subdomain is the universally unique name of your web service
      - ex: `warren-bank-hls-proxy`
  - `--acl-pass`
    * its purpose is to restrict access to the server, by requiring that every request include a `password` querystring parameter containing this secret value
      - ex: `12345`

#### Final Comments

* The [`HLS-Proxy` git repo](https://github.com/warren-bank/HLS-Proxy) is public. Anyone who wishes to host their own server instance using the free tier on [render.com](https://render.com/) can link to it. There's no need to fork a copy, though you can if you prefer.
