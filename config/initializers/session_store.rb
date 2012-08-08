# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wholebooks_session',
  :secret      => '6747c20fa4a46e1c67dd4b3b1891ee71df04d74cf21d69d24325c806735e8c14d02487af62bf2b74212cb805d014f7812d01c3a655e2ce8809f27e8276be0b94'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
