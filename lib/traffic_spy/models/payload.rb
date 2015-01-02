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
      DB.from(:payloads).insert(
        :url_id          => Url.url_id_table(payload_hash["url"]),
        :requested_at    => payload_hash["requestedAt"],
        :responded_in    => payload_hash["respondedIn"],
        :request_type_id => RequestType.find_request_type_id(payload_hash["requestType"]),
        :referred_by_id  => ReferredBy.referred_by_table(payload_hash["referredBy"]),
        :parameters      => payload_hash["parameters"].join(","),
        :event_name_id   => EventName.event_names_table(payload_hash["eventName"]),
        :user_agent_id   => UserAgent.user_agents_table(payload_hash["userAgent"]),
        :resolution_id   => Resolution.find_resolution_id(payload_hash["resolutionWidth"], payload_hash["resolutionHeight"]),
        :ip_id           => Ip.ip_table(payload_hash["ip"]),
        :identifier_id   => Identifier.identifier_id_table(identifier))
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
      DB.from(:payloads).select(:requested_at).to_a
                        .any? {|item| item[:requested_at] == data}
    end

    def self.responded_in_exists?(data)
      DB.from(:payloads).select(:responded_in)
                        .to_a.any? { |item| item[:responded_in] == data }
    end

    def self.parameters_exists?(data)
      DB.from(:payloads).select(:parameters)
                        .to_a.any? { |item| item[:parameters] == data.join(",") }
    end
  end
end
