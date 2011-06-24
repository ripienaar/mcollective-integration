module MCollective
    module Agent
        class Integration<RPC::Agent
            metadata    :name           => "Integration Agent",
                        :description    => "Simple Agent used for integration testing",
                        :author         => "P Loubser",
                        :license        => "GPLv2",
                        :version        => "1",
                        :url            => "http://..../",
                        :timeout        => 60

            def before_processing_hook(msg, connection)
                reply[:test_sender] = Config.instance.pluginconf["integration.identity"] || Config.instance.identity
            end

            def after_processing_hook
                reply[:post_sender] = Config.instance.pluginconf["integration.identity"] || Config.instance.indentity
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
