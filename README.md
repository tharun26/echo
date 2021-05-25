# Echo Application
## Introduction

Echo is a application which allows users to create endpoints for themself and  let's them hit the corresponding endpoints to get the response they provided while creating.

### Tech

Echo uses a number of open source projects to work as expected:

- [Ruby on Rails] - Server-side web application framework
- [POSTGRESQL] - Relational database management system (RDBMS)
- [Redis] - In Memeory Cache server 
##### Prerequisites

The setups steps expect following tools installed on the system.

- Ruby [2.6.3]
- Rails [6.1.3.2]
- Postgresql [13.1]
- Redis [6.2.3]

##### 1. Commands to execute

```bash
bundle install
yarn install
```

##### 2. Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

```bash
cp config/database.yml.sample config/database.yml
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.
Run postgres server using postgresapp [Version 2.4.1 (100)]

```ruby
createuser -s db_user_name
bundle exec rake db:create
bundle exec rake db:setup
bundle exec rake db:migrate
```

##### 4. Install redis server and run redis-server

```bash
brew install redis
redis-server /usr/local/etc/redis.conf
```

##### 5. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can start hitting http://localhost:3000 using postman collection provided
along with application.
PostMan Collection: https://www.getpostman.com/collections/dfd33b437f447f66ec8f
##### 


#### Unit Testing

##### Following commnds needs to be executed to run Unit test cases 

```sh
bin/rails db:environment:set RAILS_ENV=test
bundle exec rspec
```