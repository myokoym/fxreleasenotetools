require "./parser"

markdown = ""

versions = Parser.new.parse
versions.each do |version|
  markdown << <<-MARKDOWN
* [Firefox #{version.version} リリースノート](#{version.url})
  MARKDOWN
  version.changes.each do |change|
    markdown << <<-MARKDOWN
  * #{change.description}
    MARKDOWN
  end
end

puts markdown
