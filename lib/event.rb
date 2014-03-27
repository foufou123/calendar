class Event < ActiveRecord::Base
  belongs_to :user
  has_many :notes, as: :notable

  def this_day(today)
    if self.start_date.day == today.day
      true
    end
  end

  def this_month(this_month)
    if self.start_date.month == this_month.month
      true
    end
  end

  def this_week(today)
    if (self.start_date.at_beginning_of_week.day == today.at_beginning_of_week.day)
      true
    end
  end
end
