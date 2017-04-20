# README
See archive with source code attached.

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
  rake import:drop_broken
  rake import:geodatum
  rake geocode:encode_zip
  rake searchkick:reindex:all

* Setting up application on Heroku
  heroku create
  heroku buildpacks:set https://github.com/Ignitewithus/heroku-buildpack-mdbtools.git
  heroku buildpacks:add --index 2 heroku/ruby
  heroku addons:create bonsai:sandbox-10
  heroku config:set ELASTICSEARCH_URL=`heroku config:get BONSAI_URL`
  git push heroku master
  heroku run rake db:migrate
  heroku run rake db:seed
  heroku run rake searchkick:reindex:all
  heroku run rake import:program_information
  heroku run  rake import:coordinator_information
  heroku run rake import:drop_broken
  heroku run rake import:geodatum
  heroku run rake geocode:encode_zip
  heroku run rake searchkick:reindex:all

in case of error like  code=H14 desc="No web processes running" 
heroku ps:scale web=1
* Deployment instructions
git push heroku master

