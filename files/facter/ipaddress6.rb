Facter.add(:ipaddress6) do
  confine :kernel => :linux
  setcode do
    nil
  end
end
