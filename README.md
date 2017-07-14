# gifhub

## Setup

1. Run `gem install sinatra`


## Running Locally

1. Run `rackup`

2. Create an ngrok tunnel to your local on port 9292 `ngrok http 9292`

3. Copy the ngrok link shown in the console

4. Update [Oath Application](https://github.com/settings/applications/514154) with the ngrok link + /callback

5. Update the Webhook (If one was created for the repo you are testing) with the ngrok link + /payload
