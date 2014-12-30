Sequel.migration do
  change do
    create_table(:identifiers) do
      primary_key   :id
      String        :rooturl
      Text          :identifier
    end
  end
end
