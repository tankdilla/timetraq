module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%m/%d/%Y %I:%M %p") rescue datetime
  end
  
  def format_date(datetime)
    datetime.strftime("%m/%d/%Y") rescue datetime
  end
end
