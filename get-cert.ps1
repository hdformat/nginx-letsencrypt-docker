#!/usr/bin/env pwsh

if (!$env:email -or !$env:domain) {
    Write-Host "Please set the environment variables email and domain"
    exit 1
} else {
    $pwd = (Get-Location).Path
    $email = $env:email
    $domain = $env:domain
    docker run --name certbot --rm `
               -v $pwd/etc/letsencrypt:/etc/letsencrypt `
               -v $pwd/var/www:/var/www `
               certbot/certbot certonly --webroot --webroot-path=/var/www --email $email --domain $domain --agree-tos --no-eff-email
}