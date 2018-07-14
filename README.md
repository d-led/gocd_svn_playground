# gocd_svn_playground

## Setting Up

- `docker-compose up -d svn-server`
- wait for the server to be initialized successfully, as it can have some hiccups
- check the [SVN UI](http://localhost:3343) (`admin:admin`)
- start the [SVN service](http://localhost:3343/csvn/) via the "Start" button
- in the [Repo List](http://localhost:3343/csvn/repo/list) click "Discover" - to discover repositories created in the shared volume
- run [`./commit_into_repos.sh`](commit_into_repos.sh) to create the first revision in each repo
- `docker-compose up -d go-server go-agent`
- wait for the [GoCD UI](http://localhost:8153) to load
- `docker-compose scale go-agent=3` if necessary


## SVN Externals Polling

- replace the `<pipelines></pipelines>` tag content in [test/godata/config/cruise-config.xml](test/godata/config/cruise-config.xml) with the contents in [test/pipeline_with_externals.xml](test/pipeline_with_externals.xml)
- `tail -f tail -f test/svn-data/logs/access*.log` &rarr; the server continues to poll despite `autoUpdate="false"`


```
$ tail -f test/svn-data/logs/access_2018_07_14_00_00_00.log
172.18.0.3 - admin [14/Jul/2018:12:20:34 +0000] "PROPFIND /svn/with_externals/!svn/rvr/2 HTTP/1.1" 207 373 0
172.18.0.3 - admin [14/Jul/2018:12:20:35 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 154 0
172.18.0.3 - admin [14/Jul/2018:12:20:35 +0000] "PROPFIND /svn/with_externals HTTP/1.1" 207 190 0
172.18.0.3 - - [14/Jul/2018:12:20:36 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 401 381 0
172.18.0.3 - admin [14/Jul/2018:12:20:36 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 154 0
172.18.0.3 - admin [14/Jul/2018:12:20:37 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 96 0
172.18.0.3 - admin [14/Jul/2018:12:20:38 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 154 0
172.18.0.3 - admin [14/Jul/2018:12:20:39 +0000] "PROPFIND /svn/with_externals/!svn/rvr/2 HTTP/1.1" 207 216 0
172.18.0.3 - admin [14/Jul/2018:12:20:39 +0000] "PROPFIND /svn/with_externals/!svn/rvr/2 HTTP/1.1" 207 228 2
172.18.0.3 - admin [14/Jul/2018:12:20:40 +0000] "PROPFIND /svn/with_externals/!svn/rvr/2 HTTP/1.1" 207 606 1
172.18.0.3 - admin [14/Jul/2018:12:20:42 +0000] "PROPFIND /svn/with_externals/!svn/rvr/2/with_externals HTTP/1.1" 207 698 0
172.18.0.3 - - [14/Jul/2018:12:20:43 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 401 381 0
172.18.0.3 - admin [14/Jul/2018:12:20:43 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 154 0
172.18.0.3 - admin [14/Jul/2018:12:20:43 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 96 0
172.18.0.3 - admin [14/Jul/2018:12:20:44 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 154 0
172.18.0.3 - admin [14/Jul/2018:12:20:45 +0000] "PROPFIND /svn/with_externals/!svn/rvr/2 HTTP/1.1" 207 373 0
172.18.0.3 - admin [14/Jul/2018:12:20:46 +0000] "OPTIONS /svn/with_externals HTTP/1.1" 200 154 0
172.18.0.3 - admin [14/Jul/2018:12:20:46 +0000] "PROPFIND /svn/with_externals HTTP/1.1" 207 190 0
```

## Fan In/Fan Out Experiment

- set up
- replace the `<pipelines></pipelines>` tag content in [test/godata/config/cruise-config.xml](test/godata/config/cruise-config.xml) with the contents in [test/pipelines_fan_in.xml](test/pipelines_fan_in.xml)
- observe the builds
- `docker-compose down --remove-orphans`

