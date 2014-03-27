require 'active_record'
require './lib/user'
require './lib/event'
require './lib/todo'
require './lib/note'
require 'date'
require 'pry'


ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def main_menu(user_id)
  puts "Type 'add event' to add an event to your calendar."
  puts "Type 'edit event' to edit an event on your calendar."
  puts "Type 'delete event' to delete an event on your calendar."
  puts "Type 'list' to list All of your events."
  puts "Type 'day' to list your day's events"
  puts "Type 'week' to list your week's events"
  puts "Type 'month' to list your month's events"
  puts "Type 'todo' to add a new to-do task."
  puts "Type 'todo list' to list all of your to do tasks."
  puts "Type 'note' to add a note to an event or a to-do task."
  puts "Type 'exit' to exit."
  print "User ID #{user_id} logged in>"
  choice = gets.chomp

  case choice
  when 'add event'
    add_event(user_id)
  when 'list'
    list_event(user_id)
  when 'edit event'
    edit_event(user_id)
  when 'delete event'
    delete_event(user_id)
  when 'day'
    day_event(user_id)
  when 'week'
    week_event(user_id)
  when 'month'
    month_event(user_id)
  when 'todo'
    add_todo(user_id)
  when 'todo list'
    list_todos(user_id)
  when 'note'
    add_note(user_id)
  when 'exit'
    puts "\n\nGoodbye!"
    exit
  else
    puts "\n\nI don't understand what you were trying to do."
  end
end

def login_menu
  puts "Type 'add user' to add a new user."
  puts "Type 'login' to log a user in."
  puts "Type 'exit' to exit."

  choice = gets.chomp
  case choice
  when 'add user'
    add_user
  when 'login'
    login
  when 'exit'
    puts "Goodbye!"
    exit
  else
    puts "I don't understand what you are trying to do."
  end
end

def add_todo(user_id)
puts "\n\nEnter the task's description:"
  print ">"
  task = gets.chomp
  Todo.create(:task => task, :user_id => user_id)
end

def list_todos(user_id)
  puts "\n\nHere is a list of all your events: "
  Todo.all.where(user_id: user_id).each do |todo|
  puts "#{todo.id}: #{todo.task}"
    Note.all.where(notable_id: todo.id, notable_type: 'todo').each do |note|
    puts "NOTE: #{note.name}\n\n"
    end
  end
end

def add_note(user_id)
  puts "Would you like to add a note to an 'event' or a 'todo'?"
  choice = gets.chomp.downcase
  case choice
  when choice = 'event'
    list_event(user_id)
    puts "Which event would you like to add a note to?"
    print ">"
    id = gets.chomp.to_i
    event_to_edit = Event.find(id)
    puts "Enter note description:"
    text = gets.chomp
    new_note = Note.create(:name => text, :notable_id => event_to_edit.id, :notable_type => 'event')
  when choice = 'todo'
    list_todos(user_id)
    puts "Which todo would you like to add a note to?"
    print ">"
    id = gets.chomp.to_i
    todo_to_edit = Todo.find(id)
    puts "Enter note description:"
    text = gets.chomp
    new_note = Note.create(:name => text, :notable_id => todo_to_edit.id, :notable_type => 'todo')
  end
end

def add_user
  puts "\n\nEnter your name:"
  name = gets.chomp
  new_user = User.create(:name => name)
  puts "User #{new_user.name} has been created with an ID of #{new_user.id}"
end

def login
  User.all.each do |user|
    puts "#{user.id}: #{user.name}\n"
  end

  puts "\n\nEnter the ID number of the user to login."
  choice = gets.chomp.to_i
  @user_id = choice
  @logged_in = true
end

def add_event(user_id)
  puts "\n\nEnter the event's description:"
  print ">"
  desc = gets.chomp

  puts "\n\nEnter the event's location:"
  print ">"
  loc = gets.chomp

  puts "\n\nEnter the event's start date:"
  print ">"
  start_date = gets.chomp

  puts "\n\nEnter the event's end date:"
  print ">"
  end_date = gets.chomp

  new_event = Event.create(:description => desc, :location => loc, :start_date => start_date, :end_date => end_date, :user_id => user_id)
  puts "An event: #{new_event.description} at #{new_event.location} beginning #{new_event.start_date} and ending #{new_event.end_date} has been created."
end

def list_event(user_id)
  puts "\n\nHere is a list of all your events: "
  Event.all.where(user_id: user_id).order(:start_date).each do |event|
  puts "#{event.id}: #{event.description} - #{event.location} - #{event.start_date} - #{event.end_date}"
    Note.all.where(notable_id: event.id, notable_type: 'event').each do |note|
    puts "NOTE: #{note.name}"
    end
  end
end

def edit_event(user_id)
  list_event(user_id)
  puts "\n\nChoose the number of the event you'd like to edit:"
  choice = gets.chomp.to_i
  event_to_edit = Event.find(choice)

  puts "Do you want to edit this event's description? (Y/N)"
  input = gets.chomp.downcase
    if input == "y"
      edit_description(event_to_edit)
    end

  puts "Do you want to edit this event's location? (Y/N)"
  input = gets.chomp.downcase
    if input == "y"
      edit_location(event_to_edit)
    end

  puts "Do you want to edit this event's start date? (Y/N)"
  input = gets.chomp.downcase
    if input == "y"
      edit_start_date(event_to_edit)
    end

  puts "Do you want to edit this event's end date? (Y/N)"
  input = gets.chomp.downcase
    if input == "y"
      edit_end_date(event_to_edit)
    end

  list_event(user_id)
end

def day_event(user_id, today=Date.today)
  Event.all.where(user_id: user_id, start_date: today).each do |event|
    if event.this_day(today)
      puts "#{event.id}: #{event.description} - #{event.location} - #{event.start_date} - #{event.end_date}"
    end
  end
 puts "Type 'tomorrow' to view tomorrow's calendar or 'yesterday' to view yesterday's calendar."
 choice = gets.chomp
    case choice
    when "tomorrow"
      day_event(user_id, today.tomorrow)
    when "yesterday"
      day_event(user_id, today.yesterday)
    end
end


def week_event(user_id, today=Date.today)
  Event.all.where(user_id: user_id).each do |event|
    if event.this_week(today)
      puts "#{event.id}: #{event.description} - #{event.location} - #{event.start_date} - #{event.end_date}"
    end
  end
   puts "Type 'next week' to see events for the week beginning #{today.next_week}, 'last week' to see events for the week beginning #{today.last_week}."
   choice = gets.chomp
   case choice
   when "next week"
    week_event(user_id, today.next_week)
   when "last week"
    week_event(user_id, today.last_week)
  end
end

def month_event(user_id, this_month=Date.today)
  Event.all.where(user_id: user_id).each do |event|
    if event.this_month(this_month)
      puts "#{event.id}: #{event.description} - #{event.location} - #{event.start_date} - #{event.end_date}"
    end
  end

  puts "Type 'next month' to see events for next month, otherwise press enter to return to the main menu."

  choice = gets.chomp

  case choice
  when "next month"
    month_event(user_id, this_month.next_month(1))
  when "last month"
    month_event(user_id, this_month.last_month)
  end
end


def next_week(user_id)
  today = Date.today.next_week

end

def delete_event(user_id)
  list_event(user_id)
  puts "\n\nChoose the number of the event you'd like to delete:"
  choice = gets.chomp.to_i
  event_to_delete = Event.find(choice)
  event_to_delete.destroy
  puts "Event deleted."
end

def edit_description(event_to_edit)
  puts "Enter a new description:"
  edit = gets.chomp
  event_to_edit.update({:description => edit })
end

def edit_location(event_to_edit)
  puts "Enter a new location:"
  edit = gets.chomp
  event_to_edit.update({:location => edit })
end

def edit_start_date(event_to_edit)
  puts "Enter a new start date:"
  edit = gets.chomp
  event_to_edit.update({:start_date => edit })
end

def edit_end_date(event_to_edit)
  puts "Enter a new end date:"
  edit = gets.chomp
  event_to_edit.update({:end_date => edit })
end

@logged_in = false

while @logged_in == false
  login_menu
end

loop do
  main_menu(@user_id)
end
