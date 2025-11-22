# My Cart Implementation Guide

## Overview

This document describes the implementation of the My Cart feature for the La Verdad uniform ordering system. The cart allows students to add items, manage quantities, and proceed to order submission.

## Architecture

The cart system follows the project's separation of concerns pattern:
- **Backend**: Cart API endpoints, database schema, and business logic
- **Frontend**: React Context for global state, custom hooks for cart operations, and UI components
- **Database**: Supabase table for persistent cart storage

---

## Backend Implementation

### 1. Database Schema

**File**: `CAPSTONE/backend/src/db/cart.sql`

**Table**: `cart_items`

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Primary key |
| user_id | UUID | Reference to user (student) |
| inventory_id | UUID | Reference to inventory item |
| size | TEXT | Selected size (e.g., "M", "L") |
| quantity | INTEGER | Quantity of items (min: 1) |
| created_at | TIMESTAMPTZ | Timestamp when item was added |
| updated_at | TIMESTAMPTZ | Timestamp of last update |

**Constraints**:
- Unique constraint on `(user_id, inventory_id, size)` to prevent duplicate entries
- Check constraint on `quantity > 0`

**Indexes**:
- `idx_cart_items_user_id` - Fast lookup by user
- `idx_cart_items_inventory_id` - Fast lookup by inventory item
- `idx_cart_items_created_at` - For cleanup of old cart items

**Row Level Security (RLS)**:
- Users can only access their own cart items
- Policies for SELECT, INSERT, UPDATE, DELETE operations

### 2. Cart Service

**File**: `CAPSTONE/backend/src/services/cart.service.js`

**Methods**:
- `getCartItems(userId)` - Get all cart items with inventory details
- `addToCart(cartData)` - Add item or update quantity if exists
- `updateCartItem(cartItemId, userId, quantity)` - Update item quantity
- `removeFromCart(cartItemId, userId)` - Remove item from cart
- `clearCart(userId)` - Clear entire cart
- `getCartCount(userId)` - Get total item count

### 3. Cart Controller

**File**: `CAPSTONE/backend/src/controllers/cart.controller.js`

Handles HTTP requests and responses for cart operations.

### 4. Cart Routes

**File**: `CAPSTONE/backend/src/routes/cart.js`

**Base Path**: `/api/cart`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/cart/:userId` | Get all cart items for user |
| GET | `/cart/count/:userId` | Get cart item count |
| POST | `/cart` | Add item to cart |
| PUT | `/cart/:cartItemId` | Update cart item quantity |
| DELETE | `/cart/:cartItemId` | Remove item from cart |
| DELETE | `/cart/clear/:userId` | Clear entire cart |

---

## Frontend Implementation

### 1. Cart Context

**File**: `CAPSTONE/frontend/src/context/CartContext.jsx`

Global state management for cart using React Context API.

**State**:
- `items` - Array of cart items
- `loading` - Loading state
- `error` - Error message

**Methods**:
- `addToCart(item)` - Add item to cart
- `updateCartItem(cartItemId, quantity)` - Update quantity
- `removeFromCart(cartItemId)` - Remove item
- `clearCart()` - Clear all items
- `fetchCartItems()` - Refresh cart from API
- `getCartCount()` - Get item count
- `getTotalQuantity()` - Get total quantity

### 2. Cart Hook

**File**: `CAPSTONE/frontend/src/student/hooks/cart/useCart.js`

Custom hook to access cart context.

**Usage**:
```jsx
import { useCart } from '../hooks';

const { items, loading, addToCart, removeFromCart } = useCart();
```

### 3. API Service

**File**: `CAPSTONE/frontend/src/services/api.js`

**Cart API Methods**:
- `cartAPI.getCartItems(userId)`
- `cartAPI.getCartCount(userId)`
- `cartAPI.addToCart(cartData)`
- `cartAPI.updateCartItem(cartItemId, userId, quantity)`
- `cartAPI.removeFromCart(cartItemId, userId)`
- `cartAPI.clearCart(userId)`

### 4. My Cart Page

**File**: `CAPSTONE/frontend/src/student/pages/MyCart.jsx`

**Route**: `/student/cart` (Protected - Student role only)

**Features**:
- View all cart items with product details
- Edit mode to select and remove multiple items
- Update quantities with +/- controls
- Responsive design (mobile, tablet, desktop)
- No pricing displayed (uniforms are free)
- Empty cart state with call-to-action
- Order submission button

**Layout**:
- Header with back button, title, and edit button
- Item count display
- Product table (desktop) / Card layout (mobile)
- Sticky footer with "Order Now" button

**Columns** (Desktop Table):
- Checkbox (edit mode only)
- Product (image + name + education level)
- Size
- Quantity (with +/- controls in edit mode)
- Price (always shows "Free")

### 5. Updated Navbar

**File**: `CAPSTONE/frontend/src/student/components/common/Navbar.jsx`

**Changes**:
- Cart icon with badge showing item count
- Click to navigate to `/student/cart`
- Badge displays count in orange circle
- Mobile and desktop versions

### 6. Updated Product Details Page

**File**: `CAPSTONE/frontend/src/student/pages/ProductDetailsPage.jsx`

**Changes**:
- "Add to Cart" button now adds items to cart
- Success toast with "View Cart" link
- Validates size selection before adding
- Integrates with CartContext

---

## User Flow

### Adding Items to Cart

1. Student browses products on All Products page
2. Clicks "Add to Cart" icon or "Order Now" button
3. Navigates to Product Details page
4. Selects size (if required) and quantity
5. Clicks "Add to Cart" button
6. Item is added to cart with success toast
7. Cart badge in navbar updates with new count

### Viewing Cart

1. Student clicks cart icon in navbar
2. Navigates to My Cart page
3. Sees all cart items with details
4. Can view product images, names, sizes, quantities

### Editing Cart

1. Student clicks "Edit" button on My Cart page
2. Checkboxes appear next to each item
3. Can select items and click "Remove" button
4. Can adjust quantities with +/- buttons
5. Clicks "Done" to exit edit mode

### Ordering from Cart

1. Student reviews cart items
2. Clicks "Order Now" button
3. Proceeds to order confirmation (to be implemented)

---

## Responsive Design

### Mobile (< 768px)
- Card-based layout for cart items
- Stacked product information
- Touch-friendly buttons
- Full-width "Order Now" button

### Tablet (768px - 1024px)
- Hybrid layout
- Larger touch targets
- Optimized spacing

### Desktop (> 1024px)
- Table layout for cart items
- Hover effects
- Larger product images
- Multi-column display

---

## Brand Colors

- Primary Blue: `#0C2340`
- Accent Orange: `#e68b00`
- Success Green: `#10b981` (for "Free" text)
- Error Red: `#ef4444` (for remove actions)

---

## Testing Instructions

### Prerequisites

1. Backend running: `cd CAPSTONE/backend && npm start`
2. Frontend running: `cd CAPSTONE/frontend && npm run dev`
3. Database: Run `CAPSTONE/backend/src/db/cart.sql` in Supabase SQL editor

### Test Cases

#### Test 1: Add Item to Cart
1. Login as student
2. Navigate to All Products
3. Click on a product
4. Select size and quantity
5. Click "Add to Cart"
6. Verify success toast appears
7. Verify cart badge shows count

#### Test 2: View Cart
1. Click cart icon in navbar
2. Verify cart page displays all items
3. Verify product details are correct
4. Verify quantities match

#### Test 3: Update Quantity
1. On cart page, click "Edit"
2. Use +/- buttons to change quantity
3. Verify quantity updates
4. Verify cart count updates

#### Test 4: Remove Items
1. On cart page, click "Edit"
2. Select one or more items
3. Click "Remove" button
4. Verify items are removed
5. Verify cart count updates

#### Test 5: Empty Cart
1. Remove all items from cart
2. Verify empty cart state displays
3. Verify "Browse Products" button works

#### Test 6: Responsive Design
1. Test on mobile device (< 768px)
2. Test on tablet (768px - 1024px)
3. Test on desktop (> 1024px)
4. Verify layout adapts correctly

---

## Future Enhancements

1. **Order Submission from Cart**
   - Implement order creation from cart items
   - Generate QR code for multiple items
   - Clear cart after successful order

2. **Cart Persistence**
   - Cart items are already persisted in database
   - Consider adding localStorage backup for offline support

3. **Stock Validation**
   - Check inventory stock before adding to cart
   - Show warning if item is low stock
   - Prevent adding out-of-stock items

4. **Saved for Later**
   - Allow students to save items for later
   - Separate "Saved" section in cart

5. **Cart Expiration**
   - Implement automatic cleanup of old cart items
   - Notify students of expiring cart items

---

## API Examples

### Add Item to Cart

```javascript
POST /api/cart
Content-Type: application/json

{
  "userId": "user-uuid",
  "inventoryId": "inventory-uuid",
  "size": "M",
  "quantity": 2
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "id": "cart-item-uuid",
    "user_id": "user-uuid",
    "inventory_id": "inventory-uuid",
    "size": "M",
    "quantity": 2,
    "created_at": "2025-01-18T10:00:00Z",
    "updated_at": "2025-01-18T10:00:00Z"
  },
  "message": "Item added to cart"
}
```

### Get Cart Items

```javascript
GET /api/cart/:userId
```

**Response**:
```json
{
  "success": true,
  "data": [
    {
      "id": "cart-item-uuid",
      "userId": "user-uuid",
      "inventoryId": "inventory-uuid",
      "size": "M",
      "quantity": 2,
      "createdAt": "2025-01-18T10:00:00Z",
      "updatedAt": "2025-01-18T10:00:00Z",
      "inventory": {
        "id": "inventory-uuid",
        "name": "Basic Education Uniform",
        "education_level": "Senior High School",
        "category": "Uniform",
        "item_type": "Uniform",
        "image": "/assets/image/card1.png",
        "stock": 50,
        "price": 0
      }
    }
  ],
  "count": 1
}
```

---

## Files Created/Modified

### Backend Files Created
- `CAPSTONE/backend/src/db/cart.sql`
- `CAPSTONE/backend/src/services/cart.service.js`
- `CAPSTONE/backend/src/controllers/cart.controller.js`
- `CAPSTONE/backend/src/routes/cart.js`

### Backend Files Modified
- `CAPSTONE/backend/src/routes/index.js` - Added cart routes

### Frontend Files Created
- `CAPSTONE/frontend/src/context/CartContext.jsx`
- `CAPSTONE/frontend/src/student/hooks/cart/useCart.js`
- `CAPSTONE/frontend/src/student/pages/MyCart.jsx`

### Frontend Files Modified
- `CAPSTONE/frontend/src/App.jsx` - Added CartProvider and cart route
- `CAPSTONE/frontend/src/services/api.js` - Added cartAPI methods
- `CAPSTONE/frontend/src/student/hooks/index.js` - Exported useCart hook
- `CAPSTONE/frontend/src/student/index.jsx` - Exported MyCart page
- `CAPSTONE/frontend/src/student/components/common/Navbar.jsx` - Added cart icon with badge
- `CAPSTONE/frontend/src/student/pages/ProductDetailsPage.jsx` - Integrated cart functionality

---

## Notes

- All cart items are stored in the database for persistence
- Cart is user-specific and secured with RLS policies
- No pricing is displayed to students (uniforms are free)
- Cart badge shows item count, not total quantity
- Edit mode allows bulk operations (select multiple, remove)
- Responsive design ensures usability on all devices
- Toast notifications provide user feedback
- Empty cart state encourages browsing products

---

## Support

For issues or questions, contact the development team or refer to the main project documentation.

