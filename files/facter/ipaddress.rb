Facter.add(:ipaddress) do
  confine :kernel => :linux
  setcode do
    ip = nil
    output = %x{/sbin/ifconfig}

    output.split(/^\S/).each { |str|
      if str =~ /inet addr:([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/
        tmp = $1
        unless tmp =~ /^127\./
          ip = tmp
          break
        end
      end
    }

    ip
  end
end
