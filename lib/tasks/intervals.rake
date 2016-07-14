namespace :intervals do

  desc 'Finish all non-finished intervals'
  task checkout_all: :environment do
    count = 0
    User.where(auto_checkout: true).each do |user|
      count += user.intervals.where(time_out: nil).update_all(time_out: DateTime.current)
    end
    puts "#{DateTime.current} - checked out #{count} intervals"
  end

end
