# Simple Process Monitor Skeleton in Ruby

This is just a quick and dirty all-in-one script that serves as a skeleton for starting up several processes
and monitoring their output, storying relevant output items in an sqlite db. It also uses Sinatra to provide
a simple endpoint for metrics tracking.

## Prerequisites

You'll need Ruby, [asdf](https://asdf-vm.com/guide/getting-started.html) is usually a good way to go for
managing ruby installs.

You'll then need several gems:

```
gem install sinatra sqlite3 --no-ri --no-rdoc
```

Sinatra for simple web server, sqlite3 for databasing statistics

## Running

- The script is heavily commented for you to adjust it to whichever processes you're running, and whichever
  statistics you want to parse out of their respective STDOUT output.
- Once you've edited it to your use case, to run it you'll simply do as follows:

```
ruby process_monitor_skeleton.rb
```

- Next, hit this endpoint periodically to view your metrics:
  http://localhost:4567/statistics

