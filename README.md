# Yandex Hackathon project

Overview: http://city-dict.herokuapp.com/presentation.html

API site: http://city-dict.herokuapp.com

See milestones: https://github.com/sld/city_dict_api/issues/milestones?with_issues=no

And issues: https://github.com/sld/city_dict_api/issues


## Installation

1. git clone
1. Install Ruby 2.0.0 and Rails 3.2.14
1. Install Postgresql (tested on 9.1 and 9.2.4)
2. Install hstore extension for Postgresql (for Ubuntu: apt-get install postgresql-contrib)
3. Rename config/database.yml.example into config/database.yml and add to database.yml 
username and password from Postgresql
4. bundle install
5. rake db:create && rake db:migrate
6. rails server
7. Enjoy!

## License
Under MIT, see LICENSE
