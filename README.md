Bugzilla


Description

Bugzilla is basically responsible for tracking of bugs and features. It consists of three types of users which are manager, QA and developer. Manager is responsible for creation, deletion and updation of project and can also add QAs and developers to the project. QA can create, update and delete the bug of project and Developer can pick a bug from the projects in which he is enrolled and mark it resolved.


Technologies

The technologies used for the development of this project are Ruby on Rails, Bootstrap and JQuery.


How to run this project

1- Install Ruby 2.7.2
2- Install Rails 5.2.8
3- Install postgresql in your machine.
4- Run bundle install
5- Run rails g devise:install
6- Run rails g ActiveStorage:install
7- Run rake db:create
8- Run rake db:migrate
9- Run rake db:seed
10- Setup Cloudinary credentials and save credentials in credentials.yml.
11- Run rails s to start the rails server.
