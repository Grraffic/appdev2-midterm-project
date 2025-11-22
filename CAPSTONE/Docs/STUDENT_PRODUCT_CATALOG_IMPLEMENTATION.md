# Student Product Catalog Implementation
## La Verdad Uniform Ordering System

This document explains the implementation of the student-facing product catalog page that displays available uniforms and items without pricing information.

---

## Overview

The `AllProducts.jsx` page has been completely refactored to:
1. **Use real inventory data** from the API instead of mock data
2. **Hide all pricing information** (uniforms are free for students)
3. **Display stock status** without showing exact quantities
4. **Provide read-only view** with no admin controls
5. **Maintain responsive design** across all devices

---

## Key Changes

### 1. Data Source Migration

**Before**: Used `useProducts` hook with mock data
```javascript
const { products, loading, error } = useProducts();
// Loaded from MOCK_PRODUCTS constant
```

**After**: Uses `useInventory` hook with real API data
```javascript
const { items, loading, error } = useInventory();
// Fetches from /api/inventory endpoint
```

### 2. Pricing Information Removed

**What was removed:**
- ❌ Price display on product cards
- ❌ Price in product details
- ❌ Any monetary values

**What was added:**
- ✅ "FREE for Students" badge on every item
- ✅ Prominent message: "All items are free for students"

### 3. Stock Status Display

**Stock Status Logic:**
```javascript
const getStockStatusDisplay = (item) => {
  const stock = item.stock || 0;
  
  if (stock === 0) {
    return {
      label: "Out of Stock",
      color: "text-red-600",
      bgColor: "bg-red-50",
      borderColor: "border-red-200",
    };
  } else if (stock < 20) {
    return {
      label: "Low Stock",
      color: "text-orange-600",
      bgColor: "bg-orange-50",
      borderColor: "border-orange-200",
    };
  } else {
    return {
      label: "Available",
      color: "text-green-600",
      bgColor: "bg-green-50",
      borderColor: "border-green-200",
    };
  }
};
```

**Status Badges:**
- 🔴 **Out of Stock** (stock = 0) - Red badge, button disabled
- 🟠 **Low Stock** (stock < 20) - Orange badge, button enabled
- 🟢 **Available** (stock >= 20) - Green badge, button enabled

**Note:** Exact stock quantities are NOT displayed to students

### 4. Filtering System

**Available Filters:**
1. **Search Bar**: Search by name, category, item type, education level, or description
2. **Education Level Dropdown**: Filter by education level (All, Elementary, Junior High, Senior High, etc.)
3. **Item Type Dropdown**: Filter by item type (All, Uniform, PE Uniform, Patches, etc.)

**Filter Logic:**
```javascript
const filteredItems = useMemo(() => {
  let filtered = items.filter((item) => item.isActive !== false);

  // Apply search filter
  if (searchQuery.trim()) {
    const query = searchQuery.toLowerCase();
    filtered = filtered.filter(
      (item) =>
        item.name?.toLowerCase().includes(query) ||
        item.category?.toLowerCase().includes(query) ||
        item.itemType?.toLowerCase().includes(query) ||
        item.educationLevel?.toLowerCase().includes(query) ||
        item.description?.toLowerCase().includes(query)
    );
  }

  // Apply education level filter
  if (selectedEducationLevel !== "All") {
    filtered = filtered.filter(
      (item) => item.educationLevel === selectedEducationLevel
    );
  }

  // Apply item type filter
  if (selectedItemType !== "All") {
    filtered = filtered.filter((item) => item.itemType === selectedItemType);
  }

  return filtered;
}, [items, searchQuery, selectedEducationLevel, selectedItemType]);
```

### 5. Product Card Design

**Each product card displays:**
- ✅ Item image (or placeholder icon)
- ✅ Stock status badge (Available/Low Stock/Out of Stock)
- ✅ Item name
- ✅ Education level
- ✅ Category
- ✅ Item type
- ✅ Description (truncated to 2 lines)
- ✅ "FREE for Students" badge
- ✅ "View Details" button (disabled if out of stock)

**What is NOT displayed:**
- ❌ Price
- ❌ Exact stock quantity
- ❌ Admin controls (edit, delete, adjust stock)
- ❌ QR code scanner

### 6. Pagination

**Settings:**
- 12 items per page
- Previous/Next buttons
- Page number buttons
- Auto-scroll to top on page change

**Pagination Controls:**
```javascript
const itemsPerPage = 12;
const totalPages = Math.ceil(filteredItems.length / itemsPerPage);
const paginatedItems = useMemo(() => {
  const startIndex = (currentPage - 1) * itemsPerPage;
  return filteredItems.slice(startIndex, startIndex + itemsPerPage);
}, [filteredItems, currentPage, itemsPerPage]);
```

---

## Component Structure

### File Location
`CAPSTONE/frontend/src/student/pages/AllProducts.jsx`

### Dependencies
```javascript
import React, { useState, useMemo } from "react";
import { Search, Package, AlertCircle } from "lucide-react";
import Navbar from "../components/Navbar";
import HeroSection from "../components/HeroSection";
import Footer from "../components/Footer";
import { useInventory } from "../../hooks/useInventory";
```

### State Management
```javascript
const [searchQuery, setSearchQuery] = useState("");
const [selectedEducationLevel, setSelectedEducationLevel] = useState("All");
const [selectedItemType, setSelectedItemType] = useState("All");
const [currentPage, setCurrentPage] = useState(1);
```

### Data Fetching
```javascript
const {
  items,              // All inventory items
  loading,            // Loading state
  error,              // Error state
} = useInventory();
```

---

## User Interface

### Layout Structure

```
┌─────────────────────────────────────────┐
│           Navbar (Fixed Top)            │
├─────────────────────────────────────────┤
│           Hero Section                  │
├─────────────────────────────────────────┤
│  ┌───────────────────────────────────┐  │
│  │  Product Catalog (White Card)     │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Title & Filters            │  │  │
│  │  │  - Search Bar               │  │  │
│  │  │  - Education Level Dropdown │  │  │
│  │  │  - Item Type Dropdown       │  │  │
│  │  └─────────────────────────────┘  │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Product Grid (4 columns)   │  │  │
│  │  │  ┌───┐ ┌───┐ ┌───┐ ┌───┐   │  │  │
│  │  │  │ 1 │ │ 2 │ │ 3 │ │ 4 │   │  │  │
│  │  │  └───┘ └───┘ └───┘ └───┘   │  │  │
│  │  │  ┌───┐ ┌───┐ ┌───┐ ┌───┐   │  │  │
│  │  │  │ 5 │ │ 6 │ │ 7 │ │ 8 │   │  │  │
│  │  │  └───┘ └───┘ └───┘ └───┘   │  │  │
│  │  └─────────────────────────────┘  │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  Pagination Controls        │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
├─────────────────────────────────────────┤
│              Footer                     │
└─────────────────────────────────────────┘
```

### Responsive Breakpoints

- **Mobile** (< 640px): 1 column grid
- **Tablet** (640px - 1024px): 2 columns grid
- **Desktop** (1024px - 1280px): 3 columns grid
- **Large Desktop** (>= 1280px): 4 columns grid

---

## Features Comparison

### Admin Inventory Page vs Student Product Catalog

| Feature | Admin Inventory | Student Catalog |
|---------|----------------|-----------------|
| View Items | ✅ | ✅ |
| Search Items | ✅ | ✅ |
| Filter by Education Level | ✅ | ✅ |
| Filter by Item Type | ✅ | ✅ |
| See Stock Status | ✅ (with exact numbers) | ✅ (Available/Low/Out only) |
| See Prices | ✅ | ❌ |
| Add Items | ✅ | ❌ |
| Edit Items | ✅ | ❌ |
| Delete Items | ✅ | ❌ |
| Adjust Stock | ✅ | ❌ |
| QR Code Scanner | ✅ | ❌ |
| Statistics Cards | ✅ | ❌ |

---

## Testing

### Test Cases

1. **Data Loading**
   - ✅ Page loads inventory from API
   - ✅ Loading spinner displays while fetching
   - ✅ Error message displays if API fails

2. **Search Functionality**
   - ✅ Search by item name
   - ✅ Search by category
   - ✅ Search by education level
   - ✅ Search by item type
   - ✅ Search by description
   - ✅ Results update in real-time

3. **Filtering**
   - ✅ Filter by education level
   - ✅ Filter by item type
   - ✅ Combine search with filters
   - ✅ Reset to page 1 when filters change

4. **Stock Status Display**
   - ✅ "Out of Stock" badge for stock = 0
   - ✅ "Low Stock" badge for stock < 20
   - ✅ "Available" badge for stock >= 20
   - ✅ Button disabled when out of stock

5. **Pricing Hidden**
   - ✅ No price displayed on cards
   - ✅ "FREE for Students" badge visible
   - ✅ Message: "All items are free for students"

6. **Pagination**
   - ✅ 12 items per page
   - ✅ Previous/Next buttons work
   - ✅ Page numbers clickable
   - ✅ Buttons disabled at boundaries
   - ✅ Auto-scroll to top on page change

7. **Responsive Design**
   - ✅ Mobile: 1 column layout
   - ✅ Tablet: 2 columns layout
   - ✅ Desktop: 3-4 columns layout
   - ✅ Filters stack on mobile

---

## Usage Example

### Accessing the Page

Students can access the product catalog by navigating to:
```
/student/all-products
```

### User Flow

1. **Student lands on page**
   - Sees hero section with welcome message
   - Views product catalog below

2. **Student searches for item**
   - Types "uniform" in search bar
   - Results filter in real-time

3. **Student filters by education level**
   - Selects "Senior High School" from dropdown
   - Only Senior High items displayed

4. **Student views item details**
   - Clicks "View Details" button
   - Sees item information (currently shows alert, TODO: implement modal)

5. **Student sees stock status**
   - Green badge: Item is available
   - Orange badge: Low stock (act fast!)
   - Red badge: Out of stock (button disabled)

---

## Future Enhancements

### Planned Features

1. **Product Detail Modal**
   - Full item description
   - Multiple images
   - Size chart
   - Material information
   - Care instructions

2. **Order/Request System**
   - "Request Item" button
   - Add to cart functionality
   - Submit order with QR code generation

3. **Favorites/Wishlist**
   - Save items for later
   - Get notified when back in stock

4. **Image Gallery**
   - Multiple product images
   - Zoom functionality
   - 360° view

5. **Availability Notifications**
   - Email alerts when out-of-stock items return
   - Low stock warnings

---

## Integration with Existing System

### API Endpoint Used
```
GET /api/inventory
```

### Data Flow
```
API (/api/inventory)
  ↓
useInventory Hook
  ↓
AllProducts Component
  ↓
Product Cards (No Prices)
```

### Shared Components
- `Navbar` - Student navigation
- `HeroSection` - Welcome banner
- `Footer` - Site footer
- `useInventory` - Inventory data hook (shared with admin)

---

## Summary

The student product catalog page successfully:
- ✅ Displays real inventory data from the API
- ✅ Hides all pricing information
- ✅ Shows stock status without exact quantities
- ✅ Provides search and filtering capabilities
- ✅ Maintains responsive design
- ✅ Emphasizes that items are free for students
- ✅ Prevents access to admin controls

This implementation ensures students can browse available items while maintaining the appropriate level of information visibility for their role.

