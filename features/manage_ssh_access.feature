Feature: Manage ssh access
  In order to access to command line Box tools
  An user
  wants to setup ssh access

  Scenario: Default SSH Configuration is empty
    When I am on /ssh
    Then I should see "No authorized keys"

  @wip
  Scenario: Add an SSH key
    Given I am on /ssh
    When I follow "Edit"
    And I fill in "Authorized keys" with this text
    """
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8Vn+bNWAjMeb0I4T3OhIiGzPp5NIBcJol6y6aougiK5/zrrgM5y0U+594jpo3oDoSInTOq3XarM9HdX9lu+QLnjfqpDl6KsgjJYZFEkI+v5F5ZzoSNm4w0Klr2TBCy4kn6kp7vagUrBunOB/9+zz7l6nc081peU59J22S83V7ZBb4iGOPbVDctSSb6U2cKe406L/5bSEb3TP1acsF/giS+2jd6KgiorUScPtnPs0VeGOTYWOSusDy0zZLVXTc2FtEDlUYnnkPHW0+UggEOA8jqQWzcZeYWyxxN2ejhy8MwmgHosf2fgTQ0wpcVDl6WFI7e0sCUHepQekAkJPZe5e3 user@dummy
    """
    And I press "Save"
    Then I should see "1 Authorized key"
    And I can open an ssh session with boxuser
