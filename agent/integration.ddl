metadata    :name           => "Integration Agent",
            :description    => "Simple Agent used for integration testing",
            :author         => "P Loubser",
            :license        => "GPLv2",
            :version        => "1",
            :url            => "http://..../",
            :timeout        => 60

requires :mcollective => "2.2.1"

action "echo", :description => "test that input and replies propagate" do
    input :msg,
          :prompt      => "Message",
          :description => "Message to send",
          :type        => :string,
          :validation  => '^.+$',
          :optional    => false,
          :maxlength   => 20

    output :message,
           :description => "Message",
           :display_as  => "Message that was received",
           :default     => nil
end

action "validation", :description => "validate tester, passes on /^validate$/" do
     input :msg,
           :prompt      => "Message",
           :description => "Message to validate",
           :type        => :string,
           :validation  => '^.+$',
           :optional    => false,
           :maxlength   => 20

     output :passed,
            :description => "Passed",
            :display_as  => "Passed",
            :default     => nil
end

action "soft_fail", :description => "Causes a soft failure and sets :message" do
    output :message,
           :description => "Message",
           :display_as  => "Message",
           :default     => nil
end

action "hard_fail", :description => "Causes a hard failure and should never set :message" do
    output :message,
           :description => "Message",
           :display_as  => "Message",
           :default     => "unset"
end
