# dnsshield
A tiny DNS forwarder that "shields" other, perhaps insecure, DNS servers

## Usage
```
  $ ruby ./dnsshield.rb --help
  dnsshield v0.1a by @truekonrads
  Options:
    -z, --zone=<s>         Zone which to forward
    -u, --upstream=<s>     Upstream DNS
    -p, --port=<i>         Port to listen to (default: 53)
    -i, --interface=<s>    Interface to which to listen to (default: 0.0.0.0)
    -l, --loglevel=<s>     Log level - DEBUG, INFO, etc (default: INFO)
    -v, --version          Print version and exit
    -h, --help             Show this message

  $ ruby ./dnsshield.rb --zone my.upstream.zone --upstream 10.1.2.3 --port 54 --loglevel INFO
```
