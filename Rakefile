require "fileutils"

"build website"
task :build do
  puts "## Pulling any updates"
  sh "git pull"
  puts "## Building website"
  sh "bundle exec jekyll build"
end

"deploy website/_site to github pages"
task :deploy do
  puts "## Deploying website/_site to Github Pages "
  sh "git checkout main"
  sh "git pull"
  sh "git checkout website -- _site"
  FileUtils.cp_r "_site/.", "."
  FileUtils.rm_r "_site"
  sh "git add -A"
  sh "git commit -m \"Deploying website/_site at #{Time.now}\""
  sh "git push"
  sh "git checkout website"
end
