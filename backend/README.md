The serviceAccountKey.json file is required to get the dev env working. This
file can be retrieved from the Firebase console.

1. Log in to the console
2. Click the gear next to "Project Overview" and select "Project settings"
3. Click the "Service Accounts" tab
4. Click the external link that goes to all your service accounts
5. Go to "Service Accounts" in the left sidebar
6. Click the 3 dots under the "Actions" column and hit "Manage keys"
7. Create a new JSON key and save it in the python/database directory

### Development
docker-compose up -d --build