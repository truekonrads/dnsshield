#!/usr/bin/env ruby
require 'rubydns'
require 'trollop'


opts = Trollop::options do
      version "dnsshield v0.1a by @truekonrads"
      opt :zone, "Zone which to forward (it's a regex)", :type => :string, :required => true
      opt :upstream, "Upstream DNS", :type=> :string, :required  => true
      opt :port, "Port to listen to", :type => :int, :default => 53
      opt :interface, "Interface to which to listen to", :type => :string, :default => "0.0.0.0"
      opt :loglevel, "Log level - DEBUG, INFO, etc", :type => :string, :default => "INFO"
end

UPSTREAM = RubyDNS::Resolver.new([[:udp, opts[:upstream], 53], [:tcp, opts[:upstream], 53]])
INTERFACES = [
    [:udp, opts[:interface], opts[:port]],
    [:tcp, opts[:interface], opts[:port]],
]

RubyDNS::run_server(:listen => INTERFACES) do
    on(:start) do
      @logger.level = eval("Logger::#{opts[:loglevel]}")
    end

    match(/#{Regexp.new(opts[:zone])}/) do |transaction, match_data| 
        transaction.passthrough!(UPSTREAM)        
    end

    otherwise do |transaction| 
        transaction.fail!(:Refused)        
    end
end