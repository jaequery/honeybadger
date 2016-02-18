# add default admin user
user = User.new
user.email = 'test@test.com'
user.name = 'Honeybadger'
user.username = 'admin'
user.password = 'asdfasdf'
user.password_confirmation = user.password
user.role = 'admin'
user.provider = 'email'
user.avatar_url = '/vendor/honeybadger/img/avatar.jpg'
user.save

# add blog post
post = Post.new
post.user_id = 1
post.title = "Why I created Honeybadger"
post.content = "Because I wanted a simple and lightweight blogging / CMS framework for Ruby and I just could not find one that I liked."
post.created_at = Time.now
post.save