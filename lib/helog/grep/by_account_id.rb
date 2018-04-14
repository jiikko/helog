require 'open3'

module Helog
  module Grep
    class ByAccountId
      def initialize(accout_id: nil, path: [])
        if accout_id.nil?
          raise('検索対象のaccount_idがありません')
          exit 1
        end
        if path.empty?
          raise('検索対象のファイルがありません')
          exit 1
        end
        @accout_id = accout_id
        @path = path
        run
      end

      def run
        cmd = "zgrep '\\\[account_id:#{@accout_id}\\\]' #{@path}"
        lines_of_account_id = []
        Open3.popen2(cmd) do |_stdin, stdout, wait_thr|
          puts "Executing... #{cmd}"
          while line = stdout.gets
            %r!(\[[-\w]+?\]) \[account_id:! =~ line
            unless $1
              puts 'uuidの取得に失敗しました。なにかおかしいです'
              puts "-> #{line}"
            end
            lines_of_account_id << "-e '#{$1}'"
          end
        end
        cmd = ("zgrep #{lines_of_account_id.join(' ')} #{@path}").gsub(']', '\]').gsub('[', '\[')
        puts cmd
        Open3.popen2(cmd) do |_stdin, stdout, wait_thr|
          while line = stdout.gets
            puts line
          end
        end
        puts
      end
    end
  end
end
