FROM ruby:2.7 as builder
WORKDIR /app
COPY Gemfile Gemfile.lock junoser.gemspec ./
ADD lib lib/
ADD exe exe/
RUN bundle config --global frozen 1
RUN bundle install

FROM ruby:2.7-slim
WORKDIR /app
COPY --from=builder /app/ /app/
COPY --from=builder $GEM_HOME/ $GEM_HOME/
RUN groupadd -r junoser && useradd --no-log-init -r -g junoser junoser

USER junoser
EXPOSE 4567
CMD ["bundle", "exec", "exe/junoser-http", "-s", "Puma", "-e", "production"]
