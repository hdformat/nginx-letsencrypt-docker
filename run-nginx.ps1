#!/usr/bin/env pwsh

$pwd = (Get-Location).Path

docker run --name nginx --rm -it `
           -p 80:80 `
           -p 443:443 `
           -v $pwd/etc/nginx/conf.d:/etc/nginx/conf.d `
           -v $pwd/etc/letsencrypt:/etc/letsencrypt `
           -v $pwd/var/www:/var/www `
           nginx:latest
