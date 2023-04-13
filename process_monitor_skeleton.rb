# This script requires Sinatra and sqlite3 gems
# gem install sinatra sqlite3 --no-ri --no-rdoc
# Run this script with: ruby process_monitor_skeleton.rb
# Open http://localhost:4567/statistics in your browser to see the statistics

require 'open3'
require 'sqlite3'
require 'sinatra'

# Define your processes here
process_commands = [
  "command1",
  "command2",
  # ...
]

# Create or open SQLite database
db = SQLite3::Database.new("stats.db")

# Create a table for storing statistics if it doesn't exist
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS statistics (
    id INTEGER PRIMARY KEY,
    process_name TEXT,
    output TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
SQL

# Method for starting and monitoring processes
def start_process(command, db)
  Open3.popen2e(command) do |stdin, stdout_err, wait_thr|
    while line = stdout_err.gets
      puts "[#{command}] #{line}"

      # Extract statistics from the output
      # (Modify this according to your needs)
      stats = {
        process_name: command,
        output: line
      }

      # Save statistics to the database
      db.execute("INSERT INTO statistics (process_name, output) VALUES (?, ?)", [stats[:process_name], stats[:output]])
    end
  end
end

# Start and monitor all processes
threads = process_commands.map do |command|
  Thread.new { start_process(command, db) }
end

# Web server
get '/statistics' do
  # Fetch statistics from the database
  statistics = db.execute("SELECT * FROM statistics")

  # Format and display the statistics
  content_type :text
  statistics.map { |stat| "#{stat[0]}. #{stat[1]} - #{stat[2]} (#{stat[3]})" }.join("\n")
end

# Join all threads (to keep them running)
threads.each(&:join)
