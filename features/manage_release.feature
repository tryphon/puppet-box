Feature: Manage release

  Scenario: Download the latest release
    Given the current release is old
    And I am on /releases
    When I follow "Download"
    Then the release should be downloading
    And I should see "Install and reboot"

  Scenario: Install the latest release
    Given the current release is old
    And the release is fully downloaded
    When I follow "Install and reboot"
    Then I should see "No upgrade is needed"
