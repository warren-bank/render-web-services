### [Hauk](https://github.com/warren-bank/render-web-services/tree/hauk)

#### Fork Details

* fork: [bilde2910/Hauk](https://github.com/bilde2910/Hauk)
  - author: [Marius Lindvall](https://varden.info/)
  - commit: [55d2f8b8fdbebf591d759a72022527c226aad840](https://github.com/bilde2910/Hauk/tree/55d2f8b8fdbebf591d759a72022527c226aad840)
  - date: 2021-03-30
  - license: [Apache-2.0](./LICENSE)
  - more info: [original README](./README-original.md)
* diff: original snapshot vs. tags in fork
  - [v1.0.0](https://github.com/warren-bank/render-web-services/compare/hauk%2foriginal..hauk%2fv1.0.0/)

#### Goals

* update the Docker container and associated scripts to enable a small private instance of the [backend PHP server](./backend-php) to be rapidly deployed for free on the hosting provider: [render.com](https://render.com/docs/free)

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

https://dashboard.render.com/new/redis

Name               = hauk
Region             = Oregon (US West)
Maxmemory Policy   = allkeys-lru (recommended for caches)
Instance Type      = Free (25 MB RAM, 50 Connection Limit, No Persistence)

Internal Redis URL = redis://red-8qrs2p3h5q110nyy5le4:6379

--------------------------------------------------------------------------------

https://dashboard.render.com/select-repo?type=web

Public Git Repository = https://github.com/warren-bank/render-web-services
Name                  = warren-bank-hauk
Region                = Oregon (US West)
Branch                = hauk
Root Directory        = [empty]
Runtime               = Docker
Instance Type         = Free (512 MB RAM, 0.1 CPU)

Advanced > Environment Variables:
=================================
REDIS_HOST    = red-8qrs2p3h5q110nyy5le4
REDIS_PORT    = 6379
AUTH_METHOD   = PASSWORD
PASSWORD_HASH = $2y$10$4ZP1iY8A3dZygXoPgsXYV.S3gHzBbiT9nSfONjhWrvMxVPkcFq1Ka
VELOCITY_UNIT = MILES_PER_HOUR
PUBLIC_URL    = https://warren-bank-hauk.onrender.com/

</pre>

- - - -

#### Customization

* the name of the web service must be universally unique
  - ex: `warren-bank-hauk`
  - choose your own
* the value given to the environment variable `PASSWORD_HASH` should correspond to non-empty password that restricts access to the server
  - the following value corresponds to an empty password, which should _not_ be used:
    ```text
      $2y$10$4ZP1iY8A3dZygXoPgsXYV.S3gHzBbiT9nSfONjhWrvMxVPkcFq1Ka
    ```
  - using _PHP_, the command to generate your own is:
    ```bash
      # generate hash of password with randomized salt
      pw='my_server_password'
      php -n -r "print password_hash('${pw}', PASSWORD_BCRYPT);"

      # output
      $2y$10$WzDdd.xmPkBS03JhwQkk4.nMRUkY3ol76l/Kx9nJRmBbtW7aUfyTK

      # verify output
      hash='$2y$10$WzDdd.xmPkBS03JhwQkk4.nMRUkY3ol76l/Kx9nJRmBbtW7aUfyTK'
      php -n -r "print password_verify('${pw}', '${hash}') ? 'OK' : 'ERROR';"

      # output
      OK
    ```
  - using _htpasswd_, the command to generate your own is:
    ```bash
      # generate hash of password with randomized salt
      pw='my_server_password'
      htpasswd -n -b -B -C 10 "" "$pw" | tail -c +2

      # output
      $2y$10$CjhWuGGulQDPdxGwhqxkE.2zVTsz6AV0JeuMGsr51sEX1ZEPTAxn6

      # verify output
      hash='$2y$10$CjhWuGGulQDPdxGwhqxkE.2zVTsz6AV0JeuMGsr51sEX1ZEPTAxn6'
      php -n -r "print password_verify('${pw}', '${hash}') ? 'OK' : 'ERROR';"

      # output
      OK
    ```
    * where:
      - `htpasswd` is a tool included with apache
      - ex: [_C:\PortableApps\XAMPP\apache\bin\htpasswd.exe_](https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/1.7.3/xampplite-win32-1.7.3.zip/download)

#### Final Comments

* This git repo is public. Anyone who wishes to host their own Hauk server using the free tier on [render.com](https://render.com/) can link to it. There's no need to fork a copy, though you can if you prefer.
