module TrafficSpy
  class Agent

    def self.table
      DB.from(:user_agents)
    end

    def self.find(incoming_user_agent)
      table.where(:user_agent => incoming_user_agent).first
    end

    def self.exists?(incoming_user_agent)
      !table.where(:user_agent => incoming_user_agent).empty?
    end

    def self.find_or_create(incoming_user_agent)
      if exists?(incoming_user_agent)
        user_agent_id = table.select(:id)
                             .where(:user_agent => incoming_user_agent)
                             .first[:id]
      else
        user_agent = UserAgent.parse(incoming_user_agent)
        browser = user_agent.browser
        os = user_agent.platform
        table.insert(:user_agent => incoming_user_agent,
                     :browser => browser,
                     :os => os)
        user_agent_id = table.from(:user_agents)
                             .where(:user_agent => incoming_user_agent)
                             .first[:id]
      end
      user_agent_id
    end

    def self.rank_browser(identifier)
      DB.from(:payloads)
        .select(:browser, :count)
        .where(:identifier_id => identifier[:id])
        .join(:user_agents, :id => :user_agent_id)
        .group_and_count(:browser)
        .order(Sequel.desc(:count)).to_a
    end

    def self.rank_os(identifier)
      DB.from(:payloads)
        .select(:os, :count)
        .where(:identifier_id => identifier[:id])
        .join(:user_agents, :id => :user_agent_id)
        .group_and_count(:os)
        .order(Sequel.desc(:count)).to_a
    end

  end
end
