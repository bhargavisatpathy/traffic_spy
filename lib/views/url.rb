module TrafficSpy
  class Url
    def self.table
      DB.from(:urls)
    end

    def self.find(incoming_url)
      table.where(:url => incoming_url).first
    end

    def self.exists?(incoming_url)
      !table.where(:url => incoming_url).empty?
    end

    def self.find_or_create(incoming_url)
      if exists?(incoming_url)
        url_id = table.select(:id).where(:url => incoming_url).first[:id]
        puts "We found URL ID"
      else
        puts "we didn't find URL ID"
        table.insert(:url => incoming_url)
        url_id = table.where(:url => incoming_url).first[:id]
      end
      url_id
    end

    def self.rank_url(identifier)
      DB.from(:payloads)
        .select(:url, :count)
        .where(:identifier_id => identifier[:id])
        .join(:urls, :id => :url_id)
        .group_and_count(:url)
        .order(Sequel.desc(:count)).to_a
    end

    def self.rank_url_by_reponse_time(identifier)
      # DB.from(:payloads)
      #   .select(:url, avg(:responded_in))
      #   .where(:identifier_id => identifier_id)
      #   .join(:urls, :id => :url_id)
      #   .group_by(:url)
      #   .to_a
        # .order(Sequel.desc(:avg)).to_a
      DB.fetch("select url, avg(responded_in) from payloads pl join urls u on pl.url_id = u.id where pl.identifier_id = #{identifier[:id]} group by u.url order by avg desc")
    end

    def longest_response_time(identifier, url)
      DB.from(:payloads)
        .where(:identifier_id => identifier[:id], :url => url)
        .join(:urls, :id => :url_id)
        .max(:responded_in)
    end
  end
end
