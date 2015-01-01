module TrafficSpy
  class RequestType
    def self.find_request_type_id(incoming_request_type)
      if DB.from(:request_types).select(:request_type).to_a.any? {|item| item[:request_type] == incoming_request_type }
        request_type_id = DB.from(:request_types).select(:id).where(:request_type => incoming_request_type).to_a[0][:id]
        puts "We found request type"
      else
        puts "we didn't find request type"
        DB.from(:request_types).insert(:request_type => incoming_request_type)
        request_type_id = DB.from(:request_types).where(:request_type => incoming_request_type).to_a[0][:id]
      end
      request_type_id
    end
  end
end
