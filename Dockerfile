# Pre setup stuff
FROM ruby:2.7 as builder

# Add Yarn to the repository
RUN curl https://deb.nodesource.com/setup_12.x | bash     && curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -     && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install system dependencies & clean them up
RUN apt-get update -qq && apt-get install -y \
  postgresql-client build-essential yarn nodejs \
  libnotify-dev && \
  rm -rf /var/lib/apt/lists/*

# This is where we build the rails app
FROM builder as rails-app

# Allow access to port 3000
EXPOSE 3000
EXPOSE 3035

# Set APP_DIR arg
ARG APP_DIR=/myapp

# Remove existing running server
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Directory stuff
RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

# Install rails related dependencies
COPY Gemfile* $APP_DIR/

# For webpacker / node_modules
COPY package.json $APP_DIR
COPY yarn.lock $APP_DIR

RUN gem install bundler
RUN bundle install
RUN yarn install --check-files

# Copy over all files
COPY . .

ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]