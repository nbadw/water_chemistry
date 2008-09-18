module RedHillConsulting
  class Simian
    EXECUTABLE = "java -jar \"#{Dir[File.join(File.dirname(__FILE__), '..', 'bin', 'simian*.jar')].first}\"".freeze

    def initialize(basedir = RAILS_ROOT)
      @basedir = basedir
      @includes = []
    end

    def includes(pattern)
      @includes << pattern
    end

    def execute
      puts   "#{EXECUTABLE} #{@includes.map { |pattern| "-includes=#{'"' + File.join(@basedir, pattern) + '"'}" } * ' '}"
      system("#{EXECUTABLE} #{@includes.map { |pattern| "-includes=#{'"' + File.join(@basedir, pattern) + '"'}" } * ' '}")
    end
  end
end
