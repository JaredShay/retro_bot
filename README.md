# RetroBot

Simple bot that remembers retro items for your team.

## Commands
```
retro <positive|negative|change|question> # add items
retro <positives|negatives|changes|questions> # list items
retro all # list all items
retro delete # delete all items
```

## Getting Started

Simplest way to get slack talking to the bot is to deploy it to heroku then
configure a webhook integration to send a POST request to the url. You'll also
need to install the redis-to-go heroku add-on and set the SLACK_TOKEN
environment variable.
