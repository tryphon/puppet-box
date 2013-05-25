Feature: Manage networks
  In order to connect the Box to his local network
  An user
  wants to setup network interfaces

  # @wip
  # Scenario: Configure a static IP address
  #   Given I am on /networks/eth0/edit
  #   When I choose "Manual configuration"
  #   And I fill in the following:
  #   | IP address   |     10.0.3.10 |
  #   | Network mask | 255.255.255.0 |
  #   | Gateway      |      10.0.3.1 |
  #   | DNS server   |      10.0.3.1 |
  #   # Mechanize can't handle current http response :(
  #   And I press "Edit"
  #   Then I should see "Current IP address : 10.0.3.10"
