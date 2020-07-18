desc "build the image"
task :build do
  sh "docker build . --network host -t docker-chrome"
end

desc "open the chrome "
task :instance  do
  sh """
    docker run -d --net host --cpuset-cpus 0 --memory 512mb -v $PWD/google-chrome-user-data/:/data -v /tmp/.X11-unix:/tmp/.X11-unix  \
    --security-opt seccomp=$PWD/chrome.json  -e DISPLAY=unix$DISPLAY -v /dev/shm:/dev/shm --name chrome-instance docker-chrome
  """
end

desc "start chrome-instance"
task :start do
  sh "docker start chrome-instance"
end

desc "stop chrome-instance"
task :stop do
  sh "docker stop chrome-instance"
end

desc " remove chrome-instance"
task :rm do
  sh "docker rm chrome-instance"
end

task :default do
  sh "rake --tasks"
end
