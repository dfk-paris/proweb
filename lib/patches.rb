require "tiny_tds/client"

module TinyTds
  class Client
    def initialize(opts={})
      warn 'FreeTDS may have issues with passwords longer than 30 characters!' if opts[:password].to_s.length > 30
      raise ArgumentError, 'missing :username option' if opts[:username].to_s.empty?
      raise ArgumentError, 'missing :host option if no :dataserver given' if opts[:dataserver].to_s.empty? && opts[:host].to_s.empty?
      @query_options = @@default_query_options.dup
      opts[:appname] ||= 'TinyTds'
      opts[:tds_version] = TDS_VERSIONS_SETTERS[opts[:tds_version].to_s] || TDS_VERSIONS_SETTERS['71']
      opts[:login_timeout] ||= 60
      opts[:timeout] ||= 5
      opts[:encoding] = (opts[:encoding].nil? || opts[:encoding].downcase == 'utf8') ? 'UTF-8' : opts[:encoding].upcase
      opts[:port] ||= 1433
      opts[:dataserver] = "#{opts[:host]}:#{opts[:port]}" if opts[:dataserver].to_s.empty?

      opts[:timeout] = opts[:timeout].to_i

      connect(opts)
    end
  end
end
