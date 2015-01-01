module TrafficSpy
  class Identifier
    def self.save_identifier(incoming_data)
      DB.from(:identifiers).insert(:identifier => incoming_data["identifier"],
                                   :rooturl => incoming_data["rootUrl"])
    end

    def self.exists?(identifier)
      DB.from(:identifiers).select(:identifier).to_a.any? { |item| item[:identifier] == identifier}
    end

    def self.missing_identifier?(incoming_data)
      incoming_data["identifier"].nil? || incoming_data["rootUrl"].nil?
    end

    def self.identifier_id_table(incoming_identifier)
      DB.from(:identifiers).select(:id).where(:identifier => incoming_identifier).to_a[0][:id]
    end

    def self.register(incoming_data)
      if missing_identifier?(incoming_data)
        return_hash = { status: 400,
                        body:   "Missing parameters\n"
                      }
      elsif exists?(incoming_data["identifier"])
        return_hash = { status: 403,
                        body:   "Identifier already exists\n"
                      }
      else
        save_identifier(incoming_data)
        return_hash = { status: 200,
                        body: {identifier: incoming_data["identifier"]}.to_json
                      }
      end
     return_hash
    end
  end
end
