class Mock
    class ShellCommandResult
      @stdout = ''
      def initialize(stdout)
        @stdout = stdout
      end
      def stdout
        return @stdout
      end
    end
  end