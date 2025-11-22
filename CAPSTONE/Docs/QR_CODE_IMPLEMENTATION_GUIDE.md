# QR Code Implementation Guide
## La Verdad Uniform Ordering System

This document explains the complete QR code implementation for the La Verdad uniform ordering system, including both the enhanced QR scanner modal and the order receipt QR code generation system.

---

## Table of Contents
1. [Overview](#overview)
2. [Part 1: Enhanced QR Code Scanner Modal](#part-1-enhanced-qr-code-scanner-modal)
3. [Part 2: Order Receipt QR Code Generation](#part-2-order-receipt-qr-code-generation)
4. [Database Schema](#database-schema)
5. [API Endpoints](#api-endpoints)
6. [Usage Examples](#usage-examples)
7. [Testing](#testing)

---

## Overview

The QR code system consists of two main components:

1. **Admin QR Scanner**: Enhanced modal for scanning QR codes (inventory items and order receipts)
2. **Student Order Receipts**: QR code generation for student orders that can be scanned by admins

### Technology Stack
- **Frontend**: React, react-qr-code (QR generation), qr-scanner (QR scanning)
- **Backend**: Node.js/Express, Supabase (PostgreSQL)
- **QR Code Format**: JSON string containing order/item information

---

## Part 1: Enhanced QR Code Scanner Modal

### Location
`CAPSTONE/frontend/src/admin/components/QRCodeScannerModal.jsx`

### Features
✅ Modern, responsive design matching application UI
✅ Real-time camera scanning with visual feedback
✅ Automatic order receipt detection and parsing
✅ Detailed order information display
✅ Loading, error, and success states
✅ Auto-close after successful scan
✅ Orange scanning frame with corner decorations
✅ Gradient header with camera icon

### Visual Design
- **Header**: Dark blue gradient (`#0C2340` to `#1e3a8a`) with white text
- **Scanning Frame**: Orange border (`#e68b00`) with white corner decorations
- **Success State**: Green gradient background with order details
- **Loading State**: Spinning loader with "Initializing camera..." message
- **Error State**: Red alert icon with error message

### How It Works
1. Admin clicks "Scan QR Code" button on Inventory page
2. Modal opens and requests camera permission
3. Camera activates with orange scanning frame overlay
4. When QR code is detected:
   - If it's an order receipt: Displays full order details
   - If it's other data: Shows scanned data
5. Modal auto-closes after 2.5 seconds

### Order Receipt Display
When an order receipt QR code is scanned, the modal displays:
- ✅ Order number
- ✅ Student name
- ✅ Order date
- ✅ Total amount
- ✅ List of items with quantities and prices

---

## Part 2: Order Receipt QR Code Generation

### Components Created

#### 1. QR Code Generator Utility
**Location**: `CAPSTONE/frontend/src/utils/qrCodeGenerator.js`

**Functions**:
- `generateOrderReceiptQRData(orderData)` - Creates JSON string for QR code
- `parseOrderReceiptQRData(qrString)` - Parses scanned QR code data
- `generateOrderNumber()` - Generates unique order number (format: ORD-YYYYMMDD-XXXXX)
- `validateOrderData(orderData)` - Validates order data before QR generation

#### 2. Order Receipt QR Code Component
**Location**: `CAPSTONE/frontend/src/student/components/OrderReceiptQRCode.jsx`

**Features**:
- ✅ Displays QR code with order information
- ✅ Shows order details (number, student, date, total, items)
- ✅ Download QR code as PNG
- ✅ Print receipt with QR code
- ✅ Instructions for students
- ✅ Responsive design

#### 3. Order Submission Hook
**Location**: `CAPSTONE/frontend/src/student/hooks/useOrderSubmission.js`

**Functions**:
- `submitOrder(orderData)` - Submits order with QR code generation
- `resetOrder()` - Resets order state
- `calculateTotal(items)` - Calculates total from items

### QR Code Data Structure

```json
{
  "type": "order_receipt",
  "orderNumber": "ORD-20250115-12345",
  "studentId": "uuid-here",
  "studentName": "Juan Dela Cruz",
  "studentEmail": "juan@student.laverdad.edu.ph",
  "educationLevel": "Senior High School",
  "orderDate": "2025-01-15T10:30:00.000Z",
  "totalAmount": 1500.00,
  "items": [
    {
      "name": "School Uniform",
      "quantity": 1,
      "price": 800.00,
      "size": "Large",
      "category": "Uniform"
    },
    {
      "name": "PE Uniform",
      "quantity": 2,
      "price": 350.00,
      "size": "Medium",
      "category": "PE"
    }
  ],
  "status": "pending"
}
```

---

## Database Schema

### Orders Table
Created in Supabase with the following structure:

```sql
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number TEXT UNIQUE NOT NULL,
  student_id UUID REFERENCES users(id) ON DELETE CASCADE,
  student_name TEXT NOT NULL,
  student_email TEXT NOT NULL,
  education_level TEXT NOT NULL,
  items JSONB NOT NULL DEFAULT '[]',
  total_amount NUMERIC(10,2) NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'pending',
  qr_code_data TEXT,
  order_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  payment_date TIMESTAMP WITH TIME ZONE,
  claimed_date TIMESTAMP WITH TIME ZONE,
  notes TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### Indexes
- `idx_orders_student_id` - For filtering by student
- `idx_orders_order_number` - For quick order lookup
- `idx_orders_status` - For filtering by status
- `idx_orders_order_date` - For sorting by date
- `idx_orders_education_level` - For filtering by education level

---

## API Endpoints

### Backend Files Created
1. `CAPSTONE/backend/src/services/order.service.js` - Order business logic
2. `CAPSTONE/backend/src/controllers/order.controller.js` - HTTP request handlers
3. `CAPSTONE/backend/src/routes/orders.js` - API routes

### Available Endpoints

#### GET /api/orders
Get all orders with filtering and pagination
- Query params: `page`, `limit`, `status`, `education_level`, `student_id`, `search`

#### GET /api/orders/:id
Get single order by ID

#### GET /api/orders/number/:orderNumber
Get order by order number (useful for QR code scanning)

#### POST /api/orders
Create new order with QR code data
```json
{
  "order_number": "ORD-20250115-12345",
  "student_name": "Juan Dela Cruz",
  "student_email": "juan@student.laverdad.edu.ph",
  "education_level": "Senior High School",
  "items": [...],
  "total_amount": 1500.00,
  "qr_code_data": "{...}"
}
```

#### PATCH /api/orders/:id/status
Update order status
```json
{
  "status": "paid" | "claimed" | "cancelled"
}
```

#### PUT /api/orders/:id
Update order details

#### DELETE /api/orders/:id
Soft delete order

#### GET /api/orders/stats
Get order statistics

---

## Usage Examples

### Example 1: Student Places Order

```jsx
import { useOrderSubmission } from '../hooks/useOrderSubmission';
import OrderReceiptQRCode from '../components/OrderReceiptQRCode';

function CheckoutPage() {
  const { submitOrder, submittedOrder, loading } = useOrderSubmission();

  const handleCheckout = async () => {
    const orderData = {
      educationLevel: "Senior High School",
      items: [
        { name: "School Uniform", quantity: 1, price: 800, size: "Large" },
        { name: "PE Uniform", quantity: 2, price: 350, size: "Medium" }
      ],
      totalAmount: 1500
    };

    try {
      await submitOrder(orderData);
      // Order submitted successfully, QR code generated
    } catch (error) {
      console.error("Order failed:", error);
    }
  };

  if (submittedOrder) {
    return <OrderReceiptQRCode orderData={submittedOrder} />;
  }

  return (
    <button onClick={handleCheckout} disabled={loading}>
      {loading ? "Processing..." : "Place Order"}
    </button>
  );
}
```

### Example 2: Admin Scans QR Code

```jsx
import QRCodeScannerModal from '../components/QRCodeScannerModal';

function InventoryPage() {
  const [scannerOpen, setScannerOpen] = useState(false);

  const handleQRScanned = (data) => {
    console.log("Scanned data:", data);
    
    // Parse if it's an order receipt
    try {
      const orderData = JSON.parse(data);
      if (orderData.type === "order_receipt") {
        // Fetch full order details from API
        fetchOrderByNumber(orderData.orderNumber);
      }
    } catch (e) {
      // Not JSON, might be inventory item
    }
  };

  return (
    <>
      <button onClick={() => setScannerOpen(true)}>
        Scan QR Code
      </button>
      
      <QRCodeScannerModal
        isOpen={scannerOpen}
        onClose={() => setScannerOpen(false)}
        onScan={handleQRScanned}
      />
    </>
  );
}
```

---

## Testing

### Test the QR Scanner Modal
1. Navigate to Admin → Inventory page
2. Click "Scan QR Code" button
3. Allow camera permissions
4. Point camera at a QR code
5. Verify:
   - ✅ Camera activates with orange frame
   - ✅ QR code is detected automatically
   - ✅ Order details display correctly (if order receipt)
   - ✅ Modal auto-closes after scan

### Test Order Receipt Generation
1. As a student, place an order
2. Complete checkout process
3. Verify:
   - ✅ QR code is generated and displayed
   - ✅ Order details are shown correctly
   - ✅ Download button works
   - ✅ Print button works
   - ✅ QR code can be scanned by admin

### Test Backend API
```bash
# Create an order
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "order_number": "ORD-20250115-12345",
    "student_name": "Test Student",
    "student_email": "test@student.laverdad.edu.ph",
    "education_level": "Senior High School",
    "items": [{"name": "Uniform", "quantity": 1, "price": 800}],
    "total_amount": 800
  }'

# Get order by number
curl http://localhost:3000/api/orders/number/ORD-20250115-12345

# Update order status
curl -X PATCH http://localhost:3000/api/orders/{id}/status \
  -H "Content-Type: application/json" \
  -d '{"status": "paid"}'
```

---

## Next Steps

1. **Integrate with Student Checkout Flow**
   - Add OrderReceiptQRCode component to checkout success page
   - Implement order submission in student pages

2. **Add Authentication**
   - Protect order creation endpoint (students only)
   - Protect order management endpoints (admins only)

3. **Email Notifications**
   - Send order confirmation email with QR code
   - Send status update notifications

4. **Order Management Dashboard**
   - Create admin page to view all orders
   - Add filters and search functionality
   - Implement order status updates

5. **Analytics**
   - Track order statistics
   - Generate reports
   - Monitor popular items

---

## Support

For questions or issues, please refer to:
- Frontend components: `CAPSTONE/frontend/src/admin/components/` and `CAPSTONE/frontend/src/student/components/`
- Backend services: `CAPSTONE/backend/src/services/order.service.js`
- API routes: `CAPSTONE/backend/src/routes/orders.js`

