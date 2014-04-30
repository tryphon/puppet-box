desc "Run puppet-lint"
task :lint do
  sh "bundle exec puppet-lint --no-autoloader_layout-check --with-filename manifests/**/*.pp files/**/*.pp" rescue nil
end
