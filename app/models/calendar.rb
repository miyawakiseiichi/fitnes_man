class Calendar < SimpleCalendar::Calendar
  def week_start
    :sunday
  end

  def weekend
    [ 0, 6 ]
  end

  def weekend_color
    "bg-gray-50"
  end

  def today_color
    "bg-blue-50"
  end

  def other_month_color
    "bg-gray-50"
  end
end
