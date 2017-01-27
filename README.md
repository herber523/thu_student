# ThuStudent
快速獲取東海大學學生個人基本資料
需要帳號密碼登入

## Installation

需要安裝 phantomjs
```bash
$ npm install -g phantomjs
```

加入這行到您的 Gemfile:


```ruby
gem 'thu_student'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thu_student

## Usage

```ruby
student = ThuStudent.new('student_id','password')

student.profile
#profile 個人資料

student.course_info
#course_info 學程資訊

student.course
#course 歷年修課紀錄
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/herber523/thu_student.

