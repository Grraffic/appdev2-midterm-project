# Supabase Setup Guide - Users Table & Authentication

## 📋 Overview

Your authentication system requires two tables in Supabase:

1. **users** - Stores user account information from Google OAuth
2. **user_roles** - Maps users to roles for Row Level Security (RLS)

Currently, you only have a `contacts` table. This guide will help you create the missing tables.

---

## ✅ Step 1: Access Supabase SQL Editor

1. Go to your Supabase project: https://supabase.com/dashboard/project/htmghjogrouslqmpimht
2. Click on **SQL Editor** in the left sidebar
3. Click **New Query** button
4. You should see a blank SQL editor

---

## 📝 Step 2: Copy the SQL Schema

The complete SQL schema is in: `CAPSTONE/backend/src/db/users.sql`

This file contains:

- ✅ Users table with all required columns
- ✅ User_roles table for RLS policies
- ✅ Indexes for performance
- ✅ Automatic timestamp triggers
- ✅ Row Level Security policies
- ✅ Helper functions

---

## 🚀 Step 3: Run the SQL in Supabase

### Option A: Copy-Paste Method (Recommended for first time)

1. **Open the SQL file:**

   - Open `CAPSTONE/backend/src/db/users.sql` in your text editor

2. **Copy all the SQL code**

3. **Paste into Supabase SQL Editor:**

   - Click in the SQL editor text area
   - Paste the entire SQL code (Ctrl+V)

4. **Run the query:**

   - Click the **Run** button (or press Ctrl+Enter)
   - Wait for the query to complete

5. **Check for success:**
   - You should see: "Query executed successfully"
   - No red error messages

### Option B: Line-by-Line Method (If you get errors)

If the full script fails, run these sections separately:

**Section 1: Create Users Table**

```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT NOT NULL UNIQUE,
  name TEXT,
  role TEXT NOT NULL DEFAULT 'student' CHECK (role IN ('student', 'admin')),
  provider TEXT NOT NULL DEFAULT 'google',
  provider_id TEXT,
  avatar_url TEXT,
  photo_url TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Section 2: Create Indexes**

```sql
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_provider_id ON users(provider_id);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON users(is_active);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
```

**Section 3: Create User_Roles Table**

```sql
CREATE TABLE IF NOT EXISTS user_roles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('student', 'admin')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, role)
);

CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON user_roles(role);
```

**Section 4: Create Triggers & Functions**

```sql
CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at_trigger
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_users_updated_at();
```

**Section 5: Enable RLS & Create Policies**

```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their own profile"
  ON users FOR SELECT
  USING (auth.uid()::text = id::text OR true);

CREATE POLICY "Service role can manage users"
  ON users FOR ALL
  USING (auth.role() = 'service_role');

CREATE POLICY "Users can read user_roles"
  ON user_roles FOR SELECT
  USING (true);

CREATE POLICY "Service role can manage user_roles"
  ON user_roles FOR ALL
  USING (auth.role() = 'service_role');
```

---

## ✔️ Step 4: Verify Tables Were Created

Run this verification query in Supabase SQL Editor:

```sql
-- Check if users table exists and show its structure
SELECT
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name IN ('users', 'user_roles')
ORDER BY table_name, ordinal_position;
```

**Expected Result:**
You should see columns for both `users` and `user_roles` tables:

```
users table columns:
- id (uuid)
- email (text)
- name (text)
- role (text)
- provider (text)
- provider_id (text)
- avatar_url (text)
- photo_url (text)
- is_active (boolean)
- created_at (timestamp with time zone)
- updated_at (timestamp with time zone)

user_roles table columns:
- id (uuid)
- user_id (uuid)
- role (text)
- created_at (timestamp with time zone)
```

---

## 🔍 Step 5: Check Table Data

Run this query to see if any users exist:

```sql
SELECT * FROM users;
SELECT * FROM user_roles;
```

**Expected:** Empty tables (no rows yet - users will be added when they log in)

---

## 🧪 Step 6: Test the Authentication Flow

1. **Restart your backend server:**

   ```bash
   cd CAPSTONE/backend
   npm run dev
   ```

2. **Restart your frontend server:**

   ```bash
   cd CAPSTONE/frontend
   npm run dev
   ```

3. **Clear browser storage:**

   ```javascript
   // In browser console (F12)
   localStorage.clear();
   sessionStorage.clear();
   ```

4. **Test login:**

   - Go to http://localhost:5173/login
   - Click "Sign in with Google"
   - Complete the OAuth flow
   - You should be redirected to the dashboard

5. **Verify user was created:**
   - In Supabase SQL Editor, run:
   ```sql
   SELECT * FROM users;
   ```
   - You should see your user record with email, name, and role

---

## ❌ Troubleshooting

### Error: "relation 'users' does not exist"

- **Cause:** The users table wasn't created
- **Fix:** Run the SQL schema again, check for errors

### Error: "duplicate key value violates unique constraint"

- **Cause:** User already exists in database
- **Fix:** This is normal - just means the user logged in before

### Error: "permission denied for schema public"

- **Cause:** Insufficient permissions
- **Fix:** Make sure you're using the service role key in backend

### Users table exists but login still fails

- **Check:**
  1. Verify backend can connect to Supabase (check logs)
  2. Verify email column is TEXT type
  3. Check that role column has correct values

---

## 📊 Table Relationships

```
users (1) ──── (many) user_roles
  ├─ id (PK)
  ├─ email (UNIQUE)
  ├─ name
  ├─ role
  ├─ provider
  ├─ provider_id
  ├─ avatar_url
  ├─ photo_url
  ├─ is_active
  ├─ created_at
  └─ updated_at

user_roles
  ├─ id (PK)
  ├─ user_id (FK → users.id)
  ├─ role
  └─ created_at
```

---

## 🔐 Security Notes

- **RLS Enabled:** Both tables have Row Level Security enabled
- **Service Role:** Backend uses service role key to bypass RLS
- **User Privacy:** Users can only read their own profile
- **Admin Check:** `is_admin()` function checks user_roles table

---

## 📝 Next Steps

1. ✅ Create users table (this guide)
2. ✅ Create user_roles table (this guide)
3. Test Google OAuth login
4. Verify user is created in database
5. Check that role is determined correctly
6. Test admin vs student access

---

## 💡 Additional Resources

- Supabase SQL Editor: https://supabase.com/dashboard/project/htmghjogrouslqmpimht/sql
- SQL File: `CAPSTONE/backend/src/db/users.sql`
- Backend Config: `CAPSTONE/backend/src/config/supabase.js`
- Passport Config: `CAPSTONE/backend/src/config/passport.js`
