module MCollective
  module Agent
    class Integration<RPC::Agent
      def before_processing_hook(msg, connection)
        reply[:test_sender] = Config.instance.pluginconf.fetch("integration.identity", Config.instance.identity)
      end

      def after_processing_hook
        reply[:post_sender] = Config.instance.pluginconf.fetch("integration.identity", Config.instance.identity)
      end

      action "echo" do
        validate :msg, String
        reply[:message] = request[:msg]
      end

      action "validation" do
        validate :msg, /^validate$/
        reply[:passed] = 1
      end

      action "soft_fail" do
        reply.fail("Soft Failure")
        reply[:message] = "Soft Failure"
      end

      action "hard_fail" do
        reply.fail!("Hard Failure")
        reply[:message] = "Hard Failure"
      end
    end
  end
end
