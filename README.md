# What is this about?

This project is a solution to home assignment https://you.ashbyhq.com/elevate-labs/assignment/660612c6-3e00-403e-a16c-7cbc357462f8

# View API docs

1) go to the `/docs` folder
2) run `npm install`
3) run `npm run view`
4) go to the http://localhost:5000 to see the docs in action

# Run API
## For the 1st time
0) Assuming you have on your machine
  - `ruby` (recommended 3.3.2 but anything around version 3 should work). Feel free to use https://rvm.io/ to get started with that. Once you install rvm, you would just need to `cd` into the project folder and follow the prompts
  - `postgresql` (see `config/database.yml` to place your credentials for that). You may use `brew` to install `postgresql`
1) go to the project root
2) execute
```
gem install bundler
bundle install
rails db:create
rails db:migrate
rails db:seed
rails s
```

## When the project is already set up
```
rails s
```

# Run tests
```bundle exec rspec spec```

# Authentication
To make authenticated request, just make sure to sign your user in using
`POST auth/sessions` with `email` and `password` in params. Get the `token` from `response.body` and attach it as a header to an authenticated endpoint request:
`Authorization: Bearer <your token goes here>`

# Implementation details

This is `rails8` project running on `ruby-3.3.2`. 
We use `postgres` as database and Bearer authentication schema. 
There is api doc available in `docs` folder that can be rendered on demand. 