# Getting started

This project is a web application responsible to manage rooms and appointments for these rooms.

It is required that you have installed docker and docker-compose to properly serve the application.

To start the application, you will need to run these commands:

```sh
$ docker-compose build --no-cache
$ docker-compose up -d
$ docker-compose exec rails sh -c "bin/rake db:setup"
$ docker-compose exec rails sh -c "bin/rails s -b 0.0.0.0"
```

# Description of the solution

There is 2 models in this project:

* Room: Represents the meeting room
* Appointment: Represents an appointment for a specific room

The room can have N appointments, but these appointments must follow some rules:

* The appointments can't overlap the scheduled time
* The appointments can't have a scheduled time that occurs in 2 different days
* The appointments can only be scheduled on monday to friday at 9:00 to 18:00

The gem https://github.com/bokmann/business_time was used to control the schedule times for the appointments.

A complete list of the implemented endpoints can be found at http://localhost:3000/api-docs/index.html.

The application has 100% of code coverage and can be checked by running the following command:
```sh
$ docker-compose exec rails sh -c "COVERAGE=on bundle exec rspec"
```

The default language of the application is english, but it can be changed to brazilian portuguese by passing the param `locale=pt-BR` in the requests.