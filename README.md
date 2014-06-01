# appdeploy

## Overview 

The appdeploy module helps Django deploys by:

* Installing compilation dependecies
* Setting up reverse proxy
* Configuring supervisor to manage the application execution
* Allowing the user to set a websocket proxy

## Defines 

### appdeploy::django

```puppet
    appdeploy::django { 'myappname':
        user        => 'myuser',
        directory   => '/home/myuser/myappsrc',
        proxy_hosts => [
            'myappname.com',
            'internal.myappname.com',
        ],
    }
```

Parameters:

* user: user that will run the application it self. This user must have access to the source code in `directory`.
* directory: where the application source code will be placed.
* proxy_hosts: the server_name(s) that Nginx will listen to and redirect requests to the deployed app.

## Classes

Installs development libraries and headers to allow compilation of specific libraries. 

Currently supporting:

* appdeploy::deps::postgresql: dependecies for `psycopg2`
* appdeploy::deps::mysql: dependecies for `MySQL-python`
* appdeploy::deps::lxml: dependecies for 'lxml'
* appdeploy::deps::scrapy: dependecies for 'scrapy'


## Contact

Please log tickets and issues at our [Projects site](http://projects.example.com)


## Releases

Releases are published on [Puppet Forge](https://forge.puppetlabs.com/tracywebtech/appdeploy)
