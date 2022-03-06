FROM ruby:alpine
RUN apk add --update build-base postgresql-dev tzdata
COPY Gemfile Gemfile.lock ./
RUN bundle install