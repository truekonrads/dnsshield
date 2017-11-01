# dnsshield
A tiny DNS forwarder that "shields" other, perhaps insecure, DNS servers

## Usage
```
  $ ruby ./dnsshield.rb --help
  dnsshield v0.1a by @truekonrads
  Options:
    -z, --zone=<s>         Zone which to forward (it's a regex)
    -u, --upstream=<s>     Upstream DNS
    -p, --port=<i>         Port to listen to (default: 53)
    -i, --interface=<s>    Interface to which to listen to (default: 0.0.0.0)
    -l, --loglevel=<s>     Log level - DEBUG, INFO, etc (default: INFO)
    -v, --version          Print version and exit
    -h, --help             Show this message

  $ ruby ./dnsshield.rb --zone my.upstream.zone --upstream 10.1.2.3 --port 54 --loglevel INFO
```

## Installation on a recent Ubuntu
```
sudo apt-get install git ruby ruby-dev ruby-bundler
sudo apt-get build-dep ruby
git clone https://github.com/truekonrads/dnsshield/
cd dnsshield
bundle
sudo -E ruby ./dnsshield.rb -l DEBUG -z 'your\.dnszone\.com$' -u 1.2.3.4
```
