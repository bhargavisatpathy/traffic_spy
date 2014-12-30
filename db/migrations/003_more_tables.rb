Sequel.migration do
  change do
    create_table(:urls) do
      primary_key   :id
      String        :url
    end

    create_table(:referred_bys) do
      primary_key   :id
      String        :referred_by
    end

    create_table(:request_types) do
      primary_key   :id
      String        :request_type
    end

    create_table(:event_names) do
      primary_key   :id
      String        :event_name
    end

    create_table(:user_agents) do
      primary_key   :id
      String        :user_agent
    end

    create_table(:resolutions) do
      primary_key   :id
      String        :width
      String        :height
    end

    create_table(:ips) do
      primary_key   :id
      String        :ip
    end
  end
end
