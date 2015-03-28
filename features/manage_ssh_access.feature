Feature: Manage ssh access
  In order to access to command line Box tools
  An user
  wants to setup ssh access

  Scenario: Default SSH Configuration is empty
    When I am on /ssh
    Then I should see "No authorized keys"

  Scenario: Default SSH Configuration is empty
    Given I create an ssh key
    And I register this ssh key in authorized keys
    When I am on /ssh
    Then I should see "1 Authorized key"

  Scenario: Add an SSH key
    Given I create an ssh key
    When I register this ssh key in authorized keys
    Then I can open an ssh session with boxuser

  Scenario: SSH key are restored after reboot
    Given I create an ssh key
    And I register this ssh key in authorized keys
    And the box configuration is saved
    When the box reboots
    Then I can open an ssh session with boxuser

  Scenario: Remove all SSH keys
    Given I create an ssh key
    And I register this ssh key in authorized keys
    When I unregister all ssh keys
    Then I can't open an ssh session with boxuser
