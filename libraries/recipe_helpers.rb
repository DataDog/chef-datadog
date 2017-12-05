class Chef
  # Helper class for Datadog Chef recipes
  class Datadog
    class << self
      def api_key(node)
        run_state_or_attribute(node, 'api_key')
      end

      def application_key(node)
        run_state_or_attribute(node, 'application_key')
      end

      def agent6?(node)
        if run_state_or_attribute(node, 'agent6') == true
          if run_state_or_attribute(node, 'hybrid') == true
            return node['ipaddress'].split('.')[-1].to_i.even?
          end
          return true
        end

        false
      end

      private

      def run_state_or_attribute(node, attribute)
        if node.run_state.key?('datadog') && node.run_state['datadog'].key?(attribute)
          node.run_state['datadog'][attribute]
        else
          node['datadog'][attribute]
        end
      end
    end
  end
end
