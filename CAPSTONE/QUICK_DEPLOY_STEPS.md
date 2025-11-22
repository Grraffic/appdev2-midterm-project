# 🚀 Quick Deployment Steps

## Current Status
- ✅ Backend deployed on Render: https://capstone-ordertracking-be.onrender.com
- ✅ Frontend deployed on Vercel: https://capstone-order-tracking-fe.vercel.app/

---

## 🎯 What You Need to Do Now

### Step 1: Update Backend Environment Variables on Render

1. **Go to Render Dashboard**: https://dashboard.render.com
2. **Select your service**: `capstone-ordertracking-be`
3. **Click**: Environment (left sidebar)
4. **Update/Add these variables**:

```env
FRONTEND_URL=https://capstone-order-tracking-fe.vercel.app
GOOGLE_CALLBACK_URL=https://capstone-ordertracking-be.onrender.com/api/auth/google/callback
```

5. **Click**: Save Changes
6. **Wait**: 2-5 minutes for automatic redeployment

---

### Step 2: Update Frontend Environment Variables on Vercel

1. **Go to Vercel Dashboard**: https://vercel.com/dashboard
2. **Select your project**: `capstone-order-tracking-fe`
3. **Click**: Settings → Environment Variables
4. **Add/Update these variables** (for Production environment):

```env
VITE_API_URL=https://capstone-ordertracking-be.onrender.com/api
VITE_SUPABASE_URL=https://htmghjogrouslqmpimht.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh0bWdoam9ncm91c2xxbXBpbWh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA4MzcyNDgsImV4cCI6MjA3NjQxMzI0OH0.8r_wozENW62PL3zKOeDvPtmzt0TGY5RBXIqDDeX1SXQ
```

5. **Click**: Save
6. **Go to**: Deployments tab
7. **Click**: ⋯ menu on latest deployment → Redeploy

---

### Step 3: Update Google OAuth Settings

1. **Go to**: https://console.cloud.google.com
2. **Navigate to**: APIs & Services → Credentials
3. **Select your OAuth 2.0 Client ID**
4. **Add Authorized redirect URIs**:
   ```
   https://capstone-ordertracking-be.onrender.com/api/auth/google/callback
   https://capstone-order-tracking-fe.vercel.app/auth/callback
   ```
5. **Click**: Save

---

### Step 4: Deploy Your Latest Code Changes

Since you have uncommitted changes (the HeroSection fix), let's deploy them:

#### Option A: Using PowerShell Script (Recommended)
```powershell
cd C:\Users\Rafael\OneDrive\Desktop
.\CAPSTONE\deploy.ps1 both
```

#### Option B: Manual Deployment
```powershell
# Navigate to repository root
cd C:\Users\Rafael\OneDrive\Desktop

# Add all changes
git add CAPSTONE/

# Commit changes
git commit -m "Fix HeroSection z-index layering and update deployment configuration"

# Push to GitHub
git push origin main
```

**Note**: Both Render and Vercel will automatically deploy when you push to GitHub!

---

### Step 5: Verify Deployment

#### Test Backend
Open PowerShell and run:
```powershell
curl https://capstone-ordertracking-be.onrender.com/api/auth/profile
```
Expected response: `{"message": "No token provided"}` ✅

#### Test Frontend
1. Open: https://capstone-order-tracking-fe.vercel.app/
2. Open browser DevTools (F12)
3. Check Console for errors
4. Try logging in with Google
5. Navigate to All Products page
6. Verify the HeroSection background stays fixed when scrolling

---

## 🔍 Troubleshooting

### Issue: "CORS Error" in browser console
**Solution**: 
- Make sure `FRONTEND_URL` on Render is set to: `https://capstone-order-tracking-fe.vercel.app` (no trailing slash)
- Redeploy backend after changing

### Issue: "Failed to fetch" or "Network Error"
**Solution**:
- Check if `VITE_API_URL` on Vercel is set correctly
- Redeploy frontend after changing environment variables

### Issue: Google OAuth not working
**Solution**:
- Verify redirect URIs in Google Cloud Console
- Make sure both backend and frontend URLs are added

### Issue: Images not loading
**Solution**:
- Check Cloudinary environment variables on Render
- Verify Supabase environment variables on Vercel

---

## 📊 Deployment Checklist

- [ ] Backend `FRONTEND_URL` updated on Render
- [ ] Backend `GOOGLE_CALLBACK_URL` updated on Render
- [ ] Frontend `VITE_API_URL` updated on Vercel
- [ ] Frontend `VITE_SUPABASE_URL` updated on Vercel
- [ ] Frontend `VITE_SUPABASE_ANON_KEY` updated on Vercel
- [ ] Google OAuth redirect URIs updated
- [ ] Latest code pushed to GitHub
- [ ] Backend deployment successful on Render
- [ ] Frontend deployment successful on Vercel
- [ ] Backend API responding correctly
- [ ] Frontend loading without errors
- [ ] Google OAuth login working
- [ ] HeroSection z-index fix working

---

## 🎉 After Successful Deployment

Your application will be live at:
- **Frontend**: https://capstone-order-tracking-fe.vercel.app/
- **Backend**: https://capstone-ordertracking-be.onrender.com

**Next Steps**:
1. Test all features thoroughly
2. Monitor logs for any errors
3. Share the link with your team/instructor
4. Celebrate! 🎊

---

## 📝 Important Notes

- **Render Free Tier**: Backend may sleep after 15 minutes of inactivity. First request after sleep takes ~30 seconds.
- **Vercel**: Frontend is always fast and available.
- **Environment Variables**: Always redeploy after changing environment variables.
- **Git Push**: Both platforms auto-deploy when you push to main branch.

---

## 🆘 Need Help?

If you encounter any issues:
1. Check Render logs: https://dashboard.render.com → Your Service → Logs
2. Check Vercel logs: https://vercel.com/dashboard → Your Project → Deployments → View Logs
3. Check browser console for frontend errors (F12)
4. Verify all environment variables are set correctly

