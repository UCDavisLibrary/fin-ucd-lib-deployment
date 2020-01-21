

# Creating New Deployment

A fin application deployment is a series of docker containers tagged with a specific
version.  The config.sh file defines these versions.

To create a new deployment:
  - First, all images you wish to use for this deployment must be in dockerhub
    - Or like accessible docker image repository
  - Update the ```config.sh``` file with the updated container version numbers
  - Double check these version numbers
  - Uptick the main ```APP_VERSION``` number in ```config.sh```
  - Run ```./build.sh``` to create the final ```fin-ucd-server``` image
  - Run ```./push.sh``` to push the new ```fin-ucd-server``` image to dockerhub
    - Note: The ```fin-ucd-server``` will be tagged with the ```APP_VERSION```
  - Run ```./generate.sh``` to create a new ```docker-compose.yaml``` file with updated version numbers
  - Commit your changes to this repo to GitHub
  - Tag your commit with the same version number as APP_VERSION

# Running a Deployment

To run a fin application deployment:
  - Pull this repository
  - Checkout tag for version of application you wish to run
  - run ```docker-compose up``` in root directory

If you were already running a deployment make sure and
  - docker-compose down
  - docker-compose pull

Then run ```docker-compose up``` in the root directory

# Verifing a Deployment

The ```config.sh``` versions should match the running container versions.  Additionaly ```/fin/info``` will show you all tagged container versions as well as all running services