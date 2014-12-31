Sequel.migration do
  change do
    add_column :payloads, :identifier_id, Integer
  end
end
