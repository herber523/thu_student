require 'thu_student/version'
require 'mechanize'
module ThuStudent
  def self.profile(username, password)
    agent = Mechanize.new
    page = agent.get('http://fsis.thu.edu.tw/mosi/ccsd3/ccsd3_gen.php?job=stud&loginn=Y')
    form = page.forms.first

    form['username'] = username
    form['passwd'] = password

    l_page = form.submit.body.split('n="').last.split('";').first
    agent.get("http://fsiso.thu.edu.tw#{l_page}")

    profiles = agent.get('http://fsiso.thu.edu.tw/wwwstud/STUD_V6/INFO/MyProfile.php?job=personinfo')

    profiles = profiles.search('table tbody tr td')

    student_id = profiles[0].text.split("：").last
    name = profiles[1].text.split("：").last
    sex = profiles[2].text.split("：").last
    birthday = profiles[3].text.split("：").last
    birth_year = birthday.split(' ')[1].to_i + 1911
    birth_month = birthday.split(' ')[3]
    birth_day = birthday.split(' ')[5]
    birthday = "#{birth_year}/#{birth_month}/#{birth_day}"
    id = profiles[4].text.split("：").last
    type = profiles[5].text.split("：").last
    grade = profiles[6].text.split("：").last
    identity	= profiles[7].text.split("：").last
    country	= profiles[8].text.split("：").last
    status	= profiles[9].text.split("：").last
    guardian = profiles[10].text.split("：").last
    home_address = profiles[11].text.split("：").last
    home_phone = profiles[12].text.split("：").last
    address	= profiles[13].text.split("：").last
    use_phone = profiles[14].text.split("：").last
    telephone = profiles[15].text.split("：").last

    hash = []

    hash << { student_id: student_id, name: name, sex: sex, birthday: birthday, id: id, type: type, grade: grade, identity: identity, country: country, status: status, guardian: guardian, home_address: home_address, home_phone: home_phone, address: address, use_phone: use_phone, teltphone: telephone }
  end

  def self.transcript(username, password)
    agent = Mechanize.new
    page = agent.get('http://fsis.thu.edu.tw/mosi/ccsd3/ccsd3_gen.php?job=stud&loginn=Y')
    form = page.forms.first

    form['username'] = username
    form['passwd'] = password

    l_page = form.submit.body.split('n="').last.split('";').first
    agent.get("http://fsiso.thu.edu.tw#{l_page}")

    transcripts = agent.get('http://fsiso.thu.edu.tw/wwwstud/STUD_V6/COURSE/rcrd_all.php')

    transcripts = transcripts.search('#no-more-tables tbody tr')
    hash = []
    transcripts.each do |transcript|
      transcript = transcript.search('td')
      year = transcript[0].text
      semester = transcript[1].text
      course_id = transcript[2].text
      name = transcript[3].text
      credit = transcript[4].text
      score  = transcript[5].text
      hash << { year: year, semester: semester, course_id: course_id, name: name, credit: credit, score: score }
    end

    hash
  end
end
