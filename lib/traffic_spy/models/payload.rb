module TrafficSpy
  class Payload

    def self.table
      DB.from(:payloads)
    end

    def self.by_id(id)
      table.where(:identifier_id => id)
    end

    def self.missing_payload?(incoming_data)
      incoming_data.nil? || incoming_data.empty?
    end

    def self.to_hash(json_data)
      JSON.parse(json_data)
    end

    def self.save_payload(payload_hash, identifier)
      table.insert(
        :url_id          => Url.find_or_create(payload_hash["url"]),
        :requested_at    => Time.parse(payload_hash["requestedAt"]),
        :responded_in    => payload_hash["respondedIn"],
        :request_type_id => RequestType.find_or_create(payload_hash["requestType"]),
        :referred_by_id  => ReferredBy.find_or_create(payload_hash["referredBy"]),
        :parameters      => payload_hash["parameters"].join(","),
        :event_name_id   => EventName.find_or_create(payload_hash["eventName"]),
        :user_agent_id   => Agent.find_or_create(payload_hash["userAgent"]),
        :resolution_id   => Resolution.find_or_create(payload_hash["resolutionWidth"],
                                                          payload_hash["resolutionHeight"]),
        :ip_id           => Ip.find_or_create(payload_hash["ip"]),
        :identifier_id   => Identifier.find(identifier)[:id]
      )
    end

    def self.create(incoming_data)
      if missing_payload?(incoming_data["payload"])
        return_hash = { status: 400,
                        body: "Missing Payload"
                      }
      elsif !Identifier.exists?(incoming_data["identifier"])
        return_hash = { status: 403,
                        body: "Application Not Registered"
                      }
      elsif duplicate_payload?(incoming_data["payload"])
        puts "DUPLICATE PAYLOAD"
        return_hash = { status: 403,
                        body: "Already received request"
                      }
      else
        save_payload(to_hash(incoming_data["payload"]), incoming_data["identifier"])
        return_hash = { status: 200,
                        body: ""
                      }
      end
    end

    def self.duplicate_payload?(payload)
      payload = JSON.parse(payload)
      return requested_at_exists?(payload["requestedAt"]) &&
             responded_in_exists?(payload["respondedIn"]) &&
             parameters_exists?(payload["parameters"])
    end

    def self.requested_at_exists?(data)
      !table.select(:requested_at)
           .where(:requested_at => data)
           .empty?
    end

    def self.responded_in_exists?(data)
      !table.select(:responded_in)
           .where(:responded_in => data)
           .empty?
    end

    def self.parameters_exists?(data)
      !table.select(:parameters)
           .where(:parameters => data.join(","))
           .empty?
    end
  end
end
