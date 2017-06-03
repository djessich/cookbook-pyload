ENV['LC_ALL'] = 'en_US.UTF-8'

Vagrant.configure(2) do |config|
  script = <<-SHELL
    if ! [ -x "$(command -v chef-client)" ]; then
      cd /home/vagrant
      mkdir -p chef-client
      cd chef-client
      wget -O PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=chef-client
      makepkg -sfcm --check
      sudo pacman -U --noconfirm --needed ./chef-client*
      chef-client -v
      cd ..
      rm -r chef-client
    fi
  SHELL
  config.vm.provision 'shell', inline: script, privileged: false
end
