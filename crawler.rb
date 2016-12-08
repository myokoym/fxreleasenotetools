#!/usr/bin/env ruby

require "fileutils"
require "net/https"
require "uri"

require "./config"

FileUtils.mkdir_p(DATA_DIR)

VERSIONS.each do |version|
  basename = "#{version}.html"
  output_path = File.join(DATA_DIR, basename)
  if File.exist?(output_path)
    $stderr.puts("#{basename} already exists.")
    next
  end

  path = BASE_PATH.sub("VERSION", version)
  uri = URI.parse("#{HOST_NAME}#{path}")
  res = nil
  5.times do
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    res = http.start do |h|
      h.get(uri.request_uri)
    end

    case res
    when Net::HTTPSuccess
      break
    when Net::HTTPRedirection
      uri = URI.parse(res["Location"])
      next
    else
      break
    end
  end
  sleep 0.5
  unless res.is_a?(Net::HTTPSuccess)
    $stderr.puts("#{path} is not found.")
    next
  end

  File.write(output_path, res.body)
end
