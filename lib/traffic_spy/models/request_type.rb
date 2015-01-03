module TrafficSpy
  class RequestType

    def self.table
      DB.from(:request_types)
    end

    def self.find(incoming_request_type)
      table.where(:request_type => incoming_request_type).first
    end

    def self.exists?(incoming_request_type)
      !table.where(:request_type => incoming_request_type).empty?
    end

    def self.find_or_create(incoming_request_type)
      if exists?(incoming_request_type)
        request_type_id = table.select(:id)
                               .where(:request_type => incoming_request_type)
                               .first[:id]
        puts "We found request type"
      else
        puts "we didn't find request type"
        table.insert(:request_type => incoming_request_type)
        request_type_id = table .where(:request_type => incoming_request_type)
                                .first[:id]
      end
      request_type_id
    end
  end
end
