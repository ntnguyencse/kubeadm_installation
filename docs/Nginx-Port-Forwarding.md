
# Setting Up Nginx Port Forwarding

As part of the prerequisites, you’ve enabled HTTPS at your domain. To expose your secured Docker Registry there, you’ll only need to configure Nginx to forward traffic from your domain to the registry container.

You have already set up the /etc/nginx/sites-available/your_domain file, containing your server configuration. Open it for editing by running:

sudo nano /etc/nginx/sites-available/your_domain
Find the existing location block:
```
/etc/nginx/sites-available/your_domain
...
location / {
  ...
}
...
```
You need to forward traffic to port 5000, where your registry will be listening for traffic. You also want to append headers to the request forwarded to the registry, which provides additional information from the server about the request itself. Replace the existing contents of the location block with the following lines:
```
/etc/nginx/sites-available/your_domain
...
location / {
    # Do not allow connections from docker 1.5 and earlier
    # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
    if ($http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
      return 404;
    }

    proxy_pass                          http://localhost:5000;
    proxy_set_header  Host              $http_host;   # required for docker client's sake
    proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
    proxy_read_timeout                  900;
}
...
```
The if block checks the user agent of the request and verifies that the version of the Docker client is above 1.5, as well as that it’s not a Go application that’s trying to access. For more explanation on this, you can find the nginx header configuration in Docker’s registry Nginx guide.

Save and close the file when you’re done. Apply the changes by restarting Nginx:

sudo systemctl restart nginx
If you get an error, double-check the configuration you’ve added.