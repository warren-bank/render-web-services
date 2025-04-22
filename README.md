### [LibreTranslate](https://github.com/warren-bank/render-web-services/tree/libre-translate)

#### Fork Details

* canonical project:
  - [git repo](https://github.com/LibreTranslate/LibreTranslate)
  - git branch: [main](https://github.com/LibreTranslate/LibreTranslate/tree/main)
  - license: [GPL-3.0](https://github.com/LibreTranslate/LibreTranslate/blob/v1.6.5/LICENSE)
  - author: [Piero Toffanin](https://github.com/pierotofy)
* forked project:
  - [git repo](https://github.com/warren-bank/mirror-Python-LibreTranslate)
  - git branch: [PR-01-docker-security](https://github.com/warren-bank/mirror-Python-LibreTranslate/tree/PR-01-docker-security)
* diff:
  - [canonical/main .. fork/PR-01-docker-security](https://github.com/warren-bank/mirror-Python-LibreTranslate/compare/LibreTranslate%3ALibreTranslate%3Amain...PR-01-docker-security)

#### Goals

* update the Docker container to allow creating API keys when using cloud hosting

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

https://dashboard.render.com/select-repo?type=web

Public Git Repository = https://github.com/warren-bank/mirror-Python-LibreTranslate
Name                  = warren-bank-libre-translate
Language              = Docker
Branch                = PR-01-docker-security
Region                = Oregon (US West)
Root Directory        = [empty]
Dockerfile Path       = ./docker/user-with-api-key.Dockerfile
Instance Type         = Free (512 MB RAM, 0.1 CPU)

Advanced > Environment Variables:
=================================
api_key       = This-Is-My-Secret!
with_models   = true
LT_API_KEYS   = true
LT_REQ_LIMIT  = 0

</pre>

- - - -

#### Customization

* the name of the web service must be universally unique
  - ex: `warren-bank-libre-translate`
  - choose your own
* the value of the environment variable: `api_key`
  - this is your secret password
  - this value is a required [API](https://libretranslate.com/docs/) parameter

#### Usage Examples

1. [webpage interface](https://warren-bank-libre-translate.onrender.com/)
2. download [JSON data](https://warren-bank-libre-translate.onrender.com/languages) that describes all available languages
3. request a translation _without_ the proper API key:
   ```bash
     curl --silent -X POST --data-binary '{"q": "hello world", "source": "en", "target": "fr"}' -H 'content-type: application/json' 'https://warren-bank-libre-translate.onrender.com/translate'
   ```
4. request a translation _with_ the proper API key:
   ```bash
     curl --silent -X POST --data-binary '{"q": "hello world", "source": "en", "target": "fr", "api_key": "This-Is-My-Secret!"}' -H 'content-type: application/json' 'https://warren-bank-libre-translate.onrender.com/translate'
   ```
   - note: this is not my actual API key&hellip; but you get the idea

#### Usage Notes

* an interesting (and great) thing about the `/translate` API endpoint that isn't documented:
  - when the `q` attribute in the request is an array of strings
  - then the `translatedText` attribute in the response is an array of translated strings
    * same length
    * same order

* runs great on "render.com"
  - plenty of storage space to install the full package
  - takes a little while to spin up from cold sleep
  - the monthly usage allotment is super generous&hellip;<br>more than enough for my needs

#### Final Comments

* This git repo is public. Anyone who wishes to host their own [LibreTranslate&trade;](https://github.com/LibreTranslate/LibreTranslate) server using the free tier on [render.com](https://render.com/) can link to it. There's no need to fork a copy, though you can if you prefer.
