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
  end
end
