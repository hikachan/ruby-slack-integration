require "ruby/slack/integration/version"
require "opml_saw"
require "slack"
require "pp"
require 'yaml'

module Integration
  def self.opmlParse(filename)
    file = File.open(filename, 'r')
    contents = file.read
    opml = OpmlSaw::Parser.new(contents)
    opml.parse
    pp opml.feeds
  end
end

module SlackIntegration
  class SlackApi
    def initialize
      token = ENV["TOKEN"] || (print "Token: "; gets.strip)
      @@client = Slack::Client.new token: token
    end

    def getUsers
      users = Hash[@@client.users_list["members"].map{|m| [m["id"], m["name"]]}]
    end
  end
end

slackClient = SlackIntegration::SlackApi.new
puts "Get users list"
puts YAML.dump slackClient.getUsers

#filename = 'rsslist.opml'
#Integration.opmlParse(filename)
