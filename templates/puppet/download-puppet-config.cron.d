#
# cron-jobs for pige
#

MAILTO=root

1,16,31,46 * * * *     root   /usr/local/sbin/download-puppet-config <%= box_config_host %>
@reboot                root   /usr/local/sbin/download-puppet-config <%= box_config_host %>
