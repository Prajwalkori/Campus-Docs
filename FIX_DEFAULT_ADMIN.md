# Fix Default Admin Creation Issue

If you're getting the error "Could not create default admin", it's likely because **Supabase requires email confirmation** by default.

## Solution 1: Disable Email Confirmation (Recommended for Development)

1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project
3. Go to **Authentication** → **Settings** (or **Providers** → **Email**)
4. Find **"Enable email confirmations"** or **"Confirm email"** setting
5. **Disable** email confirmation
6. Save the changes
7. Try the Quick Login button again

## Solution 2: Use Manual Sign Up (Works Always)

If you can't disable email confirmation, use the manual sign-up:

1. Click **"Admin Sign Up"** on the main screen
2. Fill in:
   - **Full Name**: Default Admin (or your name)
   - **Email**: `admin@campusdocs.com`
   - **Password**: `admin123` (or your preferred password)
   - **Confirm Password**: Same as password
   - **Admin Key**: `CAMPUS_ADMIN_2024`
3. Click **"Sign Up"**
4. If email confirmation is enabled, check your email and confirm
5. Then login with the credentials

## Solution 3: Create Admin via Supabase Dashboard

1. Go to Supabase Dashboard → **Authentication** → **Users**
2. Click **"Add user"** or **"Create new user"**
3. Enter:
   - **Email**: `admin@campusdocs.com`
   - **Password**: `admin123`
   - **Auto Confirm User**: ✅ Enable this
4. Click **"Create user"**
5. Copy the **User ID**
6. Go to **SQL Editor** and run:
   ```sql
   INSERT INTO profiles (id, email, name, role)
   VALUES ('PASTE_USER_ID_HERE', 'admin@campusdocs.com', 'Default Admin', 'admin')
   ON CONFLICT (id) DO UPDATE SET role = 'admin';
   ```
7. Now you can use Quick Login or manual login

## Why This Happens

Supabase by default requires users to confirm their email before they can log in. The automatic account creation in the app might succeed, but the account won't be usable until the email is confirmed.

## Quick Fix

The easiest solution is to **disable email confirmation** in Supabase settings for development/testing purposes.
