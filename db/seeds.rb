# add default admin user
user = User.new
user.email = 'test@test.com'
user.first_name = 'Jae'
user.last_name = 'Lee'
user.username = 'admin'
user.password = 'asdfasdf'
user.password_confirmation = user.password
user.role = 'admin'
user.provider = 'email'
user.avatar_url = '/vendor/honeybadger/img/avatar.jpg'
user.save

# add blog post

#for num in 1..69 do
post = Post.new
post.user_id = 1
post.title = "Why I created Honeybadger"
post.teaser = "One day I said to myself enough is enough. I have been turmoiled by lack of quality minimal frameworks to get me started on new projects. And thus ..."
post.content = "I wanted a simple and lightweight blogging / CMS framework for Ruby and no matter how much I looked, I just could not find one. "
post.created_at = Time.now
post.save
#end