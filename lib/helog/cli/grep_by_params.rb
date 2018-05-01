require 'open3'
require 'fileutils'

module Helog
  module CLI
    class GrepByParams
      def initialize(params, path)
        @without_debug_log = true # params[:without_debug_log]
        @patterns = params[:e]
        @and_pattern = params[:and]
        @paths = path.split(' ')

        if @patterns.nil? || @patterns.empty?
          puts 'input patterns!!'
          exit 1
        end
        if path.nil?
          raise('検索対象のファイルがありません')
          exit 1
        end
      end

      def run
        patterns_for_cmd = @patterns.map { |x| " -e #{x} " }.join
        cmd_after = []
        if @without_debug_log
          cmd_after << 'grep -v DEBUG | grep -v heroku'
        end
        if @and_pattern
          cmd_after << "grep #{@and_pattern}"
        end
        string_cmd_after = cmd_after.map { |x| "| #{x} " }.join
        cmd = "zgrep -E #{patterns_for_cmd} #{@paths.join(' ')} #{string_cmd_after}"

        logfile_uuid_table = {}
        Open3.popen2(cmd) do |_stdin, stdout, wait_thr|
          puts "Executing... #{cmd}"
          while line = stdout.gets
            logfile = nil
            uuid = nil
            if /^\d\d\d\d-\d\d/ =~ line
              raise '[BUG] 引数のファイルが１つだと1行からファイル名を取得できない'
              # if /^([^:]+):/ =~ line も直す必要がある
            end
            if /^([^:]+):/ =~ line
              logfile = $1
            else
              puts 'logfile名の取得に失敗しました。なにかおかしいです'
              puts "-> #{line}"
            end
            if %r!: (\[[-\w]+?\]) Started! =~ line
              uuid = $1
            else
              puts 'uuidの取得に失敗しました。なにかおかしいです'
              puts "-> #{line}"
            end
            logfile_uuid_table[logfile] ||= []
            logfile_uuid_table[logfile] << uuid
          end
        end

        begin
          FileUtils.mkdir_p('output')
          pids = []
          logfile_uuid_table.each do |logfile, uuids|
            pids << fork do # TODO parallel使ったほうがいいんでは
              uuids.each_slice(200).with_index do |part_uuids, index|
                part_uuids_of_cmd = part_uuids.map { |u| "-e '#{u}'" }.join(" ")
                cmd = "zgrep #{part_uuids_of_cmd} #{logfile}".gsub(']', '\]').gsub('[', '\[')
                require 'pry'
                Open3.popen2(cmd) do |_stdin, stdout, wait_thr|
                  puts "Executing... #{cmd}"
                  buffer = []
                  while line = stdout.gets
                    buffer << line
                  end
                  File.write("./output/#{logfile.gsub('/', '_')}_by_params_#{index}.log", buffer.join)
                  puts "finiesh!: #{logfile}"
                end
              end
            end
          end
          pids.each { |pid| Process.wait(pid) }
        rescue
          pids.each { |pid| Process.kill(pid) }
        end
      end
    end
  end
end
