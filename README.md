# Phabricator Docker

Unofficial **Phabricator** Docker Image.

## Phabricator

is a collection of web applications which help software companies build better software.

Phabricator includes applications for:

- reviewing and auditing source code;
- hosting and browsing repositories;
- tracking bugs;
- managing projects;
- conversing with team members;
- assembling a party to venture forth;
- writing stuff down and reading it later;
- hiding stuff from coworkers; and
- also some other things.

You can learn more about the project (and find links to documentation and resources) at [Phacility](https://www.phacility.com/ "Phacility").

### Special Thanks

in this Image i used php configuration which handled in this [GitHub Repo](https://github.com/phabricator-docker/phabricator, "GitHub Repo") which has their own [Docker Stack](https://hub.docker.com/u/phabricator/ "Docker Stack") and you can use it if you want.

### Whats New

this Image provides:

- **Phabricator** Web access using apache;
- Configure **Phabricator** as Self hosted Version Control System because of [Phabricator Docs](https://secure.phabricator.com/book/phabricator/article/diffusion/, "Phabricator Docs"):

 > hosted repositories support some additional triggers and access controls which are not available for observed repositories;

- Configure HTTP Repository acessing because it's easy to Configure and Use :blush:
- Configure **Phabricator** for local file hosting;
- Add Support for Configuring DB Connection info at runtime;
- Configure base URI at runtime;

### How to Use

pulling latest docker image:

```bash
docker pull saherelm/phabricator
```

run container:

```bash
docker container run -d \
    -p $PORT:80 \
    -v $REPO_VOLUME:/var/repo \
    -v $FILES_VOLUME:/var/files \
    -e BASE_URI=$YOUR_BASE_URI \
    -e DB_HOST=$MYSQL_SERVE_ADDRES \
    -e DB_PORT=$MYSQL_SERVE_PORT \
    -e DB_USER=$MYSQL_SERVE_USER \
    -e DB_PASS=$MYSQL_SERVE_PASS \
    --network $YOUR_NETWORK \
    --restart always \
    --name $CONTAINER_NAME \
    saherelm/phabricator:latest
```

#### Notice

- change these values with your own:
  - $PORT
  - $REPO_VOLUME
  - $FILES_VOLUME
  - $YOUR_BASE_URI
  - $MYSQL_SERVE_ADDRES
  - $MYSQL_SERVE_PORT
  - $MYSQL_SERVE_USER
  - $MYSQL_SERVE_PASS
  - $CONTAINER_NAME
  - $YOUR_NETWORK

since your mysql server may be a Container running inside host maching or any cluster,
i highly recommend to prepare a Custom Network and assign your container to it for named containers acess abilit.

### What to do after Container start

**Phabricator** guides you for step by step configuration. and there is nothin unusual for you to do. but i recommend some steps because in my experience if you accesss easily to a quick starter app and use it for few times then reconfiguring it is so easy.

#### Create Admin User

when you open Phabricator for first time, it ask you to Create an admin user by providing:

- Username
- Real Name
- Email

then shows you a bunch of Setup Issues.

#### Configure Auth Provider

- click on top left **!** icon to show setup issues;
- select **No Authentication Providers Configured**;
- in issue description page, click on **Auth Application** to open **Login and Registration Providers** page.
- click on **Add Provider**;
- select **Username/Password** from presented auth providers;
- uncheck all items except **Allow Login**;
- click on **Save Changes**;
- now connect to Phabricator Container bash:

don't forget to replace **$VAR** with your own values.

```bash
docker exec -it $CONTAINER_NAME /bin/bash
```

- lock auth in phabricator by issuing following command:

```bash
auth lock
```

- now you have to set a password for admin user, issue this command:

```bash
auth recover $USER_NAME
```

- it will show you a link address for recovering selected user's password, open it in your browser and finally set admin user's password;
- ignore other setup issues for quick start;

#### Last Step

the last step is set **VSC Password**, for this navigate to Setting => VSC Password and set a Unique passwrod for admin user wich user in http authentication in VCS workflows.

**Notice** this password must be different password from your account which ueed for Login.

Finish, Enjoy Power of **Phabricator**.

### Tags

at the moment there is no other tags except latest which is default tag.

### Github

https://github.com/saherelm/PhabricatorDocker

### DockerHub

https://hub.docker.com/r/saherelm/phabricator

### Maintainer

Hadi Khazaee asl

<https://www.saherelm.ir>

hadi_khazaee_asl@yahoo.com

## Donate

- Bitcoin: 1BPiiHErBEca61BxtiVqVPdf1irvxpg9Yt
