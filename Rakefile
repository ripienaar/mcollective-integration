require 'tmpdir'
require 'yaml'

desc "Run tests"
task :test do
    sh "cd spec;rake"
end

task :integration_test do
    begin
        tmpdir = Dir.mktmpdir("mcintegration")
        gemdir = File.join([tmpdir, "gem"])
        stompconfig = File.join([tmpdir, "stompserver.conf"])

        puts "Creating integration setup in #{tmpdir}"

        chdir tmpdir

        ENV["GEM_HOME"] = gemdir

        sh %{gem install stomp --no-rdoc --no-ri}
        sh %{gem install stompserver --no-rdoc --no-ri}
        sh %{git clone git://github.com/ripienaar/mcollective-test.git}
        sh %{git clone git://github.com/ripienaar/mcollective-collective-builder.git}

        File.open(stompconfig, "w") {|f| f.write YAML.dump({:port => 7000, :daemon => true, :debug => true})}

        sh %{#{gemdir}/bin/stompserver --config #{stompconfig}}

        ENV["MC_SERVER"] = ENV["MC_INTEGRATION_SERVER"] || "localhost"
        ENV["MC_USER"] = ENV["MC_INTEGRATION_USER"] || "mcollective"
        ENV["MC_PASSWORD"] = ENV["MC_INTEGRATION_PASS"] || "secret"
        ENV["MC_PORT"] = ENV["MC_INTEGRATION_PORT"] || "7000"

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

            if File.exist?(File.join(tmpdir, "log", "stompserver.pid"))
                pid = File.read(File.join(tmpdir, "log", "stompserver.pid"))
                sh %{kill -9 #{pid}}
            end
        rescue
        end

        FileUtils.remove_entry_secure tmpdir
    end
end

task :default => [:test]
