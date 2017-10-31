#!/usr/bin/env ruby
require 'rubydns'
require 'trollop'


opts = Trollop::options do
      version "dnsshield v0.1a by @truekonrads"
      opt :zone, "Zone which to forward", :type => :string, :required => true
      opt :upstream, "Upstream DNS", :type=> :string, :required  => true
      opt :port, "Port to listen to", :type => :int, :default => 53
      opt :interface, "Interface to which to listen to", :type => :string, :default => "0.0.0.0"
      opt :loglevel, "Log level - DEBUG, INFO, etc", :type => :string, :default => "INFO"
      opt :filteraddress, "Which A record to filter for", :type => :string, :default => "0.0.0.0"
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

    match(/#{opts[:zone]}$/) do |transaction, match_data| 
        r = UPSTREAM.query(transaction.name, transaction.resource_class)
        # drop a specific, invalid response
        if (  r.answer.length>0 and 
              r.answer[0][2].respond_to?(:address) and
              r.answer[0][2].address.to_s==opts[:filteraddress]) then 
           transaction.fail!(:NXDomain)
        else
          transaction.response.merge!(r)
        end
    end

    otherwise do |transaction| 
        transaction.fail!(:Refused)        
    end
end
