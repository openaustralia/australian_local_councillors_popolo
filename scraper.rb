# get the contributions from the PlanningAlerts Contributions API
# e.g https://www.planningalerts.org.au/councillor_contributions.json
#
# for each contribution
#
# git checkout a new branch based on the contribution id. Maybe use shell out http://shiroyasha.io/running-shell-commands-from-ruby.html ?
#
# Merge the changes (with the rake task? bundle exec rake update_state_from_remote_csv[vic,https://www.planningalerts.org.au/authorities/glen_eira/councillor_contributions/5.csv] )
#
# if there are changes to the ./data directory
#   stage them
#
#   Commit the changes
#
#   Open/ReOpen a PR from the new branch with some useful info, like the contributor's
#   name and the source of the information.
#
# TODO: This process could also manage updates to the Crontribution and add
#       commits to the contribution branch/PR
