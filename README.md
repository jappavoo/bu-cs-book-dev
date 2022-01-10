<!-- #region -->
# bu-cs-book-dev

This is the container image source for the BU Computer Science Jupyter Book infrastructure.
1. This repository support running the image locally (fetching it from dockerhub if needed)
2. Building the image from scratch
3. pull and pushing from the dockerhub

**Note:  This container does not have any particular book within it.  You must clone or copy whatever particular book you want into it.
At the <a href="#localSLSlink">bottom</a> you will find a url that should trigger a clone of the Under the Covers - The Secret Life of Software into it.**

## Getting started

### Remote use 

This container image is available on the MOC [operate-first](https://jupyterhub-opf-jupyterhub.apps.smaug.na.operate-first.cloud/hub/home) JupyerHub service.  To use the container on this service login and start a server with the `BU CS Jupyter Book` image.  You can use this link to directly start it if you don't already have a server running:<br>
https://jupyterhub-opf-jupyterhub.apps.smaug.na.operate-first.cloud/hub/spawn?bu-cs-jupyter-book:latest


### Prerequisites for local use

1. Intel based computer
2. Docker installed : https://www.docker.com
3. The ability to open a terminal and run make and git in the terminal

### Downloading a copy of this repository
1. Open a terminal
2. clone this respository using git
> git clone https://github.com/jappavoo/bu-cs-book-dev
```
$ git clone https://github.com/jappavoo/bu-cs-book-dev.git
Cloning into 'bu-cs-book-dev'...
remote: Enumerating objects: 75, done.
remote: Counting objects: 100% (75/75), done.
remote: Compressing objects: 100% (49/49), done.
remote: Total 75 (delta 28), reused 64 (delta 21), pack-reused 0
Unpacking objects: 100% (75/75), 19.31 KiB | 420.00 KiB/s, done.
$
```
The rest of the instructions assume that you are in the newly created directory of the above command. To get into this directory you need to do the following:

> cd bu-cs-book-dev


```
$ cd bu-cs-book-dev/
$
```

### starting and connecting to the jupyter server

To start a local container from the image:
> make nb
```
$ make nb
docker run -it --rm -p 8888:8888 -v "/Users/myname":"/opt/app-root/src" jappavoo/bu-cs-book-dev:latest  
WARN: Jupyter Notebook deprecation notice https://github.com/jupyter/docker-stacks#jupyter-notebook-deprecation-notice.

... 
    To access the notebook, open this file in a browser:
        file:///home/jovyan/.local/share/jupyter/runtime/nbserver-9-open.html
    Or copy and paste one of these URLs:
        http://0ab5d990a6f6:8888/?token=d8c3ef6507c6df9e379df4c3745933e100850165c18f19ea
     or http://127.0.0.1:8888/?token=d8c3ef6507c6df9e379df4c3745933e100850165c18f19ea
```

There will be a lot of information displayed in response to this command.  But all we care about is the url on the last line.  You should be able to paste it into your web browser and then it will connect the the jupyter-server running within it.

### building the container locally from scratch

> make build

### more info on what you can do

> make

## Useful links:
- Published pre-built version:<br>
https://hub.docker.com/repository/docker/jappavoo/bu-cs-book-dev
- Boston University Course Online Service : be sure to pick<b>
https://jupyterhub-redhat-ods-applications.apps.bu-rosa.8pmt.p1.openshiftapps.com/hub/user-redirect/lab
- Operate-first JupyterHub Service: <br>
http://jupyterhub-opf-jupyterhub.apps.zero.massopen.cloud
- Direct spawn on Operate-first: <br>
https://jupyterhub-opf-jupyterhub.apps.zero.massopen.cloud/hub/spawn?bu-cs-jupyter-book:latest
- A book that uses this image:<br>
https://github.com/jappavoo/UndertheCovers
- If you have the container running locally you can use the following link to automatically clone a copy of the the above book into the container
<div id=localSLSlink>
http://127.0.0.1:8888/git-pull?bu-cs-jupyter-book%3Alatest=&repo=https%3A%2F%2Fgithub.com%2Fjappavoo%2FUndertheCovers&urlpath=tree%2FUndertheCovers%2Funderthecovers%2FL00_210_JA.ipynb&branch=main
    </div>


<!-- #endregion -->
