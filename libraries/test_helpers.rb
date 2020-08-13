class Mock
  class ShellCommandResult
    @stdout = ''
    def initialize(stdout)
      @stdout = stdout
    end

    attr_reader :stdout
  end
end
