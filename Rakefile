require 'tmpdir'

desc "Run tests"
task :test do
    sh "cd spec;rake"
end

task :integration_test do
    raise "Please specify a stomp user using MC_INTEGRATION_USER" unless ENV["MC_INTEGRATION_USER"]
    raise "Please specify a stomp password using MC_INTEGRATION_PASS" unless ENV["MC_INTEGRATION_PASS"]
    raise "Please specify a stomp host using MC_INTEGRATION_SERVER" unless ENV["MC_INTEGRATION_SERVER"]

    begin
        tmpdir = Dir.mktmpdir("mcintegration")

        puts "Creating integration setup in #{tmpdir}"

        chdir tmpdir

        sh %{git clone git://github.com/ripienaar/mcollective-test.git}
        sh %{git clone git://github.com/ripienaar/mcollective-collective-builder.git}

        ENV["MC_SERVER"] = ENV["MC_INTEGRATION_SERVER"]
        ENV["MC_USER"] = ENV["MC_INTEGRATION_USER"]
        ENV["MC_PASSWORD"] = ENV["MC_INTEGRATION_PASS"]
        ENV["MC_PORT"] = ENV["MC_INTEGRATION_PORT"] || "6163"

        ENV["MC_NAME"] = "mcollective_integration"
        ENV["MC_SUB"] = "mcollective_integration"
        ENV["MC_VERSION"] = "master"
        ENV["MC_SOURCE_BRANCH"] = "master"
        ENV["MC_COUNT"] = "5"
        ENV["MC_COUNT_START"] = "0"
        ENV["MC_SSL"] = "no"
        ENV["MC_SOURCE"] = "git://github.com/puppetlabs/marionette-collective.git"

        basedir = File.join([tmpdir, "mcollective-collective-builder"])
        agentsdir = File.join([basedir, "plugins", "agent"])
        FileUtils.mkdir(agentsdir) unless File.directory?(agentsdir)

        FileUtils.cp(File.join([File.dirname(__FILE__), "agent", "integration.rb"]), agentsdir)

        chdir File.join(basedir)

        sh %{rake create > /tmp/mc_integration.log}
        sh %{rake start}

        ENV["MCOLLECTIVE_EXTRA_OPTS"]= "--config=#{basedir}/client/etc/client.cfg"
        ENV["RUBYLIB"] = "#{basedir}/client/lib:#{tmpdir}/mcollective-test/lib"

        chdir(File.join([File.dirname(__FILE__), "spec"]))
        sh %{rake integration}
    ensure
        begin
            chdir File.join([tmpdir, "mcollective-collective-builder"])
            sh %{rake stop}
        rescue
        end

        FileUtils.remove_entry_secure tmpdir
    end
end

task :default => [:test]
