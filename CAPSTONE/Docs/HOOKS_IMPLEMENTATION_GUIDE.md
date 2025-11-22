# Custom Hooks Implementation Guide 🎣

## Quick Start

All 8 custom hooks have been created and are ready to use!

---

## 📁 Hooks Location

```
frontend/src/hooks/
├── useLogin.js                    ✅ Created
├── useLoginRedirect.js            ✅ Created
├── useDashboardData.js            ✅ Created
├── useOrderStatus.js              ✅ Created
├── useProductCategories.js        ✅ Created
├── useProductPagination.js        ✅ Created
├── useLoginForm.js                ✅ Created
├── useRoleSelection.js            ✅ Created
├── index.js                       ✅ Created (barrel export)
├── useScrollOnState.jsx           (existing)
└── useNavigateToSection.jsx       (existing)
```

---

## 🎯 Hook Usage Examples

### 1. useLogin - Google OAuth Login

**Purpose:** Handle Google login with loading and error states

**Usage:**
```javascript
import { useLogin } from '../hooks';

function LoginPage() {
  const { loading, error, handleGoogleLogin } = useLogin();

  return (
    <div>
      <button onClick={handleGoogleLogin} disabled={loading}>
        {loading ? 'Connecting...' : 'Login with Google'}
      </button>
      {error && <p className="error">{error}</p>}
    </div>
  );
}
```

**Returns:**
- `loading` (boolean) - Loading state
- `error` (string) - Error message
- `handleGoogleLogin()` - Login function
- `clearError()` - Clear error message

---

### 2. useLoginRedirect - Post-Login Redirect

**Purpose:** Redirect user to appropriate page after login

**Usage:**
```javascript
import { useLoginRedirect } from '../hooks';
import { useAuth } from '../context/AuthContext';

function LoginPage() {
  const { user } = useAuth();
  useLoginRedirect(user);

  return <div>Redirecting...</div>;
}
```

**Behavior:**
- Redirects students to `/product-categories`
- Redirects admins to `/admin`
- Respects previous page if available

---

### 3. useDashboardData - Fetch Dashboard Data

**Purpose:** Fetch and manage dashboard statistics and orders

**Usage:**
```javascript
import { useDashboardData } from '../hooks';

function StudentDashboard() {
  const { stats, recentOrders, notifications, loading, error } = useDashboardData();

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div>
      <p>Total Orders: {stats.totalOrders}</p>
      {recentOrders.map(order => (
        <div key={order.id}>{order.item}</div>
      ))}
    </div>
  );
}
```

**Returns:**
- `stats` - Order statistics
- `recentOrders` - List of recent orders
- `notifications` - List of notifications
- `loading` - Loading state
- `error` - Error message
- `refreshData()` - Refresh data function

---

### 4. useOrderStatus - Order Status Utilities

**Purpose:** Get status colors, icons, and labels

**Usage:**
```javascript
import { useOrderStatus } from '../hooks';

function OrderCard({ order }) {
  const { getStatusColor, getStatusIcon, getStatusLabel } = useOrderStatus();

  return (
    <div className={getStatusColor(order.status)}>
      {getStatusIcon(order.status)}
      <span>{getStatusLabel(order.status)}</span>
    </div>
  );
}
```

**Returns:**
- `getStatusColor(status)` - Tailwind classes
- `getStatusIcon(status)` - Icon component
- `getStatusLabel(status)` - Human-readable label
- `isActionable(status)` - Can user take action?
- `getNextStatus(status)` - Next status in flow

---

### 5. useProductCategories - Category Management

**Purpose:** Manage product categories and filtering

**Usage:**
```javascript
import { useProductCategories } from '../hooks';

function ProductPage() {
  const {
    categories,
    selectedCategory,
    selectCategory,
    getFilteredProducts,
  } = useProductCategories();

  const products = getFilteredProducts();

  return (
    <div>
      {categories.map(cat => (
        <button
          key={cat.title}
          onClick={() => selectCategory(cat.title)}
          className={selectedCategory === cat.title ? 'active' : ''}
        >
          {cat.title}
        </button>
      ))}
      {products.map(product => (
        <div key={product.id}>{product.title}</div>
      ))}
    </div>
  );
}
```

**Returns:**
- `categories` - All categories
- `selectedCategory` - Currently selected
- `selectCategory(title)` - Select category
- `getFilteredProducts()` - Filtered products
- `getSubcategories()` - Subcategories
- `hasSubcategories(title)` - Check for subs

---

### 6. useProductPagination - Pagination Logic

**Purpose:** Handle product pagination

**Usage:**
```javascript
import { useProductPagination } from '../hooks';

function ProductList({ products }) {
  const {
    paginatedItems,
    currentPage,
    totalPages,
    nextPage,
    prevPage,
    hasNextPage,
    hasPrevPage,
  } = useProductPagination(products, 6);

  return (
    <div>
      {paginatedItems.map(product => (
        <div key={product.id}>{product.title}</div>
      ))}
      <button onClick={prevPage} disabled={!hasPrevPage()}>
        Previous
      </button>
      <span>{currentPage} / {totalPages}</span>
      <button onClick={nextPage} disabled={!hasNextPage()}>
        Next
      </button>
    </div>
  );
}
```

**Returns:**
- `paginatedItems` - Items for current page
- `currentPage` - Current page number
- `totalPages` - Total pages
- `goToPage(n)` - Go to specific page
- `nextPage()` - Go to next page
- `prevPage()` - Go to previous page
- `hasNextPage()` - Check if next exists
- `hasPrevPage()` - Check if prev exists
- `getPageRange()` - "1-6 of 20" format
- `reset()` - Reset to page 1

---

### 7. useLoginForm - Form Handling

**Purpose:** Manage login form state and validation

**Usage:**
```javascript
import { useLoginForm } from '../hooks';

function LoginForm() {
  const { email, password, errors, handleChange, handleSubmit } =
    useLoginForm(async (formData) => {
      console.log('Submitting:', formData);
      // Call login API
    });

  return (
    <form onSubmit={handleSubmit}>
      <input
        name="email"
        value={email}
        onChange={handleChange}
        placeholder="Email"
      />
      {errors.email && <p>{errors.email}</p>}

      <input
        name="password"
        type="password"
        value={password}
        onChange={handleChange}
        placeholder="Password"
      />
      {errors.password && <p>{errors.password}</p>}

      <button type="submit">Login</button>
    </form>
  );
}
```

**Returns:**
- `email` - Email value
- `password` - Password value
- `rememberMe` - Remember me checkbox
- `errors` - Validation errors
- `isSubmitting` - Submission state
- `handleChange(e)` - Input change handler
- `handleSubmit(e)` - Form submit handler
- `resetForm()` - Reset form
- `setFormValues(data)` - Set form data

---

### 8. useRoleSelection - Role Management

**Purpose:** Manage user role selection

**Usage:**
```javascript
import { useRoleSelection } from '../hooks';

function RoleSelector() {
  const { role, selectRole, getCurrentRoleInfo, getAvailableRoles } =
    useRoleSelection();

  const roleInfo = getCurrentRoleInfo();

  return (
    <div>
      <p>Current Role: {role}</p>
      <p>Portal: {roleInfo.portal}</p>
      <p>Description: {roleInfo.description}</p>

      {getAvailableRoles().map(availableRole => (
        <button
          key={availableRole}
          onClick={() => selectRole(availableRole)}
          className={role === availableRole ? 'active' : ''}
        >
          {availableRole}
        </button>
      ))}
    </div>
  );
}
```

**Returns:**
- `role` - Selected role
- `selectRole(role)` - Select role
- `getRoleInfo(role)` - Get role info
- `getAvailableRoles()` - All roles
- `isRoleSelected(role)` - Check if selected
- `getCurrentRoleInfo()` - Current role info
- `resetRole()` - Reset to default
- `ROLES` - Role constants

---

## 🔄 Importing Hooks

### Option 1: Import from index (Recommended)
```javascript
import { useLogin, useDashboardData, useProductCategories } from '../hooks';
```

### Option 2: Import directly
```javascript
import { useLogin } from '../hooks/useLogin';
import { useDashboardData } from '../hooks/useDashboardData';
```

---

## ✅ Testing Hooks

### Test useLogin
```javascript
import { renderHook, act } from '@testing-library/react';
import { useLogin } from '../hooks/useLogin';

test('useLogin handles login', async () => {
  const { result } = renderHook(() => useLogin());

  expect(result.current.loading).toBe(false);
  expect(result.current.error).toBe(null);

  act(() => {
    result.current.handleGoogleLogin();
  });

  expect(result.current.loading).toBe(true);
});
```

---

## 🚀 Next Steps

1. **Test the components**
   - Run `npm run dev`
   - Verify all pages work
   - Check console for errors

2. **Write unit tests**
   - Test each hook independently
   - Mock dependencies
   - Verify return values

3. **Refactor more components**
   - Apply same pattern to other components
   - Extract more business logic

4. **Create service layer**
   - Move API calls to services
   - Use hooks to call services

---

## 📚 Documentation Files

- `SEPARATION_OF_CONCERNS_ANALYSIS.md` - Analysis of mixed concerns
- `REFACTORING_BEFORE_AFTER.md` - Before/after comparison
- `HOOKS_IMPLEMENTATION_GUIDE.md` - This file

---

**All hooks are ready to use! Start testing them now!** 🎉

