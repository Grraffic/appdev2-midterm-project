# My Cart Feature - Setup and Testing Guide

## Quick Setup

### Step 1: Database Setup

1. Open Supabase SQL Editor
2. Navigate to your project dashboard
3. Go to SQL Editor
4. Run the cart schema:
   ```sql
   -- Copy and paste the entire contents of:
   -- CAPSTONE/backend/src/db/cart.sql
   ```
5. Verify the table was created:
   ```sql
   SELECT * FROM cart_items LIMIT 1;
   ```

### Step 2: Backend Setup

1. Ensure backend is running:
   ```bash
   cd CAPSTONE/backend
   npm start
   ```

2. Verify cart routes are loaded:
   - Check console for "Server running on port 5000"
   - Cart routes should be available at `/api/cart`

### Step 3: Frontend Setup

1. Ensure frontend is running:
   ```bash
   cd CAPSTONE/frontend
   npm run dev
   ```

2. Open browser to `http://localhost:5173`

---

## Testing Checklist

### ✅ Test 1: Add Item to Cart

1. **Login as Student**
   - Use email ending with `@student.laverdad.edu.ph`

2. **Navigate to All Products**
   - Click "All Products" in navigation
   - Browse available items

3. **Select a Product**
   - Click on any product card
   - You'll be taken to Product Details page

4. **Add to Cart**
   - Select a size (if required)
   - Adjust quantity if needed
   - Click "Add to Cart" button
   - ✅ Success toast should appear
   - ✅ Cart badge in navbar should show count

### ✅ Test 2: View Cart

1. **Click Cart Icon**
   - Click the shopping cart icon in navbar
   - ✅ Should navigate to `/student/cart`

2. **Verify Cart Display**
   - ✅ Page title shows "MyCart" (blue + orange)
   - ✅ Item count displays correctly
   - ✅ Product image loads
   - ✅ Product name and education level shown
   - ✅ Size displays correctly
   - ✅ Quantity displays correctly
   - ✅ Price shows "Free"

### ✅ Test 3: Edit Mode

1. **Enter Edit Mode**
   - Click "Edit" button in top right
   - ✅ Checkboxes appear next to items
   - ✅ Quantity controls (+/-) appear
   - ✅ "Select All" button appears

2. **Update Quantity**
   - Click + button to increase quantity
   - ✅ Quantity updates immediately
   - ✅ Cart badge updates
   - Click - button to decrease quantity
   - ✅ Quantity decreases (minimum 1)

3. **Select Items**
   - Check one or more items
   - ✅ "Remove (X)" button appears
   - Click "Select All"
   - ✅ All items selected

4. **Remove Items**
   - Select items to remove
   - Click "Remove (X)" button
   - ✅ Items removed from cart
   - ✅ Success toast appears
   - ✅ Cart count updates

### ✅ Test 4: Empty Cart State

1. **Remove All Items**
   - Remove all items from cart
   - ✅ Empty cart message displays
   - ✅ Shopping cart icon shown
   - ✅ "Browse Products" button appears

2. **Return to Products**
   - Click "Browse Products"
   - ✅ Navigates to All Products page

### ✅ Test 5: Responsive Design

1. **Desktop View (> 1024px)**
   - ✅ Table layout displays
   - ✅ All columns visible
   - ✅ Hover effects work

2. **Tablet View (768px - 1024px)**
   - Resize browser window
   - ✅ Layout adapts
   - ✅ Touch targets appropriate

3. **Mobile View (< 768px)**
   - Resize to mobile width
   - ✅ Card layout displays
   - ✅ Stacked information
   - ✅ Full-width buttons
   - ✅ Mobile menu shows cart with badge

### ✅ Test 6: Navigation

1. **Back Button**
   - On cart page, click "Back" button
   - ✅ Returns to All Products

2. **Cart Badge**
   - ✅ Badge shows correct count
   - ✅ Badge updates when items added/removed
   - ✅ Badge hidden when cart empty

3. **Toast Notifications**
   - Add item to cart
   - ✅ Success toast with "View Cart" link
   - Click "View Cart" in toast
   - ✅ Navigates to cart page

### ✅ Test 7: Multiple Items

1. **Add Multiple Different Items**
   - Add 3-4 different products
   - ✅ All items appear in cart
   - ✅ Each item has correct details

2. **Add Same Item Different Sizes**
   - Add same product in size M
   - Add same product in size L
   - ✅ Both appear as separate cart items

3. **Add Same Item Same Size**
   - Add product (size M, qty 1)
   - Add same product again (size M, qty 1)
   - ✅ Quantity increases to 2 (not duplicate entry)

---

## Common Issues and Solutions

### Issue: Cart badge not updating

**Solution**: 
- Check that CartProvider wraps the app in App.jsx
- Verify useCart hook is imported from context
- Check browser console for errors

### Issue: Items not appearing in cart

**Solution**:
- Verify database table exists (run cart.sql)
- Check backend console for errors
- Verify user_id is being passed correctly
- Check network tab for API responses

### Issue: "Add to Cart" button disabled

**Solution**:
- Ensure size is selected (for uniform items)
- Click "Confirm Size" button
- Check that item is not out of stock

### Issue: Cart page shows loading forever

**Solution**:
- Check backend is running
- Verify API endpoint `/api/cart/:userId` works
- Check browser console for errors
- Verify user is logged in

### Issue: Responsive layout not working

**Solution**:
- Clear browser cache
- Check Tailwind CSS is loaded
- Verify breakpoints in code
- Test in different browsers

---

## API Testing (Optional)

### Using Postman or cURL

1. **Get Cart Items**
   ```bash
   GET http://localhost:5000/api/cart/{userId}
   ```

2. **Add to Cart**
   ```bash
   POST http://localhost:5000/api/cart
   Content-Type: application/json

   {
     "userId": "user-uuid",
     "inventoryId": "inventory-uuid",
     "size": "M",
     "quantity": 1
   }
   ```

3. **Update Quantity**
   ```bash
   PUT http://localhost:5000/api/cart/{cartItemId}
   Content-Type: application/json

   {
     "userId": "user-uuid",
     "quantity": 2
   }
   ```

4. **Remove Item**
   ```bash
   DELETE http://localhost:5000/api/cart/{cartItemId}?userId={userId}
   ```

---

## Success Criteria

All tests should pass with:
- ✅ No console errors
- ✅ Smooth user experience
- ✅ Correct data display
- ✅ Responsive on all devices
- ✅ Proper error handling
- ✅ Toast notifications working

---

## Next Steps

After successful testing:

1. **Order Submission from Cart**
   - Implement order creation from cart items
   - Generate QR code for multiple items
   - Clear cart after order

2. **Stock Validation**
   - Check inventory before adding to cart
   - Show warnings for low stock
   - Prevent out-of-stock additions

3. **Performance Optimization**
   - Add loading skeletons
   - Implement optimistic updates
   - Cache cart data

---

## Support

If you encounter issues:
1. Check the console for error messages
2. Verify all files are saved
3. Restart backend and frontend servers
4. Clear browser cache
5. Refer to `MY_CART_IMPLEMENTATION.md` for detailed documentation

---

## Screenshots Reference

Expected UI elements:

**Cart Page Header:**
```
[Back]                                    [Edit]

              MyCart
           🛒 2 Items
```

**Desktop Table:**
```
| ☐ | Product              | Size | Quantity | Price |
|----|---------------------|------|----------|-------|
| ☐ | [img] Basic Uniform | M    | 1        | Free  |
|    | (Senior High)       |      |          |       |
```

**Mobile Card:**
```
┌─────────────────────────────────┐
│ ☐ [img] Basic Education Uniform│
│         (Senior High School)    │
│         Size: M        Free     │
│         Qty: 1                  │
└─────────────────────────────────┘
```

**Empty Cart:**
```
        🛒
   Your cart is empty
   
   Start adding items to your
   cart to see them here
   
   [Browse Products]
```

---

## Completion

Once all tests pass, mark the testing task as complete and proceed with any additional features or improvements.

Happy Testing! 🎉

