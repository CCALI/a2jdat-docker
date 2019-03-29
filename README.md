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
