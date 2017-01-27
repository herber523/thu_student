require 'thu_student/version'
require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'nokogiri'

Capybara.javascript_driver = :webkit
Capybara.current_driver = :webkit
Capybara::Webkit.configure do |config|
  config.allow_url('*')
end

class ThuStudent
  include Capybara::DSL
  def initialize(id, password)
    visit('http://fsis.thu.edu.tw/mosi/ccsd3/index.php?job=stud&loginn=&r=http://fsis.thu.edu.tw/')
    find('#login-username').set(id)
    find('#login-password').set(password)
    find('button').click
  end

  def profile
    visit('http://fsiso.thu.edu.tw/wwwstud/STUD_V6/INFO/MyProfile.php?job=personinfo')
    profile = profile_parse(html)
  end

  def course_info
    visit('http://fsiso.thu.edu.tw/wwwstud/STUD_V6/INFO/MyProfile.php?job=courseinfo')
    course_info = course_info_parse(html)
  end

  def course
    visit('http://fsiso.thu.edu.tw/wwwstud/STUD_V6/COURSE/rcrd_all.php')
    course = course_parse(html)
  end

  private

  def profile_parse(html)
    profile = Nokogiri::HTML(html)
    profile = profile.css('table tbody tr td')
    profile = profile.map { |n| clean_data(n) }
    profile_data = {}
    profile_data[:student_id] = profile[0]
    profile_data[:name] = profile[1]
    profile_data[:sex] = profile[2]
    birthday = profile[3].split(' ')
    profile_data[:birthday] =  [birthday[1].to_i + 1911, birthday[3], birthday[5]].join('-')
    profile_data[:id] = profile[4]
    profile_data[:type] = profile[5]
    grade = profile[6].split(' ')
    profile_data[:department] = grade[0]
    profile_data[:grade] = grade[1]
    profile_data[:identity]	= profile[7]
    profile_data[:country]	= profile[8]
    profile_data[:status]	= profile[9]
    profile_data[:guardian] = profile[10]
    profile_data[:home_address] = profile[11]
    profile_data[:home_phone] = profile[12]
    profile_data[:address]	= profile[13]
    profile_data[:use_phone] = profile[14]
    profile_data[:telephone] = profile[15]

    profile_data
  end

  def course_info_parse(html)
    course_info = Nokogiri::HTML(html)
    course_info = course_info.css('table tbody tr td')
    course_info = course_info.map { |n| clean_data(n) }
    course_info_data = {}
    course_info_data[:minor] = course_info[0]
    course_info_data[:double_major] = course_info[1]
    course_info_data[:program] = course_info[2]
    course_info_data[:edu_program] = course_info[3]

    course_info_data
  end

  def course_parse(html)
    course = Nokogiri::HTML(html)
    course = course.css('#no-more-tables table tbody tr')
    course_data = []
    course.each do |c|
      course_data << clean_course(c)
    end

    course_data
  end

  def clean_course(course_tr)
    course_td = course_tr.css('td')
    course_td = course_td.map(&:text)
    course = {}
    year = course_td[0] + course_td[1]
    course[:year] = year
    course[:id] = course_td[2]
    course[:name] = course_td[3]
    course[:credit] = course_td[4]
    course[:score] = course_td[5]

    course
  end

  def clean_data(nokogiri_obj)
    str = nokogiri_obj.text.split("：")
    count = str.count
    str = str.last.strip
    str = nil if str == "無" || str == "　" || count < 2
    str
  end
end
