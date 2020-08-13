class Mock
  class ShellCommandResult
    @stdout = ''
    def initialize(stdout)
      @stdout = stdout
    end

    def stdout
      @stdout
    end
  end
end
