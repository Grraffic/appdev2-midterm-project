# Student Order System with QR Code Implementation
## La Verdad Uniform Ordering System

This document explains the complete implementation of the student order system with QR code generation and scanning functionality.

---

## Overview

The student order system allows students to:
1. **Browse products** from the real inventory API
2. **Select items** with quantity and size options
3. **Submit orders** that generate QR code receipts
4. **Receive QR codes** that can be scanned by admins

Admins can:
1. **Scan QR codes** from student order receipts
2. **View order details** including student info and items ordered
3. **Verify orders** before fulfilling them

---

## Implementation Summary

### ✅ Request 1: Restored AllProducts.jsx Layout

**What was restored:**
- ✅ **CategorySidebar** component on the left (desktop view)
- ✅ **TopPicks** component on the right (desktop view)
- ✅ **Hamburger menu** for mobile category navigation
- ✅ **3-column layout**: CategorySidebar | ProductGrid | TopPicks

**What was kept:**
- ✅ Real inventory data from `useInventory` hook
- ✅ No pricing information displayed
- ✅ Stock status badges (Available/Low Stock/Out of Stock)
- ✅ Search functionality
- ✅ Responsive design

### ✅ Request 2: Student Order System with QR Code

**What was implemented:**
- ✅ **Order Modal** for item selection with quantity and size
- ✅ **Order Submission** using `useOrderSubmission` hook
- ✅ **QR Code Generation** with order details
- ✅ **Receipt Display** using `OrderReceiptQRCode` component
- ✅ **QR Code Scanning** (already implemented in admin QRCodeScannerModal)
- ✅ **Order API Integration** with backend `/api/orders` endpoints

---

## File Structure

### Modified Files

1. **`CAPSTONE/frontend/src/student/pages/AllProducts.jsx`**
   - Restored 3-column layout with sidebars
   - Added order modal for item selection
   - Integrated order submission with QR code generation
   - Added receipt display after successful order

### Existing Files Used

2. **`CAPSTONE/frontend/src/student/components/CategorySidebar.jsx`**
   - Filters products by category (uniform, PE uniform, other items)

3. **`CAPSTONE/frontend/src/student/components/TopPicks.jsx`**
   - Displays top 4 available products

4. **`CAPSTONE/frontend/src/student/components/ProductGrid.jsx`**
   - Displays products in a responsive grid

5. **`CAPSTONE/frontend/src/student/components/ProductCard.jsx`**
   - Individual product card with "Order Now" button

6. **`CAPSTONE/frontend/src/student/components/OrderReceiptQRCode.jsx`**
   - Displays QR code receipt after order submission
   - Download and print functionality

7. **`CAPSTONE/frontend/src/student/hooks/useOrderSubmission.js`**
   - Handles order submission to backend API
   - Generates QR code data
   - Validates order data

8. **`CAPSTONE/frontend/src/admin/components/QRCodeScannerModal.jsx`**
   - Scans QR codes from student receipts
   - Displays order details when scanned

9. **`CAPSTONE/frontend/src/utils/qrCodeGenerator.js`**
   - Generates QR code data in JSON format
   - Parses scanned QR data
   - Validates order data

10. **Backend API Endpoints** (`CAPSTONE/backend/src/routes/orders.js`)
    - POST `/api/orders` - Create new order
    - GET `/api/orders/:id` - Get order by ID
    - GET `/api/orders/number/:orderNumber` - Get order by number (for QR scanning)

---

## Component Architecture

```
AllProducts.jsx
├── Navbar
├── HeroSection
├── Main Container (3-column layout)
│   ├── CategorySidebar (left)
│   │   └── Filter by category
│   ├── ProductGrid (center)
│   │   ├── Search bar
│   │   ├── Product cards
│   │   │   └── "Order Now" button → Opens Order Modal
│   │   └── Pagination
│   └── TopPicks (right)
│       └── Top 4 products
├── Order Modal
│   ├── Product info
│   ├── Quantity selector
│   ├── Size selector (if applicable)
│   └── Submit button → Calls submitOrder()
├── Receipt Display (after order)
│   └── OrderReceiptQRCode
│       ├── QR code
│       ├── Order details
│       └── Download/Print buttons
└── Footer
```

---

## Data Flow

### Student Order Flow

```
1. Student clicks "Order Now" on product
   ↓
2. Order Modal opens
   - Shows product details
   - Student selects quantity
   - Student selects size (if applicable)
   ↓
3. Student clicks "Submit Order"
   ↓
4. useOrderSubmission.submitOrder() is called
   - Validates order data
   - Generates order number (ORD-YYYYMMDD-XXXXX)
   - Generates QR code data (JSON string)
   - Transforms to snake_case for backend
   - POSTs to /api/orders
   ↓
5. Backend creates order in database
   - Stores order with qr_code_data
   - Returns order with ID
   ↓
6. Frontend displays OrderReceiptQRCode
   - Shows QR code
   - Shows order details
   - Allows download/print
   ↓
7. Student saves/prints QR code receipt
```

### Admin Scanning Flow

```
1. Admin opens Inventory page
   ↓
2. Admin clicks "Scan QR Code" button
   ↓
3. QRCodeScannerModal opens
   - Initializes camera
   - Shows scanning frame
   ↓
4. Admin scans student's QR code receipt
   ↓
5. QR data is parsed
   - Checks if type === "order_receipt"
   - Extracts order number
   ↓
6. Frontend fetches order from backend
   - GET /api/orders/number/:orderNumber
   ↓
7. Order details displayed in modal
   - Student name
   - Order number
   - Items ordered with quantities
   - Order date
   - Total amount
   ↓
8. Modal auto-closes after 2.5 seconds
```

---

## QR Code Data Structure

### Generated QR Code Data (JSON String)

```json
{
  "type": "order_receipt",
  "orderNumber": "ORD-20250115-12345",
  "studentName": "Juan Dela Cruz",
  "studentEmail": "juan.delacruz@student.laverdad.edu.ph",
  "educationLevel": "Senior High School",
  "items": [
    {
      "id": "123",
      "name": "Basic Education Uniform (Senior High)",
      "quantity": 2,
      "size": "Large",
      "price": 0
    }
  ],
  "totalAmount": 0,
  "orderDate": "2025-01-15T08:30:00.000Z",
  "timestamp": 1705308600000
}
```

### Key Fields

- **`type`**: Always "order_receipt" for identification
- **`orderNumber`**: Unique order identifier (ORD-YYYYMMDD-XXXXX)
- **`studentName`**: Student's full name
- **`studentEmail`**: Student's email (@student.laverdad.edu.ph)
- **`educationLevel`**: Student's education level
- **`items`**: Array of ordered items with quantities and sizes
- **`totalAmount`**: Always 0 (FREE for students)
- **`orderDate`**: ISO 8601 timestamp
- **`timestamp`**: Unix timestamp for quick validation

---

## API Endpoints

### POST /api/orders

**Create a new order**

**Request Body:**
```json
{
  "order_number": "ORD-20250115-12345",
  "student_id": "user123",
  "student_name": "Juan Dela Cruz",
  "student_email": "juan.delacruz@student.laverdad.edu.ph",
  "education_level": "Senior High School",
  "items": [
    {
      "id": "123",
      "name": "Basic Education Uniform (Senior High)",
      "quantity": 2,
      "size": "Large",
      "price": 0
    }
  ],
  "total_amount": 0,
  "qr_code_data": "{...JSON string...}",
  "status": "pending"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Order created successfully",
  "data": {
    "id": "order-uuid",
    "order_number": "ORD-20250115-12345",
    ...
  }
}
```

### GET /api/orders/number/:orderNumber

**Get order by order number (used when scanning QR code)**

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "order-uuid",
    "order_number": "ORD-20250115-12345",
    "student_name": "Juan Dela Cruz",
    "student_email": "juan.delacruz@student.laverdad.edu.ph",
    "education_level": "Senior High School",
    "items": [...],
    "total_amount": 0,
    "status": "pending",
    "order_date": "2025-01-15T08:30:00.000Z",
    ...
  }
}
```

---

## Testing Instructions

### Prerequisites

1. **Backend running**: `cd CAPSTONE/backend && npm start`
2. **Frontend running**: `cd CAPSTONE/frontend && npm run dev`
3. **Database**: Supabase with `orders` and `inventory` tables created

### Test Case 1: Browse Products

1. Navigate to `/student/all-products`
2. ✅ Verify 3-column layout (desktop)
   - Left: CategorySidebar
   - Center: ProductGrid
   - Right: TopPicks
3. ✅ Verify mobile layout (< 1024px)
   - Hamburger menu appears
   - Sidebars stack vertically
4. ✅ Test category filtering
   - Click "Uniform" → Shows only uniforms
   - Click "PE Uniform" → Shows only PE uniforms
   - Click "Other Items" → Shows other items
5. ✅ Test search functionality
   - Type "uniform" → Filters results
   - Type "PE" → Shows PE items
6. ✅ Verify stock status badges
   - Green "Available" for stock >= 20
   - Orange "Limited Stocks" for stock < 20
   - Red "Out of Stock" for stock = 0
7. ✅ Verify NO prices displayed anywhere

### Test Case 2: Order Submission

1. Click "Order Now" on any available product
2. ✅ Order Modal opens
   - Shows product name and description
   - Shows "FREE for Students" message
   - Quantity selector (default: 1)
   - Size selector (if product has sizes)
3. ✅ Adjust quantity (try 1, 2, 5)
4. ✅ Select size (if applicable)
5. ✅ Click "Submit Order"
6. ✅ Verify loading state ("Submitting...")
7. ✅ Order submits successfully
8. ✅ Receipt page displays with QR code

### Test Case 3: QR Code Receipt

1. After successful order submission
2. ✅ Verify QR code displays
3. ✅ Verify order details shown:
   - Order number (ORD-YYYYMMDD-XXXXX)
   - Student name
   - Order date
   - Total amount (₱0.00)
   - Items list with quantities
4. ✅ Test "Download" button
   - Downloads PNG file
   - File named: `order-receipt-ORD-YYYYMMDD-XXXXX.png`
5. ✅ Test "Print" button
   - Opens print dialog
   - Shows formatted receipt
6. ✅ Click "Continue Shopping"
   - Returns to product catalog

### Test Case 4: Admin QR Code Scanning

1. Open admin Inventory page
2. Click "Scan QR Code" button
3. ✅ QRCodeScannerModal opens
   - Camera initializes
   - Scanning frame appears
4. ✅ Scan student's QR code receipt
   - Use printed receipt or display on another device
5. ✅ Verify order details display:
   - Green success card appears
   - Shows "Order Receipt Scanned!"
   - Displays order number
   - Shows student name
   - Lists items with quantities
   - Shows order date and total
6. ✅ Modal auto-closes after 2.5 seconds

### Test Case 5: Error Handling

1. **No internet connection**
   - ✅ Shows error message
   - ✅ Allows retry

2. **Invalid QR code**
   - ✅ Shows "Invalid QR code" message
   - ✅ Continues scanning

3. **Order not found**
   - ✅ Shows "Order not found" error
   - ✅ Allows scanning again

4. **Out of stock item**
   - ✅ "Order Now" button disabled
   - ✅ Shows "Out of Stock" status

---

## Key Features

### Student Features

✅ **Browse Products**
- Real inventory data from API
- Category filtering (sidebar)
- Search functionality
- Stock status indicators
- NO pricing information

✅ **Order Items**
- Select quantity (1-10)
- Select size (if applicable)
- Submit order with one click
- Instant QR code receipt

✅ **QR Code Receipt**
- Scannable QR code
- Order details display
- Download as PNG
- Print functionality
- Instructions for use

### Admin Features

✅ **Scan QR Codes**
- Camera-based scanning
- Automatic order detection
- Order details display
- Auto-close after scan

✅ **Verify Orders**
- View student information
- See items ordered
- Check order date
- Verify quantities

---

## Important Notes

### 1. Student Authentication

**TODO**: Currently uses placeholder values for student info:
```javascript
studentName: "Student Name", // TODO: Get from auth context
studentEmail: "student@laverdad.edu.ph", // TODO: Get from auth context
```

**To fix**: Update `handleSubmitOrder()` in `AllProducts.jsx`:
```javascript
import { useAuth } from "../../context/AuthContext";

const { user } = useAuth();

const orderData = {
  studentName: user?.displayName || user?.name,
  studentEmail: user?.email,
  // ...
};
```

### 2. Price Display

All prices are set to **₱0.00** for students since uniforms are FREE. The price field is hidden from the UI but stored as 0 in the database for consistency.

### 3. Order Status

Orders are created with `status: "pending"`. Admins can update the status to:
- `pending` - Order submitted, awaiting fulfillment
- `processing` - Order being prepared
- `ready` - Order ready for pickup
- `completed` - Order claimed by student
- `cancelled` - Order cancelled

### 4. QR Code Security

The QR code contains:
- ✅ Order number (unique identifier)
- ✅ Student information
- ✅ Items ordered
- ✅ Timestamp for validation

It does NOT contain:
- ❌ Sensitive personal data
- ❌ Payment information
- ❌ Authentication tokens

---

## Troubleshooting

### Issue: QR Code Not Scanning

**Possible causes:**
1. Camera permission not granted
2. Poor lighting conditions
3. QR code too small or blurry
4. Wrong QR code format

**Solutions:**
1. Grant camera permission in browser
2. Improve lighting or adjust camera angle
3. Print QR code larger or zoom in on screen
4. Ensure QR code is from OrderReceiptQRCode component

### Issue: Order Not Submitting

**Possible causes:**
1. Backend server not running
2. Network connection issues
3. Invalid order data
4. Database connection error

**Solutions:**
1. Start backend: `cd CAPSTONE/backend && npm start`
2. Check network connection
3. Check browser console for validation errors
4. Verify Supabase connection in backend

### Issue: Products Not Loading

**Possible causes:**
1. Backend API not responding
2. Inventory table empty
3. Network error

**Solutions:**
1. Verify backend is running on port 3000
2. Add items to inventory via admin page
3. Check browser console for API errors

---

## Next Steps

### Recommended Enhancements

1. **Student Authentication**
   - Integrate with AuthContext
   - Auto-fill student name and email
   - Link orders to student accounts

2. **Order History**
   - Create "My Orders" page for students
   - Show past orders with QR codes
   - Allow re-printing receipts

3. **Order Status Tracking**
   - Show order status (pending/processing/ready/completed)
   - Email notifications when status changes
   - SMS notifications (optional)

4. **Admin Order Management**
   - Create "Orders" page in admin dashboard
   - List all orders with filters
   - Update order status
   - Mark orders as fulfilled

5. **Inventory Deduction**
   - Automatically reduce stock when order is placed
   - Reserve items for pending orders
   - Release stock if order is cancelled

6. **Multi-Item Orders**
   - Allow adding multiple items to cart
   - Submit all items in one order
   - Generate single QR code for entire order

---

## Summary

✅ **Request 1 Complete**: AllProducts.jsx restored with 3-column layout (CategorySidebar | ProductGrid | TopPicks)

✅ **Request 2 Complete**: Student order system with QR code generation and admin scanning

**What works:**
- Students can browse real inventory
- Students can order items with quantity/size selection
- Orders generate QR code receipts
- Admins can scan QR codes to view order details
- All pricing information hidden from students
- Responsive design maintained

**Ready for testing!** 🎉

