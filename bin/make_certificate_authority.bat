@echo off

set OPENSSL_HOME=C:\PortableApps\OpenSSL\3.1.3
set OPENSSL_CONF=%OPENSSL_HOME%\openssl.cnf
set PATH=%OPENSSL_HOME%;%PATH%

rem :: https://stackoverflow.com/a/74473673

cd /D "%~dp0..\crt"

set subject="/CN=my.root"
openssl req -new -x509 -nodes -subj %subject% -newkey rsa:2048 -keyout ca.key -out ca.crt -reqexts v3_req -extensions v3_ca

echo.
pause
