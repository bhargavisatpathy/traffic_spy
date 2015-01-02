Sequel.migration do
  change do
    add_column :user_agents, :browser, String
    add_column :user_agents, :os, String
  end
end

