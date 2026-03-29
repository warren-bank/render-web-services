### [ntfy](https://github.com/warren-bank/render-web-services/tree/ntfy)

#### Background

* [`ntfy`](https://github.com/binwiederhier/ntfy) is an open-source HTTP-based pub-sub notification service
  - [https://ntfy.sh](https://ntfy.sh/) hosts an instance of this service, which includes a free tier
* [`ntfy-android`](https://github.com/binwiederhier/ntfy-android) is an Android client that can subscribe to topics on instances of this service
  - APK [releases](https://github.com/binwiederhier/ntfy-android/releases)
  - [F-Droid](https://f-droid.org/packages/io.heckel.ntfy/)
  - [Play Store](https://play.google.com/store/apps/details?id=io.heckel.ntfy)

#### Goals

* install the official [Docker image](https://hub.docker.com/r/binwiederhier/ntfy) from a minimal [Dockerfile](./Dockerfile) wrapper
* [configure](https://docs.ntfy.sh/config/#config-options) the service with environment variables
  - use an external [Postgres database](https://docs.ntfy.sh/config/#database-options) for persistent storage

- - - -

<pre>
https://supabase.com/pricing

free tier includes:
* 1 PostgreSQL
  - 500 MB size, shared CPU, 500 MB RAM
  - unlimited API requests, 5 GB egress
  - is paused after 1 week of inactivity

IMPORTANT:
* only the "Connection String" for the "Session pooler" is IPv4 compatible
  - this is required to work with "Render"

--------------------------------------------------------------------------------

https://supabase.com/dashboard/new?plan=free
  - no credit card required
  - only need to provide:
    * email address
    * password

</pre>

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

Public Git Repository = https://github.com/warren-bank/render-web-services
Name                  = warren-bank-ntfy
Language              = Docker
Branch                = ntfy
Region                = Oregon (US West)
Root Directory        = [empty]
Dockerfile Path       = ./Dockerfile
Instance Type         = Free (512 MB RAM, 0.1 CPU)

Advanced > Environment Variables:
=================================
NTFY_BASE_URL         = https://warren-bank-ntfy.onrender.com
NTFY_DATABASE_URL     = postgresql://postgres.[project-id]:[project-db-password]@aws-1-us-east-2.pooler.supabase.com:5432/postgres

</pre>

- - - -

#### Customization

* the name of the web service must be universally unique
  - ex: `warren-bank-ntfy`
  - choose your own
* the value of the environment variables

#### Usage Examples

1. [publish](https://docs.ntfy.sh/publish/) a message from the command-line to a topic named: `very-important`
   ```bash
     curl -d "Reminder: leave now!" "https://warren-bank-ntfy.onrender.com/very-important"
   ```
2. [subscribe](https://docs.ntfy.sh/subscribe/phone/) to receive this notification on an Android phone<br>![android-screenshot-add-other](./img/android-screenshot-add-other.png)
   * topic name: `very-important`
   * server: `https://warren-bank-ntfy.onrender.com`

#### Final Comments

* This git repo is public. Anyone who wishes to host their own [`ntfy`](https://github.com/binwiederhier/ntfy) server using the free tier on [render.com](https://render.com/) can link to it. There's no need to fork a copy, though you can if you prefer.
