require 'date'
require 'retryable'
require 'json'
require 'pry'

module Helog
  module CLI
    class Request2JSON
      class Request
        def initialize(lines)
          @lines = lines
        end

        def to_json
          hash = {}
          @lines.each do |line|
            h = line.to_hash
            case
            when h.key?(:messages)
              hash[:messages] ||= []
              hash[:messages] << h[:messages]
            when h.key?(:params)
              hash[:params] = h[:params]
            when h.key?(:account_id)
              hash[:account_id] = h[:account_id]
            end
          end
          hash.to_json
        end
      end

      class Line
        attr_reader :dyno, :uuid, :body
        def initialize(line)
          if %r!00:00 app\[(.+?)\]: (\[.+?\]) (.+?)$! =~ line
            @dyno = $1
            @uuid = $2
            @body = $3
          else
            puts "なにかおかしいです: => #{line}"
          end
        end

        def to_hash
          case body
          when %r!^\[account_id:(\d+?)\]!
            { account_id: $1 }
          when /Parameters: ({.+?}$)/
            { params: eval($1) } # dangerous!!
          else
            { messages: body }
          end
        end
      end

      def initialize(filepath)
        if filepath.nil?
          puts 'notfound filepath!!!'
          exit 1
        end
        @filepath = filepath
      end

      def run
        requests = []
        File.open(@filepath).each_line.reduce([]) do |a, x|
          line = Line.new(x)
          if a.last.nil?
            a << line
            next(a)
          end
          if a.last.uuid == line.uuid # uuidが同じ場合は同一リクエストが続いている
            a << line
            next(a)
          else
            requests << Request.new(a)
            next([])
          end
        end
        puts requests.map(&:to_json).join("\n")
      end
    end
  end
end
