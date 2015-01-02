module TrafficSpy
  class UserAgent

    def self.table
      DB.from(:user_agents)
    end

    def self.user_agents_table(incoming_user_agent)
      if DB.from(:user_agents).select(:user_agent).to_a.any? {|item| item[:user_agent] == incoming_user_agent }
        user_agent_id = DB.from(:user_agents).select(:id).where(:user_agent => incoming_user_agent).to_a[0][:id]
        puts "We found user agents"
      else
        puts "we didn't find user agents"
        browser = incoming_user_agent.split(' ')[0]
        puts browser
        os = incoming_user_agent.split(' ')[1][1..-2]
        puts os
        table.insert(:user_agent => incoming_user_agent,
                     :browser => browser,
                     :os => os)
        user_agent_id = table.from(:user_agents).where(:user_agent => incoming_user_agent).to_a[0][:id]
      end
      user_agent_id
    end

    def self.browserlist
      table.select(:browser).to_a
                .map { |item| item[:browser] }
                .uniq
    end

    def self.browser_rank(id)
      puts browserlist.inspect
      b_and_id = browserlist.map do |browser|
        [browser, table.select(:id).where(:browser => browser)]
        end
      puts b_and_id.inspect
      puts id
      puts Identifier.get_id(id)
      sel_pay = Payload.by_id(Identifier.get_id(id))
      puts sel_pay.to_a

      b_and_id = b_and_id.map do |item|
        [item[0],item[1].to_a]
      end
      b_and_id.map do |id|
        puts id[1].inspect
      end
      return nil
    end


  end
end
