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

      private

      def run_state_or_attribute(node, attr)
        if node.run_state.key?('datadog') && node.run_state['datadog'].key?(attr)
          node.run_state['datadog'][attr]
        else
          node['datadog'][attr]
        end
      end
    end
  end
end
