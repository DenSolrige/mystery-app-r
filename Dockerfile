FROM ruby

COPY . /workspace

WORKDIR /workspace

RUN bundle install

EXPOSE 9292

ENTRYPOINT ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "9292"]