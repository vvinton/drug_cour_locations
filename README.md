# README

* Ruby version 2.3.3

* System dependencies :
  PostgreSQL
  ElasticSearch
  mdbtoops

* Configuration: nothing special
  bundle install

* Database creation and setup (The order is important):
  rake db:create
  rake db:migrate
  rake db:seed
  rake searchkick:reindex:all
  rake import:program_information
  rake import:coordinator_information
  rake import:program_information
  rake import:drop_broken
  rake import:geodatum
  rake geocode:encode_zip
  rake searchkick:reindex:all

* Deployment instructions
  git push heroku master

