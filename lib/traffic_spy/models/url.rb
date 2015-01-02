module TrafficSpy
  class Url
    def self.url_id_table(incoming_url)
      if DB.from(:urls).select(:url).to_a.any? {|item| item[:url] == incoming_url }
        url_id = DB.from(:urls).select(:id).where(:url => incoming_url).to_a[0][:id]
        puts "We found URL ID"
      else
        puts "we didn't find URL ID"
        DB.from(:urls).insert(:url => incoming_url)
        url_id = DB.from(:urls).where(:url => incoming_url).to_a[0][:id]
      end
      url_id
    end

    def self.rankurl(identifier)
      identifier_id = DB.from(:identifiers)
                        .select(:id)
                        .where(:identifier => identifier)
      puts identifier_id.to_a
      DB.from(:payloads)
        .where(:identifier_id => identifier_id)
        .join(:urls, :id => :url_id)
        .group_and_count(:url)
        .order(Sequel.desc(:count)).to_a
        .map { |entry| [entry[:url],entry[:count]] }
    end

    end
end
