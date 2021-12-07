FROM ruby:2.7.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs && gem install bundler
RUN mkdir -p /usr/src/3s-api
WORKDIR /usr/src/3s-api
COPY Gemfile /Gemfile
COPY Gemfile.lock ./Gemfile.lock
RUN bundle install
COPY . .

ENV RAILS_ENV='production'
ENV RAILS_SERVE_STATIC_FILES true
ENV RAILS_LOG_TO_STDOUT true

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
