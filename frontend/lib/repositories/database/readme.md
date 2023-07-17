# Process
For a new user, their inputted phone number is written to the database AFTER it is verified as a unique record, or after it is ensured that the user has not already registered with the platform.

If they are already registered, display a prompt that says "Hey, we've seen you here before!" or something. Then redirect to the login page.

If they are NOT already registered, insert the phone number record, where a user id will hopefully be auto-generated, and continue with the registration process.