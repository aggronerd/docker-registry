# docker-registry

An image which extends the docker registry image to add nginx and configures SSL and htaccess via an S3 bucket. 

## Usage

The basic usage follows that of the base image https://registry.hub.docker.com/_/registry/. The only additions are the following:

* CONFIG_BUCKET - An AWS S3 bucket containing required files to setup the running instance.
* AWS_SECRET_ACCESS_KEY, AWS_ACCESS_KEY_ID and AWS_DEFAULT_REGION if required (see below).

### Configuring the bucket

The chosen bucket needs to contain the following files. It is also advised you use AES256 server side encryption on these files.

* docker-registry.htpasswd - A htpasswd file containing users who are able to access your registry. A guide for creating these files can be found on the Apache site (http://httpd.apache.org/docs/2.2/programs/htpasswd.html)
* docker-registry.crt - Your server's SSL public certificate.
* docker-registry.key - Your server's SSL private key. It is recommended you set up your own CA which you can register with the docker client.

When the instances is started the entrypoint script downloads these files using the awscli tools. You can use IAM if you are in AWS to authorise your EC2 nodes to access the bucket or provide the AWS credentials using the correct environmental variables (AWS_SECRET_ACCESS_KEY and AWS_ACCESS_KEY_ID).

### Example

```{r, engine='bash', count_lines}
docker run -e SETTINGS_FLAVOR=s3 -e AWS_BUCKET=freds_docker_repository -e STORAGE_PATH=/registry -e AWS_KEY=SECRET_GOES_HERE -e AWS_SECRET=SECRET_GOES_HERE -e SEARCH_BACKEND=sqlalchemy -e CONFIG_BUCKET=uk.co.gregorydoran.docker.config -e AWS_ACCESS_KEY_ID=SECRET_GOES_HERE -e AWS_SECRET_ACCESS_KEY=SECRET_GOES_HERE -e AWS_DEFAULT_REGION=eu-west-1 -p 443:8080 aggronerd/registry
```