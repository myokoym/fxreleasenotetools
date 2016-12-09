require "nokogiri"

require "./config"

class Firefox
  attr_reader :version, :changes, :url
  def initialize(version)
    @version = version
    @changes = []
  end

  def add(tag, description)
    @changes << Change.new(tag, description)
  end

  def url=(url)
    @url = url
  end

  class Change
    attr_reader :tag, :description
    def initialize(tag, description)
      @tag = tag
      @description = description
    end
  end
end

class Parser
  def initialize
  end

  def parse
    firefoxes = []
    Dir["#{DATA_DIR}/*"].sort_by {|v| File.basename(v, ".html") }.each do |path|
      firefox = Firefox.new(File.basename(path, ".html"))
      html = Nokogiri::HTML.parse(File.read(path))
      html.xpath('//comment()').remove
      firefox.url = html.xpath('//link[@rel="canonical"]/@href').text
      html.css("#sec-whatsnew > ul > li").each do |change|
        tag = change.css(".tag")
        next if tag.empty?
        firefox.add(tag.inner_text, change.css("p").inner_html)
      end
      firefoxes << firefox
    end
    firefoxes
  end

  def parse_dev
    firefoxes = []
    Dir["#{DATA_DIR}/*"].sort_by {|v| File.basename(v, ".html") }.each do |path|
      firefox = Firefox.new(File.basename(path, ".html"))
      html = Nokogiri::HTML.parse(File.read(path))
      html.xpath('//comment()').remove
      firefox.url = html.xpath('//link[@rel="canonical"]/@href').text
      html.css("#sec-whatsnew > ul > li").each do |change|
        tag = change.css(".tag")
        next if tag.empty?
        firefox.add(tag.inner_text, change.css("p").inner_html)
      end
      firefoxes << firefox
    end
    firefoxes
  end
end
