gitlab-rails console production
#gitlab-rails console -e production  第一步不行就执行这个
user = User.where(username:"root").first
user.password = "Pu@1uC2016"
user.save!


