#!/bin/bash
# Sets up the proxy for

if [ -z "$CONFIG_BUCKET" ]
then
	echo "Expected the CONFIG_BUCKET environmental variable to be set"
	exit 1
fi

echo "Attempting to download config files..."
aws s3 cp "s3://$CONFIG_BUCKET/docker-registry.htpasswd" /etc/nginx/docker-registry.htpasswd
aws s3 cp "s3://$CONFIG_BUCKET/docker-registry.crt" /etc/ssl/certs/docker-registry
aws s3 cp "s3://$CONFIG_BUCKET/docker-registry.key" /etc/ssl/private/docker-registry

echo "Starting nginx..."
nginx

echo "Starting registry..."
registry cmd/registry/config.yml