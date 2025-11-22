# Cloudinary Deployment Guide for Render

This guide explains how to configure Cloudinary environment variables on Render for the La Verdad OrderFlow backend deployment.

---

## 📋 Prerequisites

Before deploying to Render, ensure you have:

1. ✅ **Cloudinary Account** - Sign up at [cloudinary.com](https://cloudinary.com) if you don't have one
2. ✅ **Cloudinary Credentials** - Available in your Cloudinary Dashboard
3. ✅ **Render Account** - Sign up at [render.com](https://render.com)
4. ✅ **Backend Service Deployed** - Your backend service should already be deployed on Render

---

## 🔑 Step 1: Get Cloudinary Credentials

### Option A: From Cloudinary Dashboard

1. **Log in to Cloudinary Dashboard**: [https://cloudinary.com/console](https://cloudinary.com/console)
2. **Navigate to Dashboard** (should be the default landing page)
3. **Copy the following credentials:**
   - **Cloud Name**: Found at the top of the dashboard (e.g., `dp9hjzio8`)
   - **API Key**: Found in the "Account Details" section (e.g., `146234172622929`)
   - **API Secret**: Click "Show" next to API Secret to reveal it (e.g., `dTb92CL3Z4qSJrUpbLl0QojMKyE`)

### Option B: From Your Local `.env` File

If you already have Cloudinary configured locally, you can copy the credentials from `CAPSTONE/backend/.env`:

```env
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
```

⚠️ **Important**: Never commit your `.env` file to version control!

---

## 🚀 Step 2: Configure Environment Variables on Render

### 2.1 Navigate to Your Backend Service

1. **Log in to Render Dashboard**: [https://dashboard.render.com](https://dashboard.render.com)
2. **Select your backend service** from the list (e.g., "la-verdad-backend" or similar)

### 2.2 Add Environment Variables

1. **Click on "Environment"** in the left sidebar
2. **Click "Add Environment Variable"** button
3. **Add the following three variables:**

#### Variable 1: CLOUDINARY_CLOUD_NAME
- **Key**: `CLOUDINARY_CLOUD_NAME`
- **Value**: Your Cloudinary cloud name (e.g., `dp9hjzio8`)
- Click **"Add"**

#### Variable 2: CLOUDINARY_API_KEY
- **Key**: `CLOUDINARY_API_KEY`
- **Value**: Your Cloudinary API key (e.g., `146234172622929`)
- Click **"Add"**

#### Variable 3: CLOUDINARY_API_SECRET
- **Key**: `CLOUDINARY_API_SECRET`
- **Value**: Your Cloudinary API secret (e.g., `dTb92CL3Z4qSJrUpbLl0QojMKyE`)
- Click **"Add"**

### 2.3 Save and Deploy

1. **Click "Save Changes"** at the bottom of the page
2. **Render will automatically redeploy** your service with the new environment variables
3. **Wait for deployment to complete** (usually takes 2-5 minutes)

---

## ✅ Step 3: Verify Deployment

### 3.1 Check Deployment Logs

1. **Navigate to "Logs"** in the left sidebar
2. **Look for the following success messages:**
   ```
   ✅ Cloudinary configured successfully
   📦 Cloud Name: your-cloud-name
   ```

3. **If you see errors**, check that:
   - All three environment variables are set correctly
   - No extra spaces in the variable values
   - API Secret is correct (it's case-sensitive)

### 3.2 Test Profile Image Upload

1. **Log in to your deployed application**
2. **Navigate to Admin Settings** (or Student Profile if applicable)
3. **Upload a profile picture**
4. **Verify the image displays correctly**
5. **Check Cloudinary Dashboard** to confirm the image was uploaded:
   - Go to [Cloudinary Media Library](https://cloudinary.com/console/media_library)
   - Look for images in `la-verdad-uniforms/profile-images/` folder

---

## 🔧 Troubleshooting

### Issue 1: "Missing required Cloudinary environment variables" Error

**Symptoms:**
- Backend fails to start
- Error message in logs: `Missing required Cloudinary environment variables`

**Solution:**
1. Verify all three environment variables are set on Render
2. Check for typos in variable names (they are case-sensitive)
3. Ensure no extra spaces in variable values
4. Redeploy the service after adding variables

### Issue 2: Image Upload Fails with 401 Unauthorized

**Symptoms:**
- Profile image upload fails
- Error in browser console: "Failed to upload profile image"
- Backend logs show Cloudinary authentication error

**Solution:**
1. Verify `CLOUDINARY_API_SECRET` is correct
2. Check that API Secret doesn't have extra spaces
3. Regenerate API Secret in Cloudinary Dashboard if needed
4. Update the environment variable on Render

### Issue 3: Images Not Displaying (CSP Error)

**Symptoms:**
- Images upload successfully but don't display
- Browser console shows: "Refused to load image from Cloudinary due to Content Security Policy"

**Solution:**
1. Verify `frontend/index.html` includes Cloudinary domains in CSP:
   ```html
   img-src 'self' data: blob: https://*.cloudinary.com https://res.cloudinary.com
   ```
2. Rebuild and redeploy the frontend
3. Clear browser cache (Ctrl+Shift+Delete)

### Issue 4: Old Images Not Being Deleted

**Symptoms:**
- New images upload successfully
- Old images remain in Cloudinary Media Library

**Solution:**
1. Check backend logs for deletion errors
2. Verify the old image URL is a valid Cloudinary URL
3. Ensure `CLOUDINARY_API_SECRET` has delete permissions
4. Check Cloudinary Dashboard → Settings → Security → Restricted media types

---

## 📁 File Structure Reference

### Backend Files (Cloudinary Integration)

```
CAPSTONE/backend/
├── src/
│   ├── config/
│   │   └── cloudinary.js              # Cloudinary configuration
│   ├── services/
│   │   └── cloudinary.service.js      # Upload/delete functions
│   └── routes/
│       └── auth.js                    # Profile image upload endpoint
└── .env                               # Environment variables (local only)
```

### Frontend Files (Image Display)

```
CAPSTONE/frontend/
├── src/
│   ├── admin/
│   │   ├── components/
│   │   │   └── common/
│   │   │       └── AdminHeader.jsx    # Displays profile image
│   │   ├── pages/
│   │   │   └── Settings.jsx           # Profile image upload
│   │   └── hooks/
│   │       └── settings/
│   │           └── useAdminProfile.js # Profile management logic
│   ├── components/
│   │   └── auth/
│   │       └── UserProfile.jsx        # User profile dropdown
│   └── services/
│       └── profile.service.js         # Profile API calls
└── index.html                         # CSP configuration
```

---

## 🔐 Security Best Practices

### 1. Never Commit Credentials
- ✅ Keep `.env` in `.gitignore`
- ✅ Use environment variables on Render
- ❌ Never hardcode credentials in code

### 2. Use Secure HTTPS
- ✅ Cloudinary configuration uses `secure: true`
- ✅ All image URLs use HTTPS
- ✅ CSP enforces HTTPS for Cloudinary

### 3. Validate File Uploads
- ✅ Frontend validates file type (JPEG, PNG, GIF, WebP)
- ✅ Frontend validates file size (max 5MB)
- ✅ Backend validates base64 format

### 4. Implement Rate Limiting
- Consider adding rate limiting to profile image upload endpoint
- Prevents abuse and excessive Cloudinary usage

---

## 📊 Monitoring Cloudinary Usage

### Check Usage Statistics

1. **Log in to Cloudinary Dashboard**
2. **Navigate to "Usage"** in the left sidebar
3. **Monitor the following metrics:**
   - **Transformations**: Number of image transformations (resizing, format conversion)
   - **Storage**: Total storage used (MB/GB)
   - **Bandwidth**: Data transfer (MB/GB)
   - **Requests**: API requests made

### Free Tier Limits

Cloudinary's free tier includes:
- **25 GB storage**
- **25 GB bandwidth per month**
- **25,000 transformations per month**

If you exceed these limits, consider upgrading to a paid plan.

---

## 🎯 Next Steps

After successful deployment:

1. ✅ **Test profile image upload** on production
2. ✅ **Verify images display correctly** from Cloudinary CDN
3. ✅ **Monitor Cloudinary usage** in the dashboard
4. ✅ **Set up alerts** for usage thresholds (optional)
5. ✅ **Document any custom transformations** you add in the future

---

## 📚 Additional Resources

- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [Cloudinary Node.js SDK](https://cloudinary.com/documentation/node_integration)
- [Render Environment Variables Guide](https://render.com/docs/environment-variables)
- [Content Security Policy (CSP) Guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)

---

## 🆘 Support

If you encounter issues not covered in this guide:

1. **Check Render Logs**: Look for specific error messages
2. **Check Cloudinary Logs**: Available in Cloudinary Dashboard → Reports → Activity
3. **Review Backend Logs**: Check for Cloudinary-related errors
4. **Test Locally First**: Ensure it works locally before deploying

---

**Last Updated**: 2025-11-10
**Version**: 1.0.0

