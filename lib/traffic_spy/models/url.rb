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

    def self.longest_response_time(identifier, url)
      DB.from(:payloads)
        .where(:identifier_id => identifier[:id], :url => url)
        .join(:urls, :id => :url_id)
        .max(:responded_in)
    end

    def self.shortest_response_time(identifier, url)
      DB.from(:payloads)
        .where(:identifier_id => identifier[:id], :url => url)
        .join(:urls, :id => :url_id)
        .min(:responded_in)
    end

    def self.average_response_time(identifier, url)
      DB.from(:payloads)
        .where(:identifier_id => identifier[:id], :url => url)
        .join(:urls, :id => :url_id)
        .avg(:responded_in)
    end

    def self.http_verbs(identifier, url)
      request_type_ids = DB.from(:payloads)
                           .select_group(:request_type_id)
                           .where(:identifier_id => identifier[:id], :url => url)
                           .join(:urls, :id => :url_id)

      DB.from(:request_types)
        .select(:request_type)
        .join(request_type_ids, :request_type_id => :id)
        .map { |row| row[:request_type] }
    end

    def self.popular_referrers(identifier, url)
      referrer_ids = DB.from(:payloads)
                      .select(:referred_by_id, :count)
                      .where(:identifier_id => identifier[:id], :url => url)
                      .join(:urls, :id => :url_id)
                      .group_and_count(:referred_by_id)
                      .order(Sequel.desc(:count))

      DB.from(:referred_bys)
        .select(:referred_by)
        .join(referrer_ids, :referred_by_id => :id)
        .map { |row| row[:referred_by] }
    end
  end
end
