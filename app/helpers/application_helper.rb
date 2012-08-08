module ApplicationHelper
  def format_datetime(datetime)
    datetime.strftime("%m/%d/%Y %I:%M %p") rescue datetime
  end
end
