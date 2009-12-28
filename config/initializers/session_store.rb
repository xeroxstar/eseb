# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eseb_session',
  :secret      => '4e38c69803cc86b8bf47d72baf45e93a0de804abdad29d81288904a2807062b7eb3bfe6c09f8c685c4be9f63602b1831f585dc0188c3a41d1f08401ee9a1d7b2'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
