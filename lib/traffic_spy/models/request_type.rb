module TrafficSpy
  class RequestType

    def self.table
      DB.from(:request_types)
    end

    def self.get_id(incoming_request_type)
      table.where(:request_type => incoming_request_type).to_a[0][:id]
    end

    def self.find_request_type_id(incoming_request_type)
      if table.select(:request_type).to_a.any? {|item| item[:request_type] == incoming_request_type }
        request_type_id = table.select(:id).where(:request_type => incoming_request_type).to_a[0][:id]
        puts "We found request type"
      else
        puts "we didn't find request type"
        table.insert(:request_type => incoming_request_type)
        request_type_id = table .where(:request_type => incoming_request_type)
                                .to_a[0][:id]
      end
      request_type_id
    end
  end
end
