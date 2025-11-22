# QR Code Scanner Testing & Troubleshooting Guide

## 🎯 Overview

This guide will help you test and troubleshoot the QR code scanning functionality on the admin Orders page.

---

## ✅ What Should Happen (Expected Flow)

### **Student Side:**
1. Student submits an order from AllProducts page
2. Order is saved to database with status "pending"
3. Inventory is **immediately reduced** for all items
4. QR code receipt is displayed with order details
5. Student can download/print the QR code

### **Admin Side:**
1. Admin clicks "Scan QR Code" button on Orders page
2. Camera modal opens with live video feed
3. Admin points camera at student's QR code
4. Scanner detects QR code automatically
5. **Processing overlay appears** with "Processing order..." message
6. Order status updates from "pending" → "completed"
7. **Success notification appears** (green, bottom-right) with:
   - Order number
   - Student name
   - Items updated
8. Order moves from "Processing" tab to "Claimed" tab
9. Scanner modal closes after 3 seconds

---

## 🔍 Troubleshooting Steps

### **Issue 1: Scanner Not Detecting QR Code**

#### **Possible Causes:**
1. **Camera permissions not granted**
2. **QR code is too small or blurry**
3. **Poor lighting conditions**
4. **QR code format is incorrect**
5. **Browser doesn't support camera API**

#### **Solutions:**
{"type":"order_receipt","orderNumber":"ORD-20251106-47410","studentName":"Rafael Ramos","studentEmail":"rafaelramos@student.laverdad.edu.ph","educationLevel":"Elementary","orderDate":"2025-11-05T23:33:48.690Z","totalAmount":0,"items":[{"name":"New Logo Patch","quantity":1,"price":0,"size":"N/A","category":null}],"status":"pending"}
**A. Check Camera Permissions:**
```
1. Open browser console (F12)
2. Look for error: "Failed to access camera. Please check permissions."
3. Grant camera permissions:
   - Chrome: Click camera icon in address bar → Allow
   - Firefox: Click camera icon → Allow
   - Edge: Click camera icon → Allow
4. Refresh the page and try again
```

**B. Check QR Code Quality:**
```
1. Make sure QR code is clearly visible
2. QR code should be at least 200x200 pixels on screen
3. Ensure good lighting (no glare or shadows)
4. Hold camera steady for 2-3 seconds
5. Try moving camera closer/farther from QR code
```

**C. Check Browser Compatibility:**
```
Supported Browsers:
✅ Chrome 87+
✅ Firefox 90+
✅ Edge 87+
✅ Safari 14.1+

Not Supported:
❌ Internet Explorer
❌ Old mobile browsers
```

**D. Check Console Logs:**
```
Open browser console (F12) and look for these messages:

✅ Good signs:
- "📷 QR Scanner detected code: {...}"
- "✅ Valid order receipt detected: {...}"
- "🔄 Calling onScan callback..."
- "🔍 QR Code Scanned - Starting processing..."

❌ Error signs:
- "QR decode error: ..." (normal, scanner tries continuously)
- "Failed to access camera..."
- "Scanner initialization error: ..."
```

---

### **Issue 2: Scanner Detects QR Code But Nothing Happens**

#### **Check Console Logs:**
```javascript
Expected console output when scanning:

1. "📷 QR Scanner detected code: {JSON data}"
2. "✅ Valid order receipt detected: {order data}"
3. "🔄 Calling onScan callback..."
4. "🔍 QR Code Scanned - Starting processing..."
5. "Processing scanned QR code: {data}"
6. "Parsed order data: {order data}"
7. "Found order: {order from database}"
8. "Order status updated to completed: {updated order}"
9. "Inventory reduced: {item name} by {quantity}"
10. "✅ QR Code Processing Complete: {result}"
11. "✅ Order claimed successfully, refreshing orders..."
```

#### **If Processing Stops at Step 6:**
```
Problem: Order not found in database

Solutions:
1. Check if order exists in database:
   - Go to Supabase dashboard
   - Open "orders" table
   - Search for order_number from QR code

2. Check if order_number matches:
   - QR code contains: "orderNumber": "ORD-20250205-12345"
   - Database should have: order_number = "ORD-20250205-12345"

3. Check backend API:
   - Open Network tab in browser console
   - Look for: GET /api/orders/number/ORD-XXXXX
   - Check response status (should be 200)
```

#### **If Processing Stops at Step 8:**
```
Problem: Failed to update order status

Solutions:
1. Check backend API:
   - Open Network tab
   - Look for: PATCH /api/orders/{id}/status
   - Check response status (should be 200)

2. Check backend logs:
   - Look for errors in backend console
   - Check if Supabase connection is working

3. Check order status:
   - Order might already be "completed"
   - Error: "Order already claimed on [date]"
```

#### **If Processing Stops at Step 9:**
```
Problem: Failed to reduce inventory

Solutions:
1. Check if inventory items exist:
   - Go to Supabase dashboard
   - Open "inventory" table
   - Search for item names from order

2. Check inventory matching:
   - Item name must match exactly (case-insensitive)
   - Education level must match
   - Item must be active (is_active = true)

3. Check backend logs:
   - Look for: "Failed to find inventory for {item name}"
   - Look for: "Failed to update inventory for {item name}"
```

---

### **Issue 3: "Invalid QR Code Format" Error**

#### **Check QR Code Data Format:**
```javascript
Valid QR code data should be JSON string:

{
  "type": "order_receipt",
  "orderNumber": "ORD-20250205-12345",
  "studentId": "user123",
  "studentName": "John Doe",
  "studentEmail": "john@student.laverdad.edu.ph",
  "educationLevel": "Higher Education",
  "orderDate": "2025-02-05T10:30:00.000Z",
  "totalAmount": 0,
  "items": [
    {
      "name": "Blouse",
      "quantity": 2,
      "price": 0,
      "size": "Medium",
      "category": "Uniform"
    }
  ],
  "status": "pending"
}
```

#### **Required Fields:**
- ✅ `type` must be `"order_receipt"`
- ✅ `orderNumber` must exist and not be empty
- ✅ All other fields are optional but recommended

---

### **Issue 4: "Order Already Claimed" Error**

#### **This is Expected Behavior:**
```
The system prevents duplicate claims to avoid:
- Reducing inventory twice
- Giving items to student twice
- Data inconsistency
```

#### **To Test Again:**
```
Option 1: Create a new order
1. Go to student AllProducts page
2. Submit a new order
3. Scan the new QR code

Option 2: Reset order status in database (for testing only)
1. Go to Supabase dashboard
2. Open "orders" table
3. Find the order
4. Change status from "completed" back to "pending"
5. Clear claimed_date field
6. Save changes
7. Try scanning again
```

---

## 🧪 Testing Checklist

### **Pre-Testing Setup:**
- [ ] Backend server is running (`npm run dev` in backend folder)
- [ ] Frontend server is running (`npm run dev` in frontend folder)
- [ ] Supabase database is accessible
- [ ] Camera permissions are granted
- [ ] Browser console is open (F12) to see logs

### **Test 1: Complete Order Flow**
- [ ] Submit order from student page
- [ ] Verify order appears in admin Orders page (Processing tab)
- [ ] Verify inventory was reduced immediately
- [ ] Click "Scan QR Code" button
- [ ] Camera modal opens successfully
- [ ] Point camera at QR code
- [ ] Scanner detects QR code (see console logs)
- [ ] Processing overlay appears
- [ ] Success notification appears
- [ ] Order moves to "Claimed" tab
- [ ] Scanner modal closes automatically

### **Test 2: Duplicate Prevention**
- [ ] Try scanning the same QR code again
- [ ] Error notification appears
- [ ] Message: "Order already claimed on [date]"
- [ ] Order status remains "completed"
- [ ] Inventory is NOT reduced again

### **Test 3: Invalid QR Code**
- [ ] Scan a random QR code (not an order receipt)
- [ ] Error notification appears
- [ ] Message: "Invalid QR code format..."

### **Test 4: Order Not Found**
- [ ] Create a fake QR code with non-existent order number
- [ ] Scan the fake QR code
- [ ] Error notification appears
- [ ] Message: "Order ORD-XXXXX not found in database"

---

## 📊 Expected Console Output (Success Case)

```
📷 QR Scanner detected code: {"type":"order_receipt","orderNumber":"ORD-20250205-12345",...}
✅ Valid order receipt detected: {orderNumber: "ORD-20250205-12345", studentName: "John Doe", ...}
🔄 Calling onScan callback...
🔍 QR Code Scanned - Starting processing...
Processing scanned QR code: {"type":"order_receipt",...}
Parsed order data: {orderNumber: "ORD-20250205-12345", ...}
Found order: {id: 123, order_number: "ORD-20250205-12345", status: "pending", ...}
Order status updated to completed: {id: 123, status: "completed", claimed_date: "2025-02-05T10:35:00.000Z", ...}
Inventory reduced: Blouse from 50 to 48 (ordered: 2)
✅ QR Code Processing Complete: {success: true, data: {...}}
✅ onScan callback completed
✅ Order claimed successfully, refreshing orders...
```

---

## 🐛 Common Errors & Solutions

### **Error: "Failed to access camera"**
**Solution:** Grant camera permissions in browser settings

### **Error: "Order not found in database"**
**Solution:** Check if order exists in Supabase orders table

### **Error: "Order already claimed"**
**Solution:** This is expected - order can only be claimed once

### **Error: "Invalid QR code format"**
**Solution:** Make sure QR code is generated from OrderReceiptQRCode component

### **Error: "Failed to update order status"**
**Solution:** Check backend API and Supabase connection

### **Error: "Failed to find inventory"**
**Solution:** Check if inventory items exist with matching names and education level

---

## 📱 Testing on Different Devices

### **Desktop (Recommended):**
- Use external webcam or built-in laptop camera
- Best for testing and debugging
- Console logs are easily accessible

### **Mobile:**
- Use rear camera for better quality
- May need to adjust QR code size
- Console logs harder to access

### **Tablet:**
- Similar to mobile
- Larger screen makes it easier

---

## 🎯 Success Indicators

### **Visual Indicators:**
1. ✅ Camera feed shows in modal
2. ✅ Orange frame appears around scanning area
3. ✅ "Camera is active - Ready to scan" message
4. ✅ "Processing order..." message appears after scan
5. ✅ Green success notification appears
6. ✅ Order moves from Processing to Claimed tab
7. ✅ Scanner modal closes automatically

### **Console Indicators:**
1. ✅ All console logs appear in correct order
2. ✅ No error messages in console
3. ✅ Network requests return 200 status
4. ✅ Order status changes in database

---

## 📞 Need Help?

If you're still experiencing issues:

1. **Check all console logs** - They provide detailed information
2. **Check Network tab** - See if API requests are failing
3. **Check Supabase dashboard** - Verify data is correct
4. **Try a different browser** - Some browsers have better camera support
5. **Try a different device** - Camera quality matters

---

## 🚀 Quick Test Command

To quickly test if everything is working, follow these steps:

1. **Submit a test order:**
   - Go to: http://localhost:5173/student/products
   - Select any item
   - Submit order
   - Save/screenshot the QR code

2. **Scan the QR code:**
   - Go to: http://localhost:5173/admin/orders
   - Click "Scan QR Code"
   - Point camera at QR code
   - Watch console logs

3. **Verify success:**
   - Success notification appears
   - Order moves to Claimed tab
   - Console shows all success messages

---

**Last Updated:** 2025-02-05
**Version:** 1.0

