FROM ruby:2.3.3
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs
#EXPOSE 3000 1234 26162
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile .
ADD Gemfile.lock .
#ENV BUNDLE_JOBS=4 \
#    BUNDLE_PATH=/bundle
RUN bundle install
ADD . .

