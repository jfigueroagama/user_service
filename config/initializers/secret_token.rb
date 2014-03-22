# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
UserService::Application.config.secret_key_base = 'ae0356c73445fccdfe4165e00b0690633c5dca0bb70e156ccd8394e8721f9236f906aa1e69b65e5f356445f50ada13dc85f4ea06c9a3f76c412c5e0dfe25b1a0'
