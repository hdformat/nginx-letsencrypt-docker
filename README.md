# Nginx with Letsencrypt using Docker

### Set up environment values

```powershell
PS > $env:email = "admin@example.com"

PS > $env:doamin = "ssl.example.com"

```

### Run nginx with below configuration

```
# ./etc/nginx/conf.d/default.conf

server {
    listen 80;
    listen [::]:80;

    server_tokens off;

    location /.well-known/acme-challenge {
        root /var/www;
    }
}
```

```powershell
PS > ./run-nginx.ps1

/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf differs from the packaged version
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/03/27 00:09:39 [notice] 1#1: using the "epoll" event method
2022/03/27 00:09:39 [notice] 1#1: nginx/1.21.6
2022/03/27 00:09:39 [notice] 1#1: built by gcc 10.2.1 20210110 (Debian 10.2.1-6)
2022/03/27 00:09:39 [notice] 1#1: OS: Linux 5.10.60.1-microsoft-standard-WSL2
2022/03/27 00:09:39 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/03/27 00:09:39 [notice] 1#1: start worker processes
...
```

```powershell
PS > Test-NetConnection ssl.example.com -Port 80

ComputerName     : ssl.example.com
RemoteAddress    : 61.73.3.40
RemotePort       : 80
InterfaceAlias   : 이더넷
SourceAddress    : 192.168.0.24
TcpTestSucceeded : True
```

### Get a cert from letsencrypt

```powershell
PS > .\get-cert.ps1

Requesting a certificate for ssl.example.com

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/ssl.example.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/ssl.example.com/privkey.pem
This certificate expires on 2022-06-24.
These files will be updated when the certificate renews.
NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

### Add ssl 443 setting to nginx config file

```
# ./etc/nginx/conf.d/default.conf

server {
    listen 80;
    listen [::]:80;

    server_tokens off;

    location /.well-known/acme-challenge {
        root /var/www;
    }
}

server {
    listen 443 ssl;
    server_name localhost;

    server_tokens off;

    ssl_certificate /etc/letsencrypt/live/ssl.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ssl.example.com/privkey.pem;
}
```

### Re-run nginx with new configuration

```powershell
PS > ./run-nginx.ps1

/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf differs from the packaged version
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/03/27 00:15:46 [notice] 1#1: using the "epoll" event method
2022/03/27 00:15:46 [notice] 1#1: nginx/1.21.6
2022/03/27 00:15:46 [notice] 1#1: built by gcc 10.2.1 20210110 (Debian 10.2.1-6)
2022/03/27 00:15:46 [notice] 1#1: OS: Linux 5.10.60.1-microsoft-standard-WSL2
2022/03/27 00:15:46 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/03/27 00:15:46 [notice] 1#1: start worker processes
...
```

```powershell
PS > Test-NetConnection ssl.example.com -Port 443

ComputerName     : ssl.example.com
RemoteAddress    : 61.73.3.40
RemotePort       : 443
InterfaceAlias   : 이더넷
SourceAddress    : 192.168.0.24
TcpTestSucceeded : True
```

### Check expire date of the cert

```powershell
PS > .\get-cert-expire-date.ps1

Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Found the following certs:
  Certificate Name: ssl.example.com
    Serial Number: 3af7f2301524162c5738133881f01421911
    Key Type: RSA
    Domains: ssl.example.com
    Expiry Date: 2022-06-24 23:12:54+00:00 (VALID: 89 days)
    Certificate Path: /etc/letsencrypt/live/ssl.example.com/fullchain.pem
    Private Key Path: /etc/letsencrypt/live/ssl.example.com/privkey.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

### Try to renew the cert

```powershell
PS > .\get-cert-renew.ps1

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Processing /etc/letsencrypt/renewal/ssl.example.com.conf
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Certificate not yet due for renewal

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
The following certificates are not due for renewal yet:
  /etc/letsencrypt/live/ssl.example.com/fullchain.pem expires on 2022-06-24 (skipped)
No renewals were attempted.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Saving debug log to /var/log/letsencrypt/letsencrypt.log
```

