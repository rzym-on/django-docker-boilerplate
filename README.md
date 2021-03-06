# django-docker-boilerplate

Boilerplate, that I use for Django, Docker, Nginx, Postgres projects to run locally and deploy on server.

# Instructions

1. Install python3

2. Install virtualenv, create and activate it:

```
>pip install virtualenv
>virtualenv venv
>venv\Scripts\activate.ps1
```

3. Install requirements:

```
>pip install -r ./tools/requirements.txt
```

4. Create your django project:

```
>django-admin startproject djangoplateapp
```

5. Copy `env.template` file, give it name `env` and edit it following to comments inside it.

6. Copy files:

   > tools/paste-to-project/settings.py --> djangoplateapp/djangoplateapp/settings.py
   > tools/paste-to-project/docker-entrypoint.sh --> djangoplateapp/docker-entrypoint.sh
   > tools/paste-to-project/wait-for-it.sh --> djangoplateapp/wait-for-it.sh

   And delete `paste-to-project` folder

7. Change all names in this repo (omitting `README.md`) with following pattern:

- `plate_app` - your app name with underscores (only for docker)
- `plate.app` - your app name with dots (only for docker)
- `djangoplateapp` - your created Django project name

8. Run command:

```
>docker-compose up --build
```

# Building and pushing to image registry

if you want to build and push image to your image registry via GitHub Actions on `master` branch push, leave `.github` directory here,
go to your GitHub repo `Settings`, then go to `Secrets` tab, and add these 2 secrets:

- `REGISTRY_LOGIN` - login to your docker registry
- `REGISTRY_TOKEN` - secret token generated in your docker registry

Next, change `user_name` to your image registry url (username in case of DockerHub) in `.github/workflows/build.yml`

Now every time you push some changes to master, GitHub Actions will build image, and add it to your image registry.
This will allow you to pull only prepared and latest image from server side.
