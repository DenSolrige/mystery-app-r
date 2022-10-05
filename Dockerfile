# FROM ruby

# WORKDIR /code

# COPY . /code

# RUN bundle install

# EXPOSE 4567

# CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]


# FROM ruby:2.5-alpine
# WORKDIR /app
# COPY . /app
# RUN bundle install -j $(nproc) --quiet

# FROM ruby:3.1.2-alpine
FROM ruby

COPY . /workspace

WORKDIR /workspace

# RUN gem install nio4r -v '2.5.8' --source 'https://rubygems.org/' 
# RUN gem install nio4r -v '1.2.1' -- --with-cflags="-Wno-error=implicit-function-declaration"
# RUN bundle config build.nio4r --with-cflags="-std=c99"
RUN bundle install

EXPOSE 9292

ENTRYPOINT ["bundle","exec","rackup"]