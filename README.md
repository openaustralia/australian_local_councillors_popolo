# Australian Local Councillors Popolo

This repo contains JSON data in the [Popolo open government data specification](http://www.popoloproject.com/)
for elected councillors at [local governments in Australia](https://en.wikipedia.org/wiki/Local_government_in_Australia).

The data is generated using a [fork of the *CSV to Popolo converter*](https://github.com/equivalentideas/csv_to_popolo)
which was originally created for [EveryPolitician](http://everypolitician.org/).

In the [`data` directory](https://github.com/openaustralia/australian_local_councillors_popolo/tree/master/data) there is a `local_councillors.csv` and a `local_councillor_popolo.json` file for each state.
Changes are made to the CSV file, and then the Popolo JSON is generated using the process described in the [Updates section](#updates).

## Updates

To update or add to this data follow these steps:

1. There is a `local_councillors.csv` for each Australian state in the `data` directory. Make your updates to the relevant file. Add rows for new councillors or edit the row with the existing councillors you need to edit.
2. If you don’t feel comfortable with the following steps, simply [open a new issue](https://github.com/openaustralia/australian_local_councillors_popolo/issues/new) or email contact@planningalerts.org.au to let us know you’ve made changes to the spreadsheet, e.g. “Snowy River Councillors waiting in the spreadsheet”.
3. Run `bundle` to install the Gem dependencies.
4. Run `bundle exec rake update_all` to pull data from the Spreadsheet into JSON files in this repository. Hint: run `bundle exec rake -T` to see the state specific tasks.
5. Inspect the diff to verify the changes to the JSON files and check for errors before committing them. Are all the councillors you expect to see there?
6. Submit a pull request with your changes with an [explanation](https://github.com/blog/1943-how-to-write-the-perfect-pull-request)
   of what they are and why you have made them.

## When councillors come and go

As the years come and go, so to do the people we elect as our local councillors.

**When a person is no longer a councillor** add the date that they left the position as their `end_date`.
Don't remove their record from the spreadsheet; we want to keep information about former councillors too.

**When a new person becomes a councillor** add a new row with all their standard details.
Set their `start_date` to be the date they took up the position.

Use the format `yyyy-mm-dd` for all dates, e.g. `2017-04-10`.

It might be hard to pin-point a specific date when councillors change over after an election.
You might not be able to find an official "swearing in" date you can use, use the date after an election as the `start_date` and the day of the election as the `end_date` for outgoing councillors.

[d21fb6f is an example](https://github.com/openaustralia/australian_local_councillors_popolo/commit/d21fb6fa10ef1c81ec05e6aec7ca15e1b84352b1)
of the JSON generated after adding councillors and setting start and end dates in the spreadsheet.
Note that no councillors were removed from the data, just `end_date`s added.

## Tips for collecting councillor information

The best place to find information about local councillors is the council’s official website. Most council websites have a page listing all the councillors and their information. Wikipedia can be a good source of information about the councillors’ political party, if it’s not on the council website.

**The minimum information we need is the councillor’s email**. Next important is the url for an image of them. Next important is their political party. The source of where you got most of the information is also important so we can go back and update or fill in details in the future. Any other information you can collect that has a collumn in the spreadsheet is wonderfut—but if you’re in a hurry just grab what’s necessary.

**Remove titles, prefixes and memberships from names, such as “Dr” or “OAM”**. For example “Dr Louise Hill OAM” should be listed as “Louise Hill”.

## Scrapers for the original raw data

We used the following web scrapers hosted on morph.io to collect a lot of raw data to start this collection.
We don’t recommend rerunning these and merging their output into the Google sheet.
If you do this, then generate the JSON and try to merge the changes in here, the diff will be extremely hard to read.
This makes checking the data very difficult.
It’s preferable to update the councillors one-by-one, unless you can come up with a way to produce useful git diffs,
or split the results into individual Pull Requests for the changes to each authority’s councillors.

* South Australian Councillors https://morph.io/equivalentideas/sa_lg_councillors
* NSW Councillors https://morph.io/equivalentideas/nsw_lg_directory_councillors
* Victorian Councillors https://morph.io/equivalentideas/vic_lg_directory_councillors
* Queensland Councillors https://morph.io/openaustralia/qld_lg_directory_councillors
* Tasmania https://morph.io/openaustralia/tas_lg_directory_councillors
* Western Australia https://morph.io/openaustralia/west_australian_local_councillors

## Design Principles

As we [make Councillors data easy to update for volunteers](https://github.com/openaustralia/australian_local_councillors_popolo/issues/98#issuecomment-305383236), these principles will shape what we create:

* Strive for diversifying data: invite people who are historically marginalized and excluded from conversations around technology and information, and intentionally build data structures that reflect those voices and lived experiences. The effort of achieving diversity needs to happen from multiple angles.
* Make sure contributors understand the amazing impact they’re having
* Strive for universal accessibility
* Make the process of contribution obvious and intuitive
* Communicate clearly how people’s contribution are used.
* Be welcoming for both new and existing contributors. Do adequate outreach as well as decreasing the barriers for new contributors.
* Be supportive: people need to feel supported and encouraged in their process of contributing.
* Share ownership: make sure people know they are a part of the community. Honor the their labour and make sure they are able to receive the benefits.
* Respect everyone’s time, including administrators

## How we work

* Be agile, flexible, and responsive: decide on small feature, implement, debug, repeat.
* Communicate changes to people as they come up.
* In case of conflict, return to the shared goal of the project and the problems we want to solve.  Reflect on what your beef is and where it’s coming from (maybe it’s not about the project).
 
