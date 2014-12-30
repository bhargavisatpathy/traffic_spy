Sequel.migration do
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
