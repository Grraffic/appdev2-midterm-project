# 🚀 Complete Deployment Guide

## Current Deployment URLs

- **Frontend (Vercel)**: https://capstone-order-tracking-fe.vercel.app/
- **Backend (Render)**: https://capstone-ordertracking-be.onrender.com

---

## 📋 Pre-Deployment Checklist

### ✅ Backend (Render) - Already Deployed

Your backend is already deployed on Render. Let's verify and update the configuration.

### ✅ Frontend (Vercel) - Already Deployed

Your frontend is already deployed on Vercel. Let's verify and update the configuration.

---

## 🔧 Step 1: Update Backend Environment Variables on Render

### 1.1 Update FRONTEND_URL

The backend needs to know your production frontend URL for CORS.

1. Go to: https://dashboard.render.com
2. Select your service: **capstone-ordertracking-be**
3. Click **Environment** in the left sidebar
4. Find or add `FRONTEND_URL` and set it to:
   ```
   https://capstone-order-tracking-fe.vercel.app
   ```
5. Update `GOOGLE_CALLBACK_URL` to:
   ```
   https://capstone-ordertracking-be.onrender.com/api/auth/google/callback
   ```
6. Click **Save Changes**
7. Wait 2-5 minutes for automatic redeployment

### 1.2 Verify All Backend Environment Variables

Make sure these are set on Render:

```env
PORT=5000
JWT_SECRET=9d7d3b79c6a542ff8b54c75e3f7bd393af2e491dcb7b45678901234567890abc
JWT_EXPIRE=30d
DATABASE_URL=postgresql://postgres.htmghjogrouslqmpimht:09651221953Gr@aws-1-ap-southeast-1.pooler.supabase.com:6543/postgres?sslmode=no-verify
SUPABASE_URL=https://htmghjogrouslqmpimht.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh0bWdoam9ncm91c2xxbXBpbWh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA4MzcyNDgsImV4cCI6MjA3NjQxMzI0OH0.8r_wozENW62PL3zKOeDvPtmzt0TGY5RBXIqDDeX1SXQ
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh0bWdoam9ncm91c2xxbXBpbWh0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDgzNzI0OCwiZXhwIjoyMDc2NDEzMjQ4fQ.T8zXRr75LPKch-1ZMzrXccFaU1RkRFrfK6RfETTWpJc
CLOUDINARY_CLOUD_NAME=your_cloudinary_cloud_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
GOOGLE_CALLBACK_URL=https://capstone-ordertracking-be.onrender.com/api/auth/google/callback
FRONTEND_URL=https://capstone-order-tracking-fe.vercel.app
```

---

## 🌐 Step 2: Update Frontend Environment Variables on Vercel

### 2.1 Set Production Environment Variables

1. Go to: https://vercel.com/dashboard
2. Select your project: **capstone-order-tracking-fe**
3. Click **Settings** → **Environment Variables**
4. Add/Update these variables:

```env
VITE_API_URL=https://capstone-ordertracking-be.onrender.com/api
VITE_SUPABASE_URL=https://htmghjogrouslqmpimht.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh0bWdoam9ncm91c2xxbXBpbWh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA4MzcyNDgsImV4cCI6MjA3NjQxMzI0OH0.8r_wozENW62PL3zKOeDvPtmzt0TGY5RBXIqDDeX1SXQ
```

5. Make sure to select **Production** environment
6. Click **Save**

### 2.2 Redeploy Frontend

After saving environment variables:

1. Go to **Deployments** tab
2. Click the **⋯** menu on the latest deployment
3. Click **Redeploy**
4. Wait 2-3 minutes for deployment to complete

---

## 🔄 Step 3: Deploy Latest Changes

### 3.1 Backend Deployment (Render)

Render automatically deploys when you push to your main branch.

**Manual deployment:**

1. Go to Render Dashboard
2. Select **capstone-ordertracking-be**
3. Click **Manual Deploy** → **Deploy latest commit**

### 3.2 Frontend Deployment (Vercel)

Vercel automatically deploys when you push to your main branch.

**Manual deployment from local:**

```bash
cd CAPSTONE/frontend
npm run build
# Vercel will auto-deploy from GitHub
```

**Or push to GitHub:**

```bash
cd CAPSTONE
git add .
git commit -m "Update deployment configuration"
git push origin main
```

---

## ✅ Step 4: Verify Deployment

### 4.1 Test Backend

```bash
curl https://capstone-ordertracking-be.onrender.com/api/auth/profile
```

Expected: `{"message": "No token provided"}` ✅

### 4.2 Test Frontend

1. Open: https://capstone-order-tracking-fe.vercel.app/
2. Check browser console for errors
3. Try logging in with Google OAuth
4. Verify API calls are going to the Render backend

---

## 🔍 Troubleshooting

### Issue: CORS Errors

**Solution:** Make sure `FRONTEND_URL` on Render matches your Vercel URL exactly (no trailing slash)

### Issue: Google OAuth Not Working

**Solution:** Update Google Cloud Console:

1. Go to: https://console.cloud.google.com
2. Navigate to: APIs & Services → Credentials
3. Add authorized redirect URIs:
   - `https://capstone-ordertracking-be.onrender.com/api/auth/google/callback`
   - `https://capstone-order-tracking-fe.vercel.app/auth/callback`

### Issue: Environment Variables Not Loading

**Solution:** Redeploy after changing environment variables

---

## 📝 Next Steps

1. ✅ Update backend `FRONTEND_URL` on Render
2. ✅ Update frontend `VITE_API_URL` on Vercel
3. ✅ Update Google OAuth redirect URIs
4. ✅ Test the deployment
5. ✅ Monitor logs for any errors

---

## 📚 Additional Resources

- [Render Documentation](https://render.com/docs)
- [Vercel Documentation](https://vercel.com/docs)
- [Google OAuth Setup](https://console.cloud.google.com)
