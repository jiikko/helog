require 'date'
require 'retryable'

module Helog
  class Fetcher
    include Helog::GoogleDriveMixin

    attr_accessor :dates_to_s
    def initialize(dates: )
      self.dates_to_s = dates
    end

    def run
      if dates_to_s.empty?
        puts('empty argv!!')
        return false
      end
      if dates_to_s.size > 2
        puts('too many argv!!')
        return false
      end

      result =
        dates.map { |date|
          fetch(date)
        }.join(' ')
      puts 'command was success!'
      puts
      puts "zgrep YOUR_WORD #{result}"
      return true
    end

    def dates
      valid_dates = dates_to_s.map { |d| Date.parse(d) }
      (valid_dates.first..valid_dates.last).to_a
    end

    private

    def fetch(date)
      base_path = "app_log/#{date.strftime('%Y/%m')}"
      FileUtils.mkdir_p(base_path)
      Parallel.map(files(date), in_threads: 8) do |file|
        path = "#{base_path}/#{file.title}"
        if File.exists?(path)
          puts "skip #{path}"
        else
          # Google::Apis::ClientError
          Retryable.retryable(tries: 3) { file.download_to_file(path) }
          puts "ok #{path}"
        end
        path
      end
    end

    def files(date)
      log_folder = session.folders_by_name(Helog::LOG_ROOT_DIR) || (return [])
      year_folder = log_folder.subfolder_by_name(date.strftime('%Y')) || (return [])
      folder = year_folder.subfolder_by_name(date.strftime('%m')) || (return [])
      folder.files(q: "name contains '#{date.strftime('%d')}'")
    end
  end
end
