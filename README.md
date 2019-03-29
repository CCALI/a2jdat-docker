# CALI A2JDAT Docker project
This is an *experimental* Dockerized version of the A2JDAT
https://github.com/CCALI/A2JDAT/. This project dockerizes version 2.0.0 of the DAT.  It includes wkhtmltopdf, node 8.9.4, and the CALI DAT source.

NOTE: By downloading this application, you are agreeing to the terms included in the user license [LICENSE.md](https://github.com/CCALI/A2JDAT/blob/master/LICENSE.md).


## Requirements
Docker 18

### Built on
Built with docker 18.09 on Mac High Sierra.

## Config Notes
you must modify `config.json` to match your system either before you build or with a `docker image cp` or building a derived image that replaces `config.json`

## Building
download this repo and navigate to that location in a terminal.
Then run `docker compose build . -t dat`

## Running
You can run with docker compose as demonstrated in a2jdocker or run stand alone with `docker run -p 3000:3000 -d dat`. You can test the dat by sending ports to port 3000.

## More info

To find out more about A2J Viewer, A2J DAT, and A2J Author® please see our website, [www.a2jauthor.org](https://www.a2jauthor.org/)

For questions, contact Tobias Nteireho at tobias@cali.org

# A2JDAT

This repo hosts the distributable production version of the A2J Document Assembly Tool (DAT). The document assembly tool is an optional piece of software used for producing pdf documents at the end of interviews. It requires the A2Jviewer, wkhtmltopdf and nodejs 6+ to run properly. The recommended additional tools for windows are nvm and iisnode. The recommended additional tools for \*nix servers are nvm and pm2.

Within this repo and releases you'll find a `.zip` file containing the minified JavaScript source for the DAT and sample configuration files

NOTE: By downloading this application, you are agreeing to the terms included in the user license [LICENSE.md](https://github.com/CCALI/A2JDAT/blob/master/LICENSE.md).

## Hosting
The DAT requires nodejs 8+. Any system supporting nodejs 8+ is supported. It has been tested on ubuntu 14, 16 and 18, centos, and Windows Server 2016 on Azure with apache and IIS

While other server environments may work, they have not been tested.  Should you get another hosting environment working, please do a Pull Request at the hosted [A2J DAT](https://github.com/CCALI/A2JDAT) repo to let us know any steps taken so that we may share with others.

## Insatallation instructions

1.)  Install nvm  
The DAT is a simple restful API that requires nodejs to serve endpoints. Though, you are free to install the node version that the DAT targets and manage it manually, the recommended method is to use a node version manager which will allow the simultaneous installation of multiple versions of node and mitigates several administration issues.

Obtain nvm for windows here: https://github.com/coreybutler/nvm-windows

For \*nix go here: https://github.com/creationix/nvm

2.) Install node through nvm  
after installation of nvm, type the following commands in the terminal to install the required node version

```
nvm install 8.9.4
nvm use 8.9.4
```

check that the install was successful by typing

`node -v`

which should produce the version number of node we installed

#### For Windows Users:

##### Ensure Node is in PATH:  
The node installer might not always set the PATH variable correctly. Check Environment variables to ensure that there is an entry for the folder containing node.exe.  For this tutorial that folder is C:\Program Files\nodejs\.

##### Configure Node Permissions:  
Node.exe must be added to the IIS_IUSRS group in order to be allowed to handle requests. This must occur every time the node executable is switched through nvm. Open a command prompt and run as administrator and run
```icacls “%programfiles%\nodejs\node.exe” /grant IIS_IUSRS:rx```


3.) Install global DAT dependencies and subdependencies:  

Git is a source control manager and required for npm. This can be obtained through most \*nix package managers. For windows, install Git by downloading latest from
https://git-scm.com/download/win
As of this documents writing, the latest version for the system in the azure demo environment is located at:
https://github.com/git-for-windows/git/releases/download/v2.16.2.windows.1/Git-2.16.2-64-bit.exe


4.) Install build tools:  

The node sub-dependencies for the DAT must be built locally on the target system and requires build tools for languages other than node. Run the command below to install the necessary build tools:

##### For windows
use the command below to install
```npm --add-python-to-path='true' --debug install --global windows-build-tools```

This requires administrator access. This is a very lengthy install-  it can take over an hour even on a fast connection.

#### For all platforms run the command below

```npm install node-pre-gyp babel-cli steal-tools -g```


5.) Install wkhtmltopdf  
WKHTMLTOPDF is the engine used to transform interview data into PDF from an intermediate HTML file. Download the latest stable version from https://wkhtmltopdf.org/downloads.html  and install it in the VM. Make a note of the install path.

6.) Install node process manager  
The node process manager handles automatic restarts, memory mangement, monitoring, and error logging.

For All platforms:
The recommended process manager is pm2 (http://pm2.keymetrics.io/). Install it with the following command

`npm install pm2 -g`

##### Note to Windows users:  
Older versions of this project used iisnode (https://github.com/tjanczuk/iisnode) iisnode is no longer supported. For migration instructions go here: https://www.a2jauthor.org/content/migrate-pm2-iis

7.) Download the latest DAT from repo through git or from https://github.com/CCALI/A2JDAT/releases into your webroot or preferred directory on your web server.

8.) Compile from source instructions  

navigate to the downloaded location in a terminal and run the following commands in sequence
```
cd DAT
npm install
cd js
npm install bootstrap
cd ..
npm run build
npm run build:server
```

if you encounter an error in this step it can often be resolved by deleting node_modules in DAT and DAT\\js and repeating the step.

9.) Configure DAT
Since the A2J software can run on many platforms, there is a small amount of platform specific configuration that is necessary. Navigate to the root of the DAT in your websites folder. Open config.json

The Most important keys are:
SERVER_URL- required to establish target endpoints for API
GUIDES_DIR-  required to establish location of templates  
GUIDES_URL- relative web location of guides  
WKHTMLTOPDF_PATH- path to binary of WKHTMLTOPDF  

and these new keys:
VIEWER_PATH- path to viewer  
WKHTMLTOPDF_DPI- desired default dpi to render pdfs. CALI reccomends minimum of 300  
WKHTMLTOPDF_ZOOM- The correction factor used to render text pdfs. This is necessary to standardize rendering accross all platforms. On most \*nix systems this should be 1.000 and on most windows systems this should be 1.280.  

All other keys must be present but the value is irrelevant.

Ensure that the value for the key WKHTMLTOPDF_PATH matches the path noted above where WKHTMLTOPDF is installed. Backslashes are special characters in json so each backslash must be typed twice to escape them and work properly.

a sample config.json for windows is below:
```
{
  "SERVER_URL": "http://localhost",
  "GUIDES_DIR": "C:\\inetpub\\wwwroot\\a2j-viewer\\guides",
  "GUIDES_URL": "/a2j-viewer/guides",
  "SQL_HOST": "localhost",
  "SQL_USERNAME": "root",
  "SQL_PASSWD": "root",
  "SQL_DBNAME": "caja",
  "SQL_PORT": 3306,
  "DRUPAL_HOST": "localhost",
  "DRUPAL_USERNAME": "root",
  "DRUPAL_PASSWD": "root",
  "DRUPAL_DBNAME": "D7commons",
  "DRUPAL_PORT": 3306,
  "WKHTMLTOPDF_PATH": "C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf",
  "VIEWER_PATH": "C:\\inetpub\\wwwroot\\a2j-viewer\\viewer\\",
  "WKHTMLTOPDF_DPI": 300,
  "WKHTMLTOPDF_ZOOM": 1.280
}
```

a sample config.json for linux is below:
```
{
  "SERVER_URL": "http://localhost",
  "GUIDES_DIR": "/var/www/mysite.tld/a2j-viewer/guides",
  "GUIDES_URL": "/a2j-viewer/guides",
  "SQL_HOST": "localhost",
  "SQL_USERNAME": "root",
  "SQL_PASSWD": "root",
  "SQL_DBNAME": "caja",
  "SQL_PORT": 3306,
  "DRUPAL_HOST": "localhost",
  "DRUPAL_USERNAME": "root",
  "DRUPAL_PASSWD": "root",
  "DRUPAL_DBNAME": "D7commons",
  "DRUPAL_PORT": 3306,
  "WKHTMLTOPDF_PATH": "/usr/bin/local/wkhtmltopdf",
  "VIEWER_PATH": "/vol/data/sites/viewer.mysite.tld/a2j-viewer/viewer",
  "WKHTMLTOPDF_DPI": 300,
  "WKHTMLTOPDF_ZOOM": 1.000
}
```

10.) Configure the server  

The DAT is a simple restful interface with endpoints located at <host>/api/. Requests must be routed through the node /bin/www target. We will setup a reverse proxy to accomplish this.

for IIS/Windows below is an example web.config
```
<?xml version="1.0" encoding="UTF-8"?>
<!--
     This is an exampe configuration file for using the DAT with pm2
-->
<configuration>
    <system.webServer>
        <rewrite>
            <rules>
                <rule name="ReverseProxyInboundRule1" stopProcessing="true">
                    <match url="(api/.*)" />
                    <action type="Rewrite" url="http://localhost:3000/{R:1}" />
                </rule>
            </rules>
        </rewrite>
    </system.webServer>
</configuration>
```

for apache add the following directives to your site config

```
ProxyPass /api http://localhost:3000/api
ProxyPassReverse /api http://localhost:3000/api
ProxyBadHeader Ignore
```

for nginx add the following directives
```
Location /api {
    Proxy_pass http://127.0.0.1:3000/
}
```

11.)  Start the node process
for \*nix
navigate to the DAT folder in a terminal

`pm2 start npm --name “prod-api” -- run start`


## Security Note
This software uses a version of jquery with a known security vulnerability. The features required to exploit this vulnereability are not used in this software and hence it is not an issue.

## More info

To find out more about A2J Viewer and A2J Author® please see our website, [www.a2jauthor.org](https://www.a2jauthor.org/)

For questions, contact Tobias Nteireho at tobias@cali.org
