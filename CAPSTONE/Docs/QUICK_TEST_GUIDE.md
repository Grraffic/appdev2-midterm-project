# Quick Test Guide - Student Order System
## La Verdad Uniform Ordering System

---

## 🚀 Quick Start

### 1. Start Backend
```bash
cd CAPSTONE/backend
npm start
```
**Expected**: Server running on `http://localhost:3000`

### 2. Start Frontend
```bash
cd CAPSTONE/frontend
npm run dev
```
**Expected**: App running on `http://localhost:5173`

### 3. Open Student Page
Navigate to: `http://localhost:5173/student/all-products`

---

## ✅ Test Checklist

### Part 1: Layout & Navigation (Request 1)

- [ ] **Desktop Layout (>1024px)**
  - [ ] CategorySidebar visible on left
  - [ ] ProductGrid in center
  - [ ] TopPicks visible on right
  - [ ] 3-column layout working

- [ ] **Mobile Layout (<1024px)**
  - [ ] Hamburger menu appears
  - [ ] Click hamburger → CategorySidebar opens
  - [ ] TopPicks moves below ProductGrid
  - [ ] Single column layout

- [ ] **Category Filtering**
  - [ ] Click "All Products" → Shows all items
  - [ ] Click "Uniform" → Shows uniforms only
  - [ ] Click "School Uniform" → Shows school uniforms
  - [ ] Click "PE Uniform" → Shows PE uniforms
  - [ ] Click "Other Items" → Shows other items

- [ ] **Search Functionality**
  - [ ] Type "uniform" → Filters results
  - [ ] Type "PE" → Shows PE items
  - [ ] Clear search → Shows all items

- [ ] **Stock Status Badges**
  - [ ] Green "In Stock" for available items
  - [ ] Orange "Limited Stocks" for low stock
  - [ ] Red "Out of Stock" for unavailable items

- [ ] **No Pricing Information**
  - [ ] NO prices displayed on cards
  - [ ] "FREE for Students" message visible
  - [ ] No ₱ symbols anywhere

### Part 2: Order System (Request 2)

- [ ] **Order Modal**
  - [ ] Click "Order Now" → Modal opens
  - [ ] Product name displayed
  - [ ] Product description shown
  - [ ] "FREE for Students" message visible
  - [ ] Quantity selector (default: 1)
  - [ ] Size selector (if product has sizes)
  - [ ] Cancel button works
  - [ ] Submit button enabled

- [ ] **Order Submission**
  - [ ] Select quantity (try 1, 2, 5)
  - [ ] Select size (if applicable)
  - [ ] Click "Submit Order"
  - [ ] Loading state shows ("Submitting...")
  - [ ] Modal closes on success
  - [ ] Receipt page displays

- [ ] **QR Code Receipt**
  - [ ] QR code displays (black and white square)
  - [ ] Order number shown (ORD-YYYYMMDD-XXXXX)
  - [ ] Student name displayed
  - [ ] Order date shown
  - [ ] Total amount: ₱0.00
  - [ ] Items list with quantities
  - [ ] Download button works
  - [ ] Print button works
  - [ ] "Continue Shopping" button returns to catalog

- [ ] **Admin QR Scanning**
  - [ ] Open admin Inventory page
  - [ ] Click "Scan QR Code" button
  - [ ] Camera initializes
  - [ ] Scanning frame appears
  - [ ] Scan student's QR code
  - [ ] Order details display
  - [ ] Student name shown
  - [ ] Items list shown
  - [ ] Modal auto-closes after 2.5s

---

## 🎯 Quick Test Scenarios

### Scenario 1: Complete Order Flow (5 minutes)

1. **Browse Products**
   - Open `/student/all-products`
   - Verify 3-column layout
   - Click "Uniform" category
   - Search for "Senior High"

2. **Place Order**
   - Click "Order Now" on any item
   - Set quantity to 2
   - Select size (if available)
   - Click "Submit Order"

3. **Get Receipt**
   - Verify QR code displays
   - Check order details
   - Click "Download"
   - Save QR code image

4. **Admin Scan**
   - Open admin Inventory page
   - Click "Scan QR Code"
   - Scan the downloaded QR code (display on phone or print)
   - Verify order details appear

### Scenario 2: Mobile Experience (3 minutes)

1. **Resize browser to mobile (<768px)**
2. **Click hamburger menu**
3. **Select category**
4. **Scroll to see TopPicks below grid**
5. **Order an item**
6. **View receipt on mobile**

### Scenario 3: Error Handling (2 minutes)

1. **Try ordering out-of-stock item**
   - Button should be disabled
   - Shows "Out of Stock"

2. **Cancel order modal**
   - Click "Cancel"
   - Modal closes
   - No order created

3. **Scan invalid QR code**
   - Scan any non-order QR code
   - Should show error message
   - Continue scanning

---

## 🐛 Common Issues & Fixes

### Issue: Products Not Loading

**Symptoms**: Empty product grid, loading spinner forever

**Fix**:
```bash
# Check backend is running
curl http://localhost:3000/api/inventory

# If not running, start it
cd CAPSTONE/backend
npm start
```

### Issue: Order Not Submitting

**Symptoms**: "Submitting..." never completes, error message

**Fix**:
```bash
# Check backend logs for errors
# Verify orders table exists in Supabase
# Check browser console for errors
```

### Issue: QR Code Not Scanning

**Symptoms**: Camera works but doesn't detect QR code

**Fix**:
- Grant camera permission in browser
- Improve lighting
- Hold QR code steady
- Try printing QR code larger
- Ensure QR code is from OrderReceiptQRCode component

### Issue: Camera Not Working

**Symptoms**: "Camera initialization failed" error

**Fix**:
- Grant camera permission in browser settings
- Try different browser (Chrome recommended)
- Check if camera is being used by another app
- Restart browser

---

## 📊 Expected Results

### Desktop View (>1024px)
```
┌─────────────────────────────────────────────────────┐
│                    Navbar                           │
├─────────────────────────────────────────────────────┤
│                  Hero Section                       │
├───────────┬─────────────────────────┬───────────────┤
│ Category  │    Product Grid         │   Top Picks   │
│ Sidebar   │  ┌───┐ ┌───┐ ┌───┐    │   ┌───────┐   │
│           │  │ 1 │ │ 2 │ │ 3 │    │   │ Pick1 │   │
│ • All     │  └───┘ └───┘ └───┘    │   └───────┘   │
│ • Uniform │  ┌───┐ ┌───┐ ┌───┐    │   ┌───────┐   │
│ • PE      │  │ 4 │ │ 5 │ │ 6 │    │   │ Pick2 │   │
│ • Other   │  └───┘ └───┘ └───┘    │   └───────┘   │
│           │    [Pagination]         │   ┌───────┐   │
│           │                         │   │ Pick3 │   │
│           │                         │   └───────┘   │
└───────────┴─────────────────────────┴───────────────┘
```

### Mobile View (<768px)
```
┌─────────────────────────┐
│       Navbar            │
├─────────────────────────┤
│    Hero Section         │
├─────────────────────────┤
│ [☰] All Products        │
│ [Search Bar]            │
├─────────────────────────┤
│  ┌─────────────────┐   │
│  │   Product 1     │   │
│  └─────────────────┘   │
│  ┌─────────────────┐   │
│  │   Product 2     │   │
│  └─────────────────┘   │
│    [Pagination]         │
├─────────────────────────┤
│    Top Picks            │
│  ┌─────────────────┐   │
│  │   Pick 1        │   │
│  └─────────────────┘   │
└─────────────────────────┘
```

### Order Modal
```
┌─────────────────────────────────┐
│  Order Item                  [X]│
│  Fill in the details below      │
├─────────────────────────────────┤
│  Product: Senior High Uniform   │
│  Description: Complete set...   │
│  FREE for Students ✨           │
│                                 │
│  Quantity: [2]                  │
│  Size: [Large ▼]                │
│                                 │
│  [Cancel]  [Submit Order]       │
└─────────────────────────────────┘
```

### QR Code Receipt
```
┌─────────────────────────────────┐
│         ✓ Order Confirmed!      │
│  Your order has been placed     │
├─────────────────────────────────┤
│     ┌─────────────────┐         │
│     │                 │         │
│     │   QR CODE HERE  │         │
│     │                 │         │
│     └─────────────────┘         │
│  Scan this at admin office      │
├─────────────────────────────────┤
│  Order Details                  │
│  Order #: ORD-20250115-12345    │
│  Student: Juan Dela Cruz        │
│  Date: Jan 15, 2025             │
│  Total: ₱0.00                   │
│                                 │
│  Items:                         │
│  • 2x Senior High Uniform (L)   │
├─────────────────────────────────┤
│  [Download]  [Print]            │
└─────────────────────────────────┘
```

---

## 🎉 Success Criteria

### ✅ Request 1: Layout Restored
- [x] CategorySidebar on left
- [x] ProductGrid in center
- [x] TopPicks on right
- [x] Hamburger menu on mobile
- [x] Real inventory data
- [x] No pricing information

### ✅ Request 2: Order System
- [x] Order modal with quantity/size
- [x] Order submission to backend
- [x] QR code generation
- [x] Receipt display
- [x] Admin QR scanning
- [x] Order details display

---

## 📝 Notes

### Student Authentication (TODO)

Currently uses placeholder values:
```javascript
studentName: "Student Name"
studentEmail: "student@laverdad.edu.ph"
```

**To integrate with auth:**
1. Import `useAuth` hook
2. Get `user` from context
3. Use `user.displayName` and `user.email`

### Order Status Flow

```
pending → processing → ready → completed
                    ↓
                cancelled
```

### QR Code Format

```json
{
  "type": "order_receipt",
  "orderNumber": "ORD-YYYYMMDD-XXXXX",
  "studentName": "...",
  "items": [...]
}
```

---

## 🔗 Related Files

- **AllProducts.jsx**: Main student page
- **OrderReceiptQRCode.jsx**: QR code display
- **QRCodeScannerModal.jsx**: Admin scanner
- **useOrderSubmission.js**: Order submission hook
- **orders.js**: Backend API routes

---

## 📞 Support

If you encounter issues:
1. Check browser console for errors
2. Check backend logs
3. Verify Supabase connection
4. Review implementation guide: `STUDENT_ORDER_SYSTEM_IMPLEMENTATION.md`

---

**Happy Testing! 🚀**

