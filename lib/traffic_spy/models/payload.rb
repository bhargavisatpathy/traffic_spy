module TrafficSpy
  class Payload
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
        :parameters      => payload_hash["parameters"],
        :event_name_id   => EventName.event_names_table(payload_hash["eventName"]),
        :user_agent_id   => UserAgent.user_agents_table(payload_hash["userAgent"]),
        :resolution_id   => Resolution.find_resolution_id(payload_hash["resolutionWidth"], payload_hash["resolutionHeight"]),
        :ip_id           => Ip.ip_table(payload_hash["ip"]),
        :identifier_id   => Identifier.identifier_id_table(identifier))
    end
  end

end
