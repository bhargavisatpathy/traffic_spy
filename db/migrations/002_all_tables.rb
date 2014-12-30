Sequel.migration do
  change do
    create_table(:urls) do
      primary_key   :id
      String        :url
    end
  end

  change do
    create_table(:referred_bys) do
      primary_key   :id
      String        :referred_by
    end
  end

  change do
    create_table(:request_types) do
      primary_key   :id
      String        :request_type
    end
  end

  change do
    create_table(:event_names) do
      primary_key   :id
      String        :event_name
    end
  end

  change do
    create_table(:user_agents) do
      primary_key   :id
      String        :user_agent
    end
  end

  change do
    create_table(:resolutions) do
      primary_key   :id
      String        :width
      String        :height
    end
  end

  change do
    create_table(:ips) do
      primary_key   :id
      String        :ip
    end
  end

  change do
    create_table(:payloads) do
      primary_key   :id
      Integer       :url_id
      String        :requested_at
      Integer       :responded_in
      Integer       :referred_by_id
      Integer       :request_type_id
      String        :parameters
      Integer       :event_name_id
      Integer       :user_agent_id
      Integer       :resolution_id
      Integer       :ip_id
    end
  end
end
