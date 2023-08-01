require 'date'

# https://www.smashingmagazine.com/2023/06/desktop-wallpaper-calendars-july-2023/
# A module relies on the fact that the page pattern is the same all time and follows the roles:
# - Upload Date is a previous month (e.g. 2023/06/ for June 2023 and 2022/12/ for January 2023)
# - The ending of path contains the month in lowercase (like july-2023)
module Smashing
  module PageFinder
    def month_page(month)
      date = Date.strptime(month, '%m%Y')
      date_format = date.prev_month.year, date.prev_month.month, Date::MONTHNAMES[date.month].downcase, date.year
      'https://www.smashingmagazine.com/%d/%02d/desktop-wallpaper-calendars-%s-%d/' % date_format
    end
  end
end
