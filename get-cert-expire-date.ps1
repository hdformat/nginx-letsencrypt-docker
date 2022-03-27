#!/usr/bin/env pwsh

if (!$env:email -or !$env:domain) {
    Write-Host "Please set the environment variables email and domain"
    exit 1
} else {
    $pwd = (Get-Location).Path
    $email = $env:email
    $domain = $env:domain
    docker run -it --rm --name certbot `
               -v $pwd/etc/letsencrypt:/etc/letsencrypt `
               certbot/certbot certificates
}