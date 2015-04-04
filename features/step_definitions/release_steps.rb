Given /the current release is old/ do
  # rewrite current.yml to simulate an old release 2010xxxx
  current_box.ssh do |ssh|
    ssh.exec! "mount -o remount,rw /boot"
    ssh.exec! "sed -i '/^name/ s/-201[0-9]/-2010/' /boot/current.yml"
    ssh.exec! "mount -o remount,ro /boot"
    ssh.exec! "invoke-rc.d apache2 restart"
  end
end

Then /the release should be downloading/ do
  expect(page).to have_content("Download pending since")

  time_to_wait = 3600
  pause_duration = 60

  download_rate = 0

  while page.has_content?("Download pending since")
    sleep pause_duration

    description = page.find("#release_latest p").text
    if description =~ /Download pending since/
      expect(description).to match(%r{([0-9\.]+) MB/([0-9\.]+) MB})

      description =~ %r{([0-9\.]+) MB/([0-9\.]+) MB}
      new_download_rate = $1.to_f / $2.to_f

      expect(new_download_rate).to be > download_rate
      download_rate = new_download_rate
    end

    time_to_wait -= pause_duration
    raise "Timeout while waiting release to be downloaded" unless time_to_wait > 0
  end

  expect(page).to have_content("Downloaded since")
end

Given /the release is fully downloaded/ do
  steps %Q{
    Given I am on /releases
    And I follow "Download"
    And the release should be downloading
  }
end
