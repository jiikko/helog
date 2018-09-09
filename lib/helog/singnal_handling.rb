module Helog
  module SingnalHandling
    attr_accessor :queues
    def register_signal_handlers
      trap('TERM') do
        self.queues << 'TERM'

      end

      def handle_signals
        signal = queues.shift
        if signal
          puts "Got #{signal} signal"
          shutdown!
        end
      end
    end
  end
end
