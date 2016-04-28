# Australian Local Councillors Popolo

This repo contains JSON data in the [Popolo open government data specification](http://www.popoloproject.com/)
for elected councillors at [local governments in Australia](https://en.wikipedia.org/wiki/Local_government_in_Australia).

The data is generated using a [fork of the *CSV to Popolo converter*](https://github.com/equivalentideas/csv_to_popolo)
which was originally created for [EveryPolitician](http://everypolitician.org/).

The data has been collected by [scrapers hosted on morph.io](https://morph.io/search?utf8=%E2%9C%93&q=councillors).
It has been exported from [morph.io](https://morph.io) in CSV format
and imported into [a Google Spreadsheet](https://docs.google.com/spreadsheets/d/1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE/)
to be cleaned up and updated.

## Updates

To update or add to this data follow these steps:

1. Make your changes in [the Google Spreadsheet](https://docs.google.com/spreadsheets/d/1_Ea99E5yXnHXW62o_lRo9khdbccEWfttpy2tyuYZYOE/).
2. Run `bundle` to install the Gem dependencies
3. Run `bundle exec rake` to pull data from the Spreadsheet into JSON files in this repository.
4. Inspect the diff to verify the changes to the JSON files and check for errors before committing them.
5. Submit a pull request with your changes with an [explanation](https://github.com/blog/1943-how-to-write-the-perfect-pull-request)
   of what they are and why you have made them.

## Scrapers

We used web scrapers hosted on morph.io to collect a lot of raw data to start this collection:

* South Australian Councillors https://morph.io/equivalentideas/sa_lg_councillors
* NSW Councillors https://morph.io/equivalentideas/nsw_lg_directory_councillors
* Victorian Councillors https://morph.io/equivalentideas/vic_lg_directory_councillors
* Queensland Councillors https://morph.io/openaustralia/qld_lg_directory_councillors
