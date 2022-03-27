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
            certbot/certbot renew --server https://acme-v02.api.letsencrypt.org/directory --cert-name $domain
}

