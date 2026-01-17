# Admin Account Setup Guide

## Method 1: Using Supabase Dashboard (Easiest)

### Step 1: Create a User Account
1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project
3. Navigate to **Authentication** → **Users**
4. Click **"Add user"** or **"Create new user"**
5. Fill in:
   - **Email**: `admin@campusdocs.com` (or your preferred email)
   - **Password**: Choose a strong password
   - **Auto Confirm User**: ✅ Enable this (to skip email verification)
6. Click **"Create user"**
7. **Copy the User ID** (UUID) - you'll need this in the next step

### Step 2: Set Admin Role
1. Go to **SQL Editor** in Supabase Dashboard
2. Run this SQL query (replace `YOUR_USER_ID_HERE` with the User ID you copied):

```sql
-- First, ensure the profiles table exists and has the right structure
-- If the profile doesn't exist, insert it
INSERT INTO profiles (id, email, name, role)
VALUES ('YOUR_USER_ID_HERE', 'admin@campusdocs.com', 'Admin User', 'admin')
ON CONFLICT (id) 
DO UPDATE SET role = 'admin';

-- Or if the profile already exists, just update it:
UPDATE profiles 
SET role = 'admin' 
WHERE id = 'YOUR_USER_ID_HERE';
```

3. Click **"Run"** to execute the query

### Step 3: Login
- **Email**: `admin@campusdocs.com` (or the email you used)
- **Password**: The password you set
- Click **"Admin Login"** button in the app

---

## Method 2: Using SQL Directly

### Step 1: Create User via SQL (if you have service role access)
```sql
-- This requires Supabase Admin API or service role key
-- Usually done through Supabase Dashboard Authentication section
```

### Step 2: Set Admin Role
```sql
-- Update existing user to admin
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'admin@campusdocs.com';

-- Or insert new admin profile
INSERT INTO profiles (id, email, name, role)
SELECT id, email, email, 'admin'
FROM auth.users
WHERE email = 'admin@campusdocs.com'
ON CONFLICT (id) DO UPDATE SET role = 'admin';
```

---

## Method 3: Create Admin Account via App (Temporary Solution)

1. **First, create a student account:**
   - Open the app
   - Click **"Student Login"**
   - The app doesn't have signup, so you need to create the account in Supabase Dashboard first (see Method 1, Step 1)

2. **Then set admin role:**
   - Go to Supabase Dashboard → SQL Editor
   - Run this query (replace with your email):
   ```sql
   UPDATE profiles 
   SET role = 'admin' 
   WHERE email = 'your-email@example.com';
   ```

3. **Logout and login again as Admin**

---

## Verify Admin Account

Run this query in SQL Editor to check:
```sql
SELECT id, email, role 
FROM profiles 
WHERE role = 'admin';
```

You should see your admin account listed.

---

## Default Admin Credentials (You Need to Create These)

**There are NO default admin credentials.** You must create them using one of the methods above.

**Recommended:**
- **Email**: `admin@campusdocs.com`
- **Password**: Choose a strong password (at least 8 characters)

---

## Troubleshooting

### "Access denied. This account is not an admin account"
- Make sure the `role` field in the `profiles` table is set to `'admin'` (lowercase)
- Check that the profile exists: `SELECT * FROM profiles WHERE email = 'your-email@example.com';`

### "Invalid email or password"
- Make sure the user exists in Authentication → Users
- Check that email confirmation is not required (enable "Auto Confirm User" when creating)

### Profile doesn't exist
- The app will auto-create a profile with 'student' role on first login
- You need to manually update it to 'admin' using SQL

---

## Database Schema Required

Make sure your `profiles` table has this structure:
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id),
  email TEXT,
  name TEXT,
  role TEXT DEFAULT 'student'
);
```

And ensure there's a unique constraint on `id`:
```sql
ALTER TABLE profiles ADD CONSTRAINT profiles_id_key UNIQUE (id);
```
