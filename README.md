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
2. Export the sheet as CSV.
3. Use the [CSV to Popolo converter](https://github.com/equivalentideas/csv_to_popolo) to generate a new json file.
4. Replace the json file to be update in this repo with your updated one.
5. Inspect the diff to verify your changes and check for errors before committing them.
6. Submit a pull request with your changes with an [explanation](https://github.com/blog/1943-how-to-write-the-perfect-pull-request)
   of what they are and why you have made them.

## Using the CSV to Popolo converter

Once you have downloaded an updated CSV file,
you need a copy of the CSV to Popolo converter
to regenerate the Popolo JSON files like nsw_lg_directory_councillors.json.

First, make sure you have a copy of this repo to update
and the [forked CSV to Popolo converter](https://github.com/equivalentideas/csv_to_popolo):

```
> git clone https://github.com/openaustralia/australian_local_councillors_popolo
> git clone https://github.com/equivalentideas/csv_to_popolo
```

Now run the converter on the CSV file with:

```
> cd csv_to_popolo
> bundle exec ruby ./bin/csv_to_popolo.rb updated_nsw.csv > updated_nsw.json
```

Have a look at the updated JSON file and
check that the output is what you expect.

Now you need to update the file on this project with your shiny new data.

```
> mv updated_nsw ../openaustralia/australian_local_councillors_popolo/nsw_lg_directory_councillors.json
```

You can now see the changes you’ve made to this project using `git diff`.
See here that I’ve just added emails for two councillors:

```
> cd ../openaustralia/australian_local_councillors_popolo
> git diff
diff --git a/nsw_local_councillor_popolo.json b/nsw_local_councillor_popolo.json
index 3f2f04b..301a21a 100644
--- a/nsw_local_councillor_popolo.json
+++ b/nsw_local_councillor_popolo.json
@@ -3377,10 +3377,12 @@
       "name": "Steve Pickering"
     },
     {
+      "email": "mgardiner@marrickville.nsw.gov.au",
       "id": "marrickville_council/mark_gardiner",
       "name": "Mark Gardiner"
     },
     {
+      "email": "mhanna@marrickville.nsw.gov.au",
       "id": "marrickville_council/morris_hanna",
       "name": "Morris Hanna"
     },
```

Check that the changes you see are the changes you wanted.

**The converter doesn’t do anything special to sort the data.**
This means that if the order of councillors has changed in the spreadsheet
your new JSON file will be out of order.
This is a problem because it makes the `git diff` really messy.
It should just including the precise changes you intended.
Fix the order in the spreadsheet and convert again if necessary.

Commit your changes and leave a helpful commit message
explaining why you’ve updated the file and what changes you’ve made.

## Scrapers

We used web scrapers hosted on morph.io to collect a lot of raw data to start this collection:

* South Australian Councillors https://morph.io/equivalentideas/sa_lg_councillors
* NSW Councillors https://morph.io/equivalentideas/nsw_lg_directory_councillors
* Victorian Councillors https://morph.io/equivalentideas/vic_lg_directory_councillors
* Queensland Councillors https://morph.io/openaustralia/qld_lg_directory_councillors
