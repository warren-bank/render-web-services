### [Maddy Mail Server](https://github.com/warren-bank/render-web-services/tree/maddy-email)

#### Servers included in Docker container

1. _Maddy Mail Server_
   * [git repo](https://github.com/foxcpp/maddy)
     - customized contents:
       * [Dockerfile](https://github.com/foxcpp/maddy/blob/v0.8.1/Dockerfile)
       * [maddy.conf.docker](https://github.com/foxcpp/maddy/blob/v0.8.1/maddy.conf.docker)
   * relevant docs:
     - [installation &amp; initial configuration](https://github.com/foxcpp/maddy/blob/v0.8.1/docs/tutorials/setting-up.md)
     - [SQL query mapping](https://github.com/foxcpp/maddy/blob/v0.8.1/docs/reference/table/sql_query.md)
       * [PostgreSQL connection string parameters](https://godoc.org/github.com/lib/pq#hdr-Connection_String_Parameters)
     - [Password table](https://github.com/foxcpp/maddy/blob/v0.8.1/docs/reference/auth/pass_table.md)
     - [SQL-indexed storage](https://github.com/foxcpp/maddy/blob/v0.8.1/docs/reference/storage/imapsql.md)
     - [S3-compatible storage](https://github.com/foxcpp/maddy/blob/v0.8.1/docs/reference/blob/s3.md)
2. _Alps Webmail Server_
   * [git repo](https://git.sr.ht/~migadu/alps)
   * relevant docs:
     - [command-line options](https://git.sr.ht/~migadu/alps/tree/master/item/docs/cli.md)
3. _Dropbear SSH Server_

#### Exposed Ports

* _SSH_
  - `22`
* _SMTP_
  - `25`
  - `465`
  - `587`
* _IMAP_
  - `143`
  - `993`
* _HTTP_
  - `80`

- - - -

#### Goals

* all data is stored elsewhere
  - _PostgreSQL_ database
  - _S3_-compatible storage
* all configuration is done through Docker build arguments

#### Email Accounts

* no accounts are created for you
* to manage accounts:
  - use `ssh` to log in as `root`
  - use the [_maddy_](https://github.com/foxcpp/maddy/blob/v0.8.1/docs/tutorials/setting-up.md#user-accounts-and-maddy-command) command
* because all data is stored elsewhere
  - accounts survive the shutdown and restart of the Docker container
  - moving the Docker container to a different host requires no data migration
  - only the services that store the data need to be highly reliable;<br>the site that hosts the Docker container can go out of business,<br>or close your account without any notice&hellip;<br>and it doesn't really matter

#### Security

* _HTTPS_
  - the _Alps Webmail Server_ only binds to a single _HTTP_ port (ex: `80`)
  - when the Docker container runs on [_render.com_](https://render.com/),<br>the _HTTP_ port (ex: `80`) is exposed behind a reverse proxy&hellip;<br>which provides access over both _HTTP_ (port `80`) and _HTTPS_ (port `443`)

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
Name                  = warren-bank-maddy-email
Language              = Docker
Branch                = maddy-email
Region                = Oregon (US West)
Root Directory        = [empty]
Dockerfile Path       = ./Dockerfile
Instance Type         = Free (512 MB RAM, 0.1 CPU)

Advanced > Environment Variables:
=================================
ROOT_PASSWORD    = root
ALPS_THEME       = alps
INIT_COMMAND     = maddy creds create --hash 'bcrypt' --password 'postmaster' 'postmaster@example.org' && maddy imap-acct create 'postmaster@example.org'
FORCE_ACTIVITY   = https://cors.dohjs.workers.dev/https://warren-bank-maddy-email.onrender.com/login
PORT             = 80

MAIL_HOSTNAME    = example.org
MAIL_DOMAIN      = example.org

SQL_DRIVER       = postgres
SQL_DSN          = host=postgres.example.org port=5432 sslmode=verify-full user=maddy password=maddy dbname=maddy

S3_ENDPOINT      = s3.example.org
S3_SECURE        = yes
S3_ACCESS_KEY    = Q3AM3UQ867SPQQA43P2F
S3_SECRET_KEY    = zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG
S3_BUCKET        = maddy-email
S3_OBJECT_PREFIX = maddy/
S3_REGION        = 
S3_CREDS         = 

</pre>

##### where:

* `ROOT_PASSWORD`
  - assigns a password to the _root_ user
  - enables the _SSH_ server
  - an undefined or empty value causes the _root_ user to not have a password,<br>and the _SSH_ server to not be installed
* `ALPS_THEME`
  - can be the name of any subdirectory in [_themes/_](https://git.sr.ht/~migadu/alps/tree/master/item/themes)
  - an undefined or empty value causes _Alps_ to render HTML using its base theme
* `INIT_COMMAND`
  - is an arbitrary inline command (or sequence of commands) to execute in a shell after all other build commands have finished
  - an undefined or empty value is ignored
* `FORCE_ACTIVITY`
  - causes a period HTTP request at `FORCE_ACTIVITY_INTERVAL` second intervals
    - default: `300` (ie: every 5 minutes)
  - the value is the URL, which should touch the hosted service in such a way that the container host sees activity
    * clever container hosts only count network requests that originate from the public internet,<br>rather than the internal private network
    * this example uses a [reverse proxy server](https://github.com/byu-imaal/dohjs/blob/gh-pages/cors_proxy.js) to make the network request
  - an undefined or empty value allows the Docker container to be spun down after a period of inactivity
* `PORT`
  - not used by [_Dockerfile_](./Dockerfile)
  - [hint](https://render.com/docs/web-services#binding-to-multiple-ports) to Render

- - - -

#### Customization

* the name of the web service must be universally unique
  - ex: `warren-bank-maddy-email`
  - choose your own
* the environment variable values

#### Limitations

* [_SSH_](https://render.com/docs/ssh#limitations) is not supported for free plan services
  - the server is installed and running within the container
  - external clients are unable to communicate with the server,<br>when the container is hosted on the free tier
* [multiple ports](https://render.com/docs/web-services#binding-to-multiple-ports) cannot be exposed to the public internet
  - Render forwards inbound traffic to only one HTTP port per web service
  - a web service can bind to additional ports to receive traffic over the [private network](https://render.com/docs/private-network)

#### Conclusions

* [_render.com_](https://render.com/) is great!
* however&hellip; it's not a good fit for hosting this particular container
