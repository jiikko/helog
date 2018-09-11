module Helog
  class Runner
    module SingnalHandling
      attr_writer :signal_queues

      def register_signal_handlers
        signals = %w(TERM INT)
        signals.each do |signal|
          trap(signal) do
            self.signal_queues << signal
          end
        end
      end

      def signal_queues
        @signal_queues ||= []
      end

      def handle_signals
        signal = signal_queues.shift
        if signal
          puts "Got #{signal} signal"
          shutdown!
        end
      end
    end
  end
end
