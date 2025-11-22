# Render Backend Connection Testing Guide

Step-by-step guide to test your Render backend deployment and verify frontend-backend connectivity.

---

## 📋 Prerequisites

Before testing, ensure:

- ✅ All environment variables are set on Render (see `RENDER_DEPLOYMENT_SETUP.md`)
- ✅ Backend has been redeployed after adding environment variables
- ✅ Frontend CSP has been updated to include Render backend URL
- ✅ Frontend environment files are configured (`.env.development` and `.env.production`)

---

## 🧪 Test 1: Backend Health Check

### Test 1.1: Root Endpoint (Expected to Fail)

**Command:**
```bash
curl https://capstone-ordertracking-be.onrender.com/
```

**Expected Response:**
```
Cannot GET /
```

**Status:** ✅ This is NORMAL - your backend has no root route defined.

### Test 1.2: API Endpoint (Should Work)

**Command:**
```bash
curl https://capstone-ordertracking-be.onrender.com/api/auth/profile
```

**Expected Response:**
```json
{
  "message": "No token provided"
}
```
OR
```json
{
  "message": "Unauthorized"
}
```

**Status:** ✅ If you get either response, the backend is running correctly!

### Test 1.3: Check Deployment Logs

1. **Log in to Render Dashboard**: [https://dashboard.render.com](https://dashboard.render.com)
2. **Select your backend service**
3. **Click "Logs"** in the left sidebar
4. **Look for these success messages:**
   ```
   ✅ Cloudinary configured successfully
   📦 Cloud Name: dp9hjzio8
   🚀 Server running on port 5000
   ✅ Supabase connection successful
   ```

**Status:** [ ] Pass [ ] Fail

**Notes:**
_______________________________________________________

---

## 🧪 Test 2: Environment Variables Verification

### Test 2.1: Check Cloudinary Configuration

**What to Check:**
- Backend logs should show: `✅ Cloudinary configured successfully`
- Backend logs should show: `📦 Cloud Name: dp9hjzio8`

**If Missing:**
1. Go to Render Dashboard → Environment
2. Verify these variables exist:
   - `CLOUDINARY_CLOUD_NAME`
   - `CLOUDINARY_API_KEY`
   - `CLOUDINARY_API_SECRET`
3. Click "Save Changes" and wait for redeploy

**Status:** [ ] Pass [ ] Fail

### Test 2.2: Check Database Connection

**What to Check:**
- Backend logs should show: `✅ Supabase connection successful`

**If Missing:**
1. Go to Render Dashboard → Environment
2. Verify these variables exist:
   - `DATABASE_URL`
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
3. Click "Save Changes" and wait for redeploy

**Status:** [ ] Pass [ ] Fail

### Test 2.3: Check Google OAuth Configuration

**What to Check:**
- `GOOGLE_CLIENT_ID` is set
- `GOOGLE_CLIENT_SECRET` is set
- `GOOGLE_CALLBACK_URL` is set to: `https://capstone-ordertracking-be.onrender.com/api/auth/google/callback`

**Status:** [ ] Pass [ ] Fail

---

## 🧪 Test 3: Frontend Configuration

### Test 3.1: Verify Environment Files

**Check `.env.development`:**
```bash
cat CAPSTONE/frontend/.env.development
```

**Expected Content:**
```env
VITE_API_URL=http://localhost:5000/api
VITE_SUPABASE_URL=https://htmghjogrouslqmpimht.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Status:** [ ] Pass [ ] Fail

**Check `.env.production`:**
```bash
cat CAPSTONE/frontend/.env.production
```

**Expected Content:**
```env
VITE_API_URL=https://capstone-ordertracking-be.onrender.com/api
VITE_SUPABASE_URL=https://htmghjogrouslqmpimht.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Status:** [ ] Pass [ ] Fail

### Test 3.2: Verify CSP Configuration

**Check `frontend/index.html`:**
```bash
grep "Content-Security-Policy" CAPSTONE/frontend/index.html
```

**Expected:** Should include `https://capstone-ordertracking-be.onrender.com` in both:
- `default-src` directive
- `connect-src` directive

**Status:** [ ] Pass [ ] Fail

---

## 🧪 Test 4: Local Frontend with Render Backend

### Test 4.1: Start Frontend in Development Mode

**Command:**
```bash
cd CAPSTONE/frontend
npm run dev
```

**Expected Output:**
```
VITE v7.0.4  ready in XXX ms

➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

**Status:** [ ] Pass [ ] Fail

### Test 4.2: Check API URL in Browser Console

1. **Open browser**: `http://localhost:5173`
2. **Open DevTools** (F12) → Console tab
3. **Run this command**:
   ```javascript
   console.log(import.meta.env.VITE_API_URL);
   ```

**Expected Output:**
```
http://localhost:5000/api
```

**Status:** [ ] Pass [ ] Fail

### Test 4.3: Test API Connection from Browser

**In browser console, run:**
```javascript
fetch('http://localhost:5000/api/auth/profile')
  .then(r => r.json())
  .then(console.log)
  .catch(console.error);
```

**Expected Response:**
```json
{
  "message": "No token provided"
}
```

**Status:** [ ] Pass [ ] Fail

---

## 🧪 Test 5: Google OAuth Login Flow

### Test 5.1: Navigate to Login Page

1. **Open browser**: `http://localhost:5173`
2. **Click "Login"** or navigate to `/login`
3. **Verify login page loads** correctly

**Status:** [ ] Pass [ ] Fail

### Test 5.2: Click "Sign in with Google"

1. **Click "Sign in with Google"** button
2. **Verify Google OAuth popup** appears
3. **Select your Google account**
4. **Complete authentication**

**Expected Behavior:**
- ✅ No CORS errors in console
- ✅ No CSP errors in console
- ✅ Redirected to appropriate dashboard (admin or student)
- ✅ User profile loaded correctly

**Status:** [ ] Pass [ ] Fail

**Notes:**
_______________________________________________________

### Test 5.3: Verify User Profile

1. **Check top-right corner** for user profile image
2. **Click on profile image** to open dropdown
3. **Verify user name and email** are displayed correctly

**Status:** [ ] Pass [ ] Fail

---

## 🧪 Test 6: Profile Image Upload (Cloudinary)

### Test 6.1: Navigate to Settings

1. **Click on profile dropdown**
2. **Click "Settings"** (if admin) or navigate to profile page
3. **Verify settings page loads**

**Status:** [ ] Pass [ ] Fail

### Test 6.2: Upload Profile Image

1. **Click on profile image** or camera icon
2. **Select an image file** (JPEG, PNG, GIF, or WebP)
3. **Wait for upload** to complete
4. **Click "Save Changes"**

**Expected Behavior:**
- ✅ Image preview updates immediately
- ✅ Success toast notification appears
- ✅ No console errors
- ✅ Image displays correctly

**Status:** [ ] Pass [ ] Fail

### Test 6.3: Verify Image in Cloudinary

1. **Open Cloudinary Dashboard**: [https://cloudinary.com/console/media_library](https://cloudinary.com/console/media_library)
2. **Navigate to**: `la-verdad-uniforms/profile-images/`
3. **Verify image exists** with correct filename format

**Status:** [ ] Pass [ ] Fail

---

## 🧪 Test 7: Production Build

### Test 7.1: Build Frontend for Production

**Command:**
```bash
cd CAPSTONE/frontend
npm run build
```

**Expected Output:**
```
vite v7.1.5 building for production...
✓ 2601 modules transformed.
✓ built in XX.XXs
```

**Status:** [ ] Pass [ ] Fail

### Test 7.2: Verify Production Environment

**Check build output:**
```bash
grep -r "capstone-ordertracking-be.onrender.com" CAPSTONE/frontend/dist/
```

**Expected:** Should find references to Render backend URL in built files

**Status:** [ ] Pass [ ] Fail

### Test 7.3: Preview Production Build

**Command:**
```bash
npm run preview
```

**Expected Output:**
```
➜  Local:   http://localhost:4173/
```

1. **Open browser**: `http://localhost:4173`
2. **Test login flow** again
3. **Verify everything works** with production build

**Status:** [ ] Pass [ ] Fail

---

## 🧪 Test 8: CORS and CSP Verification

### Test 8.1: Check for CORS Errors

**In browser console, look for:**
```
Access to fetch at '...' from origin '...' has been blocked by CORS policy
```

**Expected:** ✅ No CORS errors

**Status:** [ ] Pass [ ] Fail

**If CORS errors appear:**
1. Verify `FRONTEND_URL` is set correctly on Render
2. Ensure `FRONTEND_URL` matches your actual frontend URL
3. Redeploy backend after updating

### Test 8.2: Check for CSP Errors

**In browser console, look for:**
```
Refused to connect to '...' because it violates the following Content Security Policy directive
```

**Expected:** ✅ No CSP errors

**Status:** [ ] Pass [ ] Fail

**If CSP errors appear:**
1. Verify `frontend/index.html` includes Render backend URL in CSP
2. Rebuild frontend after updating CSP
3. Clear browser cache (Ctrl+Shift+Delete)

---

## 🧪 Test 9: API Endpoints Testing

### Test 9.1: Test Inventory API

**In browser console:**
```javascript
fetch('http://localhost:5000/api/inventory', {
  headers: {
    'Authorization': 'Bearer ' + localStorage.getItem('authToken')
  }
})
.then(r => r.json())
.then(console.log)
.catch(console.error);
```

**Expected:** Inventory items array or authentication error

**Status:** [ ] Pass [ ] Fail

### Test 9.2: Test Orders API

**In browser console:**
```javascript
fetch('http://localhost:5000/api/orders', {
  headers: {
    'Authorization': 'Bearer ' + localStorage.getItem('authToken')
  }
})
.then(r => r.json())
.then(console.log)
.catch(console.error);
```

**Expected:** Orders array or authentication error

**Status:** [ ] Pass [ ] Fail

---

## 📊 Test Summary

### Overall Results

- **Total Tests**: 9 test categories
- **Tests Passed**: _____ / 9
- **Tests Failed**: _____ / 9

### Critical Issues Found

1. _______________________________________________________
2. _______________________________________________________
3. _______________________________________________________

### Non-Critical Issues Found

1. _______________________________________________________
2. _______________________________________________________
3. _______________________________________________________

---

## 🆘 Common Issues and Solutions

### Issue 1: "Cannot GET /" Error

**Solution:** This is normal! API routes are at `/api/*`, not at root `/`.

### Issue 2: CORS Errors

**Solution:**
1. Set `FRONTEND_URL` on Render
2. Ensure it matches your frontend URL exactly
3. Redeploy backend

### Issue 3: CSP Errors

**Solution:**
1. Update `frontend/index.html` CSP
2. Include Render backend URL
3. Rebuild frontend

### Issue 4: Environment Variables Not Loading

**Solution:**
1. Check all variables are set on Render
2. No extra spaces in values
3. Click "Save Changes"
4. Wait for redeploy

### Issue 5: Google OAuth Fails

**Solution:**
1. Update `GOOGLE_CALLBACK_URL` to use Render URL
2. Update Google Cloud Console authorized redirect URIs
3. Redeploy backend

---

## ✅ Next Steps

After all tests pass:

1. ✅ **Deploy frontend** to production (Vercel, Netlify, or Render)
2. ✅ **Update `FRONTEND_URL`** on Render to production frontend URL
3. ✅ **Test production deployment** end-to-end
4. ✅ **Monitor logs** for any errors
5. ✅ **Update Google OAuth** redirect URIs for production

---

**Last Updated**: 2025-11-10
**Version**: 1.0.0

