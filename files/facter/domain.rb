Facter.add(:domain) do
  setcode do
    # Don't search a domain if network is not available
    return nil unless Facter.value(:ipaddress)

    # Get the domain from various sources; the order of these
    # steps is important

    if name = Facter::Util::Resolution.exec('hostname') \
      and name =~ /.*?\.(.+$)/

      $1
    elsif domain = Facter::Util::Resolution.exec('dnsdomainname') \
      and domain =~ /.+\..+/

      domain
    elsif FileTest.exists?("/etc/resolv.conf")
      domain = nil
      search = nil
      File.open("/etc/resolv.conf") { |file|
        file.each { |line|
          if line =~ /^\s*domain\s+(\S+)/
            domain = $1
          elsif line =~ /^\s*search\s+(\S+)/
            search = $1
          end
        }
      }
      next domain if domain
      next search if search
    end
  end
end
