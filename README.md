# Installing RTMP server

Launch Dokku instance from DigitalOcean.  Update it:

```
$ apt-get update
$ apt-get upgrade -y
$ reboot
```

Create a Dokku app and set some Docker options

```
$ dokku apps:create ferry
$ dokku checks:disable ferry
$ dokku docker-options:add ferry run "-h ferry2.sunspot.io"
$ dokku docker-options:add ferry run "-p 1935:1935"
```

Deploy this repo
```
$ git remote add dokku dokku@ferry2.sunspot.io:ferry
$ git push dokku master
```