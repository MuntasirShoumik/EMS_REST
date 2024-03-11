
FROM ruby:3.0-bullseye as base

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
