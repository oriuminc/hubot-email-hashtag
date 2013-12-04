# Description
#   A hubot script that sends hashtagged messages to a specified email address.
#
# Configuration:
#   HUBOT_MAILGUN_APIKEY
#   HUBOT_MAILGUN_DOMAIN
#   HUBOT_EMAILTAG_TO_DOMAIN
#
# Commands:
#   zee message to send out #email:accounting - Emails message to accounting@yourdomain.com
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   patcon@myplanetdigital

Mailgun = require 'mailgun-js'
config =
  api_key: process.env.HUBOT_MAILGUN_APIKEY
  mg_domain: process.env.HUBOT_MAILGUN_DOMAIN
  to_domain: process.env.HUBOT_EMAILTAG_TO_DOMAIN

unless config.api_key
  console.log "Please set the HUBOT_MAILGUN_APIKEY environment variable."
unless config.mg_domain
  console.log "Please set the HUBOT_MAILGUN_DOMAIN environment variable."
unless config.to_domain
  console.log "Please set the HUBOT_EMAILTAG_TO_DOMAIN environment variable."

module.exports = (robot) ->
  robot.hear /#email:([\w\.-]+)/i, (msg) ->
    to = msg.match[1]
    from = msg.message.user.name
    room = msg.message.room

    mailgun = new Mailgun config.api_key, config.mg_domain

    email_data =
      from: "#{from} <noreply@#{config.to_domain}>"
      to: "#{to}@#{config.to_domain}"
      subject: "Slack message from #{from} in #{room}"
      text: msg.message.text

    mailgun.messages.send email_data, (error, response, body) ->
      if error?
        msg.send "Unable to send email to #{to}@#{config.to_domain}!"
      else
        msg.send "Email sent to #{to}@#{config.to_domain}!"
