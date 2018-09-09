require "spec_helper"

RSpec.describe 'Helog::Runner' do
  include Logging

  def wait_to_start(runner)
    loop do
      pid = runner.instance_eval{ @cmd_pid }
      break if pid
      sleep(0.1)
      log '.'
    end
  end

  describe '#start_cmd_thread' do
    context 'コマンド実行しているThreadがThrad#killされた時' do
      it 'リソースリークしないで停止すること' do
        runner = Helog::Runner.new("yes", 'logs/test.log')
        runner.send(:start_cmd_thread)
        wait_to_start(runner)

        pid = runner.instance_eval{ @cmd_pid }
        expect(ObjectSpace.each_object(File).reject(&:closed?).size).to eq(1)
        log `pstree -p #{$$}`
        runner.instance_eval{ @cmd_thread.kill }
        log 'killed'
        begin
          log '------------'
          log `pstree -p #{$$}`
          # Thread#killしたら明示してkillが必要かと思ったけど不要かも
          Process.waitpid(pid)
        rescue Errno::ESRCH, Errno::ECHILD
          log '------------'
          log `pstree -p #{$$}`
        end
        expect(ObjectSpace.each_object(File).reject(&:closed?).size).to eq(0)
      end
    end

    context 'コマンドが正常終了した時' do
      it 'リソースリークせずに再実行すること' do
        runner = Helog::Runner.new('sleep 1', 'logs/test.log')
        runner.send(:start_cmd_thread)
        wait_to_start(runner)

        5.times do
          begin
            Process.waitpid(runner.instance_eval{ @cmd_pid })
          rescue Errno::ESRCH, Errno::ECHILD
          end
          sleep(0.5)
        end
        5.times do
          expect(ObjectSpace.each_object(File).reject(&:closed?).size).to eq(1)
          sleep(0.5)
        end
      end
    end
  end
end
