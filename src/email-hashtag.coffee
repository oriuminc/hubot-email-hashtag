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

api_key = process.env.HUBOT_MAILGUN_APIKEY
mg_domain = process.env.HUBOT_MAILGUN_DOMAIN

to_domain = process.env.HUBOT_EMAILTAG_TO_DOMAIN



module.exports = (robot) ->
  robot.hear /#email:([\w\.-]+)/i, (msg) ->
    to = msg.match[1]
    from = msg.message.user.name
    room = msg.message.room

    mailgun = new Mailgun api_key, mg_domain

    email_data =
      from: "#{from} <noreply@#{to_domain}>"
      to: "#{to}@#{to_domain}"
      subject: "Slack message from #{from} in #{room}"
      text: msg.message.text

    mailgun.messages.send data, (error, response, body) ->
      if error?
        msg.send "Unable to send email!"
      else
        msg.send "Email sent to #{to}@#{to_domain}!"
