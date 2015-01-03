module TrafficSpy
  class Url
    def self.table
      DB.from(:urls)
    end

    def self.get_id(incoming_url)
      table.where(:url => incoming_url).to_a[0][:id]
    end

    def self.url_id_table(incoming_url)
      if table.select(:url).to_a.any? {|item| item[:url] == incoming_url }
        url_id = table.select(:id).where(:url => incoming_url).to_a[0][:id]
        puts "We found URL ID"
      else
        puts "we didn't find URL ID"
        table.insert(:url => incoming_url)
        url_id = table.where(:url => incoming_url).to_a[0][:id]
      end
      url_id
    end

    def self.rank_url(identifier_id)
      DB.from(:payloads)
        .select(:url, :count)
        .where(:identifier_id => identifier_id)
        .join(:urls, :id => :url_id)
        .group_and_count(:url)
        .order(Sequel.desc(:count)).to_a
    end

  end
end
