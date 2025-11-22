# Dynamic Inventory Status Implementation

## Overview

This document describes the implementation of dynamic inventory status calculation in the La Verdad Uniform Ordering System. The status is now automatically calculated by the backend based on stock levels, ensuring consistency across the application.

---

## Business Rules

### Inventory Status Thresholds

| Status               | Stock Range | Color  | Description                                      | Displayed in Stats           |
| -------------------- | ----------- | ------ | ------------------------------------------------ | ---------------------------- |
| **Out of Stock**     | stock = 0   | Red    | No items available                               | No (tracked in backend only) |
| **Critical**         | stock 1-14  | Orange | Critically low stock, immediate attention needed | Yes                          |
| **At Reorder Point** | stock 15-49 | Yellow | Stock approaching reorder threshold              | Yes                          |
| **Above Threshold**  | stock >= 50 | Green  | Healthy stock levels                             | Yes                          |

**Note:** "Out of Stock" status is calculated and stored in the database but is NOT displayed as a separate card in the inventory statistics UI. The stats cards show only: Total Items, Above Threshold, At Reorder Point, and Critical (4 cards total).

---

## Backend Implementation

### 1. Database Trigger Function

**File:** `backend/src/db/inventory.sql`

The `update_inventory_status()` trigger function automatically calculates and sets the status field whenever an inventory item is inserted or updated:

```sql
CREATE OR REPLACE FUNCTION update_inventory_status()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.stock = 0 THEN
    NEW.status = 'Out of Stock';
  ELSIF NEW.stock >= 1 AND NEW.stock <= 14 THEN
    NEW.status = 'Critical';
  ELSIF NEW.stock >= 15 AND NEW.stock <= 49 THEN
    NEW.status = 'At Reorder Point';
  ELSIF NEW.stock >= 50 THEN
    NEW.status = 'Above Threshold';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

**Trigger:**

```sql
CREATE TRIGGER trigger_update_inventory_status
  BEFORE INSERT OR UPDATE OF stock ON inventory
  FOR EACH ROW
  EXECUTE FUNCTION update_inventory_status();
```

### 2. Helper Functions

#### get_low_stock_items()

Returns items with "Critical" or "At Reorder Point" status:

```sql
CREATE OR REPLACE FUNCTION get_low_stock_items()
RETURNS TABLE (
  id UUID,
  name TEXT,
  education_level TEXT,
  category TEXT,
  stock INTEGER,
  available INTEGER,
  reorder_point INTEGER,
  status TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    i.id, i.name, i.education_level, i.category,
    i.stock, i.available, i.reorder_point, i.status
  FROM inventory i
  WHERE i.is_active = true
    AND (i.status = 'Critical' OR i.status = 'At Reorder Point')
  ORDER BY i.stock ASC;
END;
$$ LANGUAGE plpgsql;
```

#### get_inventory_stats()

Returns statistics for each status category:

```sql
CREATE OR REPLACE FUNCTION get_inventory_stats()
RETURNS TABLE (
  total_items BIGINT,
  above_threshold_items BIGINT,
  at_reorder_point_items BIGINT,
  critical_items BIGINT,
  out_of_stock_items BIGINT,
  total_value NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    COUNT(*) as total_items,
    COUNT(*) FILTER (WHERE status = 'Above Threshold') as above_threshold_items,
    COUNT(*) FILTER (WHERE status = 'At Reorder Point') as at_reorder_point_items,
    COUNT(*) FILTER (WHERE status = 'Critical') as critical_items,
    COUNT(*) FILTER (WHERE status = 'Out of Stock') as out_of_stock_items,
    SUM(price * stock) as total_value
  FROM inventory
  WHERE is_active = true;
END;
$$ LANGUAGE plpgsql;
```

### 3. Service Layer

**File:** `backend/src/services/inventory.service.js`

Updated `getInventoryStats()` method to return new status categories:

```javascript
async getInventoryStats() {
  const { data, error } = await supabase.rpc("get_inventory_stats");

  return data[0] || {
    total_items: 0,
    above_threshold_items: 0,
    at_reorder_point_items: 0,
    critical_items: 0,
    out_of_stock_items: 0,
    total_value: 0,
  };
}
```

---

## Frontend Implementation

### 1. Components Updated

#### InventoryTable.jsx

- Updated `getStatusColor()` function to handle new status values
- Status is displayed as an **editable dropdown** with 4 options:
  - Above Threshold (green)
  - At Reorder Point (yellow)
  - Critical (orange)
  - Out of Stock (red)
- Dropdown allows manual status override if needed

```javascript
const getStatusColor = (status) => {
  switch (status) {
    case "Above Threshold":
      return "bg-green-100 text-green-800";
    case "At Reorder Point":
      return "bg-yellow-100 text-yellow-800";
    case "Critical":
      return "bg-orange-100 text-orange-800";
    case "Out of Stock":
      return "bg-red-100 text-red-800";
    default:
      return "bg-gray-100 text-gray-800";
  }
};
```

#### InventoryModals.jsx

- Updated status badge colors to match new status values
- Added "Critical" status with orange styling

#### InventoryStatsCards.jsx

- Updated to display **4 cards total**: 1 Total Items card + 3 status category cards
- Changed card titles and values to match displayed status categories:
  - Total Items
  - Above Threshold
  - At Reorder Point
  - Critical
- **Removed "Out of Stock" card** from display (status still tracked in backend)
- Updated grid layout to `lg:grid-cols-4`

### 2. Hooks Updated

#### useInventoryStats.js

Updated to calculate statistics based on new status values:

```javascript
export const useInventoryStats = (filteredItems) => {
  const stats = useMemo(() => {
    const totalItems = filteredItems.length;
    const aboveThreshold = filteredItems.filter(
      (item) => item.status === "Above Threshold"
    ).length;
    const atReorderPoint = filteredItems.filter(
      (item) => item.status === "At Reorder Point"
    ).length;
    const critical = filteredItems.filter(
      (item) => item.status === "Critical"
    ).length;
    const outOfStock = filteredItems.filter(
      (item) => item.status === "Out of Stock"
    ).length;

    return {
      totalItems,
      aboveThreshold,
      atReorderPoint,
      critical,
      outOfStock,
    };
  }, [filteredItems]);

  return stats;
};
```

#### useInventory.js

Updated `getStockStatus()` function to match backend logic (for client-side calculations if needed):

```javascript
const getStockStatus = useCallback((stock) => {
  if (stock === 0) return "Out of Stock";
  if (stock >= 1 && stock <= 14) return "Critical";
  if (stock >= 15 && stock <= 49) return "At Reorder Point";
  return "Above Threshold";
}, []);
```

---

## Migration

### Running the Migration

**File:** `backend/src/db/migrations/update_inventory_status_logic.sql`

To apply the changes to an existing database:

1. Connect to your Supabase database
2. Run the migration script:
   ```bash
   psql -h <host> -U <user> -d <database> -f backend/src/db/migrations/update_inventory_status_logic.sql
   ```

Or execute the SQL directly in the Supabase SQL Editor.

### Migration Steps

1. Updates the `update_inventory_status()` trigger function
2. Recreates the trigger to fire on `stock` changes
3. Updates `get_low_stock_items()` helper function
4. Updates `get_inventory_stats()` helper function
5. Migrates existing data to new status values
6. Provides verification query to check migration results

### Rollback

If you need to rollback to the old logic, uncomment and run the rollback section in the migration file.

---

## API Endpoints

All inventory API endpoints automatically return the calculated status:

- `GET /api/inventory` - Returns all items with status
- `GET /api/inventory/:id` - Returns single item with status
- `POST /api/inventory` - Creates item with auto-calculated status
- `PUT /api/inventory/:id` - Updates item with auto-calculated status
- `PATCH /api/inventory/:id/adjust` - Adjusts stock and updates status
- `GET /api/inventory/stats` - Returns statistics by status category
- `GET /api/inventory/low-stock` - Returns Critical and At Reorder Point items

---

## Testing

### Backend Testing

1. **Create Item Test:**

   ```bash
   POST /api/inventory
   {
     "name": "Test Item",
     "stock": 25,
     ...
   }
   # Expected: status = "At Reorder Point"
   ```

2. **Update Stock Test:**

   ```bash
   PUT /api/inventory/:id
   {
     "stock": 5
   }
   # Expected: status = "Critical"
   ```

3. **Adjust Stock Test:**
   ```bash
   PATCH /api/inventory/:id/adjust
   {
     "adjustment": -20
   }
   # Expected: status updates based on new stock level
   ```

### Frontend Testing

1. Navigate to Inventory page
2. Verify stats cards display 5 categories
3. Create/update items and verify status badges update correctly
4. Check that status colors match the defined thresholds

---

## Benefits

1. **Consistency:** Status is calculated in one place (database trigger)
2. **Automatic:** No manual status updates needed
3. **Real-time:** Status updates immediately when stock changes
4. **Reliable:** Database-level enforcement ensures data integrity
5. **Maintainable:** Single source of truth for status logic

---

## Notes

- Status field is now **read-only** in the frontend
- Status is **automatically calculated** by the backend
- Frontend displays the status value returned by the API
- No client-side status calculation is needed (except for display purposes)
- The `stock` field is the source of truth for status calculation

---

## Future Enhancements

Potential improvements to consider:

1. Add configurable thresholds per item category
2. Implement status change notifications
3. Add status history tracking
4. Create dashboard alerts for critical items
5. Add bulk status reports and exports
