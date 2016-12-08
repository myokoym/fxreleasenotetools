require "nokogiri"

require "./config"

class Firefox
  attr_reader :version, :changes
  def initialize(version)
    @version = version
    @changes = []
  end

  def add(tag, description)
    @changes << Change.new(tag, description)
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
    Dir["#{DATA_DIR}/*"].each do |path|
      firefox = Firefox.new(File.basename(path, ".html"))
      html = Nokogiri::HTML.parse(File.read(path))
      html.css("#sec-whatsnew > ul > li").each do |change|
        tag = change.css(".tag")
        next unless tag
        firefox.add(tag.inner_text, change.css("p").inner_html)
      end
      firefoxes << firefox
    end
    firefoxes
  end
end
