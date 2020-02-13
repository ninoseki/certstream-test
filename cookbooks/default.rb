# frozen_string_literal: true

ERLANG_VERSION = "2.0"
CERTSTREAM_PATH = "/opt/certstream"

execute "wget https://packages.erlang-solutions.com/erlang-solutions_#{ERLANG_VERSION}_all.deb && sudo dpkg -i erlang-solutions_#{ERLANG_VERSION}_all.deb" do
  not_if "dpkg -l | grep erlang-solutions"
end

execute "sudo apt-get update" do
  not_if "dpkg -l | grep esl-erlang"
end

%w(git esl-erlang elixir).each do |package_name|
  package package_name
end

user "certstream" do
  home "/home/certstream"
  shell "/bin/bash"
  create_home true
end

git CERTSTREAM_PATH do
  repository "https://github.com/CaliDog/certstream-server"
end

execute "sudo chown -R certstream:certstream #{CERTSTREAM_PATH}"

["mix local.hex --force && mix local.rebar --force", "mix deps.get"].each do |command|
  execute command do
    cwd CERTSTREAM_PATH
    user "certstream"
  end
end

remote_file "/etc/systemd/system/certstream.service"

# start the service
execute "sudo systemctl daemon-reload"
%i(enable start).each do |action|
  service "certstream" do
    action action
  end
end
