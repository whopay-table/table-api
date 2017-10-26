FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs cron && rm -rf /var/lib/apt/lists/*

# App specific installations are run separately so previous is a reused container
# RUN apt-get install -y imagemagick && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

RUN gem install bundler && bundle install --jobs 20 --retry 5
whenever --update-crontab
