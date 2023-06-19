FROM elixir:1.14

RUN apt-get install curl git -y

# Needed to generate project
RUN mix local.hex --force && mix local.rebar --force
RUN mix archive.install hex phx_new --force
# RUN mix phx.new app1 --no-html --no-assets --no-live --no-dashboard --no-mailer --binary-id