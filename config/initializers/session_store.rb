# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_event_registration_session',
  :secret      => '37848b1754bf8674fe41b91d27d288e23651420724a7ef61dfdec1ddf3b8dbd023bb0812ac879c5bdca5e6229cc9c251841561a747482a78f2c1a84823c686f7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
