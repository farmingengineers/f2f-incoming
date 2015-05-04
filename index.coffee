express = require 'express'

config =
  port: process.env.PORT || 5000

app = express()

# TODO - receive emails

# Send anyone else to the main website.
app.get '*', (request, response) ->
  response.redirect 301, "http://www.farmtoforkmarket.org"

app.listen config.port, ->
  console.log "App is running on port #{config.port}"
